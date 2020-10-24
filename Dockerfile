FROM dddlab/python-notebook:v20200331-df7ed42-94fdd01b492f

LABEL maintainer="Patrick Windmiller <sysadmin@pstat.ucsb.edu>"

USER root

RUN apt-get update && \
    apt-get install -y vim

USER $NB_UID

RUN conda update python && \
    pip install vdiff

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
    jupyter lab build && \
    pip install datascience && \
    \
    # remove cache
    rm -rf ~/.cache/pip ~/.cache/matplotlib ~/.cache/yarn

#--- Install nbgitpuller
RUN pip install nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix

RUN conda install -c conda-forge nodejs && \
    conda install -c conda-forge spacy && \
    conda install -c conda-forge ipympl  && \
    conda install --quiet -y nltk && \
    conda install --quiet -y mplcursors && \
    conda install --quiet -y pytest && \
    conda install --quiet -y tweepy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN jupyter labextension install @jupyterlab/debugger && \
    jupyter labextension install jupyter-matplotlib@0.7.3 && \
    jupyter labextension update jupyterlab_bokeh && \
    jupyter lab build

RUN fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN pip install PTable && \
    pip install pytest-custom-report

# Install otter-grader
RUN pip install otter-grader

RUN fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

