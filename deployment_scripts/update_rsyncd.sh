#!/bin/bash

rsync_fragments='/etc/rsync.d'
conf_file='/etc/rsyncd.conf'

ls $rsync_fragments/frag-* 1>/dev/null 2>/dev/null 
if [ $? -eq 0 ]
then 
	cat ${rsync_fragments}/header ${rsync_fragments}/frag-* > ${conf_file}
else
	cat ${rsync_fragments}/header > ${conf_file}
fi