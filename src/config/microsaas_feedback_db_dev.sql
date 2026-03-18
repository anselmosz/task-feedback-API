-- Banco de desenvolvimento - mas pode ser adaptado para produção

--* Criação do banco - se existir, ele remove do SGBD
DROP DATABASE IF EXISTS db_feedback_saas_dev;

--* Cria o banco com padrão utf8 unicode
CREATE DATABASE db_feedback_saas_dev
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE db_feedback_saas_dev;

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

-- Consultas de exemplo para análises

-- Consulta o número de uma respsota de perguntas do tipo NPS
-- SELECT answer_number FROM answers JOIN questions ON questions.question_id = answers.question_id WHERE question_type = 'nps';

-- Consulta a média de avaliação
-- SELECT AVG(answer_number) FROM answers WHERE question_id = ?

-- Consulta para ver as respostas completas
-- SELECT s.title AS survey, q.question_text, a.answer_text, a.answer_number, qo.option_text FROM answers a JOIN questions q ON q.question_id = a.question_id JOIN responses r ON r.response_id = a.response_id JOIN surveys s ON s.survey_id = r.survey_id LEFT JOIN question_options qo ON qo.option_id = a.option_id;


-- INSERTS MANUAIS DE TESTE
-- Criação de uma conta com seu plano
INSERT INTO accounts (name, plan)
VALUES
('Empresa Exemplo LTDA', 'pro');

-- Criação de usuários associados a conta da empresa
INSERT INTO users (
  account_id,
  name,
  email,
  password_hash,
  role
)
VALUES
(1, 'Administrador', 'admin@empresa.com', 'hash_fake_123', 'admin'),
(1, 'Colaborador', 'user@empresa.com', 'hash_fake_456', 'member');

-- Criação de uma pesquisa de satisfação
INSERT INTO surveys (
  account_id,
  title,
  description,
  created_by
)
VALUES
(
  1,
  'Pesquisa de Satisfação - Maio',
  'Queremos saber como foi sua experiência com nosso serviço',
  1
);

-- Inserir perguntas em uma pesquisa
-- Pergunta NPS
INSERT INTO questions (
  survey_id,
  question_text,
  question_type,
  position,
  is_required
)
VALUES
(
  1,
  'De 0 a 10, o quanto você recomendaria nossa empresa?',
  'nps',
  1,
  TRUE
);

-- Pergunta de rating
INSERT INTO questions (
  survey_id,
  question_text,
  question_type,
  position,
  is_required
)
VALUES
(
  1,
  'Como você avalia a qualidade do atendimento?',
  'rating',
  2,
  TRUE
);

-- Pergunta de múltipla escolha
INSERT INTO questions (
  survey_id,
  question_text,
  question_type,
  position,
  is_required
)
VALUES
(
  1,
  'Qual foi o principal motivo da sua avaliação?',
  'multiple_choice',
  3,
  FALSE
);

-- Inserir opções da pergunta de múltipla escolha
INSERT INTO question_options (
  question_id,
  option_text,
  position
)
VALUES
(3, 'Preço', 1),
(3, 'Qualidade do produto', 2),
(3, 'Atendimento', 3),
(3, 'Tempo de entrega', 4);

-- Pergunta de texto livre
INSERT INTO questions (
  survey_id,
  question_text,
  question_type,
  position,
  is_required
)
VALUES
(
  1,
  'Deixe um comentário ou sugestão:',
  'text',
  4,
  FALSE
);

-- Simulação de um cliente respondendo
-- Geração de uma resposta enviada
INSERT INTO responses (
  survey_id,
  respondent_ip,
  respondent_user_agent
)
VALUES
(
  1,
  '192.168.0.10',
  'Mozilla/5.0 Chrome'
);


-- Simulação das respostas do usuário
-- Resposta da pergunta NPS
INSERT INTO answers (
  response_id,
  question_id,
  answer_number
)
VALUES
(
  1,
  1,
  9
);

-- Resposta da pergunta de rating
INSERT INTO answers (
  response_id,
  question_id,
  answer_number
)
VALUES
(
  1,
  2,
  4
);

-- Respsota da pergunta de múltipla escolha onde ele escolheu "Atendimento" (option_id = 3)
INSERT INTO answers (
  response_id,
  question_id,
  option_id
)
VALUES
(
  1,
  3,
  3
);

-- Resposta da pergunta de texto livre
INSERT INTO answers (
  response_id,
  question_id,
  answer_text
)
VALUES
(
  1,
  4,
  'Gostei muito do atendimento, mas a entrega demorou.'
);

-- Simulação de outra resposta
-- Novo envio
INSERT INTO responses (
  survey_id,
  respondent_ip,
  respondent_user_agent
)
VALUES
(
  1,
  '192.168.0.20',
  'Mozilla Firefox'
);

-- NPS
INSERT INTO answers (response_id, question_id, answer_number) 
VALUES (2, 1, 6);

-- Rating
INSERT INTO answers (response_id, question_id, answer_number)
VALUES (2, 2, 3);

-- Múltipla escolha
INSERT INTO answers (response_id, question_id, option_id)
VALUES (2, 3, 4);

-- Comentário
INSERT INTO answers (response_id, question_id, answer_text)
VALUES
(
  2,
  4,
  'Entrega demorou mais do que esperado.'
);

SELECT s.title AS survey, q.question_text, a.answer_text, a.answer_number, qo.option_text FROM answers a JOIN questions q ON q.question_id = a.question_id JOIN responses r ON r.response_id = a.response_id JOIN surveys s ON s.survey_id = r.survey_id LEFT JOIN question_options qo ON qo.option_id = a.option_id;