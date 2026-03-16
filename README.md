## 📌 Task Feedback API

Backend de um micro-SaaS para **coleta e análise de feedback de clientes** através de pesquisas personalizadas.

O sistema permite que empresas criem pesquisas, compartilhem formulários públicos e analisem as respostas coletadas através de métricas e dashboards.

Este projeto está sendo desenvolvido com foco em:

* arquitetura modular
* boas práticas de backend
* autenticação com JWT
* organização em camadas (Repository / Service / Controller)

Além de servir como **base para um produto SaaS**, o projeto também funciona como **projeto de estudo e portfólio backend**.

---

# 🎯 Objetivo do Sistema

Permitir que empresas:

* criem pesquisas de satisfação
* compartilhem formulários públicos com clientes
* coletem respostas
* analisem métricas como NPS e feedback qualitativo

---

# 🚀 Funcionalidades atuais

Atualmente o sistema possui os seguintes recursos implementados:

### Autenticação

* Registro de conta
* Criação automática de usuário administrador
* Login com geração de token JWT

### Gestão de usuários

* Criar usuários
* Listar usuários
* Buscar usuário por ID
* Atualizar usuário
* Remover usuário

### Segurança

* Autenticação via **JWT**
* Controle de permissões (admin / usuário)
* Isolamento de dados por **account_id**

---

# 🔧 Funcionalidades planejadas

Funcionalidades que serão adicionadas nas próximas etapas:

### Pesquisas

* Criar pesquisa
* Editar pesquisa
* Listar pesquisas
* Ativar / desativar pesquisa

### Perguntas

* Adicionar perguntas à pesquisa
* Editar perguntas
* Ordenar perguntas

### Respostas

* Gerar link público de formulário
* Receber respostas de clientes
* Armazenar respostas no banco

### Dashboard

* Número de respostas
* Média de avaliação
* Comentários de clientes
* Métricas básicas de satisfação

---

# 🏗 Arquitetura do projeto

O projeto segue uma arquitetura em camadas:

```
Controller
↓
Service
↓
Repository
↓
Database
```

### Responsabilidade de cada camada

**Controllers**

* recebem requisições HTTP
* validam dados da requisição
* retornam respostas

**Services**

* contêm a lógica de negócio
* coordenam operações entre repositories
* gerenciam transactions

**Repositories**

* responsáveis pelas queries no banco
* isolam acesso ao banco de dados

---

# 🧱 Estrutura de módulos

O sistema é organizado em módulos baseados no domínio da aplicação.

```
src
 ├ config
 ├ middlewares
 ├ modules
 │   ├ auth
 │   ├ users
 │   ├ surveys
 │   ├ questions
 │   └ responses
 │
 ├ services
 └ utils 
```

### auth

Responsável por:

* registro de contas
* autenticação
* geração de token JWT

### users

Responsável por:

* CRUD de usuários
* gerenciamento de permissões
* associação de usuários a contas

### surveys

Responsável por:

* criação de pesquisas
* edição de pesquisas
* ativação/desativação

### questions

Responsável por:

* gerenciamento de perguntas das pesquisas

### responses

Responsável por:

* registro das respostas enviadas pelos clientes

---

# ⚙ Tecnologias utilizadas

### Backend

* Node.js
* Express

### Banco de dados

* MySQL

### Query Builder

* Knex.js

### Autenticação

* JSON Web Token (JWT)
* bcrypt

### Outras ferramentas

* dotenv
* nodemon

---

# 🔌 Endpoints da API

## Auth

Responsável por autenticação e criação de contas.

| Método | Endpoint       | Descrição                           |
| ------ | -------------- | ----------------------------------- |
| POST   | /auth/register | Criar conta e usuário administrador |
| POST   | /auth/login    | Login e geração de token JWT        |

### Exemplo de dados para registro

```json
{
    "company": {
        "name": "Empresa exemplo",
        "plan": "pro"
    },
    "user": {
        "name": "Administrador",
        "email": "admin@empresa.com.br",
        "senha": "senha@1234"
    }
}
```

### Exemplo de dados para login

```json
{
    "email": "admin@empresa.com.br",
    "senha": "senha@1234"
}

```

---

# 👤 Users

Endpoints para gerenciamento de usuários.

⚠ Todas as rotas requerem **token JWT no header Authorization**

```
Authorization: Bearer TOKEN
```

| Método | Endpoint   | Descrição             |
| ------ | ---------- | --------------------- |
| GET    | /users     | Listar usuários       |
| GET    | /users/:id | Buscar usuário por ID |
| POST   | /users     | Criar novo usuário    |
| PUT    | /users/:id | Atualizar usuário     |
| DELETE | /users/:id | Remover usuário       |

---

# ▶ Como executar o projeto

### 1️⃣ Clonar o repositório

```
git clone <repo>
```

---

### 2️⃣ Instalar dependências

```
npm install
```

---

### 3️⃣ Configurar variáveis de ambiente

Crie um arquivo `.env` baseado no `.env.example`

```
NODE_ENV=development

DB_CLIENT=mysql2
DB_HOST=localhost
DB_PORT=3306
DB_NAME=database_name
DB_USER=user
DB_USER_PASSWORD=password

PORT=3000
JWT_SECRET=seu_secret
```

---

### 4️⃣ Executar o projeto

```
npm run dev
```

---

# 📌 Status do projeto

🚧 Em desenvolvimento

O projeto está em evolução e novas funcionalidades serão adicionadas gradualmente.
