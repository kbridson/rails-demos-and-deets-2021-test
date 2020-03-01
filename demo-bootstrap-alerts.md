---
title: 'Styling Flash Alert Messages'
---

{% include under-construction.html %}

# {{ page.title }}

TODO

Finally, we will use [Bootstrap alerts](https://getbootstrap.com/docs/4.3/components/alerts/) to style our form notifications, and we will annotate form fields with error messages, as depicted in Figure 3.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/demo15_quiz_form_error.png" class="figure-img img-fluid rounded border" alt="Screenshot of browser page">
<figcaption class="figure-caption">Figure 3. Updated form page for <code>Quiz</code> records that now uses Bootstrap to style notice/alert messages and now annotates form fields with error messages.</figcaption>
</figure>
</div>

xxx

## 1. Adding Flash Key Colors

In this task, we will apply a flashier Bootstrap style to our flash messages (as depicted in Figure 3). In Bootstrap, flash messages are typically styled with the `alert` class along with one of the colored `alert-x` classes, such as `alert-success` (usually green) or `alert-danger` (usually red).

To automatically set the `alert` class based on the key used for the message, add a `flash_class` helper method that maps all flash key values used in the app to an appropriate `alert` class, like this:

```ruby
def flash_class(level)
  bootstrap_alert_class = {
    "success" => "alert-success",
    "error" => "alert-danger",
    "notice" => "alert-info",
    "alert" => "alert-danger",
    "warn" => "alert-warning"
  }
  bootstrap_alert_class[level]
end
```

More keys can be added later if necessary. A list of all the `alert` classes can be found [here](https://getbootstrap.com/docs/4.3/components/alerts/). If a Bootswatch theme has been applied, the colors of each alert class will be different depending on the theme.

In the view layout `layouts/application.html.erb`, update the existing flash message code to use the Bootstrap `alert` class and the `flash_class` helper method, like this:

```erb
<% flash.each do |key, message| %>
  <div class="alert <%= flash_class(key) %> alert-dismissible fade show text-center" role="alert">
    <%= message %>
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
  </div>
<% end %>
```

The above code has a little problem: the `alert` text is slightly off-center. Fix this by adding the following to `application.scss`:

```scss
.alert-dismissible {
  padding-left: $close-font-size + $alert-padding-x * 2;
}
```

These variables were declared in the Bootstrap files in the `node_modules` folder, but we can use them in our SCSS files after the `import` statement.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-bootstrap-cards.md' next_page='demo-form-errors.md' %}
