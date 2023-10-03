'USEUNIT Factory
'USEUNIT Config
'USEUNIT ErrorDef
'USEUNIT LibFunc
'USEUNIT Database
'USEUNIT Log
'USEUNIT Registry
'USEUNIT Consts

Option Explicit

Dim arrParti(4, 4)
arrParti(0, 0) = IttifakAdiAA1
arrParti(0, 1) = IttifakMvAA1
arrParti(0, 2) = IttifakIdAA1
arrParti(0, 3) = IttifakYuzdeAA1

arrParti(1, 0) = IttifakAdiAA2
arrParti(1, 1) = IttifakMvAA2
arrParti(1, 2) = IttifakIdAA2
arrParti(1, 3) = IttifakYuzdeAA2

arrParti(2, 0) = IttifakAdiAA3
arrParti(2, 1) = IttifakMvAA3
arrParti(2, 2) = IttifakIdAA3
arrParti(2, 3) = IttifakYuzdeAA3

arrParti(3, 0) = IttifakAdiAA4
arrParti(3, 1) = IttifakMvAA4
arrParti(3, 2) = IttifakIdAA4
arrParti(3, 3) = IttifakYuzdeAA4

arrParti(4, 0) = IttifakAdiAA5
arrParti(4, 1) = IttifakMvAA5
arrParti(4, 2) = IttifakIdAA5
arrParti(4, 3) = IttifakYuzdeAA5

Dim idSCTR  : idSCTR = 0
Dim currentCumhur : currentCumhur = eSP_2023Cumhurbaskanligi
Dim currentGenel : currentGenel = eSP_2023Genel
' Dim idDataSource : idDataSource = eDS_CONSOLIDE
Dim idDataSource : idDataSource = eDS_TUIK
Dim idPartiOrderType : idPartiOrderType = ePOT_Pusula
Dim bagimsizDetayli : bagimsizDetayli =  ePRM_BagimsizDetay_NO
Dim cumhurID : cumhurID = ePARTI_CumhurIttifaki
Dim milletID : milletID = ePARTI_MilletIttifaki
Dim toplamMVSayisi : toplamMVSayisi = 600
Dim arrWinners()
Dim main_machine

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
        btnVerileriGuncelle.Enabled = true
        btnYayindaSabit.Visible = False
        btnYayindaSirali.Visible = False
        cbSiraliVer.Checked = False
        cbMvGoster.Checked = False
        ClearTextboxes()
        toplamMv.UTF8Text = ""
End Sub

Sub ClearTextboxes()
       Dim c
       For c = 1 To 5 Step 1
           findcomponent("IttifakAdiAA"&c).UTF8Text = ""
           findcomponent("IttifakYuzdeAA"&c).UTF8Text = ""
           findcomponent("IttifakMvAA"&c).UTF8Text = ""
       Next
       txtAcilanSandikBilgisi.UTF8Text = ""
       tbCumhur.UTF8Text = ""
       tbMillet.UTF8TExt = ""
       tbEmek.UTF8Text = ""
       tbAta.UTF8Text = ""
       tbSosyalist.UTF8Text = ""
       tbCumhurYuzde.UTF8Text = ""
       tbMilletYuzde.UTF8Text = ""
       tbEmekYuzde.UTF8Text = ""
       tbAtaYuzde.UTF8Text = ""
       tbSosyalistYuzde.UTF8Text = ""
End Sub

Sub btnVerileriGuncelleClick(Sender)
        SendToVizButtonClick.Enabled = true
        cbMvGoster.Enabled = true
'btnVerileriGuncelle.Enabled = false
        If cbSiraliVer.Checked = True Then
           Call GetIttifaklarSirali(idSCTR, idDataSource, ePRM_IttifakVariant_YES, "IttifakIdAA", "IttifakAdiAA", "IttifakYuzdeAA", "IttifakMvAA", txtAcilanSandikBilgisi)
        Else 'cbSiraliVer.Checked = False Then
           Dim acilanSandik
           acilansandik = g_db.AcilanSandikYuzdeDetay(idSCTR, currentGenel, idDataSource, true)
           txtAcilanSandikBilgisi.UTF8Text = g_lib.YuzdeKorumaYuvarlama(acilansandik)
           Call GetDatasCumhur()
           Call GetDatasMillet()
           Call GetDatasEmek()
           Call GetDatasAta()
           Call GetDatasSosyalist()
           toplamMv.UTF8Text = CInt(tbCumhur.UTF8Text) + CInt(tbMillet.UTF8Text) + CInt(tbEmek.UTF8Text) + CInt(tbAta.UTF8Text) + CInt(tbSosyalist.UTF8Text)
        End If
End sub

Sub GetDatasCumhur()
       Call GetDatasMvIttifak(currentGenel, idDataSource, tbCumhur, tbCumhurYuzde, lblCumhurId, ePARTI_CumhurIttifakiToplam, idSCTR)
End Sub

Sub GetDatasMillet()
       Call GetDatasMvIttifak(currentGenel, idDataSource, tbMillet, tbMilletYuzde, lblMilletId, ePARTI_MilletIttifakiToplam, idSCTR)
End Sub

Sub GetDatasEmek()
       Call GetDatasMvIttifak(currentGenel, idDataSource, tbEmek, tbEmekYuzde, lblEmekId, ePARTI_EmekveOzgurlukIttifakiToplam, idSCTR)
End Sub

Sub GetDatasAta()
       Call GetDatasMvIttifak(currentGenel, idDataSource, tbAta, tbAtaYuzde, lblAtaId, ePARTI_ATAIttifakiToplam, idSCTR)
End Sub

Sub GetDatasSosyalist()
       Call GetDatasMvIttifak(currentGenel, idDataSource, tbSosyalist, tbSosyalistYuzde, lblSosyalistId, ePARTI_SosyalistGucBirligiIttifakiToplam, idSCTR)
End Sub

Sub GetDatasMvIttifak(idSecim, idSource , tbMv, tbYuzde, labelId, ittifakId, idSc)
        Dim arrSonuc()
        Dim ittifakSayisi : ittifakSayisi = 28

        Call g_db.SonucListesiTamDetay(arrSonuc, idSc, idSecim, idDataSource, idPartiOrderType, bagimsizDetayli, ePRM_IttifakVariant_YES, ittifakSayisi, true)
        If Not g_lib.IsInitialized(arrSonuc) Then
                msgbox "arrSonuc, Initialize edilemedi!"
                Exit Sub
        End If

        Dim ittifakSonuc
        SET ittifakSonuc = g_lib.GetPartiSonuc(arrSonuc, ittifakId)

        labelId.UTF8Text = ittifakSonuc.idParti
        tbMv.UTF8Text = ittifakSonuc.mvB
        tbYuzde.UTF8Text = g_lib.YuzdeKorumaYuvarlama(ittifakSonuc.yuzde)
End Sub

Sub GetIttifaklarSirali(idSC, ajans, ittifakVariant, txtId,txtName,txtOy,txtMv, txtAcilan)
  Dim arrSonuc()
  Dim acilanSandik
  Dim ittifakSayisi : ittifakSayisi = 28
  acilansandik = g_db.AcilanSandikYuzdeDetay(idSC, currentGenel, idDataSource, true)
  txtAcilan.UTF8Text = g_lib.YuzdeKorumaYuvarlama(acilansandik)

  Call g_db.SonucListesiTamDetayOrderByMv(arrSonuc, idSC, currentGenel, ajans, idPartiOrderType, bagimsizDetayli, ittifakVariant, ittifakSayisi, true, 1)
  If Not g_lib.IsInitialized(arrSonuc) Then
                msgbox "arrSonuc, Initialize edilemedi!"
                Exit Sub
  End If
  Dim counter : counter = 1
  Dim i
  for i = 0 to UBound(arrSonuc)
        if arrSonuc(i).idParti = 402 OR arrSonuc(i).idParti = 403 OR arrSonuc(i).idParti = 406 OR arrSonuc(i).idParti = 407 OR arrSonuc(i).idParti = 409 then
                findcomponent(txtName&""&counter).UTF8Text = g_lib.Buyut(Replace(arrSonuc(i).nameShortResmi," Toplam Oyu",""))
                findcomponent(txtOy&""&counter).UTF8Text = g_lib.YuzdeKorumaYuvarlamaDigit(arrSonuc(i).yuzde,1)
                findcomponent(txtId&""&counter).UTF8Text = arrSonuc(i).idParti
                findcomponent(txtMv&""&counter).UTF8Text = arrSonuc(i).mvB
                counter = counter +1
        else

        end if

  next
  toplamMv.UTF8Text = CInt(IttifakMvAA1.UTF8Text) + CInt(IttifakMvAA2.UTF8Text) + CInt(IttifakMvAA3.UTF8Text) + CInt(IttifakMvAA4.UTF8Text) + CInt(IttifakMvAA5.UTF8Text)
End Sub

Sub SendToVizButtonClickClick(Sender)
        SendToVizButtonClick.Enabled = false
        btnVerileriGuncelle.Enabled = true
        If cbSiraliVer.Checked = False Then
                btnYayindaSabit.Visible = True
                btnYayindaSirali.Visible = False
                GoVizDatas()
        ElseIf cbSiraliVer.Checked = True Then
                btnYayindaSabit.Visible = False
                btnYayindaSirali.Visible = True
                GoVizDatasSirali()
        End If
End sub

Sub GoVizDatasSirali()
        buffer_clear()
        Dim i,a
        Dim count : count = 0
        Dim mvTotal : mvTotal = 0
        Dim mvPieIlk : mvPieIlk = 0
        Dim tmpPieTotal : tmpPieTotal = 0

        For a = 0 To UBound(arrParti)
                If arrParti(a, 0).UTF8Text = "" Then  Exit For
                mvTotal = mvTotal + 1
        Next

        buffer_put("-1 RENDERER*TREE*@hpartgrp_0"&(i+1)&"*ACTIVE SET 0")

        For i = 0 To UBound(arrParti)
                Dim mvCount : mvCount = g_lib.CDblSafe(arrParti(i, 1).UTF8Text)
                Dim mvPie : mvPie = 180* mvCount / toplamMVSayisi

               ' buffer_put("-1 RENDERER*TREE*@acilan*GEOM*TEXT SET " & g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))

                If CInt(toplamMv.UTF8Text) > 600 OR CInt(CInt(IttifakMvAA1.UTF8Text)+CInt(IttifakMvAA2.UTF8Text)+CInt(IttifakMvAA3.UTF8Text)+CInt(IttifakMvAA4.UTF8Text)+CInt(IttifakMvAA5.UTF8Text)) > 600 Then
                        msgbox "Milletvekili sayısı 600' ü aştı!"
                        exit sub
                Else
                        If i = 0 Then
                                buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*ANIMATION*KEY*$end*VALUE SET " & mvPie)
                        Else
                                buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*ANIMATION*KEY*$end*VALUE SET " & mvPie)
                                if mvCount > 0 then
                                        buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*GEOM*rotation SET " & (90+ tmpPieTotal))
                                end if
                        End if

                        tmpPieTotal = tmpPieTotal + mvPie
                End If

              '  If i = 0 Then
              '          buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*ANIMATION*KEY*$end*VALUE SET " & mvPie)
              '  Else
              '          buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*ANIMATION*KEY*$end*VALUE SET " & mvPie)
              '          if mvCount > 0 then
              '                  buffer_put("-1 RENDERER*TREE*@p_0"&(i+1)&"*GEOM*rotation SET " & (90+ tmpPieTotal))
              '          end if
              '  End if

              ' tmpPieTotal = tmpPieTotal + mvPie

                If CInt(arrParti(i, 1).UTF8Text) > 0 Then
                        Call SetActive("hpartgrp_0"&(count+1), "1")
                        Call SetText("ittval_0"&(count+1), arrParti(i,3).UTF8Text)
                        Call SetKeyFrame("ittval_0"&(count+1), "end", "VALUE", arrParti(i,3).UTF8Text)
                        Call SetText("pnm_0"&(count+1), arrParti(i,0).UTF8Text)
                        Call SetText("pmvs_0"&(count+1), arrParti(i,1).UTF8Text)
                        Call SetKeyFrame("pmvs_0"&(count+1), "end", "VALUE", arrParti(i,1).UTF8Text)
                        Call SetMaterial("ittifak_renk0"&(count+1), "SECIM_2023/CNN/PARTI_MATERIAL/"&arrParti(i,2).UTF8Text)
                        Call SetMaterial("it_renk0"&(count+1), "SECIM_2023/CNN/PARTI_MATERIAL/"&arrParti(i,2).UTF8Text)
                        Call SetMaterial("p_0"&(count+1), "SECIM_2023/CNN/PARTI_MATERIAL/"&arrParti(i,2).UTF8Text)
                        count  =  count + 1
                ElseIf CInt(arrParti(i, 1).UTF8Text) = 0 AND cbMvGoster.Checked = TRUE Then
                        Call SetActive("hpartgrp_0"&(count+1), "1")
                        Call SetText("ittval_0"&(count+1), arrParti(i,3).UTF8Text)
                        Call SetKeyFrame("ittval_0"&(count+1), "end", "VALUE", arrParti(i,3).UTF8Text)
                        Call SetText("pnm_0"&(count+1), arrParti(i,0).UTF8Text)
                        Call SetText("pmvs_0"&(count+1), lblTire.UTF8Text)
                        Call SetKeyFrame("pmvs_0"&(count+1), "end", "VALUE", arrParti(i,1).UTF8Text)
                        Call SetMaterial("ittifak_renk0"&(count+1), "SECIM_2023/CNN/PARTI_MATERIAL/"&arrParti(i,2).UTF8Text)
                        Call SetMaterial("it_renk0"&(count+1), "SECIM_2023/CNN/PARTI_MATERIAL/"&arrParti(i,2).UTF8Text)
                        Call SetMaterial("p_0"&(count+1), "SECIM_2023/CNN/PARTI_MATERIAL/"&arrParti(i,2).UTF8Text)
                        count  =  count + 1
                else
                buffer_put("-1 RENDERER*TREE*@hpartgrp_0"&(count+1)&"*ACTIVE SET 0")
                buffer_put("-1 RENDERER*TREE*@hpartgrp_0"&(i+1)&"*ACTIVE SET 0")
                End if

        Next

        Call PlayAnim("Default")
        Call PlayAnim("MV_LEGEND")
        Call PlayAnim("MEC_ANI")

       buffer_send(main_machine)
End Sub

Sub GoVizDatas()
       buffer_clear()

      ' Call SetText("acilan", g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))

       Call SetActive("hpartgrp_01", 0)
       Call SetActive("hpartgrp_02", 0)
       Call SetActive("hpartgrp_03", 0)
       Call SetActive("hpartgrp_04", 0)
       Call SetActive("hpartgrp_05", 0)

       if tbCumhur.UTF8Text > 0 then
             Call SetActive("hpartgrp_01", 1)
             Call SetText("pnm_01", lblCumhur.UTF8Text)
             Call SetMaterial("ittifak_renk01", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_CumhurIttifakiToplam)
             Call SetMaterial("it_renk01", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_CumhurIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_01*FUNCTION*Advanced_Counter*inpmask SET ###")
             Call SetText("pmvs_01", tbCumhur.UTF8Text)
             Call SetKeyFrame("pmvs_01", "end", "VALUE", tbCumhur.UTF8Text)
             Call SetText("ittval_01", tbCumhurYuzde.UTF8Text)
             Call SetKeyFrame("ittval_01", "end", "VALUE", tbCumhurYuzde.UTF8Text)
       elseif CInt(tbCumhur.UTF8Text) = 0 AND cbMvGoster.Checked = TRUE then
             Call SetActive("hpartgrp_01", 1)
             Call SetText("pnm_01", lblCumhur.UTF8Text)
             Call SetMaterial("ittifak_renk01", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_CumhurIttifakiToplam)
             Call SetMaterial("it_renk01", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_CumhurIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_01*FUNCTION*Advanced_Counter*inpmask SET -")
             Call SetText("pmvs_01", lblTire.UTF8Text)
             Call SetKeyFrame("pmvs_01", "end", "VALUE", lblTire.UTF8Text)
             Call SetText("ittval_01", tbCumhurYuzde.UTF8Text)
             Call SetKeyFrame("ittval_01", "end", "VALUE", tbCumhurYuzde.UTF8Text)
       else
             Call SetActive("hpartgrp_01", 0)
       end if

       if tbMillet.UTF8Text > 0 then
             Call SetActive("hpartgrp_02", 1)
             Call SetText("pnm_02", lblMillet.UTF8Text)
             Call SetMaterial("ittifak_renk02", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_MilletIttifakiToplam)
             Call SetMaterial("it_renk02", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_MilletIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_02*FUNCTION*Advanced_Counter*inpmask SET ###")
             Call SetText("pmvs_02", tbMillet.UTF8Text)
             Call SetKeyFrame("pmvs_02", "end", "VALUE", tbMillet.UTF8Text)
             Call SetText("ittval_02", tbMilletYuzde.UTF8Text)
             Call SetKeyFrame("ittval_02", "end", "VALUE", tbMilletYuzde.UTF8Text)
       elseif CInt(tbMillet.UTF8Text) = 0 AND cbMvGoster.Checked = TRUE then
             Call SetActive("hpartgrp_02", 1)
             Call SetText("pnm_02", lblMillet.UTF8Text)
             Call SetMaterial("ittifak_renk02", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_MilletIttifakiToplam)
             Call SetMaterial("it_renk02", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_MilletIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_02*FUNCTION*Advanced_Counter*inpmask SET -")
             Call SetText("pmvs_02", lblTire.UTF8Text)
             Call SetKeyFrame("pmvs_02", "end", "VALUE", lblTire.UTF8Text)
             Call SetText("ittval_02", tbMilletYuzde.UTF8Text)
             Call SetKeyFrame("ittval_02", "end", "VALUE", tbMilletYuzde.UTF8Text)
       else
             Call SetActive("hpartgrp_02", 0)
       end if

       if tbEmek.UTF8Text > 0 then
             Call SetActive("hpartgrp_03", 1)
             Call SetText("pnm_03", lblEmek.UTF8Text)
             Call SetMaterial("ittifak_renk03", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_EmekveOzgurlukIttifakiToplam)
             Call SetMaterial("it_renk03", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_EmekveOzgurlukIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_03*FUNCTION*Advanced_Counter*inpmask SET ###")
             Call SetText("pmvs_03", tbEmek.UTF8Text)
             Call SetKeyFrame("pmvs_03", "end", "VALUE", tbEmek.UTF8Text)
             Call SetText("ittval_03", tbEmekYuzde.UTF8Text)
             Call SetKeyFrame("ittval_03", "end", "VALUE", tbEmekYuzde.UTF8Text)
       elseif CInt(tbEmek.UTF8Text) = 0 AND cbMvGoster.Checked = TRUE then
             Call SetActive("hpartgrp_03", 1)
             Call SetText("pnm_03", lblEmek.UTF8Text)
             Call SetMaterial("ittifak_renk03", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_EmekveOzgurlukIttifakiToplam)
             Call SetMaterial("it_renk03", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_EmekveOzgurlukIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_03*FUNCTION*Advanced_Counter*inpmask SET -")
             Call SetText("pmvs_03", lblTire.UTF8Text)
             Call SetKeyFrame("pmvs_03", "end", "VALUE", lblTire.UTF8Text)
             Call SetText("ittval_03", tbEmekYuzde.UTF8Text)
             Call SetKeyFrame("ittval_03", "end", "VALUE", tbEmekYuzde.UTF8Text)
       else
             Call SetActive("hpartgrp_03", 0)
       end if

       if tbAta.UTF8Text > 0 then
             Call SetActive("hpartgrp_04", 1)
             Call SetText("pnm_04", lblAta.UTF8Text)
             Call SetMaterial("ittifak_renk04", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_ATAIttifakiToplam)
             Call SetMaterial("it_renk04", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_ATAIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_04*FUNCTION*Advanced_Counter*inpmask SET ###")
             Call SetText("pmvs_04", tbAta.UTF8Text)
             Call SetKeyFrame("pmvs_04", "end", "VALUE", tbAta.UTF8Text)
             Call SetText("ittval_04", tbAtaYuzde.UTF8Text)
             Call SetKeyFrame("ittval_04", "end", "VALUE", tbAtaYuzde.UTF8Text)
       elseif CInt(tbAta.UTF8Text) = 0 AND cbMvGoster.Checked = TRUE then
             Call SetActive("hpartgrp_04", 1)
             Call SetText("pnm_04", lblAta.UTF8Text)
             Call SetMaterial("ittifak_renk04", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_ATAIttifakiToplam)
             Call SetMaterial("it_renk04", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_ATAIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_04*FUNCTION*Advanced_Counter*inpmask SET -")
             Call SetText("pmvs_04", lblTire.UTF8Text)
             Call SetKeyFrame("pmvs_04", "end", "VALUE", lblTire.UTF8Text)
             Call SetText("ittval_04", tbAtaYuzde.UTF8Text)
             Call SetKeyFrame("ittval_04", "end", "VALUE", tbAtaYuzde.UTF8Text)
       else
             Call SetActive("hpartgrp_04", 0)
       end if

       if tbSosyalist.UTF8Text > 0 then
             Call SetActive("hpartgrp_05", 1)
             Call SetText("pnm_05", lblSosyalist.UTF8Text)
             Call SetMaterial("ittifak_renk05", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_SosyalistGucBirligiIttifakiToplam)
             Call SetMaterial("it_renk05", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_SosyalistGucBirligiIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_05*FUNCTION*Advanced_Counter*inpmask SET ###")
             Call SetText("pmvs_05", tbSosyalist.UTF8Text)
             Call SetKeyFrame("pmvs_05", "end", "VALUE", tbSosyalist.UTF8Text)
             Call SetText("ittval_05", tbSosyalistYuzde.UTF8Text)
             Call SetKeyFrame("ittval_05", "end", "VALUE", tbSosyalistYuzde.UTF8Text)
       elseif CInt(tbSosyalist.UTF8Text) = 0 AND cbMvGoster.Checked = TRUE then
             Call SetActive("hpartgrp_05", 1)
             Call SetText("pnm_05", lblSosyalist.UTF8Text)
             Call SetMaterial("ittifak_renk05", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_SosyalistGucBirligiIttifakiToplam)
             Call SetMaterial("it_renk05", "SECIM_2023/CNN/PARTI_MATERIAL/"&ePARTI_SosyalistGucBirligiIttifakiToplam)
             buffer_put("-1 RENDERER*TREE*@pmvs_05*FUNCTION*Advanced_Counter*inpmask SET -")
             Call SetText("pmvs_05", lblTire.UTF8Text)
             Call SetKeyFrame("pmvs_05", "end", "VALUE", "-")
             Call SetText("ittval_05", tbSosyalistYuzde.UTF8Text)
             Call SetKeyFrame("ittval_05", "end", "VALUE", tbSosyalistYuzde.UTF8Text)
       else
             Call SetActive("hpartgrp_05", 0)
       end if

       Call GetMeclisBoya()

       Call PlayAnim("Default")
       Call PlayAnim("MV_LEGEND")
       Call PlayAnim("MEC_ANI")

       buffer_send(main_machine)
End Sub

Sub GetMeclisBoya()
       Dim toplamMvSayisi : toplamMvSayisi = 600
       Dim tmpPieTotal : tmpPieTotal = 0

       Dim mvCount1 : mvCount1 = g_lib.CDblSafe(tbCumhur.UTF8Text)
       Dim mvCount2 : mvCount2 = g_lib.CDblSafe(tbMillet.UTF8Text)
       Dim mvCount3 : mvCount3 = g_lib.CDblSafe(tbEmek.UTF8Text)
       Dim mvCount4 : mvCount4 = g_lib.CDblSafe(tbAta.UTF8Text)
       Dim mvCount5 : mvCount5 = g_lib.CDblSafe(tbSosyalist.UTF8Text)

       Dim mvPie1 : mvPie1 = 180 * mvCount1 / toplamMvSayisi
       Dim mvPie2 : mvPie2 = 180 * mvCount2 / toplamMvSayisi
       Dim mvPie3 : mvPie3 = 180 * mvCount3 / toplamMvSayisi
       Dim mvPie4 : mvPie4 = 180 * mvCount4 / toplamMvSayisi
       Dim mvPie5 : mvPie5 = 180 * mvCount5 / toplamMvSayisi

       buffer_put("-1 RENDERER*TREE*@p_01*ANIMATION*KEY*$end*VALUE SET " & mvPie1)
       buffer_put("-1 RENDERER*TREE*@p_02*ANIMATION*KEY*$end*VALUE SET " & mvPie2)
       buffer_put("-1 RENDERER*TREE*@p_03*ANIMATION*KEY*$end*VALUE SET " & mvPie3)
       buffer_put("-1 RENDERER*TREE*@p_04*ANIMATION*KEY*$end*VALUE SET " & mvPie4)
       buffer_put("-1 RENDERER*TREE*@p_05*ANIMATION*KEY*$end*VALUE SET " & mvPie5)

       if mvCount1 > 0 then
          buffer_put("-1 RENDERER*TREE*@p_01*GEOM*rotation SET " & (90+ tmpPieTotal))
       end if
       tmpPieTotal = tmpPieTotal + mvPie1
       if mvCount2 > 0 then
          buffer_put("-1 RENDERER*TREE*@p_02*GEOM*rotation SET " & (90+ tmpPieTotal))
       end if
       tmpPieTotal = tmpPieTotal + mvPie2
       if mvCount3 > 0 then
          buffer_put("-1 RENDERER*TREE*@p_03*GEOM*rotation SET " & (90+ tmpPieTotal))
       end if
       tmpPieTotal = tmpPieTotal + mvPie3
       if mvCount4 > 0 then
          buffer_put("-1 RENDERER*TREE*@p_04*GEOM*rotation SET " & (90+ tmpPieTotal))
       end if
       tmpPieTotal = tmpPieTotal + mvPie4
       if mvCount5 > 0 then
          buffer_put("-1 RENDERER*TREE*@p_05*GEOM*rotation SET " & (90+ tmpPieTotal))
       end if
       tmpPieTotal = tmpPieTotal + mvPie5

       Call SetMaterial("p_01",tbCumhur.UTF8Text)
       buffer_put("-1 RENDERER*TREE*@p_01*MATERIAL SET MATERIAL*SECIM_2023/CNN/PARTI_MATERIAL/" & ePARTI_CumhurIttifakiToplam)
       Call SetMaterial("p_02",tbMillet.UTF8Text)
       buffer_put("-1 RENDERER*TREE*@p_02*MATERIAL SET MATERIAL*SECIM_2023/CNN/PARTI_MATERIAL/" & ePARTI_MilletIttifakiToplam)
       Call SetMaterial("p_03",tbEmek.UTF8Text)
       buffer_put("-1 RENDERER*TREE*@p_03*MATERIAL SET MATERIAL*SECIM_2023/CNN/PARTI_MATERIAL/" & ePARTI_EmekveOzgurlukIttifakiToplam)
       Call SetMaterial("p_04",tbAta.UTF8Text)
       buffer_put("-1 RENDERER*TREE*@p_04*MATERIAL SET MATERIAL*SECIM_2023/CNN/PARTI_MATERIAL/" & ePARTI_ATAIttifakiToplam)
       Call SetMaterial("p_05",tbSosyalist.UTF8Text)
       buffer_put("-1 RENDERER*TREE*@p_05*MATERIAL SET MATERIAL*SECIM_2023/CNN/PARTI_MATERIAL/" & ePARTI_SosyalistGucBirligiIttifakiToplam)
End Sub

'# VIZ KOMUTLARI

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

Sub LoadSceneButtonClickClick(Sender)
        Call LoadScene("SECIM_2023/CNN/SAHNELER/2_TUR","/mv_ittifak_meclis")
End sub

Sub Btn_Yayindan_AlClick(Sender)
        btnYayindaSabit.Visible = False
        btnYayindaSirali.Visible = False
        buffer_clear()
        buffer_put("-1 RENDERER SET_OBJECT ")
        buffer_send(main_machine)
End sub

Sub cbSiraliVerClick(Sender)
'gbIttifaklar.Visible = true
btnVerileriGuncelle.Enabled = true
End sub

Sub cbMvGosterClick(Sender)
SendToVizButtonClick.Enabled = true
End sub