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

1. Additionally, within VS Code, install the following extensions:

   - `Code Spell Checker`
   
   - `Markdown PDF`
   
   - `Markdown Preview Github Styling`
   
   - `markdownlint`
   
   - `Simple Ruby ERB`

1. Install a Bash shell with SSH client (if you don't already have it).

   - Windows users: download and install the _Git for the Windows_ platform (<http://git-scm.com/download/win>), which comes with a Bash shell and SSH client.

   - MacOS users: you have this software by default (see the _Terminal_ app).

   - Debian/Ubuntu Linux users: you have the shell, but may need to install the "openssh-client" package (if it’s not already installed by default).

1. Download and install _VirtualBox_ (<https://www.virtualbox.org/>). I will be using this software to run an Ubuntu Linux virtual machine. This VM will house most of the Rails development tools (with a few graphical tools running in the host OS). Note: Your computer must support virtualization in order for VirtualBox to work.
    <span><a class="text-muted" data-toggle="collapse" href="#moreDetails" role="button" aria-expanded="false" aria-controls="moreDetails">More details...</a></span>

    <div class="collapse" id="moreDetails">
        <p class="text-muted mr-3 ml-3">
            Even if your computer does provide virtualization support you may need to enable in your system BIOS. For Windows users, VirtualBox will not work if you have Hyper-V enabled, so you will need to disable Hyper-V to complete the next steps or see the instructor for potential workarounds.
        </p>
    </div>

1. Download and install _Vagrant_ (<https://www.vagrantup.com/>). Vagrant is used to package, distribute, and run custom-configured VMs. I have prepared a Vagrant "box" as you will see below.

1. Download and install _pgAdmin_ 4 (<https://www.pgadmin.org/download/>), a database viewer and administration tool for PostgreSQL databases. This application will allow you to view the database on your VM from a browser on your host.

## 2. Setting Up Workspace and Initializing VM

1. Create a folder `workspace`. This folder is where all the Rails projects in these demos will go.

1. Download the file [Vagrantfile]({{ site.baseurl }}/resources/Vagrantfile) and the file [provisioner.sh]({{ site.baseurl }}/resources/provisioner.sh), and save them in your `workspace` folder. Make sure that no file suffix (e.g., ".txt") gets added to the Vagrantfile when saving it. For example, one way to download it would be to right-click on the hyperlink and select "Save Link As..." (or similar) from the context menu.

1. Launch a terminal. In Windows, it involves launching _Git Bash_. In MacOS and Linux, this involves launching a terminal application.

1. In the terminal, change directory (using the `cd` command) to your `workspace` folder. Note: I will be using the command-line a lot in the demos. I will generally assume that readers are familiar with the basic file management and navigation commands (`cd`, `rm`, `cp`, `mv`, etc.).
    <span><a class="text-muted" data-toggle="collapse" href="#moreDetails" role="button" aria-expanded="false" aria-controls="moreDetails">More details...</a></span>

    <div class="collapse" id="moreDetails">
        <p class="text-muted mr-3 ml-3">
             If you're new to the command-line, I highly suggest you spend some time on your own learning about it—for example, Codecademy has <a href="https://www.codecademy.com/learn/learn-the-command-line" target="_">a course</a>.
        </p>
    </div>

1. Install two Vagrant plugins by running the commands `vagrant plugin install vagrant-vbguest` and `vagrant plugin install vagrant-fsnotify`. [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) will ensure your VirtualBox Guest Additions versions are kept in sync between the host and the VM. [vagrant-fsnotify](https://github.com/adrienkohlbecker/vagrant-fsnotify) enhances VirtualBox shared folders by forwarding filesystem change notifications to your Vagrant VM.

1. Run the command `vagrant up` to download and initialize the Vagrant box specified in the Vagrantfile you downloaded. BEWARE! This command (1) may take a long time to complete, (2) downloads a big file (~700MB), and (3) performs at least one processor-intensive compilation (of Ruby). Once this command completes, you will have a running Ubuntu Linux VM (headless). **However, the fsnotify plugin will tie up the current terminal window, and you will need a second terminal window in the workspace folder to run additional commands.**

## 3. Testing the Environment

1. From a second terminal window in the workspace folder, run the command `vagrant ssh` to SSH into the Linux VM. A command prompt should appear that looks like this: `[vagrant@ubuntu1804:~]` followed by a `$` prompt. If you use the `ls -l` command, you will see a list of files in the current directory. Among them should be a `workspace` folder (actually a symbolic link to the folder `/vagrant`).

1. Change directory (using the `cd` command) to the `workspace` folder. Note that this folder is synced with the `workspace` folder on the host OS. That is, changes made in the folder on one side (VM or host OS) are instantly visible on the other side.

1. Enter the command `git clone https://github.com/kbridson/rails6demo.git` to use Git to download an example project. A `rails6demo` folder should be visible inside the `workspace` folder. Note that the `workspace` folder is synced with the host OS, so the `rails6demo` folder should also be visible in the host OS's file explorer. The main reason for syncing this folder is that it will enable the use a GUI code editor (VS Code) to work on the code files.

1. Change directory (using the `cd` command) to the `rails6demo` folder. When you run this command, RVM should print a message, which lets you know it's working.
    <span><a class="text-muted" data-toggle="collapse" href="#moreDetails" role="button" aria-expanded="false" aria-controls="moreDetails">More details...</a></span>

    <div class="collapse" id="moreDetails">
        <p class="text-muted mr-3 ml-3">
            If no such message appears, then something is wrong. A common problem is that the terminal application is not configured to run as a "login" shell. This issue seems to come up the most for Linux users, or users of more exotic terminal applications. Typically, the solution can be found in the terminal application's settings.
        </p>
    </div>

1. Run these four commands to set up the web app project (i.e., prepare it to run). The first two commands may take a while to complete because they download and install a lot of content.
    - `bundle install`
    - `yarn install`
      - _For Windows users, if attempting to run `yarn install` throws symlink errors, you will need to complete some additional steps here._
      1. _Enter the command `exit` to log out of the VM._
      1. _Switch to the first terminal window and press Ctrl-C to stop the fsnotify plugin._
      1. _Enter the command `vagrant halt` to shutdown the VM. You will now be able to type commands on the host._
      1. _Open a command prompt with administrative privileges inside the workspace folder and enter the command `fsutil behavior set SymlinkEvaluation L2L:1 R2R:1 L2R:1 R2L:1`. Verify that has completed correctly with `fsutil behavior query symlinkevaluation` (all should be valid)._
      1. _Restart your VM and attempt to run `yarn install` again. It should complete with no errors._
    - `rails db:reset`

1. The project comes with some automated tests. Run the command `rails test` to execute the tests. You should see that all the tests passed.

1. Start up the Rails web app server with the command `rails s -b 0.0.0.0` (those are zeros). You should see that the server has started without error. Note that this command will not "return" like other commands—that is, the command prompt will not reappear until you halt the server process (covered below).

1. Now open the URL <http://localhost:3000> in a web browser.  You should see a "Welcome to Quiz Maker" web page with a list of quizzes.

1. Start pgAdmin 4. In the left sidebar, go to Servers > Vagrant > Databases > default_development > Schemas > public > Tables. Right click on `quizzes` and go to View/Edit Data > All Rows. You should see the Data Output panel in the bottom right corner of the screen showing information about all the quizzes in the application.

1. To further test out the web app, log in and create a new quiz. Follow the `Sign In` link at the top right and log in with the email `alice@email.com` and the password `password`. Click the `Create New Quiz` link and enter a title and description for a quiz. In your pgAdmin browser window, you can see the new quiz in the database by hitting the refresh button (F5 or the lightning bolt button). You can then add questions to the quiz by going to `Edit Quiz` link or return to the list of quizzes by clicking `Quizzes` at the top of the page.

## 4. Shutting Everything Down

To shut down everything:

1. Back in the terminal, type Ctrl-C to kill the Rails server (that is, press and hold the Ctrl key and then click the 'C' key).
1. Enter the command `exit` to logout of the VM.
1. Enter the command `vagrant halt` to shut down the VM.

To restart the VM, run `vagrant up` to start it up (should be much faster than last time) and run `vagrant ssh` in a new terminal to log in again.
