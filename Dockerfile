FROM python:3.9

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY etl.py extract.py transform.py load.py variables_to_export.sh /app/

ENTRYPOINT ["python", "etl.py"]
