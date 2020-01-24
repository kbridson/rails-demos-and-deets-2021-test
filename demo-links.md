---
title: 'Adding Hyperlinks between Pages'
---

# {{ page.title }}

In this demonstration, I will show how to add hyperlinks between pages. We will continue to build upon the _QuizMe_ project from the previous demos.

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

{% include pagination.html prev_page='demo-images.md' next_page='demo-root-route.md' %}
