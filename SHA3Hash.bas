/'************************************************************
* 作者：伍耀晖               Author: Geek.Zhiyuan            *
* 开源日期：2022年7月25日    Open Source Date: 2022-7-25     *
* 国家城市：中国广州         City, Country: GuangZhou, China *
************************************************************'/
' Compiled by free basic. free basic website: www.freebasic.net

#include "file.bi"

Type SHA3Context
    ubaDataBlock(63, 5) As UByte

    ubaMessageDigest(4, 23) As UByte
End Type

Sub Usage()
    Print "Usage: SHA3Hash YouWantToHash.File"
End Sub

Sub Trinary6(ubpTrinary As UByte Pointer,_
             ByVal lNumeric As LongInt)
    ubpTrinary[0] = 0

    ubpTrinary[1] = 0

    ubpTrinary[2] = 0

    ubpTrinary[3] = 0

    ubpTrinary[4] = 0

    ubpTrinary[5] = 0

    If lNumeric <> 0 Then
        For i As LongInt = 5 To 0 Step -1
            ubpTrinary[i] = lNumeric Mod 3

            lNumeric \= 3

        Next i

    End If
End Sub

Sub Trinary24(ubpTrinary As UByte Pointer,_
              ByVal lNumeric As LongInt)
    ubpTrinary[0] = 0 : ubpTrinary[1] = 0 : ubpTrinary[2] = 0 : ubpTrinary[3] = 0 : ubpTrinary[4] = 0 : ubpTrinary[5] = 0 : ubpTrinary[6] = 0 : ubpTrinary[7] = 0

    ubpTrinary[8] = 0 : ubpTrinary[9] = 0 : ubpTrinary[10] = 0 : ubpTrinary[11] = 0 : ubpTrinary[12] = 0 : ubpTrinary[13] = 0 : ubpTrinary[14] = 0 : ubpTrinary[15] = 0

    ubpTrinary[16] = 0 : ubpTrinary[17] = 0 : ubpTrinary[18] = 0 : ubpTrinary[19] = 0 : ubpTrinary[20] = 0 : ubpTrinary[21] = 0 : ubpTrinary[22] = 0 : ubpTrinary[23] = 0

    If lNumeric <> 0 Then
        For i As LongInt = 23 To 0 Step -1
            ubpTrinary[i] = lNumeric Mod 3

            lNumeric \= 3

        Next i

    End If
End Sub

/'
 0 0 0
 0 1 1
 0 1 2
'/

Sub TrinaryAnd(W As UByte Pointer,_
               X As UByte Pointer,_
               Y As UByte Pointer)
    For i As LongInt = 0 To 23
        If X[i] = 0 AndAlso Y[i] = 0 Then
            W[i] = 0

        ElseIf X[i] = 0 AndAlso Y[i] = 1 Then
            W[i] = 0

        ElseIf X[i] = 0 AndAlso Y[i] = 2 Then
            W[i] = 0

        ElseIf X[i] = 1 AndAlso Y[i] = 0 Then
            W[i] = 0

        ElseIf X[i] = 1 AndAlso Y[i] = 1 Then
            W[i] = 1

        ElseIf X[i] = 1 AndAlso Y[i] = 2 Then
            W[i] = 1

        ElseIf X[i] = 2 AndAlso Y[i] = 0 Then
            W[i] = 0

        ElseIf X[i] = 2 AndAlso Y[i] = 1 Then
            W[i] = 1

        ElseIf X[i] = 2 AndAlso Y[i] = 2 Then
            W[i] = 2

        End If

    Next i
End Sub

/'
 0 1 2
 1 1 2
 2 2 2
'/

Sub TrinaryOr(W As UByte Pointer,_
              X As UByte Pointer,_
              Y As UByte Pointer)
    For j As LongInt = 0 To 23
        If X[j] = 0 AndAlso Y[j] = 0 Then
            W[j] = 0

        ElseIf X[j] = 0 AndAlso Y[j] = 1 Then
            W[j] = 1

        ElseIf X[j] = 0 AndAlso Y[j] = 2 Then
            W[j] = 2

        ElseIf X[j] = 1 AndAlso Y[j] = 0 Then
            W[j] = 1

        ElseIf X[j] = 1 AndAlso Y[j] = 1 Then
            W[j] = 1

        ElseIf X[j] = 1 AndAlso Y[j] = 2 Then
            W[j] = 2

        ElseIf X[j] = 2 AndAlso Y[j] = 0 Then
            W[j] = 2

        ElseIf X[j] = 2 AndAlso Y[j] = 1 Then
            W[j] = 2

        ElseIf X[j] = 2 AndAlso Y[j] = 2 Then
            W[j] = 2

        End If

    Next j
End Sub

/'
 0 0 2
 1 1 1
 2 2 0
'/

Sub TrinaryXOr0(W As UByte Pointer,_
                X As UByte Pointer,_
                Y As UByte Pointer)
    For k As LongInt = 0 To 23
        If X[k] = 0 AndAlso Y[k] = 0 Then
            W[k] = 0

        ElseIf X[k] = 0 AndAlso Y[k] = 1 Then
            W[k] = 0

        ElseIf X[k] = 0 AndAlso Y[k] = 2 Then
            W[k] = 2

        ElseIf X[k] = 1 AndAlso Y[k] = 0 Then
            W[k] = 1

        ElseIf X[k] = 1 AndAlso Y[k] = 1 Then
            W[k] = 1

        ElseIf X[k] = 1 AndAlso Y[k] = 2 Then
            W[k] = 1

        ElseIf X[k] = 2 AndAlso Y[k] = 0 Then
            W[k] = 2

        ElseIf X[k] = 2 AndAlso Y[k] = 1 Then
            W[k] = 2

        ElseIf X[k] = 2 AndAlso Y[k] = 2 Then
            W[k] = 0

        End If

    Next k
End Sub

/'
 0 2 2
 1 1 1
 2 0 0
'/

Sub TrinaryXOr2(W As UByte Pointer,_
                X As UByte Pointer,_
                Y As UByte Pointer)
    For l As LongInt = 0 To 23
        If X[l] = 0 AndAlso Y[l] = 0 Then
            W[l] = 0

        ElseIf X[l] = 0 AndAlso Y[l] = 1 Then
            W[l] = 2

        ElseIf X[l] = 0 AndAlso Y[l] = 2 Then
            W[l] = 2

        ElseIf X[l] = 1 AndAlso Y[l] = 0 Then
            W[l] = 1

        ElseIf X[l] = 1 AndAlso Y[l] = 1 Then
            W[l] = 1

        ElseIf X[l] = 1 AndAlso Y[l] = 2 Then
            W[l] = 1

        ElseIf X[l] = 2 AndAlso Y[l] = 0 Then
            W[l] = 2

        ElseIf X[l] = 2 AndAlso Y[l] = 1 Then
            W[l] = 0

        ElseIf X[l] = 2 AndAlso Y[l] = 2 Then
            W[l] = 0

        End If

    Next l
End Sub

/'
 2 0 0
 1 1 1
 0 2 2
'/

Sub TrinaryXAnd0(W As UByte Pointer,_
                 X As UByte Pointer,_
                 Y As UByte Pointer)
    For i As LongInt = 0 To 23
        If X[i] = 0 AndAlso Y[i] = 0 Then
            W[i] = 2

        ElseIf X[i] = 0 AndAlso Y[i] = 1 Then
            W[i] = 0

        ElseIf X[i] = 0 AndAlso Y[i] = 2 Then
            W[i] = 0

        ElseIf X[i] = 1 AndAlso Y[i] = 0 Then
            W[i] = 1

        ElseIf X[i] = 1 AndAlso Y[i] = 1 Then
            W[i] = 1

        ElseIf X[i] = 1 AndAlso Y[i] = 2 Then
            W[i] = 1

        ElseIf X[i] = 2 AndAlso Y[i] = 0 Then
            W[i] = 0

        ElseIf X[i] = 2 AndAlso Y[i] = 1 Then
            W[i] = 2

        ElseIf X[i] = 2 AndAlso Y[i] = 2 Then
            W[i] = 2

        End If

    Next i
End Sub

/'
 2 2 0
 1 1 1
 0 0 2
'/

Sub TrinaryXAnd2(W As UByte Pointer,_
                 X As UByte Pointer,_
                 Y As UByte Pointer)
    For j As LongInt = 0 To 23
        If X[j] = 0 AndAlso Y[j] = 0 Then
            W[j] = 2

        ElseIf X[j] = 0 AndAlso Y[j] = 1 Then
            W[j] = 2

        ElseIf X[j] = 0 AndAlso Y[j] = 2 Then
            W[j] = 0

        ElseIf X[j] = 1 AndAlso Y[j] = 0 Then
            W[j] = 1

        ElseIf X[j] = 1 AndAlso Y[j] = 1 Then
            W[j] = 1

        ElseIf X[j] = 1 AndAlso Y[j] = 2 Then
            W[j] = 1

        ElseIf X[j] = 2 AndAlso Y[j] = 0 Then
            W[j] = 0

        ElseIf X[j] = 2 AndAlso Y[j] = 1 Then
            W[j] = 0

        ElseIf X[j] = 2 AndAlso Y[j] = 2 Then
            W[j] = 2

        End If

    Next j
End Sub

/'
 0 1 2
 1 2 0
 2 0 1
'/

Sub TrinaryAdd(W As UByte Pointer,_
               X As UByte Pointer,_
               Y As UByte Pointer)
    For k As LongInt = 0 To 23
        If X[k] = 0 AndAlso Y[k] = 0 Then
            W[k] = 0

        ElseIf X[k] = 0 AndAlso Y[k] = 1 Then
            W[k] = 1

        ElseIf X[k] = 0 AndAlso Y[k] = 2 Then
            W[k] = 2

        ElseIf X[k] = 1 AndAlso Y[k] = 0 Then
            W[k] = 1

        ElseIf X[k] = 1 AndAlso Y[k] = 1 Then
            W[k] = 2

        ElseIf X[k] = 1 AndAlso Y[k] = 2 Then
            W[k] = 0

        ElseIf X[k] = 2 AndAlso Y[k] = 0 Then
            W[k] = 2

        ElseIf X[k] = 2 AndAlso Y[k] = 1 Then
            W[k] = 0

        ElseIf X[k] = 2 AndAlso Y[k] = 2 Then
            W[k] = 1

        End If

    Next k
End Sub

/'
 0 2 1
 1 0 2
 2 1 0
'/

Sub TrinarySubtract(W As UByte Pointer,_
                    X As UByte Pointer,_
                    Y As UByte Pointer)
    For l As LongInt = 0 To 23
        If X[l] = 0 AndAlso Y[l] = 0 Then
            W[l] = 0

        ElseIf X[l] = 0 AndAlso Y[l] = 1 Then
            W[l] = 2

        ElseIf X[l] = 0 AndAlso Y[l] = 2 Then
            W[l] = 1

        ElseIf X[l] = 1 AndAlso Y[l] = 0 Then
            W[l] = 1

        ElseIf X[l] = 1 AndAlso Y[l] = 1 Then
            W[l] = 0

        ElseIf X[l] = 1 AndAlso Y[l] = 2 Then
            W[l] = 2

        ElseIf X[l] = 2 AndAlso Y[l] = 0 Then
            W[l] = 2

        ElseIf X[l] = 2 AndAlso Y[l] = 1 Then
            W[l] = 1

        ElseIf X[l] = 2 AndAlso Y[l] = 2 Then
            W[l] = 0

        End If

    Next l
End Sub

/'
 0 0 0
 0 1 2
 0 2 1
'/

Sub TrinaryMultiply(W As UByte Pointer,_
                    X As UByte Pointer,_
                    Y As UByte Pointer)
    For i As LongInt = 0 To 23
        If X[i] = 0 AndAlso Y[i] = 0 Then
            W[i] = 0

        ElseIf X[i] = 0 AndAlso Y[i] = 1 Then
            W[i] = 0

        ElseIf X[i] = 0 AndAlso Y[i] = 2 Then
            W[i] = 0

        ElseIf X[i] = 1 AndAlso Y[i] = 0 Then
            W[i] = 0

        ElseIf X[i] = 1 AndAlso Y[i] = 1 Then
            W[i] = 1

        ElseIf X[i] = 1 AndAlso Y[i] = 2 Then
            W[i] = 2

        ElseIf X[i] = 2 AndAlso Y[i] = 0 Then
            W[i] = 0

        ElseIf X[i] = 2 AndAlso Y[i] = 1 Then
            W[i] = 2

        ElseIf X[i] = 2 AndAlso Y[i] = 2 Then
            W[i] = 1

        End If

    Next i
End Sub

/'
 0 0 0
 0 1 0
 0 2 1
'/

Sub TrinaryDivide(W As UByte Pointer,_
                  X As UByte Pointer,_
                  Y As UByte Pointer)
    For j As LongInt = 0 To 23
        If X[j] = 0 AndAlso Y[j] = 0 Then
            W[j] = 0

        ElseIf X[j] = 0 AndAlso Y[j] = 1 Then
            W[j] = 0

        ElseIf X[j] = 0 AndAlso Y[j] = 2 Then
            W[j] = 0

        ElseIf X[j] = 1 AndAlso Y[j] = 0 Then
            W[j] = 0

        ElseIf X[j] = 1 AndAlso Y[j] = 1 Then
            W[j] = 1

        ElseIf X[j] = 1 AndAlso Y[j] = 2 Then
            W[j] = 0

        ElseIf X[j] = 2 AndAlso Y[j] = 0 Then
            W[j] = 0

        ElseIf X[j] = 2 AndAlso Y[j] = 1 Then
            W[j] = 2

        ElseIf X[j] = 2 AndAlso Y[j] = 2 Then
            W[j] = 1

        End If

    Next j
End Sub

Sub RotateShiftLeft7(ubpRSHL As UByte Pointer)
    Dim As UByte ubaTemp(6) => {ubpRSHL[0], ubpRSHL[1], ubpRSHL[2], ubpRSHL[3], ubpRSHL[4], ubpRSHL[5], ubpRSHL[6]}

    ubpRSHL[0] = ubpRSHL[7]

    ubpRSHL[1] = ubpRSHL[8]

    ubpRSHL[2] = ubpRSHL[9]

    ubpRSHL[3] = ubpRSHL[10]

    ubpRSHL[4] = ubpRSHL[11]

    ubpRSHL[5] = ubpRSHL[12]

    ubpRSHL[6] = ubpRSHL[13]

    ubpRSHL[7] = ubpRSHL[14]

    ubpRSHL[8] = ubpRSHL[15]

    ubpRSHL[9] = ubpRSHL[16]

    ubpRSHL[10] = ubpRSHL[17]

    ubpRSHL[11] = ubpRSHL[18]

    ubpRSHL[12] = ubpRSHL[19]

    ubpRSHL[13] = ubpRSHL[20]

    ubpRSHL[14] = ubpRSHL[21]

    ubpRSHL[15] = ubpRSHL[22]

    ubpRSHL[16] = ubpRSHL[23]

    ubpRSHL[17] = ubaTemp(0)

    ubpRSHL[18] = ubaTemp(1)

    ubpRSHL[19] = ubaTemp(2)

    ubpRSHL[20] = ubaTemp(3)

    ubpRSHL[21] = ubaTemp(4)

    ubpRSHL[22] = ubaTemp(5)

    ubpRSHL[23] = ubaTemp(6)
End Sub


Sub Add(W As UByte Pointer,_
        Z As UByte Pointer)
    Dim As UByte ubCarry = 0

    For i As LongInt = 0 To 23
        W[i] += Z[i] + ubCarry

        If W[i] > 2 Then
            W[i] -= 3

            If ubCarry = 0 Then
                ubCarry = 1

            End If

        Else
            ubCarry = 0

        End If

    Next i
End Sub

Sub Assign(X As UByte Pointer,_
           Y As UByte Pointer)
    For j As LongInt = 0 To 23
        X[j] = Y[j]

    Next j
End Sub

Sub RotateShiftLeft19(ubpRSHL1 As UByte Pointer,_
                      ubpRSHL2 As UByte Pointer)
    ubpRSHL1[23] = ubpRSHL2[18]

    ubpRSHL1[22] = ubpRSHL2[17]

    ubpRSHL1[21] = ubpRSHL2[16]

    ubpRSHL1[20] = ubpRSHL2[15]

    ubpRSHL1[19] = ubpRSHL2[14]

    ubpRSHL1[18] = ubpRSHL2[13]

    ubpRSHL1[17] = ubpRSHL2[12]

    ubpRSHL1[16] = ubpRSHL2[11]

    ubpRSHL1[15] = ubpRSHL2[10]

    ubpRSHL1[14] = ubpRSHL2[9]

    ubpRSHL1[13] = ubpRSHL2[8]

    ubpRSHL1[12] = ubpRSHL2[7]

    ubpRSHL1[11] = ubpRSHL2[6]

    ubpRSHL1[10] = ubpRSHL2[5]

    ubpRSHL1[9] = ubpRSHL2[4]

    ubpRSHL1[8] = ubpRSHL2[3]

    ubpRSHL1[7] = ubpRSHL2[2]

    ubpRSHL1[6] = ubpRSHL2[1]

    ubpRSHL1[5] = ubpRSHL2[0]

    ubpRSHL1[4] = ubpRSHL2[23]

    ubpRSHL1[3] = ubpRSHL2[22]

    ubpRSHL1[2] = ubpRSHL2[21]

    ubpRSHL1[1] = ubpRSHL2[20]

    ubpRSHL1[0] = ubpRSHL2[19]
End Sub

Sub SHA3Hash(SHA3 As SHA3Context)
    Dim As UByte A(23), B(23), C(23), D(23), E(23), F(23), G(23), H(23), II(23), P(23), Q(23), T(23), W(79, 23)

    Dim As LongInt i

    Assign(@A(0), @SHA3.ubaMessageDigest(0, 0))

    Assign(@B(0), @SHA3.ubaMessageDigest(1, 0))

    Assign(@C(0), @SHA3.ubaMessageDigest(2, 0))

    Assign(@D(0), @SHA3.ubaMessageDigest(3, 0))

    Assign(@E(0), @SHA3.ubaMessageDigest(4, 0))

    Trinary24(@F(0), &h5A827999)

    Trinary24(@G(0), &h6ED9EBA1)

    Trinary24(@H(0), &h8F1BBCDC)

    Trinary24(@II(0), &hCA62C1D6)

    i = 0

    For j As LongInt = 0 To 15
        W(j, 23) = SHA3.ubaDataBlock(i, 5)

        W(j, 22) = SHA3.ubaDataBlock(i, 4)

        W(j, 21) = SHA3.ubaDataBlock(i, 3)

        W(j, 20) = SHA3.ubaDataBlock(i, 2)

        W(j, 19) = SHA3.ubaDataBlock(i, 1)

        W(j, 18) = SHA3.ubaDataBlock(i, 0)

        W(j, 17) = SHA3.ubaDataBlock(i + 1, 5)

        W(j, 16) = SHA3.ubaDataBlock(i + 1, 4)

        W(j, 15) = SHA3.ubaDataBlock(i + 1, 3)

        W(j, 14) = SHA3.ubaDataBlock(i + 1, 2)

        W(j, 13) = SHA3.ubaDataBlock(i + 1, 1)

        W(j, 12) = SHA3.ubaDataBlock(i + 1, 0)

        W(j, 11) = SHA3.ubaDataBlock(i + 2, 5)

        W(j, 10) = SHA3.ubaDataBlock(i + 2, 4)

        W(j, 9) = SHA3.ubaDataBlock(i + 2, 3)

        W(j, 8) = SHA3.ubaDataBlock(i + 2, 2)

        W(j, 7) = SHA3.ubaDataBlock(i + 2, 1)

        W(j, 6) = SHA3.ubaDataBlock(i + 2, 0)

        W(j, 5) = SHA3.ubaDataBlock(i + 3, 5)

        W(j, 4) = SHA3.ubaDataBlock(i + 3, 4)

        W(j, 3) = SHA3.ubaDataBlock(i + 3, 3)

        W(j, 2) = SHA3.ubaDataBlock(i + 3, 2)

        W(j, 1) = SHA3.ubaDataBlock(i + 3, 1)

        W(j, 0) = SHA3.ubaDataBlock(i + 3, 0)

        i += 4

    Next j

    For k As LongInt = 16 To 79
        TrinaryXOr0(@T(0), @W(k - 3, 0), @W(k - 5, 0))

        TrinaryXAnd2(@T(0), @T(0), @W(k - 7, 0))

        TrinaryXOr2(@T(0), @T(0), @W(k - 11, 0))

        TrinaryXAnd0(@T(0), @T(0), @W(k - 13, 0))

        W(k, 23) = T(2)

        W(k, 22) = T(1)

        W(k, 21) = T(0)

        W(k, 20) = T(23)

        W(k, 19) = T(22)

        W(k, 18) = T(21)

        W(k, 17) = T(20)

        W(k, 16) = T(19)

        W(k, 15) = T(18)

        W(k, 14) = T(17)

        W(k, 13) = T(16)

        W(k, 12) = T(15)

        W(k, 11) = T(14)

        W(k, 10) = T(13)

        W(k, 9) = T(12)

        W(k, 8) = T(11)

        W(k, 7) = T(10)

        W(k, 6) = T(9)

        W(k, 5) = T(8)

        W(k, 4) = T(7)

        W(k, 3) = T(6)

        W(k, 2) = T(5)

        W(k, 1) = T(4)

        W(k, 0) = T(3)

    Next k

    For i As LongInt = 0 To 19
        RotateShiftLeft7(@A(0))

        TrinaryAdd(@P(0), @B(0), @C(0))

        TrinarySubtract(@Q(0), @C(0), @D(0))

        TrinaryAnd(@P(0), @P(0), @Q(0))

        TrinaryDivide(@Q(0), @D(0), @B(0))

        TrinaryOr(@T(0), @P(0), @Q(0))

        Add(@T(0), @A(0))

        Add(@T(0), @E(0))

        Add(@T(0), @W(i, 0))

        Add(@T(0), @F(0))

        Assign(@E(0), @D(0))

        Assign(@D(0), @C(0))

        RotateShiftLeft19(@C(0), @B(0))

        Assign(@B(0), @A(0))

        Assign(@A(0), @T(0))

    Next i

    For j As LongInt = 20 To 39
        RotateShiftLeft7(@A(0))

        TrinaryDivide(@P(0), @C(0), @D(0))

        TrinaryMultiply(@Q(0), @D(0), @B(0))

        TrinaryXAnd0(@P(0), @P(0), @Q(0))

        TrinarySubtract(@Q(0), @B(0), @C(0))

        TrinaryXOr2(@T(0), @P(0), @Q(0))

        Add(@T(0), @A(0))

        Add(@T(0), @E(0))

        Add(@T(0), @W(j, 0))

        Add(@T(0), @G(0))

        Assign(@E(0), @D(0))

        Assign(@D(0), @C(0))

        RotateShiftLeft19(@C(0), @B(0))

        Assign(@B(0), @A(0))

        Assign(@A(0), @T(0))

    Next j

    For k As LongInt = 40 To 59
        RotateShiftLeft7(@A(0))

        TrinaryAdd(@P(0), @D(0), @B(0))

        TrinaryDivide(@Q(0), @B(0), @C(0))

        TrinaryOr(@P(0), @P(0), @Q(0))

        TrinaryMultiply(@Q(0), @C(0), @D(0))

        TrinaryAnd(@T(0), @P(0), @Q(0))

        Add(@T(0), @A(0))

        Add(@T(0), @E(0))

        Add(@T(0), @W(k, 0))

        Add(@T(0), @H(0))

        Assign(@E(0), @D(0))

        Assign(@D(0), @C(0))

        RotateShiftLeft19(@C(0), @B(0))

        Assign(@B(0), @A(0))

        Assign(@A(0), @T(0))

    Next k

    For l As LongInt = 60 To 79
        RotateShiftLeft7(@A(0))

        TrinaryMultiply(@P(0), @B(0), @C(0))

        TrinaryAdd(@Q(0), @C(0), @D(0))

        TrinaryXAnd2(@P(0), @P(0), @Q(0))

        TrinarySubtract(@Q(0), @D(0), @B(0))

        TrinaryXOr0(@T(0), @P(0), @Q(0))

        Add(@T(0), @A(0))

        Add(@T(0), @E(0))

        Add(@T(0), @W(l, 0))

        Add(@T(0), @II(0))

        Assign(@E(0), @D(0))

        Assign(@D(0), @C(0))

        RotateShiftLeft19(@C(0), @B(0))

        Assign(@B(0), @A(0))

        Assign(@A(0), @T(0))

    Next l

    Assign(@SHA3.ubaMessageDigest(0, 0), @A(0))

    Assign(@SHA3.ubaMessageDigest(1, 0), @B(0))

    Assign(@SHA3.ubaMessageDigest(2, 0), @C(0))

    Assign(@SHA3.ubaMessageDigest(3, 0), @D(0))

    Assign(@SHA3.ubaMessageDigest(4, 0), @E(0))
End Sub

Sub Main()
    Dim As UByte ubaPadding(63) => {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,_
        101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,_
        211, 223, 227, 229, 233, 239, 241, 251, 15, 25, 35, 55, 65, 85, 95, 115, 145, 155}

    Dim As UByte ubCLAA = 1

    Dim As LongInt lFileSize, lBytesLeft, k

    Dim As UByte Pointer ubpData

    Dim As SHA3Context SHA3

    Do
        Dim As String strCLA = Command(ubCLAA)

        If Len(strCLA) = 0 Then
            Exit Do

        End If

        ubCLAA += 1

    Loop

    If ubCLAA <> 2 Then
        Usage()

    Else
        lFileSize = FileLen(Command(1))

        If lFileSize = 0 Then
            Print "There is no data in file [" & Command(1) & "], 0 byte."

            End -1

        End If

        lBytesLeft = lFileSize And 63

        If lBytesLeft = 0 Then
            lBytesLeft = lFileSize + 64

        ElseIf lBytesLeft < 54 Then
            lBytesLeft = lFileSize - lBytesLeft + 64

        ElseIf lBytesLeft > 53 Then
            lBytesLeft = lFileSize - lBytesLeft + 128

        End If

        ubpData = New UByte[lBytesLeft]

        Open Command(1) For Binary Access Read As #3

        Get #3, , *ubpData, lFileSize

        Close #3

        For i As LongInt = 0 To 4
            ubpData[i + lFileSize] = lFileSize Shr 8 * i

        Next i

        k = 0

        For j As LongInt = lFileSize + 5 To lBytesLeft - 6
            ubpData[j] = ubaPadding(k)

            k += 1

        Next j

        For l As LongInt = 4 To 0 Step -1
            ubpData[lBytesLeft - l - 1] = lFileSize Shr 8 * l

        Next l

        Trinary24(@SHA3.ubaMessageDigest(0, 0), &h67452301)

        Trinary24(@SHA3.ubaMessageDigest(1, 0), &hEFCDAB89)

        Trinary24(@SHA3.ubaMessageDigest(2, 0), &h98BADCFE)

        Trinary24(@SHA3.ubaMessageDigest(3, 0), &h10325476)

        Trinary24(@SHA3.ubaMessageDigest(4, 0), &hC3D2E1F0)

        For i As LongInt = 0 To lBytesLeft - 1 Step 64
            For j As LongInt = 0 To 63
                Trinary6(@SHA3.ubaDataBlock(j, 0), ubpData[i + j])

            Next j

            SHA3Hash(SHA3)

        Next i

        For k = 0 To 23
            Print SHA3.ubaMessageDigest(0, k); SHA3.ubaMessageDigest(1, k); SHA3.ubaMessageDigest(2, k); SHA3.ubaMessageDigest(3, k); SHA3.ubaMessageDigest(4, k);

        Next k

        Print

        Delete ubpData

    End If
End Sub

Main()