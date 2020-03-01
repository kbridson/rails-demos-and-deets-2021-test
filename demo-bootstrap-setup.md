---
title: 'Setting Up Bootstrap and Bootswatch Styling'
---

# {{ page.title }}

In this demonstration, I will show how to set up the popular front-end component library, [Bootstrap](https://getbootstrap.com/docs/4.4/getting-started/introduction/){:target="_blank"}, and the theme library, [Bootswatch](https://bootswatch.com/){:target="_blank"}, for styling app pages. We will continue to build upon the [QuizMe project](https://github.com/human-se/quiz-me-2020){:target="_blank"} from the previous demos.

## 1. Installing the Bootstrap and Bootswatch Packages

Add some Yarn packages to the project, including Bootstrap and its dependencies, by running the console command:

```bash
yarn add bootstrap jquery popper.js expose-loader bootswatch jquery-ui autosize
```

In particular, the `bootstrap` library requires [`jquery`](https://en.wikipedia.org/wiki/JQuery){:target="_blank"} and [`popper.js`](https://popper.js.org/){:target="_blank"}. We are installing `bootswatch` to conveniently choose from a selection Bootstrap-based themes. [`expose-loader`](https://webpack.js.org/loaders/expose-loader/){:target="_blank"} enables the use of JQuery in views. [`jquery-ui`](https://en.wikipedia.org/wiki/JQuery_UI){:target="_blank"} has some nice features (e.g., [the `position` method](https://jqueryui.com/position/){:target="_blank"}). [`autosize`](https://www.jacklmoore.com/autosize/){:target="_blank"} enables automatically scaling the height of a `textarea` to fit its content.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/685020692ce0b43a83ceb3b90fd0b07e0fc58c09){:target="_blank"}**

## 2. Configuring the App to Use Bootstrap

[Webpacker](https://github.com/rails/webpacker){:target="_blank"} is a Rails subsystem for managing JavaScript in Rails. Configure Webpacker by inserting the following code on line 2 of the file, `config/webpack/environment.js`:

```js
const webpack = require("webpack")

environment.plugins.append("Provide", new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  "window.jQuery": "jquery'",
  "window.$": "jquery",
  Popper: ['popper.js', 'default']
}))

environment.config.merge({
  module: {
    rules: [
      {
        test: require.resolve('jquery'),
        use: [{
          loader: 'expose-loader',
          options: '$'
        }, {
          loader: 'expose-loader',
          options: 'jQuery'
        }]
      },
      {
        test: require.resolve('@rails/ujs'),
        use: [{
          loader: 'expose-loader',
          options: 'Rails'
        }]
      }
    ]
  }
})
```

Add the following to the bottom of `app/javascript/packs/application.js`:

```js
import 'bootstrap'
import { autosize } from 'autosize'

document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
})
```

Rename the file, `app/assets/stylesheets/application.css`, to be `application.scss` (note the extra `s` in the file extension).

Import the Bootstrap CSS classes by adding the following to `application.scss`:

```scss
@import "../node_modules/bootstrap/scss/bootstrap";
```

Verify that these steps were performed successfully by running the app and opening it in a browser. You should see that the fonts have now changed.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/5729480812fe9d18a816fb0bdbc30eec861240b4){:target="_blank"}**

## 3. Adding the Yeti Bootswatch Theme

Bootswatch themes override the default colors, font, sizing, and look of the default Bootstrap classes. You can find a list of the available themes (including examples) on the [Bootswatch website](https://bootswatch.com/){:target="_blank"}. For the QuizMe project, we will use the [Yeti theme](https://bootswatch.com/yeti){:target="_blank"}.

Add the Yeti theme by importing the styles in `application.scss`, like this:

```scss
@import "../node_modules/bootswatch/dist/yeti/variables";
@import "../node_modules/bootstrap/scss/bootstrap";
@import "../node_modules/bootswatch/dist/yeti/bootswatch";
```

You can change which theme is used by replacing "`yeti`" with the theme name you want.

Once the theme has been added, you can reload the page to see the text styling has changed again.

In the upcoming demos, we will use Bootstrap components (in combination with our Bootswatch theme) to customize the style (e.g., fonts, colors, text alignment, and layout) of our current pages and to add new UI components (e.g., a navigation bar and cards).

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/bb357d13c104c9c8672d7e861e90e8093f3c2c83){:target="_blank"}**

{% include pagination.html prev_page='demo-authorization.md' next_page='demo-bootstrap-navbar.md' %}
