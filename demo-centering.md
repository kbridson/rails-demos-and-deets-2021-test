---
title: 'Centering Page Content'
---

# {{ page.title }}

In this demonstration, I will show how to center various kinds of page content using Bootstrap. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

In particular, we will center the following elements:

1. We will center the text in an `h1` heading element. The approach we will use would work for text in any block element, such as `p`  and `div` elements.
1. We will center (horizontally) an `img` image element. The approach we will use would work for centering any block element that is less wide than its containing element (e.g., a `div` with `width` less than 100%).
1. We will use the [Bootstrap grid system](https://getbootstrap.com/docs/4.4/layout/grid/){:target="_blank"} to create a centered column for the main content of the app's pages.

## 1. Centering the Text in `h1` Heading Elements

One element that we would like to center is the `h1` text-heading elements on all our pages.

To center an individual `h1` element, we could add the Bootstrap `text-center` class, like this:

```erb
<h1 class="text-center">Welcome to QuizMe!</h1>
```

However, this class must be applied to individual elements, which would not be a very [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself){:target="_blank"} way to apply the style, considering that we want to center all `h1` elements on all pages.

Instead of individually styling each individual `h1` element with the `text-center` class, we will instead set a global `text-align` style for all `h1` elements by adding some CSS to `application.scss`, like this:

```scss
h1 {
  text-align: center;
}
```

This global style will center the heading text for all `h1` elements on every page in the app.

Verify that this code works correctly by running the app and opening the app's various pages in a browser. All the top-level heading should be centered on the pages.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/b5713ef0b2f6b24087f35f609f2fe994a94cf050){:target="_blank"}**

## 2. Centering an `img` Image Element

Another element that we would like to center on the page is the QuizMe image on the Welcome page; however, we can't use the `text-align` style like we did for the `h1` heading elements, because the style only works on text within elements. To horizontally center elements that don't contain text, we can use the [Bootstrap `mx-auto` class](https://getbootstrap.com/docs/4.4/utilities/spacing/#horizontal-centering){:target="_blank"}. This class divides the empty whitespace around the element between the element's left and right margins, centering the element within its parent element.

Center the image on the Welcome page by making the `img` element a block-level element (using the [Bootstrap `d-block` class](https://getbootstrap.com/docs/4.4/utilities/display/){:target="_blank"}) and by adding the `.mx-auto` class, like this:

```erb
<%= image_tag "quiz-bubble.png", width: 300, class: 'd-block mx-auto' %>
```

Verify that this code displays correctly by running the app and opening <http://localhost:3000> in the browser. The image should be centered on the Welcome page.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/169ba2395a1d7d4d966c79d7e7b4153355ceaf3d){:target="_blank"}**

## 3. Presenting Page Content in a Column Centered on the Page

A final sort of element centering that we would like to do is to make the content of each page layout in a column such that the column is placed in the center (horizontally speaking) of the page. To accomplish this task, we will leverage [Bootstrap's 12-column flexbox grid layout system](https://getbootstrap.com/docs/4.4/layout/grid/). For most of the pages in QuizMe, we don't want multiple columns side-by-side, but we do want the content to be somewhat in the middle of the page with margins on both sides. We can achieve this by creating a single column that spans 8 of the 12 possible Bootstrap columns, and then, by centering the entire column on the page (leaving the width of 2 columns on each side).

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

Verify that this code works correctly by running the app and opening the app's various pages in a browser. The content of the pages should now appear in a discernable column centered on the page.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/1ba6dc26991eee9a5fb8a7454052676a47347c87){:target="_blank"}**

{% include pagination.html prev_page='demo-bootstrap-navbar.md' next_page='demo-bootstrap-cards.md' %}
