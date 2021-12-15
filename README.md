Replication materials for "Execution by organ procurement: Breaching the dead donor rule in China" by Matthew P. Robertson and Jacob Lavee
=====================================

> This repository contains the replication materials for the above paper. 
> Following is an explanation of the folder structure, the files, and the code that performed the analysis. 

### Structure of the project

    .
    ├── appendix_1             # All files necessary for knitting Appendix 1
    ├── appendix_2             # All files necessary for knitting Appendix 2
    ├── code                   # All R and bash scripts plus a Word macro 
    ├── data                   # All raw and processed txt, pdf, & analysis files
    ├── figures                # Figures used in the ms.
    ├── ms_rr                  # The manuscript for the revised and resubmitted version of the paper
    ├── tables                 # Used in the ms
    ├── LICENSE
    └── README.md

> Note: The project is around 1.5gb

### Appendix 1

The file and folder structure should be intuitive, but: 

- `/references` contains the bibliographic material of the papers consulted for the pilot study; 
- `/txt` contains the full text files that were consulted;
- `appendix_1.Rmd` file knits to `.docx` format through the template file, used also in the other appendix and the manuscript file.

### Appendix 2

These file names should also be straightforward to interpret. `bdd_included.csv` and `bdd_included.csv`

Often it is beneficial to include some reference data into the project, such as
Rich Text Format (RTF) documentation, which is usually stored into the `docs`
or, less commonly, into the `doc` folder.

    .
    ├── ...
    ├── docs                    # Documentation files (alternatively `doc`)
    │   ├── TOC.md              # Table of contents
    │   ├── faq.md              # Frequently asked questions
    │   ├── misc.md             # Miscellaneous information
    │   ├── usage.md            # Getting started guide
    │   └── ...                 # etc.
    └── ...

> **Samples**: [HTML5 Boilerplate](https://github.com/h5bp/html5-boilerplate) `doc`, [Backbone](https://github.com/jashkenas/backbone) `docs`, [three.js](https://github.com/mrdoob/three.js) `docs`, [GitLab](https://github.com/gitlabhq/gitlabhq) `doc`, [Underscore.js](https://github.com/jashkenas/underscore) `docs`, [Discourse](https://github.com/emberjs/ember.js) `docs`, [Grunt](https://github.com/gruntjs/grunt) `docs`, [Emscripten](https://github.com/kripken/emscripten) `docs`, [RethinkDB](https://github.com/rethinkdb/rethinkdb) `docs`, [RequireJS](https://github.com/jrburke/requirejs) `docs`, [GitHub Hubot](https://github.com/github/hubot) `docs`, [Twitter Flight](https://github.com/flightjs/flight) `doc`, [Video.js](https://github.com/videojs/video.js) `docs`, [Bitcoin](https://github.com/bitcoin/bitcoin) `doc`, [MongoDB](https://github.com/mongodb/mongo) `docs`, [Facebook React](https://github.com/facebook/react) `docs`, [libgit2](https://github.com/libgit2/libgit2) `docs`, [Stylus](https://github.com/LearnBoost/stylus) `docs`, [Gulp](https://github.com/gulpjs/gulp) `docs`, [Brunch](https://github.com/brunch/brunch) `docs`

### Scripts

...

### Tools and utilities

...

### Compiled files

...

### 3rd party libraries

...

### License information

If you want to share your work with others, please consider choosing an open
source license and include the text of the license into your project.
The text of a license is usually stored in the `LICENSE` (or `LICENSE.txt`,
`LICENSE.md`) file in the root of the project.

> You’re under no obligation to choose a license and it’s your right not to
> include one with your code or project. But please note that opting out of
> open source licenses doesn’t mean you’re opting out of copyright law.
> 
> You’ll have to check with your own legal counsel regarding your particular
> project, but generally speaking, the absence of a license means that default
> copyright laws apply. This means that you retain all rights to your source
> code and that nobody else may reproduce, distribute, or create derivative
> works from your work. This might not be what you intend.
>
> Even in the absence of a license file, you may grant some rights in cases
> where you publish your source code to a site that requires accepting terms
> of service. For example, if you publish your source code in a public
> repository on GitHub, you have accepted the [Terms of Service](https://help.github.com/articles/github-terms-of-service)
> which do allow other GitHub users some rights. Specifically, you allow others
> to view and fork your repository.

For more info on how to choose a license for an open source project, please
refer to http://choosealicense.com

This readme was adapted from this helpful example: https://github.com/kriasoft/Folder-Structure-Conventions/blob/master/README.md