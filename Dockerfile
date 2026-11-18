FROM python:3.11-slim

# 1. Definimos a pasta raiz do contentor
WORKDIR /app

RUN useradd -ms /bin/bash appuser && chown -R appuser:appuser /app
RUN apt-get update && apt-get install -y build-essential libffi-dev && rm -rf /var/lib/apt/lists/*

USER appuser
ENV PATH="/home/appuser/.local/bin:$PATH"

# 2. Instalamos as dependências
RUN pip install --no-cache-dir --upgrade pip
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copiamos a pasta src do projeto para /app/src no contentor
COPY --chown=appuser:appuser src ./src

# 4. Ensinamos o Python a reconhecer a pasta onde estão os "modules"
ENV PYTHONPATH=/app/src

# 5. Mudamos o foco para dentro da pasta src apenas no momento de arrancar
WORKDIR /app/src

EXPOSE 80

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]