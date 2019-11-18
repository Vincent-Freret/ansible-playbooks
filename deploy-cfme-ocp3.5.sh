#!/bin/bash
# Deploying OCP 3.5 CFME 4.5 images and installation 


echo "Retrieve and ad OCP images to registry"
oc import-image my-cloudforms45/cfme-openshift-app --from=registry.access.redhat.com/cloudforms45/cfme-openshift-app --confirm
oc import-image my-cloudforms45/cfme-openshift-memcached --from=registry.access.redhat.com/cloudforms45/cfme-openshift-memcached --confirm
oc import-image my-cloudforms45/cfme-openshift-postgresql --from=registry.access.redhat.com/cloudforms45/cfme-openshift-postgresql --confirm

echo "Prepare CFME deployment"


oc new-project cfme-cmp --description="CloudMmanagement PF CloudForms" --display-name="cmfe-cmp"
oc adm policy add-scc-to-user anyuid system:serviceaccount:cfme-cmp:cfme-anyuid
oc describe scc anyuid | grep Users
oc adm policy add-scc-to-user privileged system:serviceaccount:cfme-cmp:default
oc describe scc privileged | grep Users

oc create -f cfme-pv-db-example.yaml
oc create -f cfme-pv-server-example.yaml

oc get pv

echo "Deploy CFME on OCP"
oc create -f /usr/share/openshift/examples/cfme-templates/cfme-template.yaml
oc get templates
oc new-app --template=cloudforms


