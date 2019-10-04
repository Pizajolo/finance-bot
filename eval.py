def eval(stock):

    # Import libraries
    import pandas as pd
    import numpy as np
    import datetime
    import pandas_datareader.data as web

    from evaluate import show_eval_result
    from agent import Agent
    from evaluate import evaluate_model
    from utils import (
        get_state,
        format_currency,
        format_position)

    switch_k_backend_device() #Train on CPU instead of GPU (CPU is faster with this model)

    # Init parameters
    window_size = 10
    batch_size = 16
    #ep_count = 100  # 3-5 for debugging, otherwise 20-100
    model_name = 'model_w10_10'
    #pretrained = True
    debug = False

    # Load Data
    start_test = datetime.datetime(2019, 1, 1)
    end_test = datetime.datetime.now()

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

    position = [history[0][0]] + [x[0] for x in history]
    actions = ['HOLD'] + [x[1] for x in history]
    dft['position'] = position
    dft['action'] = actions
    dft['number'] = 0
    dft['account'] = 0

    # to be debugged!
    for index, row in dft.iterrows():
        if row['action'] =="BUY":
            row['number'] = row['number']+1
        if row['action'] == "SELL":
            row['number'] = row['number'] - 1

    return(dft)


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



tf1 = eval("aapl")
print(tf1)
tf1.to_csv("testfile.csv")





