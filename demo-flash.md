---
title: 'Passing Notification Messages to the View with the Flash'
---

{% include under-construction.html %}

# {{ page.title }}

In this demonstration, I will show how to XXX. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

## 1. Passing Notification Messages to the View with the Flash

In this part, we will refactor our existing notification-message code to work better with the new forms we will be implementing. It is common for modern web apps to display notification messages after the user performs certain operations. For example, if the user submits a form, a success notification might appear to let them know that the submission was successful. Similarly, if the form submission failed, an error notification might appear.

To implement such messages, Rails provides _the flash_. The flash is basically a hash that controllers and ERBs can read and write. The flash is part of the session, so the data stored in the flash is specific to a particular user session. What makes the flash special is that the saved data is available only for the next HTTP request of the session. When that request completes, the data is automatically deleted. (For more info on sessions and the flash, see [this deets page]({{ site.baseurl }}/deets-sessions/).)

To demonstrate using the flash, let's refactor the code we wrote for the feedback form's status message. Instead of passing the status message to the view as a local variable, we can put the message in the `flash` hash under the key `:status_msg`, like this:

In the `leave_feedback` method of `StaticPagesController`, remove the status message from the `locals` hash, and add the status message to the `flash` hash, like this:

```ruby
respond_to do |format|
  format.html {
    flash.now[:status_msg] = form_status_msg
    render :contact, locals: { feedback: params }
  }
end
```

Note that in this example we use `flash.now`, because we want the flash notification to be available during the current request (and not the next one).

In the `contact.html.erb` view, replace the current code for displaying the status message with the following code that displays the status message using the flask:

```erb
<% if flash.key? :status_msg %>
  <p><%= flash[:status_msg] %></p>
<% end %>
```

Submit the feedback form to see the flash message working.

Since it is common to display flash messages in a variety of different views, it makes the the most sense to put the above view code in a single place—namely, the `application.html.erb` layout. In Rails, when a controller action renders a view, that view is implicitly wrapped in the default layout, `application.html.erb`, found in `app/views/layouts`. This layout contains the `<html>`, `<head>`, `<body>`, etc. tags required for all HTML pages. View code we write, such as `show.html.erb`, is actually rendered inside the `application.html.erb` layout. A `<%= yield %>` statement within `application.html.erb` specifies where the view code is inserted. To move the code for displaying flash messages to the `application.html.erb` layout, we do as follows.

Display all flash messages (if there are any) on any given page by inserting the following code above the `<%= yield %>` in `application.html.erb`, like this:

```erb
<% flash.each do |key, message| %>
  <p><%= message %></p>
<% end %>
```

Remove the now redundant flash message displaying code in the `contact.html.erb` view.

You should be able to run the app and see that the notification messages are still working.

**[➥ Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-custom-validations.md' next_page='demo-new-create.md' %}
