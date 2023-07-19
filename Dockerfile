FROM python:3.10-alpine3.18

LABEL maintainer="Ali Khalil"

# this variable tells python not to buffer any output, but directly send to console, to vaoid delays
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Set the working directory inside the container
WORKDIR /app

# Expose port 8000 (the port on which Django runs inside the container)
EXPOSE 8000

ARG DEV=false
# dev requirements are only to be used at build stage so tehy are made conditional
RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /tmp/requirements.txt && \
    if [$DEV="true"]; \
      then /venv/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp
#    adduser \
#        --disabled-password \
#        --no-create-home \
#        django-user

ENV PATH="/venv/bin:$PATH"

#USER django-user