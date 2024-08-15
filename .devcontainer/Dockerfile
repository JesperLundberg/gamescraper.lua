FROM gcc:latest

LABEL version="0.0.1"
LABEL description="Lua docker container to easily run & develop Lua"

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

ARG LUA_INSTALL_VERSION="5.1"
ARG LUAROCKS_INSTALL_VERSION="3.11.1"
ARG USERNAME=lua-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY scripts/common-debian.sh /tmp/library-scripts/
RUN apt update && apt install cmake -y 
# && apt install luajit -y
RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" 

ENV LUA_VERSION_STR="lua-$LUA_INSTALL_VERSION"
ENV LUAROCKS_VERSION_STR="luarocks-$LUAROCKS_INSTALL_VERSION"

# ---------- Build & install Lua from source ----------
# Install dependencies for build with apt install 
RUN wget http://www.lua.org/ftp/$LUA_VERSION_STR.tar.gz
RUN tar zxf $LUA_VERSION_STR.tar.gz

WORKDIR $LUA_VERSION_STR
RUN make linux test
RUN make install

# ---------- Build & install Luarocks ----------
WORKDIR /
RUN wget https://luarocks.github.io/luarocks/releases/$LUAROCKS_VERSION_STR.tar.gz --no-check-certificate
RUN tar zxpf $LUAROCKS_VERSION_STR.tar.gz
WORKDIR $LUAROCKS_VERSION_STR
RUN ./configure --with-lua-include=/usr/local/include
RUN make
RUN make install

# install luarocks bin to path (e.g. we can run busted in CLI with "busted spec")
ENV PATH "$PATH:/workspaces/lua-docker/./lua_modules/bin:/home/lua-user/.luarocks/bin"

# remove all build dependencies and temporary files
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# add lua-user to lua-users group
RUN adduser -u $USER_UID -G lua-users -h /home/$USERNAME -D $USERNAME

# [Optional] Set the default user. Omit if you want to keep the default as root.
# e.g. if you notice that you have to run sudo .. in your terminal just comment the next line. (Note: Sudo not available in Alpine by default)
USER $USERNAME
