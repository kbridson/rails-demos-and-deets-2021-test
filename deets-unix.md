---
title: 'Unix Shell Command-Line'
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

This page will give a quick overview of the command-line interface used in the Rails-development demos. The following is intended to be a brief introduction to help get readers new to such interfaces started. For deeper treatments of the topic, we provide helpful resources at the end of the page.

Command-line interfaces are very widely used in software development environments—and with good reason! Terminal apps (like [Windows Terminal](https://en.wikipedia.org/wiki/Windows_Terminal), [macOS Terminal](https://en.wikipedia.org/wiki/Terminal_(macOS)), and [Linux Gnome Terminal](https://en.wikipedia.org/wiki/GNOME_Terminal), just to name a few) enable users to enter textual commands into a command-line interface to perform a host of development tasks. In particular, many platforms, frameworks, and toolkits (including Rails) provide their core functionality via a command-line interface.

Although different flavors of command-line interface exist, the demos will use the Unix Shell command-line interface (specifically [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))/[Z Shell](https://en.wikipedia.org/wiki/Z_shell)), which is arguably the most popular for Rails development.

## Typical User–Shell Interaction

Interactions with a Unix shell command-line interface goes something like this. The shell provides a prompt that might look something like this:

```text
$ ▊
```

Prompts are customizable, so they may look very different than this.

Users can type commands after the prompt, like this:

```text
$ ls -l▊
```

In this case, the user has typed the command `ls -l`, which displays a detailed file listing. If the user presses the Enter key, the command will run, producing output, like this:

```text
$ ls -l
total 6.5K
drwxrwxr-x+ 77 root admin 2.5K Jan 15 09:34 Applications
drwxr-xr-x+ 69 root wheel 2.2K Jan 14 11:19 Library
drwxr-xr-x   2 root wheel   64 Feb 25  2019 Network
drwxr-xr-x+  5 root wheel  160 Mar 19  2019 System
drwxr-xr-x   3 root wheel   96 Aug  9  2017 Tools
drwxr-xr-x   6 root admin  192 Nov  4 15:17 Users
drwxr-xr-x+  3 root wheel   96 Jan 16 11:33 Volumes
$ ▊
```

Note that once the command completes, another prompt is offered, so that the user can enter their next command.

## Command Syntax

At its most basic, Unix command syntax is a command token followed by an arbitrary number of whitespace-separated argument tokens. All tokens are strings. Since whitespace is used to separate arguments, a string token itself generally may not contain embedded whitespace characters; otherwise, it will will be interpreted as multiple tokens. If you have an argument that must contain whitespace (e.g., because it's a filename that contains whitespace), then either the argument must be surrounded by quotes or the whitespace characters must be escaped (e.g., "`\ `"). Here are some examples of the `cat` command with varying numbers and types of arguments.

| Example Command | Explanation |
| --------------- | ----------- |
| `cat aaa.txt` | In this example, the `cat` command is given one argument, `aaa.txt`. |
| `cat aaa.txt bbb.txt` | In this example, the `cat` command is given two arguments, `aaa.txt` and `bbb.txt`. |
| `cat aaa.txt bbb.txt ccc.txt` | In this example, the `cat` command is given three arguments. |
| `cat 'filename with spaces.txt'` | In this example, the `cat` command is given one argument. Because that argument contains spaces, it is surrounded by single quotes. |
| `cat "filename with spaces.txt"` | Same as the previous example, except using double quotes instead of single quotes. (Either one is OK to use.) |
| `cat filename\ with\ spaces.txt` | Same as the previous example, except escaping each embedded space character instead of surrounding the whole argument with quotes. |
| `cat aaa.txt x\ x\ x.txt "y y y.txt" zzz.txt` | In this example, the `cat` command is given four arguments. Can you tell what they are? |

In addition to this basic syntax, there are several common syntactic patterns that Unix shell commands employ.

One such common pattern are _dash options_. Dash options are arguments with a form like this: `-a`, `-b`, `-c`, etc.

| Example Command | Explanation |
| --------------- | ----------- |
| `ls -l` | The `ls` command may be called with a `-l` option that makes the command produce more-detailed output. |
| `ls -a` | `ls` may also be called with a `-a` option that makes the command output include hidden files. |
| `ls -a -l` | Multiple dash options may be used for a single command. |
| `ls -al` | For single-letter dash options, multiple options may also be combined together as a single dash option. |
| `ls --all` | For each option, Unix commands often have a single-letter dash option and a corresponding longer double-dash version. For example, the `ls` option `-a` may also be expressed as `--all`.
| `ls -a -l foo bar` | Dash options may be used in combination with other sorts of arguments. For example, this command has two dash options (`-a` and `-l`) and two string arguments (`foo` and `bar`). |

## Directory Tree Structure

Interactions with a Unix shell take place in the context of a Unix file system. The Unix file system is generally made up of directories (or _folders_), text files (e.g., source code), and binary files (e.g., image files).

The directory structure is generally organized as a tree. Each directory is contained within a parent directory and may itself contain child directories. A directory may also contain text and binary files. For example, the following is part of the directory tree for the `app` directory of a Rails project:

```text
app
├── assets
│   ├── config
│   │   └── manifest.js
│   ├── images
│   │   └── quiz-bubble.png
│   └── stylesheets
│       ├── account_quizzes.scss
│       ├── application.scss
│       ├── mc_questions.scss
│       ├── quiz_mc_questions.scss
│       ├── quizzes.scss
│       └── static_pages.scss
...
```

Note how the `assets` directory is contained within the `app` parent directory and has three child directories, `config`, `images`, and `stylesheets`. Also, note the text files (i.e., with `.js` and `.scss` suffixes) and the binary image file, `quiz-bubble.png`.

The entire Unix filesystem directory tree originates from a single _root directory_, which is denoted as `/`.

Each registered user of the system has a _home directory_ somewhere in the filesystem directory tree. The home directory is denoted as `~`. Where home directories are located depends on the OS. In Linux, they are often in the `/home` directory (e.g., `/home/alice`). In macOS, they are in the `/Users` directory (e.g., `/Users/alice`).

## Expressing File Paths

When interacting with a shell, the user is always "in" some directory in the file system. This directory is referred to as the _current working directory_ (also sometimes _present working directory_). Generally, a user's home directory set as the current working directory when a user logs into the system.

Shell commands often take a file or directory as part of their arguments. To illustrate, the following are some examples of different ways to express file paths using the `ls` (directory listing) command. Assume that the examples take place in the context of this directory tree:

```text
aaa
├── bbb
│   ├── ddd
│   ├── eee
│   │   └── hhh
│   └── fff
└── ccc
    └── ggg
```

Also, assume that current working directory is the `bbb` folder in the above directory tree.

| Example Command | Explanation |
| --------------- | ----------- |
| `ls ddd` | List the contents of the `ddd` child directory within the current working directory (`bbb`). "`ddd`" in this case is a relative path because its position is relative to the current directory. |
| `ls ddd/` | Same as the previous example. In this case, the `/` just clarifies that `ddd` should be a directory (and not a file). Putting a `/` after a directory name like this is generally optional. |
| `ls ./ddd` | Same as the previous example. In this case, `.` is used to explicitly denote the current working directory. Also note that `/` is used as separator between elements of the path. |
| `ls eee/hhh` | List the contents of `hhh`, which is a subdirectory of `eee`, which in turn is a subdirectory of the current working directory (`bbb`). |
| `ls ..` | List the contents of the parent directory (`aaa`) of the current working directory (`bbb`). |
| `ls ../..` | List the contents of the parent of the parent of the current directory. |
| `ls ../ccc` | List the contents of `ccc`, which is a subdirectory of the parent directory (`aaa`) of the current working directory (`bbb`). |

All of the above example paths are considered _relative paths_ because they are all expressed in a way that is relative to the current working directory.

In contrast to relative paths, _absolute paths_ always mean the same thing regardless of which directory is the current working directory. Such paths always start from a fixed location in the filesystem—for example, the root directory or the current user's home directory (`~`). Here are some examples that use absolute paths:

| Example Command | Explanation |
| --------------- | ----------- |
| `ls /aaa/bbb` | Assume that the `aaa` directory is contained within the root directory. List the contents of the `bbb` directory, which is a child of the `aaa` directory. Note that the first `/` denotes the root directory. |
| `ls ~/aaa/bbb` | Assume that the `aaa` directory is contained within the current user's home directory. List the contents of the `bbb` directory, which is a child of the `aaa` directory. Note that the `~` denotes the home directory. |

## Inspecting and Changing the Current Working Directory

The following are several common commands for inspecting and changing the current working directory.

- [`pwd`](https://en.wikipedia.org/wiki/Pwd): Report the path of the current (aka _present_) working directory.
- [`ls`](https://en.wikipedia.org/wiki/Ls): List the contents of the current working directory.
- [`cd`](https://en.wikipedia.org/wiki/Cd_(command)): Change the current working directory.

Here are some examples of common usages of these commands, including some of their commonly used options.

| Example Command | Explanation |
| --------------- | ----------- |
| `pwd -P` | List the absolute path to the current working directory. |
| `ls -a` | List all files in the current working directory, including hidden files. |
| `ls -l` | List all files in the current working directory, providing a "long" listing that includes permissions, etc. |
| `ls -l -a` | Combines the above two commands. |
| `cd` | Change the working directory to the home directory. |
| `cd foo` | Change the working directory to the directory named `foo` within the current working directory. |
| `cd ..` | Change the working directory to the parent directory of the current working directory. |
| `cd ~` | Change the working directory to the current user's home directory. |
| `cd /` | Change the working directory to the root directory of the filesystem. |

## Manipulating Files and Directories

The following are common commands for manipulating files and directories from the command-line.

- [`mkdir`](https://en.wikipedia.org/wiki/Mkdir): Make a directory.
- [`cp`](https://en.wikipedia.org/wiki/Cp_(Unix)): Make a copy of a file or directory.
- [`mv`](https://en.wikipedia.org/wiki/Mv): Move (or rename) a file or directory.
- [`rm`](https://en.wikipedia.org/wiki/Rm_(Unix)): Remove a file.
- [`cat`](https://en.wikipedia.org/wiki/Cat_(Unix)): Outputs the contents of text files. If multiple files are listed, the output effectively concatenates them, which is why the command is called `cat` (short for _concatenate_).
- [`nano`](https://en.wikipedia.org/wiki/GNU_nano): Launch a basic command-line text editor.

Here are some examples of common usages of these commands, including some of their commonly used options.

| Example Command | Explanation |
| --------------- | ----------- |
| `mkdir foo` | Make a directory named `foo` in the current working directory. |
| `cp a.txt b.txt` | Make a copy of the file `a.txt` in the current working directory, and save the copy as `b.txt` (also in the current working directory). |
| `cp a.txt foo/` | Make a copy of the file `a.txt` in the current working directory, and save the copy (using the same filename) in the subdirectory `foo`. |
| `cp -a foo bar` | Make a copy of the folder `foo` (including all the folder's contents), and save the new folder as `bar`. Note that the `-a` option (short for _archive_) is needed when copying a directory. |
| `mv a.txt b.txt` | Rename the file `a.txt` to `b.txt` |
| `mv a.txt foo/` | Move the file `a.txt` from the current working directory into the subdirectory `foo`. |
| `rm a.txt` | Remove (i.e., delete) the file `a.txt` from the current working directory. |
| `rm -r foo` | Remove (i.e., delete) the directory `foo` and all its contents. Note that the `-r` option is needed when the target is a directory. |
| `cat a.txt` | Outputs the contents of file `a.txt`. |
| `nano a.txt` | Opens the file `a.txt` in a command-line text editor. Note the special key commands listed at the bottom of the terminal. For example, Ctrl-X (denoted `^X`) will exit the editor, giving the user the option to save their changes. |

## Finding Documentation on Commands

There are several ways that users commonly find documentation on commands. (Unfortunately, this can be a bit inconsistent depending on who created the command.)

Firstly, googling is often your best option to figure out what command will perform a certain function.

If you think you know the command you need, but want to find out what options, there are several ways to go about it.

For the commands mentioned above, which the standard file-management commands in Unix, the [`man` command](https://en.wikipedia.org/wiki/Man_page) (short for _manual_) is probably your best bet:

```bash
man ls
```

The above example will open a documentation viewer in your terminal for the command `ls`. You can scroll up and down in the documentation using the up- and down-arrow keys. To exit the viewer, enter `q` (short for _quit_).

For other commands, there may not be a good `man` page; however, there are some other common ways to find documentation.

One such way is that many commands offer a help option (`-h` and/or `--help`), for example:

```bash
ls --help
```

This command will cause `ls` to print usage documentation.

One final way often works for certain commands (e.g., `git` and `rails`) that expect a sub-command as their first argument, for example:

```bash
git help
```

This command will cause `git` to display general help documentation.

Furthermore, the `help` sub-command can often be followed by a specific sub-command, like this:

```bash
git help commit
```

This command will cause `git` to display documentation specifically about its `commit` sub-command.

## Productivity Features

Finally, there are two productivity features common to shells/terminals that you will **definitely** want to train yourself to use.

### Quickly Accessing Previous Commands in the Command History

From the terminal prompt, hitting your up- and down-arrow keys will cycle through your command history. It is very common to enter the same (or almost the same) commands over and over, and this shortcut will save you a lot of time and typing.

### Tab Completion to Speed Up Typing

When entering file paths as arguments to commands, you can use the Tab key to autocomplete directory and filenames. For example, imagine that a user starts to type a command, like this:

```text
$ ls f▊
```

If the user now hits the Tab key, the shell will look for all the files in the current working directory that start with `f`. If there's only one such file, it will automatically fill in that file's name for the user, like this:

```text
$ ls foo▊
```

If there are multiple such files, then the terminal will blink/beep at you, and you'll have to add enough characters to disambiguate which file you want.

Similar to the up-arrow shortcut, this [Tab completion](https://en.wikipedia.org/wiki/Command-line_completion) feature will save you tons of time and typing.

## Helpful Resources

As the above document was just intended as a practical introduction, you may want to explore these other resources to learn more details about how Unix shells work and how to use them effectively.

- [Wikipedia List of Unix commands](https://en.wikipedia.org/wiki/List_of_Unix_commands)
- [Learn the Command Line Codecademy Course](https://www.codecademy.com/learn/learn-the-command-line)

_Suggestions for other helpful resources are welcome!_
