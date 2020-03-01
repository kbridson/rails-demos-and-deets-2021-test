---
title: 'Adding a Navigation Bar'
---

# {{ page.title }}

In this demonstration, I will show how to implement a navigation bar using the Bootstrap library. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will add a [Bootstrap navbar](https://getbootstrap.com/docs/4.4/components/navbar/){:target="_blank"} (short for _navigation bar_) to the QuizMe app's pages. The navbar will provide hyperlinks to the apps main pages (e.g., the Welcome and About pages) as well as the sign-in/sign-out links, as depicted in Figure 1.

{% include image.html file="bootstrap_navbar.png" alt="Screenshot of browser page" caption="Figure 1. The new navbar for the QuizMe app." %}

Adding the navbar will involve three main tasks:

1. Add a placeholder navbar by pasting in template code from the Yeti Bootswatch Theme website.
1. Customize the template navbar code to display hyperlinks to the QuizMe app's pages.
1. Update the navbar to conditionally format the link to the currently displayed (or _active_) page so that the link to the active page looks different from the other links.

## 1. Adding a Template Navbar to the App

Start by copying the example code for the blue navbar found on the [Yeti Bootswatch Theme webpage](https://bootswatch.com/yeti/#navbars)){:target="_blank"}. If you open the page in the Google Chrome browser, you can then open the HTML code for the page by clicking `View` > `Developer` > `View Source`. To locate the template navbar code, search for the string "`Navbars`" on the page (`Edit` > `Find` > `Find...`), which is a string found only in the heading for the Navbars section.

Paste the Yeti navbar template code into the `app/views/layouts/application.html.erb` at the top of the `body` element, like this:

```erb
<nav class="navbar navbar-expand-md navbar-dark bg-primary">
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

Verify that this code displays correctly by running the app and opening <http://localhost:3000> in the browser. The navbar should appear on all the app's pages.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/5b4f3dcb5fef9f8ec0571295e55c87cbe6663925){:target="_blank"}**

## 2. Migrating the QuizMe Navigation Links into the Navbar

For this task, we will migrate the existing list of links at the top of our pages (i.e., the ones in the `ul` element) into the newly added navbar.

Change the `navbar-brand` `a` element to be a hyperlink to the QuizMe root page, like this:

```erb
<%= link_to 'QuizMe', root_path, class: "navbar-brand" %>
```

Replace the links in the template's `ul` element with our actual Home, About, etc. links, like this:

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

Replace the template's `form` element with another `ul` element that contains the Devise links, like this:

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

Delete the old navigation links in `app/views/static_pages/welcome.html.erb` and the old Devise links in `app/views/layouts/application.html.erb`.

Verify that the above links display and work correctly by reloading the app and testing it out.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/718080ad149b9320717478ebaece67cc71b6ac13){:target="_blank"}**

## 3. Conditionally Highlighting the Active Navigation Link

In the above code, the `nav-item` element for the Home link has an additional `active` class; however, this is incorrect and needs to be fixed. The intent of the `active` class is to highlight the nav link for the currently open page. However, to achieve this behavior, the `active` class must be applied to the `nav-item` element that corresponds to the current page. The above code is broken in that the Home `nav-item` element is always styled as `active` regardless of which page is actually open.

To fix this problem, we will conditionally add the `active` class to the appropriate `nav-item` element for the current page by making the following changes.

Add a helper method `active_class` to the `ApplicationHelper` module in `app/helpers/application_helper.rb` that returns the string `'active'` if the path of the current HTTP request matches a `path` parameter and that otherwise returns an empty string (`''`), like this:

```ruby
def active_class(path)
  if request.path == path
    return 'active'
  else
    return ''
  end
end
```

Use this helper method in the navbar view code to add the `active` class to the appropriate `nav-item` element, like this:

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

Note that, in the above code, we have added an embedded Ruby call to the `active_class` method in the `class` attribute string for each of the the `li` elements. The argument passed to each call of `active_class` is the `path` route helper for the corresponding link destination page.

Verify that the above `active` formatting works correctly by reloading the app and testing out the links.

The app now has a fully functioning navbar. In the upcoming demos, we will add additional UI elements and styling to the page bodies of the app.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/1d3a7894e96e5a0901e87ffad7a5592c24b2d51b){:target="_blank"}**

{% include pagination.html prev_page='demo-bootstrap-setup.md' next_page='demo-centering.md' %}
