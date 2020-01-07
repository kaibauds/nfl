# Sortable and Queryable Web Report for Nfl Rushing Data

## Prerequisites for the installation on DEV host

1. Node.js

   Installation Guide: https://nodejs.org/en/download/

2. Erlang, Elixir

   Installation Guide: https://elixir-lang.org/install.html

3. inotify-tool

   Skip it for macOS or Windows
   For Linux:
   Installation Guide: https://github.com/rvoicilas/inotify-tools/wiki

4. Postgres

   **Method 1: Install Postgres on the DEV host** 

   Download & Installation: https://www.postgresql.org/download/

   Note: 
   If there's existing Postgres on the DEV host, and the password for database user `postgres`, then in the later steps, before running the Phoenix server, update the source code `config/dev.exs` and `config/test.exs` with the actual password.

   **Method 2: Install and run Postgres docker container on the DEV host**

   Alternatively, using Postgres docker container is highly recommended if the DEV host doesn't have existing Postgre
   * Fistly install `docker-ce` and `docker cli`: https://docs.docker.com/install/

   Run Postgres docker container in the following steps (`sudo` the command when the situation needs):
   * `docker pull postgres`
   * `docker volume create pg_db`
   * `docker run --rm --name pg_docker -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 -v pg_db:/var/lib/postgresql/data postgres`

## Run the server on the DEV host

1. Clone the souce code 

    `git clone https://github.com/kaibauds/nfl.git && cd nfl`

2. If needed

    Update the source file `config/dev.exs` and `config/test.exs` with the actual password for the database user `postgres`

3. Install dependencies

    `mix deps.get`

4. Create database and seed data

    `mix ecto.setup`

5. Install Node.js dependencies

    `cd assets && npm install && cd ..`

6. Start Phoenix server

    `mix phx.server`

## Access the service from web browser

   http://localhost:4000/ 