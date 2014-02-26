# Slideoff

Slideoff is a presentation tool. You write some slides in markdown, choose
a style and it displays it in HTML5. With a browser in full-screen, you can
make amazing presentations!

## Requirements

* **Ruby 1.9.3** or higher
* **Sass** for themes with sass files
* **CoffeeScript** for themes with coffee files
* **Python3** for serving static presentation
* **Wget** for static site generation
* **Pygments** for syntax highlighting
* **Browser** for viewing presentation


## First presentation

1. `gem install slideoff` Install Slideoff
1. `slideoff init mypres` Initialize presentation in `mypres/`
1. `$EDITOR presentation.json` and add your Flickr API key
1. `$EDITOR main/slides.md` Edit your slides
1. `slideoff serve` Start server
1. Open <http://localhost:9000/>
1. Use the arrows keys to navigate between slides

## Themes

Several themes are available: `io2012`, `shower`, `3d_slideshow`, `reveal`,
`html5rocks`, `CSSS`, `memories` and `modern`. To choose the theme for your
presentation, edit the `presentation.json` file and change the `"theme"`
element.

You can also create your own theme, for example, by copying the template:

```sh
mkdir -p ~/.slideoff
cp -r themes/template ~/.slideoff/my-theme
$EDITOR ~/.slideoff/my-theme/README
```


## Markup for the slides

This slides are writen in [Markdown](http://daringfireball.net/projects/markdown/syntax)
and `!SLIDE` is the indicator for a new slide.

Example:

    !SLIDE
    # Title of the first slide #
    ## A subtitle ##
    And some text...

    !SLIDE
    # Another slide #

    * a
    * bullet
    * list

    !SLIDE
    # Third slide #

    1. **bold**
    2. _italics_
    3. https://github.com/

Many more additional elements are added. See `main/slides.md` after initialization to get an example.


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


##Flickr integration

To integrate this [Flickr photo (22565509)](https://secure.flickr.com/photos/scoobymoo/22565509) you have to write this:

```
!F[22565509]
```

Only the ID of the photo is relevant. All other information like image source, title, author or license are requested via the Flickr
API. So it's important to generate a Flickr API key to have access to the API. You can do it on
<https://secure.flickr.com/services/apps/create/>. You have to specify this key in your `presentation.json`.


##Incremental view of slide

If you like to display some information incrementally, you can do it! If you specify an additional slide class `incr`,
all `li`-HTML-Elements will be displayed after some key strokes. For example:

```
!SLIDE incr

* First item will be displayed after one key stroke
* Second item will be displayed after two key strokes
* Third item will be displayed after three key strokes
```

If you like to add some opacity to visited elements, you can add `incr hover` to `!SLIDE`.

If you don't like to increment only list items, you can do it more precise. You only have to add `!PAUSE` in your slide. For example:

!SLIDE

This paragraph will be displayed first.

!PAUSE

```
+++box-red shadow
+++Box
+++This box is displayed after one next key stroke.
```

Try it in your example presentation after initialization.

## Export to PDF

You can export your presentation to PDF by installing
[phantomjs](http://phantomjs.org/) and then run `slideoff2pdf`.


## Issues or Suggestions

Found an issue or have a suggestion? Please report it on
[Github's issue tracker](http://github.com/DSIW/slideoff/issues).

If you wants to make a pull request, please check the specs before:

    bundle exec spec/slideoff_spec.rb


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
