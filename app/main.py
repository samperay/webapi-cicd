from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def health_check():
    # added comment
    return {"status": "OK"}
