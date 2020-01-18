---
title: 'Running a Rails App'
---

# {{ page.title }}

1. From your terminal application, create a folder `workspace` in your home directory by running:

    ```bash
    mkdir ~/workspace
    ```

    This folder is where all the Rails projects in these demos will go.

1. Change directory to your `workspace` folder by running:

    ```bash
    cd ~/workspace
    ```

1. Use Git to download an example project by running:

    ```bash
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
    export DB_PASSWORD=password1
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

        - Password: `password1`

        The user and password must match your Postgres and Ubuntu user.

    1. In the left sidebar, go navigate as follows:

        `Servers` > `SoftwareEng` > `Databases` > `default_development` > `Schemas` > `public` > `Tables`

        Right click on `quizzes` and go to `View/Edit Data` > `All Rows`.

        You should see the Data Output panel in the bottom right corner of the screen showing information about all the quizzes in the application.

1. Further test out the web app by logging in and creating a quiz:

    1. Follow the `Sign In` link at the top right and log in with the email `alice@email.com` and the password `password`.

    1. Click the `Create New Quiz` link and enter a title and description for a quiz.

    1. In your pgAdmin browser window, you can see the new quiz in the database by hitting the refresh button (F5 or the lightning bolt button).

    1. Add questions to the quiz by clicking to `Edit Quiz` link.
