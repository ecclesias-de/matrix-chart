FROM matrixdotorg/synapse

COPY chart/files/entrypoint.py /entrypoint.py

# Use curl instead of pip because using pip would require git
RUN curl \
    https://raw.githubusercontent.com/devture/matrix-synapse-shared-secret-auth/2.0.3/shared_secret_authenticator.py \
    -o $(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')/shared_secret_authenticator.py