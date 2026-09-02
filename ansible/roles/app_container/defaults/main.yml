---
# Generic defaults for the app_container role.
# Consuming playbooks override these per-application.
app_container_name: "app"
app_container_image: ""            # required — the image to run (e.g. xabiere15/charlotte-api:latest)
app_container_port: 8080          # host:container port mapping
app_container_env: {}             # dict of plain env vars to inject
app_container_secret_id: ""       # optional — Secrets Manager secret to fetch
app_container_secret_region: "us-east-1"
app_container_secret_env_var: ""  # env var name to inject the fetched secret into
app_container_secret_json_key: "" # if secret is JSON, extract this key
app_container_health_path: "/actuator/health"
