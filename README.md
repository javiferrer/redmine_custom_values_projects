redmine_custom_values_projects
==============================

This plugin allows users to limits the values of custom fiels (lists and checkbox) per project (only issues)

Features
--------

* Limit the values of custom fields per project (only issues)
* Works in the edit form, contextual menu and bulk edit.

Compatibility
-------------

Developed and tested on redmine 2.5.x

Installation
------------

* Clone https://github.com/javiferrer/redmine_custom_values_projects or download zip into  **redmine_dir/plugins/** folder
```
$ git clone https://github.com/javiferrer/redmine_custom_values_projects.git
```
* From redmine root directory, run: 
```
$ rake redmine:plugins:migrate RAILS_ENV=production
```
* Restart redmine

TODO
----

* Extend functionality to other models (projects, versions, etc...)

Licence
-------

GNU General Public License Version 2
