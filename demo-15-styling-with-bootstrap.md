---
layout: page
title: 'Demo 15: Styling with Bootstrap'
permalink: /demo-15-styling-with-bootstrap/
---

# {{ page.title }}

In this demonstration, I will show how to style the existing pages of the QuizMe app using the [Bootstrap](https://getbootstrap.com/docs/4.3/getting-started/introduction/) library. I will focus on demonstrating how to complete certain tasks including creating a navbar, adding key specific colors to the flash messages, centering content on the page, adding cards, adding colors to text or backgrounds, and styling forms with errors on particular fields.

## Installing Bootstrap

This section has already been done in your project repos, so you can start using it immediately.

1. Add some yarn packages to the project including Bootstrap and its dependencies by running the console command:

    ```sh
    yarn add bootstrap jquery popper.js expose-loader bootswatch jquery-ui autosize
    ```

    - bootstrap library requires jquery and popper.js
    - bootswatch for bootstrap themes
    - expose-loader allows you to use jquery in your views
    - jquery-ui has some nice features (position)
    - autosize fits textarea to input content
    
1. Configure Webpacker by adding the following to `config/webpack/environment.js`:

    > (insert on line 2)

    ```js
    const webpack = require("webpack")

    environment.plugins.append("Provide", new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      "window.jQuery": "jquery'",
      "window.$": "jquery",
      Popper: ['popper.js', 'default']
    }))

    environment.config.merge({
      module: {
        rules: [
          {
            test: require.resolve('jquery'),
            use: [{
              loader: 'expose-loader',
              options: '$'
            }, {
              loader: 'expose-loader',
              options: 'jQuery'
            }]
          },
          {
            test: require.resolve('@rails/ujs'),
            use: [{
              loader: 'expose-loader',
              options: 'Rails'
            }]
          }
        ]
      }
    })
    ```

1. Add the following to the bottom of `app/javascript/packs/application.js`:

    ```js
    import 'bootstrap'
    import { autosize } from 'autosize'

    document.addEventListener("turbolinks:load", () => {
      $('[data-toggle="tooltip"]').tooltip()
      $('[data-toggle="popover"]').popover()
    })
    ```

1. Change app/assets/stylesheets/application.css to `application.scss`.

1. Import the Bootstrap css classes by adding the following to `application.scss`:

    ```scss
    @import "../node_modules/bootstrap/scss/bootstrap";
    ```

If you reload the QuizMe app now, you should see the fonts have changed.

## Adding a Bootwatch Theme

Bootswatch themes override the default colors, font, sizing, and look of the default Bootstrap classes. You can see examples of elements of each available theme on the [Bootswatch website](https://bootswatch.com/).

I will add the [Yeti](https://bootswatch.com/yeti) theme to the QuizMe project by importing the styles in `application.scss`:

    ```scss
     @import "../node_modules/bootswatch/dist/yeti/variables";
     @import "../node_modules/bootstrap/scss/bootstrap";
     @import "../node_modules/bootswatch/dist/yeti/bootswatch";
    ```

You can change which theme is used by replacing "yeti" with the theme name you want.

Once the theme has been added, you can reload the page to see the text styling has changed again.

## Adding a Navbar

The documentation for Bootstrap navbar is [here](https://getbootstrap.com/docs/4.3/components/navbar/).

In this section, we are going to turn the existing list of links at the top of every page (in the `<ul>` element) into a real navbar.

I am going to use the navbar templates provided [here](https://bootswatch.com/yeti/) and customize it to have the correct links.

1. Add the default navbar from the link above:

    ```erb
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
      <a class="navbar-brand" href="#">Navbar</a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarColor01">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item active">
            <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#">Features</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#">Pricing</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#">About</a>
          </li>
        </ul>
        <form class="form-inline my-2 my-lg-0">
          <input class="form-control mr-sm-2" type="text" placeholder="Search">
          <button class="btn btn-secondary my-2 my-sm-0" type="submit">Search</button>
        </form>
      </div>
    </nav>
    ```

1. Change the `navbar-brand` element to the name of the app:

    ```erb
    <a class="navbar-brand" href="#">QuizMe</a>
    ```

1. Replace the existing links in the `<ul>` element with:

    ```erb
    <ul class="navbar-nav mr-auto">
      <li class="nav-item active">
        <%= link_to 'Home', root_path, class: 'nav-link' %>
      </li>
      <li class="nav-item">
        <%= link_to 'About', about_path, class: 'nav-link' %>
      </li>
      <li class="nav-item">
        <%= link_to 'Contact', contact_path, class: 'nav-link' %>
      </li>
      <% if user_signed_in? %>
        <li class="nav-item">
          <%= link_to 'Quizzes', quizzes_path, class: 'nav-link' %>
        </li>
        <li class="nav-item">
          <%= link_to 'My Quizzes', account_quizzes_path, class: 'nav-link' %>
        </li>
      <% end %>
    </ul>
    ```

1. Replace the existing form element with another `<ul>` containing the Devise links:

    ```erb
    <ul class="navbar-nav">
      <% if user_signed_in? %>
        <li class="nav-item">
          <%= link_to "Hi, #{current_user.email}", edit_user_registration_path, class: 'nav-link' %>
        </li>
        <li class="nav-item">
          <%= link_to 'Sign Out', destroy_user_session_path, method: :delete, class: 'nav-link' %>
        </li>
      <% else %>
        <li class="nav-item">
          <%= link_to 'Sign In', new_user_session_path, class: 'nav-link' %>
        </li>
        <li class="nav-item">
          <%= link_to 'Sign Up', new_user_registration_path, class: 'nav-link' %>
        </li>
      <% end %>
    </ul>
    ```

The `active` class on a link is what highlights the link for the current page. If you load the page and try clicking on one the links other than Home, you will see the "Home" tab is still active and the current page is not. To fix this, we will conditionally add the `active` class to the link depending on the current page.

1. Add a helper method `active_class` to `application_helper.rb`:

    ```ruby
    def active_class(path)
      if request.path == path
        return 'active'
      else
        return ''
      end
    end
    ```

1. Add code to use the helper method to set the active class based on the path to each of the navbar links:

    ```erb
    <ul class="navbar-nav mr-auto">
      <li class="nav-item <%= active_class(welcome_path) %>">
        <%= link_to 'Home', welcome_path, class: 'nav-link' %>
      </li>
      <li class="nav-item <%= active_class(about_path) %>">
        <%= link_to 'About', about_path, class: 'nav-link' %>
      </li>
      <% if user_signed_in? %>
        <li class="nav-item <%= active_class(contact_path) %>">
          <%= link_to 'Contact', contact_path, class: 'nav-link' %>
        </li>
        <li class="nav-item <%= active_class(quizzes_path) %>">
          <%= link_to 'Quizzes', quizzes_path, class: 'nav-link' %>
        </li>
        <li class="nav-item <%= active_class(account_quizzes_path) %>">
          <%= link_to 'My Quizzes', account_quizzes_path, class: 'nav-link' %>
        </li>
      <% end %>
    </ul>
    <ul class="navbar-nav">
      <% if user_signed_in? %>
        <li class="nav-item <%= active_class(edit_user_registration_path) %>">
          <%= link_to "Hi, #{current_user.email}", edit_user_registration_path, class: 'nav-link' %>
        </li>
        <li class="nav-item <%= active_class(destroy_user_session_path) %>">
          <%= link_to 'Sign Out', destroy_user_session_path, method: :delete, class: 'nav-link' %>
        </li>
      <% else %>
        <li class="nav-item <%= active_class(new_user_session_path) %>">
          <%= link_to 'Sign In', new_user_session_path, class: 'nav-link' %>
        </li>
        <li class="nav-item <%= active_class(new_user_registration_path) %>">
          <%= link_to 'Sign Up', new_user_registration_path, class: 'nav-link' %>
        </li>
      <% end %>
    </ul>
    ```

1. Remove the simple `<ul>` list of links we made in previous demos and the links from the bottom of the welcome page.

## Centering Content

Let's continue improving the welcome page by centering the content.

### Centering a Text Element

We can center a single element containing text by adding the `.text-center` class. For example, let's center the text of the `<h1>` element on this page with:

    ```erb
    <h1 class="text-center">Welcome to QuizMe!</h1>
    ```

If we know we want all `<h1>` elements to be centered, we can set a global style for all the `<h1>` tags by adding some css to `application.scss` like:

    ```scss
    h1 {
      text-align: center;
    }
    ```

This global style will be set for heading tags on every page in the app.

### Centering an Element with Margin

We can horizontally center elements that don't contain text using the `.mx-auto` class. This class divides the empty whitespace around the element between the element's left and right margins, centering the element within its parent element.

For example, we can center the welcome page image by making the `<img>` element a block-level element and adding `.mx-auto`:

    ```erb
    <%= image_tag "quiz-bubble.png", width: 400, class: 'd-block mx-auto' %>
    ```

### Centering with Columns and Justify Content

You can read about Bootstrap's 12-column flexbox grid layout system [here](https://getbootstrap.com/docs/4.3/layout/grid/).

For most of the pages in QuizMe, we don't want multiple columns side-by-side, but we do want the content to be somewhat in the middle of the page with equal non-zero margins on both sides. We can achieve this by creating a single column that spans 8 of the 12 possible columns and, then, centering the entire column on the page (leaving 2 columns-width of space on each side).

We can achieve this by wrapping the `yield` statement in `application.html.erb` in a 3-layer div wrapper with the outermost div having `.container-fluid`, the second div having `.row` and `justify-content-center` and the innermost div having `col-8`. The code should be:

    ```erb
    <div class="container-fluid">
      <div class="row justify-content-center">
        <div class="col-8">
          <%= yield %>
        </div>
      </div>
    </div>
    ```

## Adding Flash Key Colors

Flash messages are typically styled with the `alert` class and one of the colored alert classes like `alert-success` (usually, green) or `alert-danger` (usually, red). We can add a helper method to automatically set the color class based on the key used for the message.

1. Add a `flash_class` helper method that links all flash key values used in the app to an appropriate color class:

    ```ruby
    def flash_class(level)
      bootstrap_alert_class = {
        "success" => "alert-success",
        "error" => "alert-danger",
        "notice" => "alert-info",
        "alert" => "alert-danger",
        "warn" => "alert-warning"
      }
      bootstrap_alert_class[level]
    end
    ```

    You can add more keys later if you need to. A list of all the alert color classes is found [here](https://getbootstrap.com/docs/4.0/components/alerts/). If you have a Bootswatch theme applied, the colors of each alert class will be different.

1. Replace the existing flash message display with:

    ```erb
    <% flash.each do |key, message| %>
      <div class="alert <%= flash_class(key) %> alert-dismissible fade show text-center" role="alert">
        <%= message %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% end %>
    ```

1. The alert text is slightly off-center. Fix this by adding the following to application.scss: 

    ```scss
    .alert-dismissible {
      padding-left: $close-font-size + $alert-padding-x * 2;
    }
    ```

    These variables are declared in the Bootstrap files in the node_modules folder, but we can use them in our scss files after the import statement.

## Bootstrap Cards

Bootstrap's cards provide stylish bordered content containers. You can read about all of their options [here](https://getbootstrap.com/docs/4.1/components/card/).

In the QuizMe app, we are going to use them to clean up the `quizzes#index` page by putting each quiz into a card container.

    ```erb
    <div id="<%= dom_id(quiz) %>">
      <div class="card container border-primary mb-3">
        <div class="card-header row justify-content-between text-white bg-primary">
          <h5 class='m-0'><%= quiz.title %></h5>
          <div>
            <%= link_to '🔎', quiz_path(quiz) %>
            <% if quiz.creator == current_user %>
              <%= link_to '🖋', edit_quiz_path(quiz) %>
              <%= link_to '🗑', quiz_path(quiz), method: :delete %>
            <% end %>
          </div>
        </div>
        <div class="card-body">
          <h6 class="card-subtitle mb-2 text-muted">By: <%= quiz.creator.email %></h6>
          <p class="card-text"><%= truncate quiz.description, length: 75, separator: ' ' %></p>
        </div>
      </div>
    </div>
    ```


## Styling Forms That Display Errors

Validation errors are added to an errors hash on the model object. We can determine if an object is invalid (has any validation errors) by checking if the errors hash is empty. We can also get the errors for a particular attribute using a key-based lookup in the errors hash.

In this section, we will add styling to the form to make the fields look nicer. Then, we can add attribute specific error messages and coloring to the form fields to make it clear to the users what errors they need to fix in their input. The documentation for the Bootstrap form classes is found [here](https://getbootstrap.com/docs/4.3/components/forms/).

Most importantly, the `<div>` containing the label and field elements should have `.form-group`. The input field should have `.form-control`. The submit button should have `.btn`, and probably one or more of the special button styling classes like `.btn-primary` for color or `.btn-block` for a full-width button. 

1. Add the appropriate Bootstrap classes to the `AccountQuizzes#new` view:

    ```erb
    <div class="form-group">
      <%= form.label :title %>
      <%= form.text_field :title, class: "form-control" %>
    </div>

    <div class="form-group">
      <%= form.label :description %>
      <%= form.text_area :description, size: "27x7", class: "form-control" %>
    </div>

    <%= form.submit "Add Quiz", class: "btn btn-block btn-primary" %>
    ```

    Notice we don't need the `<br>` tags between the label and field anymore.

Now we can add the attribute error indicators by:

1. Before the `.form-group` div, add a variable that checks if there are errors for the attribute:

    ```erb
    <% invalid = quiz.errors.include?(:title) %>
    ```

1. Use the invalid variable to add the `.is-invalid` class to the field if there are errors on the attribute:

    ```erb
    <%= form.text_field :title, class: "form-control #{'is-invalid' if invalid}" %>
    ```

1. Display the error messages for the attribute if there are any by adding the following to the end of the `.form-group` div:

    ```erb
    <% if invalid %>
      <div class="invalid-feedback d-block">
        <% quiz.errors.full_messages_for(:title).each do |error_message| %>
          <%= error_message %>.
        <% end %>
      </div>
    <% end %>
    ```

This process should be followed for each form field. For each one, you should have something like:

    ```erb
    <% invalid = quiz.errors.include?(:title) %>
    <div class="form-group">
      <%= form.label :title %>
      <%= form.text_field :title, class: "form-control #{'is-invalid' if invalid}" %>
      <% if invalid %>
        <div class="invalid-feedback d-block">
          <% quiz.errors.full_messages_for(:title).each do |error_message| %>
            <%= error_message %>.
          <% end %>
        </div>
      <% end %>
    </div>
    ```

Try creating an invalid quiz to see the new styling.
