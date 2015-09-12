# RedmineIssuesTree [![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KGN52ZXA8J7B8)

This is a plugin for [Redmine](http://www.redmine.org/). It's provides a tree view of the issues list.

## Compatibility

This branch of plugin tested with `3.1.0` version of the Redmine. But there is a high probability of compatibility with other `3.1.*` versions.
If you have other version of the Redmine (for example, `2.*`), please, select another branch of this plugin.

## Examples of interface

You can find them on the [official plugin page](https://www.redmine.org/plugins/redmine_issues_tree).

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
