---
title: 'Running a Rails App'
---
<style>
    .highlighter-rouge {
        white-space: nowrap;
    }

    th {
        white-space: nowrap;
    }

    table {
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid black;
        padding: 0.25rem 0.75rem;
    }
</style>

# {{ page.title }}

In this demo, I will show how to download, configure, and run an existing Rails web app hosted on GitHub ([Rails 6 Test App](https://github.com/human-se/rails-6-test-app-2020)). This demo will also serve as a good test of whether our development environment was set up correctly.

## 1. Downloading the Project

First, we will create a workspace for our Rails projects and download the test app.

1. Using your terminal application, create a folder `workspace` in your home directory by entering this command:

    ```bash
    mkdir ~/workspace
    ```

    This folder is where all our Rails projects will go.

1. Change directory to your `workspace` folder by entering this command:

    ```bash
    cd ~/workspace
    ```

1. Use Git to download the test-app project by entering this command:

    ```bash
    git clone https://github.com/human-se/rails-6-test-app-2020.git
    ```

1. Verify that the download was successful by entering the following command:

    ```bash
    ls -l
    ```

    You should see that a new `rails-6-test-app-2020` directory has been added to the `workspace` directory.

## 2. Installing Project Dependencies

Next, we will install the Ruby and JS package dependencies for the project.

1. Change the working directory to the `rails-6-test-app-2020` directory by entering this command:

    ```bash
    cd rails-6-test-app-2020
    ```

    When you run this command, RVM should print a message like the following, which lets you know it's working. Note that this message appears only after the _first_ time you `cd` into a new project.

    ```text
    ruby-2.6.5 - #gemset created /home/vagrant/.rvm/gems/ruby-2.6.5@quiz-maker
    ruby-2.6.5 - #generating quiz-maker wrappers.........
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

1. Download and install all the JS packages for this Rails project by entering the following command:

    ```bash
    yarn install
    ```

## 3. Setting Up the Database Backend

Next, we will initialize the database for the project.

1. Wipe and reset the database to be used by this Rails app by entering the following command:

    ```bash
    rails db:migrate:reset db:seed
    ```

## 4. Running the Project

We should now be able to run the project. We will first run the project's automated tests. If the tests are working correctly, we will then launch the web server and open the web app in a browser.

1. The project comes with some automated tests. Run them by entering the following command:

    ```bash
    rails test
    ```

    You should see that all the tests passed.

1. Start up the Rails web app server by entering the following command:

    ```bash
    rails s
    ```

    You should see that the server has started without error. Note that this command will not "return" like other commands—that is, the command prompt will not reappear until you halt the server process (covered below).

    Note that the `s` in the above command is short for `server`, and the command can alternatively be entered as follows:

    ```bash
    rails server
    ```

1. Open the URL <http://localhost:3000> in a web browser. You should see a "QuizMaker" web app with a list of quizzes.

1. Further test out the web app by logging in and creating a quiz:

    1. Follow the `Sign In` link at the top right and log in with the email `alice@email.com` and the password `password`.

    1. Click the `Create New Quiz` link and enter a title and description for a quiz.

    1. In your pgAdmin browser window, you can see the new quiz in the database by hitting the refresh button (F5 or the lightning bolt button).

    1. Add questions to the quiz by clicking to `Edit Quiz` link.

## 5. Inspecting the Database with pgAdmin

Verify that the Postgres DBMS running on the server is accessible and that the app's database is configured as expected.

1. Launch pgAdmin 4, entering your pgAdmin password when prompted.

1. Add a new Server by first making the following selection:

    `Object` > `Create` > `Server...`

1. Next, set the following configuration fields for the new server:

    | Field | Value | Explanation |
    | ----- | ----- | ----- |
    | Name | `SoftwareEng` | Just a made-up name for this Postgres database. |
    | Hostname/address | `localhost` | Tells pgAdmin that the database service is running on this machine. |
    | Port | `5432` | The port on which the Postgres service listens. |
    | User | `homer` | Your Unix username on the system. Replace `homer` with your actual username. |
    | Password | `password1` | The Postgres password for your username. Replace `password1` with the password you entered when configuring Postgres in the [previous demo]({% include page_url.html page_name='demo-dev-env.md' %}). |

    Once you've entered these data, click `Save`.

1. Inspect the demo web app's databases by performing the following steps. In the left sidebar, navigate as follows:

    `Servers` > `SoftwareEng` > `Databases` > `default_development` > `Schemas` > `public` > `Tables`

    Right click on `quizzes` and go to `View/Edit Data` > `All Rows`.

    You should see the Data Output panel in the bottom right corner of the screen showing information about all the quizzes in the application.

As we begin developing the demo app, using pgAdmin in this way can be very useful for verifying that our app databases are being configured properly and for debugging problems.

{% include pagination.html prev_page='demo-dev-env.md' next_page='demo-new-rails-project.md' %}
