---
title: 'Adding Hyperlinks between Pages'
---

# {{ page.title }}

In this demonstration, I will show how to add hyperlinks between pages. We will continue to build upon the _QuizMe_ project from the previous demos.

Instead of using the anchor (`<a>`) HTML tags for links, Rails provides the `link_to` helper to add links. Remember, Ruby code in the views must be enclosed in a `<% %>` or a `<%= %>` tag.

## 1. Adding Hyperlinks to External Websites

We will first add a link to the external website, <https://quizlet.com>, to the Welcome page, as depicted in Figure 1.

{% include image.html file="welcome-page-external-link.png" alt="The Welcome page, including a hyperlink to an external website" caption="Figure 1. The QuizMe Welcome page with an external hyperlink to the Quizlet website." %}

Using the `link_to` helper, add a hyperlink on the word "Quizlet" to the Quizlet homepage by editing the QuizMe app description in `welcome.html.erb` as follows:

```erb
<p>
  QuizMe is a free <%= link_to "Quizlet", "https://quizlet.com", target: "_blank" %> style quizzing application that helps you learn by taking quizzes and trying to improve your scores.
</p>
```

The `link_to` helper takes as arguments the text you want to display, the link destination, and any additional HTML attributes you want to add.

Confirm that the hyperlink works by refreshing the Welcome page in the browser.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/0867a44fb45c385fd7ce3005abe2d9f264c386ab)**

## 2. Adding Hyperlinks between Pages within the App

Next, we will add hyperlinks between the Welcome and About pages within the web app, as depicted in Figure 2 and Figure 3, so users aren't forced to manually enter the URL every time they want to switch pages.

{% include image.html file="welcome-page-internal-link.png" alt="The Welcome page, including a hyperlink to an internal page" caption="Figure 2. The QuizMe Welcome page with an internal hyperlink to the About page." %}

{% include image.html file="about-page-internal-link.png" alt="The Welcome page, including a hyperlink to an internal page" caption="Figure 3. The QuizMe About page with an internal hyperlink to the Welcome page." %}

Add the links by using the named route helpers (recall the `as` route arguments) in combination with the `link_to` helper as follows.

Add a link to the About page at the bottom of the Welcome page by adding this code to `welcome.html.erb`:

```erb
<p><%= link_to "About", about_path %></p>
```

Add a link to the Welcome page at the bottom of the About page by adding this code to `about.html.erb`:

```erb
<p><%= link_to 'Welcome', welcome_path %></p>
```

Reload the Welcome page and confirm the links on both pages work correctly.

**[➥ Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/13424f3ed23dc590a2d06f7b89d33d051c16aeff)**

{% include pagination.html prev_page='demo-images.md' next_page='demo-root-route.md' %}
