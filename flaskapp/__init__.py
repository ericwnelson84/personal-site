from flask import Flask, render_template

# this is a free template from HTML5 up. there are 3 different HTML files to choose from

# using the chrome browser editor you can edit elements on the webpage directly on the webpage. This will make
# anything on the webpage editable. To do this, open the site in chrome the chrome console and type the
# following Javascript command   document.body.contentEditable=true
# Then you can save the current HTML file from the webpage that will include your edits. then just put that in pycharm

# use unsplash.com for cool background images

app =Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=False)