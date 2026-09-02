---
- name: Ensure Docker is running
  ansible.builtin.systemd:
    name: docker
    state: started
    enabled: true

- name: Stop and remove any manually-run container (idempotent cleanup)
  ansible.builtin.shell: |
    docker stop {{ app_container_name }} 2>/dev/null || true
    docker rm {{ app_container_name }} 2>/dev/null || true
  changed_when: false

- name: Fetch secret from Secrets Manager
  ansible.builtin.shell: >
    aws secretsmanager get-secret-value
    --secret-id "{{ app_container_secret_id }}"
    --region "{{ app_container_secret_region }}"
    --query SecretString --output text
  register: secret_raw
  when: app_container_secret_id != ""
  no_log: true

- name: Extract secret value
  ansible.builtin.set_fact:
    secret_value: >-
      {{ (secret_raw.stdout | from_json)[app_container_secret_json_key]
         if app_container_secret_json_key else secret_raw.stdout }}
  when: app_container_secret_id != ""
  no_log: true

- name: Write systemd environment file (holds the secret, root-only)
  ansible.builtin.copy:
    dest: "/etc/{{ app_container_name }}.env"
    content: "SECRET_VALUE={{ secret_value }}\n"
    owner: root
    group: root
    mode: "0600"
  when: app_container_secret_id != ""
  no_log: true

- name: Deploy systemd unit for the container
  ansible.builtin.template:
    src: app_container.service.j2
    dest: "/etc/systemd/system/{{ app_container_name }}.service"
    mode: "0644"

- name: Reload systemd and start the container service
  ansible.builtin.systemd:
    name: "{{ app_container_name }}"
    state: restarted
    enabled: true
    daemon_reload: true

- name: Wait for the app to respond healthy
  ansible.builtin.uri:
    url: "http://localhost:{{ app_container_port }}{{ app_container_health_path }}"
    status_code: 200
  register: health
  retries: 12
  delay: 5
  until: health.status == 200
