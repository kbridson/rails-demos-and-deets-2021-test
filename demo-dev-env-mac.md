---
title: 'Setting Up the Development Environment (Mac users)'
---

# {{ page.title }}

In this demonstration, I will show you how to setup the development environment used in the rest of the demos.

## 1. Install Homebrew (if you have not already)

1. Open the Terminal application and run:

    ```console
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

    When it asks you to install XCode CommandLine Tools, say yes.

## 2. Install Additional Software

1. Install the _Visual Studio Code_ (VS Code) editor (<https://code.visualstudio.com/>). VS Code will be the code editor of choice for these demos. Use the latest stable version.

1. Additionally, within VS Code, install the following five extensions: (1) _Code Spell Checker_, (2) _Markdown PDF_, (3) _Markdown Preview Github Styling_, (4) _markdownlint_, and (5) _Simple Ruby ERB_.

1. Download and install _pgAdmin_ 4 (<https://www.pgadmin.org/download/>), a database viewer and administration tool for PostgreSQL databases. This application will allow you to view the database running on your VM from a web browser on your host.

    Confirm that the install was successful by launching the pgAdmin 4 app on your host OS. A pgAdmin page should open in your web browser.

    The first time you launch pgAdmin, you will be prompted to create a password. Don't forget it, because you will need it to run pgAdmin in the future!

## 3. Setup Github Account and Credentials

1. Register an account at <https://github.com/> (if you don't already have one). Git and GitHub will be used for version control and collaboration in these demos. Be sure not to lose your GitHub username and password.

1. Check that you have the git package installed by running:

    ```console
    git --version
    ```

1. Set your global Git configuration settings by creating a `.gitconfig` file by running:

    ```console
    vi ~/.gitconfig
    ```

    The contents of the file should look something like Figure x, containing your name, the email you used to register your Github account, and a couple other options that are quality of life improvements for this class. For example, mine is:

    ```ini
    # This is Git's per-user configuration file.
    [user]
            name = Katie Bridson
            email = kbridson@memphis.edu

    [core]
            autocrlf = false
    [color]
            ui = true
    ```

    Save the file (by hitting ESC and typing `:x` if using the Vim editor).

1. Setup SSH authentication with your Github account by generating a new SSH key with the following:

    ```console
    ssh-keygen -t rsa -b 4096 -C "kbridson@memphis.edu"
    ```

    Make sure to use the email associated with your Github account. Also, you should accept all the default options for that command by hitting ENTER without entering anything.

1. Add the key you just generated to your Github account by copying the output of the following command:

    ```console
    cat ~/.ssh/id_rsa.pub
    ```

    Then, go to `<https://github.com/settings/keys>` in your browser. Make sure you are logged into Github. Click the button "New SSH key", enter a title, and paste the output of the command in the key field. Click "Add SSH key".

1. Check the SSH key has been setup correctly by running:

    ```console
    ssh -T git@github.com
    ```

    You should get a message like:

    ```console
    Hi kbridson! You've successfully authenticated, but GitHub does not provide shell access.
    ```

## 4. Install Ruby and Rails

1. Install the Node.js and Yarn repositories by running each of the following commands:

    ```console
    brew install yarn
    ```

1. Install RVM by running each of the following commands:

    ```console
    brew install gnupg

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

    \curl -sSL https://get.rvm.io | bash -s stable --ruby

    source ~/.rvm/scripts/rvm
    ```

1. Install the latest version of Ruby by running each of the following commands:

    ```console
    rvm install 2.6.5
    rvm use 2.6.5 --default
    ruby -v
    ```

    If Ruby has successfully installed, the output of `ruby -v` should be something like:

    ```console
    ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]
    ```

1. Globally install the Bundler gem to manage project gemsets by running:

    ```console
    rvm @global do gem install bundler
    ```

1. Globally install Rails by running:

    ```console
    rvm @global do gem install rails
    ```

    If Rails has installed correctly, running `rails -v` should show version 6.0.2.1.

## 5. Install Postgres

1. Install the Postgres packages by running:

    ```console
    brew install postgresql
    ```

1. Start the Postgres service by running:

    ```console
    brew services start postgresql
    ```

## 7. Running a Rails App

1. From your terminal application, create a folder `workspace` in your home directory by running:

    ```console
    mkdir ~/workspace
    ```

    This folder is where all the Rails projects in these demos will go.

1. Change directory to your `workspace` folder by running:

    ```console
    cd ~/workspace
    ```

1. Use Git to download an example project by running:

    ```console
    git clone https://github.com/memphis-cs/rails-6-test-app.git
    ```

    Run the command `ll` to see a new `rails-6-test-app` folder should be visible inside the `workspace` folder.

1. Change directory (using the `cd` command) to the `rails-6-test-app` folder. When you run this command, RVM should print a message like the following, which lets you know it's working. Note that this message appears only after the _first_ time you `cd` into the project.

    ```text
    ruby-2.6.3 - #gemset created /home/vagrant/.rvm/gems/ruby-2.6.3@quiz-maker
    ruby-2.6.3 - #generating quiz-maker wrappers.........
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails3-5" role="button" aria-expanded="false" aria-controls="moreDetails3-5">Troubleshoot: no messages appear...▼</a></small></span>

    <div class="collapse" id="moreDetails3-5">
    <p class="text-muted mr-3 ml-3">
    If no messages from RVM appears, then something is wrong. A common problem is that the terminal application is not configured to run as a "login" shell. This issue seems to come up the most for Linux users, or users of more exotic terminal applications. Typically, the solution can be found in the terminal application's settings. Restarting the terminal application after fixing the setting will likely be necessary.
    </p>
    </div>

1. Download and install the gems (Ruby libraries) for this Rails project by entering the following command:

    ```bash
    bundle install
    ```

1. Download and install all the JavaScript dependencies for this Rails project by entering the following command:

    ```bash
    yarn install
    ```

1. Open the `rails-6-test-app` in VSCode by running the following command in the `rails-6-test-app` directory:

    ```bash
    code .
    ```

1. From VSCode, create a copy of the `.env.sample` file named `.env`. Edit the `.env` file to use your username and password. This will need to be set correctly for every Rails project you work on. This file should look something like:

    ```text
    export DB_USERNAME=kbridson
    export DB_PASSWORD=
    ```

1. Wipe and reset the database to be used by this Rails app by entering the following command:

    ```bash
    rails db:reset
    ```

1. The project comes with some automated tests. Run them by entering the following command:

    ```bash
    rails test
    ```

    You should see that all the tests passed.

1. Start up the Rails web app server by entering the following command (those are zeros):

    ```bash
    rails s -b 0.0.0.0
    ```

    You should see that the server has started without error. Note that this command will not "return" like other commands—that is, the command prompt will not reappear until you halt the server process (covered below).

1. Now open the URL <http://localhost:3000> in a web browser. You should see a "Welcome to Quiz Maker" web page with a list of quizzes.

1. Verify that the Postgres DBMS running on the server is accessible and that the app's database is configured as expected.

    1. Add a Server with the following configuration:

        - Name: `SoftwareEng`

        - Hostname/address: `localhost`

        - Port: `5432`

        - User: `kbridson`

        - Password: 

        The user and password must match your Postgres and Mac user.

    1. In the left sidebar, go navigate as follows:

        `Servers` > `SoftwareEng` > `Databases` > `default_development` > `Schemas` > `public` > `Tables`

        Right click on `quizzes` and go to `View/Edit Data` > `All Rows`.

        You should see the Data Output panel in the bottom right corner of the screen showing information about all the quizzes in the application.

1. Further test out the web app by logging in and creating a quiz:

    1. Follow the `Sign In` link at the top right and log in with the email `alice@email.com` and the password `password`.

    1. Click the `Create New Quiz` link and enter a title and description for a quiz.

    1. In your pgAdmin browser window, you can see the new quiz in the database by hitting the refresh button (F5 or the lightning bolt button).

    1. Add questions to the quiz by clicking to `Edit Quiz` link.
