FROM naotoe/askbot-devel

# TODO
ENV PYTHONUNBUFFERED 1

WORKDIR /src/

# For postgreSQL
RUN pip install psycopg2


COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080

WORKDIR /site/

CMD ["python", "/site/manage.py", "runserver", "0.0.0.0:8080"]

