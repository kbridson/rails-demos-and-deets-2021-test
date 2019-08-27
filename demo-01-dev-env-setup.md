---
layout: page
title: 'Demo 1: Development Environment Setup'
permalink: /demo-01-dev-env-setup/
---

# Demo 1: Development Environment Setup

In this demonstration, I will show you how to setup the development environment used in the rest of the demos. The following setup should generally work for Windows, Mac, and Linux.

Before I jump into the demo, I'd like to clear up a little terminology. In these demos, I will be using a _virtual machine_ (VM). A VM is where one OS is run inside of another OS (rather than directly on a physical machine). The parent OS is called the _host OS_. For example, imagine you have a Windows computer—that'll be the host OS. You can use the VirtualBox software to install a Linux OS within the host Windows OS and to run a Linux VM as if it were a Windows program.

## 1. Installing Software

1. Register an account at <https://github.com/> (if you don't already have one). Git and GitHub will be used for version control and collaboration in these demos. Be sure not to lose your GitHub username and password.

1. Install the _Visual Studio Code_ (VS Code) editor (<https://code.visualstudio.com/>). VS Code will be the code editor of choice for these demos. Use the latest stable version.

1. Additionally, within VS Code, install the following five extensions: (1) _Code Spell Checker_, (2) _Markdown PDF_, (3) _Markdown Preview Github Styling_, (4) _markdownlint_, and (5) _Simple Ruby ERB_.

1. Install a Bash shell with SSH client (if you don't already have it).

   - Windows users: download and install the _Git for the Windows_ platform (<http://git-scm.com/download/win>), which comes with a Bash shell and SSH client. **Important!** During installation, you must check the "Enable symbolic links" checkbox.

   - MacOS users: you have this software by default (see the _Terminal_ app).

   - Debian/Ubuntu Linux users: you have the shell, but may need to install the "openssh-client" package (if it’s not already installed by default).

1. Download and install _VirtualBox_ version 6.0.4 (<https://www.virtualbox.org/wiki/Download_Old_Builds_6_0>). I will be using this software to run an Ubuntu Linux virtual machine that will house most of the Rails development tools (with only a few graphical tools running in the host OS). As of the time of writing, there is [a VirtualBox bug](https://www.virtualbox.org/ticket/18569) in releases newer than 6.0.4 that breaks Git, among other things, in the VM's shared folder. Note: Your computer must support virtualization in order for VirtualBox to work.
    <span><a class="text-muted" data-toggle="collapse" href="#moreDetails1-5" role="button" aria-expanded="false" aria-controls="moreDetails1-5">More details...</a></span>

    <div class="collapse" id="moreDetails1-5">
    <p class="text-muted mr-3 ml-3">
    Even if your computer does provide virtualization support you may need to enable in your system BIOS. For Windows users, VirtualBox will not work if you have Hyper-V enabled, so you will need to disable Hyper-V to complete the next steps or see the instructor for potential workarounds.
    </p>
    </div>

1. Download and install _Vagrant_ (<https://www.vagrantup.com/>). Vagrant is used to package, distribute, and run custom-configured VMs. I have prepared a Vagrant "box" as you will see below.

1. Download and install _pgAdmin_ 4 (<https://www.pgadmin.org/download/>), a database viewer and administration tool for PostgreSQL databases. This application will allow you to view the database running on your VM from a web browser on your host.

## 2. Setting Up Workspace and Initializing VM

1. Create a folder `workspace`. This folder is where all the Rails projects in these demos will go.

1. Download the file [Vagrantfile]({{ site.baseurl }}/resources/Vagrantfile) and the file [provisioner.sh]({{ site.baseurl }}/resources/provisioner.sh), and save them in your `workspace` folder. Make sure that no file suffix (e.g., ".txt") gets added to the Vagrantfile when saving it. For example, one way to download it would be to right-click on the hyperlink and select "Save Link As..." (or similar) from the context menu.

1. Launch a terminal. In Windows, it involves launching _Git Bash_. In MacOS and Linux, this involves launching a terminal application.

1. In the terminal, change directory (using the `cd` command) to your `workspace` folder. Note: I will be using the command-line a lot in the demos. I will generally assume that readers are familiar with the basic file management and navigation commands (`cd`, `rm`, `cp`, `mv`, etc.).
    <span><a class="text-muted" data-toggle="collapse" href="#moreDetails2-4" role="button" aria-expanded="false" aria-controls="moreDetails2-4">More details...</a></span>

    <div class="collapse" id="moreDetails2-4">
        <p class="text-muted mr-3 ml-3">
             If you're new to the command-line, I highly suggest you spend some time on your own learning about it—for example, Codecademy has <a href="https://www.codecademy.com/learn/learn-the-command-line" target="_">a course</a>.
        </p>
    </div>

1. Install two Vagrant plugins by running the following commands:

    `vagrant plugin install vagrant-vbguest`

    `vagrant plugin install vagrant-fsnotify`

    [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) will ensure your VirtualBox Guest Additions versions are kept in sync between the host and the VM. [vagrant-fsnotify](https://github.com/adrienkohlbecker/vagrant-fsnotify) enhances VirtualBox shared folders by forwarding filesystem change notifications to your Vagrant VM.

1. Download and initialize the Vagrant box specified in the Vagrantfile you downloaded by running the following command:

    `vagrant up`

    BEWARE! This command (1) may take a long time to complete, (2) downloads a big file (~700MB), and (3) performs at least one processor-intensive compilation (of Ruby). Once this command completes, you will have a running Ubuntu Linux VM (headless). The last line of output from this command should look something like the following:

    `default: ==> default: fsnotify: Watching (some system-specific file path)`

    The fsnotify plugin will tie up the current terminal window from here on out.

## 3. Testing the Environment

1. Open a second terminal window (or tab) and change directory (using the `cd` command) to the `workspace` folder to continue running additional commands below.

1. To SSH into the Linux VM, run the following command:

    `vagrant ssh`

    A command prompt should appear that looks like this: `[vagrant@ubuntu1804:~]` followed by a `$` prompt. If you use the `ls -l` command, you will see a list of files in the current directory. Among them should be a `workspace` folder (actually a symbolic link to the folder `/vagrant`).

1. Change directory (using the `cd` command) to the `workspace` folder. Note that this folder is synced with the `workspace` folder on the host OS. That is, changes made in the folder on one side (VM or host OS) are instantly visible on the other side.

1. Use Git to download an example project by entering the following command:

    `git clone https://github.com/memphis-cs/rails-6-test-app.git`

    A `rails-6-test-app` folder should be visible inside the `workspace` folder. Note that the `workspace` folder is synced with the host OS, so the `rails-6-test-app` folder should also be visible in the host OS's file explorer. The main reason for syncing this folder is that it will enable the use a GUI code editor (VS Code) to work on the code files.

1. Change directory (using the `cd` command) to the `rails-6-test-app` folder. When you run this command, RVM should print a message like the following, which lets you know it's working:

    `ruby-2.6.3 - #gemset created /home/vagrant/.rvm/gems/ruby-2.6.3@quiz-maker`  
    `ruby-2.6.3 - #generating quiz-maker wrappers.........`

    <span><a class="text-muted" data-toggle="collapse" href="#moreDetails3-5" role="button" aria-expanded="false" aria-controls="moreDetails3-5">More details...</a></span>

    <div class="collapse" id="moreDetails3-5">
        <p class="text-muted mr-3 ml-3">
            If no such messages appears, then something is wrong. A common problem is that the terminal application is not configured to run as a "login" shell. This issue seems to come up the most for Linux users, or users of more exotic terminal applications. Typically, the solution can be found in the terminal application's settings.
        </p>
    </div>

1. Download and install the gems (Ruby libraries) for this Rails project by entering the following command:

    `bundle install`

1. Download and install all the JavaScript dependencies for this Rails project by entering the following command:

    `yarn install`

    Windows users: if attempting to run `yarn install` throws symlink errors, you will need to complete some additional steps here.
    <span><a class="text-muted" data-toggle="collapse" href="#moreDetails3-7" role="button" aria-expanded="false" aria-controls="moreDetails3-7">More details...</a></span>

    <div class="collapse" id="moreDetails3-7">
    <p class="text-muted mr-3 ml-3">
    <ol class="text-muted">
    <li>Enter the command <code>exit</code> to log out of the VM.</li>
    <li>Switch to the first terminal window and press Ctrl-C to stop the fsnotify plugin.</li>
    <li>Enter the command <code>vagrant halt</code> to shutdown the VM. You will now be able to type commands on the host.</li>
    <li>Open a command prompt with administrative privileges inside the workspace folder and enter the command:<br>
    <code>fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1</code><br>
    Verify that has completed correctly with:<br>
    <code>fsutil behavior query symlinkevaluation</code><br>
    (all should be valid).</li>
    <li>Restart your VM and attempt to run <code>yarn install</code> again. It should complete with no errors.</li>
    </ol>
    </p>
    </div>

1. Wipe and reset the database to be used by this Rails app by entering the following command:

    `rails db:reset`

1. The project comes with some automated tests. Run them by entering the following command:

    `rails test`

    You should see that all the tests passed.

1. Start up the Rails web app server by entering the following command (those are zeros):

    `rails s -b 0.0.0.0`

    You should see that the server has started without error. Note that this command will not "return" like other commands—that is, the command prompt will not reappear until you halt the server process (covered below).

1. Now open the URL <http://localhost:3000> in a web browser on your host OS.  You should see a "Welcome to Quiz Maker" web page with a list of quizzes.

1. Verify that the Postgres DBMS running on the server is accessible and that the app's database is configured as expected.

    1. Launch the pgAdmin 4 app on your host OS. This will open a pgAdmin webpage in your web browser.

    1. Create a password for pgAdmin when prompted. Don't forget it!

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

To shut down everything:

1. In the terminal, type Ctrl-C to halt the Rails server (that is, press and hold the Ctrl key and then click the 'C' key).

1. Enter the command `exit` to logout of the VM (and optionally close the terminal window/tab).

1. In the other terminal, type Ctrl-C to halt fsnotify.

1. Enter the command `vagrant halt` to shut down the VM (and optionally close the terminal window/tab).

To restart the VM, run `vagrant up` in the `workspace` folder on the host OS (should be much faster than last time), and run `vagrant ssh` in a new terminal window/tab to log in again.
