from flask import Flask, render_template
import requests
import json
import boto3
from botocore.exceptions import ClientError

secret_name = "news-api-key"
region_name = "us-east-1"
# Create a Secrets Manager client
session = boto3.session.Session()
client = session.client(
    service_name='secretsmanager',
    region_name=region_name
)

try:
    get_secret_value_response = client.get_secret_value(
        SecretId=secret_name
    )
except ClientError as e:
    # For a list of exceptions thrown, see
    # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    raise e

# Decrypts secret using the associated KMS key.
secret = json.loads(get_secret_value_response['SecretString'])
key = secret['x-api-key']

# response = requests.get('http://169.254.169.254/latest/meta-data/instance-id')
# instance_id = response.text

app =Flask(__name__)

@app.route('/')
def home():
    # return render_template('index.html', instance_id=instance_id)
    return render_template('index.html')

@app.route("/news", methods=["GET", "POST"])
def news():

    url = "https://lly1yqp3p6.execute-api.us-east-1.amazonaws.com/Prod/newsreader"
    payload = "{\r\n  \"sentiment\": \"NEUTRAL\"\r\n}"
    headers = {
        'x-api-key': key,
        'Content-Type': 'text/plain'
    }   
    response = requests.request("POST", url, headers=headers, data=payload)

    json_data = json.loads(response.text)
    data = json_data['Items']

    return render_template("news.html", response=data)


if __name__ == '__main__':
    app.run(debug=False)


