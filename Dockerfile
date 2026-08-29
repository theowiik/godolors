# Renders colors.png without a display, using Xvfb + software OpenGL:
#
#   docker build --output out .
#
# Note: Godot's --headless flag is NOT usable here. It selects the dummy
# rendering driver, so get_viewport().get_texture() returns null and the
# screenshot fails. We need a real GL context, hence Xvfb + llvmpipe.

FROM debian:bookworm-slim AS render

ARG GODOT_VERSION=4.2.2-stable

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates wget unzip \
      xvfb xauth \
      libgl1 libglx-mesa0 libgl1-mesa-dri libegl1 \
      libxkbcommon0 libx11-6 libxcursor1 libxinerama1 libxrandr2 libxi6 libxext6 \
      libasound2 libpulse0 libudev1 libdbus-1-3 \
      fontconfig \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q "https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux.x86_64.zip" -O /tmp/godot.zip \
    && unzip -q /tmp/godot.zip -d /usr/local/bin \
    && mv "/usr/local/bin/Godot_v${GODOT_VERSION}_linux.x86_64" /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot \
    && rm /tmp/godot.zip

ENV LIBGL_ALWAYS_SOFTWARE=1
ENV GALLIUM_DRIVER=llvmpipe

WORKDIR /project
COPY . /project/

# The Xvfb screen can be smaller than the 3360x1680 output: Godot renders to an
# FBO, so the grab is not clipped by the virtual screen size.
RUN godot --headless --path /project --import 2>&1 | tail -5 \
    && xvfb-run -a -s '-screen 0 1280x720x24' \
         godot --path /project --rendering-driver opengl3 --audio-driver Dummy \
    ; cp /root/.local/share/godot/app_userdata/godolors/colors.png /colors.png

FROM scratch
COPY --from=render /colors.png /colors.png
