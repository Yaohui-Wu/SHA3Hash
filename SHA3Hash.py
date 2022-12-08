#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#*************************************************************
# 作者：伍耀晖               Author: Geek.Zhiyuan            *
# 开源日期：2022年7月25日    Open Source Date: 2022-7-25     *
# 国家城市：中国广州         City, Country: GuangZhou, China *
#*************************************************************

import os, sys

class SHA3Context:
    def __init__(self):
        self.lDataBlock = [[0] * 6 for i in range(64)]

        self.lMessageDigest = [[0] * 24 for j in range(5)]

def Usage():
    print("Usage: python SHA3Hash.py YouWantToHash.File")

def Trinary6(lTrinary, iNumeric):
    lTrinary[0] = lTrinary[1] = lTrinary[2] = lTrinary[3] = lTrinary[4] = lTrinary[5] = 0

    if iNumeric != 0:
        for i in range(5, -1, -1):
            iNumeric, lTrinary[i] = divmod(iNumeric, 3)

def Trinary24(lTrinary, iNumeric):
    lTrinary[0] = lTrinary[1] = lTrinary[2] = lTrinary[3] = lTrinary[4] = lTrinary[5] = lTrinary[6] = lTrinary[7] = 0

    lTrinary[8] = lTrinary[9] = lTrinary[10] = lTrinary[11] = lTrinary[12] = lTrinary[13] = lTrinary[14] = lTrinary[15] = 0

    lTrinary[16] = lTrinary[17] = lTrinary[18] = lTrinary[19] = lTrinary[20] = lTrinary[21] = lTrinary[22] = lTrinary[23] = 0

    if iNumeric != 0:
        for j in range(23, -1, -1):
            iNumeric, lTrinary[j] = divmod(iNumeric, 3)

# 0 0 0
# 0 1 1
# 0 1 2

def TrinaryAnd(W, X, Y):
    for i in range(24):
        if X[i] == Y[i] == 0: W[i] = 0

        elif X[i] == 0 and Y[i] == 1: W[i] = 0

        elif X[i] == 0 and Y[i] == 2: W[i] = 0

        elif X[i] == 1 and Y[i] == 0: W[i] = 0

        elif X[i] == Y[i] == 1: W[i] = 1

        elif X[i] == 1 and Y[i] == 2: W[i] = 1

        elif X[i] == 2 and Y[i] == 0: W[i] = 0

        elif X[i] == 2 and Y[i] == 1: W[i] = 1

        elif X[i] == Y[i] == 2: W[i] = 2

# 0 1 2
# 1 1 2
# 2 2 2

def TrinaryOr(W, X, Y):
    for j in range(24):
        if X[j] == Y[j] == 0: W[j] = 0

        elif X[j] == 0 and Y[j] == 1: W[j] = 1

        elif X[j] == 0 and Y[j] == 2: W[j] = 2

        elif X[j] == 1 and Y[j] == 0: W[j] = 1

        elif X[j] == Y[j] == 1: W[j] = 1

        elif X[j] == 1 and Y[j] == 2: W[j] = 2

        elif X[j] == 2 and Y[j] == 0: W[j] = 2

        elif X[j] == 2 and Y[j] == 1: W[j] = 2

        elif X[j] == Y[j] == 2: W[j] = 2

# 0 0 2
# 1 1 1
# 2 2 0

def TrinaryXOr0(W, X, Y):
    for k in range(24):
       if X[k] == Y[k] == 0: W[k] = 0

       elif X[k] == 0 and Y[k] == 1: W[k] = 0

       elif X[k] == 0 and Y[k] == 2: W[k] = 2

       elif X[k] == 1 and Y[k] == 0: W[k] = 1

       elif X[k] == Y[k] == 1: W[k] = 1

       elif X[k] == 1 and Y[k] == 2: W[k] = 1

       elif X[k] == 2 and Y[k] == 0: W[k] = 2

       elif X[k] == 2 and Y[k] == 1: W[k] = 2

       elif X[k] == Y[k] == 2: W[k] = 0

# 0 2 2
# 1 1 1
# 2 0 0

def TrinaryXOr2(W, X, Y):
    for l in range(24):
        if X[l] == Y[l] == 0: W[l] = 0

        elif X[l] == 0 and Y[l] == 1: W[l] = 2

        elif X[l] == 0 and Y[l] == 2: W[l] = 2

        elif X[l] == 1 and Y[l] == 0: W[l] = 1

        elif X[l] == Y[l] == 1: W[l] = 1

        elif X[l] == 1 and Y[l] == 2: W[l] = 1

        elif X[l] == 2 and Y[l] == 0: W[l] = 2

        elif X[l] == 2 and Y[l] == 1: W[l] = 0

        elif X[l] == Y[l] == 2: W[l] = 0

# 2 0 0
# 1 1 1
# 0 2 2

def TrinaryXAnd0(W, X, Y):
    for i in range(24):
       if X[i] == Y[i] == 0: W[i] = 2

       elif X[i] == 0 and Y[i] == 1: W[i] = 0

       elif X[i] == 0 and Y[i] == 2: W[i] = 0

       elif X[i] == 1 and Y[i] == 0: W[i] = 1

       elif X[i] == Y[i] == 1: W[i] = 1

       elif X[i] == 1 and Y[i] == 2: W[i] = 1

       elif X[i] == 2 and Y[i] == 0: W[i] = 0

       elif X[i] == 2 and Y[i] == 1: W[i] = 2

       elif X[i] == Y[i] == 2: W[i] = 2

# 2 2 0
# 1 1 1
# 0 0 2

def TrinaryXAnd2(W, X, Y):
    for j in range(24):
        if X[j] == Y[j] == 0: W[j] = 2

        elif X[j] == 0 and Y[j] == 1: W[j] = 2

        elif X[j] == 0 and Y[j] == 2: W[j] = 0

        elif X[j] == 1 and Y[j] == 0: W[j] = 1

        elif X[j] == Y[j] == 1: W[j] = 1

        elif X[j] == 1 and Y[j] == 2: W[j] = 1

        elif X[j] == 2 and Y[j] == 0: W[j] = 0

        elif X[j] == 2 and Y[j] == 1: W[j] = 0

        elif X[j] == Y[j] == 2: W[j] = 2

# 0 1 2
# 1 2 0
# 2 0 1

def TrinaryAdd(W, X, Y):
    for k in range(24):
        if X[k] == Y[k] == 0: W[k] = 0

        elif X[k] == 0 and Y[k] == 1: W[k] = 1

        elif X[k] == 0 and Y[k] == 2: W[k] = 2

        elif X[k] == 1 and Y[k] == 0: W[k] = 1

        elif X[k] == Y[k] == 1: W[k] = 2

        elif X[k] == 1 and Y[k] == 2: W[k] = 0

        elif X[k] == 2 and Y[k] == 0: W[k] = 2

        elif X[k] == 2 and Y[k] == 1: W[k] = 0

        elif X[k] == Y[k] == 2: W[k] = 1

# 0 2 1
# 1 0 2
# 2 1 0

def TrinarySubtract(W, X, Y):
    for l in range(24):
        if X[l] == Y[l] == 0: W[l] = 0

        elif X[l] == 0 and Y[l] == 1: W[l] = 2

        elif X[l] == 0 and Y[l] == 2: W[l] = 1

        elif X[l] == 1 and Y[l] == 0: W[l] = 1

        elif X[l] == Y[l] == 1: W[l] = 0

        elif X[l] == 1 and Y[l] == 2: W[l] = 2

        elif X[l] == 2 and Y[l] == 0: W[l] = 2

        elif X[l] == 2 and Y[l] == 1: W[l] = 1

        elif X[l] == Y[l] == 2: W[l] = 0

# 0 0 0
# 0 1 2
# 0 2 1

def TrinaryMultiply(W, X, Y):
    for i in range(24):
        if X[i] == Y[i] == 0: W[i] = 0

        elif X[i] == 0 and Y[i] == 1: W[i] = 0

        elif X[i] == 0 and Y[i] == 2: W[i] = 0

        elif X[i] == 1 and Y[i] == 0: W[i] = 0

        elif X[i] == Y[i] == 1: W[i] = 1

        elif X[i] == 1 and Y[i] == 2: W[i] = 2

        elif X[i] == 2 and Y[i] == 0: W[i] = 0

        elif X[i] == 2 and Y[i] == 1: W[i] = 2

        elif X[i] == Y[i] == 2: W[i] = 1

# 0 0 0
# 0 1 0
# 0 2 1

def TrinaryDivide(W, X, Y):
    for j in range(24):
        if X[j] == Y[j] == 0: W[j] = 0

        elif X[j] == 0 and Y[j] == 1: W[j] = 0

        elif X[j] == 0 and Y[j] == 2: W[j] = 0

        elif X[j] == 1 and Y[j] == 0: W[j] = 0

        elif X[j] == Y[j] == 1: W[j] = 1

        elif X[j] == 1 and Y[j] == 2: W[j] = 0

        elif X[j] == 2 and Y[j] == 0: W[j] = 0

        elif X[j] == 2 and Y[j] == 1: W[j] = 2

        elif X[j] == Y[j] == 2: W[j] = 1

def RotateShiftLeft7(lRSHL):
    tTemp = (lRSHL[0], lRSHL[1], lRSHL[2], lRSHL[3], lRSHL[4], lRSHL[5], lRSHL[6])

    lRSHL[0] = lRSHL[7]

    lRSHL[1] = lRSHL[8]

    lRSHL[2] = lRSHL[9]

    lRSHL[3] = lRSHL[10]

    lRSHL[4] = lRSHL[11]

    lRSHL[5] = lRSHL[12]

    lRSHL[6] = lRSHL[13]

    lRSHL[7] = lRSHL[14]

    lRSHL[8] = lRSHL[15]

    lRSHL[9] = lRSHL[16]

    lRSHL[10] = lRSHL[17]

    lRSHL[11] = lRSHL[18]

    lRSHL[12] = lRSHL[19]

    lRSHL[13] = lRSHL[20]

    lRSHL[14] = lRSHL[21]

    lRSHL[15] = lRSHL[22]

    lRSHL[16] = lRSHL[23]

    lRSHL[17] = tTemp[0]

    lRSHL[18] = tTemp[1]

    lRSHL[19] = tTemp[2]

    lRSHL[20] = tTemp[3]

    lRSHL[21] = tTemp[4]

    lRSHL[22] = tTemp[5]

    lRSHL[23] = tTemp[6]

def Add(W, Z):
    iCarry = 0

    for i in range(24):
        W[i] += Z[i] + iCarry

        if W[i] > 2:
            W[i] -= 3

            if iCarry == 0:
                iCarry = 1
        else:
            iCarry = 0

def Assign(X, Y):
    for j in range(24):
        X[j] = Y[j]

def RotateShiftLeft19(lRSHL1, lRSHL2):
    lRSHL1[23] = lRSHL2[18]

    lRSHL1[22] = lRSHL2[17]

    lRSHL1[21] = lRSHL2[16]

    lRSHL1[20] = lRSHL2[15]

    lRSHL1[19] = lRSHL2[14]

    lRSHL1[18] = lRSHL2[13]

    lRSHL1[17] = lRSHL2[12]

    lRSHL1[16] = lRSHL2[11]

    lRSHL1[15] = lRSHL2[10]

    lRSHL1[14] = lRSHL2[9]

    lRSHL1[13] = lRSHL2[8]

    lRSHL1[12] = lRSHL2[7]

    lRSHL1[11] = lRSHL2[6]

    lRSHL1[10] = lRSHL2[5]

    lRSHL1[9] = lRSHL2[4]

    lRSHL1[8] = lRSHL2[3]

    lRSHL1[7] = lRSHL2[2]

    lRSHL1[6] = lRSHL2[1]

    lRSHL1[5] = lRSHL2[0]

    lRSHL1[4] = lRSHL2[23]

    lRSHL1[3] = lRSHL2[22]

    lRSHL1[2] = lRSHL2[21]

    lRSHL1[1] = lRSHL2[20]

    lRSHL1[0] = lRSHL2[19]

def SHA3Hash(SHA3):
    A, B, C, D, E, F = [0] * 24, [0] * 24, [0] * 24, [0] * 24, [0] * 24, [0] * 24

    G, H, I, P, Q, T = [0] * 24, [0] * 24, [0] * 24, [0] * 24, [0] * 24, [0] * 24

    W = [[0] * 24 for l in range(80)]

    Assign(A, SHA3.lMessageDigest[0])

    Assign(B, SHA3.lMessageDigest[1])

    Assign(C, SHA3.lMessageDigest[2])

    Assign(D, SHA3.lMessageDigest[3])

    Assign(E, SHA3.lMessageDigest[4])

    Trinary24(F, 0x5A827999)

    Trinary24(G, 0x6ED9EBA1)

    Trinary24(H, 0x8F1BBCDC)

    Trinary24(I, 0xCA62C1D6)

    for i, j in zip(range(0, 64, 4), range(16)):
        W[j][23] = SHA3.lDataBlock[i][5]

        W[j][22] = SHA3.lDataBlock[i][4]

        W[j][21] = SHA3.lDataBlock[i][3]

        W[j][20] = SHA3.lDataBlock[i][2]

        W[j][19] = SHA3.lDataBlock[i][1]

        W[j][18] = SHA3.lDataBlock[i][0]

        W[j][17] = SHA3.lDataBlock[i + 1][5]

        W[j][16] = SHA3.lDataBlock[i + 1][4]

        W[j][15] = SHA3.lDataBlock[i + 1][3]

        W[j][14] = SHA3.lDataBlock[i + 1][2]

        W[j][13] = SHA3.lDataBlock[i + 1][1]

        W[j][12] = SHA3.lDataBlock[i + 1][0]

        W[j][11] = SHA3.lDataBlock[i + 2][5]

        W[j][10] = SHA3.lDataBlock[i + 2][4]

        W[j][9] = SHA3.lDataBlock[i + 2][3]

        W[j][8] = SHA3.lDataBlock[i + 2][2]

        W[j][7] = SHA3.lDataBlock[i + 2][1]

        W[j][6] = SHA3.lDataBlock[i + 2][0]

        W[j][5] = SHA3.lDataBlock[i + 3][5]

        W[j][4] = SHA3.lDataBlock[i + 3][4]

        W[j][3] = SHA3.lDataBlock[i + 3][3]

        W[j][2] = SHA3.lDataBlock[i + 3][2]

        W[j][1] = SHA3.lDataBlock[i + 3][1]

        W[j][0] = SHA3.lDataBlock[i + 3][0]

    for k in range(16, 80):
        TrinaryXOr0(T, W[k - 3], W[k - 5])

        TrinaryXAnd2(T, T, W[k - 7])

        TrinaryXOr2(T, T, W[k - 11])

        TrinaryXAnd0(T, T, W[k - 13])

        W[k][23] = T[2]

        W[k][22] = T[1]

        W[k][21] = T[0]

        W[k][20] = T[23]

        W[k][19] = T[22]

        W[k][18] = T[21]

        W[k][17] = T[20]

        W[k][16] = T[19]

        W[k][15] = T[18]

        W[k][14] = T[17]

        W[k][13] = T[16]

        W[k][12] = T[15]

        W[k][11] = T[14]

        W[k][10] = T[13]

        W[k][9] = T[12]

        W[k][8] = T[11]

        W[k][7] = T[10]

        W[k][6] = T[9]

        W[k][5] = T[8]

        W[k][4] = T[7]

        W[k][3] = T[6]

        W[k][2] = T[5]

        W[k][1] = T[4]

        W[k][0] = T[3]

    for i in range(20):
        RotateShiftLeft7(A)

        TrinaryAdd(P, B, C)

        TrinarySubtract(Q, C, D)

        TrinaryAnd(P, P, Q)

        TrinaryDivide(Q, D, B)

        TrinaryOr(T, P, Q)

        Add(T, A)

        Add(T, E)

        Add(T, W[i])

        Add(T, F)

        Assign(E, D)

        Assign(D, C)

        RotateShiftLeft19(C, B)

        Assign(B, A)

        Assign(A, T)

    for j in range(20, 40):
        RotateShiftLeft7(A)

        TrinaryDivide(P, C, D)

        TrinaryMultiply(Q, D, B)

        TrinaryXAnd0(P, P, Q)

        TrinarySubtract(Q, B, C)

        TrinaryXOr2(T, P, Q)

        Add(T, A)

        Add(T, E)

        Add(T, W[j])

        Add(T, G)

        Assign(E, D)

        Assign(D, C)

        RotateShiftLeft19(C, B)

        Assign(B, A)

        Assign(A, T)

    for k in range(40, 60):
        RotateShiftLeft7(A)

        TrinaryAdd(P, D, B)

        TrinaryDivide(Q, B, C)

        TrinaryOr(P, P, Q)

        TrinaryMultiply(Q, C, D)

        TrinaryAnd(T, P, Q)

        Add(T, A)

        Add(T, E)

        Add(T, W[k])

        Add(T, H)

        Assign(E, D)

        Assign(D, C)

        RotateShiftLeft19(C, B)

        Assign(B, A)

        Assign(A, T)

    for l in range(60, 80):
        RotateShiftLeft7(A)

        TrinaryMultiply(P, B, C)

        TrinaryAdd(Q, C, D)

        TrinaryXAnd2(P, P, Q)

        TrinarySubtract(Q, D, B)

        TrinaryXOr0(T, P, Q)

        Add(T, A)

        Add(T, E)

        Add(T, W[l])

        Add(T, I)

        Assign(E, D)

        Assign(D, C)

        RotateShiftLeft19(C, B)

        Assign(B, A)

        Assign(A, T)

    Assign(SHA3.lMessageDigest[0], A)

    Assign(SHA3.lMessageDigest[1], B)

    Assign(SHA3.lMessageDigest[2], C)

    Assign(SHA3.lMessageDigest[3], D)

    Assign(SHA3.lMessageDigest[4], E)

if __name__ == "__main__":
    if len(sys.argv) != 2: Usage()

    else:
        statFileSize = os.stat(sys.argv[1])

        iFileSize = statFileSize.st_size

        if iFileSize == 0:
            print("There is no data in file [{}], 0 byte.".format(sys.argv[1]))

            exit(-1)

        iBytesLeft = iFileSize & 63

        if iBytesLeft == 0: iBytesLeft = iFileSize + 64

        elif iBytesLeft < 54: iBytesLeft = iFileSize - iBytesLeft + 64

        elif iBytesLeft > 53: iBytesLeft = iFileSize - iBytesLeft + 128

        with open(sys.argv[1], "br") as fdData:
            baData = bytearray(fdData.read())

        tPadding = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
            101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
            211, 223, 227, 229, 233, 239, 241, 251, 15, 25, 35, 55, 65, 85, 95, 115, 145, 155)

        while iFileSize < iBytesLeft:
            for i in range(5):
                baData.append(statFileSize.st_size >> 8 * i & 255)

                iFileSize += 1

            j = 0

            while iFileSize < iBytesLeft - 5:
                baData.append(tPadding[j])

                j += 1

                iFileSize += 1

            for k in range(4, -1, -1):
                baData.append(statFileSize.st_size >> 8 * k & 255)

                iFileSize += 1

        SHA3 = SHA3Context()

        Trinary24(SHA3.lMessageDigest[0], 0x67452301)

        Trinary24(SHA3.lMessageDigest[1], 0xEFCDAB89)

        Trinary24(SHA3.lMessageDigest[2], 0x98BADCFE)

        Trinary24(SHA3.lMessageDigest[3], 0x10325476)

        Trinary24(SHA3.lMessageDigest[4], 0xC3D2E1F0)

        for i in range(0, iBytesLeft, 64):
            for j in range(64):
                Trinary6(SHA3.lDataBlock[j], baData[i + j])

            SHA3Hash(SHA3)

        for k in range(24):
            print(f"{SHA3.lMessageDigest[0][k]}{SHA3.lMessageDigest[1][k]}{SHA3.lMessageDigest[2][k]}{SHA3.lMessageDigest[3][k]}{SHA3.lMessageDigest[4][k]}", sep = "", end = "")

        print()