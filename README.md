[![Build Status](https://github.com/cucumber-school/scripts/workflows/html/badge.svg)](https://github.com/cucumber-school/scripts/actions)

# Cucumber School - Video Scripts

This repo contains the scripts and other artefacts used to generate the video courses hosted at https://school.cucumber.io

Video and audio assets are stored on Google Drive, [here](https://drive.google.com/drive/u/2/folders/1UevNOmYoxXFosSrg_wxfretQmJxunjv4).

## Reading the scripts

The scripts can be read [here](https://cucumber-school.github.io/scripts/) as HTML pages generated by AsciiDoc from the source files in this repository. The pages are built by a [GitHub action](https://github.com/cucumber-school/scripts/blob/master/.github/workflows/html.yml) and hosted on GitHub pages.

## Generating the script HTML

To work on the scripts locally, you'll need to install Ruby and Bundler.

To compile the project into a set of HTML files, run the following command:

```
  bundle exec rake
```

This will produce an html file under `public/<course>/index.<language>.html` for each available programming language variant of each course, and a `public/index.html` to navigate to them.

### Continuous build

You can use Guard together with a [LiveReload](http://livereload.com/) plugin for your browser to automatically re-generate and refresh the HTML in your browser.

```
  bundle exec guard
```

### Working on code storyboard branches

The source code for most of the chapters is kept in on [orphan branches](https://git-scm.com/docs/git-checkout/1.7.3.1#git-checkout---orphan) named after the chapter and language, e.g. [`chapter-03-code-ruby`](https://github.com/cucumber-school/scripts/commits/chapter-03-code-ruby)

The idea is to create a storyboard for the code in the chapter in the branch, with one commit each time something happens. To create a new chapter code branch, use these commands:

    git checkout --orphan chapter-0n-code-<lang> # where n is the chapter number and <lang> is the language
    rm -rf . # because otherwise all the files you just had in HEAD will get checked in!
    echo "content\npublic\n" > .gitignore
    git add --all
    git commit -m "Initial commit"

Now you can work on the storyboard. If you mess something up, use `git rebase` to fix it:

    git rebase -i --root

This will show you all the commits in the branch, and you can go back and rewrite history until you have something you're happy with.

### Unrolling storyboards into your branch

Once you have your storyboard, you can unroll each of the commits from the storyboard into a `content/<course>/<chapter>/code/<language>`
folder, allowing you to include snippets of the code in the AsciiDoc script.

To unroll the storyboard branches, run this command:

    bundle exec rake code

Or only for a specific language:

    bundle exec rake code[ruby]

Don't forget to push your storyboard branch too!

    git push --force chapter-0n-code-<lang>

### Workflow tip: iterating between storyboard and script

Sometimes you want to work on the code and the script at the same time. It's a hassle to keep switching
branches in this situation. A good tip is to use `git worktree`, like this:

````
git worktree add <new-path-for-worktree> <branch-to-work-on-in-worktree>
````

The `new-path-for-worktree` should be **outside** the existing git repo.

You can work on the code branch in the `worktree` branch, and the script on `master`. When you've made commits to the worktree, they will be reflected in the repo. Then you can run `rake code` to unroll the latest commits and make them available to your script.

Once you have committed your code changes, it's safe to remove the worktree:

````
git worktree remove <new-path-for-worktree>
````

When everything is done, push *both branches* (master and your code branch) to GitHub. You may need to force push the code branch.

## License

Site content is licensed under CC-BY-4.0. CC-BY-4.0 gives you permission to use the content for almost any purpose but does not grant you any trademark permissions, so long as you note the license and give credit, such as follows:

    Content based on github.com/cucumber-school/ used under the CC-BY-4.0 license.

Code used to build and test the site as well as code samples on the site, if any, are licensed under CC0-1.0. CC0 waives all copyright restrictions but does not grant you any trademark permissions.

This means you can use the content and code in this repository except for Cucumber trademarks in your projects.

When you contribute to this repository you are doing so under the above licenses.
