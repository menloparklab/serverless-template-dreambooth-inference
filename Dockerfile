# Must use a Cuda version 11+
# FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime
FROM pytorch/pytorch:1.13.0-cuda11.6-cudnn8-runtime

WORKDIR /

# Install git
RUN apt-get update && apt-get install -y git

# Install python packages
RUN pip3 install --upgrade pip
ADD requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.6 -c pytorch -c conda-forge
RUN pip install -U --pre triton
RUN conda install xformers -c xformers/label/dev

# We add the banana boilerplate here
ADD server.py .
EXPOSE 8000

# Add your huggingface auth key here
ENV HF_AUTH_TOKEN="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"

# Add your model weight files 
# (in this case we have a python script)
ADD download.py .
RUN python3 download.py

# Add your custom app code, init() and inference()
ADD app.py .

CMD python3 -u server.py
