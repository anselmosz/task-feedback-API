-- Banco de desenvolvimento - mas pode ser adaptado para produção

--* Criação do banco - se existir, ele remove do SGBD
DROP DATABASE IF EXISTS db_feedback_saas;

--* Cria o banco com padrão utf8 unicode
CREATE DATABASE db_feedback_saas
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE db_feedback_saas;

--* Cria a tabela de contas - representa cada cliente do SaaS - cada empresa que utiliza o SaaS
CREATE TABLE accounts (
  account_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  plan ENUM('free','pro','enterprise') DEFAULT 'free',
  is_active BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--* Criação da tabela de usduários - representa cada usuário pertencente a uma conta
CREATE TABLE users (
  user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL,

  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,

  role ENUM('admin','member') DEFAULT 'member',

  user_status ENUM('active', 'inactive') DEFAULT 'active',

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  must_change_password BOOLEAN DEFAULT true,
  login_attempts INT DEFAULT 0,
  last_login_at DATETIME NULL,
  locked_until DATETIME NULL,

  UNIQUE(email),

  FOREIGN KEY (account_id)
    REFERENCES accounts(account_id)
    ON DELETE CASCADE -- Se o usuário for removido, isso não irá afetar outros registros do banco
);

--* Criação da tabela de pesquisas - cada pesquisa pertence a uma conta
CREATE TABLE surveys (
  survey_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL,

  title VARCHAR(200) NOT NULL,
  description TEXT,

  is_active BOOLEAN DEFAULT TRUE,

  created_by BIGINT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (account_id)
    REFERENCES accounts(account_id)
    ON DELETE CASCADE,

  FOREIGN KEY (created_by)
    REFERENCES users(user_id)
    ON DELETE SET NULL
);

--* Criação da tabela de perguntas - cada pesquisa pode ter diversas perguntas
CREATE TABLE questions (
  question_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  survey_id BIGINT NOT NULL,

  question_text VARCHAR(500) NOT NULL,

  question_type ENUM(
    'nps',
    'rating',
    'multiple_choice',
    'text'
  ) NOT NULL,

  position INT NOT NULL,

  is_required BOOLEAN DEFAULT FALSE,

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (survey_id)
    REFERENCES surveys(survey_id)
    ON DELETE CASCADE
);

--* Criação da tabela de opções - usado para a pergunta de múltipla escolha
CREATE TABLE question_options (
  option_id BIGINT AUTO_INCREMENT PRIMARY KEY,

  question_id BIGINT NOT NULL,

  option_text VARCHAR(200) NOT NULL,

  position INT,

  FOREIGN KEY (question_id)
    REFERENCES questions(question_id)
    ON DELETE CASCADE
);

--* Criação da tabela de respostas - cada envio do formulário gera uma resposta
CREATE TABLE responses (
  response_id BIGINT AUTO_INCREMENT PRIMARY KEY,

  survey_id BIGINT NOT NULL,

  respondent_ip VARCHAR(50),
  respondent_user_agent TEXT,

  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (survey_id)
    REFERENCES surveys(survey_id)
    ON DELETE CASCADE
);

--* Criação da tabela de respostas de cada pergunta - cada pergunta respondida gera um registro
CREATE TABLE answers (
  answer_id BIGINT AUTO_INCREMENT PRIMARY KEY,

  response_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,

  answer_text TEXT,
  answer_number DECIMAL(10,2),
  option_id BIGINT,

  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (response_id)
    REFERENCES responses(response_id)
    ON DELETE CASCADE,

  FOREIGN KEY (question_id)
    REFERENCES questions(question_id)
    ON DELETE CASCADE,

  FOREIGN KEY (option_id)
    REFERENCES question_options(option_id)
    ON DELETE SET NULL
);

--* Criação de indices para melhorar a performance de consultas
CREATE INDEX idx_users_account
ON users(account_id);

CREATE INDEX idx_surveys_account
ON surveys(account_id);

CREATE INDEX idx_questions_survey
ON questions(survey_id);

CREATE INDEX idx_responses_survey
ON responses(survey_id);

CREATE INDEX idx_answers_response
ON answers(response_id);

