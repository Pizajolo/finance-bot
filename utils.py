import math

import pandas as pd
import numpy as np

# Formats Position
format_position = lambda price: ('-$' if price < 0 else '+$') + '{0:.2f}'.format(abs(price))

# Formats Currency
format_currency = lambda price: '${0:.2f}'.format(abs(price))


def sigmoid(x):
    """ Computes sigmoid activation.

    Args:
            x (float): input value to sigmoid function.
    Returns:
            float: sigmoid function output.
    """
    try:
        if x < 0:
            return 1 - 1 / (1 + math.exp(x))
        return 1 / (1 + math.exp(-x))
    except OverflowError as err:
        print("Overflow err: {0} - Val of x: {1}".format(err, x))
    except ZeroDivisionError:
        print("division by zero!")
    except Exception as err:
        print("Error in sigmoid: " + err)




def get_state(data, data2, t, n_days):
    """ Returns an n-day state representation ending at time t. """
    d = t - n_days + 1
    res1 = []
    block = data[d: t + 1] if d >= 0 else -d * [data[0]] + data[0: t + 1]  # pad with t0


    if data2 is not None:     # init 2nd block if input is not none
        block2 = data2[d: t + 1] if d >= 0 else -d * [data2[0]] + data2[0: t + 1]  # pad with t0
        res2 = []
        for i in range(n_days - 1):
            res1.append(sigmoid(block[i + 1] - block[i]))
            res2.append(sigmoid(block2[i + 1] - block2[i]))
        res = res1 + res2

    else:   # Process single input
        for i in range(n_days - 1):
            res1.append(sigmoid(block[i + 1] - block[i]))
        res = res1

    return np.array([res])



