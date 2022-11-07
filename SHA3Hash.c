/*************************************************************
* 作者：伍耀晖               Author: Geek.Zhiyuan            *
* 开源日期：2022年7月25日    Open Source Date: 2022-7-25     *
* 国家城市：中国广州         City, Country: GuangZhou, China *
*************************************************************/

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

typedef struct
{
    unsigned char ucaDataBlock[64][6];

    unsigned char ucaMessageDigest[5][24];
} SHA3Context;

void Usage()
{
    printf ("Usage: SHA3Hash YouWantToHash.File\n");
}

void Trinary6(unsigned char *ucpTrinary,
              unsigned char ucNumeric)
{
    ucpTrinary[0] = ucpTrinary[1] = ucpTrinary[2] = ucpTrinary[3] = ucpTrinary[4] = ucpTrinary[5] = 0;

    if (ucNumeric != 0)
    {

        for (long long i = 5; i >= 0; --i)
        {
            ucpTrinary[i] = ucNumeric % 3;

            ucNumeric /= 3;
        }
    }
}

void Trinary24(unsigned char *ucpTrinary,
               long long lNumeric)
{
    ucpTrinary[0] = ucpTrinary[1] = ucpTrinary[2] = ucpTrinary[3] = ucpTrinary[4] = ucpTrinary[5] = ucpTrinary[6] = ucpTrinary[7] = 0;

    ucpTrinary[8] = ucpTrinary[9] = ucpTrinary[10] = ucpTrinary[11] = ucpTrinary[12] = ucpTrinary[13] = ucpTrinary[14] = ucpTrinary[15] = 0;

    ucpTrinary[16] = ucpTrinary[17] = ucpTrinary[18] = ucpTrinary[19] = ucpTrinary[20] = ucpTrinary[21] = ucpTrinary[22] = ucpTrinary[23] = 0;

    if (lNumeric != 0)
    {
        for (long long j = 23; j >= 0; --j)
        {
            ucpTrinary[j] = lNumeric % 3;

            lNumeric /= 3;
        }
    }
}

// 0 0 0
// 0 1 1
// 0 1 2

void TrinaryAnd(unsigned char *W,
                unsigned char *X,
                unsigned char *Y)
{
    for (long long i = 0; i < 24; ++i)
    {
        if (X[i] == 0 && Y[i] == 0)
        {
            W[i] = 0;
        }
        else if (X[i] == 0 && Y[i] == 1)
        {
            W[i] = 0;
        }
        else if (X[i] == 0 && Y[i] == 2)
        {
            W[i] = 0;
        }
        else if (X[i] == 1 && Y[i] == 0)
        {
            W[i] = 0;
        }
        else if (X[i] == 1 && Y[i] == 1)
        {
            W[i] = 1;
        }
        else if (X[i] == 1 && Y[i] == 2)
        {
            W[i] = 1;
        }
        else if (X[i] == 2 && Y[i] == 0)
        {
            W[i] = 0;
        }
        else if (X[i] == 2 && Y[i] == 1)
        {
            W[i] = 1;
        }
        else if (X[i] == 2 && Y[i] == 2)
        {
            W[i] = 2;
        }
    }
}

// 0 1 2
// 1 1 2
// 2 2 2

void TrinaryOr(unsigned char *W,
               unsigned char *X,
               unsigned char *Y)
{
    for (long long j = 0; j < 24; ++j)
    {
        if (X[j] == 0 && Y[j] == 0)
        {
            W[j] = 0;
        }
        else if (X[j] == 0 && Y[j] == 1)
        {
            W[j] = 1;
        }
        else if (X[j] == 0 && Y[j] == 2)
        {
            W[j] = 2;
        }
        else if (X[j] == 1 && Y[j] == 0)
        {
            W[j] = 1;
        }
        else if (X[j] == 1 && Y[j] == 1)
        {
            W[j] = 1;
        }
        else if (X[j] == 1 && Y[j] == 2)
        {
            W[j] = 2;
        }
        else if (X[j] == 2 && Y[j] == 0)
        {
            W[j] = 2;
        }
        else if (X[j] == 2 && Y[j] == 1)
        {
            W[j] = 2;
        }
        else if (X[j] == 2 && Y[j] == 2)
        {
            W[j] = 2;
        }
    }
}

// 0 0 2
// 1 1 1
// 2 2 0

void TrinaryXOr0(unsigned char *W,
                 unsigned char *X,
                 unsigned char *Y)
{
    for (long long k = 0; k < 24; ++k)
    {
        if (X[k] == 0 && Y[k] == 0)
        {
            W[k] = 0;
        }
        else if (X[k] == 0 && Y[k] == 1)
        {
            W[k] = 0;
        }
        else if (X[k] == 0 && Y[k] == 2)
        {
            W[k] = 2;
        }
        else if (X[k] == 1 && Y[k] == 0)
        {
            W[k] = 1;
        }
        else if (X[k] == 1 && Y[k] == 1)
        {
            W[k] = 1;
        }
        else if (X[k] == 1 && Y[k] == 2)
        {
            W[k] = 1;
        }
        else if (X[k] == 2 && Y[k] == 0)
        {
            W[k] = 2;
        }
        else if (X[k] == 2 && Y[k] == 1)
        {
            W[k] = 2;
        }
        else if (X[k] == 2 && Y[k] == 2)
        {
            W[k] = 0;
        }
    }
}

// 0 2 2
// 1 1 1
// 2 0 0

void TrinaryXOr2(unsigned char *W,
                 unsigned char *X,
                 unsigned char *Y)
{
    for (long long l = 0; l < 24; ++l)
    {
        if (X[l] == 0 && Y[l] == 0)
        {
            W[l] = 0;
        }
        else if (X[l] == 0 && Y[l] == 1)
        {
            W[l] = 2;
        }
        else if (X[l] == 0 && Y[l] == 2)
        {
            W[l] = 2;
        }
        else if (X[l] == 1 && Y[l] == 0)
        {
            W[l] = 1;
        }
        else if (X[l] == 1 && Y[l] == 1)
        {
            W[l] = 1;
        }
        else if (X[l] == 1 && Y[l] == 2)
        {
            W[l] = 1;
        }
        else if (X[l] == 2 && Y[l] == 0)
        {
            W[l] = 2;
        }
        else if (X[l] == 2 && Y[l] == 1)
        {
            W[l] = 0;
        }
        else if (X[l] == 2 && Y[l] == 2)
        {
            W[l] = 0;
        }
    }
}

// 2 0 0
// 1 1 1
// 0 2 2

void TrinaryXAnd0(unsigned char *W,
                  unsigned char *X,
                  unsigned char *Y)
{
    for (long long i = 0; i < 24; ++i)
    {
        if (X[i] == 0 && Y[i] == 0)
        {
            W[i] = 2;
        }
        else if (X[i] == 0 && Y[i] == 1)
        {
            W[i] = 0;
        }
        else if (X[i] == 0 && Y[i] == 2)
        {
            W[i] = 0;
        }
        else if (X[i] == 1 && Y[i] == 0)
        {
            W[i] = 1;
        }
        else if (X[i] == 1 && Y[i] == 1)
        {
            W[i] = 1;
        }
        else if (X[i] == 1 && Y[i] == 2)
        {
            W[i] = 1;
        }
        else if (X[i] == 2 && Y[i] == 0)
        {
            W[i] = 0;
        }
        else if (X[i] == 2 && Y[i] == 1)
        {
            W[i] = 2;
        }
        else if (X[i] == 2 && Y[i] == 2)
        {
            W[i] = 2;
        }
    }
}

// 2 2 0
// 1 1 1
// 0 0 2

void TrinaryXAnd2(unsigned char *W,
                  unsigned char *X,
                  unsigned char *Y)
{
    for (long long j = 0; j < 24; ++j)
    {
        if (X[j] == 0 && Y[j] == 0)
        {
            W[j] = 2;
        }
        else if (X[j] == 0 && Y[j] == 1)
        {
            W[j] = 2;
        }
        else if (X[j] == 0 && Y[j] == 2)
        {
            W[j] = 0;
        }
        else if (X[j] == 1 && Y[j] == 0)
        {
            W[j] = 1;
        }
        else if (X[j] == 1 && Y[j] == 1)
        {
            W[j] = 1;
        }
        else if (X[j] == 1 && Y[j] == 2)
        {
            W[j] = 1;
        }
        else if (X[j] == 2 && Y[j] == 0)
        {
            W[j] = 0;
        }
        else if (X[j] == 2 && Y[j] == 1)
        {
            W[j] = 0;
        }
        else if (X[j] == 2 && Y[j] == 2)
        {
            W[j] = 2;
        }
    }
}

// 0 1 2
// 1 2 0
// 2 0 1

void TrinaryAdd(unsigned char *W,
                unsigned char *X,
                unsigned char *Y)
{
    for (long long k = 0; k < 24; ++k)
    {
        if (X[k] == 0 && Y[k] == 0)
        {
            W[k] = 0;
        }
        else if (X[k] == 0 && Y[k] == 1)
        {
            W[k] = 1;
        }
        else if (X[k] == 0 && Y[k] == 2)
        {
            W[k] = 2;
        }
        else if (X[k] == 1 && Y[k] == 0)
        {
            W[k] = 1;
        }
        else if (X[k] == 1 && Y[k] == 1)
        {
            W[k] = 2;
        }
        else if (X[k] == 1 && Y[k] == 2)
        {
            W[k] = 0;
        }
        else if (X[k] == 2 && Y[k] == 0)
        {
            W[k] = 2;
        }
        else if (X[k] == 2 && Y[k] == 1)
        {
            W[k] = 0;
        }
        else if (X[k] == 2 && Y[k] == 2)
        {
            W[k] = 1;
        }
    }
}

// 0 2 1
// 1 0 2
// 2 1 0

void TrinarySubtract(unsigned char *W,
                     unsigned char *X,
                     unsigned char *Y)
{
    for (long long l = 0; l < 24; ++l)
    {
        if (X[l] == 0 && Y[l] == 0)
        {
            W[l] = 0;
        }
        else if (X[l] == 0 && Y[l] == 1)
        {
            W[l] = 2;
        }
        else if (X[l] == 0 && Y[l] == 2)
        {
            W[l] = 1;
        }
        else if (X[l] == 1 && Y[l] == 0)
        {
            W[l] = 1;
        }
        else if (X[l] == 1 && Y[l] == 1)
        {
            W[l] = 0;
        }
        else if (X[l] == 1 && Y[l] == 2)
        {
            W[l] = 2;
        }
        else if (X[l] == 2 && Y[l] == 0)
        {
            W[l] = 2;
        }
        else if (X[l] == 2 && Y[l] == 1)
        {
            W[l] = 1;
        }
        else if (X[l] == 2 && Y[l] == 2)
        {
            W[l] = 0;
        }
    }
}

// 0 0 0
// 0 1 2
// 0 2 1

void TrinaryMultiply(unsigned char *W,
                     unsigned char *X,
                     unsigned char *Y)
{
    for (long long i = 0; i < 24; ++i)
    {
        if (X[i] == 0 && Y[i] == 0)
        {
            W[i] = 0;
        }
        else if (X[i] == 0 && Y[i] == 1)
        {
            W[i] = 0;
        }
        else if (X[i] == 0 && Y[i] == 2)
        {
            W[i] = 0;
        }
        else if (X[i] == 1 && Y[i] == 0)
        {
            W[i] = 0;
        }
        else if (X[i] == 1 && Y[i] == 1)
        {
            W[i] = 1;
        }
        else if (X[i] == 1 && Y[i] == 2)
        {
            W[i] = 2;
        }
        else if (X[i] == 2 && Y[i] == 0)
        {
            W[i] = 0;
        }
        else if (X[i] == 2 && Y[i] == 1)
        {
            W[i] = 2;
        }
        else if (X[i] == 2 && Y[i] == 2)
        {
            W[i] = 1;
        }
    }
}

// 0 0 0
// 0 1 0
// 0 2 1

void TrinaryDivide(unsigned char *W,
                   unsigned char *X,
                   unsigned char *Y)
{
    for (long long j = 0; j < 24; ++j)
    {
        if (X[j] == 0 && Y[j] == 0)
        {
            W[j] = 0;
        }
        else if (X[j] == 0 && Y[j] == 1)
        {
            W[j] = 0;
        }
        else if (X[j] == 0 && Y[j] == 2)
        {
            W[j] = 0;
        }
        else if (X[j] == 1 && Y[j] == 0)
        {
            W[j] = 0;
        }
        else if (X[j] == 1 && Y[j] == 1)
        {
            W[j] = 1;
        }
        else if (X[j] == 1 && Y[j] == 2)
        {
            W[j] = 0;
        }
        else if (X[j] == 2 && Y[j] == 0)
        {
            W[j] = 0;
        }
        else if (X[j] == 2 && Y[j] == 1)
        {
            W[j] = 2;
        }
        else if (X[j] == 2 && Y[j] == 2)
        {
            W[j] = 1;
        }
    }
}

void RotateShiftLeft7(unsigned char *ucpRSHL)
{
    unsigned char ucaTemp[7] = {ucpRSHL[0], ucpRSHL[1], ucpRSHL[2], ucpRSHL[3], ucpRSHL[4], ucpRSHL[5], ucpRSHL[6]};

    ucpRSHL[0] = ucpRSHL[7];

    ucpRSHL[1] = ucpRSHL[8];

    ucpRSHL[2] = ucpRSHL[9];

    ucpRSHL[3] = ucpRSHL[10];

    ucpRSHL[4] = ucpRSHL[11];

    ucpRSHL[5] = ucpRSHL[12];

    ucpRSHL[6] = ucpRSHL[13];

    ucpRSHL[7] = ucpRSHL[14];

    ucpRSHL[8] = ucpRSHL[15];

    ucpRSHL[9] = ucpRSHL[16];

    ucpRSHL[10] = ucpRSHL[17];

    ucpRSHL[11] = ucpRSHL[18];

    ucpRSHL[12] = ucpRSHL[19];

    ucpRSHL[13] = ucpRSHL[20];

    ucpRSHL[14] = ucpRSHL[21];

    ucpRSHL[15] = ucpRSHL[22];

    ucpRSHL[16] = ucpRSHL[23];

    ucpRSHL[17] = ucaTemp[0];

    ucpRSHL[18] = ucaTemp[1];

    ucpRSHL[19] = ucaTemp[2];

    ucpRSHL[20] = ucaTemp[3];

    ucpRSHL[21] = ucaTemp[4];

    ucpRSHL[22] = ucaTemp[5];

    ucpRSHL[23] = ucaTemp[6];
}

void Add(unsigned char *W,
         unsigned char *Z)
{
    unsigned char ucCarry = 0;

    for (long long i = 0; i < 24; ++i)
    {
        W[i] += Z[i] + ucCarry;

        if (W[i] > 2)
        {
            W[i] -= 3;

            if (ucCarry == 0)
            {
                ucCarry = 1;
            }
        }
        else
        {
            ucCarry = 0;
        }
    }
}

void Assign(unsigned char *X,
            unsigned char *Y)
{
    for (long long j = 0; j < 24; ++j)
    {
        X[j] = Y[j];
    }
}

void RotateShiftLeft19(unsigned char *ucpRSHL1,
                       unsigned char *ucpRSHL2)
{
    ucpRSHL1[23] = ucpRSHL2[18];

    ucpRSHL1[22] = ucpRSHL2[17];

    ucpRSHL1[21] = ucpRSHL2[16];

    ucpRSHL1[20] = ucpRSHL2[15];

    ucpRSHL1[19] = ucpRSHL2[14];

    ucpRSHL1[18] = ucpRSHL2[13];

    ucpRSHL1[17] = ucpRSHL2[12];

    ucpRSHL1[16] = ucpRSHL2[11];

    ucpRSHL1[15] = ucpRSHL2[10];

    ucpRSHL1[14] = ucpRSHL2[9];

    ucpRSHL1[13] = ucpRSHL2[8];

    ucpRSHL1[12] = ucpRSHL2[7];

    ucpRSHL1[11] = ucpRSHL2[6];

    ucpRSHL1[10] = ucpRSHL2[5];

    ucpRSHL1[9] = ucpRSHL2[4];

    ucpRSHL1[8] = ucpRSHL2[3];

    ucpRSHL1[7] = ucpRSHL2[2];

    ucpRSHL1[6] = ucpRSHL2[1];

    ucpRSHL1[5] = ucpRSHL2[0];

    ucpRSHL1[4] = ucpRSHL2[23];

    ucpRSHL1[3] = ucpRSHL2[22];

    ucpRSHL1[2] = ucpRSHL2[21];

    ucpRSHL1[1] = ucpRSHL2[20];

    ucpRSHL1[0] = ucpRSHL2[19];
}

void SHA3Hash(SHA3Context *SHA3)
{
    unsigned char A[24], B[24], C[24], D[24], E[24], F[24], G[24], H[24], I[24], P[24], Q[24], T[24], W[80][24];

    Assign(A, SHA3->ucaMessageDigest[0]);

    Assign(B, SHA3->ucaMessageDigest[1]);

    Assign(C, SHA3->ucaMessageDigest[2]);

    Assign(D, SHA3->ucaMessageDigest[3]);

    Assign(E, SHA3->ucaMessageDigest[4]);

    Trinary24(F, 0x5A827999);

    Trinary24(G, 0x6ED9EBA1);

    Trinary24(H, 0x8F1BBCDC);

    Trinary24(I, 0xCA62C1D6);

    for (long long i = 0, j = 0; j < 16; i += 4, ++j)
    {
        W[j][23] = SHA3->ucaDataBlock[i][5];

        W[j][22] = SHA3->ucaDataBlock[i][4];

        W[j][21] = SHA3->ucaDataBlock[i][3];

        W[j][20] = SHA3->ucaDataBlock[i][2];

        W[j][19] = SHA3->ucaDataBlock[i][1];

        W[j][18] = SHA3->ucaDataBlock[i][0];

        W[j][17] = SHA3->ucaDataBlock[i + 1][5];

        W[j][16] = SHA3->ucaDataBlock[i + 1][4];

        W[j][15] = SHA3->ucaDataBlock[i + 1][3];

        W[j][14] = SHA3->ucaDataBlock[i + 1][2];

        W[j][13] = SHA3->ucaDataBlock[i + 1][1];

        W[j][12] = SHA3->ucaDataBlock[i + 1][0];

        W[j][11] = SHA3->ucaDataBlock[i + 2][5];

        W[j][10] = SHA3->ucaDataBlock[i + 2][4];

        W[j][9] = SHA3->ucaDataBlock[i + 2][3];

        W[j][8] = SHA3->ucaDataBlock[i + 2][2];

        W[j][7] = SHA3->ucaDataBlock[i + 2][1];

        W[j][6] = SHA3->ucaDataBlock[i + 2][0];

        W[j][5] = SHA3->ucaDataBlock[i + 3][5];

        W[j][4] = SHA3->ucaDataBlock[i + 3][4];

        W[j][3] = SHA3->ucaDataBlock[i + 3][3];

        W[j][2] = SHA3->ucaDataBlock[i + 3][2];

        W[j][1] = SHA3->ucaDataBlock[i + 3][1];

        W[j][0] = SHA3->ucaDataBlock[i + 3][0];
    }

    for (long long k = 16; k < 80; ++k)
    {
        TrinaryXOr0(T, W[k - 3], W[k - 5]);

        TrinaryXAnd2(T, T, W[k - 7]);

        TrinaryXOr2(T, T, W[k - 11]);

        TrinaryXAnd0(T, T, W[k - 13]);

        W[k][23] = T[2];

        W[k][22] = T[1];

        W[k][21] = T[0];

        W[k][20] = T[23];

        W[k][19] = T[22];

        W[k][18] = T[21];

        W[k][17] = T[20];

        W[k][16] = T[19];

        W[k][15] = T[18];

        W[k][14] = T[17];

        W[k][13] = T[16];

        W[k][12] = T[15];

        W[k][11] = T[14];

        W[k][10] = T[13];

        W[k][9] = T[12];

        W[k][8] = T[11];

        W[k][7] = T[10];

        W[k][6] = T[9];

        W[k][5] = T[8];

        W[k][4] = T[7];

        W[k][3] = T[6];

        W[k][2] = T[5];

        W[k][1] = T[4];

        W[k][0] = T[3];
    }

    for (long long i = 0; i < 20; ++i)
    {
        RotateShiftLeft7(A);

        TrinaryAdd(P, B, C);

        TrinarySubtract(Q, C, D);

        TrinaryAnd(P, P, Q);

        TrinaryDivide(Q, D, B);

        TrinaryOr(T, P, Q);

        Add(T, A);

        Add(T, E);

        Add(T, W[i]);

        Add(T, F);

        Assign(E, D);

        Assign(D, C);

        RotateShiftLeft19(C, B);

        Assign(B, A);

        Assign(A, T);
    }

    for (long long j = 20; j < 40; ++j)
    {
        RotateShiftLeft7(A);

        TrinaryDivide(P, C, D);

        TrinaryMultiply(Q, D, B);

        TrinaryXAnd0(P, P, Q);

        TrinarySubtract(Q, B, C);

        TrinaryXOr2(T, P, Q);

        Add(T, A);

        Add(T, E);

        Add(T, W[j]);

        Add(T, G);

        Assign(E, D);

        Assign(D, C);

        RotateShiftLeft19(C, B);

        Assign(B, A);

        Assign(A, T);
    }

    for (long long k = 40; k < 60; ++k)
    {
        RotateShiftLeft7(A);

        TrinaryAdd(P, D, B);

        TrinaryDivide(Q, B, C);

        TrinaryOr(P, P, Q);

        TrinaryMultiply(Q, C, D);

        TrinaryAnd(T, P, Q);

        Add(T, A);

        Add(T, E);

        Add(T, W[k]);

        Add(T, H);

        Assign(E, D);

        Assign(D, C);

        RotateShiftLeft19(C, B);

        Assign(B, A);

        Assign(A, T);
    }

    for (long long l = 60; l < 80; ++l)
    {
        RotateShiftLeft7(A);

        TrinaryMultiply(P, B, C);

        TrinaryAdd(Q, C, D);

        TrinaryXAnd2(P, P, Q);

        TrinarySubtract(Q, D, B);

        TrinaryXOr0(T, P, Q);

        Add(T, A);

        Add(T, E);

        Add(T, W[l]);

        Add(T, I);

        Assign(E, D);

        Assign(D, C);

        RotateShiftLeft19(C, B);

        Assign(B, A);

        Assign(A, T);
    }

    Assign(SHA3->ucaMessageDigest[0], A);

    Assign(SHA3->ucaMessageDigest[1], B);

    Assign(SHA3->ucaMessageDigest[2], C);

    Assign(SHA3->ucaMessageDigest[3], D);

    Assign(SHA3->ucaMessageDigest[4], E);
}

long long main(int argc,
               char *argv[])
{
    if (argc != 2)
    {
        Usage();
    }
    else
    {
        struct stat stattFileSize;

        stat(argv[1], &stattFileSize);

        long long lFileSize = stattFileSize.st_size;

        if (lFileSize == 0)
        {
            printf ("There is no data in file [%s], 0 byte.\n", argv[1]);

            return -1;
        }

        long long lBytesLeft = lFileSize & 63;

        if (lBytesLeft == 0)
        {
            lBytesLeft = lFileSize + 64;
        }
        else if (lBytesLeft < 54)
        {
            lBytesLeft = lFileSize - lBytesLeft + 64;
        }
        else if (lBytesLeft > 53)
        {
            lBytesLeft = lFileSize - lBytesLeft + 128;
        }

        unsigned char *ucpData = (unsigned char*)malloc(lBytesLeft);

        int iFD = open(argv[1], O_BINARY | O_RDONLY, S_IREAD | S_IWRITE);

        read(iFD, ucpData, lFileSize);

        close(iFD);

        const unsigned char ucaPadding[] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,
            53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149,
            151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251,
            15, 25, 35, 55, 65, 85, 95, 115, 145, 155};

        for (long long i = 0; i < 5; ++i)
        {
            ucpData[i + lFileSize] = ((unsigned char*)&lFileSize)[i];
        }

        for (long long j = lFileSize + 5, k = 0; j < lBytesLeft - 5; ++j, ++k)
        {
            ucpData[j] = ucaPadding[k];
        }

        for (long long l = 5; l > 0; --l)
        {
            ucpData[lBytesLeft - l] = ((unsigned char*)&lFileSize)[l - 1];
        }

        SHA3Context SHA3;

        Trinary24(SHA3.ucaMessageDigest[0], 0x67452301);

        Trinary24(SHA3.ucaMessageDigest[1], 0xEFCDAB89);

        Trinary24(SHA3.ucaMessageDigest[2], 0x98BADCFE);

        Trinary24(SHA3.ucaMessageDigest[3], 0x10325476);

        Trinary24(SHA3.ucaMessageDigest[4], 0xC3D2E1F0);

        for (long long i = 0; i < lBytesLeft; i += 64)
        {
            for (long long j = 0; j < 64; ++j)
            {
                Trinary6(SHA3.ucaDataBlock[j], ucpData[i + j]);
            }

            SHA3Hash(&SHA3);
        }

        for (long long k = 0; k < 24; ++k)
        {
            printf("%hhu%hhu%hhu%hhu%hhu", SHA3.ucaMessageDigest[0][k], SHA3.ucaMessageDigest[1][k],
                SHA3.ucaMessageDigest[2][k], SHA3.ucaMessageDigest[3][k], SHA3.ucaMessageDigest[4][k]);
        }

        putchar(10);

        free(ucpData);
    }

    return 0;
}