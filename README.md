# DiWi Ruby on Rails API

Project management can be found in [*Asana*](https://app.asana.com/0/1129363480968355/board)

## Setup
This is the start for all of our Ruby on Rails APIs.

1. Clone this into the directory of your choice by appending the folder name to your git clone command.

2. Add the `application.yml` file from Asana to the config folder. It is setup to be ignored in `.gitignore`.

3. Build the docker container and app with:

```
$ docker-compose build
```

4. Start the app on `localhost:3000` with:

```
$ docker-compose up -d && docker attach diwi_app_1
```

Attaching to container allows for debugging with pry. The `-d` flag is
optional and runs containers in the background.

5. Enter the app shell using:

```
$ docker-compose run app bash
```

6. Setup the databases:

```
# create database and run all migrations
$ rake db:setup

# add sample data (optional)
$ rake sample:all

```

## Development

### Docker
This app is dockerized solely for development environment normalization. Docker
is not used for deployment to Heroku.

You can prefix commands with `docker-compose run app` to run them against the application
container. For example:

```
# build the container
$ docker-compose build

# start the app
$ docker-compose up

# runs the rails console
$ docker-compose run app rails console

# start the shell
$ docker-compose run app bash

```
You can run each command individually or alternatively open the shell where you can run the rails console,
rake commands, and testing from within it.

### Testing
To run the test suite you can use:

```
$ docker-compose run app rspec
```

Alternatively, open the shell (see above) and use bin/rspec to make test suite loading faster after the first time the suite is run.

```
$ bin/rspec spec
```

### Documentation
[Rwag](https://github.com/domaindrivendev/rswag) is used to generate documentation from our request specs.

In order to properly setup the documentation the ENV `SWAGGER_DOCUMENTATION` with the value `enabled` should be present in development and/or staging. Documentation should not be enabled in production.

After request specs are created/updated in the required format, the documentation can be updated with:

```
$ rake rswag:specs:swaggerize
```

To avoid duplicate schemas throughout the specs, a yml file can be added in `support/definitions`. Navigate to `/api-docs` to see the documentation in development or staging.

### Debugging with Pry and Docker
If you start the server and attach to the container in the same command you can automatically use `binding.pry`
for debugging.

To confirm the app container id you can used `docker ps`. You can attach separately if running docker commands
one by one.

```
$ docker attach diwi_app_1
```

### Workflow
* The `develop` branch is used for development, submit PR requests to this branch, not `master`.
* Staging will automatically pull latest updates from the `develop` branch.
* Deployments to production are performed via Heroku deploy button from `master` branch.

### Creating a CSV of Users
1. From Heroku, create a backup of the database and save it to your machine with the following:

```
heroku pg:backups:capture -a app-name-here
heroku pg:backups:download -a app-name-here
```

2. Move the `latest.dump` file to the root of your repo, and run the following in the terminal after the docker container has been created.

```
docker-compose exec -T postgres pg_restore --verbose --clean --no-acl --no-owner -U postgres -d APP_NAME_development < ./latest.dump
```

3. Run the task with `rake api_user_list_csv:run`. Save the CSV generated to another folder in your machine. Remove the latest.dump file, do not commit it.

