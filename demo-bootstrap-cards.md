---
title: 'Formatting Data with Cards'
---

# {{ page.title }}

In this demonstration, I will show how to display page content using Bootstrap cards. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will use [Bootstrap cards](https://getbootstrap.com/docs/4.4/components/card/){:target="_blank"} to display `Quiz` records, as depicted in Figure 1.

{% include image.html file="bootstrap_cards.png" alt="Screenshot of browser page" caption="Figure 1. Updated `index` page for `Quiz` records that now uses Bootstrap cards to display each quiz record." %}

## 1. Displaying `Quiz` Records as Bootstrap Cards

In this task, we will restyle the quizzes displayed on the `index` page for `Quiz` records by displaying each quiz as a [Bootstrap card](https://getbootstrap.com/docs/4.4/components/card/){:target="_blank"}.

Put each quiz in the `quizzes/index.html.erb` view into a `card` container, like this:

```erb
<div id="<%= dom_id(quiz) %>">
  <div class="card container border-primary mb-3">
    <div class="card-header row justify-content-between text-white bg-primary">
      <h5 class='m-0'><%= quiz.title %></h5>
      <div>
        <%= link_to '🔎', quiz_path(quiz) %>
        <% if quiz.creator == current_user %>
          <%= link_to '🖋', edit_quiz_path(quiz) %>
          <%= link_to '🗑', quiz_path(quiz), method: :delete %>
        <% end %>
      </div>
    </div>
    <div class="card-body">
      <h6 class="card-subtitle mb-2 text-muted">By: <%= quiz.creator.email %></h6>
      <p class="card-text"><%= truncate quiz.description, length: 75, separator: ' ' %></p>
    </div>
  </div>
</div>
```

Verify that this code displays correctly by running the app and opening <http://localhost:3000/quizzes> in the browser. The quizzes should be displayed as cards.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/5a117bf76b0504c8a2c0b39f44511af736097ab9){:target="_blank"}**

{% include pagination.html prev_page='demo-centering.md' next_page='demo-bootstrap-alerts.md' %}
