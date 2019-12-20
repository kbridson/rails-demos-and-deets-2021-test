---
title: 'Demo 7: Functional Testing of Static Pages'
---

# Demo 7: Functional Testing of Static Pages

In this demonstration, I will show how to write some basic automated test functions to make sure that the pages we have made are working the way we expect them to. Later on these tests will help us to make sure any changes we make later do not unexpectedly break any of the functionality we already have. I will continue to work on the _QuizMe_ project from the previous demos.

This and all future demos will assume you are starting in the workspace folder on your virtual machine.

## Controller Tests




1. Adding a New Page

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