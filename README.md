Fuel Plugin Detach Swift
========================

Plugin to separate swift object and proxy from controllers.

# Guide

Please look at the [install guide](doc/content/installation_guide.rst),
[user guide](doc/content/user_guide.rst)
and [developer guide](doc/content/developer_guide.rst)

# Compatibility
The plugin depends on two commit in fuel-library that are merge starting from fuel 8.0:
* [Add override variables for plugin](https://github.com/openstack/fuel-library/commit/1e690ed95452297294c710a2f5886ef671d6b6da)
* [Allow a plugin to use custom swift role name](https://github.com/openstack/fuel-library/commit/c5537541eea5ba88d9c573e2b450a0d09437bee4)

At the moment no tests were done using Fuel 8.0. The tests are done on Fuel 7.0 applying manually the previous two commits.

