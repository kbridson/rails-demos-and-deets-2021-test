---
title: 'Setting Up the Development Environment'
---

# {{ page.title }}

In this demonstration, I will show you how to setup the development environment used in the rest of the demos. The following setup should generally work for Windows, Mac, and Linux.

Before I jump into the demo, I'd like to clear up a little terminology. In these demos, I will be using a _virtual machine_ (VM). A VM is where one OS is run inside of another OS (rather than directly on a physical machine). The parent OS is called the _host OS_. For example, imagine you have a Windows computer—that'll be the host OS. You can use the VirtualBox software to install a Linux OS within the host Windows OS and to run a Linux VM as if it were a Windows program.

## 1. Installing Software on the Host OS

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/l4Moh3_7IYM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

1. Register an account at <https://github.com/> (if you don't already have one). Git and GitHub will be used for version control and collaboration in these demos. Be sure not to lose your GitHub username and password.

1. Install the _Visual Studio Code_ (VS Code) editor (<https://code.visualstudio.com/>). VS Code will be the code editor of choice for these demos. Use the latest stable version.

1. Additionally, within VS Code, install the following five extensions: (1) _Code Spell Checker_, (2) _Markdown PDF_, (3) _Markdown Preview Github Styling_, (4) _markdownlint_, and (5) _Simple Ruby ERB_.

1. Install a Bash shell with SSH client (if you don't already have it).

   - Windows users: download and install _Git for Windows_ (<http://git-scm.com/download/win>), which comes with a Bash shell and SSH client. **Important!** During installation, you must check the "Enable symbolic links" checkbox. If you accidentally failed to do so, you must uninstall and then reinstall Git for Windows, this time checking the box.

   - MacOS users: you have this software by default (see the _Terminal_ app).

   - Debian/Ubuntu Linux users: you have the shell, but may need to install the "openssh-client" package (if it’s not already installed by default).

1. Download and install _VirtualBox_ version 6.0.4 (<https://www.virtualbox.org/wiki/Download_Old_Builds_6_0>). I will be using this software to run an Ubuntu Linux virtual machine that will house most of the Rails development tools (with only a few graphical tools running in the host OS). As of the time of writing, there is [a VirtualBox bug](https://www.virtualbox.org/ticket/18569) in releases newer than 6.0.4 that breaks Git, among other things, in the VM's shared folder. Note: Your computer must support virtualization in order for VirtualBox to work.
    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-5" role="button" aria-expanded="false" aria-controls="moreDetails1-5">More details...▼</a></small></span>

    <div class="collapse" id="moreDetails1-5">
    <p class="text-muted mr-3 ml-3">
    Even if your computer does provide virtualization support you may need to enable in your system BIOS. For Windows users, VirtualBox will not work if you have Hyper-V enabled, so you will need to disable Hyper-V to complete the next steps or see the instructor for potential workarounds.
    </p>
    </div>

1. Download and install _Vagrant_ (<https://www.vagrantup.com/>). Vagrant is used to package, distribute, and run custom-configured VMs. I have prepared a Vagrant "box" as you will see below.

1. Install two Vagrant plugins by launching a terminal and entering the following commands:

    ```bash
    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-fsnotify
    ```

    [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) will ensure that your VirtualBox Guest Additions versions are kept in sync between the host and the VM.

    [vagrant-fsnotify](https://github.com/adrienkohlbecker/vagrant-fsnotify) enhances VirtualBox shared folders by forwarding filesystem change notifications to your Vagrant VM. Later, when you're adding new code to your Rails web apps, this plugin will save you from having to restart the Rails development web server every time you make a change.

    Confirm that the plugins were successfully installed by entering the following command:

    ```bash
    vagrant plugin list
    ```

1. Download and install _pgAdmin_ 4 (<https://www.pgadmin.org/download/>), a database viewer and administration tool for PostgreSQL databases. This application will allow you to view the database running on your VM from a web browser on your host.

    Confirm that the install was successful by launching the pgAdmin 4 app on your host OS. A pgAdmin page should open in your web browser.

    The first time you launch pgAdmin, you will be prompted to create a password. Don't forget it, because you will need it to run pgAdmin in the future!

## 2. Setting Up Workspace and Initializing VM

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/VGpxOg6e_8Y" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

1. Create a folder `workspace`. This folder is where all the Rails projects in these demos will go.

1. Download the file [Vagrantfile]({{ site.baseurl }}/resources/Vagrantfile) and the file [provisioner.sh]({{ site.baseurl }}/resources/provisioner.sh), and save them in your `workspace` folder. Make sure that no file suffix (e.g., ".txt") gets added to the Vagrantfile when saving it. For example, one way to download it would be to right-click on the hyperlink and select "Save Link As..." (or similar) from the context menu.

1. Launch a terminal. In Windows, it involves launching _Git Bash_. In MacOS and Linux, this involves launching a terminal application.

1. In the terminal, change directory (using the `cd` command) to your `workspace` folder. Note: I will be using the command-line a lot in the demos. I will generally assume that readers are familiar with the basic file management and navigation commands (`cd`, `rm`, `cp`, `mv`, etc.).
    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails2-4" role="button" aria-expanded="false" aria-controls="moreDetails2-4">If you're new to the command-line...▼</a></small></span>

    <div class="collapse" id="moreDetails2-4">
    <p class="text-muted mr-3 ml-3">
    If you're new to the command-line, I highly suggest you spend some time on your own learning about it—for example, Codecademy has <a href="https://www.codecademy.com/learn/learn-the-command-line" target="_">a course</a>.
    </p>
    </div>

1. Download and initialize the Vagrant box specified in the Vagrantfile you downloaded by running the following command:

    ```bash
    vagrant up
    ```

    BEWARE! This command (1) may take a long time to complete, (2) downloads a big file (~700MB), and (3) performs at least one processor-intensive compilation (of Ruby). Once this command completes, you will have a running Ubuntu Linux VM (headless). The last line of output from this command should look something like the following:

    `default: ==> default: fsnotify: Watching (some system-specific file path)`

    The fsnotify plugin will tie up the current terminal window from here on out.

    The VirtualBox application should show that a new VM was created and is running.

## 3. Testing a Rails App

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/g8xaHHwqQ0E" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

1. To log into the Linux VM, open a second terminal window (or tab) and change directory (using the `cd` command) to the `workspace` folder. Then, SSH into the VM by entering the following command:

    ```bash
    vagrant ssh
    ```

    A command prompt should appear that looks like this: `[vagrant@ubuntu1804:~]` followed by a `$` prompt. If you use the `ls -l` command, you will see a list of files in the current directory. Among them should be a `workspace` folder (actually a symbolic link to the folder `/vagrant`).

1. Change directory (using the `cd` command) to the `workspace` folder. Note that this folder is synced with the `workspace` folder on the host OS. That is, changes made in the folder on one side (VM or host OS) are instantly visible on the other side.

1. Use Git to download an example project by entering the following command:

    ```bash
    git clone https://github.com/memphis-cs/rails-6-test-app.git
    ```

    A `rails-6-test-app` folder should be visible inside the `workspace` folder. Note that the `workspace` folder is synced with the host OS, so the `rails-6-test-app` folder should also be visible in the host OS's file explorer. The main reason for syncing this folder is that it will enable the use a GUI code editor (VS Code) to work on the code files.

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

    Windows users: if attempting to run `yarn install` throws symlink errors, you will need to complete some additional steps here.
    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails3-7" role="button" aria-expanded="false" aria-controls="moreDetails3-7">More details...▼</a></small></span>

    <div class="collapse" id="moreDetails3-7">
    <p class="text-muted mr-3 ml-3">
    <ol class="text-muted">
    <li>Log out of the VM by entering the command <code>exit</code>.</li>
    <li>Switch to the first terminal window and stop fsnotify by pressing Ctrl-C.</li>
    <li>Shutdown the VM by entering the command <code>vagrant halt</code>. You will now be able to type commands on the host OS.</li>
    <li>Open a command prompt with administrative privileges inside the workspace folder and enter the following command:
    <code class="d-block">fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1</code>
    Verify that has completed correctly with:<br>
    <code class="d-block">fsutil behavior query symlinkevaluation</code>
    (all should be valid).</li>
    <li>Restart your VM and attempt to run <code>yarn install</code> again. It should complete with no errors.</li>
    </ol>
    </p>
    </div>

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

1. Now open the URL <http://localhost:3000> in a web browser on your host OS.  You should see a "Welcome to Quiz Maker" web page with a list of quizzes.

1. Verify that the Postgres DBMS running on the server is accessible and that the app's database is configured as expected.

    1. Add a Server with the following configuration:

        - Name: `Vagrant`

        - Hostname/address: `localhost`

        - Port: `5432`

        - User: `vagrant`

        - Password: `password1`

    1. In the left sidebar, go navigate as follows:

        `Servers` > `Vagrant` > `Databases` > `default_development` > `Schemas` > `public` > `Tables`

        Right click on `quizzes` and go to `View/Edit Data` > `All Rows`.

        You should see the Data Output panel in the bottom right corner of the screen showing information about all the quizzes in the application.

1. Further test out the web app by logging in and creating a quiz:

    1. Follow the `Sign In` link at the top right and log in with the email `alice@email.com` and the password `password`.

    1. Click the `Create New Quiz` link and enter a title and description for a quiz.

    1. In your pgAdmin browser window, you can see the new quiz in the database by hitting the refresh button (F5 or the lightning bolt button).

    1. Add questions to the quiz by clicking to `Edit Quiz` link.

## 4. Shutting Everything Down

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/tZpPCU1ZIws" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

To shut down everything:

1. In the terminal, type Ctrl-C to halt the Rails server (that is, press and hold the Ctrl key and then click the 'C' key).

1. Log out of the VM by entering the following command:

    ```bash
    exit
    ```

1. In the other terminal, halt fsnotify by typing `Ctrl-C`.

1. Shut down the VM by entering the following command:

    ```bash
    vagrant halt
    ```

To restart the VM, run `vagrant up` in the `workspace` folder on the host OS (should be much faster than last time), and run `vagrant ssh` in a new terminal window/tab to log in again.
