User Guide
==========

Intro
+++++

- Create a new environment with the Fuel UI wizard. 

- Click on the Settings tab of the Fuel web UI.

  Select the “Detach swift” tab, then enable
  the plugin by clicking on the “Detach swift” checkbox and
  fill-in the required fiels:

  .. image:: _static/plugin_gui.png
     :alt: A screen-shot of the detach-swift-plugin Settings UI
     :scale: 90%

- For installing swift proxy on separated nodes check
  the "Install swift proxy on separate node(s)" checkbox.

  .. image:: _static/check_separate_proxy.png
     :alt: A screen-shot of the detach-swift-plugin Settings UI
     :scale: 90%

- Go to the nodes page.

- Add computes and controllers node.

- Add one or more 'standalone-swift-object'. On this nodes are
  installed the storage part of swift.

- For the swift-proxy there are two cases depending on if
  "Install swift proxy on separate node(s)" is enable:

    1. if enable add one ore more 'standalone-swift-proxy'. On this node
    are installed the swift control part.
    
    2. if not enable the swift proxies are install on controllers and
    there is no the need and neither the possibility to install 'standalone-swift-proxy'

  .. image:: _static/nodes_proxy_yes.png
     :alt: Case where 'standalone-swift-proxy' are checked.
     :scale: 90%

  .. image:: _static/nodes_proxy_no.png
     :alt: Case where 'standalone-swift-proxy' are not checked
     :scale: 90%

- Deploy the changes

How to use the plugin
+++++++++++++++++++++

In both case, i.e. with "Install swift proxy on separate node(s)" is checked or not,
swift is configured correctly. In the case where it is enabled the swift endpoint 
is set to swift proxy virtual ip, otherwise it is set to controllers.