#FROM ucsb/base-scipy:v20200921.1
FROM dddlab/python-notebook:v20200331-df7ed42-94fdd01b492f

LABEL maintainer="Patrick Windmiller <sysadmin@pstat.ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y vim

USER $NB_UID

RUN pip install vdiff

RUN \
    # Notebook extensions (TOC extension)
    pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --sys-prefix && \
    jupyter nbextension enable toc2/main --sys-prefix && \
    jupyter nbextension enable toggle_all_line_numbers/main --sys-prefix && \
    jupyter nbextension enable table_beautifier/main --sys-prefix && \
    \
    # Notebook extensions configurator (server on and interface off)
    jupyter nbextension install jupyter_nbextensions_configurator --py --sys-prefix && \
    jupyter nbextensions_configurator disable --sys-prefix && \
    jupyter serverextension enable jupyter_nbextensions_configurator --sys-prefix && \
    \
    # update JupyterLab (required for @jupyterlab/toc)
    conda update -c conda-forge jupyterlab && \
    \
    # jupyter lab extensions
    jupyter labextension install @jupyterlab/google-drive && \
    jupyter labextension install @jupyterlab/toc --clean && \
    pip install datascience && \
    \
    # remove cache
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn
