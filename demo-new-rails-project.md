---
title: 'Setting Up a New Rails Project'
---

# {{ page.title }}

In this demonstration, I will show you how to create and setup a new Rails 6 project. The application I will create in these tutorials is QuizMe, a quizzing application similar to [Quizlet](https://quizlet.com/).

This and all future demos will assume you are starting in the `workspace` directory.

## 1. Creating a New Rails Project

1. Check that RVM is set up to use the correct Ruby version by running the following command:

    ```bash
    rvm list
    ```
  
    The `=*` should appear next to version 2.6.5, indicating that it is both the current and default version of Ruby.

1. Create a new Rails project backed by a PostgreSQL database by entering the following command:

    ```bash
    rails new quiz-me --database=postgresql --skip-coffee
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-3a" role="button" aria-expanded="false" aria-controls="moreDetails1-3a">More details about this command...▼</a></small></span>

    <div class="collapse" id="moreDetails1-3a">
    <p class="text-muted mr-3 ml-3">
    By Rails convention the name of the project should be the name of the app in lowercase with words separated by dashes. SQLite is the default database for Rails Applications so the <code>--database</code> option is required to use PostgreSQL. Rails applications also default to automatically creating Coffeescript files, but the <code>--skip-coffee</code> option specifies plain Javascript files should be created instead.
    </p>
    </div>

    This command will take a while to complete and run several intermediate commands to complete the process.
    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-3b" role="button" aria-expanded="false" aria-controls="moreDetails1-3b">More details...▼</a></small></span>

    <div class="collapse" id="moreDetails1-3b">
    <p class="text-muted mr-3 ml-3">
    The project directory files are created first. Then, new gems are installed by running <code>bundle install</code>. Beware, some gems can take a long time to install (nokogiri, pg), but this is normal. One of the gems installed is webpacker which allows the app to serve all the project's JavaScript files in one large file, but it requires some installation setup which is the next thing to run as <code>rails webpacker:install</code>. Last the node packages will be installed by running <code>yarn install</code>. Many packages and their dependencies should be added. There will likely be a few dependency warnings which will later be resolved, but there should be no symlink errors.
    </p>
    </div>

1. Open the `quiz-me` project folder in VS Code (using the command `code quiz-me`) and familiarize yourself with the Rails project directory structure.

1. In the terminal, change directory into the `quiz-me` folder (`cd quiz-me`), and create a new project-specific gemset by running the following command:

    ```bash
    rvm use ruby-2.6.5@quiz-me --ruby-version --create
    ```

    This command will create two files, `.ruby-gemset` and `.ruby-version`, if they do not already exist to store the Ruby version and gemset information for RVM.

1. The previous command also creates a backup file that looks similar to this: `.ruby-version.01.22.2020-09:48:07`. This file should be removed, because the colons in the filename can cause problems on some OSs. To remove the file, run this command:

    ```bash
    rm ./.ruby-version.*
    ```

1. Open the file `Gemfile` in the top level of the `quiz-me` folder. This file declares all the gems required for the project. Another package is needed to ensure that PosgreSQL works correctly as the project's database backend. To add the package insert the following code lines at the end of the file:

    ```ruby
    # Disconnects all connections to PostgreSQL db when running rails db:reset
    gem 'pgreset', '~> 0.1.1'
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-6" role="button" aria-expanded="false" aria-controls="moreDetails1-6">More details...▼</a></small></span>

    <div class="collapse" id="moreDetails1-6">
    <p class="text-muted mr-3 ml-3">
    Without the <code>pgreset</code> gem, you will get <code>PG::ObjectInUse</code> errors when attempting to drop the database while pgAdmin is running.
    </p>
    </div>

1. Install all the gems into the new gemset by running the following command:

    ```bash
    bundle install
    ```

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/006d9aefca56a5ba121462c65be80f1eca1ab614)**

## 2. Configuring PostgreSQL Databases for the New Rails Project

1. Open the file `config/database.yml`. This file contains the connection information for the project's three PostgreSQL databases. Rails uses three environments (development, test, and production), each with their own separate databases.

1. Comment out the preset username and password on the production database to match the following:

    ```yaml
    production:
    <<: *default
    database: quiz_me_production
    # username: quiz_me
    # password: <%= ENV['QUIZ_ME_DATABASE_PASSWORD'] %>
    ```

1. Confirm the database configuration is correct by running the following commands:

    ```bash
    rails db:migrate:reset
    ```

    It should complete without errors. Possible issues might be the postgresql service is not running, or the Postgres user role was not set up correctly.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/1e756bcc643cdab0a104fd975e75a553ef5aefa4)**

## 3. Run the App

1. Start the development web server by running this command:

    ```bash
    rails s
    ```

1. Open the web app in a browser by opening this URL: <http://localhost:3000/>

    You should see a "Yay! You’re on Rails!" default page.

    The basic Rails project skeleton is now up and running!

1. To halt the development web server, enter Ctrl-C in the terminal.

{% include pagination.html prev_page='demo-run-app.md' next_page='demo-new-github-project.md' %}
