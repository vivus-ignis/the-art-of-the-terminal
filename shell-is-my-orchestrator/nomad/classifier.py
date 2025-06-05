#!/usr/bin/env python3
import os
from transformers import pipeline
import redis

REDIS_HOST = os.environ["REDIS_HOST"]
SEQUENCE = os.environ["NOMAD_META_SEQUENCE"]
LABELS = os.environ["NOMAD_META_LABELS"]

# https://huggingface.co/MoritzLaurer/DeBERTa-v3-base-mnli-fever-anli
classifier = pipeline("zero-shot-classification", model="MoritzLaurer/DeBERTa-v3-base-mnli-fever-anli")
results = classifier(SEQUENCE, LABELS.split(","), multi_label=False)
print(results)

print(f"About to save results to redis host {REDIS_HOST}")
r = redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)
r.set(results["sequence"], results["labels"][0]) 
