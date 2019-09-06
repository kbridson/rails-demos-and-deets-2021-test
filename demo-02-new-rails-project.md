---
layout: page
title: 'Demo 2: Setting Up a New Rails Project'
permalink: /demo-02-new-rails-project/
---

# Demo 2: Setting Up a New Rails Project

In this demonstration, I will show you how to create and setup a new Rails 6 project. The application I will create in these tutorials is QuizMe, a quizzing application similar to [Quizlet](https://quizlet.com/), but with multiple choice and fill in the blank questions.

This and all future demos will assume you are starting in the `workspace` folder on your Linux VM.

## 1. Creating a New Rails Project

1. Set up RVM to use Ruby version 2.6.3 as the default version by running the following command:

    ```bash
    rvm use ruby-2.6.3 --default
    ```

    You can check that this has worked correctly by running the following command:
  
    ```bash
    rvm list
    ```
  
    Verify that `=*` appears next to version 2.6.3, indicating that it is both the current and default version of Ruby.

1. Install the Rails 6 gem using the following command:

    ```bash
    gem install rails
    ```

    Verify that the correct version was installed by running the following command:

    ```bash
    rails -v
    ```

    Verify that the output is `Rails 6.0.0`.

1. Create a new Rails project backed by a PostgreSQL database by entering the following command:

    ```bash
    rails new quiz-me --database=postgresql --skip-coffee
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-3a" role="button" aria-expanded="false" aria-controls="moreDetails1-3a">More details about this command...</a></small></span>

    <div class="collapse" id="moreDetails1-3a">
    <p class="text-muted mr-3 ml-3">
    By Rails convention the name of the project should be the name of the app in lowercase with words separated by dashes. SQLite is the default database for Rails Applications so the <code>--database</code> option is required to use PostgreSQL. Rails applications also default to automatically creating Coffeescript files, but the <code>--skip-coffee</code> option specifies plain Javascript files should be created instead.
    </p>
    </div>

    This command will take a while to complete and run several intermediate commands to complete the process.
    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-3b" role="button" aria-expanded="false" aria-controls="moreDetails1-3b">More details...</a></small></span>

    <div class="collapse" id="moreDetails1-3b">
    <p class="text-muted mr-3 ml-3">
    The project directory files are created first. Then, new gems are installed by running <code>bundle install</code>. Beware, some gems can take a long time to install (nokogiri, pg), but this is normal. One of the gems installed is webpacker which allows the app to serve all the project's JavaScript files in one large file, but it requires some installation setup which is the next thing to run as <code>rails webpacker:install</code>. Last the node packages will be installed by running <code>yarn install</code>. Many packages and their dependencies should be added. There will likely be a few dependency warnings which will later be resolved, but there should be no symlink errors.
    </p>
    </div>

1. Open the `quiz-me` project folder in VS Code and familiarize yourself with the directory structure.

1. Change directory into the `quiz-me` folder (`cd quiz-me`), and create a new project-specific gemset by running the following command:

    ```bash
    rvm use ruby-2.6.3@quiz-me --ruby-version --create
    ```

    This command will create two files, `.ruby-gemset` and `.ruby-version`, if they do not already exist to store the Ruby version and gemset information for RVM.

1. Open the file `Gemfile` in the top level of the `quiz-me` folder. This file declares all the gems required for the project. Another package is needed to ensure that PosgreSQL works correctly as the project's database backend. To add the package insert the following code lines at the end of the file:

    ```ruby
    # Disconnects all connections to PostgreSQL db when running rails db:reset
    gem 'pgreset', '~> 0.1.1'
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-6" role="button" aria-expanded="false" aria-controls="moreDetails1-6">More details...</a></small></span>

    <div class="collapse" id="moreDetails1-6">
    <p class="text-muted mr-3 ml-3">
    Without the <code>pgreset</code> gem, you will get <code>PG::ObjectInUse</code> errors when attempting to drop the database while pgAdmin is running.
    </p>
    </div>

1. Install all the gems into the new gemset by running the following command:

    ```bash
    bundle install
    ```

## 2. Creating a PostgreSQL Database for the New Rails Project

1. Open the file `config/database.yml`. This file contains the connection information for the project's three PostgreSQL databases. Rails uses three environments (development, test, and production), each with their own separate databases.

1. Create the three PostgreSQL databases with the names specified in the `database.yml` file by running the following commands:

    ```bash
    sudo -i -u postgres psql -c "CREATE DATABASE quiz_me_development OWNER vagrant;"
    sudo -i -u postgres psql -c "CREATE DATABASE quiz_me_test OWNER vagrant;"
    sudo -i -u postgres psql -c "CREATE DATABASE quiz_me_production OWNER vagrant;"
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails2-2" role="button" aria-expanded="false" aria-controls="moreDetails2-2">More details...</a></small></span>

    <div class="collapse" id="moreDetails2-2">
    <p class="text-muted mr-3 ml-3">
    The above commands can be adapted for any project by following the below template and changing the values of the variable <code>PG_DB_ROOT</code> with the appropriate information for the project. The first two psql commands only need to be run once on a system:

    <code class="d-block pl-3 pr-3 bg-light">PG_USER="vagrant"</code>
    <code class="d-block pl-3 pr-3 bg-light">PG_PSWD="password1"</code>
    <code class="d-block pl-3 pr-3 bg-light">PG_DB_ROOT="default"</code>
    <code class="d-block pl-3 pr-3 bg-light">sudo -i -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PSWD';"</code>
    <code class="d-block pl-3 pr-3 bg-light">sudo -i -u postgres psql -c "ALTER USER $PG_USER WITH SUPERUSER CREATEDB;"</code>
    <code class="d-block pl-3 pr-3 bg-light">sudo -i -u postgres psql -c "CREATE DATABASE ${PG_DB_ROOT}_development OWNER $PG_USER;"</code>
    <code class="d-block pl-3 pr-3 bg-light">sudo -i -u postgres psql -c "CREATE DATABASE ${PG_DB_ROOT}_test OWNER $PG_USER;"</code>
    <code class="d-block pl-3 pr-3 bg-light">sudo -i -u postgres psql -c "CREATE DATABASE ${PG_DB_ROOT}_production OWNER $PG_USER;"</code>
    </p>
    </div>

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

1. Confirm the database configuration is correct by running the following commands:

    ```bash
    rails db:migrate
    rails db:reset
    ```
