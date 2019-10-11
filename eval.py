# Import libraries
import pandas as pd
import numpy as np
import datetime
import pandas_datareader.data as web

from evaluate import show_eval_result
from keras import backend as K
from agent import Agent
from evaluate import evaluate_model


def eval(stock, abo=False):
    K.clear_session()
    from utils import (
        get_state,
        format_currency,
        format_position)

    switch_k_backend_device() #Train on CPU instead of GPU (CPU is faster with this model)

    # Init parameters
    window_size = 12
    batch_size = 16
    #ep_count = 100  # 3-5 for debugging, otherwise 20-100
    model_name = 'model_w12v4_MTH_90'
    #pretrained = True
    debug = False

    # Load Data
    # start_test = datetime.datetime(2018, 6, 1)

    if abo == True:
        end_test = datetime.datetime.now()
    else:
        end_test = datetime.datetime.now()-datetime.timedelta(days = 10) # in case of no abo: only old state available

    start_test = end_test-datetime.timedelta(weeks = 52)

    # Load Stock
    df_test = web.DataReader([stock], 'yahoo',
                             start=start_test,
                             end=end_test)['Adj Close']
    #Load 2nd feature
    # if only 1 featue used: df2_test = None
    df2_test = web.DataReader('GOLD', 'yahoo',
                              start=start_test, end=end_test)
    df2_test_list = list(df2_test['Adj Close'])


    # Initialize Agent
    if df2_test is not None:
        agent = Agent(window_size * 2, pretrained=True, model_name=model_name)
    else:
        agent = Agent(window_size, pretrained=True, model_name=model_name)

    dft = df_test.rename(columns={df_test.columns[0]: 'actual'})
    df_test_list = list(dft['actual']) #Make list out of data

    initial_offset = df_test_list[1] - df_test_list[0]

    val_result, history = evaluate_model(agent, df_test_list, df2_test_list, window_size, debug)
    show_eval_result(model_name, val_result, initial_offset);
    # print(val_result)

    K.clear_session()
    position = [history[0][0]] + [x[0] for x in history]
    actions = ['HOLD'] + [x[1] for x in history]
    dft['position'] = position
    dft['action'] = actions
    dft['number'] = 0
    dft['account'] = 0
    dft['value'] = 0
    #dft["mavg100"] = dft["actual"].rolling(window=30).mean()

    number = 0
    balance = 0

    for index, row in dft.iterrows():
        if row['action'] =="BUY":
            number = number+1
            balance = balance - row['actual']


        if row['action'] == "SELL":
            number = number-1
            balance = balance + row['actual']

        value = number*row['actual'] + balance # Value of stocks and Balance
        dft.set_value(index, 'number', number)
        dft.set_value(index, 'account', balance)
        dft.set_value(index, 'value', value)
    # print(number)
    # print(balance)

    dft = dft.reset_index()
    return dft

def switch_k_backend_device():
    import logging
    import keras.backend as K
    import os
    """ Switches `keras` backend from GPU to CPU if required.

    Faster computation on CPU (if using tensorflow-gpu).
    """
    if K.backend() == 'tensorflow':
        logging.debug('switching to TensorFlow for CPU')
        os.environ['CUDA_VISIBLE_DEVICES'] = '-1'







