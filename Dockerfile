FROM python:3.11

WORKDIR /app

COPY ./src /app

RUN pip install --no-cache-dir -r requirements.txt

COPY ./src/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["/bin/bash", "-c", "python __main__.py \"{\\\"url\\\": \\\"$URL\\\", \\\"slack_webhook_url\\\": \\\"$SLACK_WEBHOOK_URL\\\", \\\"timeout\\\": $TIMEOUT}\""]