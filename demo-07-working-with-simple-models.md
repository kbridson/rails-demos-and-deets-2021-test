---
layout: page
title: 'Demo 7: Working with Simple Models'
permalink: /demo-07-working-with-simple-models/
---

# Demo 7: Working with Simple Models

In this demonstration, I will show how to create a model class and some sample objects, persist those objects in the database, and then retrieve and view them on a web page. I will continue to work on the _QuizMe_ project from the previous demos.

## 1. Adding a New Model Class and Sample Data

Since we are building a quizzing application, we will need to store questions in the database. At first, the app will only allow multiple choice questions but in a later demo we will see that it's pretty easy to add other kinds of questions too (e.g., fill in the blank). For multiple choice questions we need to store the question, answer, and a couple of incorrect options (distractors). Figure 1 shows the corresponding class diagram.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/class-diagram.png" class="figure-img img-fluid rounded" alt="Class diagram for McQuestion model.">
<figcaption class="figure-caption">Fig 1. Class diagram for McQuestion model. (Diagram created using <a href="https://www.genmymodel.com">GenMyModel</a>.)</figcaption>
</figure>
</div>

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/qZLxdc_6MOI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

1. Run the following `rails generate model ...` command to create the model class shown in the above class diagram:

    ```bash
    rails g model McQuestion question:string answer:string distractor_1:string distractor_2:string
    ```

    Note the files that are generated, including `app/models/mc_question.rb` (the model class), `db/migrate/20190926192541_create_mc_questions.rb` (the database migration; timestamp will vary), and two files for automated testing, `test/fixtures/mc_questions.yml` (data for use in the tests) and `test/models/mc_question_test.rb` (unit tests for the model class).

1. Run the following command to set up the `mc_questions` table in the database and to regenerate the `app/db/schema.rb` file, which holds the Rails app's representation of the database.

    ```bash
    rails db:migrate
    ```

    Observe the changes to the `schema.rb` file and the new `mc_questions` table in pgAdmin.

1. Add a couple sample questions in the `app/db/seeds.rb` file as follows:

    ```ruby
    q1 = McQuestion.create!(question: 'What does the M in MVC stand for?', 
      answer: 'Model', distractor_1: 'Media', distractor_2: 'Mode')

    q2 = McQuestion.create!(question: 'What does the V in MVC stand for?', 
      answer: 'View', distractor_1: 'Verify', distractor_2: 'Validate')

    q3 = McQuestion.create!(question: 'What does the C in MVC stand for?', 
      answer: 'Controller', distractor_1: 'Create', distractor_2: 'Code')
    ```

    Note that we use the `create!` method (with a bang `!`) to create new database records in the `seeds.rb` file. The reason is that the bang version of `create` (i.e., `create!`) throws an exception if something goes wrong, which will, among other things, produce an error message. If the plain old `create` (with no `!`) method was used, the command will fail silently, which can be awfully confusing.

1. Run the following command to execute the `seeds.rb` file, adding the sample records to the database.

    ```bash
    rails db:seed
    ```

    Observe the new records in pgAdmin.

**[➥ Code changeset for this part](https://github.com/sdflem/quiz-me/commit/0f812ada8d65c6755f13563cee09324b7bc47df3)**

## 2. Retrieving and Viewing Records from the Database

In the first part of this demo, we stored a few questions in the database, so in this part, we will demonstrate how to retrieve and display the questions. In particular, we will demonstrate how to display a single question using a `show` action and how to display all the questions using an `index` action. These two actions are semi-standard read (as in the R in CRUD) actions in Rails. There are also semi-standard `create`, `update`, and `destroy` actions that we will cover in future demos.

<div class="video-container">
<iframe width="560" height="315" src="https://www.youtube.com/embed/QxIifPWWNKA" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

1. Create a controller for `McQuestion` objects by running the `rails generate controller ...` command as follows:

    ```bash
    rails g controller McQuestions index show
    ```

    Note that this command generates the file `app/controllers/mc_questions_controller.rb`, which contains the class `McQuestionsController`. This controller class has two actions (public methods), `index` and `show`. The command also inserted into the `routes.rb` file a new route for each of these controller actions, and it created two new view files, `app/views/mc_questions/index.html.erb` and `app/views/mc_questions/show.html.erb`.

1. Replace the generated routes with standard resources routes for the `McQuestionsController`'s `index` and `show` actions as follows:

    ```ruby
    get 'mc_questions', to: 'mc_questions#index', as: 'mc_questions' # index
    get 'mc_questions/:id', to: 'mc_questions#show', as: 'mc_question' # show
    ```

    Previously, we saw parameters passed to the Rails server via POST requests (recall the `params` hash); however, parameters can also be passed via GET requests. In particular, the `show` route has as part of its URI pattern an `:id` request parameter that becomes part of the URL (e.g., <http://localhost:3000/mc_questions/125>). The `:id` value for a given request can be retrieved from `params[:id]`.

    Additionally, it is possible to pass even more parameters, if needed, by appending them to the end of the URL, as in this example: <http://localhost:3000/somepath?keyword1=value1&keyword2=value2&keyword3=value3>.

1. Add the standard `respond_to` blocks to the `show` and `index` actions.

1. We will also need to add the object(s) to display to the controller actions by using the [ActiveRecord query methods](https://guides.rubyonrails.org/active_record_querying.html#retrieving-a-single-object) for our `McQuestion` model class. For the `show` action, which displays only one object, we use the `find` method with an `id` parameter as follows:

    ```ruby
    question = McQuestion.find(params[:id])
    ```

    For the `index` action, which displays all the records from that table, we use the `all` method as follows:

    ```ruby
    questions = McQuestion.all
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

1. The `index` action should display some data for each of the records in the associated database table. Often, `index` actions will display the database table in an HTML `table` element, with a row for each record and a column for each of the record attributes; however, I will direct you to pgAdmin's show-all-records feature for that. In this demo, we will simply display all the `McQuestion` objects on one page in the same way that they were displayed individually by the `show` action. However, each question will be wrapped in its own HTML `div` element with a unique `id` attribute generated by the `dom_id` helper.

    1. Create a heading for the page as follows:

        ```erb
        <h1>Multiple Choice Questions</h1>
        ```

    1. Recall that we added a local `questions` variable to the `index` action that contains all the `McQuestion` objects in the database. Add code that loops through each question and creates an empty `div` element (for now) with a unique `id` for each question using the `dom_id` helper as follows:

        ```erb
        <% questions.each do |question| %>
          <div id="<%= dom_id(question) %>">
          </div>
        <% end %>
        ```

        Navigating to the index page now shows that three `div` elements have been created that look like `<div id="mc_question_1">` where the number is the record `id`.

    1. Each question should be displayed the same as on the `show` page, so we copy the `show` page code into the empty `div` we have, like this:

        ```erb
        <% questions.each do |question| %>
          <div id="<%= dom_id(question) %>">
            <p><%= question.question %></p>

            <%
            choices = [question.answer, question.distractor_1, question.distractor_2]
            choices.each do |c|
            %>
              <div>
                <%= radio_button_tag "guess", c, checked = c == question.answer, disabled: true %>
                <%= label_tag "guess_#{c}", c %>
              </div>

            <% end %>
          </div>
        <% end %>
        ```

    1. If we reload the `index` page now, we can see that all the questions are displayed, but only one radio button is checked on the entire page. Looking at the code we copied from the `show` page, the radio button tag `id` is "guess" for all the radio buttons. This was fine for the `show` page, but it now means that the radio buttons for all the questions belong to the same group, and only one can ever be checked at a time. We fix this problem by generating a unique radio button group ID for each question, like this:

        ```erb
        <%= radio_button_tag "guess_#{question.id}", c, checked = c == question.answer, disabled: true %>
        <%= label_tag "guess_#{question.id}_#{c}", c %>
        ```

        Now, the group ID should be unique for each question. I also changed the `label` tag `id` for consistency.

The QuizMe app now provides a way to view an individual multiple-choice question (`show`) and a way to view all the multiple-choice questions on a single page (`index`).

**[➥ Code changeset for this part](https://github.com/sdflem/quiz-me/commit/9f9d520e550fc0802a4d6e1212469d9d92bc3671)**
