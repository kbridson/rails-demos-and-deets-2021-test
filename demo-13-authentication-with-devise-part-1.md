---
layout: page
title: 'Demo 13: Authentication with Devise (Part 1)'
permalink: /demo-13-authentication-with-devise-part-1/
---

# {{ page.title }}

In this demonstration, I will show how to install and setup the Devise gem for user authentication.

## 1. Install and Setup Devise

1. Add the Devise gem to the QuizMe project by adding the following to the end of the `Gemfile`:

    ```ruby
    # Authentication
    gem 'devise'
    ```

1. Run `bundle install`.

1. Run `rails generate devise:install`.

    After running the install, you should see this console message:

    ```shell
    Some setup you must do manually if you haven't yet:

      1. Ensure you have defined default url options in your environments files. Here
        is an example of default_url_options appropriate for a development environment
        in config/environments/development.rb:

          config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

        In production, :host should be set to the actual host of your application.

      2. Ensure you have defined root_url to *something* in your config/routes.rb.
        For example:

          root to: "home#index"

      3. Ensure you have flash messages in app/views/layouts/application.html.erb.
        For example:

          <p class="notice"><%= notice %></p>
          <p class="alert"><%= alert %></p>

      4. You can copy Devise views (for customization) to your app by running:

          rails g devise:views
    ```

    We aren't going to be deploying the app, so we can ignore #1. We have already completed #2 and #3 in previous demos. 

1. Run `rails g devise:views` and look at the created files. The most important ones are `devise/registrations/new.html.erb` (sign up) and `devise/sessions/new.html.erb` (sign in). 

1. Add a User class to work with Devise by running `rails generate devise User`.

    Look at the created migration and model. Also, look at the statement that was added to the routes file. You can run `annotate --routes` to see all the Devise routes that were added and their named path helpers. The most important ones you will use are `new_user_session` (sign in page), `destroy_user_session` (sign out), and `new_user_registration` (sign up page).

1. Run `rails db:migrate`.

## 2. Using the New Devise Helpers

Most websites have some kind of navbar on most pages of their site with links to commonly used actions like sign in, sign up, and the common pages of their app. It also can have different links in it depending on if the user is signed in. Although we don't have the fancy Bootstrap navbar yet, we can add the links to `application.html.erb` to have them appear on all pages. If the user is not logged in, we want to show links to "Sign In" and "Sign Up". If the user is logged in, we want to show their email and a link to "Sign Out".

1. Add the following code at the top of the `<body>` tag in `application.html.erb`:

    ```erb
    <ul>
      <% if user_signed_in? %>
        <li>
          <%= link_to "Hi, #{current_user.email}", edit_user_registration_path %>
        </li>
        <li>
          <%= link_to 'Sign Out', destroy_user_session_path, method: :delete %>
        </li>
      <% else %>
        <li>
          <%= link_to 'Sign In', new_user_session_path %>
        </li>
        <li>
          <%= link_to 'Sign Up', new_user_registration_path %>
        </li>
      <% end %>
    </ul>
    ```

1. Try using the new links you added by signing up with an email and password, seeing how the links change once you are logged in, and logging out and back in.

## 3. Restricting Permissions for Unauthenticated Users

Now we have the ability for users to log in, we can start restricting functionality of the app to only logged in users. Specifically, the only pages we want people to view without logging in are the home page and the about page.

We can use the `before_action :authenticate_user!` helper from Devise in our controllers to require that a user be logged in before they can use the actions we specify.

1. Restrict all actions in the StaticPages Controller, except welcome and about:

    ```ruby
    before_action :authenticate_user!, except: [:welcome, :about]
    ```

1. Restrict all actions in the other controllers by adding the following to each:

    ```ruby
    before_action :authenticate_user!
    ```

Try to view the pages of the app now without being signed in. You should be redirected to the sign in page when trying to view the restricted pages.