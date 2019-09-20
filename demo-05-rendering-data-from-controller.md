---
layout: page
title: 'Demo 5: Rendering Data From Controllers'
permalink: /demo-05-rendering-data-from-controller/
---

# Demo 5: Rendering Data From Controllers

In this demonstration, I will show how to pass data from a controller action to its view and render it using ruby functions. I will continue to work on the _QuizMe_ project from the previous demos.

This and all future demos will assume you are starting in the workspace folder on your virtual machine.

## 1. Moving Business Data from the View to the Controller

Based on the MVC model, the models and possibly the controllers should be responsible for storing and processing a website's data. The views should only format and display that data. The _QuizMe_ site does not have much data so far but it may make sense to extract the list of features from the welcome page to an array of strings in the controller so they could be rendered with a loop. That would make adding new features much easier than editing the view directly, especially when we add styling to the app.

1. Copy the feature strings from `app/views/static/welcome.html.erb` and reformat them into a ruby array in the `app/controllers/static_pages_controller.rb`'s welcome action above the `respond_to` block. The resulting array should match:

    ```ruby
    features = [
      "Choose from premade quizzes on a variety of topics",
      "Make your own quizzes to customize your learning",
      "Compare your scores with other users"
    ]
    ```

    Review the ruby array syntax if you are unfamiliar with it.

1. Include the `features` array in the data passed to the render call in the `respond_to` block by adding it as a local variable with the same name in the view. The render statement should match:

    ```ruby
    format.html { render :welcome, locals: { features: features } }
    ```

1. Replace the raw html unordered list in `app/views/static/welcome.html.erb` with ruby code that loops over the `features` array and wraps each string in the correct html elements. Recall that ruby code in erb files should be enclosed in `<% %>` or `<%= %>` blocks and that the difference between them is the result of the code in a `<%= %>` block is additionally rendered on the page. The structure of the loop should match:

    ```erb
    <ul>
      <% features.each do |f| %>
        <li><%= f %></li>
      <% end %>
    </ul>
    ```

    > TODO: Coherent explanation of loop code including:
    >
    > - ul tags outside loop since you only need one set
    > - loop header and end statements in regular <% %> blocks
    > - review ruby each do syntax, f is the string to display
    > - inside loop render the f variable (<%= %>) containing the string and wrap in li tags
    >

1. Navigate to `localhost:3000/welcome` to see that the view looks exactly the same after the changes since the html rendered after the erb is processed is the same as before. You can inspect the source html code in the browser with right-click > Inspect (element) and confirm it is the same.

