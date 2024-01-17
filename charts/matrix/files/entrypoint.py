import os
import sys
import yaml

with open("/etc/synapse/homeserver.yaml") as f:
    config = yaml.safe_load(f)

if config["database"]["name"] == "psycopg2":
    config["database"]["args"]["host"] = os.environ["DATABASE_HOST"]
    config["database"]["args"]["port"] = os.environ["DATABASE_PORT"]
    config["database"]["args"]["dbname"] = os.environ["DATABASE_NAME"]
    config["database"]["args"]["user"] = os.environ["DATABASE_USER"]

    with open("/etc/synapse/database_password") as f:
        config["database"]["args"]["password"] = f.read().strip()

if "modules" in config and config["modules"] is not None:
    for idx, x in enumerate(config["modules"]):
        if x["module"] == "shared_secret_authenticator.SharedSecretAuthProvider":
            if "config" not in x:
                config["modules"][idx]["config"] = {}

            with open("/etc/synapse/shared_secret_authenticator_secret") as f:
                config["modules"][idx]["config"]["shared_secret"] = f.read().strip()

            break
    
with open("/etc/synapse/macaroon_secret_key") as f:
    config["macaroon_secret_key"] = f.read().strip()

with open("/etc/synapse/form_secret") as f:
    config["form_secret"] = f.read().strip()

runtime_config_path = "/tmp/homeserver.yaml"
with open(runtime_config_path, "w") as f:
    yaml.dump(config, f)

os.execve(sys.executable, [sys.executable, "-m", "synapse.app.homeserver", "--config-path", runtime_config_path], os.environ)