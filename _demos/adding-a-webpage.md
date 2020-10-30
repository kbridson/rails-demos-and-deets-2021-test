---
title: 'Adding a Webpage'
section: Mostly Static Pages
lesson: 1
---

# {{ page.title }}

In this demonstration, I will show how to create mostly static webpages in Rails. We will continue to build upon the _QuizMe_ project from the previous demos.

## 1. Adding a Welcome Page

We will start by making the Welcome page depicted in Figure 1.

{% include image.html file="welcome-page.png" alt="A web page that welcomes users to the QuizMe application" caption="Figure 1. The QuizMe Welcome page." %}

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

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-2" role="button" aria-expanded="false" aria-controls="moreDetails1-2">More details about this code...▼</a></small></span>

    <div class="collapse" id="moreDetails1-2">
    <p class="text-muted mr-3 ml-3">
    The <code>respond_to</code> block allows you to specify different responses to generate based on the type of data the request is looking for. For now, the requests will only be expecting HTML responses, but common alternatives are Javascript and JSON.
    </p>
    </div>

1. Looking at the `config/routes.rb` file, a `get` (as in HTTP GET request) route to `'static_pages/welcome'` has been created, meaning the URL for the page would be <http://localhost:3000/static_pages/welcome>. Instead, make the route point to <http://localhost:3000/welcome> by editing it as follows:

    ```ruby
    get 'welcome', to: 'static_pages#welcome', as: 'welcome'
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-3" role="button" aria-expanded="false" aria-controls="moreDetails1-3">More details about this code...▼</a></small></span>

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

1. Verify that he page displays properly by starting the Rails server (`rails s`) and navigating to <http://localhost:3000/welcome>. You should see some automatically generated text telling you what controller, controller action, and view file were used.

    As we begin customizing the this text, you can keep the Rails server running, reloading the page to view changes as you make them.

1. Start by replacing the generated text in `app/views/static_pages/welcome.html.erb` with a large heading that says "Welcome to QuizMe!", using the following code:

    ```html
    <h1>Welcome to QuizMe!</h1>
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-5" role="button" aria-expanded="false" aria-controls="moreDetails1-5">More details about this code...▼</a></small></span>

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

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-6" role="button" aria-expanded="false" aria-controls="moreDetails1-6">More details about this code...▼</a></small></span>

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

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails1-7" role="button" aria-expanded="false" aria-controls="moreDetails1-7">More details about this code...▼</a></small></span>

    <div class="collapse" id="moreDetails1-7">
    <p class="text-muted mr-3 ml-3">
    The <code>&lt;h2&gt;</code> tag is usually used for the first level of subheadings.
    </p>
    <p class="text-muted mr-3 ml-3">
    The <code>&lt;ul&gt;</code> tag is usually used for bulleted lists. The text for each bullet point must be enclosed in its own <code>&lt;li&gt;</code> tag. You can replace the <code>&lt;ul&gt;</code> tag with <code>&lt;ol&gt;</code> to make a numbered list.
    </p>
    </div>

    The Welcome page should now look like Figure 1.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/71ee066ad47e5e1ca04482786cdfae53ffde4e42)**

## 2. Adding an About Page

We will now add an additional _About_ page (to which we can link in later demo), as depicted in Figure 2.

{% include image.html file="about-page.png" alt="A web page that tells users about the authors of the QuizMe application" caption="Figure 2. The QuizMe About page." %}

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

    Verify that the About page appears as in Figure 2 by opening <http://localhost:3000/about> in the browser.

We now have a couple simple pages to work with! Next, let's see how to add images to pages.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/6a6fe395caa7089e4a791d7bab67358d2f6503cf)**

{% include pagination.html prev_page='demo-new-github-project.md' next_page='demo-images.md' %}
