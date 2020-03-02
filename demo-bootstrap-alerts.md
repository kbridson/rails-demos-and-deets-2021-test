---
title: 'Styling Flash Notification Messages'
---

# {{ page.title }}

In this demonstration, I will show how to style flash notification messages using Bootstrap. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will use [Bootstrap alerts](https://getbootstrap.com/docs/4.4/components/alerts/){:target="_blank"} to style our flash notification messages, as depicted in Figure 1.

{% include image.html file="bootstrap_alert.png" alt="Screenshot of browser page" caption="Figure 1. Updated form page for `Quiz` records that now uses Bootstrap to style flash notification messages." %}

## 1. Styling the Flash Notification Messages with Bootstrap Alerts

Using [Bootstrap alerts](https://getbootstrap.com/docs/4.4/components/alerts/){:target="_blank"}, flash messages are typically styled with the CSS `alert` class along with one of the colored `alert-x` classes, such as `alert-success` (usually green) or `alert-danger` (usually red).

Define a helper to automatically set the `alert-x` class based on the key used for the message by adding to the `ApplicationHelper` module (in `app/helpers/application_helper.rb`) a `flash_class` helper method that maps all flash key values used in the app to an appropriate Bootstrap alert class, like this:

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

More keys can be added later if necessary. A list of all the `alert` classes can be found [here](https://getbootstrap.com/docs/4.4/components/alerts/){:target="_blank"}. If a Bootswatch theme has been applied, the colors of each alert class will be different depending on the theme.

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

The above code has a little problem: the `alert` text is slightly off-center. Fix this problem by adding some SCSS code to `app/assets/stylesheets/application.scss`, like this:

```scss
.alert-dismissible {
  padding-left: $close-font-size + $alert-padding-x * 2;
}
```

The variables, `$close-font-size` and `$alert-padding-x`, were declared in the Bootstrap files in the `node_modules` folder, but we can use them in our SCSS files after the `@import` statements.

Verify that the above code works correctly by running the app and testing out the features for creating, updating, and destroying `Quiz` and `McQuestion` records (i.e., the features that produce flash notification messages).

Although our flash notification messages are now nicely styled, our form error messages still lack details about the nature of the errors, which could cause confusion for users. To address this issue, we will next add detailed error messages as annotations on our existing forms.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/32c8512973ec31a18fa49408d6101330b119a4a4){:target="_blank"}**

{% include pagination.html prev_page='demo-bootstrap-cards.md' next_page='demo-form-errors.md' %}
