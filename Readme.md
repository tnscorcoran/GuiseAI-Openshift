# Deploy on openshift
oc new-app --name guise-cmline  https://github.com/arslankhanali/GuiseAI-Openshift  
oc expose svc guise-cmlin  
oc delete all -l app=guise-cmline
# MLOps
## Tekton
1. Install pipeline operator
2. Create pipeline instance
3. Create workspace
   1. workspace = edge-workspace
4. git clone
   1.  display name = git-clone
   2.  url = https://github.com/arslankhanali/GuiseAI-Openshift
   3.  workspace = edge-workspace
5. buildah
   1. display name = buildah
   2. IMAGE = quay.io/arslankhanali/guise
   3. workspace = edge-workspace
6. Create a secret to access quay.io to push to it
   1. https://tekton.dev/docs/pipelines/auth/#configuring-basic-auth-authentication-for-docker
   2. ```yaml
      apiVersion: v1
      kind: Secret
      metadata:
      name: basic-user-pass
      annotations:
         tekton.dev/docker-0: https://quay.io # Described below
      type: kubernetes.io/basic-auth
      stringData:
      username: arslankhanali
      password: <pass>
      ```
7. Give service account 'pipeline' access to the secret
   1. edit yaml
   2. ```yaml
      secrets:
         - name: pipeline-dockercfg-fgppj
         - name: basic-user-pass
      ```

## Argo cd
1. Build using manifest folder
2. Install gitops operator
3. Create argocd instance
4. edit yaml. In line 209
5. ```yaml
   rbac:
      - defaultPolicy: 'role:admin'
   ```
6. Login to argo cd using the route
7. Create a project
   1. App name = <>
   2. project = default
   3. repo url = https://github.com/arslankhanali/GuiseAI-Openshift
   4. path = manifest
   5. Sync policy = automatic
   6. destination url = https://kubernetes.default.svc
   7. namespace = <user2>
8. Test 
   1. Delete the app
      1. oc delete all -l app=guiseai 
   2. See in Argo cd UI that the components are redeployed immediatly
   3. Try with both self heal enabled and disabled.
      1. With disabled, since service is not deployed, the route deployment will break
      2. With enabled, route will be exposed automatically once the service is up



