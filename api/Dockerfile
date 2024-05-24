FROM python:3.9-slim

WORKDIR /api

COPY api/requirements.txt /api/

RUN ls -la /api/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY api/ /api/

EXPOSE 8000

CMD ["bash", "run_app.sh"]
