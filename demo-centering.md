---
title: 'Centering Page Content'
---

# {{ page.title }}

xxx

For this task, we will center several different types of elements on our pages.

## 1. Centering a Text Element

One element that we would like to center is the `h1` text-heading elements on all our pages.

To center an individual `h1` element, we could add the Bootstrap `text-center` class, like this:

```erb
<h1 class="text-center">Welcome to QuizMe!</h1>
```

However, this class must be applied to individual elements, which would not be a very [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) way to apply the style, considering that we want to center all `h1` elements on all pages.

Instead of individually styling each individual `h1` element with the `text-center` class, we will instead set a global `text-align` style for all `h1` elements by adding some CSS to `application.scss`, like this:

```scss
h1 {
  text-align: center;
}
```

This global style will center the heading text for all `h1` elements on every page in the app.

## 2. Centering an Element with Margin

Another element that we would like to center on the page is the QuizMe welcome-page image; however, we can't use the `text-align` style like we did for the `h1` heading elements, because the style only works for text elements. To horizontally center elements that don't contain text, we can use the Bootstrap `mx-auto` class. This class divides the empty whitespace around the element between the element's left and right margins, centering the element within its parent element.

Center the welcome-page image by making the `img` element a block-level element (using the Bootstrap `d-block` class) and by adding the `.mx-auto` class, like this:

```erb
<%= image_tag "quiz-bubble.png", width: 400, class: 'd-block mx-auto' %>
```

## 3. Centering with Columns and Justify Content

A final sort of element centering that we would like to do is to make the content of each page layout in a column such that the column is placed in the center (horizontally speaking) of the page. To accomplish this task, we will leverage [Bootstrap's 12-column flexbox grid layout system](https://getbootstrap.com/docs/4.3/layout/grid/). For most of the pages in QuizMe, we don't want multiple columns side-by-side, but we do want the content to be somewhat in the middle of the page with margins on both sides. We can achieve this by creating a single column that spans 8 of the 12 possible Bootstrap columns, and then, by centering the entire column on the page (leaving the width of 2 columns on each side).

To achieve this layout, wrap the `yield` statement in `application.html.erb` in a 3-layer `div` wrapper with the outermost `div` having the Bootstrap `container-fluid` class, the second `div` having the Bootstrap `row` and `justify-content-center` classes, and the innermost `div` having the Bootstrap `col-8` class, like this:

```erb
<div class="container-fluid">
  <div class="row justify-content-center">
    <div class="col-8">
      <%= yield %>
    </div>
  </div>
</div>
```

xxx

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](xxx){:target="_blank"}**

{% include pagination.html prev_page='demo-bootstrap-navbar.md' next_page='demo-bootstrap-cards.md' %}
