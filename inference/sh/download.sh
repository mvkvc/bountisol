#! /bin/sh

MODEL_URL="https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q4_K_M.gguf?download=true"
MODEL_FOLDER="models"
MODEL_PATH=$MODEL_FOLDER"/mistral-7b.gguf"

if [ ! -d $MODEL_FOLDER ]; then
    echo "Creating model folder..."
    mkdir $MODEL_FOLDER
else
    echo "Model folder already exists"
fi

if [ ! -f $MODEL_PATH ]; then
    echo "Downloading model..."
    wget -O $MODEL_PATH $MODEL_URL
else
    echo "Model already exists"
fi
