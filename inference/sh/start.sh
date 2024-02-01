#! /bin/sh

MODEL_FOLDER="models"
MODEL_PATH=$MODEL_FOLDER"/mistral-7b.gguf"

./server -m $MODEL_PATH -c 8000 --host 0.0.0.0 --port 8080
