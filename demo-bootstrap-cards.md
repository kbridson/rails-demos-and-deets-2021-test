---
title: 'Formatting Data with Cards'
---

# {{ page.title }}

xxx

We will also use [Bootstrap cards](https://getbootstrap.com/docs/4.3/components/card/) to display `Quiz` records, as depicted in Figure 2.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo15_quizzes_index_page.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page">
<figcaption class="figure-caption">Figure 2. Updated <code>index</code> page for <code>Quiz</code> records that now uses Bootstrap cards to display each quiz record.</figcaption>
</figure>
</div>

xxx

## 5. Displaying Records as Bootstrap Cards

In this task, we will restyle the quizzes displayed on the `index` page for `Quiz` records by displaying each quiz as a [Bootstrap card](https://getbootstrap.com/docs/4.3/components/card/), as shown in Figure 2.

1. Put each quiz in the `quizzes/index.html.erb` view into a card container, like this:

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

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-centering.md' next_page='demo-bootstrap-alerts.md' %}
