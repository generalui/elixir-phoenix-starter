# Elixir / Phoenix API

An API built in Elixir

## Status

### Main

The `main` branch should be merged from the `staging` branch after a successful promotion of the staging image to Prod.

## Table Of Contents

- [Status](#status)

- [Versioning](#versioning)

- [Developing Locally](#developing-locally)
  - [PostgreSQL](#postgresql)
  - [Dockerized](#dockerized)
  - [Non Dockerized](#non-dockerized)
    - [For Windows Users](#for-windows-users)
    - [Install Dependencies](#install-dependencies)
      - [Start the Phoenix Server First Time](#start-the-phoenix-server-first-time)
      - [Stop the Phoenix Server](#stop-the-phoenix-server)
      - [Restart the Phoenix Server](#restart-the-phoenix-server)
  - [Environment Variables](#environment-variables)
    - [Setting Defaults](#setting-defaults)
    - [Overriding Defaults](#overriding-defaults)
      - [Overrides](#overrides)
  - [Updating or Resetting the Database](#updating-or-resetting-the-database)
    - [Local Dev](#local-dev)
  - [Swagger Documentation](#swagger-documentation)
    - [Swagger UI](#swagger-ui)
  - [Code Base Documentation](#code-base-documentation)
  - [Formatting](#formatting)
  - [Linting](#linting)
  - [Running Tests](#running-tests)
    - [Test Coverage](#test-coverage)

- [Infrastructure](#infrastructure)

- [Deployment](#deployment)
  - [To Deploy to Production](#to-deploy-to-production)

- [Migrations](#migrations)

- [Notes](#notes)

## Versioning

The app uses [Version Tasks](https://hexdocs.pm/version_tasks/VersionTasks.html) to manage the app version. This should be used to increment the version with code changes.

Aliases have been created for incrementing the major, minor, and patch versions.

Upgrade the version number on the project and commit the changes files to the local git repository with:

```sh
mix <major|minor|patch>?>
```

## Developing Locally

Two things are needed for developing the API, or against the API, locally:

- A local PostgreSQL instance. See [PostgreSQL](#postgresql)
- The Phoenix server process. See [Dockerized](#dockerized) or [Non Dockerized](#non-dockerized)

### PostgreSQL

The easiest way to get PostgreSQL up and running is to use Docker. The application will handle seeding data into the database.

["postgres_docker"](https://github.com/generalui/postgres_docker) is an easy app to get a Postgres server up and running locally in a docker container. It also runs pgAdmin for convenience.

[https://github.com/generalui/postgres_docker](https://github.com/generalui/postgres_docker)

Follow the directions in the [README](https://github.com/generalui/postgres_docker/blob/master/README.md)

The password the application uses to access the database has to match what's been configured, which happens in the `config/dev.exs` file. The default values built into the app support the postgres_docker configuration out of the box.

In order to cleanly reset the database to a clean state, a `mix ecto.reset` can be run. Note that this will remove any data that's been added via the API but not put into the `priv/repo/seeds.exs` file or one of the data files it imports.

### Dockerized

The instructions below assume that there is a PostgreSQL server running locally and that Docker Compose (and Docker Engine) are installed locally. If this is not the case, please see:

- Information on [PostgreSQL in Docker](#postgresql) above.

  **Linux ONLY**

  If you are running on a Linux operating system the default connection to the docker container `host.docker.internal` will not work. To connect to the local dockerized PostgreSQL DB, ensure there is a `.env-dev` file and a `.env-test` file ([`.env-sample`](./.env-sample) can be used as a reference.) In the `.env-dev` and `.env-test` files, ensure the host value in the `DATABASE_URL` variable (and optionally the `DATABASE_URL_LEGACY` variable) is set to `172.17.0.1`

```.env
DATABASE_URL=postgres://postgres:docker@172.17.0.1/eps_dev
DATABASE_URL_LEGACY=postgres://postgres:docker@172.17.0.1/eps_dev_legacy
```

- [Docker Compose](https://docs.docker.com/compose/install/)

To change any of the environment variables used by the app see [Environment Variables](#environment-variables) below.

The first time you checkout the project, run the following command to build the docker image, start the container, and start the API:

```sh
./start.sh -setup
```

or

```sh
./start.sh -s
```

This will build the Docker image and run the container. Once the container is created, this will automatically run `mix ecto.setup` to setup the database and then will start the server.

The landing page should open automatically in your browser.

**Note:** If you get *'Version in "./docker-compose.yml" is unsupported.'*, please update your version of Docker Desktop.

**Optional:** If you choose to use VS Code, you may use the [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension to develop from within the container itself. Using this approach, you don't need to install Elixir, Erlang, or any dependencies (besides Docker and VS Code itself) as everything is already installed inside the container. There is a volume mapped to your user .ssh folder so that your ssh keys are available inside the container as well as your user .gitconfig file. The root user's folder inside the container is also mapped to a volume so that it persists between starts and stops of the container. This means you may create a `.bashrc`, and `.profile` or similar for yourself within the container and it will persist between container starts and stops. Additionally, the app's recommended extensions can safely be installed withing the container without effecting your host machine.

To start the container without auto starting the server, pass the `--no_auto_start` or `-n` flag like

```sh
./start.sh -no_auto_start
```

or

```sh
./start.sh -n
```

Once the container starts and the developer is in a VS Code instance within the container, start the Phoenix endpoint with `mix phx.server` or start the server in interactive mode with `iex -S mix phx.server` (preferred). *Essentially, treat the inside of the container as if operating in a non-dockerized setting running on Debian Linux.*

To reset the environment variables to the defaults, pass the `--reset_env` or `-r` flag. Remember, the values in the `.env-dev` file will still override defaults. To get back to absolute defaults, ensure there are no values set in the `.env-dev` file.

To explicitly rebuild the Docker image, pass the `--build` or `-b` flag.

An example of starting the container for the first time, resetting the environment variables, not auto starting the server, and explicitly building the Docker image all at once would be like:

```sh
./start.sh -s -r -n -b
```

The following command will stop the server and container:

```sh
./stop.sh
```

Restart the container with the following command (the above described flags may also be used):

```sh
./start.sh
```

If there are changes made to the container or image, first, stop the container `./stop.sh`, then rebuild it and restarted it with `./start.sh --build` or `./start.sh -b`.

### Non Dockerized

#### For Windows Users

It's highly recommended to put the code inside a WSL2 (Windows Subsystem for Linux) linux environment. The performance on windows is very poor compared to linux or IOS.

You can use the following [guide](https://docs.docker.com/docker-for-windows/wsl/) for how to use WSL2 with Docker Desktop.

Once you've configured and installed WSL2, you have to download and install Debian, which you can find in the windows store.

Install and configure git, clone the repo and you're good to go.

After that, you can proceed with installing the dependencies inside your new linux virtual machine.

#### Install Dependencies

The instructions below assume that there is a PostgreSQL server running locally and that Docker Compose (and Docker Engine) are installed locally. If this is not the case, please see:

- Information on [PostgreSQL in Docker](#postgresql) above.

- Install [`libsodium`](https://libsodium.gitbook.io/doc/installation) - required for [`:enacl`](https://github.com/jlouis/enacl)

- Install Elixir with Erlang/OTP - [See `.tool-versions`](./.tool-versions).

  - [MacOs / Linux](https://thinkingelixir.com/install-elixir-using-asdf/)
  - [Windows](https://elixir-lang.org/install.html)

  - Once installed, run `mix local.hex --force && mix local.rebar --force` to get [Hex](https://hexdocs.pm/mix/Mix.Tasks.Local.Hex.html) and [Rebar](https://hexdocs.pm/mix/master/Mix.Tasks.Local.Rebar.html) installed.

- Set the needed environment variables. See [Environment Variables](#environment-variables) below for more information.

##### Start the Phoenix Server First Time

- Install dependencies with `mix deps.get`.
- Create and migrate the database with `mix ecto.setup`.
- Start Phoenix endpoint with `mix dev`. This will create the swagger file and start the server in interactive mode.

##### Stop the Phoenix Server

- Stop the current server with `CTRL+C` (twice in a row).
  - The first time you hit `CTRL+C` will stop the server.
  - The second time you hit `CTRL+C` will exit the iex shell.

##### Restart the Phoenix Server

- Restart Phoenix endpoint with `mix phx.server` or restart the server in interactive mode with `iex -S mix phx.server` (preferred).

### Environment Variables

#### Setting Defaults

All the environment variables used by the app have defaults. All defaults are set in the `docker-compose.yml` file and additionally in the `set_env_variables.sh` script. (This is a little duplication, but allows more flexibility).

If running "Dockerized", simply start the server per the [Dockerized instructions above](#dockerized), the defaults are already set.

If running "Non Dockerized", use the `set_env_variables.sh` script to set the defaults.

From the root of the project run:

```sh
source set_env_variables.sh
```

#### Overriding Defaults

Whether "Dockerized" or "Non Dockerized", the default environment variables' values may be overridden by adding the value to a `.env-dev` file in the root of the project. This file is not versioned in the repository.

##### Overrides

Please note that the `.env-{environment}` filename may be appended with whichever environment the `MIX_ENV` is set to. `MIX_ENV` defaults to `dev`. When tests are run, `MIX_ENV` is set to `test`, thus, a `.env-test` file should be set to adjust environment variable values for tests. Again, the defaults are already set, the `.env-{environment}` files are for overrides.

The [`.env-sample`](./.env-sample) file is an example of what the `.env-{environment}` could be like and may be used as a reference.

The [`.env-none`](./.env-none) file is intentionally left blank and should not be used or altered.

To reset the needed environment variables back to the original defaults when "Dockerized", simply stop the container with `./stop.sh` and then restart the server with the `--reset_env` or `-r` flag:

```sh
./start.sh --reset_env
```

or

```sh
./start.sh -r
```

To reset the needed environment variables back to the original defaults when "Non Dockerized", stop the server with `CTRL+C`, `CTRL+C` (twice in a row) and run the following bash script from the root of the project:

```sh
source reset_env_variables.sh
```

Then restart the server following the instructions above.

**Remember**: Values set in the `.env-{environment}` file will still override the defaults even when resetting. To reset completely back to the original defaults, ensure no values are set in the `.env-{environment}` file.

### Updating or Resetting the Database

#### Local Dev

At times during development, changes may be introduced into the code that may effect the database (data, schema, etc) after the database has already been setup (see steps above). To ensure these changes are incorporated into your running server:

- Stop the current server with `CTRL+C` (twice in a row).
  - The first time you hit `CTRL+C` will stop the server.
  - The second time you hit `CTRL+C` will exit the iex shell.
- Reset the database with `mix ecto.reset`
  - This will run migrations and re-seed the database.
  - **NOTE:** any additional data added to the database AFTER it was setup will be lost (this is a reset).
- Restart the server (either directly with `mix phx.server` or in interactive mode with `iex -S mix phx.server`)

### Swagger Documentation

The app uses [PhoenixSwagger](https://hexdocs.pm/phoenix_swagger/getting-started.html) to create documentation for the API.

As API endpoints are added or updated, ensure that the Swagger info is updated as well.

After changes, run:

```sh
mix swagger
```

This will update the `priv/static/swagger.json` (not versioned).

For local development, view the generated documentation at: [http://localhost:4000/api/swagger](http://localhost:4000/api/swagger)

During deployment, the `mix swagger` command is run and the swagger.json is deployed with the app so that the Swagger UI may be made available. Currently, the Swagger UI is available in the develop and staging environments (NOT available in prod).

#### Swagger UI

For more information on how the Swagger UI works, see this useful video [https://www.youtube.com/watch?v=7MS1Z_1c5CU](https://www.youtube.com/watch?v=7MS1Z_1c5CU).

### Code Base Documentation

[ex_doc](https://hexdocs.pm/ex_doc/readme.html) is used to generate documentation for the code base.

The configuration for generating the documentation is in the `docs` section of [`mix.exs`](./mix.exs). See the [ex_doc config documentation](https://hexdocs.pm/ex_doc/Mix.Tasks.Docs.html).

During deployment, the `mix docs` command is run and the documentation is deployed with the app. Currently, the documentation is available in the develop and staging environments (NOT available in prod).

To generate the documentation locally run:

```sh
mix docs
```

Locally, the generated documentation should be available at [http:localhost:4000/docs/](http:localhost:4000/docs/)

### Formatting

To ensure the code base is formatted in a consistent fashion, run `mix format --check-formatted`. This will help ensure the code base is consistent and will help eliminate some merge request conflicts.

See [mix format](https://hexdocs.pm/mix/1.11.3/Mix.Tasks.Format.html) for more information.

Formatting options are defined in [`.formatter.exs`](./.formatter.exs)

### Linting

The app uses [Credo](https://hexdocs.pm/credo/overview.html) for linting.

Run `mix credo` to lint the app.

This will help ensure the code base is consistent and will help eliminate some merge request conflicts.

Configurations for Credo are defined in the [`.credo.exs`](./.credo.exs) file.

### Running Tests

**NOTE** When running inside a container, ensure that there is a `.env-test` file present in the root of the `/app` folder and that it has the `DATABASE_URL` variable set appropriately. The tests should run in their own database, like `eps_test`.

ie.

```.env-test
DATABASE_URL=postgres://postgres:docker@host.docker.internal/eps_test
```

To run all tests, call

```bash
mix tests
```

To run a specific test script, call

```bash
mix tests relative/path/to/the/script_test.exs
```

To run a specific test within a script, call

```bash
mix tests relative/path/to/the/script_test.exs:{line_number}
```

#### Test Coverage

The app uses [Coveralls](https://hexdocs.pm/excoveralls/readme.html) for test coverage.

Configurations for Coveralls are defined in the [`coveralls.json`](./coveralls.json) file.

To run test coverage, call

```bash
mix coverage.html
```

This will run all the tests and generate an html document located in the root of the project at `cover/excoveralls.html`. This html document will display what lines of which files are getting coverage and not.

Custom styles, functionality, and layout for the coverage report are found in the [`coveralls_template/`](./coveralls_template/) folder.

## Migrations

New migrations are run when the app is started using [EctoBootMigration](https://hexdocs.pm/ecto_boot_migration/EctoBootMigration.html).

To run rollback migrations and apply new migrations locally in development, see the information on [Ecto.Migration](https://hexdocs.pm/ecto_sql/Ecto.Migration.html) or simply reset the database with `mix ecto.reset`.

When running tests, the database is automatically reset and migrations run before the tests are run.

To handle rolling back migrations in the `develop`, `staging`, and `prod` environments, see the [AWS](#aws) section.

## Notes

There is some collected and useful information in the [`NOTES.md`](./NOTES.md) file.
