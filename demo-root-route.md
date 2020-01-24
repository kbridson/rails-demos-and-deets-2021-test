---
title: 'Adding a Root Route'
---

# {{ page.title }}

In this demonstration, I will show how to make a page the "root" page—that is, the default page that is displayed if no resource path is added to the URL. We will continue to build upon the _QuizMe_ project from the previous demos.

If you navigate to the QuizMe app's root (<http://localhost:3000>), you'll notice that it still has the old default Rails project page. We probably want this to be something more useful for our app, like the Welcome page.

We can change what root routes to by adding the following code to the top of the block in the `config/routes.rb` file:

```ruby
root to: redirect('/welcome', status: 302)
```

<span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails5-0" role="button" aria-expanded="false" aria-controls="moreDetails5-0">More details about this code...▼</a></small></span>

<div class="collapse" id="moreDetails5-0">
<p class="text-muted mr-3 ml-3">
This statement means that whenever someone tries to go to <code>http://localhost:3000</code> they are automatically redirected to the Welcome page URL via the route we previously made. If you didn't want to have a separate URL for the Welcome page, you could point root directly to the controller action with <code>root to: 'static_pages#welcome'</code> and remove original welcome route. Then, in the <code>link_to</code> statement, you would use the <code>root_path</code> helper instead of <code>welcome_path</code>.
</p>
</div>

If you open the QuizMe app's root page now, the browser will be redirected to the Welcome page.

{% include pagination.html prev_page='demo-links.md' next_page='demo-rendering-data.md' %}