FROM debian:stable-slim
HEALTHCHECK --start-period=30s CMD curl --fail https://localhost:8021 || exit 1
RUN apt update && apt install -y curl snapd && snap install core && snap refresh core && snap install --classic certbot && curl https://rclone.org/install.sh -o install.sh && chmod +x install.sh && ./install.sh
RUN mkdir -p /root/.config/rclone/
COPY rclone.conf /root/.config/rclone/rclone.conf
EXPOSE 8021
RUN certbot certonly --webroot
CMD rclone serve webdav --read-only --cert fullchain.pem --key privatekey.pem --htpasswd htpasswd $CRYPTBOAT: --addr 0.0.0.0:8021
