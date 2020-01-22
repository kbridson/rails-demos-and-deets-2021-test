---
title: 'Setting Up a New Github Project Repository'
---

# {{ page.title }}

In this demonstration, I will show you how to create and upload an existing project to a new Github repository.

1. Log in to Github (<https://www.github.com/>) with the username and password you previously created.

1. From the homepage, click on `New` under the Repositories heading in the left sidebar panel.

1. In the `Create a new repository` form, enter a repository name. Usually this will be the same as the project folder name. For this project, the repository name should be "`quiz-me`". Then, click the `Create repository` button, and you will be taken to the main page for your new empty repository.

1. Create an initial project commit (a snapshot of the current project state) by entering the following commands:

    ```bash
    git add -A
    git commit -m "Initial commit"
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails0-5" role="button" aria-expanded="false" aria-controls="moreDetails0-5">More about these Git commands...▼</a></small></span>

    <div class="collapse" id="moreDetails0-5">
    <p class="text-muted mr-3 ml-3">
    The <code>git add</code> and <code>git commit</code> commands will be run often as you are making changes to your projects and want to save them to the online repository. The <code>git add</code> command adds a change in the working directory to the staging area. It tells Git that you want to include updates to a particular file in the next commit. The <code>-A</code> option tells Git to include all changes to all files in the project folder. You can view the contents of the staging area with the <code>git status</code> command. The <code>git commit</code> command creates the snapshot and saves it to your local repository. Each commit will have a default commit message that you can override with the <code>-m "$MSG"</code> option to make a more informative description of the changes in that commit.
    </p>
    </div>

    Verify the commit has the correct information by entering the following command:

    ```bash
    git log
    ```

1. Copy the instructions on the GitHub repository webpage for pushing an existing repository from the command line, and paste them into your terminal. The commands should look something like this (only with the "`...`" replaced with your GitHub username):

    ```bash
    git remote add origin https://github.com/.../quiz-me.git
    git push -u origin master
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails0-6" role="button" aria-expanded="false" aria-controls="moreDetails0-6">More about these Git commands...▼</a></small></span>

    <div class="collapse" id="moreDetails0-6">
    <p class="text-muted mr-3 ml-3">
    The <code>git remote</code> command is used configure your local repo to know about remote repos. In this case, it sets the name "<code>origin</code>" to correspond to the remote repo at <code>https://github.com/.../quiz-me.git</code>.
    </p>
    <p class="text-muted mr-3 ml-3">
    The <code>git push</code> command is used upload and merge local commits into a remote repo. In this case, the local commits are sent to the remote repo named "<code>origin</code>", which was set to correspond to the GitHub repo in the previous command. The word "<code>master</code>" in the command refers to the <code>master</code> branch in the local repo, which is the only branch we currently have and was created by default by Git. The "<code>-u</code>" flag is only used once, the first time a local branch is pushed to a remote repo. In short, its purpose is to configure the local repo to know that the local branch is a "tracking branch" with respect to the remote branch (i.e., that the branches have a direct relationship). For subsequent pushes from the <code>master</code> branch, we will need only to enter the command <code>git push</code> (without the additional arguments), and Git will know exactly what we mean.
    </p>
    </div>

1. Verify that the push was successful by refreshing the Github project page, which should now display the project file structure.

The project repository is now hosted on GitHub!

{% include pagination.html prev_page='demo-new-rails-project.md' %}
