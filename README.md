# RedmineIssuesTree [![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KGN52ZXA8J7B8)

This is a plugin for [Redmine](http://www.redmine.org/). It's provides a tree view of the issues list.
[Official page on Redmine.org](https://www.redmine.org/plugins/redmine_issues_tree).

## Compatibility

Plugin tested with `3.3.*`, `3.2.*`, `3.1.*`, `3.0.*`, `2.6.*` and `2.5.*` versions of Redmine.

## Features

* Dynamically loading of nested issues by click.
* Minimal changes in default plain issues index page.
* Tree view available in context of project and in global scope of all projects.
* Plugin has setting (in admin menu) to enable a tree_view as a standard view for all issues#index page. Keep in mind what
speed of this feature related with amount of issues in project and in case of >1000 issues this can work drastically slow.

## Support

Features are added only for `3.x` version. Bugfix and locales available for all version from `2.6.x` and higer. 

## Usage

This is a `master` branch. DO NOT USE THIS BRANCH. Please, use a branch with name corresponding to your
Redmine version i.e. `3.3.x`, `3.2.x` and so on.

## Examples of interface

You can find them on the [official plugin page](https://www.redmine.org/plugins/redmine_issues_tree).

## Installation

Use a common Redmine [installation guide](http://www.redmine.org/projects/redmine/wiki/Plugins).
This plugin hasn't any migration. So, you just need to copy source code into a proper folder and
run `bundle` for install required gems.

## Information for developers and contributors

* Plugin based on one of the modification of the [jQueryTreetable](https://github.com/ludo/jquery-treetable) library.
This lib can be found [here](https://github.com/Loriowar/jquery-treetable/tree/multiline_cell_fix).
Major differences described in [pull request](https://github.com/ludo/jquery-treetable/pull/133).
* It redefine a default template `issues/index.html`. If you redefine it too, then you can implement several hooks
and have a same result. You can look at `lib/redmine_issues_tree/hook_listner.rb` and get list of all used hooks.
Here is a list of hooks, added by plugin:
  * `view_issues_index_header` in the top of `issues/index.html` for including js and css;
  * `view_issues_index_contextual` in contextual area for additional links in the top of issues table;
  * `view_issues_tree_index_contextual` for same purpose, but on a tree view page.
