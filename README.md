![logo](logo.png)

Slideoff is a presentation tool. You write some slides in markdown, choose
a style and it displays it in HTML5. With a browser in full-screen, you can
make amazing presentations!

## Demo

Click here for a [demonstration](http://slideoff-test.dsiw-it.de/).

## Requirements

* **Ruby 1.9.3** or higher
* **Sass** for themes with sass files
* **CoffeeScript** for themes with coffee files
* **pygments** for syntax highlighting
* **wget** for static site generation
* **python3** for serving static presentation
* **git** for installing themes and makes your slides version controlled
* **scp** for uploading to remote host via SSH
* **wkhtmltopdf** for generating PDF
* **Browser** for viewing your presentation

## Features

* Write your slides in the simplest markup language: `markdown`
* Very portable presentation. You only need to upload your presentation to your web server via `scp` and open your URL.
* Change the theme via overriding CSS in `style.css` or create a new one.
* Install different themes
* Export to pdf via `slideoff pdf`
* Use the best features from web technologies. Be dynamic and interactive via Javascript, easy styling via CSS, ...


## First presentation

1. Install ruby and some dependencies from Requirements section
1. `gem install slideoff` Install Slideoff
1. `slideoff init mypres` Initialize presentation in `mypres/`
1. `$EDITOR presentation.json` and add your Flickr API key
1. `$EDITOR main/index.md` Edit your slides
1. `slideoff serve` Start server
1. Open <http://localhost:9000/>
1. Use the arrow keys to navigate between slides

## Themes

Several themes are available: `modern`, `io2012`, `shower`, `3d_slideshow`, `reveal`,
`html5rocks`, `CSSS` and `memories`. To choose the theme for your
presentation, edit the `presentation.json` file and change the `"theme"`
element.

**Attention: Some of the following features are only implemented in `modern` theme.**

Override some theme styles by using `style.css` in the presentation directory. Another way is to clone the theme via
`slideoff install_theme <git-url>` and make changes there. Be sure to use the correct theme name in `presentation.json`.

Assets are looked up in this order:

1. `./<asset_name>`
1. `.config/slideoff/themes/<theme_name>/<asset_name>`
1. `installation_dir/themes/<theme_name>/<asset_name>`
1. `installation_dir/themes/common/<asset_name>`


## Markup for the slides

These slides are written in [Markdown](http://daringfireball.net/projects/markdown/syntax)
and `!SLIDE` is the indicator for a new slide.

Example:

    !SLIDE
    # Title of the first slide
    ## A subtitle
    And some text...

    !SLIDE
    # Another slide

    * a
    * bullet
    * list

    !SLIDE
    # Third slide

    1. **bold**
    2. _italics_
    3. https://github.com/

Many more additional elements are added. See `main/index.md` after initialization to get an example.


## Syntax Highlighting

To highlight some code in your slides, you have to install
[pygments](http://pygments.org/). Then, surround your code with backticks
like this:

    ```ruby
    class Foobar
      def baz
        puts "Foobar says baz"
      end
    end
    ```

Different syntax highlighting styles exist in modern theme: `colorful`, `github`, `solarized-light`, `solarized-dark`


## Formulas (modern theme)

[MathJax](https://www.mathjax.org) is integrated and you can write your formulas in [LaTeX](https://en.wikibooks.org/wiki/LaTeX/Mathematics). You need to wrap it with `<p>`. Example:

    <p>
    Pythagoras as inline equation: \( a^2 + b^2 = c^2 \)
    </p>

    <p>
    Fibonacci as displayed equation:
    $$
      F_n =
      \begin{cases}
      n & \quad \text{if } n \leq 1 \\
      F_{i-1} + F_{i-2} & \quad \text{otherwise} \\
      \end{cases}
    $$
    </p>


## Flickr integration (modern theme)

Use Flickr photos like this one [22565509](https://secure.flickr.com/photos/scoobymoo/22565509):

```
!F[22565509]
```

Only the ID of the photo is relevant. All other information like image source, title, author or license are requested via the Flickr API. So it's important to generate a Flickr API key (
<https://secure.flickr.com/services/apps/create/>). You have to specify this key in your `presentation.json`.


## Boxes (modern theme)

```
!SLIDE
#Boxes

+++
+++Normal box
+++Content

+++shadow
+++Box with shadow
+++Content

+++box-alert
+++Alert box
+++Content
```


## Description list (modern theme)

```
!SLIDE
#Description list

Elephant
  : big animal
House
  : big garage
Car
  : big bike with four wheels
Smartphone
  : smart mobile phone with touch display
```


## Colors

Highlight text with red background:

```
==red==text==
```

or red text:

```
__red__text__
```


## Incremental view of slide (modern theme)

If you like to display some information incrementally, you can do it! If you specify an additional slide class `incr-list`
and all `li`-HTML-Elements will be displayed after some additional key strokes. For example:

```
!SLIDE incr-list

* First item will be displayed after first key stroke
* Second item will be displayed after second key stroke
* Third item will be displayed after third key stroke
```

If you like to add some opacity to visited elements, you can add `incr-list hover` to `!SLIDE`.

You can incrementally show every element on the slide. You only have to add `!PAUSE` to your slide. For example:

```
!SLIDE

This paragraph will be displayed first.

!PAUSE

+++box-red shadow
+++Box
+++This box is displayed after one next key stroke.
```

Try it in your example presentation after initialization.

You can add many states to one slide via the following snippet:

```
!SLIDE
...
!STEPS[n]
```

After each keystroke a class `step-i` is added to the `.slide` element while `i` is a number betweet 0 and
`n-1`. So you can change your styling for these different states. For example you can translate an element via CSS.
After these `n` keystrokes the next slide will be displayed.


## Issues or Suggestions

Found an issue or have a suggestion? Please report it on
[Github's issue tracker](http://github.com/DSIW/slideoff/issues).

## Credits

Bruno Michel is the guy who made [Slide'em up](https://github.com/nono/slide-em-up) and Scott Chacon is the guy who made
[ShowOff](https://github.com/schacon/showoff).  Slideoff is based on Slide'em up and Showoff.

Themes were picked from the internet. Thanks to:

- Hakim El Hattab for 3d_slideshow and reveal
- Google for html5rocks
- Vadim Makeev for shower
- Lea Verou for CSSS (and its modified version, memories)
- Google for io2012

♡2014 by DSIW. Copying is an act of love. Please copy and share.
Released under the MIT license
