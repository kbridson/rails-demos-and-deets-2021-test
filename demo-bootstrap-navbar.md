---
title: 'Adding a Navigation Bar'
---

# {{ page.title }}

xxx

We will add a [Bootstrap navbar](https://getbootstrap.com/docs/4.3/components/navbar/) (short for _navigation bar_), as depicted in Figure 1.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo15_home_page.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page">
<figcaption class="figure-caption">Figure 1. Updated welcome page that now has Bootstrap styling and a navbar.</figcaption>
</figure>
</div>

## 1. Migrating the Old Navigation Links into a Navbar

For this task, we will convert the existing list of links at the top of our pages (i.e., the ones in the `ul` element) into a more modern and practical [Bootstrap navbar](https://getbootstrap.com/docs/4.4/components/navbar/). In particular, we will start with the Yeti navbar templates (provided [here](https://bootswatch.com/yeti/#navbars)) and customize the template code to have the correct links.

Paste in the Yeti navbar template, like this:

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

Change the `navbar-brand` element to _QuizMe_, like this:

```erb
<a class="navbar-brand" href="#">QuizMe</a>
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

## 2. Conditionally Highlighting the Active Navigation Link

In the above code, the `nav-item` element for the Home link has an additional `active` class; however, this is incorrect and needs to be fixed. The intent of the `active` class is to highlight the nav link for the currently open page. However, to achieve this behavior, the `active` class must be applied to the `nav-item` element that corresponds to the current page. The above code is broken in that the Home `nav-item` element is always styled as `active` regardless of which page is actually open.

To fix this problem, we will conditionally add the `active` class to the appropriate `nav-item` element for the current page by making the following changes.

Add a helper method `active_class` to `application_helper.rb` that returns the string "`active`" if the path of the current HTTP request matches a `path` parameter and that otherwise return an empty string, like this:

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

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-bootstrap-setup.md' next_page='demo-centering.md' %}
