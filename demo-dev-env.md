---
title: 'Setting Up the Development Environment'
---

# {{ page.title }}

In this demonstration, I will show how to set up the development environment used throughout the demos. We will use a [Unix-like](https://en.wikipedia.org/wiki/Unix-like) environment, regardless of the operating system being run. As a consequence, some of the setup will be different based on your computer's operating system (OS):

- {% include windows-badge.html %} As Windows is not a Unix-based OS, we will use the [Windows Subsystem for Linux (WSL)](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) to provide an [Ubuntu Linux](https://en.wikipedia.org/wiki/Ubuntu) environment (which is Unix-like).

- {% include macos-badge.html %} As [macOS](https://en.wikipedia.org/wiki/MacOS) is already a Unix-based OS, we will simply use it as-is.

- {% include linux-badge.html %} Although Linux is already a Unix-like OS, there are numerous different distros, which can complicate things. The demos were written with [Ubuntu Linux](https://en.wikipedia.org/wiki/Ubuntu) in mind; however, other [Debian](https://en.wikipedia.org/wiki/Debian)-based distros may also work.

In the text below, we use badges similar to the ones above to denote which instructions apply to which OS. Following this initial setup demo, OS-specific instructions will be much fewer are farther between.

## 1. Unix-Like Environment and Terminal App

As mentioned above, the demos will use a Unix-like development environment, although the exact environment will vary by OS. The main interface for such environments are [terminal applications](https://en.wikipedia.org/wiki/Terminal_emulator), which will similarly vary by OS.

- {% include windows-badge.html %} Set up the [Windows Subsystem for Linux (WSL)](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) and install the [Windows Terminal](https://en.wikipedia.org/wiki/Windows_Terminal) app. To do so, follow the steps in this demo: [{% include page_title.html page_name='demo-wsl.md' %}]({% include page_url.html page_name='demo-wsl.md' %}).

- {% include macos-badge.html %} No action needed. macOS is Unix based and ships with a [Terminal](https://en.wikipedia.org/wiki/Terminal_(macOS)) app by default.

- {% include linux-badge.html %} No action needed. Linux is Unix based and generally comes with a terminal app (with many more to choose from). We recommend [GNOME Terminal](https://en.wikipedia.org/wiki/GNOME_Terminal), because we have tested and which worked well for the demos.

## 2. Package Manager

Modern full-stack development platforms have numerous library and tool dependencies. To manage these dependencies, we will use a [package management system](https://en.wikipedia.org/wiki/List_of_software_package_management_systems), which will vary by OS.

- {% include windows-linux-badge.html %} No action needed. Ubuntu ships with the [APT](https://en.wikipedia.org/wiki/APT_(software)) package manager by default.

- {% include macos-badge.html %} Install the [Homebrew](https://en.wikipedia.org/wiki/Homebrew_(package_management_software)) package manager by following these steps:

    1. Launch the Terminal application and enter this command:

        ```bash
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        ```

    1. When it asks you to install [Xcode](https://en.wikipedia.org/wiki/Xcode) CommandLine Tools, say "yes".

## 3. Chrome

[Google Chrome](https://en.wikipedia.org/wiki/Google_Chrome) will be the web browser of choice for the demos. Although the demo web app should be compatible with any modern web browser, Chrome has certain development features that we will use and that are not necessarily common to all browsers.

- {% include windows-linux-badge.html %} Download and install the latest stable version from the Google Chrome website: <https://www.google.com/chrome/>.

- {% include macos-badge.html %} Install using Homebrew by entering this command:

    ```bash
    brew cask install google-chrome
    ```

## 4. VS Code

[Visual Studio Code (VS Code)](https://en.wikipedia.org/wiki/Visual_Studio_Code) will be the code editor of choice for the demos. It should look and work essentially the same on all OSs; however, the installation instructions vary somewhat by OS. (Note that VS Code is **not** the same thing as the [Microsoft Visual Studio](https://en.wikipedia.org/wiki/Microsoft_Visual_Studio) IDE.)

### 4.1. VS Code Installation

- {% include windows-linux-badge.html %} Download and install the latest stable version from the VS Code website: <https://code.visualstudio.com/>.

- {% include macos-badge.html %} Install using Homebrew by entering this command:

    ```bash
    brew cask install visual-studio-code
    ```

### 4.2. VS Code Extensions

- {% include all-badge.html %} Once you have VS Code installed, add the following extensions:
  - _Code Spell Checker_
  - _Markdown PDF_
  - _Markdown Preview Github Styling_
  - _markdownlint_
  - _Simple Ruby ERB_
  - (Windows users only) _Remote - WSL_

## 5. Z Shell

[Z Shell](https://en.wikipedia.org/wiki/Z_shell) is the Unix shell of choice for the demos. It has a number of productivity features not found in other shells. We will use the [Oh My Zsh](https://en.wikipedia.org/wiki/Z_shell#Oh_My_Zsh) Z Shell configuration manager, which provides a plugin and theme infrastructure for Z Shell. In addition to the features Oh My Zsh provides by default, we will also add a custom theme.

### 5.1. Install Z Shell

- {% include windows-linux-badge.html %} Install Z Shell using APT by entering the following commands:

    ```bash
    sudo apt update
    sudo apt install zsh
    ```

- {% include macos-badge.html %} Install Z Shell using Homebrew by entering the following command:

    ```bash
    brew install zsh
    ```

### 5.2. Make Z Shell the Default

- {% include all-badge.html %} Make Z Shell the default shell by following these steps.

    1. Set Z Shell as the default shell by entering the following command, except replacing `homer` with your username:

        ```bash
        sudo chsh homer -s /usr/bin/zsh
        ```

    1. Quit and relaunch the terminal app to make the new settings take effect.

### 5.3. Install Oh My Zsh

- {% include all-badge.html %} Install Oh My Zsh by entering the following command:

    ```bash
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

### 5.4. Add Custom Theme

- {% include all-badge.html %} Add our custom Z Shell theme by following these steps.

    1. Download the custom theme by entering this command:

        ```bash
        curl -fsSL --output ~/.oh-my-zsh/custom/themes/sdflem.zsh-theme https://human-se.github.io/rails-demos-n-deets-2020/resources/sdflem.zsh-theme
        ```

    1. Open the Z Shell configuration file `.zshrc` in VS Code by entering this command:

        ```bash
        code ~/.zshrc
        ```

    1. Configure Z Shell to use the custom theme by locating the `ZSH_THEME` setting in the `.zshrc` file and editing the setting as follows:

        ```text
        ZSH_THEME="sdflem"
        ```

        Don't forget to save the file!

    1. Quit and relaunch the terminal app to make the new settings take effect. You should now see a command prompt that looks similar to this (only with your username and hostname):

        ```text
        [homer@springfield:~/]
        % ▊
        ```

        Note that, for convenience, the prompt includes our Unix username (`homer`), the hostname of our machine (`springfield`), and the current working directory (`~/`).

## 6. pgAdmin 4

[pgAdmin 4](https://en.wikipedia.org/wiki/PostgreSQL#pgAdmin) is a database viewer and administration tool for PostgreSQL databases. This application will allow us to inspect our backend databases from a web browser.

- {% include windows-linux-badge.html %} Download and install the latest stable version from the pgAdmin website: <https://www.pgadmin.org/download/>).

- {% include macos-badge.html %} Install using Homebrew by entering this command:

    ```bash
    brew cask install pgadmin4
    ```

- {% include all-badge.html %} Once you have installed pgAdmin 4, confirm that the install was successful by launching the pgAdmin 4 app. A pgAdmin page should open in your web browser. The first time you launch pgAdmin, you will be prompted to create a password.

    **Caution!** Don't forget your pgAdmin password, because you will need it to run pgAdmin in the future.

## 7. Git

[Git](https://en.wikipedia.org/wiki/Git) is a version-control system that we will use to manage different versions of the demo project as it evolves.

### 7.1. Git Installation

- {% include windows-linux-badge.html %} Git may or may not already be installed. Check if the git package is installed by running this command:

    ```bash
    git --version
    ```

    If Git is not installed (resulting in an error message instead of a version number), install it by running:

    ```bash
    sudo apt install git
    ```

- {% include macos-badge.html %} Git should already be installed, because macOS ships with it.

### 7.2. Git Configuration

- {% include all-badge.html %} Once you have confirmed that Git is installed, set your user Git configuration settings by creating a `.gitconfig` file as follows:

    1. Create an empty `.gitconfig` file in your home directory by running this command:

        ```bash
        touch ~/.gitconfig
        ```

    1. Open this file in VS Code by entering the this command:

        ```bash
        code ~/.gitconfig
        ```

    1. Edit the contents of the file as follows, except using your own name and email:

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

## 8. GitHub

[GitHub](https://en.wikipedia.org/wiki/GitHub) is a web-based Git repository hosting service. We will use it (in conjunction with Git) to distribute different versions of the demo project as it evolves.

### 8.1. GitHub Account Registration

Since GitHub is a web-based service, we will need to register an account via GitHub's web interface.

- {% include all-badge.html %} Set up your GitHub account by following these steps.

    1. Register an account at <https://github.com/> (if you don't already have).

        **Caution!** Be sure that your GitHub account is set up with the same email address that you use in your `.gitconfig` file. The emails must match in order for GitHub to associate your commits with your GitHub user profile.

        Also, be sure not to lose your GitHub username and password.

### 8.2. Key-Based Authentication

Since GitHub will require us to authenticate every time we upload changes to our project, and we upload changes frequently, entering our password every time can be a hassle. [SSH key authentication](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh) enables Git to automatically authenticate us using secure cryptographic keys in lieu of our password.

- {% include all-badge.html %} Set up SSH key-based authentication with your Github account by following these steps.

    1. Generate a new SSH key using this command (replacing the email address with your own):

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

## 9. Node.js and Yarn

Modern web [frontend](https://en.wikipedia.org/wiki/Front_and_back_ends) code makes heavy use of [JavaScript (JS)](https://en.wikipedia.org/wiki/JavaScript), and as a consequence, there are numerous commonly used JS libraries and packages. [Node.js](https://en.wikipedia.org/wiki/Node.js) and [Yarn](https://en.wikipedia.org/wiki/Yarn_(software)) provide tools for managing JS packages

- {% include windows-linux-badge.html %} Install Node.js and Yarn by running the following commands:

    ```bash
    sudo apt install curl
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    sudo apt update
    sudo apt install zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn
    ```

- {% include macos-badge.html %} Install Node.js and Yarn by running the following commands:

    ```bash
    brew install node
    brew install yarn
    ```

## 10. RVM

[Ruby Version Manager (RVM)](https://en.wikipedia.org/wiki/Ruby_Version_Manager) is a tool for managing different versions of the [Ruby Programming Language](https://en.wikipedia.org/wiki/Ruby_(programming_language)) and different Ruby gemsets. A gemset is the collection of [Ruby gems](https://en.wikipedia.org/wiki/RubyGems) (i.e., Ruby libraries and toolkits) used by a Ruby-based software project. We will use RVM to carefully control the version of Ruby and the associated Ruby gems that the demo project uses.

### 10.1. RVM Dependencies

- {% include windows-linux-badge.html %} First, install several of RVM's dependencies by entering this command:

    ```bash
    sudo apt install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
    ```

- {% include macos-badge.html %} First, install an RVM installer dependency by entering this command:

    ```bash
    brew install gnupg
    ```

### 10.2. RVM Installation

- {% include all-badge.html %} Install RVM by running the following commands:

    ```bash
    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
    ```

## 11. Ruby on Rails

[Ruby on Rails (aka Rails)](https://en.wikipedia.org/wiki/Ruby_on_Rails) is a popular web-development framework and toolkit. It will provide the main platform upon which we construct the demo app.

### 11.1. Ruby

As the name suggests, Rails is built using the [Ruby Programming Language](https://en.wikipedia.org/wiki/Ruby_(programming_language)). Thus, Rails requires a Ruby interpreter to be installed.

- {% include all-badge.html %} Install the latest version of Ruby by running each of the following commands:

    ```bash
    rvm install 2.6.5
    rvm use 2.6.5 --default
    ruby -v
    ```

    If Ruby has successfully installed, the output of `ruby -v` should be something like:

    ```text
    ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-linux]
    ```

### 11.2. Bundler Gem

[Bundler](https://bundler.io/) is a Ruby gem management tool (which is itself a gem) that Rails projects use to manage their gem dependencies.

- {% include all-badge.html %} Globally install the Bundler gem by running this command:

    ```bash
    rvm @global do gem install bundler
    ```

- {% include windows-badge.html %} If the previous command times out because RVM cannot connect to `rubygems.org`, try restarting the computer and rerunning the command. If it still doesn't work, the problem may be with IPv6 connections to `rubygems.org`. Force IPv4 connections to `rubygems.org` by following these steps **and then trying the command again**:

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

### 11.3. Rails Gem

Rails is packaged as a gem that must be installed in order to create, run, etc. Rails projects.

- {% include all-badge.html %} Globally install Rails by running this command:

    ```bash
    rvm @global do gem install rails
    ```

    Verify that Rails was installed successfully by running this command:

    ```bash
    rails -v
    ```

    It should display version 6.0.2.1.

## 12. Postgres

[Postgres](https://en.wikipedia.org/wiki/PostgreSQL) is a popular database management system. The demo Rails project will use Postgres as its database [backend](https://en.wikipedia.org/wiki/Front_and_back_ends).

- {% include windows-linux-badge.html %} Install Postgres by following these steps:

    1. Install the Postgres packages by running:

        ```bash
        sudo apt -y install postgresql-12 postgresql-client-12 libpq-dev
        ```

        If the `postgresql-12` package cannot be found, follow these additional steps, **and then try the above command again**:

        1. Add the repository by running:

            ```bash
            sudo tee /etc/apt/sources.list.d/pgdg.list <<END
            deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main
            END
            ```

            Be careful when you copy and paste the above command that you do not get an extra space before the `END` line.

        1. Get the signing key and import it by running:

            ```bash
            wget https://www.postgresql.org/media/keys/ACCC4CF8.asc
            sudo apt-key add ACCC4CF8.asc
            ```

        1. Fetch the metadata from the new repo by running:

            ```bash
            sudo apt update
            ```

    1. Start the Postgres service by running:

        ```bash
        sudo service postgresql start
        ```

        For Windows/WSL users, the `postgresql` service will generally stay on, but you may sometimes discover that it has been halted (e.g., rebooting Windows may cause the service to halt). To restart the service, simply rerun the above command. If in doubt, you can check the status of the service by running this command:

        ```bash
        sudo service postgresql status
        ```

        Additionally, you can halt the service by running this command:

        ```bash
        sudo service postgresql stop
        ```

    1. Set up a `postgres` user with permission to create databases (which must have the same name as your Ubuntu user) by running the following command (replacing `homer` with your Unix username).

        **Important!** The username must match your Unix username exactly.

        ```bash
        sudo -u postgres createuser homer -s -d
        ```

    1. Set a password for your Postgres username by running:

        ```bash
        sudo -u postgres psql
        ```

        This command will launch a `postgres` command prompt. At the prompt, enter the following command (substituting `homer` with your Unix username and `password1` with a password of your choosing):

        ```bash
        ALTER USER homer WITH PASSWORD 'password1';
        ```

        **Caution!** Don't forget the semicolon on the end, or the command will fail silently.

    1. Enter `\q` to exit the `postgres` prompt.

- {% include macos-badge.html %} Install Postgres by following these steps:

    1. Install the Postgres packages using Homebrew by running this command:

        ```bash
        brew install postgresql
        ```

    1. Update the Postgres security settings by running the following command:

        ```bash
        curl -fsSL --output /usr/local/var/postgres/pg_hba.conf https://human-se.github.io/rails-demos-n-deets-2020/resources/pg_hba.conf
        ```

    1. Start the Postgres service by running:

        ```bash
        brew services start postgresql
        ```

        The service will now generally stay on, even after reboots. If you ever need to halt the service, you can run this command:

        ```bash
        brew services stop postgresql
        ```

    1. Set a password for your Postgres username (same as your Unix username) by running:

        ```bash
        psql postgres
        ```

        This command will launch a `postgres` command prompt. At the prompt, enter the following command (substituting `homer` with your Unix username and `password1` with a password of your choosing):

        ```bash
        ALTER USER homer WITH PASSWORD 'password1';
        ```

        **Caution!** Don't forget the semicolon on the end, or the command will fail silently.

    1. Enter `\q` to exit the `postgres` prompt.

- {% include all-badge.html %} **Caution!** Don't forget the password you entered for your Postgres user. You will need it later to access the database using pgAdmin.

## 13. Conclusion

Having completed all of the above development environment setup, the next step will be to test that it's all working by running an existing Rails-based web app.

{% include pagination.html next_page='demo-run-app.md' %}
