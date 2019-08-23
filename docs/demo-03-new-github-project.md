# Demo 2: Setting Up a New Github Project Repository

[**▶️ Play from the beginning**](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=0s) (~30 minutes)

In this demonstration, I will show you how to create and upload an existing project to a new Github repository.

This and all future demos will assume you are starting in the workspace folder on your virtual machine.

## [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=1m30s) 1. Create a New Github Repository

1. [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=1m33s) Login to Github (<https://www.github.com/>) with the username and password you previously created.

1. [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=2m02s) From the homepage, click on `New` under the Repositories heading in the left sidebar panel.

1. [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=3m18s) In the "Create a new repository form", enter a repository name. Usually this will be the same as the project folder name. For this project, the repository name should be "quiz-me". Then, click the "Create repository" button and you will be taken to the main page for your new empty repository.

## [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=1m30s) 1. Push an Existing Project to an Empty Github Repository

1. [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=4m45s) Setup your Github account information globally for your VM by entering the following commands, replacing the variables (beginning with $) with your information:

    ```Powershell
    git config --global user.name "$FIRST_NAME $LAST_NAME"
    git config --global user.email "$GITHUB_EMAIL"
    ```

1. [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=4m45s) Create an initial project commit (a snapshot of the current project state) by running the commands `git add -A` and `git commit -m "Initial commit"`. You can verify the commit has the correct information by running `git log`.

    > _The `git add` and `git commit` commands will be run often as you are making changes to your projects and want to save them to the online repository. The `git add` command adds a change in the working directory to the staging area. It tells Git that you want to include updates to a particular file in the next commit. The `-A` option tells Git to include all changes to all files in the project folder. You can view the contents of the staging area with the `git status` command. The `git commit` command creates the snapshot and saves it to your local repository. Each commit will have a default commit message that you can override with the `-m "$MSG"` option to make a more informative description of the changes in that commit._

1. [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=4m45s) Follow the instructions on the repository main page for pushing an existing repository from the command line, which are to enter the following commands inside the project folder on your VM:

    ```Powershell
    git remote add origin https://github.com/kbridson/quiz-me.git
    git push -u origin master
    ```

    > _TODO: explanation_

1. [▶️](https://www.youtube.com/watch?v=EkAeZrr_5gk&list=PL0s90BggiDzyveaaQjXBYOAkLpTxk_pTo&index=2&t=4m45s) Go to Github project page which should now have the project file structure.
