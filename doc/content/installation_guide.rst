Installation Guide
==================

Prerequisites
+++++++++++++

+----------------------------------+-----------------+
| Requirement                      | Version/Comment |
+==================================+=================+
| Mirantis OpenStack compatility   | 8.0 or higher   |
+----------------------------------+-----------------+
| Mirantis OpenStack compatility   | 7.0 with patch   |
+----------------------------------+-----------------+
| Distribution Supported           | Ubuntu          |
+----------------------------------+-----------------+

Where to download the plugin
++++++++++++++++++++++++++++

The plugin in not yet distribuited as package.  You have to build it
yourself.

The code is hosted by `SmartInfrastructures
<https://github.com/SmartInfrastructures/fuel-plugin-detach-swift>`

How to build the plugin
+++++++++++++++++++++++

Please refer to the `Fuel Plugins wiki
<https://wiki.openstack.org/wiki/Fuel/Plugins>`_ to build the plugin
by yourself, version 2.0.0 (or higher) of the Fuel Plugin Builder is
required.

.. code:: bash

    git clone https://github.com/SmartInfrastructures/fuel-plugin-detach-swift.git
    cd fuel-plugin-detach-swift
    fuel-plugin-builder --build .

How to install the plugin
+++++++++++++++++++++++++

Copy the plugin file to the Fuel Master node.

.. code:: bash

    scp detach-swift-*.noarch.rpm root@<Fuel Master node IP address>:

Install the plugin using the fuel command line:

.. code:: bash

    ssh root@<Fuel Master node IP address>
    fuel plugins --install detach-swift-*.noarch.rpm

Verify that the plugin is installed correctly:

.. code:: bash

    fuel plugins --list
