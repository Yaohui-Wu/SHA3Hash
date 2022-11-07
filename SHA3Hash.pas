(*************************************************************
* 作者：伍耀晖               Author: Geek.Zhiyuan            *
* 开源日期：2022年7月25日    Open Source Date: 2022-7-25     *
* 国家城市：中国广州         City, Country: GuangZhou, China *
*************************************************************)
(* Compiled by free pascal. free pascal Website: www.freepascal.org *)

Program SHA3Hash;

Type
    Trinary6A = Array[0..5] Of Byte;

    Trinary24A = Array[0..23] Of Byte;

    SHA3Context = Record
        baDataBlock : Array[0..63, 0..5] Of Byte;

        baMessageDigest : Array[0..5, 0..23] Of Byte;
    End;

Const
    baPadding : Array[0..63] Of Byte = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
        101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
        211, 223, 227, 229, 233, 239, 241, 251, 15, 25, 35, 55, 65, 85, 95, 115, 145, 155);

Procedure Usage();
Begin
    WriteLn('Usage: SHA3Hash YouWantToHash.File');
End;

Procedure Trinary6(Var baTrinary : Trinary6A;
                   bNumeric : Byte);
Var
    i : int64;

Begin
    baTrinary[0] := 0;

    baTrinary[1] := 0;

    baTrinary[2] := 0;

    baTrinary[3] := 0;

    baTrinary[4] := 0;

    baTrinary[5] := 0;

    If bNumeric <> 0 Then
    Begin
        For i := 5 DownTo 0 Do
        Begin
            baTrinary[i] := bNumeric Mod 3;

            bNumeric := bNumeric Div 3;
        End;
    End;
End;

Procedure Trinary24(Var baTrinary : Trinary24A;
                    lNumeric : Int64);
Var
    j : int64;

Begin
    baTrinary[0] := 0;

    baTrinary[1] := 0;

    baTrinary[2] := 0;

    baTrinary[3] := 0;

    baTrinary[4] := 0;

    baTrinary[5] := 0;

    baTrinary[6] := 0;

    baTrinary[7] := 0;

    baTrinary[8] := 0;

    baTrinary[9] := 0;

    baTrinary[10] := 0;

    baTrinary[11] := 0;

    baTrinary[12] := 0;

    baTrinary[13] := 0;

    baTrinary[14] := 0;

    baTrinary[15] := 0;

    baTrinary[16] := 0;

    baTrinary[17] := 0;

    baTrinary[18] := 0;

    baTrinary[19] := 0;

    baTrinary[20] := 0;

    baTrinary[21] := 0;

    baTrinary[22] := 0;

    baTrinary[23] := 0;

    If lNumeric <> 0 Then
    Begin
        For j := 23 DownTo 0 Do
        Begin
            baTrinary[j] := lNumeric Mod 3;

            lNumeric := lNumeric Div 3;
        End;
    End;
End;

(*
 0 0 0
 0 1 1
 0 1 2
*)

Procedure TrinaryAnd(Var W : Trinary24A;
                     Var X : Trinary24A;
                     Var Y : Trinary24A);
Var
    i : Int64;

Begin
    For i := 0 To 23 Do
    Begin
        If (X[i] = 0) And (Y[i] = 0) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 0) And (Y[i] = 1) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 0) And (Y[i] = 2) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 1) And (Y[i] = 0) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 1) And (Y[i] = 1) Then
        Begin
            W[i] := 1;
        End
        Else If (X[i] = 1) And (Y[i] = 2) Then
        Begin
            W[i] := 1;
        End
        Else If (X[i] = 2) And (Y[i] = 0) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 2) And (Y[i] = 1) Then
        Begin
            W[i] := 1;
        End
        Else If (X[i] = 2) And (Y[i] = 2) Then
        Begin
            W[i] := 2;
        End;
    End;
End;

(*
 0 1 2
 1 1 2
 2 2 2
*)

Procedure TrinaryOr(Var W : Trinary24A;
                    Var X : Trinary24A;
                    Var Y : Trinary24A);
Var
    j : Int64;

Begin
    For j := 0 To 23 Do
    Begin
        If (X[j] = 0) And (Y[j] = 0) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 0) And (Y[j] = 1) Then
        Begin
            W[j] := 1;
        End
        Else If (X[j] = 0) And (Y[j] = 2) Then
        Begin
            W[j] := 2;
        End
        Else If (X[j] = 1) And (Y[j] = 0) Then
        Begin
            W[j] := 1;
        End
        Else If (X[j] = 1) And (Y[j] = 1) Then
        Begin
            W[j] := 1;
        End
        Else If (X[j] = 1) And (Y[j] = 2) Then
        Begin
            W[j] := 2;
        End
        Else If (X[j] = 2) And (Y[j] = 0) Then
        Begin
            W[j] := 2;
        End
        Else If (X[j] = 2) And (Y[j] = 1) Then
        Begin
            W[j] := 2;
        End
        Else If (X[j] = 2) And (Y[j] = 2) Then
        Begin
            W[j] := 2;
        End;
    End;
End;

(*
 0 0 2
 1 1 1
 2 2 0
*)

Procedure TrinaryXOr0(Var W : Trinary24A;
                      Var X : Trinary24A;
                      Var Y : Trinary24A);
Var
    k : Int64;

Begin
    For k := 0 To 23 Do
    Begin
        If (X[k] = 0) And (Y[k] = 0) Then
        Begin
            W[k] := 0;
        End
        Else If (X[k] = 0) And (Y[k] = 1) Then
        Begin
            W[k] := 0;
        End
        Else If (X[k] = 0) And (Y[k] = 2) Then
        Begin
            W[k] := 2;
        End
        Else If (X[k] = 1) And (Y[k] = 0) Then
        Begin
            W[k] := 1;
        End
        Else If (X[k] = 1) And (Y[k] = 1) Then
        Begin
            W[k] := 1;
        End
        Else If (X[k] = 1) And (Y[k] = 2) Then
        Begin
            W[k] := 1;
        End
        Else If (X[k] = 2) And (Y[k] = 0) Then
        Begin
            W[k] := 2;
        End
        Else If (X[k] = 2) And (Y[k] = 1) Then
        Begin
            W[k] := 2;
        End
        Else If (X[k] = 2) And (Y[k] = 2) Then
        Begin
            W[k] := 0;
        End;
    End;
End;

(*
 0 2 2
 1 1 1
 2 0 0
*)

Procedure TrinaryXOr2(Var W : Trinary24A;
                      Var X : Trinary24A;
                      Var Y : Trinary24A);
Var
    l : Int64;

Begin
    For l := 0 To 23 Do
    Begin
        If (X[l] = 0) And (Y[l] = 0) Then
        Begin
            W[l] := 0;
        End
        Else If (X[l] = 0) And (Y[l] = 1) Then
        Begin
            W[l] := 2;
        End
        Else If (X[l] = 0) And (Y[l] = 2) Then
        Begin
            W[l] := 2;
        End
        Else If (X[l] = 1) And (Y[l] = 0) Then
        Begin
            W[l] := 1;
        End
        Else If (X[l] = 1) And (Y[l] = 1) Then
        Begin
            W[l] := 1;
        End
        Else If (X[l] = 1) And (Y[l] = 2) Then
        Begin
            W[l] := 1;
        End
        Else If (X[l] = 2) And (Y[l] = 0) Then
        Begin
            W[l] := 2;
        End
        Else If (X[l] = 2) And (Y[l] = 1) Then
        Begin
            W[l] := 0;
        End
        Else If (X[l] = 2) And (Y[l] = 2) Then
        Begin
            W[l] := 0;
        End;
    End;
End;

(*
 2 0 0
 1 1 1
 0 2 2
*)

Procedure TrinaryXAnd0(Var W : Trinary24A;
                       Var X : Trinary24A;
                       Var Y : Trinary24A);
Var
    i : Int64;

Begin
    For i := 0 To 23 Do
    Begin
        If (X[i] = 0) And (Y[i] = 0) Then
        Begin
            W[i] := 2;
        End
        Else If (X[i] = 0) And (Y[i] = 1) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 0) And (Y[i] = 2) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 1) And (Y[i] = 0) Then
        Begin
            W[i] := 1;
        End
        Else If (X[i] = 1) And (Y[i] = 1) Then
        Begin
            W[i] := 1;
        End
        Else If (X[i] = 1) And (Y[i] = 2) Then
        Begin
            W[i] := 1;
        End
        Else If (X[i] = 2) And (Y[i] = 0) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 2) And (Y[i] = 1) Then
        Begin
            W[i] := 2;
        End
        Else If (X[i] = 2) And (Y[i] = 2) Then
        Begin
            W[i] := 2;
        End;
    End;
End;

(*
 2 2 0
 1 1 1
 0 0 2
*)

Procedure TrinaryXAnd2(Var W : Trinary24A;
                       Var X : Trinary24A;
                       Var Y : Trinary24A);
Var
    j : Int64;

Begin
    For j := 0 To 23 Do
    Begin
        If (X[j] = 0) And (Y[j] = 0) Then
        Begin
            W[j] := 2;
        End
        Else If (X[j] = 0) And (Y[j] = 1) Then
        Begin
            W[j] := 2;
        End
        Else If (X[j] = 0) And (Y[j] = 2) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 1) And (Y[j] = 0) Then
        Begin
            W[j] := 1;
        End
        Else If (X[j] = 1) And (Y[j] = 1) Then
        Begin
            W[j] := 1;
        End
        Else If (X[j] = 1) And (Y[j] = 2) Then
        Begin
            W[j] := 1;
        End
        Else If (X[j] = 2) And (Y[j] = 0) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 2) And (Y[j] = 1) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 2) And (Y[j] = 2) Then
        Begin
            W[j] := 2;
        End;
    End;
End;

(*
 0 1 2
 1 2 0
 2 0 1
*)

Procedure TrinaryAdd(Var W : Trinary24A;
                     Var X : Trinary24A;
                     Var Y : Trinary24A);
Var
    k : Int64;

Begin
    For k := 0 To 23 Do
    Begin
        If (X[k] = 0) And (Y[k] = 0) Then
        Begin
            W[k] := 0;
        End
        Else If (X[k] = 0) And (Y[k] = 1) Then
        Begin
            W[k] := 1;
        End
        Else If (X[k] = 0) And (Y[k] = 2) Then
        Begin
            W[k] := 2;
        End
        Else If (X[k] = 1) And (Y[k] = 0) Then
        Begin
            W[k] := 1;
        End
        Else If (X[k] = 1) And (Y[k] = 1) Then
        Begin
            W[k] := 2;
        End
        Else If (X[k] = 1) And (Y[k] = 2) Then
        Begin
            W[k] := 0;
        End
        Else If (X[k] = 2) And (Y[k] = 0) Then
        Begin
            W[k] := 2;
        End
        Else If (X[k] = 2) And (Y[k] = 1) Then
        Begin
            W[k] := 0;
        End
        Else If (X[k] = 2) And (Y[k] = 2) Then
        Begin
            W[k] := 1;
        End;
    End;
End;

(*
 0 2 1
 1 0 2
 2 1 0
*)

Procedure TrinarySubtract(Var W : Trinary24A;
                          Var X : Trinary24A;
                          Var Y : Trinary24A);
Var
    l : Int64;

Begin
    For l := 0 To 23 Do
    Begin
        If (X[l] = 0) And (Y[l] = 0) Then
        Begin
            W[l] := 0;
        End
        Else If (X[l] = 0) And (Y[l] = 1) Then
        Begin
            W[l] := 2;
        End
        Else If (X[l] = 0) And (Y[l] = 2) Then
        Begin
            W[l] := 1;
        End
        Else If (X[l] = 1) And (Y[l] = 0) Then
        Begin
            W[l] := 1;
        End
        Else If (X[l] = 1) And (Y[l] = 1) Then
        Begin
            W[l] := 0;
        End
        Else If (X[l] = 1) And (Y[l] = 2) Then
        Begin
            W[l] := 2;
        End
        Else If (X[l] = 2) And (Y[l] = 0) Then
        Begin
            W[l] := 2;
        End
        Else If (X[l] = 2) And (Y[l] = 1) Then
        Begin
            W[l] := 1;
        End
        Else If (X[l] = 2) And (Y[l] = 2) Then
        Begin
            W[l] := 0;
        End;
    End;
End;

(*
 0 0 0
 0 1 2
 0 2 1
*)

Procedure TrinaryMultiply(Var W : Trinary24A;
                          Var X : Trinary24A;
                          Var Y : Trinary24A);
Var
    i : Int64;

Begin
    For i := 0 To 23 Do
    Begin
        If (X[i] = 0) And (Y[i] = 0) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 0) And (Y[i] = 1) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 0) And (Y[i] = 2) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 1) And (Y[i] = 0) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 1) And (Y[i] = 1) Then
        Begin
            W[i] := 1;
        End
        Else If (X[i] = 1) And (Y[i] = 2) Then
        Begin
            W[i] := 2;
        End
        Else If (X[i] = 2) And (Y[i] = 0) Then
        Begin
            W[i] := 0;
        End
        Else If (X[i] = 2) And (Y[i] = 1) Then
        Begin
            W[i] := 2;
        End
        Else If (X[i] = 2) And (Y[i] = 2) Then
        Begin
            W[i] := 1;
        End;
    End;
End;

(*
 0 0 0
 0 1 0
 0 2 1
*)

Procedure TrinaryDivide(Var W : Trinary24A;
                        Var X : Trinary24A;
                        Var Y : Trinary24A);
Var
    j : Int64;

Begin
    For j := 0 To 23 Do
    Begin
        If (X[j] = 0) And (Y[j] = 0) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 0) And (Y[j] = 1) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 0) And (Y[j] = 2) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 1) And (Y[j] = 0) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 1) And (Y[j] = 1) Then
        Begin
            W[j] := 1;
        End
        Else If (X[j] = 1) And (Y[j] = 2) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 2) And (Y[j] = 0) Then
        Begin
            W[j] := 0;
        End
        Else If (X[j] = 2) And (Y[j] = 1) Then
        Begin
            W[j] := 2;
        End
        Else If (X[j] = 2) And (Y[j] = 2) Then
        Begin
            W[j] := 1;
        End;
    End;
End;

Procedure RotateShiftLeft7(Var baRSHL : Trinary24A);
Var
    baTemp : Array[0..6] Of Byte;
    
Begin
    baTemp[0] := baRSHL[0];

    baTemp[1] := baRSHL[1];

    baTemp[2] := baRSHL[2];

    baTemp[3] := baRSHL[3];

    baTemp[4] := baRSHL[4];

    baTemp[5] := baRSHL[5];

    baTemp[6] := baRSHL[6];

    baRSHL[0] := baRSHL[7];

    baRSHL[1] := baRSHL[8];

    baRSHL[2] := baRSHL[9];

    baRSHL[3] := baRSHL[10];

    baRSHL[4] := baRSHL[11];

    baRSHL[5] := baRSHL[12];

    baRSHL[6] := baRSHL[13];

    baRSHL[7] := baRSHL[14];

    baRSHL[8] := baRSHL[15];

    baRSHL[9] := baRSHL[16];

    baRSHL[10] := baRSHL[17];

    baRSHL[11] := baRSHL[18];

    baRSHL[12] := baRSHL[19];

    baRSHL[13] := baRSHL[20];

    baRSHL[14] := baRSHL[21];

    baRSHL[15] := baRSHL[22];

    baRSHL[16] := baRSHL[23];

    baRSHL[17] := baTemp[0];

    baRSHL[18] := baTemp[1];

    baRSHL[19] := baTemp[2];

    baRSHL[20] := baTemp[3];

    baRSHL[21] := baTemp[4];

    baRSHL[22] := baTemp[5];

    baRSHL[23] := baTemp[6];
End;

Procedure Add(Var W : Trinary24A;
              Var Z : Trinary24A);
Var
    i : Int64;

    bCarry : Byte;

Begin
    bCarry := 0;

    For i := 0 To 23 Do
    Begin
        W[i] := W[i] + Z[i] + bCarry;

        If W[i] > 2 Then
        Begin
            W[i] := W[i] - 3;

            If bCarry = 0 Then
            Begin
                bCarry := 1;
            End;
        End
        Else
        Begin
            bCarry := 0;
        End;
    End;
End;

Procedure Assignment(Var X : Trinary24A;
                     Var Y : Trinary24A);
Var
    j : Int64;

Begin
    For j := 0 To 23 Do
    Begin
        X[j] := Y[j];
    End;
End;

Procedure RotateShiftLeft19(Var baRSHL1 : Trinary24A;
                            Var baRSHL2 : Trinary24A);
Begin
    baRSHL1[23] := baRSHL2[18];

    baRSHL1[22] := baRSHL2[17];

    baRSHL1[21] := baRSHL2[16];

    baRSHL1[20] := baRSHL2[15];

    baRSHL1[19] := baRSHL2[14];

    baRSHL1[18] := baRSHL2[13];

    baRSHL1[17] := baRSHL2[12];

    baRSHL1[16] := baRSHL2[11];

    baRSHL1[15] := baRSHL2[10];

    baRSHL1[14] := baRSHL2[9];

    baRSHL1[13] := baRSHL2[8];

    baRSHL1[12] := baRSHL2[7];

    baRSHL1[11] := baRSHL2[6];

    baRSHL1[10] := baRSHL2[5];

    baRSHL1[9] := baRSHL2[4];

    baRSHL1[8] := baRSHL2[3];

    baRSHL1[7] := baRSHL2[2];

    baRSHL1[6] := baRSHL2[1];

    baRSHL1[5] := baRSHL2[0];

    baRSHL1[4] := baRSHL2[23];

    baRSHL1[3] := baRSHL2[22];

    baRSHL1[2] := baRSHL2[21];

    baRSHL1[1] := baRSHL2[20];

    baRSHL1[0] := baRSHL2[19];
End;

Procedure SHA3Hash(Var SHA3 : SHA3Context);
Var
    A, B, C, D, E, F, G, H, II, P, Q, T : Trinary24A;

    W : Array[0..79, 0..23] Of Byte;

    i, j, k, l : Int64;

Begin
    Assignment(A, SHA3.baMessageDigest[0]);

    Assignment(B, SHA3.baMessageDigest[1]);

    Assignment(C, SHA3.baMessageDigest[2]);

    Assignment(D, SHA3.baMessageDigest[3]);

    Assignment(E, SHA3.baMessageDigest[4]);

    Trinary24(F, $5A827999);

    Trinary24(G, $6ED9EBA1);

    Trinary24(H, $8F1BBCDC);

    Trinary24(II, $CA62C1D6);

    i := 0;

    For j := 0 To 15 Do
    Begin
        W[j, 23] := SHA3.baDataBlock[i, 5];

        W[j, 22] := SHA3.baDataBlock[i, 4];

        W[j, 21] := SHA3.baDataBlock[i, 3];

        W[j, 20] := SHA3.baDataBlock[i, 2];

        W[j, 19] := SHA3.baDataBlock[i, 1];

        W[j, 18] := SHA3.baDataBlock[i, 0];

        W[j, 17] := SHA3.baDataBlock[i + 1, 5];

        W[j, 16] := SHA3.baDataBlock[i + 1, 4];

        W[j, 15] := SHA3.baDataBlock[i + 1, 3];

        W[j, 14] := SHA3.baDataBlock[i + 1, 2];

        W[j, 13] := SHA3.baDataBlock[i + 1, 1];

        W[j, 12] := SHA3.baDataBlock[i + 1, 0];

        W[j, 11] := SHA3.baDataBlock[i + 2, 5];

        W[j, 10] := SHA3.baDataBlock[i + 2, 4];

        W[j, 9] := SHA3.baDataBlock[i + 2, 3];

        W[j, 8] := SHA3.baDataBlock[i + 2, 2];

        W[j, 7] := SHA3.baDataBlock[i + 2, 1];

        W[j, 6] := SHA3.baDataBlock[i + 2, 0];

        W[j, 5] := SHA3.baDataBlock[i + 3, 5];

        W[j, 4] := SHA3.baDataBlock[i + 3, 4];

        W[j, 3] := SHA3.baDataBlock[i + 3, 3];

        W[j, 2] := SHA3.baDataBlock[i + 3, 2];

        W[j, 1] := SHA3.baDataBlock[i + 3, 1];

        W[j, 0] := SHA3.baDataBlock[i + 3, 0];

        i := i + 4;
    End;

    For k := 16 To 79 Do
    Begin
        TrinaryXOr0(T, W[k - 3], W[k - 5]);

        TrinaryXAnd2(T, T, W[k - 7]);

        TrinaryXOr2(T, T, W[k - 11]);

        TrinaryXAnd0(T, T, W[k - 13]);

        W[k, 23] := T[2];

        W[k, 22] := T[1];

        W[k, 21] := T[0];

        W[k, 20] := T[23];

        W[k, 19] := T[22];

        W[k, 18] := T[21];

        W[k, 17] := T[20];

        W[k, 16] := T[19];

        W[k, 15] := T[18];

        W[k, 14] := T[17];

        W[k, 13] := T[16];

        W[k, 12] := T[15];

        W[k, 11] := T[14];

        W[k, 10] := T[13];

        W[k, 9] := T[12];

        W[k, 8] := T[11];

        W[k, 7] := T[10];

        W[k, 6] := T[9];

        W[k, 5] := T[8];

        W[k, 4] := T[7];

        W[k, 3] := T[6];

        W[k, 2] := T[5];

        W[k, 1] := T[4];

        W[k, 0] := T[3];
    End;

    For i := 0 To 19 Do
    Begin
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

        Assignment(E, D);

        Assignment(D, C);

        RotateShiftLeft19(C, B);

        Assignment(B, A);

        Assignment(A, T);
    End;

    For j := 20 To 39 Do
    Begin
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

        Assignment(E, D);

        Assignment(D, C);

        RotateShiftLeft19(C, B);

        Assignment(B, A);

        Assignment(A, T);
    End;

    For k := 40 To 59 Do
    Begin
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

        Assignment(E, D);

        Assignment(D, C);

        RotateShiftLeft19(C, B);

        Assignment(B, A);

        Assignment(A, T);
    End;

    For l := 60 To 79 Do
    Begin
        RotateShiftLeft7(A);

        TrinaryMultiply(P, B, C);

        TrinaryAdd(Q, C, D);

        TrinaryXAnd2(P, P, Q);

        TrinarySubtract(Q, D, B);

        TrinaryXOr0(T, P, Q);

        Add(T, A);

        Add(T, E);

        Add(T, W[l]);

        Add(T, II);

        Assignment(E, D);

        Assignment(D, C);

        RotateShiftLeft19(C, B);

        Assignment(B, A);

        Assignment(A, T);
    End;

    Assignment(SHA3.baMessageDigest[0], A);

    Assignment(SHA3.baMessageDigest[1], B);

    Assignment(SHA3.baMessageDigest[2], C);

    Assignment(SHA3.baMessageDigest[3], D);

    Assignment(SHA3.baMessageDigest[4], E);
End;

Var
    flFD : File;

    i, j, k, l, lFileSize, lBytesLeft : Int64;

    bpData : PByte;

    SHA3 : SHA3Context;

Begin
    If ParamCount <> 1 Then
    Begin
        Usage();
    End
    Else
    Begin
        Assign(flFD, ParamStr(1));

        Reset(flFD, 1);

        lFileSize := FileSize(flFD);

        If lFileSize = 0 Then
        Begin
            WriteLn('There is no data in file [', ParamStr(1), '], 0 byte.');

            Halt(-1);
        End;

        lBytesLeft := lFileSize And 63;

        If lBytesLeft = 0 Then
        Begin
            lBytesLeft := lFileSize + 64;
        End
        Else If lBytesLeft < 54 Then
        Begin
            lBytesLeft := lFileSize - lBytesLeft + 64;
        End
        Else If lBytesLeft > 53 Then
        Begin
            lBytesLeft := lFileSize - lBytesLeft + 128;
        End;

        bpData := GetMem(lBytesLeft);

        BlockRead(flFD, bpData^, lFileSize);

        Close(flFD);

        For i := 0 To 4 Do
        Begin
            bpData[i + lFileSize] := lFileSize Shr (8 * i);
        End;

        k := 0;

        For j := lFileSize + 5 To lBytesLeft - 6 Do
        Begin
            bpData[j] := baPadding[k];

            k := k + 1;
        End;

        For l := 4 DownTo 0 Do
        Begin
            bpData[lBytesLeft - l - 1] := lFileSize Shr (8 * l);
        End;

        Trinary24(SHA3.baMessageDigest[0], $67452301);

        Trinary24(SHA3.baMessageDigest[1], $EFCDAB89);

        Trinary24(SHA3.baMessageDigest[2], $98BADCFE);

        Trinary24(SHA3.baMessageDigest[3], $10325476);

        Trinary24(SHA3.baMessageDigest[4], $C3D2E1F0);

        i := 0;

        While i < lBytesLeft Do
        Begin
            For j := 0 To 63 Do
            Begin
                Trinary6(SHA3.baDataBlock[j], bpData[i + j]);
            End;

            SHA3Hash(SHA3);

            i := i + 64;
        End;

        For k := 0 To 23 Do
        Begin
            Write(SHA3.baMessageDigest[0, k], SHA3.baMessageDigest[1, k], SHA3.baMessageDigest[2, k], SHA3.baMessageDigest[3, k], SHA3.baMessageDigest[4, k]);
        End;

        WriteLn();

        FreeMem(bpData);
    End;
End.