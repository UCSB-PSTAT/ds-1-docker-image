FROM jupyter/scipy-notebook:137a295ff71b

USER $NB_UID

RUN pip install datascience && \
    pip install nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix
