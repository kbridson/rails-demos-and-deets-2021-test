---
title: 'Adding Images to Pages'
---

# {{ page.title }}

In this demonstration, I will show how to display images on pages. We will continue to build upon the _QuizMe_ project from the previous demos.

Webpages with only unstyled text are not very nice to look at, so for now, we will add a little color with the [quiz graphic]({{ '/resources/quiz-bubble.png' | relative_url }}) depicted in Figure 1.

{% include image.html file="quiz-bubble.png" alt="A colorful graphic of the word quiz" caption="Figure 1. A quiz graphic." %}

In particular, we will add the image to the Welcome page, as depicted in Figure 2. We will add additional style formatting to the app later.

{% include image.html file="welcome-page-image.png" alt="The Welcome page for the QuizMe application, including a quiz bubble graphic" caption="Figure 2. The QuizMe Welcome page with quiz graphic." %}

1. Start by downloading the image file using the link above and save it to the project's `app/assets/images` folder. All files in the `assets` directory get compiled by the server and require Rails helper methods to reference the correct file.

1. Add the image to the page using the `image_tag` helper method by adding the following code to the top of the `welcome.html.erb` file:

    ```erb
    <%= image_tag "quiz-bubble.png", height: 300 %>
    ```

    <span class="ml-2 text-nowrap"><small><a class="text-muted" data-toggle="collapse" href="#moreDetails2-2" role="button" aria-expanded="false" aria-controls="moreDetails2-2">More details about this code...▼</a></small></span>

    <div class="collapse" id="moreDetails2-2">
    <p class="text-muted mr-3 ml-3">
    The original size of the image is about 700x480px. You can scale it down but keep the original aspect ratio by setting only the height or the width argument. The values are in pixels.
    </p>
    <p class="text-muted mr-3 ml-3">
    The `html.erb` file is used to render plain old HTML code to be sent in HTTP responses. To render the response HTML, each line in the `html.erb` is written into the response. The <code>&lt;% %&gt;</code> and <code>&lt;%= %&gt;</code> tags are exceptions. Both contain Ruby code. Rather than writing these tags and their Ruby code to the response, the Ruby code is instead executed when the line would have otherwise been written. This capability is useful, for example, for conditionally generating HTML code to be written to the response. The <code>&lt;%= %&gt;</code> tag additionally writes the value returned by the Ruby code into the HTML response.
    </p>
    </div>

    Reload the Welcome page to confirm that the image now appears as depicted in Figure 2.

**[{% octicon git-commit height:24 class:"right left" aria-label:hi %} Code changeset for this part](https://github.com/human-se/quiz-me-2020/commit/4321a3161871ddc504be4c6d1c02d2738dd6d368)**

{% include pagination.html prev_page='demo-static-pages.md' next_page='demo-links.md' %}
