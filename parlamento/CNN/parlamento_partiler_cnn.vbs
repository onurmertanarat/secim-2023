'USEUNIT Factory
'USEUNIT Config
'USEUNIT ErrorDef
'USEUNIT LibFunc
'USEUNIT Database
'USEUNIT Log
'USEUNIT Registry
'USEUNIT Consts

Option Explicit

Dim idSCTR : idSCTR = 0
Dim currentCumhur : currentCumhur = eSP_2023Cumhurbaskanligi
Dim currentGenel : currentGenel = eSP_2023Genel
' Dim idDataSource : idDataSource = eDS_CONSOLIDE
Dim idDataSource : idDataSource = eDS_TUIK
Dim idPartiOrderType : idPartiOrderType = ePOT_Pusula
Dim bagimsizDetayli : bagimsizDetayli =  ePRM_BagimsizDetay_NO
Dim cumhurID : cumhurID = ePARTI_CumhurIttifaki
Dim milletID : milletID = ePARTI_MilletIttifaki
Dim toplamMVSayisi : toplamMVSayisi = 600
Dim main_machine
Dim arrWinners()

Dim arrParti(9, 2)
arrParti(0, 0) = UpPartiAdiG1
arrParti(0, 1) = UpPartiMvG1
arrParti(0, 2) = UpPartiIdG1

arrParti(1, 0) = UpPartiAdiG2
arrParti(1, 1) = UpPartiMvG2
arrParti(1, 2) = UpPartiIdG2

arrParti(2, 0) = UpPartiAdiG3
arrParti(2, 1) = UpPartiMvG3
arrParti(2, 2) = UpPartiIdG3

arrParti(3, 0) = UpPartiAdiG4
arrParti(3, 1) = UpPartiMvG4
arrParti(3, 2) = UpPartiIdG4

arrParti(4, 0) = UpPartiAdiG5
arrParti(4, 1) = UpPartiMvG5
arrParti(4, 2) = UpPartiIdG5

arrParti(5, 0) = UpPartiAdiG6
arrParti(5, 1) = UpPartiMvG6
arrParti(5, 2) = UpPartiIdG6

arrParti(6, 0) = UpPartiAdiG7
arrParti(6, 1) = UpPartiMvG7
arrParti(6, 2) = UpPartiIdG7

arrParti(7, 0) = UpPartiAdiG8
arrParti(7, 1) = UpPartiMvG8
arrParti(7, 2) = UpPartiIdG8

arrParti(8, 0) = UpPartiAdiG9
arrParti(8, 1) = UpPartiMvG9
arrParti(8, 2) = UpPartiIdG9

Sub InitForm()
        UninitClass()
        Dim ret : ret  =  InitClass([_template], [_scripter])
        If ret <> CFnRetOk Then
                MsgBox "InitForm : Classlar init edilirken problem meydana geldi"
                Exit Sub
        End If

  InnerInitForm()
End Sub

Function TemplateCloseQuery
  UninitClass()
End Function

Sub InnerInitForm()
  SendToVizButtonClick.Enabled = false
  ClearTextBoxes()
  cbMvGoster.Checked = false
End Sub

Sub ClearTextboxes()
       Dim c
       For c = 1 To 10 Step 1
           '#1
           findcomponent("UpPartiAdiG"&c).UTF8Text = ""
           findcomponent("UpPartiYuzdeG"&c).UTF8Text = ""
           findcomponent("UpPartiMvG"&c).UTF8Text = ""
       Next
       txtAcilanSandikBilgisi.UTF8Text = ""
End Sub

Sub btnVerileriGuncelleClick(Sender)
SendToVizButtonClick.Enabled = true
        Call GetPartilerOrderByMv(idSCTR, idDataSource, ePRM_IttifakVariant_NO, "UpPartiIdG","UpPartiAdiG","UpPartiYuzdeG","UpPartiMvG", txtAcilanSandikBilgisi)
End sub

Sub GetPartilerOrderByMv(idSC, ajans, ittifakVariant, txtId,txtName,txtOy,txtMv, txtAcilan)

  Dim arrSonuc()
  Dim acilanSandik
  Dim partiSayisi : partiSayisi = 10

  acilansandik = g_db.AcilanSandikYuzdeDetay(idSC, currentGenel, idDataSource, true)
  txtAcilan.UTF8Text = g_lib.YuzdeKorumaYuvarlama(acilansandik)
  Call g_db.SonucListesiTamDetayOrderByMv(arrSonuc, idSC, currentGenel, ajans, idPartiOrderType, bagimsizDetayli, ittifakVariant, partiSayisi, true, 1)
  If Not g_lib.IsInitialized(arrSonuc) Then
         msgbox "arrSonuc, Initialize edilemedi!"
         Exit Sub
  End If
  Dim toplam : toplam = 0
  Dim i
  for i = 0 to UBound(arrSonuc)

             findcomponent(txtName&""&(i+1)).UTF8Text = arrSonuc(i).nameAlter
             findcomponent(txtOy&""&(i+1)).UTF8Text = g_lib.YuzdeKorumaYuvarlama(arrSonuc(i).yuzde)
             findcomponent(txtId&""&(i+1)).UTF8Text = arrSonuc(i).idParti
             findcomponent(txtMv&""&(i+1)).UTF8Text = arrSonuc(i).mvB
             toplam = toplam + arrSonuc(i).mvB
  next
  toplamMv.UTF8Text = toplam
End Sub

Sub SendToVizButtonClickClick(Sender)
        SendToVizButtonClick.Enabled = false
        GoVizDatas()
End sub

Sub GoVizDatas()

       buffer_clear()

       Call SetActive("hpartgrp_01", 0)
       Call SetActive("hpartgrp_02", 0)
       Call SetActive("hpartgrp_03", 0)
       Call SetActive("hpartgrp_04", 0)
       Call SetActive("hpartgrp_05", 0)
       Call SetActive("hpartgrp_06", 0)
       Call SetActive("hpartgrp_07", 0)
       Call SetActive("hpartgrp_08", 0)
       Call SetActive("hpartgrp_09", 0)
       Call SetActive("hpartgrp_10", 0)

       if cbMvGoster.Checked = TRUE then
                        Call SetActive("hpartgrp_01", 1)
                        Call SetActive("hpartgrp_02", 1)
                        Call SetActive("hpartgrp_03", 1)
                        Call SetActive("hpartgrp_04", 1)
                        Call SetActive("hpartgrp_05", 1)
                        Call SetActive("hpartgrp_06", 1)
                        Call SetActive("hpartgrp_07", 1)
                        Call SetActive("hpartgrp_08", 1)
                        Call SetActive("hpartgrp_09", 1)
                        Call SetActive("hpartgrp_10", 1)

                        if CInt(UpPartiMvG1.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk01", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG1.UTF8Text)
                                Call SetText("hpartiadi_01", UpPartiAdiG1.UTF8Text)
                                Call SetText("pmvnum_01", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG2.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk02", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG2.UTF8Text)
                                Call SetText("hpartiadi_02", UpPartiAdiG2.UTF8Text)
                                Call SetText("pmvnum_02", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG3.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk03", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG3.UTF8Text)
                                Call SetText("hpartiadi_03", UpPartiAdiG3.UTF8Text)
                                Call SetText("pmvnum_03", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG4.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk04", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG4.UTF8Text)
                                Call SetText("hpartiadi_04", UpPartiAdiG4.UTF8Text)
                                Call SetText("pmvnum_04", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG5.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk05", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG5.UTF8Text)
                                Call SetText("hpartiadi_05", UpPartiAdiG5.UTF8Text)
                                Call SetText("pmvnum_05", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG6.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk06", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG6.UTF8Text)
                                Call SetText("hpartiadi_06", UpPartiAdiG6.UTF8Text)
                                Call SetText("pmvnum_06", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG7.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk07", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG7.UTF8Text)
                                Call SetText("hpartiadi_07", UpPartiAdiG7.UTF8Text)
                                Call SetText("pmvnum_07", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG8.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk08", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG8.UTF8Text)
                                Call SetText("hpartiadi_08", UpPartiAdiG8.UTF8Text)
                                Call SetText("pmvnum_08", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG9.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk09", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG9.UTF8Text)
                                Call SetText("hpartiadi_09", UpPartiAdiG9.UTF8Text)
                                Call SetText("pmvnum_09", lblTire.UTF8Text)
                        end if
                        if CInt(UpPartiMvG10.UTF8Text) = 0 then
                                Call SetMaterial("ittifak_renk10", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG10.UTF8Text)
                                Call SetText("hpartiadi_10", UpPartiAdiG10.UTF8Text)
                                Call SetText("pmvnum_10", lblTire.UTF8Text)
                        end if

       elseif cbMvGoster.Checked = FALSE then

                        if CInt(UpPartiMvG1.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_01", 0)
                        end if
                        if CInt(UpPartiMvG2.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_02", 0)
                        end if
                        if CInt(UpPartiMvG3.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_03", 0)
                        end if
                        if CInt(UpPartiMvG4.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_04", 0)
                        end if
                        if CInt(UpPartiMvG5.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_05", 0)
                        end if
                        if CInt(UpPartiMvG6.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_06", 0)
                        end if
                        if CInt(UpPartiMvG7.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_07", 0)
                        end if
                        if CInt(UpPartiMvG8.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_08", 0)
                        end if
                        if CInt(UpPartiMvG9.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_09", 0)
                        end if
                        if CInt(UpPartiMvG10.UTF8Text) = 0 then
                                Call SetActive("hpartgrp_10", 0)
                        end if

                        if CInt(UpPartiMvG1.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_01", 1)
                        end if
                        if CInt(UpPartiMvG2.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_02", 1)
                        end if
                        if CInt(UpPartiMvG3.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_03", 1)
                        end if
                        if CInt(UpPartiMvG4.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_04", 1)
                        end if
                        if CInt(UpPartiMvG5.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_05", 1)
                        end if
                        if CInt(UpPartiMvG6.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_06", 1)
                        end if
                        if CInt(UpPartiMvG7.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_07", 1)
                        end if
                        if CInt(UpPartiMvG8.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_08", 1)
                        end if
                        if CInt(UpPartiMvG9.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_09", 1)
                        end if
                        if CInt(UpPartiMvG10.UTF8Text) > 0 then
                                Call SetActive("hpartgrp_10", 1)
                        end if


                        Call SetText("hpartiadi_01", UpPartiAdiG1.UTF8Text)
                        Call SetMaterial("ittifak_renk01", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG1.UTF8Text)
                        Call SetText("pmvnum_01", UpPartiMvG1.UTF8Text)

                        Call SetText("hpartiadi_02", UpPartiAdiG2.UTF8Text)
                        Call SetMaterial("ittifak_renk02", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG2.UTF8Text)
                        Call SetText("pmvnum_02", UpPartiMvG2.UTF8Text)

                        Call SetText("hpartiadi_03", UpPartiAdiG3.UTF8Text)
                        Call SetMaterial("ittifak_renk03", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG3.UTF8Text)
                        Call SetText("pmvnum_03", UpPartiMvG3.UTF8Text)

                        Call SetText("hpartiadi_04", UpPartiAdiG4.UTF8Text)
                        Call SetMaterial("ittifak_renk04", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG4.UTF8Text)
                        Call SetText("pmvnum_04", UpPartiMvG4.UTF8Text)

                        Call SetText("hpartiadi_05", UpPartiAdiG5.UTF8Text)
                        Call SetMaterial("ittifak_renk05", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG5.UTF8Text)
                        Call SetText("pmvnum_05", UpPartiMvG5.UTF8Text)

                        Call SetText("hpartiadi_06", UpPartiAdiG6.UTF8Text)
                        Call SetMaterial("ittifak_renk06", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG6.UTF8Text)
                        Call SetText("pmvnum_06", UpPartiMvG6.UTF8Text)

                        Call SetText("hpartiadi_07", UpPartiAdiG7.UTF8Text)
                        Call SetMaterial("ittifak_renk07", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG7.UTF8Text)
                        Call SetText("pmvnum_07", UpPartiMvG7.UTF8Text)

                        Call SetText("hpartiadi_08", UpPartiAdiG8.UTF8Text)
                        Call SetMaterial("ittifak_renk08", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG8.UTF8Text)
                        Call SetText("pmvnum_08", UpPartiMvG8.UTF8Text)

                        Call SetText("hpartiadi_09", UpPartiAdiG9.UTF8Text)
                        Call SetMaterial("ittifak_renk09", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG9.UTF8Text)
                        Call SetText("pmvnum_09", UpPartiMvG9.UTF8Text)

                        Call SetText("hpartiadi_10", UpPartiAdiG10.UTF8Text)
                        Call SetMaterial("ittifak_renk10", "SECIM_2023/CNN/PARTI_MATERIAL/"&UpPartiIdG10.UTF8Text)
                        Call SetText("pmvnum_10", UpPartiMvG10.UTF8Text)

       else
                        Exit SUB
       end if

      ' Call SetText("acilan", g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))
       Dim toplamMvSayisi : toplamMvSayisi = 600

       Dim i
       Dim tmpPieTotal : tmpPieTotal = 0

       If CInt(toplamMv.UTF8Text) > 600 OR CInt(CInt(UpPartiMvG1.UTF8Text)+CInt(UpPartiMvG2.UTF8Text)+CInt(UpPartiMvG3.UTF8Text)+CInt(UpPartiMvG4.UTF8Text)+CInt(UpPartiMvG5.UTF8Text)+CInt(UpPartiMvG6.UTF8Text)+CInt(UpPartiMvG7.UTF8Text)+CInt(UpPartiMvG8.UTF8Text)+CInt(UpPartiMvG9.UTF8Text)+CInt(UpPartiMvG10.UTF8Text)) > 600 Then
             msgbox "Milletvekili sayısı 600' ü aştı!"
             exit sub
       Else
         for i = 0 to 9 step 1
           Dim mvCount : mvCount = g_lib.CDblSafe(findcomponent("UpPartiMvG"&(i+1)).UTF8Text)
           Dim mvPie : mvPie = 180 * mvCount / toplamMvSayisi

           buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*ANIMATION*KEY*$end*VALUE SET " & mvPie)
           if mvCount > 0 then
                 buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*GEOM*rotation SET " & (90+ tmpPieTotal))
           end if
           tmpPieTotal = tmpPieTotal + mvPie
           Call SetMaterial("p_0"&(i+1),findcomponent("UpPartiIdG"&(i+1)).UTF8Text )
           buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*MATERIAL SET MATERIAL*SECIM_2023/CNN/PARTI_MATERIAL/" & findcomponent("UpPartiIdG"&(i+1)).UTF8Text)
         next
       End If

     '  Dim i
     '  Dim tmpPieTotal : tmpPieTotal = 0
     '  for i = 0 to 9 step 1
     '      Dim mvCount : mvCount = g_lib.CDblSafe(findcomponent("UpPartiMvG"&(i+1)).UTF8Text)
     '      Dim mvPie : mvPie = 180 * mvCount / toplamMvSayisi
     '
     '      buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*ANIMATION*KEY*$end*VALUE SET " & mvPie)
     '      if mvCount > 0 then
     '            buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*GEOM*rotation SET " & (90+ tmpPieTotal))
     '      end if
     '      tmpPieTotal = tmpPieTotal + mvPie
     '      Call SetMaterial("p_0"&(i+1),findcomponent("UpPartiIdG"&(i+1)).UTF8Text )
     '      buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*MATERIAL SET MATERIAL*SECIM_2023/CNN/PARTI_MATERIAL/" & findcomponent("UpPartiIdG"&(i+1)).UTF8Text)
     '  next

       Call PlayAnim("Default")
       Call PlayAnim("MV_LEGEND")
       Call PlayAnim("MEC_ANI")

       buffer_send(main_machine)
End Sub

Sub Btn_Yayindan_AlClick(Sender)
        buffer_clear()
        buffer_put("-1 RENDERER SET_OBJECT ")
        buffer_send(main_machine)
End sub

Sub LoadSceneButtonClickClick(Sender)
        Call LoadScene("SECIM_2023/CNN/SAHNELER/2_TUR","/mv_sandalye")
End sub

Sub SetText(controlName, text)
    buffer_put("-1 RENDERER*TREE*@"&controlName&"*GEOM*TEXT SET "&text)
End Sub

Sub SetActive(controlName, state)
    buffer_put("-1 RENDERER*TREE*@"&controlName&"*ACTIVE SET "&state)
End Sub

Sub SetImage(controlName, path)
    buffer_put("-1 RENDERER*TREE*@"&controlName&"*IMAGE SET IMAGE*"&path)
End Sub

Sub SetKeyframe(controlName, keyName, command, text)
    buffer_put("-1 RENDERER*TREE*@"&controlName&"*ANIMATION*KEY*$"&keyName&"*"&command&" SET " & text)
End Sub

Sub SetMaterial(controlName, path)
    buffer_put("-1 RENDERER*TREE*@"&ControlName&"*MATERIAL SET "&Path)
End Sub

Sub PlayAnim(animName)
    buffer_put("-1 RENDERER*STAGE*DIRECTOR*" & animName & "*DIRECTION SET")
    buffer_put("-1 RENDERER*STAGE*DIRECTOR*" & animName & " START")
End Sub

Sub LoadScene(path, sceneName)
        buffer_clear()
        buffer_put("-1 RENDERER SET_OBJECT SCENE*" & path & sceneName)
        buffer_put("-1 RENDERER*STAGE SHOW 0")
        buffer_send(main_machine)
End Sub

Sub cbMvGosterClick(Sender)
        SendToVizButtonClick.Enabled = true
End sub