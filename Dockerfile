FROM ucsb/base-scipy:v191012

LABEL maintainer="Sang-Yun Oh <syoh@ucsb.edu>"

USER root

RUN \
    git clone https://github.com/TheLocehiliosan/yadm.git \
        /usr/local/share/yadm && \
    ln -s /usr/local/share/yadm/yadm /usr/local/bin/yadm && \
    \
    apt-get update && \
    apt-get install -y vim.tiny curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s $(which vim.tiny) /usr/local/bin/vim

USER $NB_UID

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
    # vim binding
    git clone https://github.com/lambdalisue/jupyter-vim-binding \
        /opt/conda/share/jupyter/nbextensions/vim_binding && \
    jupyter nbextension disable vim_binding/vim_binding --sys-prefix && \
    \
    # jupyter lab extensions
    jupyter labextension install jupyterlab_vim --clean && \
    jupyter labextension disable jupyterlab_vim && \
    jupyter labextension install @jupyterlab/toc --clean && \
    pip install datascience && \
    \
    # remove cache
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn
