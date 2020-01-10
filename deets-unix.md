---
title: 'Unix Shell Command-Line'
---

# {{ page.title }}

This page will give a quick overview of the command-line interface used in the Rails-development demos. The following is intended to be a brief introduction to help get readers new to such interfaces started. For deeper treatments of the topic, we proved helpful resources at the end of the page.

Command-line interfaces are very widely used in software development environments—and with good reason! Terminal apps, like the one depicted in Figure 1, enable users to enter textual commands into a command-line interface to perform a host of development tasks. In particular many platforms, frameworks, and toolkits (including Rails) provide their core functionality via a command-line interface.

TODO figure

Although different flavors of command-line interfaces exist, the demos will use the Unix Shell command-line interface (specifically Bash/Z Shell), which is arguably the most popular for Rails development.

## Anatomy of a Typical Command-Line Interface and UNIX Command

TODO

TODO figures (prompt; example command; enter/output)

## Directory Tree Structure

Interactions with a Unix shell take place in the context of a Unix file system. The Unix file system is generally made up of directories (or _folders_), text files (e.g., source code), and binary files.

When interacting with a shell, the user is always "in" some directory (or _folder_) in the file system. This directory is referred to as the _current working directory_ (also sometimes _present working directory_).

Parent/child relationships.

Root directory `/`

Home directory `~`

Parent directory `..`

Path separator `/`

## Inspecting and Changing the Current Working Directory

`pwd`
: Report the path of the current (aka _present_) working directory.

`ls`
: List the contents of the current working directory.

`cd`
: Change directory.

| Example Command | What It Does |
| --------------- | ------------ |
| `cd` | Change the working directory to the home directory. |
| `cd foo/` | Change the working directory to the directory named `foo` within the current working directory. |
| `cd ../` | Change the working directory to the parent directory of the current working directory. |

## Manipulating Files

`mkdir`
: Make a directory.

`cp`
: Copy a file.

`mv`
: Move a file.

`rm`
: Remove a file.

`touch`
: Touch a file to update its modification timestamp.

`nano`
: Command-line text editor.

## Productivity Features

### Quickly Accessing Previous Commands in the Command History

### Tab Completion to Speed Up Typing
