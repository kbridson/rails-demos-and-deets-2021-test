---
title: 'Displaying a Single Model Record'
---

{% include under-construction.html %}

# {{ page.title }}


1. Replace the generated routes with standard resources routes for the `McQuestionsController`'s `show` actions as follows:

    ```ruby
    get 'mc_questions/:id', to: 'mc_questions#show', as: 'mc_question' # show
    ```

    Previously, we saw parameters passed to the Rails server via POST requests (recall the `params` hash); however, parameters can also be passed via GET requests. In particular, the `show` route has as part of its URI pattern an `:id` request parameter that becomes part of the URL (e.g., <http://localhost:3000/mc_questions/125>). The `:id` value for a given request can be retrieved from `params[:id]`.

    Additionally, it is possible to pass even more parameters, if needed, by appending them to the end of the URL, as in this example: <http://localhost:3000/somepath?keyword1=value1&keyword2=value2&keyword3=value3>.

1. Add the standard `respond_to` blocks to the `show` and `index` actions.

1. We will also need to add the object(s) to display to the controller actions by using the [ActiveRecord query methods](https://guides.rubyonrails.org/active_record_querying.html#retrieving-a-single-object){:target="_blank"} for our `McQuestion` model class. For the `show` action, which displays only one object, we use the `find` method with an `id` parameter as follows:

    ```ruby
    question = McQuestion.find(params[:id])
    ```

    You will also need to pass those variables into the `locals` hash, so they will be available in the view.





1. The `show` action should display all the _important_ attributes of the `mc_question` object (i.e., not the timestamps and not the `id` because that is shown in the URL). We could simply set up something like `<p>Answer: <%= answer %></p>` for each attribute, but let's make it a little more interesting by showing the question and a set of disabled radio buttons for all the answer choices (the correct answer and distractor(s)). Note that the radio buttons are just for show in this case, and will not be part of a working form.

    1. Create a `<p>` block for the question text as follows:

        ```erb
        <p><%= question.question %></p>
        ```

    1. Now we need to create the radio button group with all the answers. Let's make three radio button tags as follows:

        ```erb
        <div>
          <%= radio_button_tag "guess", question.answer, checked = true, disabled: true %>
          <%= label_tag "guess_#{question.answer}", question.answer %>
        </div>
        <div>
          <%= radio_button_tag "guess", question.distractor_1, checked = false, disabled: true %>
          <%= label_tag "guess_#{question.distractor_1}", question.distractor_1 %>
        </div>
        <div>
          <%= radio_button_tag "guess", question.distractor_2, checked = false, disabled: true %>
          <%= label_tag "guess_#{question.distractor_2}", question.distractor_2 %>
        </div>
        ```

        In the `radio_button_tag` options, we need to make sure the buttons are all disabled by adding `disabled: true`. We also need to be sure that only the correct answer is checked by setting the `checked` option to be true only for the answer radio button. For the unique label tag IDs, we use string interpolation to execute some ruby code and put it inside the string (e.g. `#{question.answer}`).

    1. Coding each radio button, like we did above, works, but it results in a lot of duplicate code. Instead, we can programmatically generate the radio buttons by looping through an array that contains all the choices and creating the radio button inside the loop.

        ```erb
        <%
        choices = [question.answer, question.distractor_1, question.distractor_2]
        choices.each do |c|
        %>
          <div>
            <%= radio_button_tag "guess", c, checked = c == question.answer, disabled: true %>
            <%= label_tag "guess_#{c}", c %>
          </div>

        <% end %>
        ```

        Setting most of the options is straightforward based on the `c` value but determining which radio button to check is more complicated. We know the `checked` option should be true only if `c` is `question.answer`, so we can actually set `checked` equal to the the result of determining if `c` is equal to `question.answer`.

    1. Try going to <http://localhost:3000/mc_questions/1> to see the show page for one of the questions we added to the database.
