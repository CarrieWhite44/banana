from flask import Flask, render_template, redirect, url_for

app = Flask(__name__)


# SIGN-UP / LOGIN PAGE
@app.route("/")
def signup():
    return render_template("sign-up.html")


# HOME PAGE
@app.route("/home")
def home():
    return render_template("home.html")


# LOGOUT ROUTE
@app.route("/logout")
def logout():
    return redirect(url_for("signup"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)