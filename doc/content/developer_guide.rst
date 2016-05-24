Developer Guide
==============

This guide is intended for developers or for people that want to
investigate more in details about the detach-swift-plugin.

Intro
+++++
This plugin allow to separate swift componente from controllers.
It's possibile to separate only the object part (the storage part)
leaving the proxy part (the control and api part) in the controllers
and both roles in separate nodes. At the moment it's not possible to
install proxy and object parts in the same node.

Architecture
++++++++++++
Separating only the object part the api and control section are leaving
on the controllers: all api and control software run on them and storage
part run on separate nodes.

 .. figure:: _static/architecture_1.png
     :alt: Architecture when proxy are installed on controllers
     :scale: 90%
     :align: center
     :figclass: align-center

     Architecture when proxy are installed on controllers

 .. figure:: _static/architecture_2.png
    :alt: Architecture when proxy are installed on dedicated nodes
    :scale: 90%
    :align: center
    :figclass: align-center

    Architecture when proxy are installed on dedicated nodes

When swift proxy are installed on controllers, the primary controller is also
the primary swift proxy. The ring files are created here; then the object nodes
take these rings file from primary-controller with rsync.
The object nodes are connected to the management network. The endpoint of the
service points to controllers.

When proxies are on separated nodes the architecture is more complex.
The proxies nodes have a new management virtual ip and a new public virtual ip.
A new instance of haproxy are installed and configured inside the proxies and
they are independent to controllers. The endpoint in this case point to new
virtual ips.

Deployment notes
++++++++++++++++
The puppet script are contained in deployment_script folder.

- haproxy.pp: this is the modular script of osnailyfacter for haproxy for swift.
  It uses the management and public virtual ip for configure service for swift.
- swift_hiera_override.pp: overrides some variables used for swift deployment process.
  It selects where and if install swift-proxy and swift-object and write the node swift list
- swift_hiera_override_predeploy: runs before global yaml task, it is used for override
  the role name for globals.
- update_rsyncd.pp and update_rsyncd.sh: in the process of configuration of rsync,
  the /etc/rsyncd.conf file is not correctly configured. With this trick the plugin forces
  the updating of the script.
