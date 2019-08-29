---
layout: page
title: 'Demo 4: Adding (Mostly Static) View Pages in Rails'
permalink: /demo-04-rails-static-pages/
---

# Demo 4: Adding (Mostly Static) View Pages in Rails

In this demonstration, I will show how to create mostly static webpages in Rails. I will continue to work on the _QuizMe_ project from the previous demos. Specifically, I will be making this [welcome page](/resources/welcome-page.png).

This and all future demos will assume you are starting in the workspace folder on your virtual machine.

## 1. Adding a New Page

Based on the MVC model, there are three things needed to setup a page in a Rails project. You need a controller action (a function inside a controller file) which renders a html.erb view file containing the html code for the page. You also need a route in the routes.rb file which links the URL for the page with the controller action.

1. Create the controller and controller action and template view file using the following command:

    `rails g controller StaticPages welcome`

    You should see the files `app/controllers/static_pages_controller.rb`, `app/views/static_pages/welcome.html.erb` have been created along with some other files we will use later.

1. Looking at the `app/controllers/static_pages_controller.rb` file, a function, `welcome`, has been created but it is empty. Modify the generated controller action to explicitly render the `welcome.html.erb` view by adding a `respond_to` block with a `render` statement to match:

    ```ruby
    def welcome
      respond_to do |format|
        format.html { render :welcome }
      end
    end
    ```

    <div class="collapse" id="moreDetails1-2">
    <p class="text-muted mr-3 ml-3">
      The `respond_to` block allows you to specify different responses to generate based on the type of data the request is looking for. For now, the requests will only be expecting HTML responses, but common alternatives are Javascript and JSON.
    </p>
    </div>

1. Looking at the `app/config/routes.rb` file, a GET route to 'static_pages/welcome' has been created, meaning the URL for the page would be <http://localhost:3000/static_pages/welcome>. Instead, make the route to point to <http://localhost:3000/welcome> by editing it to match:

    ```ruby
    get 'welcome', to: 'static_pages#welcome', as: 'welcome'
    ```

    <span><a class="text-muted" data-toggle="collapse" href="#moreDetails1-3" role="button" aria-expanded="false" aria-controls="moreDetails1-3">More details...</a></span>

    <div class="collapse" id="moreDetails1-3">
    <p class="text-muted mr-3 ml-3">
      Route syntax looks a little confusing until you get the hang of it. The first part `get 'welcome'` means make a GET request to the URL formed by concatenating the site root (for now <http://localhost:3000>) with a slash `/` followed by the page specific path in quotes. The `to` option tells the router which controller and action should be used when it receives that request. The `as` option generates a named route helper methods `welcome_path` and `welcome_url` which you can use to link to a certain url instead of hard-coding it. Since the system root could change (for example, if the app was deployed to Heroku or was running on a port other than 3000), using the helpers is much better practice.
    </p>
    </div>

1. Now start the Rails server (`rails s -b 0.0.0.0`) and navigate to <http://localhost:3000/welcome> to check that the page displays. You should see some automatically generated text telling you what controller, controller action, and view file were used.

## 2. Adding Text HTML Content to a View

While the automatically generated view is a useful starting point, we need to customize the HTML to display the information we want. Remember we want to have this [welcome page](/resources/welcome-page.png).

You can keep the Rails server running and reload the page to view changes as you make them.

1. Start by replacing the generated text with a large heading that says "Welcome to QuizMe!", using the following code:

    ```html
    <h1>Welcome to QuizMe!</h1>
    ```

    > The `<h1>` tag is usually used for page titles and only once per page.

1. Add a description of the QuizMe app under the welcome header, using the following code:

    ```html
    <p>QuizMe is a free Quizlet style quizzing application that helps you learn by taking quizzes and trying to improve your scores.</p>
    ```

    > The `<p>` tag is used for blocks of paragraph text.

1. Finally, add a list of features the QuizMe app will have, using the following code:

    ```html
    <h2>Features</h2>

    <p>QuizMe allows users to:</p>

    <ul>
      <li>Choose from premade quizzes on a variety of topics</li>
      <li>Make your own quizzes to customize your learning</li>
      <li>Compare your scores with other users</li>
    </ul>

    <p>QuizMe also supports a variety of question styles like multiple choice and fill in the blank.</p>
    ```

    > The `<h2>` tag is usually used for the first level of subheadings.  
    > The `<ul>` tag is usually used for bulleted lists. The text for each bullet point must be enclosed in its own `<li>` tag. You can replace the `<ul>` tag with `<ol>` to make a numbered list.  

## 3. Adding an Image to a View Using Rails Helpers

Webpages with only unstyled text are not very nice to look at, so for now we will add a little color with a [quiz graphic](/resources/quiz-bubble.png). We will add additional style formatting to the app later.

1. Start by downloading the image file using the link above and save it to the project's `app/assets/images` folder. All files in the assets directory get compiled by the server and require Rails helper methods to reference the correct file.

1. Add the image to the page using the `image_tag` helper method by adding the following code to the top of the `welcome.html.erb` file:

    ```erb
    <%= image_tag "quiz-bubble.png", height: 300 %>
    ```

    The original size of the image is about 700x480px. You can scale it down but keep the original aspect ratio by only setting the height or the width option. The values are in pixels.

    > TODO: add more info on what <% %> and erb means.  
    > <% %> and <%= %> both execute Ruby code.  <%= %> will additionally render the return value into the html.

## 4. Adding Links to a View Using Rails Helpers

Instead of using the anchor (`<a>`) HTML tags for links, Rails provides the `link_to` helper to add links. Remember, Ruby code in the views must be enclosed in a `<% %>` or `<%= %>` block. 

1. Using the `link_to` helper, add a hyperlink on the word "Quizlet" to the Quizlet homepage by editing the QuizMe app description to match the following:

    ```erb
    <p>QuizMe is a free <%= link_to "Quizlet", "https://quizlet.com", target: "_blank" %> style quizzing application that helps you learn by taking quizzes and trying to improve your scores.</p>
    ```

    The format for the `link_to` helper is the text you want to display, the link destination, then any additional HTML options you need to add.

1. Add an About page to the QuizMe app by adding the following:

    - Setup the route to point to an about function in the StaticPagesController and to have the URL be <http://localhost:3000/about> by adding the following to `config/routes.rb`:

      ```ruby
      get 'about', to: 'static_pages#about', as: 'about'
      ```

    - Add the following about function to the StaticPagesController:

      ```ruby
      def about
        respond_to do |format|
          format.html { render :about }
        end
      end
      ```

    - Create a new file `app/views/static_pages/about.html.erb` and add the following:

      ```erb
      <h1>About</h1>

      <h2>The Authors</h2>

      <p>This site was created by Scott Fleming and Katie Bridson.</p>
      ```

    Navigate to the new page using the URL and make sure it displays correctly.

1. Now that we have more than one page in the app, we need to add links on each of the pages so users don't need to enter the URL to switch pages. We can add links to other pages in the app by using the named route helpers with the `link_to` helper with the following:

    - Add a link to the about page at the bottom of the welcome page with:

      ```erb
      <p><%= link_to "About", about_path %></p>
      ```

    - Add a link to the about page at the bottom of the welcome page with:

      ```erb
      <p><%= link_to 'Welcome', welcome_path %></p>
      ```

    Reload the page and confirm the links on both pages work correctly.

1. If you navigate to the site's root (<http://localhost:3000>), you'll notice it still has the old default Rails project page. We probably want this to be something more useful for our app like the welcome page. We can change what root routes to by adding the following at the top of the `config/routes.rb` file:

    ```ruby
    root to: redirect('/welcome', status: 302)
    ```

    > This statement means that whenever someone tries to go to <http://localhost:3000> they are automatically redirected to the welcome page URL via the route we previously made. If you didn't want to have a separate URL for the welcome page, you could point root directly to the controller action with `root to: 'static_pages#welcome'` and remove original welcome route. Then, in the `link_to` statement, you would use the `root_path` helper instead of `welcome_path`.
