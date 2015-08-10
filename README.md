# RedmineIssuesTree

This is a plugin for [Redmine 3](http://www.redmine.org/). It's provides a tree view of the issues list.

## Installation

Use a common Redmine [installation guide](http://www.redmine.org/projects/redmine/wiki/Plugins).
This plugin hasn't any migration. So, you just need to copy source code into a proper folder and
run `bundle` for install required gems.

## Features

* Plugin based on one of the modification of the [jQueryTreetable](https://github.com/ludo/jquery-treetable) library.
This lib can be found [here](https://github.com/Loriowar/jquery-treetable/tree/multiline_cell_fix).
Major differences described in [pull request](https://github.com/ludo/jquery-treetable/pull/133).
* It redefine a default template `issues/index.html`. If you redefine it too, then you can implement several hooks
and have a same result. You can look at `lib/redmine_issues_tree/hook_listner.rb` and get list of all used hooks.
Here is a list of hooks, added by plugin:
  * `view_issues_index_header` in the top of `issues/index.html` for including js and css;
  * `view_issues_index_contextual` in contextual area for additional links in the top of issues table;
  * `view_issues_tree_index_contextual` for same purpose, but on a tree view page.