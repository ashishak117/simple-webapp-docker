import os
from flask import Flask
app = Flask(__name__)

@app.route("/")
def main():
    return "Welcome!"

@app.route('/how are you')
def hello():
    return 'I am good, how about you?'

@app.route('/ash')
def ashish():
    return 'so i tried docker and its too good yessss!!!!!!!!!!!!!!!11'

@app.route('/ashish')
def ashish():
    return 'another api added'

if __name__ == "__main__":
    app.run()
