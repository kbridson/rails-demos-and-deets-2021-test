---
layout: page
title: 'Demo 2: Setting Up a New Rails Project'
permalink: /demo-02-new-rails-project/
---

# Demo 2: Setting Up a New Rails Project

In this demonstration, I will show you how to create and setup a new Rails 6 project. The application I will create in these tutorials is QuizMe, a quizzing application similar to Quizlet but with multiple choice and fill in the blank questions.

This and all future demos will assume you are starting in the workspace folder on your virtual machine.

## 1. Create a New Project

1. Setup RVM to use ruby version 2.6.3 as the default version by running the command `rvm use ruby-2.6.3 --default`. You can check this has been done correctly by running the command `rvm list` and verifying `=*` appears next to the correct version.

1. Install the Rails 6 gem using the command `gem install rails`. You can verify the correct version was installed by running `rails -v` and verifying the output is `Rails 6.0.0`.

1. Create a new Rails project backed by a PostgreSQL database by entering the command `rails new quiz-me --database=postgresql --skip-coffee`.
    > _By Rails convention the name of the project should be the name of the app in lowercase with words separated by dashes. SQLite is the default database for Rails Applications so the `--database` option is required to use PostgreSQL. Rails applications also default to automatically creating Coffeescript files, but the `--skip-coffee` option specifies plain Javascript files should be created instead._

   This command will take a while to complete and run several intermediate commands to complete the process.

    > _The project directory files are created first. Then, new gems are installed by running `bundle install`. Beware, some gems can take a long time to install (nokogiri, pg), but this is normal. One of the gems installed is webpacker which allows the app to serve all the project's Javascript files in one large file, but it requires some installation setup which is the next thing to run as `rails webpacker:install`. Last the node packages will be installed by running `yarn install`. Many packages and their dependencies should be added. There will likely be a few dependency warnings which will later be resolved, but there should be no symlink errors._

1. Open the project folder in VS Code and familiarize yourself with the directory structure.

1. Change directory into the quiz-me folder (`cd quiz-me`) and create a new project-specific gemset by running the command `rvm use ruby-2.6.3@quiz-me --ruby-version --create`. This command will create two files, .ruby-gemset and .ruby-version, if they do not already exist to store the information for RVM.

1. Open the file `Gemfile` in the top level of the quiz-me folder. This file contains all the gems required for the project. Add the following code lines to the end of the file:

    ```ruby
    # Disconnects all connections to PostgreSQL db when running rails db:reset
    gem 'pgreset', '~> 0.1.1'
    ```

    > _Without the pgreset gem, you will get `PG::ObjectInUse` errors when attempting to drop the database while pgAdmin is running._

1. Run the command `bundle install` to install all the gems into the new gemset.

## 1. Creating a PostgreSQL Database for a New Rails Project

1. Open the project folder in VS Code and familiarize yourself with the directory structure.

1. Open the file `config/database.yml`. This file contains the connection information for the project's three PostgreSQL databases. Rails uses three environments (development, test and production), each with their own separate databases.

1. Create the three databases with the names specified in the database.yml file by running the following commands:

    ```Powershell
    sudo -i -u postgres psql -c "CREATE DATABASE quiz_me_development OWNER vagrant;"
    sudo -i -u postgres psql -c "CREATE DATABASE quiz_me_test OWNER vagrant;"
    sudo -i -u postgres psql -c "CREATE DATABASE quiz_me_production OWNER vagrant;"
    ```

    > _The above commands can be adapted for any project by following the below template and changing the values of the variable `PG_DB_ROOT` with the appropriate information for the project. The first two psql commands only need to be run once on a system:_  

    ```Powershell
    PG_USER="vagrant"
    PG_PSWD="password1"
    PG_DB_ROOT="default"

    sudo -i -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PSWD';"
    sudo -i -u postgres psql -c "ALTER USER $PG_USER WITH SUPERUSER CREATEDB;"
    sudo -i -u postgres psql -c "CREATE DATABASE ${PG_DB_ROOT}_development OWNER $PG_USER;"
    sudo -i -u postgres psql -c "CREATE DATABASE ${PG_DB_ROOT}_test OWNER $PG_USER;"
    sudo -i -u postgres psql -c "CREATE DATABASE ${PG_DB_ROOT}_production OWNER $PG_USER;"
    ```

1. Make the following changes to the database.yml file:
    - Add username and password to the default configuration to match the following:

      ```yaml
      default: &default
        adapter: postgresql
        encoding: unicode
        # For details on connection pooling, see Rails configuration guide
        # https://guides.rubyonrails.org/configuring.html#database-pooling
        pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
        username: vagrant
        password: password1
      ```

    - Comment out the preset username and password on the production database to match the following:

      ```yaml
      production:
        <<: *default
        database: default_production
        # username: quiz_maker
        # password: <%= ENV['QUIZ_MAKER_DATABASE_PASSWORD'] %>
      ```

1. Confirm the database configuration is correct by running the commands `rails db:migrate` and `rails db:reset`.
