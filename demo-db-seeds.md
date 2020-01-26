---
title: 'Seeding the Database'
---

# {{ page.title }}


1. Add a couple sample questions in the `db/seeds.rb` file as follows:

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


