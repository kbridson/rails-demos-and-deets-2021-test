---
title: 'Rendering Data from Controllers'
---

# {{ page.title }}

In this demonstration, I will demonstrate how to pass data from a controller action to a view and how to render the view using ruby functions. We will continue to build upon the _QuizMe_ project from the previous demos.

Following Rails' MVC architecture, the models (and to some extent the controllers) should be responsible for storing and processing a website's data. The views should only format and display that data. Central to mastering Rails is understanding the ways that data can be passed between the models, views, and controllers.

The _QuizMe_ site does not have much data so far; however, recall the list of features on the Welcome page (depicted in Figure 1). For demonstration purposes, we would like to extract this list of features (i.e., some data) currently encoded in the `welcome.html.erb` view, and instead, encode them as an array of strings in the controller. That way, the array of feature-list items can be rendered using a loop in the view. Such a setup would make adding new feature-list items much easier than inserting them (along with all their accompanying HTML code) manually into the view. The following steps can be performed to make this change.

{% include image.html file="welcome-page-features-list.png" alt="The Welcome page, including a the list of app features" caption="Figure 1. The QuizMe Welcome page with its list of features." %}

1. Copy the feature strings from `app/views/static/welcome.html.erb` and reformat them into a ruby array in the `app/controllers/static_pages_controller.rb`'s `welcome` action above the `respond_to` block. The resulting array should look like this:

    ```ruby
    features = [
      "Choose from premade quizzes on a variety of topics",
      "Make your own quizzes to customize your learning",
      "Compare your scores with other users"
    ]
    ```

    Review the [Ruby array syntax](https://ruby-doc.org/core-2.6.5/Array.html) if you are unfamiliar with it.

1. Include the `features` array in the data passed to the render call in the `respond_to` block by adding it as a local variable with the same name in the view. The render statement should be **updated** to match:

    ```ruby
    format.html { render :welcome, locals: { features: features } }
    ```

    **Make sure you do not end up with more than one render statement.**

1. **Replace** the raw HTML unordered list in `app/views/static/welcome.html.erb` with ruby code that loops over the `features` array and wraps each string in the correct html elements. Recall that Ruby code in ERB files should be enclosed in `<% %>` or `<%= %>` blocks and that the difference between them is that the result of the code in a `<%= %>` block is additionally rendered on the page. The structure of the loop should match:

    ```erb
    <ul>
      <% features.each do |f| %>
        <li><%= f %></li>
      <% end %>
    </ul>
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails0-3" role="button" aria-expanded="false" aria-controls="moreDetails0-3">More details about this code...▼</a></small></span>

    <div class="collapse" id="moreDetails0-3">
    <p class="text-muted mr-3 ml-3">
    The goal of this code is to render an HTML bullet list (<code>ul</code>) such that each bullet item (<code>li</code>) is an item in the array <code>features</code>.
    </p>
    <p class="text-muted mr-3 ml-3">
    The <code>each</code> method iterates through each item in the array <code>features</code>. In each iteration of the loop, the current item is referenced by the <code>f</code> variable. The <code>end</code> statement denotes the end of the loop body.
    </p>
    <p class="text-muted mr-3 ml-3">
    For more on how HTML.ERB code is rendered by a controller, see <a href="{{ site.baseurl }}/deets-erb/">this page</a>.
    </p>
    </div>

1. Navigate to <http://localhost:3000/welcome> to see that the view looks exactly the same after the changes since the HTML rendered after the ERB is processed is the same as before. You can inspect the source HTML code in the browser with right-click > `Inspect` (element) and confirm that it is the same.

We have now successfully passed data from the controller to the view to be rendered!

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/370ec758a1ce78ac62482591d8d5b42614bb4a3b)**

{% include pagination.html prev_page='demo-root-route.md' next_page='demo-simple-forms.md' %}
