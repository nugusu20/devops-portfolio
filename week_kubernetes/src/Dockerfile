# 1. משתמשים בתמונה מוכנה של פייתון (בסיס)
FROM python:3.10-slim

# 2. יוצרים תיקייה בתוך הקונטיינר
WORKDIR /app

# 3. מעתיקים את הקובץ hello.py לתוך הקונטיינר
COPY hello.py .

# 4. מתקינים את Flask
RUN pip install flask

# 5. מגדירים מה יקרה כשהקונטיינר ירוץ
CMD ["python", "hello.py"]

