# matrix chart
This repo contains the base charts, for our matrix setup(s).

It is intended to be used as a multi tenant setup. Where each tenant gets is own synapse (homesever) and element (web client).
Shared servers (e.g. the Push Gateway) get there own chart. All per tenant services were/still are defined inside the matrix chart. Element already is in its own chart. They should be split into multiple charts. Thats better for updating production release. As you can be sure to not restart the wrong service accidentally.

Out setup is indented to be used with tine as a data source. These features are provided by tine
+ tine is used as open id provider for sso
+ tine is used to mange room membership.
+ tine will be ~~is~~ used as a directory search backend.


Room management is build using [matrix-corporal](https://github.com/devture/matrix-corporal). For which tine generates and pushes the policies. Room management is the only matrix corporal feature we really use currently.

Directory search is build using [ma1sd](https://github.com/ma1uta/ma1sd/blob/master/docs/features/directory.md). Which uses tine as a backend. For multi tenant setups it a central tine can be used. Which provides directory search for the whole organization.

## requirements
1. This chart uses a custom entrypoint script (`charts/matrix/files/entrypoint.py`) to inject db config and secrets into the homeserver.yaml. You can either build a custom synapse image with `/entrypoint.py`. Or set `synapse.inject_entrypoint: true` to inject the entrypoint as a config map.
  A custom synapse image can be specified like this:
  ```yaml
    synapse:
      deployment:
      image:
        repository: your/oci/repository
        tag: your_tag
  ```
2. Matrix-corporal needs the synapse module devture/matrix-synapse-shared-secret-auth to be installed and configured. Therefor you need to build a custom synapse docker image. You can install shared-secret-auth like this:
  ```sh
    curl https://raw.githubusercontent.com/devture/matrix-synapse-shared-secret-auth/2.0.3/shared_secret_authenticator.py \
        -o $(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')/shared_secret_authenticator.py
  ```
  This configuration needs to be added to load shared-secret-auth and configure it to be useable by matrix-corporal:
  ```yaml
    synapse:
      homeserverConfig:
        modules:
        - module: shared_secret_authenticator.SharedSecretAuthProvider
          config:
            m_login_password_support_enabled: true
            # shared_secret: is injected by the entrypoint
  ```
## installation
1. You need to configure which database is used. This chart dose not come with one. 
  For dev/testing you can use sqlite:
  ```yaml
    synapse:
      homeserverConfig:
        database:
          name: sqlite3
          args:
            # /data is a mounted persisted dir primarily used for the media_store
            database: /data/homeserver.db
  ```
2. Some mandatory secrets and hostnames need to be configured. Take a look at `sample-values.yaml` and or `tine-sample-values.yaml` (tine setup specific config) what you need to configure.
3. Install chart - with matrix corporal disabled:
  ```sh
  helm upgrade --install --namespace $NAMESPACE $RELEASE ./charts/matrix -f $PATH_TO_VALUES_YAML --set corporal.enabled=false
  ```
  Before the shared secret authenticator config needs to be commented out.
  ```
  synapse:
    homeserverConfig:
      modules:
      # # config for shared_secret_auth module. needed for matrix-corporal
      # - module: shared_secret_authenticator.SharedSecretAuthProvider
      #   config:
      #     m_login_password_support_enabled: true
  ```
4. Matrix-corporal needs an admin user to be created. The user name can be configured like this: (this is the default config)
  ```yaml
  corporal:
    config:
      Corporal:
        UserId: "@corporal:{{ .Values.synapse.homeserverConfig.server_name }}"
  ```
  To create the user you need to run `register_new_matrix_user` inside of the synapse container. You can to this like this: `kubectl exec -it deployments/synapse-$RELEASE-matrix -- register_new_matrix_user -c /tmp/homeserver.yaml`

  The user name must match the configured on. Only the local username is required e.g. `corporal`. 
  The password can be whatever you want. But you should safe it to you password manager. ( Matrix corporal dose not join rooms it should manage automatically. Therefore you either need to log in as the corporal user and join the rooms or use the synapse admin join api. ) 
  Make sure the user is an admin user.
5. Install chart - now with matrix corporal:
  ```sh
  helm upgrade --install --namespace $NAMESPACE $RELEASE ./charts/matrix -f $PATH_TO_VALUES_YAML
  ```
  Before the shared secret authenticator config needs to be commented in again.
6. Matrix-corporal will now deny any request, until it receives an initial policy. An initial empty policy can be pushed with curl:
```
curl -XPUT \
--data '{"schemaVersion": 1}' \ 
-H "Authorization: Bearer $vMATRIX_CORPORAL_AUTHORIZATION_BEARER_TOKEN" \
https://$SYNAPSE_HOSTNAME/_matrix/corporal/policy                                                            
```
The response should be `{}`. If it fails matrix-corporal may 


## config
### templating inside of configs
It is possible to use helm templating inside of the `values.yaml` for some configs like `synapse.homeserverConfig`, `wellknown.client` or `element.config`.
All these configs produce config files which get saved to config maps. The templates are rendered during creation of there respective config maps. 

Therefore caveats apply:
+ It is not possible to use `{{` or `}}` inside of these configs, as helm would exact it being part of its template. e.g: This is problem when defining jinja2 tempting for oidc usernames in the synapse homeserver config. To solve ths problem you need a template resulting in `{{` or `}}`. Helm templating dose not feature escaping. You can write double curly braces like this `{{ "{{" }}`
+ It is not possible to use a templated value somewhere else. E.g.: the wellknown ingress uses `{{ .Values.synapse.homeserverConfig.server_name }}` as host.If server_name would contain a template e.g. `{{ .Values.myownservernamevar }}`, the ingress would contain the template as literal string. And the string `{{ .Values.myownservernamevar }}` probably is not you servers hostname.
  It may be possible to use values in another templated section be do not do that, unless there is really no better solution
+ Some configs get covered to json. The conversion happens before the template rendering. If the template is not valid json it will be escaped, sometimes... Templates like `{{ .Values.element.ingress.hostname }}` are ok. But templates link `{{ include "synapse.basename" . }}` are not.
  If you are using more complex templates it may require some try and error. (It will not always be possible to achieve the desired effect. E.g. see the matrix corporal HomeserverApiEndpoint hack)

## 
<img src="https://erzbistum-hamburg.de/_layout/EBHH_Logo_hoch.png" alt="erzbistum-hamburg logo" width="200"/></br>
Mit freundlicher Unterstützung vom Erzbistum Hamburg