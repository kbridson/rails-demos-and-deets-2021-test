---
title: 'Setting Up the Development Environment'
---

# {{ page.title }}

In this demonstration, I will show you how to setup the development environment used in the rest of the demos. Some of the setup will be different based on your computer's operating system (OS). In particular, Windows users will be using Ubuntu via the Windows Subsytem for Linux (WSL). Once that part of their setup is complete, Windows and Linux users will have the same command line steps to follow.

## 1. Unix-Like Environment and Terminal App

- {% include windows-badge.html %} **⇨** Set up the [Windows Subsystem for Linux (WSL)](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) and install the [Windows Terminal](https://en.wikipedia.org/wiki/Windows_Terminal) app. To do so, follow the steps in this [demo on setting up WSL and Windows Terminal]({{ '/demo-wsl/' | relative_url }}).

- {% include macos-badge.html %} **⇨** No action needed. macOS is Unix based and ships with a [Terminal](https://en.wikipedia.org/wiki/Terminal_(macOS)) app by default.

- {% include linux-badge.html %} **⇨** No action needed. Linux is Unix based and generally comes with a terminal app (with many more to choose from). We recommend [GNOME Terminal](https://en.wikipedia.org/wiki/GNOME_Terminal), because we have tested and which worked well for the demos.

## 2. Package Manager

- {% include windows-linux-badge.html %} **⇨** No action needed. Ubuntu ships with the [APT](https://en.wikipedia.org/wiki/APT_(software)) package manager by default.

- {% include macos-badge.html %} **⇨** Install the [Homebrew](https://en.wikipedia.org/wiki/Homebrew_(package_management_software)) package manager by following these steps:

    1. Launch the Terminal application and enter this command:

        ```bash
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        ```

    1. When it asks you to install [Xcode](https://en.wikipedia.org/wiki/Xcode) CommandLine Tools, say "yes".

## 3. VS Code

[Visual Studio Code (VS Code)](https://en.wikipedia.org/wiki/Visual_Studio_Code) will be the code editor of choice for these demos.

- {% include windows-linux-badge.html %} **⇨** Download and install the latest stable version from the VS Code website: <https://code.visualstudio.com/>.

- {% include macos-badge.html %} **⇨** Install using Homebrew by entering this command:

    ```bash
    brew cask install vscode
    ```

- {% include badge.html text="All" color="primary" %} **⇨** Once you have VS Code installed, add the following extensions:
  - _Code Spell Checker_
  - _Markdown PDF_
  - _Markdown Preview Github Styling_
  - _markdownlint_
  - _Simple Ruby ERB_
  - (Windows users only) _Remote - WSL_

## 4. pgAdmin 4

[pgAdmin 4](https://en.wikipedia.org/wiki/PostgreSQL#pgAdmin) is a database viewer and administration tool for PostgreSQL databases. This application will allow us to inspect our backend databases from a web browser.

- {% include windows-linux-badge.html %} **⇨** Download and install the latest stable version from the pgAdmin website: <https://www.pgadmin.org/download/>).

- {% include macos-badge.html %} **⇨** Install using Homebrew by entering this command:

    ```bash
    brew cask install pgadmin4
    ```

- {% include badge.html text="All" color="primary" %} **⇨** Once you have installed pgAdmin 4, confirm that the install was successful by launching the pgAdmin 4 app. A pgAdmin page should open in your web browser. The first time you launch pgAdmin, you will be prompted to create a password. Don't forget it, because you will need it to run pgAdmin in the future!

## 5. Git

Git will be used for version control and collaboration in these demos.

- {% include windows-linux-badge.html %} **⇨** Git may or may not already be installed. Check if the git package is installed by running this command:

    ```bash
    git --version
    ```

    If Git is not installed (resulting in an error message instead of a version number), install it by running:

    ```bash
    sudo apt install git
    ```

- {% include macos-badge.html %} **⇨** Git should already be installed, because macOS ships with it.

- {% include badge.html text="All" color="primary" %} **⇨** Once you have confirmed that Git is installed, set your user Git configuration settings by creating a `.gitconfig` file as follows:

    1. Create an empty `.gitconfig` file in your home directory by running this command:

        ```bash
        touch ~/.gitconfig
        ```

    1. Open this file in VS Code by entering the this command:

        ```bash
        code ~/.gitconfig
        ```

    1. Edit the contents of the file as follows, only using your name and email:

        ```ini
        # This is Git's per-user configuration file.
        [user]
                name = Homer Simpson
                email = homer@email.com

        [core]
                autocrlf = false
        [color]
                ui = true
        ```

        Don't forget to save the file!

## 6. GitHub

- {% include badge.html text="All" color="primary" %} **⇨** Set up your GitHub account by following these steps.

    1. Register an account at <https://github.com/> (if you don't already have).

        **Caution!** Be sure that your GitHub account is set up with the same email address that you use in your `.gitconfig` file. The emails must match in order for GitHub to associate your commits with your GitHub user profile.

        Also, be sure not to lose your GitHub username and password.

    1. To setup SSH authentication with your Github account, first, generate a new SSH key using this command (replacing the email address with your own one):

        ```bash
        ssh-keygen -t rsa -b 4096 -C "homer@email.com"
        ```

        Again, be sure to use the email associated with your Github account. Also, you should accept all the default options for that command by hitting ENTER without entering anything.

    1. Add the key you just generated to your Github account by copying the output of the following command:

        ```bash
        cat ~/.ssh/id_rsa.pub
        ```

        Then, go to <https://github.com/settings/keys> in your browser. Make sure you are logged into Github. Click the button "New SSH key", enter a title, and paste the output of the command in the key field. Click "Add SSH key".

    1. Check the SSH key has been setup correctly by entering this command:

        ```bash
        ssh -T git@github.com
        ```

        You should get a message like:

        ```text
        Hi homer! You've successfully authenticated, but GitHub does not provide shell access.
        ```

## 7. Node.js and Yarn

- {% include windows-linux-badge.html %} **⇨** Install Node.js and Yarn by running the following commands:

    ```bash
    sudo apt install curl
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    sudo apt-get update
    sudo apt-get install zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn
    ```

- {% include macos-badge.html %} **⇨** Install Node.js and Yarn by running the following commands:

    ```bash
    brew install node
    brew install yarn
    ```

## 8. RVM

- {% include windows-linux-badge.html %} **⇨** First, install several of RVM's dependencies by entering this command:

    ```bash
    sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
    ```

- {% include macos-badge.html %} **⇨** First, install several of RVM's dependencies by entering this command:

    ```bash
    brew install gnupg
    ```

- {% include badge.html text="All" color="primary" %} **⇨** Install RVM by running each of the following commands:

    ```bash
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    ```

## 9. Ruby

- {% include badge.html text="All" color="primary" %} **⇨** Install the latest version of Ruby by running each of the following commands:

    ```bash
    rvm install 2.6.5
    rvm use 2.6.5 --default
    ruby -v
    ```

    If Ruby has successfully installed, the output of `ruby -v` should be something like:

    ```text
    ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-linux]
    ```

## 10. Ruby on Rails

- {% include badge.html text="All" color="primary" %} **⇨** First, globally install the Bundler gem to manage project gemsets by running this command:

    ```bash
    rvm @global do gem install bundler
    ```

- {% include windows-badge.html %} **⇨** If the previous command times out because RVM cannot connect to <rubygems.org>, try restarting the computer and rerunning the command. If it still doesn't work, the problem may be with IPv6 connections to <rubygems.org>. Force IPv4 connections to <rubygems.org> by following these steps and then trying the command again:

    1. Edit the /etc/gai.conf file by running:

        ```bash
        sudo nano /etc/gai.conf
        ```

    1. Uncomment lines to match the following:

        ```conf
        #For sites which prefer IPv4 connections change the last line to
        precedence ::ffff:0:0/96 100
        ...
        #    For sites which use site-local IPv4 addresses behind NAT there is
        #    the problem that even if IPv4 addresses are preferred they do not
        #    have the same scope and are therefore not sorted first.  To change
        #    this use only these rules:
        #
        scopev4 ::ffff:169.254.0.0/112  2
        scopev4 ::ffff:127.0.0.0/104    2
        scopev4 ::ffff:0.0.0.0/96       14
        ```

    1. Enter Ctrl-X to save and exit.

- {% include badge.html text="All" color="primary" %} **⇨** Globally install Rails by running this command:

    ```bash
    rvm @global do gem install rails
    ```

    Verify that Rails was installed successfully by running this command:

    ```bash
    rails -v
    ```

    It should display version 6.0.2.1.

## 11. Postgres

- {% include windows-linux-badge.html %} **⇨** Install Postgres by following these steps:

    1. Install the Postgres packages by running:

        ```bash
        sudo apt -y install postgresql-12 postgresql-client-12
        ```

        If the `postgresql-12` package cannot be found, follow these additional steps, and then try the above command again:

        1. Add the repository by running:

            ```bash
            sudo tee /etc/apt/sources.list.d/pgdg.list <<END
            deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main
            END
            ```

        1. Get the signing key and import it by running:

            ```bash
            wget https://www.postgresql.org/media/keys/ACCC4CF8.asc
            sudo apt-key add ACCC4CF8.asc
            ```

        1. Fetch the metadata from the new repo by running:

            ```bash
            sudo apt-get update
            ```

    1. Start the Postgres service by running:

        ```bash
        sudo service postgresql start
        ```

        For Windows/WSL users, you will need to run this command every time you restart your WSL/Ubuntu terminal.

    1. Set up a `postgres` user with permission to create databases (which must have the same name as your Ubuntu user) by running the following command (replacing `homer` with your Ubuntu username):

        ```bash
        sudo -u postgres createuser homer -s -d
        ```

    1. Set a password for your Postgres username by running:

        ```bash
        sudo -u postgres psql
        ```

        At the new prompt enter the following command (substituting your username and password):

        ```bash
        ALTER USER homer WITH PASSWORD 'password1';
        ```

        Enter `\q` to exit the `postgres` prompt.

- {% include macos-badge.html %} **⇨** Install Postgres by following these steps:

    1. Install the Postgres packages using Homebrew by running this command:

        ```bash
        brew install postgresql
        ```

    1. Start the Postgres service by running:

        ```bash
        brew services start postgresql
        ```
