/*************************************************************
* 作者：伍耀晖               Author: Geek.Zhiyuan            *
* 开源日期：2022年7月25日    Open Source Date: 2022-7-25     *
* 国家城市：中国广州         City, Country: GuangZhou, China *
*************************************************************/

import java.io.*;

public class SHA3Hash
{
    final static byte[] baPadding = {(byte)2, (byte)3, (byte)5, (byte)7, (byte)11, (byte)13, (byte)17, (byte)19, (byte)23, (byte)29,
        (byte)31, (byte)37, (byte)41, (byte)43, (byte)47, (byte)53, (byte)59, (byte)61, (byte)67, (byte)71, (byte)73, (byte)79,
        (byte)83, (byte)89, (byte)97, (byte)101, (byte)103, (byte)107, (byte)109, (byte)113, (byte)127, (byte)131, (byte)137, (byte)139,
        (byte)149, (byte)151, (byte)157, (byte)163, (byte)167, (byte)173, (byte)179, (byte)181, (byte)191, (byte)193, (byte)197, (byte)199,
        (byte)211, (byte)223, (byte)227, (byte)229, (byte)233, (byte)239, (byte)241, (byte)251,
        (byte)15, (byte)25, (byte)35, (byte)55, (byte)65, (byte)85, (byte)95, (byte)115, (byte)145, (byte)155};

    private static class SHA3Context
    {
        private byte[][] baDataBlock = new byte[64][6];

        private byte[][] baMessageDigest = new byte[5][24];
    }

    private static void Usage()
    {
        System.out.printf("Usage: java SHA3Hash YouWantToHash.File\n");
    }

    private static void Trinary6(byte[] baTrinary,
                                 int iNumeric)
    {
        baTrinary[0] = baTrinary[1] = baTrinary[2] = baTrinary[3] = baTrinary[4] = baTrinary[5] = 0;

        if (iNumeric != 0)
        {
            for (int i = 5; i >= 0; --i)
            {
                baTrinary[i] = (byte)(iNumeric % 3 & 255);

                iNumeric /= 3;
            }
        }
    }

    private static void Trinary24(byte[] baTrinary,
                                  long lNumeric)
    {
        baTrinary[0] = baTrinary[1] = baTrinary[2] = baTrinary[3] = baTrinary[4] = baTrinary[5] = baTrinary[6] = baTrinary[7] = 0;

        baTrinary[8] = baTrinary[9] = baTrinary[10] = baTrinary[11] = baTrinary[12] = baTrinary[13] = baTrinary[14] = baTrinary[15] = 0;

        baTrinary[16] = baTrinary[17] = baTrinary[18] = baTrinary[19] = baTrinary[20] = baTrinary[21] = baTrinary[22] = baTrinary[23] = 0;

        if (lNumeric != 0)
        {
            for (int j = 23; j >= 0; --j)
            {
                baTrinary[j] = (byte)(lNumeric % 3 & 255);

                lNumeric /= 3;
            }
        }
    }

// 0 0 0
// 0 1 1
// 0 1 2

    private static void TrinaryAnd(byte[] W,
                                   byte[] X,
                                   byte[] Y)
    {
        for(int i = 0; i < 24; ++i)
        {
            if(X[i] == 0 && Y[i] == 0)
            {
                W[i] = 0;
            }
            else if(X[i] == 0 && Y[i] == 1)
            {
                W[i] = 0;
            }
            else if(X[i] == 0 && Y[i] == 2)
            {
                W[i] = 0;
            }
            else if(X[i] == 1 && Y[i] == 0)
            {
                W[i] = 0;
            }
            else if(X[i] == 1 && Y[i] == 1)
            {
                W[i] = 1;
            }
            else if(X[i] == 1 && Y[i] == 2)
            {
                W[i] = 1;
            }
            else if(X[i] == 2 && Y[i] == 0)
            {
                W[i] = 0;
            }
            else if(X[i] == 2 && Y[i] == 1)
            {
                W[i] = 1;
            }
            else if(X[i] == 2 && Y[i] == 2)
            {
                W[i] = 2;
            }
        }
    }

// 0 1 2
// 1 1 2
// 2 2 2

    private static void TrinaryOr(byte[] W,
                                  byte[] X,
                                  byte[] Y)
    {
        for(int j = 0; j < 24; ++j)
        {
            if(X[j] == 0 && Y[j] == 0)
            {
                W[j] = 0;
            }
            else if(X[j] == 0 && Y[j] == 1)
            {
                W[j] = 1;
            }
            else if(X[j] == 0 && Y[j] == 2)
            {
                W[j] = 2;
            }
            else if(X[j] == 1 && Y[j] == 0)
            {
                W[j] = 1;
            }
            else if(X[j] == 1 && Y[j] == 1)
            {
                W[j] = 1;
            }
            else if(X[j] == 1 && Y[j] == 2)
            {
                W[j] = 2;
            }
            else if(X[j] == 2 && Y[j] == 0)
            {
                W[j] = 2;
            }
            else if(X[j] == 2 && Y[j] == 1)
            {
                W[j] = 2;
            }
            else if(X[j] == 2 && Y[j] == 2)
            {
                W[j] = 2;
            }
        }
    }

// 0 0 2
// 1 1 1
// 2 2 0

    private static void TrinaryXOr0(byte[] W,
                                    byte[] X,
                                    byte[] Y)
    {
        for (int k = 0; k < 24; ++k)
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

    private static void TrinaryXOr2(byte[] W,
                                    byte[] X,
                                    byte[] Y)
    {
        for (int l = 0; l < 24; ++l)
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

    private static void TrinaryXAnd0(byte[] W,
                                     byte[] X,
                                     byte[] Y)
    {
        for (int i = 0; i < 24; ++i)
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

    private static void TrinaryXAnd2(byte[] W,
                                     byte[] X,
                                     byte[] Y)
    {
        for (int j = 0; j < 24; ++j)
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

    private static void TrinaryAdd(byte[] W,
                                   byte[] X,
                                   byte[] Y)
    {
        for (int k = 0; k < 24; ++k)
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

    private static void TrinarySubtract(byte[] W,
                                        byte[] X,
                                        byte[] Y)
    {
        for (int l = 0; l < 24; ++l)
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

    private static void TrinaryMultiply(byte[] W,
                                        byte[] X,
                                        byte[] Y)
    {
        for (int i = 0; i < 24; ++i)
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

    private static void TrinaryDivide(byte[] W,
                                      byte[] X,
                                      byte[] Y)
    {
        for (int j = 0; j < 24; ++j)
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

    private static void RotateShiftLeft7(byte[] baRSHL)
    {
        byte[] baTemp = {baRSHL[0], baRSHL[1], baRSHL[2], baRSHL[3], baRSHL[4], baRSHL[5], baRSHL[6]};

        baRSHL[0] = baRSHL[7];

        baRSHL[1] = baRSHL[8];

        baRSHL[2] = baRSHL[9];

        baRSHL[3] = baRSHL[10];

        baRSHL[4] = baRSHL[11];

        baRSHL[5] = baRSHL[12];

        baRSHL[6] = baRSHL[13];

        baRSHL[7] = baRSHL[14];

        baRSHL[8] = baRSHL[15];

        baRSHL[9] = baRSHL[16];

        baRSHL[10] = baRSHL[17];

        baRSHL[11] = baRSHL[18];

        baRSHL[12] = baRSHL[19];

        baRSHL[13] = baRSHL[20];

        baRSHL[14] = baRSHL[21];

        baRSHL[15] = baRSHL[22];

        baRSHL[16] = baRSHL[23];

        baRSHL[17] = baTemp[0];

        baRSHL[18] = baTemp[1];

        baRSHL[19] = baTemp[2];

        baRSHL[20] = baTemp[3];

        baRSHL[21] = baTemp[4];

        baRSHL[22] = baTemp[5];

        baRSHL[23] = baTemp[6];
    }

    private static void Add(byte[] W,
                            byte[] Z)
    {
        int iCarry = 0;

        for (int i = 0; i < 24; ++i)
        {
            W[i] += Z[i] + iCarry;

            if (W[i] > 2)
            {
                W[i] -= 3;

                if (iCarry == 0)
                {
                    iCarry = 1;
                }
            }
            else
            {
                iCarry = 0;
            }
        }
    }

    private static void Assign(byte[] X,
                               byte[] Y)
    {
        for (int j = 0; j < 24; ++j)
        {
            X[j] = Y[j];
        }
    }

    private static void RotateShiftLeft19(byte[] baRSHL1,
                                          byte[] baRSHL2)
    {
        baRSHL1[23] = baRSHL2[18];

        baRSHL1[22] = baRSHL2[17];

        baRSHL1[21] = baRSHL2[16];

        baRSHL1[20] = baRSHL2[15];

        baRSHL1[19] = baRSHL2[14];

        baRSHL1[18] = baRSHL2[13];

        baRSHL1[17] = baRSHL2[12];

        baRSHL1[16] = baRSHL2[11];

        baRSHL1[15] = baRSHL2[10];

        baRSHL1[14] = baRSHL2[9];

        baRSHL1[13] = baRSHL2[8];

        baRSHL1[12] = baRSHL2[7];

        baRSHL1[11] = baRSHL2[6];

        baRSHL1[10] = baRSHL2[5];

        baRSHL1[9] = baRSHL2[4];

        baRSHL1[8] = baRSHL2[3];

        baRSHL1[7] = baRSHL2[2];

        baRSHL1[6] = baRSHL2[1];

        baRSHL1[5] = baRSHL2[0];

        baRSHL1[4] = baRSHL2[23];

        baRSHL1[3] = baRSHL2[22];

        baRSHL1[2] = baRSHL2[21];

        baRSHL1[1] = baRSHL2[20];

        baRSHL1[0] = baRSHL2[19];
    }

    private static void SHA3HashCode(SHA3Context SHA3)
    {
        byte[] A = new byte[24], B = new byte[24], C = new byte[24], D = new byte[24], E = new byte[24], F = new byte[24];

        byte[] G = new byte[24], H = new byte[24], I = new byte[24], P = new byte[24], Q = new byte[24], T = new byte[24];

        byte[][] W = new byte[80][24];

        Assign(A, SHA3.baMessageDigest[0]);

        Assign(B, SHA3.baMessageDigest[1]);

        Assign(C, SHA3.baMessageDigest[2]);

        Assign(D, SHA3.baMessageDigest[3]);

        Assign(E, SHA3.baMessageDigest[4]);

        Trinary24(F, 0X5A827999L);

        Trinary24(G, 0X6ED9EBA1L);

        Trinary24(H, 0X8F1BBCDCL);

        Trinary24(I, 0XCA62C1D6L);

        for (int i = 0, j = 0; j < 16; i += 4, ++j)
        {
            W[j][23] = SHA3.baDataBlock[i][5];

            W[j][22] = SHA3.baDataBlock[i][4];

            W[j][21] = SHA3.baDataBlock[i][3];

            W[j][20] = SHA3.baDataBlock[i][2];

            W[j][19] = SHA3.baDataBlock[i][1];

            W[j][18] = SHA3.baDataBlock[i][0];

            W[j][17] = SHA3.baDataBlock[i + 1][5];

            W[j][16] = SHA3.baDataBlock[i + 1][4];

            W[j][15] = SHA3.baDataBlock[i + 1][3];

            W[j][14] = SHA3.baDataBlock[i + 1][2];

            W[j][13] = SHA3.baDataBlock[i + 1][1];

            W[j][12] = SHA3.baDataBlock[i + 1][0];

            W[j][11] = SHA3.baDataBlock[i + 2][5];

            W[j][10] = SHA3.baDataBlock[i + 2][4];

            W[j][9] = SHA3.baDataBlock[i + 2][3];

            W[j][8] = SHA3.baDataBlock[i + 2][2];

            W[j][7] = SHA3.baDataBlock[i + 2][1];

            W[j][6] = SHA3.baDataBlock[i + 2][0];

            W[j][5] = SHA3.baDataBlock[i + 3][5];

            W[j][4] = SHA3.baDataBlock[i + 3][4];

            W[j][3] = SHA3.baDataBlock[i + 3][3];

            W[j][2] = SHA3.baDataBlock[i + 3][2];

            W[j][1] = SHA3.baDataBlock[i + 3][1];

            W[j][0] = SHA3.baDataBlock[i + 3][0];
        }

        for (int k = 16; k < 80; ++k)
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

        for (int i = 0; i < 20; ++i)
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

        for (int j = 20; j < 40; ++j)
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

        for (int k = 40; k < 60; ++k)
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

        for (int l = 60; l < 80; ++l)
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

        Assign(SHA3.baMessageDigest[0], A);

        Assign(SHA3.baMessageDigest[1], B);

        Assign(SHA3.baMessageDigest[2], C);

        Assign(SHA3.baMessageDigest[3], D);

        Assign(SHA3.baMessageDigest[4], E);
    }

    public static void main(String[] args)
    {
        if (args.length != 1)
        {
            Usage();
        }
        else
        {
            File flFD = new File(args[0]);

            long lFileSize = flFD.length();

            if (lFileSize == 0)
            {
                System.out.printf("There is no data in file [%s], 0 byte.\n", args[0]);

                System.exit(-1);
            }

            long lBytesLeft = lFileSize & 63;

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

            byte[] baData = new byte[(int)lBytesLeft];

            try
            {
                FileInputStream fisData = new FileInputStream(flFD);

                fisData.read(baData, 0, (int)lFileSize);

                fisData.close();
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }

            for (int i = 0; i < 5; ++i)
            {
                baData[i + (int)lFileSize] = (byte)(lFileSize >>> 8 * i & 255);
            }

            for (int j = (int)(lFileSize + 5), k = 0; j < (int)(lBytesLeft - 5); ++j, ++k)
            {
                baData[j] = baPadding[k];
            }

            for (int l = 5; l > 0; --l)
            {
                baData[(int)(lBytesLeft - l)] = (byte)(lFileSize >>> 8 * (l - 1) & 255);
            }

            SHA3Context SHA3 = new SHA3Context();

            Trinary24(SHA3.baMessageDigest[0], 0X67452301L);

            Trinary24(SHA3.baMessageDigest[1], 0XEFCDAB89L);

            Trinary24(SHA3.baMessageDigest[2], 0X98BADCFEL);

            Trinary24(SHA3.baMessageDigest[3], 0X10325476L);

            Trinary24(SHA3.baMessageDigest[4], 0XC3D2E1F0L);

            for (int i = 0; i < lBytesLeft; i += 64)
            {
                for (int j = 0; j < 64; ++j)
                {
                    Trinary6(SHA3.baDataBlock[j], baData[i + j] & 255);
                }

                SHA3HashCode(SHA3);
            }

            for (int k = 0; k < 24; ++k)
            {
                System.out.printf("%d%d%d%d%d", SHA3.baMessageDigest[0][k], SHA3.baMessageDigest[1][k],
                    SHA3.baMessageDigest[2][k], SHA3.baMessageDigest[3][k], SHA3.baMessageDigest[4][k]);
            }

            System.out.println();
        }
    }
}