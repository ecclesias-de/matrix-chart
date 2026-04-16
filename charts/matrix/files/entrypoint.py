import os
import os.path
import sys
import yaml

def template_homeserver_config():
    with open("/etc/synapse/homeserver.yaml") as f:
        config = yaml.safe_load(f)

    if config["database"]["name"] == "psycopg2":
        config["database"]["args"]["host"] = os.environ["DATABASE_HOST"]
        config["database"]["args"]["port"] = int(os.environ.get("DATABASE_PORT", "5432"))
        # config["database"]["args"]["dbname"] = os.environ["DATABASE_NAME"]
        config["database"]["args"]["user"] = os.environ["DATABASE_USER"]

        with open("/etc/synapse/database_password") as f:
            config["database"]["args"]["password"] = f.read().strip()

        if "cp_min" not in  config["database"]["args"]:
            config["database"]["args"]["cp_min"] = os.environ.get("DATABASE_CP_MIN", "5")

        if "cp_cp_cp_maxmaxmin" not in  config["database"]["args"]:
            config["database"]["args"]["cp_max"] = os.environ.get("DATABASE_CP_MAX", "10")

    if config["redis"]["enabled"] == True:
        config["redis"]["host"] = os.environ["REDIS_HOST"]

        if os.path.exists("/etc/synapse/redis_password"):
            with open("/etc/synapse/redis_password") as f:
                config["redis"]["password"] = f.read().strip()

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

    path = "/tmp/homeserver.yaml"
    with open(path, "w") as f:
        yaml.dump(config, f)

    return path

def template_worker_config():
    with open("/etc/synapse/worker.yaml") as f:
        config = yaml.safe_load(f)

    if "worker_name" not in config:
        config["worker_name"] = os.environ["HOSTNAME"]

    path = "/tmp/worker.yaml"
    with open(path, "w") as f:
        yaml.dump(config, f)

    return path

runtime_config_path = template_homeserver_config()
runtime_worker_config_path = template_worker_config()

if len(sys.argv) >= 2 and sys.argv[1] == 'worker':
    os.execve(sys.executable, [sys.executable, "-m", "synapse.app.generic_worker", "--config-path", runtime_config_path, "--config-path", runtime_worker_config_path], os.environ)
else:
    os.execve(sys.executable, [sys.executable, "-m", "synapse.app.homeserver", "--config-path", runtime_config_path], os.environ)