# -*- coding: utf-8 -*-

from scripts import tabledef
from scripts import forms
from scripts import helpers
from flask import Flask, redirect, url_for, render_template, request, session
# import json
import simplejson as json
import pandas as pd
import datetime
import pandas_datareader.data as web
import sys
import numpy as np
import os
from eval import eval
import stripe


api_test_key = 'pk_test_ZGjcdWhwzPlqCxlrY0AmuQQu00lX6ZWN27'
api_test_secret_key = 'sk_test_16AIFAVEEKxLYPGkEG8XlCMZ00N981yRv0'

stripe.api_key = api_test_secret_key

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
    # csv_file_path = 'media/AAPL.csv'
    csv_file_path = './media/testfile.csv'
    df = pd.read_csv(csv_file_path)
    prices = df['actual'].values.tolist()
    date = df['Date'].values.tolist()

    df.loc[df['action'] == 'HOLD', 'actual'] = None
    df_buy = df.copy()
    df_sell = df.copy()
    df_buy.loc[df_buy['action'] == 'SELL', 'actual'] = None
    prices_buy = df_buy['actual'].values.tolist()
    df_sell.loc[df_sell['action'] == 'BUY', 'actual'] = None
    prices_sell = df_sell['actual'].values.tolist()
    return json.dumps({'Date': date,'Prices':prices, 'Buy_Prices':prices_buy, 'Sell_Prices':prices_sell},ignore_nan=True)


# -------- Search Share ---------------------------------------------------------- #
@app.route('/search',methods=["POST"])
def search():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    stock = request.form.get("search_query")
    user = helpers.get_user()
    sub = user.subscription
    sub_data = user.sub_date
    if sub:
        if datetime.datetime.now() > sub_data:
            helpers.change_user(subscription=False)
            sub = False
    df = eval(stock, sub)
    prices = df['actual'].values.tolist()
    date = []
    for i in range(len(df)):
        date.append(str(df.at[i, 'Date'])[0:10])
    # date = df['Date'].apply(str).values.tolist()
    df.loc[df['action'] == 'HOLD', 'actual'] = None
    df_buy = df.copy()
    df_sell = df.copy()
    df_buy.loc[df_buy['action'] == 'SELL', 'actual'] = None
    prices_buy = df_buy['actual'].values.tolist()
    df_sell.loc[df_sell['action'] == 'BUY', 'actual'] = None
    prices_sell = df_sell['actual'].values.tolist()
    return json.dumps({'Date': date, 'Prices': prices, 'Buy_Prices': prices_buy, 'Sell_Prices': prices_sell,
                       'Subscription': sub, 'Return-fAI': "---", 'Return-holding': "---"},
                      ignore_nan=True)
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
        return render_template('analyse.html', user=user, name=stock, key=api_test_key)
    except:
        return redirect(url_for('home'))


@app.route('/subscribe', methods=['Post'])
def subscribe():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    try:
        # amount in cents
        amount = 99

        customer = stripe.Customer.create(
            email='sample@customer.com',
            source=request.form['stripeToken']
        )

        stripe.Charge.create(
            customer=customer.id,
            amount=amount,
            currency='usd',
            description='Flask Charge'
        )
        user = helpers.get_user()
        sub = user.subscription
        if not sub:
            helpers.change_user(subscription=True)
            date = datetime.datetime.now()+datetime.timedelta(days=31)
            helpers.change_user(sub_date=date)
        else:
            if datetime.datetime.now() > user.sub_date:
                date = datetime.datetime.now()+datetime.timedelta(days=31)
            else:
                date = user.sub_date+datetime.timedelta(days=31)
            helpers.change_user(sub_date=date)
    except:
        print('subscrption didnt work')
    user = helpers.get_user()
    return render_template('profile.html', user=user)
    # user = helpers.get_user()
    # sub = user.subscription
    # if not sub:
    #     helpers.change_user(subscription=True)
    # else:
    #     helpers.change_user(subscription=False)
    # return redirect(url_for('home'))


# -------- Login API ------------------------------------------------------------- #
@app.route('/api/login', methods=['POST'])
def login_api():
    if not session.get('logged_in'):
        if request.method == 'POST':
            username = request.form.get("username")
            password = request.form.get("password")
            if helpers.credentials_valid(username, password):
                session['logged_in'] = True
                session['username'] = username
                return json.dumps({'status': 'Login successful', 'code': 201})
            return json.dumps({'status': 'Invalid user/pass', 'code': 401})
        return json.dumps({'status': 'Accept only Post', 'code': 402})
    return json.dumps({'status': 'user logged in', 'code': 202})


# -------- Logout API ------------------------------------------------------------- #
@app.route("/api/logout")
def logout_api():
    session['logged_in'] = False
    return json.dumps({'status': 'logged out', 'code': 210})


# -------- Profile API ---------------------------------------------------------- #
@app.route('/api/profile', methods=['GET', 'POST'])
def settings_api():
    if session.get('logged_in'):
        user = helpers.get_user()
        username = user.username
        email = user.email
        has_subscription = user.subscription
        sub_date = user.sub_date
        return json.dumps({'status': 'User data', 'Username': username, 'Email': email, 'Subscription': has_subscription, 'Date': str(sub_date)[0:10], 'code': 220})
    return json.dumps({'status': 'Not logged in', 'code': 403})


# -------- Search Share API ---------------------------------------------------------- #
@app.route('/api/search',methods=["POST"])
def search_api():
    if not session.get('logged_in'):
        return json.dumps({'status': 'Not logged in', 'code': 403})
    else:
        print("request search")
        stock = request.form.get("search_query")
        try:
            print("check Stock", stock)
            df = web.DataReader(stock, 'yahoo',
                                start=datetime.datetime(2019, 9, 2),  # start
                                end=datetime.datetime(2019, 9, 10))  # end
            print("checked Stock")
            user = helpers.get_user()
            sub = user.subscription
            sub_data = user.sub_date
            if sub:
                if datetime.datetime.now() > sub_data:
                    helpers.change_user(subscription=False)
                    sub = False
            print("evaluation start")
            df = eval(stock, sub)
            print("evaluation end")
            prices = df['actual'].values.tolist()
            date = []
            for i in range(len(df)):
                date.append(str(df.at[i, 'Date'])[0:10])
            # date = df['Date'].apply(str).values.tolist()
            df.loc[df['action'] == 'HOLD', 'actual'] = None
            df_buy = df.copy()
            df_sell = df.copy()
            df_buy.loc[df_buy['action'] == 'SELL', 'actual'] = None
            prices_buy = df_buy['actual'].values.tolist()
            df_sell.loc[df_sell['action'] == 'BUY', 'actual'] = None
            prices_sell = df_sell['actual'].values.tolist()
            return json.dumps({'Stock': stock,'Date': date, 'Prices': prices, 'Buy_Prices': prices_buy, 'Sell_Prices': prices_sell,
                               'Subscription': sub, 'Return-fAI': "---", 'Return-holding': "---", 'code': 301},
                              ignore_nan=True)
        except:
            return json.dumps({'status': 'Stock not found', 'code': 302})


# ======== Main ============================================================== #
if __name__ == "__main__":
    app.run(debug=True, use_reloader=True)
