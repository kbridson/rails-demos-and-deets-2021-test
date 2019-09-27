---
layout: page
title: 'Demo 7: Working with Simple Models'
permalink: /demo-07-working-with-simple-models/
---

# Demo 7: Working with Simple Models

In this demonstration, I will show how to create a model class and some sample objects, persist those objects in the database, and then retrieve and view them on a web page. I will continue to work on the _QuizMe_ project from the previous demos.

## 1. Adding a New Model Class and Sample Data

TODO: Review Rails architecture diagram and what's a model... OOP version of a db record

Since we are building a quizzing application, we will need to store questions in the database. At first, the app will only allow multiple choice questions but in a later demo we will see it's pretty easy to add other kinds of questions too (e.g. fill in the blank). For multiple choice questions we need to store the question, answer, and a couple of incorrect options (distractors). Figure 1 shows the corresponding class diagram.

<div class="figure-container mx-auto my-4" style="max-width: 960px;">
<figure class="figure">
<img src="{{ site.baseurl }}/resources/class-diagram.png" class="figure-img img-fluid rounded" alt="Class diagram for McQuestion model.">
<figcaption class="figure-caption">Fig 1. Class diagram for McQuestion model.</figcaption>
</figure>
</div>

1. Run the following `rails generate model...` command to create the model class shown in the above class diagram:

    ```bash
    rails g model MCQuestion question:string answer:string distractor_1:string distractor_2:string
    ```

    Observe the generated files.

    TODO: Explanation of migration and how it should change schema.

1. Run the `rails db:migrate` command to regenerate the `app/db/schema.rb` file.

    Observe the changes to the file and the new table in pgAdmin.

1. Add a couple sample questions in the `app/db/seeds.rb` file as follows:

    ```ruby
    q1 = McQuestion.create!(question: 'What does the M in MVC stand for?', 
      answer: 'Model', distractor_1: 'Media', distractor_2: 'Mode')

    q2 = McQuestion.create!(question: 'What does the V in MVC stand for?', 
      answer: 'View', distractor_1: 'Verify', distractor_2: 'Validate')

    q3 = McQuestion.create!(question: 'What does the C in MVC stand for?', 
      answer: 'Controller', distractor_1: 'Create', distractor_2: 'Code')
    ```

    TODO: Create vs create!

1. Run the `rails db:seed` command to add those sample records to the database.

    Observe the new records in pgAdmin.

## 2. Retrieving and Viewing Data from the Database

TODO: Explanation of what we are doing including:
- Standard CRUD actions - for now just R (see one vs see all)
- There are standard conventions to follow for all these CRUD actions - for now concerned with index (all records) and show (one record)

1. Create a controller for McQuestion by running the `rails generate controller...` command as follows:

    ```bash
     rails g controller MCQuestions index show
    ```

1. Replace the generated routes with standard resources routes for the McQuestions index and show actions as follows:

    ```ruby
    get 'mc_questions', to: 'mc_questions#index', as: 'mc_questions' # index
    get 'mc_questions/:id', to: 'mc_questions#show', as: 'mc_question' # show
    ```

    Previously we saw parameters with POST requests, but GET requests can also have them. In the show route, `:id` is a request parameter that becomes part of the URL. Any other parameters not specified directly would be appended to the end of the URL (e.g. <http://www.foo.com/somepath?keyword1=value1&keyword2=value2&keyword3=value3>).

1. Add the standard `respond_to` blocks to the show and index actions.

1. We will also need to add the object(s) to display to the controller actions by using the (ActiveRecord query methods)[https://guides.rubyonrails.org/active_record_querying.html#retrieving-a-single-object] for our McQuestion model class. For the show action which displays only one object, we should use the `find` method with the `id` parameter as follows:

    ```ruby
    question = McQuestion.find(params[:id])
    ```

    For the index action which displays all the records from that table, we should use the `all` method as follows:

    ```ruby
    questions = McQuestion.all
    ```

    You will also need to pass those variables into the `locals` hash so they will be available in the view.

1. The show page should display all the _important_ attributes of the `mc_question` object (i.e. not the timestamps and not the id because that is shown in the URL). We could simply set up something like `<p>Answer: <%= answer %></p>` for each attribute but let's make it a little more interesting by showing the question and a set of disabled radio buttons for all the answer choices (the correct answer and distractor(s)).

    1. Create a `<p>` block for the question text as follows:

        ```erb
        <p><%= question.question %></p>
        ```

    1. Now we need to create the radio button group with all the answers. Lets make three radio button tags as follows:

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

        In the `radio_button_tag` options, we need to make sure the buttons are all disabled by adding `disabled: true`. We also need to be sure that only the correct answer is checked by setting the `checked` option to be true only for the answer radio button. For the unique label tag ids, we use string interpolation to execute some ruby code and put it inside the string (e.g. `#{question.answer}`).

    1. Coding each radio button works, but it seems like a lot of duplicate code. Instead, we can programmatically generate the radio buttons by looping through an array that contains all the choices and creating the radio button inside the loop.

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

1. The index page should display some data for each of the records in the associated database table. Sometimes this is done in a table with columns for each of the attributes but I will direct you to pgAdmin's show all records feature for that. In this demo, we will just be displaying the all the records on one page in the same way that they are displayed on their individual show pages. However, each question will be wrapped in its own div with a unique id generated by the `dom_id` helper.

    1. Create a heading for the page as follows:

        ```erb
        <h1>Multiple Choice Questions</h1>
        ```

    1. Recall that we added a local `questions` variable to the index page which contains all the McQuestions in the database. Add code which loops through each question and creates an empty div (for now) with a unique id for each question using the `dom_id` helper as follows:

        ```erb
        <% questions.each do |question| %>
          <div id="<%= dom_id(question) %>">
          </div>
        <% end %>
        ```

        Navigating to the index page now shows that three divs have been created with the form `<div id="mc_question_1">` where the number is the record id.

    1. The question display should be the same as on the show page, so we can copy the show page code into the empty div we have as follows.

        ```erb
        <% questions.each do |question| %>
          <div id="<%= dom_id(question) %>">
            <p><%= question.question %></p>

            <%
            choices = [question.answer, question.distractor_1, question.distractor_2]
            choices.each do |c|
            %>
              <div class="custom-control custom-radio">
                <%= radio_button_tag "guess", c, checked = c == question.answer, disabled: true %>
                <%= label_tag "guess_#{c}", c %>
              </div>

            <% end %>
          </div>
        <% end %>
        ```

    1. If we reload the index page now, we can see that all the questions are displayed, but only one radio button is checked on the entire page. Looking at the code we copied from the show page, the radio button tag id is "guess" for all the radio buttons. This was fine for the show page, but now means that the radio buttons for all the questions belong to the same group and only one can ever be checked at a time. We can fix this by generating a unique radio button group id for each question to the following:

        ```erb
        <%= radio_button_tag "guess_#{question.id}", c, checked = c == question.answer, disabled: true %>
        <%= label_tag "guess_#{question.id}_#{c}", c %>
        ```

        Now the group id should be unique for each question. I also changed the label tag id for consistency.


TODO: Maybe conclusion.

    