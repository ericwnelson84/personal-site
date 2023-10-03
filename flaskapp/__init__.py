from flask import Flask, render_template
import requests
import json


app =Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route("/news", methods=["GET", "POST"])
def news():

    url = "https://lly1yqp3p6.execute-api.us-east-1.amazonaws.com/Prod/newsreader"
    payload = "{\r\n  \"sentiment\": \"NEUTRAL\"\r\n}"
    headers = {
        'x-api-key': 'RbhcMyrXwO4OYH0NXrjuA5MjefneI9Pv4Mw1CEGZ',
        'Content-Type': 'text/plain'
    }   
    response = requests.request("POST", url, headers=headers, data=payload)

    json_data = json.loads(response.text)
    data = json_data['Items']

    return render_template("news.html", response=data)


if __name__ == '__main__':
    app.run(debug=False)

