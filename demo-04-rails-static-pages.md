---
layout: page
title: 'Demo 4: Adding (Mostly Static) View Pages in Rails'
permalink: /demo-04-rails-static-pages/
---

# Demo 4: Adding (Mostly Static) View Pages in Rails

In this demonstration, I will show how to create mostly static webpages in Rails. I will continue to work on the _QuizMe_ project from the previous demos.

## 1. Adding a New Page

We will start by making the welcome page depicted in Fig. 1.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/welcome-page.png" class="figure-img img-fluid rounded" alt="A web page that welcomes users to the QuizMe application.">
<figcaption class="figure-caption">Fig 1. The QuizMe welcome page.</figcaption>
</figure>
</div>

Based on the Rails MVC model, there are three things needed to set up a page in a Rails project. You need (1) a controller action (a public method inside a controller class) which renders (2) an `html.erb` view file containing the html code for the page. You also need (3) a route in the `routes.rb` file which links the URL for the page with the controller action.

1. Generate the controller class, a controller action inside that class, and a template view file by entering the following command:

    ```bash
    rails g controller StaticPages welcome
    ```

    You should see that the files `app/controllers/static_pages_controller.rb` and `app/views/static_pages/welcome.html.erb` have been created, along with some other files we will use later.

1. Looking at the `app/controllers/static_pages_controller.rb` file, a method `welcome` has been created, but it is empty. Modify this method to explicitly render the `welcome.html.erb` view by adding a `respond_to` block with a `render` statement to match:

    ```ruby
    def welcome
      respond_to do |format|
        format.html { render :welcome }
      end
    end
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-2" role="button" aria-expanded="false" aria-controls="moreDetails1-2">More details about this code...</a></small></span>

    <div class="collapse" id="moreDetails1-2">
    <p class="text-muted mr-3 ml-3">
    The <code>respond_to</code> block allows you to specify different responses to generate based on the type of data the request is looking for. For now, the requests will only be expecting HTML responses, but common alternatives are Javascript and JSON.
    </p>
    </div>

1. Looking at the `app/config/routes.rb` file, a GET (as in HTTP GET request) route to `'static_pages/welcome'` has been created, meaning the URL for the page would be <http://localhost:3000/static_pages/welcome>. Instead, make the route point to <http://localhost:3000/welcome> by editing it as follows:

    ```ruby
    get 'welcome', to: 'static_pages#welcome', as: 'welcome'
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-3" role="button" aria-expanded="false" aria-controls="moreDetails1-3">More details about this code...</a></small></span>

    <div class="collapse" id="moreDetails1-3">
    <p class="text-muted mr-3 ml-3">
      Route syntax looks a little confusing until you get the hang of it. The first part, <code>get 'welcome'</code> tells the Rails router to accept GET requests to the URL formed by concatenating the site root (for now <code>http://localhost:3000</code>) with a slash (<code>/</code>) followed by the page-specific path in quotes (<code>welcome</code>).
      </p>
      <p class="text-muted mr-3 ml-3">
      The `to` argument tells the router which controller action should be called when it receives such a GET request. Note that routes use the shorthand "<code>static_pages#welcome</code>" to refer to the method <code>welcome</code> in the <code>StaticPagesController</code> class.
      </p>
      <p class="text-muted mr-3 ml-3">
      The `as` argument automatically generates the helper methods <code>welcome_path</code> and <code>welcome_url</code>, which return the relative path and the full URL for this route, respectively. You should use these helpers in your code instead of hard-coding paths. For example, the system root could change (e.g., if the app was deployed to Heroku or was running on a port other than 3000), and using these helpers will save you from having to search for and update all the hard-coded URLs spread throughout your code.
    </p>
    </div>

1. Verify that he page displays properly by starting the Rails server (`rails s -b 0.0.0.0`) and navigating to <http://localhost:3000/welcome>. You should see some automatically generated text telling you what controller, controller action, and view file were used.

    As we begin customizing the this text, you can keep the Rails server running, reloading the page to view changes as you make them.

1. Start by replacing the generated text with a large heading that says "Welcome to QuizMe!", using the following code:

    ```html
    <h1>Welcome to QuizMe!</h1>
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-5" role="button" aria-expanded="false" aria-controls="moreDetails1-5">More details about this code...</a></small></span>

    <div class="collapse" id="moreDetails1-5">
    <p class="text-muted mr-3 ml-3">
    The <code>&lt;h1&gt;</code> tag is usually used for page titles and only once per page.
    </p>
    </div>

1. Add a description of the QuizMe app under the welcome header, using the following code:

    ```html
    <p>
      QuizMe is a free Quizlet style quizzing application that helps you learn by taking quizzes and trying to improve your scores.
    </p>
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-6" role="button" aria-expanded="false" aria-controls="moreDetails1-6">More details about this code...</a></small></span>

    <div class="collapse" id="moreDetails1-6">
    <p class="text-muted mr-3 ml-3">
    The <code>&lt;p&gt;</code> tag is used for blocks of paragraph text.
    </p>
    </div>

1. Finally, add a list of features the QuizMe app will have, using the following code:

    ```html
    <h2>Features</h2>

    <p>
      QuizMe allows users to:
    </p>

    <ul>
      <li>Choose from premade quizzes on a variety of topics</li>
      <li>Make your own quizzes to customize your learning</li>
      <li>Compare your scores with other users</li>
    </ul>

    <p>
      QuizMe also supports a variety of question styles like multiple choice and fill in the blank.
    </p>
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-7" role="button" aria-expanded="false" aria-controls="moreDetails1-7">More details about this code...</a></small></span>

    <div class="collapse" id="moreDetails1-7">
    <p class="text-muted mr-3 ml-3">
    The <code>&lt;h2&gt;</code> tag is usually used for the first level of subheadings.
    </p>
    <p class="text-muted mr-3 ml-3">
    The <code>&lt;ul&gt;</code> tag is usually used for bulleted lists. The text for each bullet point must be enclosed in its own <code>&lt;li&gt;</code> tag. You can replace the <code>&lt;ul&gt;</code> tag with <code>&lt;ol&gt;</code> to make a numbered list.
    </p>
    </div>

## 2. Adding an Image to a View Using Rails Helpers

Webpages with only unstyled text are not very nice to look at, so for now, we will add a little color with the [quiz graphic]({{ site.baseurl }}/resources/quiz-bubble.png) depicted in Fig. 2. We will add additional style formatting to the app later.

<div class="figure-container mx-auto my-4" style="max-width: 698px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/quiz-bubble.png" class="figure-img img-fluid rounded" alt="A colorful graphic of the word quiz.">
<figcaption class="figure-caption">Fig 2. A quiz graphic.</figcaption>
</figure>
</div>

1. Start by downloading the image file using the link above and save it to the project's `app/assets/images` folder. All files in the `assets` directory get compiled by the server and require Rails helper methods to reference the correct file.

1. Add the image to the page using the `image_tag` helper method by adding the following code to the top of the `welcome.html.erb` file:

    ```erb
    <%= image_tag "quiz-bubble.png", height: 300 %>
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails2-2" role="button" aria-expanded="false" aria-controls="moreDetails2-2">More details about this code...</a></small></span>

    <div class="collapse" id="moreDetails2-2">
    <p class="text-muted mr-3 ml-3">
    The original size of the image is about 700x480px. You can scale it down but keep the original aspect ratio by setting only the height or the width argument. The values are in pixels.
    </p>
    <p class="text-muted mr-3 ml-3">
    The `html.erb` file is used to render plain old HTML code to be sent in HTTP responses. To render the response HTML, each line in the `html.erb` is written into the response. The <code>&lt;% %&gt;</code> and <code>&lt;%= %&gt;</code> tags are exceptions. Both contain Ruby code. Rather than writing these tags and their Ruby code to the response, the Ruby code is instead executed when the line would have otherwise been written. This capability is useful, for example, for conditionally generating HTML code to be written to the response. The <code>&lt;%= %&gt;</code> tag additionally writes the value returned by the Ruby code into the HTML response.
    </p>
    </div>

## 3. Adding Another Page

Before we begin adding hyperlinks, we will add an additional _About_ page (to which we can link).

1. Set the route to point to an `about` method in the `StaticPagesController` and to have the URL be <http://localhost:3000/about> by adding the following code to `config/routes.rb`:

    ```ruby
    get 'about', to: 'static_pages#about', as: 'about'
    ```

1. Add the following `about` method to the `StaticPagesController`:

    ```ruby
    def about
      respond_to do |format|
        format.html { render :about }
      end
    end
    ```

1. Create a new file `app/views/static_pages/about.html.erb` and add the following to it:

    ```erb
    <h1>About</h1>

    <h2>The Authors</h2>

    <p>This site was created by Scott Fleming and Katie Bridson.</p>
    ```

    Navigate to the new page using the URL and make sure it displays correctly.

## 4. Adding Links to a View Using Rails Helpers

Instead of using the anchor (`<a>`) HTML tags for links, Rails provides the `link_to` helper to add links. Remember, Ruby code in the views must be enclosed in a `<% %>` or a `<%= %>` tag.

We will first add a link to an external website and then add one to another page within the web app.

1. Using the `link_to` helper, add a hyperlink on the word "Quizlet" to the Quizlet homepage by editing the QuizMe app description in `welcome.html.erb` as follows:

    ```erb
    <p>
      QuizMe is a free <%= link_to "Quizlet", "https://quizlet.com", target: "_blank" %> style quizzing application that helps you learn by taking quizzes and trying to improve your scores.
    </p>
    ```

    The `link_to` helper takes as arguments the text you want to display, the link destination, and any additional HTML attributes you want to add.

1. Now that we have more than one page in the app, we will add links between the pages, so users aren't forced to enter the URL every time they want to switch pages. Add the links by using the named route helpers (recall the `as` route arguments) in combination with the `link_to` helper as follows:

    - Add a link to the About page at the bottom of the Welcome page by adding this code to `welcome.html.erb`:

      ```erb
      <p><%= link_to "About", about_path %></p>
      ```

    - Add a link to the Welcome page at the bottom of the About page by adding this code to `about.html.erb`:

      ```erb
      <p><%= link_to 'Welcome', welcome_path %></p>
      ```

    Reload the page and confirm the links on both pages work correctly.

## 5. Adding a Root Route

If you navigate to the site's root (<http://localhost:3000>), you'll notice that it still has the old default Rails project page. We probably want this to be something more useful for our app, like the Welcome page. We can change what root routes to by adding the following code at the top of the `config/routes.rb` file:

```ruby
root to: redirect('/welcome', status: 302)
```

<span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails5-0" role="button" aria-expanded="false" aria-controls="moreDetails5-0">More details about this code...</a></small></span>

<div class="collapse" id="moreDetails5-0">
<p class="text-muted mr-3 ml-3">
This statement means that whenever someone tries to go to <code>http://localhost:3000</code> they are automatically redirected to the Welcome page URL via the route we previously made. If you didn't want to have a separate URL for the Welcome page, you could point root directly to the controller action with <code>root to: 'static_pages#welcome'</code> and remove original welcome route. Then, in the <code>link_to</code> statement, you would use the <code>root_path</code> helper instead of <code>welcome_path</code>.
</p>
</div>
