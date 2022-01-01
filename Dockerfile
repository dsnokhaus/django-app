FROM python:3.10-alpine
LABEL maintainer="Snekovi.cz"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

RUN mkdir /app
WORKDIR /app
COPY ./app /app
EXPOSE 8000

RUN python -m  venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev

RUN /py/bin/pip install -r /requirements.txt

RUN apk del .tmp-deps

RUN adduser --disabled-password --no-create-home app

RUN mkdir -p /vol/web/static
RUN mkdir -p /vol/web/media
RUN chown -R app:app /vol
RUN chmod -R 755 /vol

ENV PATH="/py/bin:$PATH"

USER app
