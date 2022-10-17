#!/bin/sh

ED_BASE_URL="https://github.com/electronics-and-drives"
YNK_BASE_URL="https://github.com/augustunderground"
CKT_HOME="$HOME/.circus"
CONDA_ROOT="$HOME/miniconda3"

if [ ! -d "$CKT_HOME" ]; then
    printf "Create circus home directory\n"
    mkdir -vp "$CKT_HOME"
else
    printf "$CKT_HOME already exists!\n"
    exit 1
fi

if { conda env list | grep 'circus'; } >/dev/null 2>&1; then
    printf "circus environment already exits!\n"
    exit 2
else
    printf "Creating the conda Environment\n"
    conda env create -f ./environment.yml
fi

printf "Activating new environment\n"
source $CONDA_ROOT/bin/activate circus

printf "Installing dependencies\n"
pip install git+$YNK_BASE_URL/pynut.git
pip install git+$YNK_BASE_URL/pyspectre.git
pip install git+$YNK_BASE_URL/serafin.git
pip install git+$YNK_BASE_URL/circus.git

printf "Copy GPDK examples\n"
cp -vr ./circus/ckt "$CKT_HOME/"
cp -vr ./circus/pdk "$CKT_HOME/"

PROMPT='Specify the complete path to gpdk.scs in GPDK 180: '
read -p $PROMPT MODEL_PATH

if [ -z "${MODEL_PATH}" ]; then
    MODEL_PATH=$(head -n 2 ./circus/pdk/gpdk180.yml | tail -1 | cut -d':' -f2)
    printf "No path specified, using default:\n\t$MODEL_PATH"
    cp -vr ./circus/pdk/gpdk180.yml "$CKT_HOME/pdk/gpdk180.yml"
elif [ ! -f "$MODEL_PATH" ]; then
    printf "$MODEL_PATH does not exist.\n"
    exit 3
else
    LINE="  - path: \"$MODEL_PATH\""
    sed "2s/.*/$LINE/" ./circus/gpdk180.yml > "$CKT_HOME/pdk/gpdk180.yml"
fi

source $CONDA_ROOT/bin/deactivate

printf "Installation Successful\n"
exit 0
