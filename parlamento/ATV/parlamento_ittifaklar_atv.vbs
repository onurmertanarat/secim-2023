'USEUNIT Factory
'USEUNIT Config
'USEUNIT ErrorDef
'USEUNIT LibFunc
'USEUNIT Database
'USEUNIT Log
'USEUNIT Registry
'USEUNIT Consts

Option Explicit

Dim currentCumhur : currentCumhur = eSP_2023Cumhurbaskanligi
Dim currentGenel : currentGenel = eSP_2023Genel
Dim idDataSource : idDataSource = eDS_TUIK
Dim idPartiOrderType : idPartiOrderType = ePOT_Pusula
Dim bagimsizDetayli : bagimsizDetayli =  ePRM_BagimsizDetay_NO
Dim cumhurID : cumhurID = ePARTI_CumhurIttifaki
Dim milletID : milletID = ePARTI_MilletIttifaki
Dim idScTr : idScTr = 0
Dim arrScBolgeIds(81)
Dim arrKazananMilletIds(81)
Dim arrWinners()
Dim toplamMVSayisi : toplamMVSayisi = 600

Dim main_machine

Sub InitForm()
       UninitClass()
       Dim ret : ret = InitClass([_template],[_scripter])
       If ret <> CFnRetOk Then
          MsgBox "Hata : Class' lar Init edilemedi"
          Exit Sub
       End If
       InnerInitForm()
End Sub

Function TemplateCloseQuery
  UninitClass()
End Function

Sub InnerInitForm()
       ClearTextboxes()
End Sub

Sub GetDatasIttifaks(idSecim, idSource)
  Dim arrSonuc()
  Dim i
  Dim partiSayisi : partiSayisi =26
  'Call g_db.SonucListesiDetay(arrSonuc, idScTr, currentGenel, idDataSource, idPartiOrderType, bagimsizDetayli, ePRM_IttifakVariant_YES, partiSayisi, true)
  Call g_db.SonucListesiDetayOnlyIttifak(arrSonuc, idScTr , currentGenel, idDataSource, idPartiOrderType)
  Dim adaySonuc1
  Set adaySonuc1 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_CumhurIttifakiToplam)

  Dim adaySonuc2
  Set adaySonuc2 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_MilletIttifakiToplam)

  Dim adaySonuc3
  Set adaySonuc3 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_EmekveOzgurlukIttifakiToplam)

  Dim adaySonuc4
  Set adaySonuc4 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_ATAIttifakiToplam)

  Dim adaySonuc5
  Set adaySonuc5 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_SosyalistGucBirligiIttifakiToplam)

  tbCumhurMv.UTF8Text = adaySonuc1.mvB
  tbMilletMv.UTF8Text = adaySonuc2.mvB
  tbEmekMv.UTF8Text = adaySonuc3.mvB
  tbAtaMv.UTF8Text = adaySonuc4.mvB
  tbSosyalistMv.UTF8Text = adaySonuc5.mvB

End Sub

Sub GetDatasPartiler(idSecim, idSource)
  Dim arrSonuc()
  Dim partiSayisi : partiSayisi = 26

  Call g_db.SonucListesiTamDetay(arrSonuc, idScTr, idSecim, idDataSource, idPartiOrderType, bagimsizDetayli, ePRM_IttifakVariant_NO, partiSayisi, true)

  Dim adaySonuc1
  Set adaySonuc1 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_BBP)
  Dim adaySonuc2
  Set adaySonuc2 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_AKP)
  Dim adaySonuc3
  Set adaySonuc3 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_Y_REFAH)
  Dim adaySonuc4
  Set adaySonuc4 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_MHP)
  Dim adaySonuc5
  Set adaySonuc5 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_CHP)
  Dim adaySonuc6
  Set adaySonuc6 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_IYI)
  Dim adaySonuc7
  Set adaySonuc7 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_YSP)
  Dim adaySonuc8
  Set adaySonuc8 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_TIP)
  Dim adaySonuc9
  Set adaySonuc9 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_ADALET)
  Dim adaySonuc10
  Set adaySonuc10 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_ZP)
  Dim adaySonuc11
  Set adaySonuc11 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_TKP)
  Dim adaySonuc12
  Set adaySonuc12 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_TKH)
  Dim adaySonuc13
  Set adaySonuc13 = g_lib.GetPartiSonuc(arrSonuc, ePARTI_SOLPARTI)

  tbBBPYuzde.UTF8Text = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc1.yuzde,txtUstHane.UTF8Text)
  tbAkPartiYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc2.yuzde,txtUstHane.UTF8Text)
  tbYRPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc3.yuzde,txtUstHane.UTF8Text)
  tbMHPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc4.yuzde,txtUstHane.UTF8Text)
  tbCHPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc5.yuzde,txtUstHane.UTF8Text)
  tbIyiPartiYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc6.yuzde,txtUstHane.UTF8Text)
  tbYSPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc7.yuzde,txtUstHane.UTF8Text)
  tbTIPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc8.yuzde,txtUstHane.UTF8Text)
  tbAPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc9.yuzde,txtUstHane.UTF8Text)
  tbZPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc10.yuzde,txtUstHane.UTF8Text)
  tbTKPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc11.yuzde,txtUstHane.UTF8Text)
  tbTKHYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc12.yuzde,txtUstHane.UTF8Text)
  tbSPYuzde.UTF8Text  = g_lib.YuzdeKorumaYuvarlamaDigit(adaySonuc13.yuzde,txtUstHane.UTF8Text)

  Call GetDatasDiger(tbDigerYuzde, tbDigerMv)

  Redim arrWinners(600)
  Dim tempCount : tempCount = 0
  Dim a
  for a = 0 to (CInt(findcomponent("tbCumhurMv").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent("txtId"&"1").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent("tbMilletMv").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent("txtId"&"2").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent("tbEmekMv").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent("txtId"&"3").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent("tbAtaMv").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent("txtId"&"4").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent("tbSosyalistMv").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent("txtId"&"5").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent("tbDigerMv").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent("txtId"&"6").UTF8Text
      tempCount = tempCount + 1
  Next
End Sub

Sub btnVerileriGuncelleClick(Sender)
SendToVizButtonClick.Enabled = true
        tbSecimCevresi.UTF8Text = "TÜRKİYE GENELİ"
        Dim acilansandik
        acilansandik = g_db.AcilanSandikYuzdeDetay(idScTr, currentGenel, idDataSource, true)
        tbAcilanSandik.UTF8Text = g_lib.YuzdeKorumaYuvarlama(acilansandik)

        Call GetDatasIttifaks(currentGenel, idDataSource)

        Call GetDatasPartiler(currentGenel, idDataSource)



        KazananIllerIttifaks()
End sub

Sub GetDatasDiger(digerYuzde, digerMv)
        digerYuzde.UTF8Text = g_lib.YuzdeKorumaYuvarlamaDigit((100 - CDbl(CDbl(tbBBPYuzde.UTF8Text)+CDbl(tbAkPartiYuzde.UTF8Text)+CDbl(tbYRPYuzde.UTF8Text)+CDbl(tbMHPYuzde.UTF8Text)+CDbl(tbCHPYuzde.UTF8Text)+CDbl(tbIyiPartiYuzde.UTF8Text)+CDbl(tbYSPYuzde.UTF8Text)+CDbl(tbTIPYuzde.UTF8Text)+CDbl(tbAPYuzde.UTF8Text)+CDbl(tbZPYuzde.UTF8Text)+CDbl(tbTKPYuzde.UTF8Text)+CDbl(tbTKHYuzde.UTF8Text)+CDbl(tbSPYuzde.UTF8Text))),txtUstHane.UTF8Text)
        digerMv.UTF8Text = 600 - CInt(CInt(tbCumhurMv.UTF8Text)+CInt(tbMilletMv.UTF8Text)+CInt(tbEmekMv.UTF8Text)+CInt(tbAtaMv.UTF8Text)+CInt(tbSosyalistMv.UTF8Text))
End Sub

Sub KazananIllerIttifaks()
        Dim countCumhurIttifaki
        countCumhurIttifaki = 0
        Dim countMilletIttifaki
        countMilletIttifaki = 0
        Dim countEmekIttifaki
        countEmekIttifaki = 0
        Dim countAtaIttifaki
        countAtaIttifaki = 0
        Dim countSosyalistIttifaki
        countSosyalistIttifaki = 0
        Dim countBgmz
        countBgmz = 0

       Dim partiSayisi:partiSayisi = 28

       Dim arrSehirSonuc
       Dim arrSehirler()

       Call g_db.SehirListesi(arrSehirler, ePRM_AddTurkiye_NO  , ePRM_AddBolge_NO)

        Dim j
        For j = 0 To 80
            Dim idSC : idSC = arrSehirler(j).id
            arrScBolgeIds(j) = arrSehirler(j).id

            Call g_db.SonucListesiDetayOnlyIttifak(arrSehirSonuc, idSC , currentGenel, idDataSource, idPartiOrderType)
            arrKazananMilletIds(j) = arrSehirSonuc(0).idParti
        Next

       Dim i
       For i = 0 To 80
           Dim idSC1 : idSC1 = arrScBolgeIds(i)
           If (countCumhurIttifaki + countMilletIttifaki + countEmekIttifaki + countAtaIttifaki + countSosyalistIttifaki) > 81 Then
                MsgBox "İl sınır aşımına uğradı"
                Exit Sub
           Else

                If (arrKazananMilletIds(i)=ePARTI_CumhurIttifakiToplam) Then
                        countCumhurIttifaki = countCumhurIttifaki + 1
                ElseIf (arrKazananMilletIds(i)=ePARTI_MilletIttifakiToplam) Then
                        countMilletIttifaki  = countMilletIttifaki  + 1
                ElseIf (arrKazananMilletIds(i)=ePARTI_ATAIttifakiToplam) Then
                        countAtaIttifaki  = countAtaIttifaki  + 1
                ElseIf (arrKazananMilletIds(i)=ePARTI_EmekveOzgurlukIttifakiToplam) Then
                        countEmekIttifaki  = countEmekIttifaki  + 1
                ElseIf (arrKazananMilletIds(i)=ePARTI_SosyalistGucBirligiIttifakiToplam) Then
                        countSosyalistIttifaki  = countSosyalistIttifaki  + 1
                ElseIf (arrKazananMilletIds(i)=ePARTI_BGMZ) Then
                        countBgmz  = countBgmz  + 1
                End If

           End If

       Next

       tbCumhurIl.UTF8Text = countCumhurIttifaki
       tbMilletIl.UTF8Text = countMilletIttifaki
       tbAtaIl.UTF8Text = countAtaIttifaki
       tbEmekIl.UTF8Text = countEmekIttifaki
       tbSosyalistIl.UTF8Text = countSosyalistIttifaki
       tbDigerIl.UTF8Text = countBgmz
End Sub

Sub ClearTextboxes()
tbSecimCevresi.UTF8Text = ""
tbAcilanSandik.UTF8Text = ""
tbBBPYuzde.UTF8Text = ""
tbAkPartiYuzde.UTF8Text = ""
tbYRPYuzde.UTF8Text = ""
tbMHPYuzde.UTF8Text = ""
tbCumhurIl.UTF8Text = ""
tbCumhurMv.UTF8Text = ""
tbCHPYuzde.UTF8Text = ""
tbIyiPartiYuzde.UTF8Text = ""
tbMilletIl.UTF8Text = ""
tbMilletMv.UTF8Text = ""
tbYSPYuzde.UTF8Text = ""
tbTIPYuzde.UTF8Text = ""
tbMilletIl.UTF8Text = ""
tbMilletMv.UTF8Text = ""
tbYSPYuzde.UTF8Text = ""
tbTIPYuzde.UTF8Text = ""
tbEmekIl.UTF8Text = ""
tbEmekMv.UTF8Text = ""
tbAPYuzde.UTF8Text = ""
tbZPYuzde.UTF8Text = ""
tbAtaIl.UTF8Text = ""
tbAtaMv.UTF8Text = ""
tbTKPYuzde.UTF8Text = ""
tbTKHYuzde.UTF8Text = ""
tbSPYuzde.UTF8Text = ""
tbSosyalistIl.UTF8Text = ""
tbSosyalistMv.UTF8Text = ""
tbDigerYuzde.UTF8Text = ""
tbDigerMv.UTF8Text = ""
tbDigerIl.UTF8Text = ""
End Sub

Sub LoadSceneButtonClickClick(Sender)
  buffer_clear()

  buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&" SET_OBJECT SCENE*SECIM_2023/ATV_SECIM_2023/IC_EKRANLAR/MILLETVEKILLIGI_2_TUR/ONAIR/113_MV_MECLIS_ITTIFAKLAR")
  buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*STAGE SHOW 0")

  buffer_send(main_machine)
End sub

Sub Btn_Yayindan_AlClick(Sender)
  buffer_clear()

  buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&" SET_OBJECT ")

  buffer_send(main_machine)
End sub

Sub PaintParlamento()
    Dim a
    for a = 1 to 600
       buffer_put("-1 RENDERER*TREE*@"&a&"*FUNCTION*DataMaterialIndex*offset SET 0")
    Next

    Dim i
    for i = 0 to 599
        buffer_put("-1 RENDERER*TREE*@"&(i+1)&"*FUNCTION*DataMaterialIndex*offset SET "& SetId(arrWinners(i)))
    Next
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=")
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=0;")

Call Playanim("MECLIS")
End Sub
Function SetId(id)
            if id > 400  then
                if id = 402 then id = 230
                if id = 403 then id = 231
                if id = 406 then id = 232
                if id = 407 then id = 233
                if id = 409 then id = 234
            else
                id = id
            end if
            SetId = id
End Function

Sub SendToVizButtonClickClick(Sender)
  Dim tempHane
  tempHane = CInt(txtUstHane.UTF8Text)
  Dim counterHashTag

  if tempHane = 1 then
     counterHashTag = "#"
  elseif tempHane = 2 then
     counterHashTag = "##"
  elseif tempHane = 3 then
     counterHashTag = "###"
  end if
SendToVizButtonClick.Enabled = false
buffer_clear()

    Call SetAcilanSandikToViz(tbAcilanSandik,"TG_SOL_ASS_PUAN1","TG_SOL_ASS_PUAN2","SIRA1_NOKTA_SABIT","TG_ASS_bar_value","TG_SOL_ASS")

    Call SayiSplitSendToViz(findcomponent("tbBBPYuzde"),"sira1_oran1","sira1_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbAkPartiYuzde"),"sira2_oran1","sira2_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbYRPYuzde"),"sira3_oran1","sira3_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbMHPYuzde"),"sira4_oran1","sira4_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbCHPYuzde"),"sira5_oran1","sira5_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbIyiPartiYuzde"),"sira6_oran1","sira6_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbYSPYuzde"),"sira7_oran1","sira7_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbTIPYuzde"),"sira8_oran1","sira8_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbAPYuzde"),"sira9_oran1","sira9_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbZPYuzde"),"sira10_oran1","sira10_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbTKPYuzde"),"sira11_oran1","sira11_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbTKHYuzde"),"sira12_oran1","sira12_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbSPYuzde"),"sira13_oran1","sira13_oran2", "")
    Call SayiSplitSendToViz(findcomponent("tbDigerYuzde"),"sira14_oran1","sira14_oran2", "")

    buffer_put("-1 RENDERER*TREE*@sira1_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira2_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira3_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira4_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira5_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira6_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira7_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira8_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira9_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira10_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira11_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira12_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira13_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)
    buffer_put("-1 RENDERER*TREE*@sira14_oran2*FUNCTION*Advanced_Counter*inpmask SET "&counterHashTag)

    Call SetImage("sira1_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblBBPId.UTF8Text)
    Call SetImage("sira2_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblAkPartiId.UTF8Text)
    Call SetImage("sira3_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblYRPId.UTF8Text)
    Call SetImage("sira4_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblMHPId.UTF8Text)
    Call SetImage("sira5_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblChpId.UTF8Text)
    Call SetImage("sira6_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblIyiId.UTF8Text)
    Call SetImage("sira7_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblYspId.UTF8Text)
    Call SetImage("sira8_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblTipId.UTF8Text)
    Call SetImage("sira9_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblApId.UTF8Text)
    Call SetImage("sira10_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblZaferId.UTF8Text)
    Call SetImage("sira11_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblTkpId.UTF8Text)
    Call SetImage("sira12_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblTkhId.UTF8Text)
    Call SetImage("sira13_logo", "SECIM_2023/ATV_SECIM_2023/PARTI_LOGOLAR/"&lblSpId.UTF8Text)

    Call SetText("cumhur_toplam_il", tbCumhurIl.UTF8Text)
    Call SetText("millet_toplam_il", tbMilletIl.UTF8Text)
    Call SetText("emek_toplam_il", tbEmekIl.UTF8Text)
    Call SetText("ata_toplam_il", tbAtaIl.UTF8Text)
    Call SetText("sosyalist_toplam_il", tbSosyalistIl.UTF8Text)
    Call SetText("diger_toplam_il", tbSosyalistIl.UTF8Text)

    Call SetText("cumhur_toplam_mv", tbCumhurMv.UTF8Text)
    Call SetText("millet_toplam_mv", tbMilletMv.UTF8Text)
    Call SetText("emek_toplam_mv", tbEmekMv.UTF8Text)
    Call SetText("ata_toplam_mv", tbAtaMv.UTF8Text)
    Call SetText("sosyalist_toplam_mv", tbSosyalistMv.UTF8Text)
    Call SetText("diger_toplam_mv", tbSosyalistMv.UTF8Text)

    Call PlayAnim("IN")
    PaintParlamento()
    buffer_send(main_machine)
End sub

Sub SetKeyframe(ControlName, KeyName, Command, Txt)
    buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*TREE*@"&ControlName&"*ANIMATION*KEY*$"&KeyName&"*"&Command&" SET " & Txt)
End Sub

Sub SetText(ControlName, Txt)
    buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*TREE*@"&ControlName&"*GEOM*TEXT SET "&Txt)
End Sub
Sub SetImage(ControlName, Path)
    buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*TREE*@"&ControlName&"*IMAGE SET IMAGE*"&Path)
End Sub
Sub PlayAnim(AnimName)  '  Buffer clear ediyor ve gönderiyor. Buffer oluşturulan blokların içinden çağrılmamalı!
    buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*STAGE*DIRECTOR*" & AnimName & "*DIRECTION SET")
    buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*STAGE*DIRECTOR*" & AnimName & " START")
End Sub

Sub SetAcilanSandikToViz(txtAcilanSandik, asspuan1, asspuan2, noktasabit, pie, animName)
        Dim tempAcilanSandik : tempAcilanSandik = g_lib.YuzdeKorumaYuvarlama(txtAcilanSandik.UTF8Text)
        if g_lib.CDblSafe(tempAcilanSandik) = 100 then
                Call SetKeyframe(asspuan1, "End", "VALUE", tempAcilanSandik)
                buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*TREE*@"&asspuan2&"*ACTIVE SET 0")
                buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*TREE*@"&noktasabit&"*ACTIVE SET 0")
        else
                buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*TREE*@"&asspuan2&"*ACTIVE SET 1")
                buffer_put("-1 RENDERER*"&cbLayer.Items(cbLayer.ItemIndex)&"*TREE*@"&noktasabit&"*ACTIVE SET 1")
                Call SetKeyframe(asspuan1, "End", "VALUE", g_lib.SplitYuzdeTamSayiYuvarlamasiz(tempAcilanSandik))
                Call SetKeyframe(asspuan2, "End", "VALUE", g_lib.SplitYuzdeOndalikYuvarlamasiz(tempAcilanSandik))
        end if
        Call SetKeyframe(pie, "End", "VALUE", tempAcilanSandik)

        PlayAnim(animName)
End Sub

Sub SayiSplitSendToViz(txtYuzde,yuzdelikControl,ondalikControl, pieControl)

  Dim tempValue : tempValue= txtYuzde.UTF8Text

  Call SetKeyframe(yuzdelikControl, "End", "VALUE", g_lib.SplitYuzdeTamSayiYuvarlamasiz(tempValue))
  Call SetKeyframe(ondalikControl, "End", "VALUE",g_lib.SplitYuzdeOndalikYuvarlamasiz(tempValue))
  'Call SetKeyframe(pieControl, "End", "VALUE", tempValue)
End Sub

Sub btnUstHaneUpClick(Sender)
  Dim val : val = CInt(txtUstHane.UTF8Text)
  val = val + 1
  if val > 3 then
    val = 3
  end if
  txtUstHane.UTF8Text = val
End sub

Sub btnUstHaneDownClick(Sender)
  Dim val : val = CInt(txtUstHane.UTF8Text)
  val = val - 1
  if val < 1 then
    val = 1
  end if
  txtUstHane.UTF8Text = val
End sub