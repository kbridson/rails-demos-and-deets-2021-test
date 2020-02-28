---
title: 'Adding Authentication with Devise'
---

# {{ page.title }}

In this demonstration, I will show how to add user authentication to a Rails web app using the [Devise gem](https://github.com/plataformatec/devise#readme). We will continue to build upon the _QuizMe_ project from the previous demos.

In particular, we will add sign-in and sign-up links at the top of all pages, as depicted in Figure 1.

{% include image.html file="devise_sign-in_links.png" alt="Screenshot of browser page" caption="Figure 1. Sign-in and sign-up hyperlinks that appear at the top of each page of the app when the user isn't signed in." %}

Clicking the sign-up link will take the user to a sign-up form, as depicted in Figure 2.

{% include image.html file="devise_sign-up_page.png" alt="Screenshot of browser page" caption="Figure 2. Devise sign-up form page." %}

Clicking the sign-in link will take the user to a sign-in form, as depicted in Figure 3.

{% include image.html file="devise_sign-in_page.png" alt="Screenshot of browser page" caption="Figure 3. Devise sign-in form page." %}

If a user (e.g., with email `homer@email.com`) signs in successfully, the sign-in/sign-up links at the top of the page will be replaced with a welcome message and sign-out link, as depicted in Figure 4.

{% include image.html file="devise_sign-out_links.png" alt="Screenshot of browser page" caption="Figure 4. User-greeting and sign-out hyperlinks that appear at the top of each page of the app when the user isn't signed in." %}

To implement this functionality, we will perform three main tasks:

1. Install and set up Devise, including generating a Devise `User` model class (as depicted in Figure 5) along with the sign-up and sign-in pages.
1. Create the sign-in/sign-out/sign-up hyperlinks.
1. Restrict access to controller actions to only users who are signed in.

{% include image.html file="user_model_class.svg" alt="Class diagram" caption="Figure 5. Model class design diagram showing the new Devise `User` model class. (Note that the Devise `User` class actually contains a few additional attributes to support Devise's inner workings; however, those attributes have been omitted here for clarity.)" %}

## 1. Installing and Setting Up Devise

Add the Devise gem to the QuizMe project by adding the following to the end of the `Gemfile`:

```ruby
# Authentication
gem 'devise'
```

Install the Devise gem by running this now-familiar command:

```bash
bundle install
```

Add Devise functionality to our project by running this command:

```bash
rails generate devise:install
```

After running this command, you should see this console message:

```text
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

We can ignore items 1–3. We aren't going to be deploying the app, so we can skip item 1. We have already completed items 2 and 3 in previous demos, so they can be skipped as well. However, we will next want to perform item 4.

Copy Devise view code (for purposes of customization) into our project by entering this command:

```bash
rails g devise:views
```

Note the generated view files. The most important ones are `devise/registrations/new.html.erb` (sign up) and `devise/sessions/new.html.erb` (sign in).

Add a `User` class to work with Devise by running by entering this command:

```bash
rails generate devise User
```

The command should generate a new migration (something like `db/migrate/20191113155313_devise_create_users.rb`) and a new model class (`app/models/user.rb`), and it should add the following declaration to `routes.rb`:

```ruby
devise_for :users
```

To see the complete list of routes, including the ones that this declaration generates, run this command:

```bash
rails routes
```

Of the Devise routes in the list, we will be using `new_user_session` (sign-in page), `destroy_user_session` (sign out), and `new_user_registration` (sign-up page).

Update the database schema based on the generated Devise migration by running this command:

```bash
rails db:migrate
```

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/3e141f0d5178dddc2ac01bd39764109f0a688080){:target="_blank"}**

## 2. Creating the Sign-In/Sign-Out/Sign-Up Links

In this task, we will add the sign-in/sign-up links that are shown for users who aren't signed in (see Figure 1) and the greeting/sign-out links that are shown for signed-in users (see Figure 4). Most websites have some kind of navbar with links to commonly used actions, like sign in, sign up, and sign up (among other things). We don't have a fancy [Bootstrap](https://getbootstrap.com/)-style navbar yet, but we will add one in an upcoming demo. For now, we will simply add the links to `application.html.erb`, so that they appear at the top on all pages.

As a first step, add the logic to conditionally display text depending on whether the user is signed in by adding the following code to the top of the `<body>` tag in `application.html.erb`:

```erb
<ul>
  <% if user_signed_in? %>
    <li>Hi, user</li>
    <li>Sign Out</li>
  <% else %>
    <li>Sign In</li>
    <li>Sign Up</li>
  <% end %>
</ul>
```

In the above code, the Devise API provides the `user_signed_in?` helper method, which returns `true` if the current user is signed in and returns `false` otherwise.

In the next steps, we replace the placeholders in the above code with the actual hyperlinks.

Replace the "Hi, user" placeholder with logic that displays the signed-in user's email address instead of "user", like this:

```erb
<li><%= "Hi, #{current_user.email}" %></li>
```

In the above code, the Devise API provides the `current_user` helper method, which returns a reference to the `User` object corresponding to the currently signed-in user.

Wrap the placeholder text with hyperlinks to the appropriate Devise page.

This code handles the links for signed-in users:

```erb
<li><%= link_to "Hi, #{current_user.email}", edit_user_registration_path %></li>
<li><%= link_to 'Sign Out', destroy_user_session_path, method: :delete %></li>
```

Note that the `edit_user_registration_path` and `destroy_user_session_path` methods come from the route `devise_for :users`. The `edit_user_registration_path` goes to a Devise page for editing the user's email and changing their password. The sign-out hyperlink is handled like the `destroy` action in previous demos (i.e., it sends an HTTP DELETE request instead of the usual GET request).

This code handles the links for anonymous (i.e., not-signed-in) users:

```erb
<li><%= link_to 'Sign In', new_user_session_path %></li>
<li><%= link_to 'Sign Up', new_user_registration_path %></li>
```

Similar to above, the `new_user_session_path` and `new_user_registration_path` methods come from the `devise_for :users` route and return paths to Devise sign-in and sign-up pages, respectively.

Try using the new links you added by signing up with an email and password, seeing how the links change once you are logged in, and logging out and back in.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/770db830f6c08c5f63f22543a7ae072db30c6de9){:target="_blank"}**

## 3. Restricting Access to Controller Actions to Signed-In Users Only

Now that users have the ability to sign into the app, we can start restricting functionality of the app to only signed-in users. Specifically, the only pages we want people to view without logging in are the `home` page and the `about` page.

We can use the `before_action :authenticate_user!` helper from the Devise API in our controllers to require that a user is signed in before they can use the actions we specify.

Restrict access to all actions in the `StaticPagesController` class, except `welcome` and `about` by inserting this declaration before the first method in the class definition:

```ruby
before_action :authenticate_user!, except: [:welcome, :about]
```

Restrict all actions in the other controllers by adding the following declaration before the first method of each controller class definition:

```ruby
before_action :authenticate_user!
```

Try to view the pages of the app now without being signed in. The app should redirect you to the sign-in page when you try to view the restricted pages.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/db0c329fdfed90c691c15a27a98b99dc0a233937){:target="_blank"}**

{% include pagination.html prev_page='demo-has-many-forms.md' next_page='demo-authorization.md' %}
