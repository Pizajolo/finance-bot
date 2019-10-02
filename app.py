# -*- coding: utf-8 -*-

from scripts import tabledef
from scripts import forms
from scripts import helpers
from flask import Flask, redirect, url_for, render_template, request, session
import json
import pandas as pd
import datetime
import pandas_datareader.data as web
import sys
import os

app = Flask(__name__)
app.secret_key = os.urandom(12)  # Generic key for dev purposes only

# Heroku
#from flask_heroku import Heroku
#heroku = Heroku(app)

# ======== Routing =========================================================== #
# -------- Landing page ------------------------------------------------------------- #
@app.route('/')
@app.route('/landing')
def index():
    return render_template('index.html')


# -------- Login ------------------------------------------------------------- #
@app.route('/login', methods=['GET', 'POST'])
def login():
    # return render_template('login.html')
    if not session.get('logged_in'):
        form = forms.LoginForm(request.form)
        if request.method == 'POST':
            username = request.form['username'].lower()
            password = request.form['password']
            if form.validate():
                if helpers.credentials_valid(username, password):
                    session['logged_in'] = True
                    session['username'] = username
                    return json.dumps({'status': 'Login successful'})
                return json.dumps({'status': 'Invalid user/pass'})
            return json.dumps({'status': 'Both fields required'})
        return render_template('login.html', form=form)
    user = helpers.get_user()
    # return render_template('home.html', user=user)
    return redirect(url_for('home'))


@app.route('/home', methods=['GET', 'POST'])
def home():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    user = helpers.get_user()
    return render_template('home.html', user=user)

@app.route("/logout")
def logout():
    session['logged_in'] = False
    return redirect(url_for('index'))


# -------- Register ---------------------------------------------------------- #
@app.route('/register', methods=['GET', 'POST'])
def register():
    if not session.get('logged_in'):
        return render_template('register.html')
    return redirect(url_for('home'))


# -------- Signup ---------------------------------------------------------- #
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if not session.get('logged_in'):
        form = forms.LoginForm(request.form)
        if request.method == 'POST':
            username = request.form['username'].lower()
            password = helpers.hash_password(request.form['password'])
            email = request.form['email']
            if form.validate():
                if not helpers.username_taken(username):
                    helpers.add_user(username, password, email)
                    session['logged_in'] = True
                    session['username'] = username
                    return json.dumps({'status': 'Signup successful'})
                return json.dumps({'status': 'Username taken'})
            return json.dumps({'status': 'User/Pass required'})
        return render_template('login.html', form=form)
    return redirect(url_for('home'))


# -------- Profile ---------------------------------------------------------- #
@app.route('/profile', methods=['GET', 'POST'])
def settings():
    if session.get('logged_in'):
        if request.method == 'POST':
            password = request.form['password']
            if password != "":
                password = helpers.hash_password(password)
            email = request.form['email']
            helpers.change_user(password=password, email=email)
            return json.dumps({'status': 'Saved'})
        user = helpers.get_user()
        return render_template('profile.html', user=user)
    return redirect(url_for('login'))


# -------- Forgot Password ---------------------------------------------------------- #
# Todo:
#     Add send email with temporery password to entered email

@app.route('/forgot-password', methods=['GET', 'POST'])
def forgot_pw():
    if not session.get('logged_in'):
        return render_template('forgot-password.html')
    return redirect(url_for('home'))


# -------- Load CSV Landing Page ---------------------------------------------------------- #
@app.route('/graph')
def graph():
    csv_file_path = 'media/AAPL.csv'
    df = pd.read_csv(csv_file_path)
    data_json = df.to_json(orient='records')

    return data_json


# -------- Search Share ---------------------------------------------------------- #
@app.route('/search',methods=["POST"])
def search():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    stock = request.form.get("search_query")
    print(stock)
    # try:
    df = web.DataReader(stock, 'yahoo',
                          start=datetime.datetime(2018, 1, 2),  # start
                          end=datetime.datetime(2019, 9, 10))  # end
    prices = df['Open'].values.tolist()
    date = []
    for i in df.index.values:
        date.append(str(i)[:10])
    data = {"Date": date, "Prices":prices}
    return json.dumps({'Date': date,'Prices':prices})
    # except:
    #     return json.dumps({'status': 'Stock does not exist'})


@app.route('/analyse', methods=['GET'])
def analyse():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    stock = request.args.get('stock')
    try:
        df = web.DataReader(stock, 'yahoo',
                            start=datetime.datetime(2019, 9, 2),  # start
                            end=datetime.datetime(2019, 9, 10))  # end
        user = helpers.get_user()
        return render_template('analyse.html', user=user, name=stock)
    except:
        return redirect(url_for('home'))

# ======== Main ============================================================== #
if __name__ == "__main__":
    app.run(debug=True, use_reloader=True)
