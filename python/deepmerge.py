#!/usr/bin/python

from copy import deepcopy

def deepmerge(left, right):
    if left is None:
        if right is None:
            return None
        return deepcopy(right)
    elif right is None:
        return deepcopy(left)

    if type(left) != type(right):
        raise Exception("Type mismatch")

    if isinstance(left, dict):
        result = {}
        for lkey, lvalue in left.items():
            result[lkey] = deepmerge(lvalue, right.get(lkey))
        for rkey, rvalue in right.items():
            result[rkey] = deepmerge(left.get(rkey), rvalue)
        return result

    if isinstance(left, list):
        result = deepcopy(left)
        result.extend(deepcopy(right))
        return result

    return right

