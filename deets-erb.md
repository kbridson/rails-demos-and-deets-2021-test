---
layout: page
title: 'ERBs Explained'
permalink: /deets-erb/
---

# ERBs Explained

Understanding how ERBs work can be a bit confusing at first. This page aims to explain it in straightforward terms using a simple example.

Imagine that you have an app that stores song lyrics, and you want a page that prints the lyrics to a particular song. Instead of making a different HTML.ERB view for every song (which would be awful, of course), you want to have one template HTML.ERB that is parameterized such that it can be used to print any song's lyrics.

Here is just such an HTML.ERB view:

```erb
<h1><%= title %></h1>

<ul>
<% lyrics.each do |l| %>
    <li><%= l %></li>
<% end %>
</ul>
```

This HTML.ERB generates plain old HTML code such that there is a heading (`h1`) with the song title and a bullet list (`ul`) where each bullet item (`li`) is a lyric in the song. The `lyrics` variable references an array of strings, with each string having a different line of the song lyrics.

When a Rails controller renders this HTML.ERB code, the HTML.ERB code effectively behaves like the following Ruby code, where the `write` function concatenates its string argument onto the end of the plain old HTML string to be output:

```ruby
write('<h1>')
write(title)
write('<h1>')
write('\n')
write('<ul>\n')
lyrics.each do |l|
    write('    <li>')
    write(l)
    write('</li>\n')
end
write('</ul>\n')
```

In the above Ruby code, notice how all the plain old HTML code was wrapped in `write` statements. In contrast, the embedded Ruby code (`<% ... %>`) is simply inserted between the `write` statements. The embedded Ruby code inside the element, `<%= ... %>` (note the `=` sign), was additionally wrapped in a `write` statement that will write whatever value is returned by the embedded Ruby code.

So, imagine the above HTML.ERB was rended with the `lyrics` array set as follows:

```ruby
title = 'Go Tigers Go'
lyrics = [
    'Go on to victory',
    'Be a winner through and through',
    'Fight Tigers Fight',
    '\'Cause we\'re going all the way'
]
```

The generated HTML would look like this:

```html
<h1>Go Tigers Go</h1>

<ul>
    <li>Go on to victory</li>
    <li>Be a winner through and through</li>
    <li>Fight Tigers Fight</li>
    <li>'Cause we're going all the way</li>
</ul>

```

## Further Reading

For more info on ERB, see the official Ruby documentation: <https://ruby-doc.org/stdlib-2.6.4/libdoc/erb/rdoc/ERB.html>
