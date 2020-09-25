---
title: 'Setting Up Windows Subsystem for Linux (WSL) and Windows Terminal'
---

# {{ page.title }}

## 1. Enable Developer Mode

Open the Settings app and click `Update & Security` as seen in Figure 1.

{% include image.html file="wsl/1_Settings.PNG" alt="Settings app" caption="Figure 1. Windows Settings app" %}

In the left menu, click `For developers` as seen in Figure 2.

{% include image.html file="wsl/2_fordevelopers.PNG" alt="For developers" caption="Figure 2. For developers in Update & Security" %}

Enable Developer mode as seen in Figure 3.

{% include image.html file="wsl/3_click_developers.PNG" alt="Developer mode" caption="Figure 3. Developer mode" %}

Accept the confirmation as seen in Figure 4.

{% include image.html file="wsl/4_accept_confirmation.PNG" alt="Developer mode confirmation" caption="Figure 4. Developer mode confirmation" %}

Wait for the Developer Mode package to install as seen in Figure 5.

{% include image.html file="wsl/5_wait_for_install.PNG" alt="Searching for Developer Mode package" caption="Figure 5. Searching for Developer Mode package" %}

When Developer mode has been enabled, you should see something like Figure 6.

{% include image.html file="wsl/6_developer_enabled.PNG" alt="Developer mode enabled" caption="Figure 6. Developer mode enabled" %}

## 2. Enable Windows Subsystem for Linux

Open the Control Panel and click on Programs and Features as seen in Figure 7.

{% include image.html file="wsl/7_control_panel.PNG" alt="Control Panel" caption="Figure 7. Programs and Features in Control Panel" %}

Notice that the view setting is `Small icons`. If you are using the default view `Category`, you can click `Programs` then `Turn Windows features on or off` and skip the next step.

Click on `Turn Windows features on or off` as seen in Figure 8.

{% include image.html file="wsl/8_turn_features_on_off.PNG" alt="Turn Windows features on or off" caption="Figure 8. Turn Windows features on or off" %}

Scroll to the bottom and check the box for Windows Subsystem for Linux as seen in Figure 9.

{% include image.html file="wsl/9_WSL.PNG" alt="Windows Subsystem for Linux checkbox" caption="Figure 9. Windows Subsystem for Linux checkbox" %}

Click `Restart now` in the window that pops up as seen in Figure 10.

{% include image.html file="wsl/10_reboot.PNG" alt="Restart confirmation" caption="Figure 10. Restart confirmation" %}

## 3. Install Ubuntu Linux

After your computer has restarted, open the Microsoft Store app and search for `Ubuntu`. When the results appear, select the "Ubuntu" app as seen in Figure 11. Do not install one of the versioned Ubuntu apps.

{% include image.html file="wsl/11_ubuntu_on_store.png" alt="Find Ubuntu in Microsoft Store" caption="Figure 11. Find Ubuntu in Microsoft Store" %}

Click on `Install` as seen in Figure 12.

{% include image.html file="wsl/12_install_ubuntu.PNG" alt="Install Ubuntu" caption="Figure 12. Install Ubuntu" %}

When the installation completes, click on `Launch` as seen in Figure 13.

{% include image.html file="wsl/13_launch.PNG" alt="Launch Ubuntu" caption="Figure 13. Launch Ubuntu" %}

In the terminal that opens, enter a username and then a password that you will remember as seen in Figure 14.

{% include image.html file="wsl/15_setup_complete.PNG" alt="Ubuntu user setup" caption="Figure 14. Ubuntu root user setup" %}

You may close the terminal window when you are finished. You may reopen this terminal by starting the Ubuntu app, or you can go on to install the new `Windows Terminal` app (recommended).

## 4. Install the Windows Terminal App

In the Microsoft Store, search for the `Windows Terminal (Preview)` app, install it, and then launch it as seen in Figure 15.

{% include image.html file="wsl/16_terminal_in_store.PNG" alt="Terminal app in Microsoft Store" caption="Figure 15. Launch Windows Terminal from Microsoft Store" %}

Open a new WSL Ubuntu terminal by clicking the dropdown and selecting Ubuntu as seen in Figure 16.

{% include image.html file="wsl/17_terminal_ubuntu.PNG" alt="Open new Ubuntu terminal tab" caption="Figure 16. Open a new Ubuntu terminal tab" %}

You can also open other types of terminals like Powershell and the older Command Prompt.
