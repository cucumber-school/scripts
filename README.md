# Fundamentals of BDD

This repo contains the scripts and other artefacts used to generate the Fundamentals of BDD Courses for Java, Ruby annd JavaScript hosted at https://school.cucumber.io

## License

Site content is licensed under CC-BY-4.0. CC-BY-4.0 gives you permission to use the content for almost any purpose but does not grant you any trademark permissions, so long as you note the license and give credit, such as follows:

    Content based on github.com/cucumber-school/ used under the CC-BY-4.0 license.

Code used to build and test the site as well as code samples on the site, if any, are licensed under CC0-1.0. CC0 waives all copyright restrictions but does not grant you any trademark permissions.

This means you can use the content and code in this repository except for Cucumber trademarks in your projects.

When you contribute to this repository you are doing so under the above licenses.

## Compilation

To compile the project into a set of HTML files, run the following command:

```
  rake "html"
```

This will produce an html file under `public/<language>/index.html` for each available language.

You can list all available languages with:

```
  rake list
```

To compile only the files for a specific language, you can pass an argument to the `html` rake task, like this:

```
  rake "html[ruby]"
```
