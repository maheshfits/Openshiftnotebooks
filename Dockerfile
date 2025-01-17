FROM jupyter/minimal-notebook

USER root

RUN chgrp -R root /home/$NB_USER \
    && find /home/$NB_USER -type d -exec chmod g+rwx,o+rx {} \; \
    && find /home/$NB_USER -type f -exec chmod g+rw {} \; \
    && chgrp -R root /opt/conda \
    && find /opt/conda -type d -exec chmod g+rwx,o+rx {} \; \
    && find /opt/conda -type f -exec chmod g+rw {} \;

RUN useradd -m -s /bin/bash -N -u $NB_UID -g 0 $NB_USER && \
    mkdir -p /opt/conda && \
    chown jovyan /opt/conda

RUN ln -s /usr/bin/env /bin/env

ENV HOME /home/$NB_USER

USER 1001

LABEL io.k8s.description="S2I builder for Jupyter (minimal-notebook)." \
      io.k8s.display-name="Jupyter (minimal-notebook)" \
      io.openshift.expose-services="8888:http" \
      io.openshift.tags="builder,python,jupyter" \
      io.openshift.s2i.scripts-url="https://raw.githubusercontent.com/GrahamDumpleton/openshift3-jupyter-stacks/master/s2i-bootstrap"
