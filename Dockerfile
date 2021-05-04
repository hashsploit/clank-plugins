FROM debian:bullseye-slim
LABEL name="clank-plugins"
LABEL description="Clank Plugins - This repository is dedicated for example Lua plugins written for Clank."
LABEL maintainer="hashsploit <hashsploit@protonmail.com>"

# Install dependencies
RUN echo "Updating packages ..." \
	&& apt-get update -y >/dev/null 2>&1 \
	&& echo "Installing dependencies ..." \
	&& apt-get install -y \
	curl \
	lua5.4 >/dev/null 2>&1

# Remove bloat
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& apt-get autoremove --purge -y \
	&& apt-get clean -y \
	&& rm -rf /usr/share/man \
	&& rm -rf /usr/share/locale \
	&& rm -rf /usr/share/doc \
	&& mkdir -p /etc/initramfs-tools/conf.d/ \
	&& echo "COMPRESS=xz" | tee /etc/initramfs-tools/conf.d/compress >/dev/null 2>&1

ENTRYPOINT ["/bin/bash", "/opt/obfuscate.sh"]
