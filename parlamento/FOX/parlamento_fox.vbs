'USEUNIT Factory
'USEUNIT Config
'USEUNIT ErrorDef
'USEUNIT LibFunc
'USEUNIT Database
'USEUNIT Log
'USEUNIT Registry
'USEUNIT Consts

Option Explicit

Dim main_machine
Dim GFX : GFX = ""

Dim currentCumhur : currentCumhur = eSP_2023Cumhurbaskanligi_2Tur
Dim currentGenel : currentGenel = eSP_2023Genel
Dim idDataSource : idDataSource = eDS_TUIK
Dim idPartiOrderType : idPartiOrderType = ePOT_Pusula
Dim bagimsizDetayli : bagimsizDetayli =  ePRM_BagimsizDetay_NO
dim cumhurID : cumhurID = ePARTI_CumhurIttifaki
dim milletID : milletID = ePARTI_MilletIttifaki
dim idScTR : idScTR = 0
Dim toplamMVSayisi : toplamMVSayisi = 600
Dim arrWinners()
Dim arrWinners2()
Dim countClick : countClick = 0

Dim arrParti(7, 2)
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
    btn2018Ver.Enabled = true
    TWUniButton1.Enabled = false
    Call g_lib.ListBoxClear(lbPartiler)
    Call g_lib.ListBoxClear(lbHavuz)
    rdPartiler.Checked = false
    rdIttifak.Checked = true
    btn2018Ver.Enabled = false
    TWUniButton1.Enabled = false
    ButtonsPassive()
    ClearTextboxesAll()
End Sub

Sub FillPartiListesi()
     Call g_lib.ListBoxClear(lbPartiler)
     Dim arrSonuc()
     Call g_db.PartiListesiDetay(arrSonuc, currentGenel, ePOT_Alfabe, bagimsizDetayli)
     Call g_lib.ListBoxInsertArray(lbPartiler, arrSonuc)
End Sub

Sub ClearTextboxesAll()
       dim q
       for q=1 to 8 step 1
                findcomponent("UpPartiAdiG"&q).UTF8Text = ""
                findcomponent("UpPartiYuzdeG"&q).UTF8Text = ""
                findcomponent("UpPartiMvG"&q).UTF8Text = ""
       next
       dim w
       for w=1 to 6 step 1
               findcomponent("IttifakAdiAA"&w).UTF8Text = ""
               findcomponent("IttifakYuzdeAA"&w).UTF8Text = ""
               findcomponent("IttifakMvAA"&w).UTF8Text = ""
       next
       txtAcilanSandikBilgisi.UTF8Text = ""
End Sub

Sub ButtonsPassive()
        btnYayindaPartilerAA.Visible = false
        btnYayindaIttifaklarAA.Visible = false
End Sub

Sub GetDatasAA()
       Call GetPartilerMv(0, ajansAA, "UpPartiIdG","UpPartiAdiG","UpPartiYuzdeG","UpPartiMvG", txtAcilanSandikBilgisi)
End Sub

Sub GetPartilerMv(idSC, ajans, ittifakVariant, txtId,txtName,txtOy,txtMv, txtAcilan)
  Dim arrSonuc()
  Dim acilanSandik
  Dim partiSayisi : partiSayisi = 8
  Dim arrPartiIds(50)
  Dim arrPartiNames(50)
  Dim arrPartiMvs(50)
  Dim arrPartiOy(50)

  acilansandik = g_db.AcilanSandikYuzdeDetay(idSC, currentGenel, ajans, true)
  txtAcilan.UTF8Text = g_lib.YuzdeKorumaYuvarlama(acilansandik)

  Call g_db.SonucListesiTamDetayOrderByMv(arrSonuc, idSC, currentGenel, ajans, idPartiOrderType, bagimsizDetayli, ittifakVariant, partiSayisi, true, 1)
  if Not g_lib.IsInitialized(arrSonuc) then exit sub

  Dim i
  for i = 0 to UBound(arrSonuc)

        If arrSonuc(i).mvB > 0 Then
                lbPartiler.Items.Add(arrSonuc(i).nameShort)
                lbPartiler.ListIDs.Add(arrSonuc(i).idParti)
        Else

        End If
        findcomponent(txtName&""&(i+1)).UTF8Text = arrSonuc(i).nameShort
        findcomponent(txtOy&""&(i+1)).UTF8Text = g_lib.YuzdeKorumaYuvarlama(arrSonuc(i).yuzde)
        findcomponent(txtId&""&(i+1)).UTF8Text = arrSonuc(i).idParti
        findcomponent(txtMv&""&(i+1)).UTF8Text = arrSonuc(i).mvB
  next

  Redim arrWinners(600)
  Dim tempCount : tempCount = 0
  Dim a
  for a = 0 to (CInt(findcomponent(txtMv&"1").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"1").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"2").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"2").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"3").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"3").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"4").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"4").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"5").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"5").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"6").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"6").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"7").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"7").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"8").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"8").UTF8Text
      tempCount = tempCount + 1
  Next
End Sub

Sub GetIttifaklarMv(idSC, ajans, ittifakVariant, txtId,txtName,txtOy,txtMv, txtAcilan)
Dim arrSonuc()
  Dim acilanSandik
  Dim ittifakSayisi : ittifakSayisi = 6
  acilansandik = g_db.AcilanSandikYuzdeDetay(idSC, currentGenel, ajans, true)
  txtAcilan.UTF8Text = g_lib.YuzdeKorumaYuvarlama(acilansandik)

  Call g_db.SonucListesiTamDetayOrderByMv(arrSonuc, idSC, currentGenel, ajans, idPartiOrderType, bagimsizDetayli, ittifakVariant, ittifakSayisi, true, 1)
  if Not g_lib.IsInitialized(arrSonuc) then exit sub

  Dim i
  for i = 0 to UBound(arrSonuc)

        If arrSonuc(i).mvB > 0 Then
                lbPartiler.Items.Add(g_lib.Buyut(arrSonuc(i).nameShort))
                lbPartiler.ListIDs.Add(arrSonuc(i).idParti)
        Else

        End If

                findcomponent(txtName&""&(i+1)).UTF8Text = g_lib.Buyut(Replace(arrSonuc(i).nameShortResmi," İttifakı Toplam Oyu",""))
                findcomponent(txtOy&""&(i+1)).UTF8Text = g_lib.YuzdeKorumaYuvarlamaDigit(arrSonuc(i).yuzde,1)
                findcomponent(txtId&""&(i+1)).UTF8Text = arrSonuc(i).idParti
                findcomponent(txtMv&""&(i+1)).UTF8Text = arrSonuc(i).mvB
  next

  Redim arrWinners(600)
  Dim tempCount : tempCount = 0
  Dim a
  for a = 0 to (CInt(findcomponent(txtMv&"1").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"1").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"2").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"2").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"3").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"3").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"4").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"4").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"5").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"5").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"6").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"6").UTF8Text
      tempCount = tempCount + 1
  Next
End Sub

Sub btnVerileriGuncelleClick(Sender)
        Call g_lib.ListBoxClear(lbPartiler)
        Call g_lib.ListBoxClear(lbHavuz)
        SendToVizButtonClick.Enabled = true

       if rdPartiler.Checked = true then
       '#1
                Call GetPartilerMv(0, idDataSource, ePRM_IttifakVariant_NO, "UpPartiIdG","UpPartiAdiG","UpPartiYuzdeG","UpPartiMvG", txtAcilanSandikBilgisi)
       elseif rdIttifak.Checked = true then
       '#2
                Call GetIttifaklarMv(0, idDataSource, ePRM_IttifakVariant_YES, "IttifakIdAA","IttifakAdiAA","IttifakYuzdeAA","IttifakMvAA", txtAcilanSandikBilgisi)
       else
                exit sub
       end if

End sub

Sub LoadSceneButtonClickClick(Sender)
    buffer_clear()
    buffer_put("-1 RENDERER SET_OBJECT SCENE*SECIM_2023/FOX/SAHNELER_2TUR/05_meclis_dagilimi")
    buffer_put("-1 RENDERER*STAGE SHOW 0")
    buffer_send(main_machine)
End sub

Sub Btn_Yayindan_AlClick(Sender)
    buffer_clear()
    buffer_put("-1 RENDERER SET_OBJECT ")
    buffer_send(main_machine)
End sub

Sub LoadScene(path, sceneName)
        buffer_clear()
        buffer_put("-1 RENDERER SET_OBJECT SCENE*" & path & sceneName)
        buffer_put("-1 RENDERER*STAGE SHOW 0")
        buffer_send(main_machine)
End Sub

Sub ClearScene()
        buffer_clear()
        buffer_put("-1 RENDERER SET_OBJECT ")
        buffer_send(main_machine)
End Sub

Sub PlayAnim(animName)
        buffer_put("-1 RENDERER*STAGE*DIRECTOR*" & animName & "*DIRECTION SET")
        buffer_put("-1 RENDERER*STAGE*DIRECTOR*" & animName & " START")
End Sub

Sub ContinueAnim(animName)
        buffer_put("-1 RENDERER*STAGE*DIRECTOR*" & animName & " CONTINUE")
End Sub

Sub KeyframeTransformation(controlName, keyName, dataType ,xyz, text)
        buffer_put("-1 RENDERER*TREE*@"&controlName&"*TRANSFORMATION*"&dataType&"*ANIMATION*KEY*$"&keyName&"*VALUE*"&xyz&" SET " & text)
End Sub

Sub SetKeyframe(controlName, keyName, command, text)
        buffer_put("-1 RENDERER*TREE*@"&controlName&"*ANIMATION*KEY*$"&keyName&"*"&command&" SET " & text)
End Sub

Sub SetText(controlName, text)
        buffer_put("-1 RENDERER*TREE*@"&controlName&"*GEOM*TEXT SET "&text)
End Sub

Sub SetImage(controlName, path)
        buffer_put("-1 RENDERER*TREE*@"&controlName&"*IMAGE SET IMAGE*"&path)
End Sub

Sub SetActive(controlName, state)
        buffer_put("-1 RENDERER*TREE*@"&controlName&"*ACTIVE SET "&state)
End Sub

Sub SetMaterial(controlName, path)
        buffer_put("-1 RENDERER*TREE*@"&controlName&"*MATERIAL SET "&path)
End Sub

Sub PaintParlamentoYasakli()
    Dim a
    for a = 1 to 600
       buffer_put("-1 RENDERER*TREE*@"&a&"*FUNCTION*DataMaterialIndex*offset SET 0")
    Next

   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=")
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=0;")

   Playanim("PARLAMENTO")
End Sub

Sub SendToVizButtonClickClick(Sender)
        Timer1.Enabled = true
        SendToVizButtonClick.enabled = false
       ' btn2018Ver.Enabled = true

        Call SetActive("SANDIKGRUP", 0)
        Call SetText("toplam_mv", lbl600.UTF8Text)

       if rdPartiler.Checked = true then
       '#1
                        btnYayindaPartilerAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = false
                        btnYayindaPartilerAA.Visible = true

                        buffer_clear()

                        Call SetActive("1GRUP","0")
                        Call SetActive("2GRUP","0")
                        Call SetActive("3GRUP","0")
                        Call SetActive("4GRUP","0")
                        Call SetActive("5GRUP","0")
                        Call SetActive("6GRUP","0")
                        Call SetActive("7GRUP","0")
                        Call SetActive("8GRUP","0")
                        Call SetActive("ust","0")
                        Call SetActive("alt","0")

                        dim cntr:cntr = 0
                        dim a

                        for a = 1 to 8 step 1
                            if CInt(findcomponent("UpPartiMvG"&a).UTF8Text) > 0 then
                                  cntr = cntr +1
                            end if
                        next

                        if cntr <= 4 then
                              Call SetActive("ust2", "1")
                              if cntr = 1 then
                                 Call SetActive("1GRUP", "1")
                              elseif cntr = 2 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                              elseif cntr = 3 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                              elseif cntr = 4 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                                Call SetActive("4GRUP", "1")
                              end if

                              dim b5
                              for b5 = 1 to 4 step 1
                                Call SetText(b5&"mv", findcomponent("UpPartiMvG"&b5).UTF8Text)
                                Call SetText(b5&"isim", findcomponent("UpPartiAdiG"&b5).UTF8Text)
                                Call SetImage(b5&"logo", "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("UpPartiIdG"&b5).UTF8Text)
                                Call SetImage(b5&"renk", "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("UpPartiIdG"&b5).UTF8Text)
                              next

                        elseif cntr > 4 then
                               Call SetActive("ust", "1")
                               Call SetActive("alt", "1")
                                if cntr = 5 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        dim b
                                        for b = 1 to 3 step 1
                                            Call SetText(b&"mv", findcomponent("UpPartiMvG"&b).UTF8Text)
                                            Call SetText(b&"isim", findcomponent("UpPartiAdiG"&b).UTF8Text)
                                            Call SetImage(b&"logo", "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("UpPartiIdG"&b).UTF8Text)
                                            Call SetImage(b&"renk", "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("UpPartiIdG"&b).UTF8Text)
                                        next
                                        dim c
                                        for c = 5 to 6 step 1
                                            Call SetText(c&"mv", findcomponent("UpPartiMvG"&(c-1)).UTF8Text)
                                            Call SetText(c&"isim", findcomponent("UpPartiAdiG"&(c-1)).UTF8Text)
                                            Call SetImage(c&"logo", "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("UpPartiIdG"&(c-1)).UTF8Text)
                                            Call SetImage(c&"renk", "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("UpPartiIdG"&(c-1)).UTF8Text)
                                        next
                                elseif cntr = 6 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        dim d
                                        for d = 1 to 4 step 1
                                            Call SetText(d&"mv", findcomponent("UpPartiMvG"&d).UTF8Text)
                                            Call SetText(d&"isim", findcomponent("UpPartiAdiG"&d).UTF8Text)
                                            Call SetImage(d&"logo", "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("UpPartiIdG"&d).UTF8Text)
                                            Call SetImage(d&"renk", "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("UpPartiIdG"&d).UTF8Text)
                                        next
                                        dim e
                                        for e = 5 to 8 step 1
                                            Call SetText(e&"mv", findcomponent("UpPartiMvG"&(e-1)).UTF8Text)
                                            Call SetText(e&"isim", findcomponent("UpPartiAdiG"&(e-1)).UTF8Text)
                                            Call SetImage(e&"logo", "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("UpPartiIdG"&(e-1)).UTF8Text)
                                            Call SetImage(e&"renk", "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("UpPartiIdG"&(e-1)).UTF8Text)
                                        next
                                elseif cntr = 7 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("4GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        Call SetActive("8GRUP", "1")
                                        dim f
                                        for f = 1 to 4 step 1
                                            Call SetText(f&"mv", findcomponent("UpPartiMvG"&f).UTF8Text)
                                            Call SetText(f&"isim", findcomponent("UpPartiAdiG"&f).UTF8Text)
                                            Call SetImage(f&"logo", "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("UpPartiIdG"&f).UTF8Text)
                                            Call SetImage(f&"renk", "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("UpPartiIdG"&f).UTF8Text)
                                        next
                                        dim g
                                        for g = 6 to 8 step 1
                                            Call SetText(g&"mv", findcomponent("UpPartiMvG"&(g-1)).UTF8Text)
                                            Call SetText(g&"isim", findcomponent("UpPartiAdiG"&(g-1)).UTF8Text)
                                            Call SetImage(g&"logo", "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("UpPartiIdG"&(g-1)).UTF8Text)
                                            Call SetImage(g&"renk", "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("UpPartiIdG"&(g-1)).UTF8Text)
                                        next
                                else
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("4GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        Call SetActive("8GRUP", "1")
                                        dim h
                                        for h = 1 to 8 step 1
                                            Call SetText(h&"mv", findcomponent("UpPartiMvG"&h).UTF8Text)
                                            Call SetText(h&"isim", findcomponent("UpPartiAdiG"&h).UTF8Text)
                                            Call SetImage(h&"logo", "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("UpPartiIdG"&h).UTF8Text)
                                            Call SetImage(h&"renk", "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("UpPartiIdG"&h).UTF8Text)
                                        next
                                end if
                        end if

                        PlayAnim("LOOP")
                        PlayAnim("GELIS")
                        PlayAnim("PARLAMENTO")
                        PlayAnim("MECLIS_SONUCLARI_2")
                        PaintParlamento()
                        buffer_send(main_machine)

       elseif rdIttifak.Checked = true then
       '#2
                        btnYayindaPartilerAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = true

                        buffer_clear()

                        Call SetActive("GRUP1","0")
                        Call SetActive("GRUP2","0")
                        Call SetActive("GRUP3","0")
                        Call SetActive("GRUP4","0")
                        Call SetActive("GRUP5","0")
                        Call SetActive("GRUP6","0")
                        Call SetActive("GRUP7","0")
                        Call SetActive("GRUP8","0")
                        Call SetActive("ust","0")
                        Call SetActive("alt","0")

                        dim h9
                        for h9 = 1 to 8 step 1
                                Call SetActive("isim"& h9, "0")
                                Call SetActive("ittifaklogo"& h9, "1")
                        next

                        dim s4
                        for s4 = 1 To 6 step 1
                            if CInt(findcomponent("IttifakIdAA"&s4).UTF8Text) < 400 then
                                  Call SetActive("ittifaklogo"&s4, "0")
                                  Call SetActive("isim"&s4, "1")
                            else
                                  Call SetActive("ittifaklogo"&s4, "0")
                                  Call SetActive("isim"&s4, "1")
                            end if
                        next

                        dim cntr6:cntr6 = 0
                        dim y1

                        for y1 = 1 to 6 step 1
                            if CInt(findcomponent("IttifakMvAA"&y1).UTF8Text) > 0 then
                                  cntr6 = cntr6 +1
                            end if
                        next

                        if cntr6 <= 4 then
                              Call SetActive("ust1", "1")
                              if cntr6 = 1 then
                                 Call SetActive("GRUP1", "1")
                                 if CInt(IttifakIdAA1.UTF8Text) < 400 then
                                  Call SetActive("ittifaklogo1", "0")
                                  Call SetActive("isim1", "1")
                                 else
                                  Call SetActive("isim1", "0")
                                  Call SetActive("ittifaklogo1", "1")
                                 end if
                              elseif cntr6 = 2 then
                                Call SetActive("GRUP1", "1")
                                Call SetActive("GRUP2", "1")
                                 if CInt(IttifakIdAA2.UTF8Text) < 400 then
                                  Call SetActive("ittifaklogo1", "1")
                                  Call SetActive("isim1", "0")
                                  Call SetActive("ittifaklogo2", "0")
                                  Call SetActive("isim2", "1")
                                 else
                                  Call SetActive("isim1", "0")
                                  Call SetActive("ittifaklogo1", "1")
                                  Call SetActive("isim2", "0")
                                  Call SetActive("ittifaklogo2", "1")
                                 end if
                              elseif cntr6 = 3 then
                                Call SetActive("GRUP1", "1")
                                Call SetActive("GRUP2", "1")
                                Call SetActive("GRUP3", "1")
                                 if CInt(IttifakIdAA3.UTF8Text) < 400 then
                                  Call SetActive("ittifaklogo1", "1")
                                  Call SetActive("isim1", "0")
                                  Call SetActive("ittifaklogo2", "1")
                                  Call SetActive("isim2", "0")
                                  Call SetActive("ittifaklogo3", "0")
                                  Call SetActive("isim3", "1")
                                 else
                                  Call SetActive("isim1", "0")
                                  Call SetActive("ittifaklogo1", "1")
                                  Call SetActive("isim2", "0")
                                  Call SetActive("ittifaklogo2", "1")
                                  Call SetActive("isim3", "0")
                                  Call SetActive("ittifaklogo3", "1")
                                 end if
                              elseif cntr6 = 4 then
                                Call SetActive("GRUP1", "1")
                                Call SetActive("GRUP2", "1")
                                Call SetActive("GRUP3", "1")
                                Call SetActive("GRUP4", "1")
                                 if CInt(IttifakIdAA4.UTF8Text) < 400 then
                                ' msgbox "im in"
                                  Call SetActive("ittifaklogo1", "1")
                                  Call SetActive("isim1", "0")
                                  Call SetActive("ittifaklogo2", "1")
                                  Call SetActive("isim2", "0")
                                  Call SetActive("ittifaklogo3", "1")
                                  Call SetActive("isim3", "0")
                                  Call SetActive("ittifaklogo4", "0")
                                  Call SetActive("isim4", "1")
                                 else
                                  Call SetActive("isim1", "0")
                                  Call SetActive("ittifaklogo1", "1")
                                  Call SetActive("isim2", "0")
                                  Call SetActive("ittifaklogo2", "1")
                                  Call SetActive("isim3", "0")
                                  Call SetActive("ittifaklogo3", "1")
                                  Call SetActive("isim4", "0")
                                  Call SetActive("ittifaklogo4", "1")
                                 end if
                              end if

                              dim g2
                              for g2 = 1 to 4 step 1
                                Call SetText("mv"&g2, findcomponent("IttifakMvAA"&g2).UTF8Text)
                                Call SetText("isim"&g2, findcomponent("IttifakAdiAA"&g2).UTF8Text)
                                Call SetImage("ittifaklogo"&g2, "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("IttifakIdAA"&g2).UTF8Text)
                                Call SetImage("renk"&g2, "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("IttifakIdAA"&g2).UTF8Text)
                              next

                        elseif cntr6 > 4 then
                               Call SetActive("ust1", "1")
                               Call SetActive("alt1", "1")
                                if cntr6 = 5 then
                                        Call SetActive("GRUP1", "1")
                                        Call SetActive("GRUP2", "1")
                                        Call SetActive("GRUP3", "1")
                                        Call SetActive("GRUP5", "1")
                                        Call SetActive("GRUP6", "1")

                                        if CInt(IttifakIdAA5.UTF8Text) < 400 Then
                                               ' msgbox "im in"
                                                Call SetActive("ittifaklogo1", "1")
                                                Call SetActive("isim1", "0")
                                                Call SetActive("ittifaklogo2", "1")
                                                Call SetActive("isim2", "0")
                                                Call SetActive("ittifaklogo3", "1")
                                                Call SetActive("isim3", "0")
                                                Call SetActive("ittifaklogo5", "1")
                                                Call SetActive("isim5", "0")
                                                Call SetActive("ittifaklogo6", "0")
                                                Call SetActive("isim6", "1")
                                        else
                                                Call SetActive("isim1", "0")
                                                Call SetActive("ittifaklogo1", "1")
                                                Call SetActive("isim2", "0")
                                                Call SetActive("ittifaklogo2", "1")
                                                Call SetActive("isim3", "0")
                                                Call SetActive("ittifaklogo3", "1")
                                                Call SetActive("isim5", "0")
                                                Call SetActive("ittifaklogo5", "1")
                                                Call SetActive("isim6", "0")
                                                Call SetActive("ittifaklogo6", "1")
                                        end if

                                        dim d2
                                        for d2 = 1 to 3 step 1
                                                Call SetText("mv"&d2, findcomponent("IttifakMvAA"&d2).UTF8Text)
                                                Call SetText("isim"&d2, findcomponent("IttifakAdiAA"&d2).UTF8Text)
                                                Call SetImage("ittifaklogo"&d2, "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("IttifakIdAA"&d2).UTF8Text)
                                                Call SetImage("renk"&d2, "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("IttifakIdAA"&d2).UTF8Text)
                                        next
                                        dim e2
                                        for e2 = 5 to 6 step 1
                                                Call SetText("mv"&e2, findcomponent("IttifakMvAA"&(e2-1)).UTF8Text)
                                                Call SetText("isim"&e2, findcomponent("IttifakAdiAA"&(e2-1)).UTF8Text)
                                                Call SetImage("ittifaklogo"&e2, "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("IttifakIdAA"&(e2-1)).UTF8Text)
                                                Call SetImage("renk"&e2, "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("IttifakIdAA"&(e2-1)).UTF8Text)
                                        next
                                elseif cntr6 = 6 then
                                        Call SetActive("GRUP1", "1")
                                        Call SetActive("GRUP2", "1")
                                        Call SetActive("GRUP3", "1")
                                        Call SetActive("GRUP5", "1")
                                        Call SetActive("GRUP6", "1")
                                        Call SetActive("GRUP7", "1")

                                        if CInt(IttifakIdAA6.UTF8Text) < 400 then
                                                Call SetActive("ittifaklogo1", "1")
                                                Call SetActive("isim1", "0")
                                                Call SetActive("ittifaklogo2", "1")
                                                Call SetActive("isim2", "0")
                                                Call SetActive("ittifaklogo3", "1")
                                                Call SetActive("isim3", "0")
                                                Call SetActive("ittifaklogo5", "1")
                                                Call SetActive("isim5", "0")
                                                Call SetActive("ittifaklogo6", "1")
                                                Call SetActive("isim6", "0")
                                                Call SetActive("ittifaklogo7", "0")
                                                Call SetActive("isim7", "1")
                                        else
                                                Call SetActive("isim1", "0")
                                                Call SetActive("ittifaklogo1", "1")
                                                Call SetActive("isim2", "0")
                                                Call SetActive("ittifaklogo2", "1")
                                                Call SetActive("isim3", "0")
                                                Call SetActive("ittifaklogo3", "1")
                                                Call SetActive("isim5", "0")
                                                Call SetActive("ittifaklogo5", "1")
                                                Call SetActive("isim6", "0")
                                                Call SetActive("ittifaklogo6", "1")
                                                Call SetActive("isim7", "0")
                                                Call SetActive("ittifaklogo7", "1")
                                        end if

                                        dim d4
                                        for d4 = 1 to 3 step 1
                                                Call SetText("mv"&d4, findcomponent("IttifakMvAA"&d4).UTF8Text)
                                                Call SetText("isim"&d4, findcomponent("IttifakAdiAA"&d4).UTF8Text)
                                                Call SetImage("ittifaklogo"&d4, "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("IttifakIdAA"&d4).UTF8Text)
                                                Call SetImage("renk"&d4, "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("IttifakIdAA"&d4).UTF8Text)
                                        next
                                        dim e4
                                        for e4 = 5 to 7 step 1
                                                Call SetText("mv"&e4, findcomponent("IttifakMvAA"&(e4-1)).UTF8Text)
                                                Call SetText("isim"&e4, findcomponent("IttifakAdiAA"&(e4-1)).UTF8Text)
                                                Call SetImage("ittifaklogo"&e4, "SECIM_2023/FOX/PARTI_LOGO/"&findcomponent("IttifakIdAA"&(e4-1)).UTF8Text)
                                                Call SetImage("renk"&e4, "SECIM_2023/FOX/PARTI_MATERIAL/"&findcomponent("IttifakIdAA"&(e4-1)).UTF8Text)
                                        next
                                end if
                        end if

                        PlayAnim("LOOP")
                        PlayAnim("GELIS")
                        PlayAnim("PARLAMENTO")
                        PlayAnim("MECLIS_SONUCLARI_1")
                        PaintParlamento()
                        buffer_send(main_machine)

       else
                exit sub
       end if
End sub

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

Sub PaintParlamento2()
    Dim a
    for a = 1 to 600
       buffer_put("-1 RENDERER*TREE*@"&a&"*FUNCTION*DataMaterialIndex*offset SET 0")
    Next

    Dim i
    for i = 0 to UBound(arrWinners2)
        buffer_put("-1 RENDERER*TREE*@"&(i+1)&"*FUNCTION*DataMaterialIndex*offset SET "& SetId(arrWinners2(i)))
    Next

   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=")
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=0;")

   Playanim("PARLAMENTO")
End Sub

Sub PaintParlamento()
    Dim a
    for a = 1 to 600
       buffer_put("-1 RENDERER*TREE*@"&a&"*FUNCTION*DataMaterialIndex*offset SET 0")
    Next

    Dim i
    for i = 0 to UBound(arrWinners)
        buffer_put("-1 RENDERER*TREE*@"&(i+1)&"*FUNCTION*DataMaterialIndex*offset SET "& SetId(arrWinners(i)))
    Next
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=")
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=0;")

Call Playanim("PARLAMENTO")

End Sub

Sub YasakliPaintParlamento()
    Dim a
    for a = 1 to 600
       buffer_put("-1 RENDERER*TREE*@"&a&"*FUNCTION*DataMaterialIndex*offset SET 0")
    Next

    Dim i
    for i = 0 to UBound(arrWinners)
        buffer_put("-1 RENDERER*TREE*@"&(i+1)&"*FUNCTION*DataMaterialIndex*offset SET "& SetId(arrWinners(i)))
    Next

   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=")
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=0;")

Call Playanim("PARLAMENTO")
End Sub

Function GetColor(partiID)
  Dim returnValue : returnValue = ""
  If partiID = "" Then returnValue = ""
  if partiID <> "null" then
    partiID = partiID
  end if
  returnValue = sendsinglecmd(main_machine, "MATERIAL*SECIM_2023/FOX/PARTI_MATERIAL/"& partiID & "*COLOR GET", true)
  returnValue = ColorCodeTemizle(returnValue)
  GetColor = returnValue
End Function

Function ColorCodeTemizle(code)
  Dim returnValue : returnValue = ""
  If code = "" Then returnValue = ""
  returnValue = Right(code, Len(code) - 0)

  ColorCodeTemizle = returnValue
End Function

Sub GetPartilerArr(idSC, ajans, ittifakVariant)
  Dim arrSonuc()
  Dim acilanSandik
  Dim partiSayisi : partiSayisi = 50
  lbArrPartiler.Items.Clear()
  lbArrMv.Items.Clear()
  lbArrId.Items.Clear()
  Dim arrPartiIds(50)
  Dim arrPartiNames(50)
  Dim arrPartiMvs(50)

  Call g_db.SonucListesiDetay(arrSonuc, idSC, currentGenel, ajans, idPartiOrderType, bagimsizDetayli, ittifakVariant, partiSayisi, true)
  if Not g_lib.IsInitialized(arrSonuc) then exit sub

  Dim i
  dim c : c = 0
  for i = 0 to UBound(arrSonuc)
            arrPartiMvs(i) = arrSonuc(i).mvB
            arrPartiNames(i) = arrSonuc(i).nameShort
            arrPartiIds(i) = arrSonuc(i).idParti
            if arrPartiMvs(i) > 0 then
                  'lbArrMv.Items.Add(arrPartiMvs(i))
                  'lbArrId.Items.Add(arrPartiIds(i))
                  c = c + 1
                findcomponent("PartiMvG"&c).UTF8Text = arrPartiMvs(i)
                findcomponent("PartiAdiG"&c).UTF8Text = arrPartiNames(i)
                findcomponent("PartiIdG"&c).UTF8Text = arrPartiIds(i)
            end if
   next
End Sub

Sub btnArrClick(Sender)
Call GetPartilerArr(0, ajansAnka, ePRM_IttifakVariant_NO)
End sub

Sub btn2018VerClick(Sender)
        btn2018Ver.Enabled = false
        buffer_clear()
        if rdPartiler.Checked = true then
                buffer_put("-1 RENDERER*STAGE*$MECLIS_SONUCLARI_2 CONTINUE")
                buffer_send(main_machine)
        elseif rdIttifak.Checked = true then
                buffer_put("-1 RENDERER*STAGE*$MECLIS_SONUCLARI_1 CONTINUE")
                buffer_send(main_machine)
        else
                msgbox "Parti/İttifak seçimi yapınız!"
        exit sub
        end if
End sub

Sub rdIttifakClick(Sender)
        btn2018Ver.Enabled = true
End sub

Sub rdPartilerClick(Sender)
        btn2018Ver.Enabled = false
End sub

Sub cb2018GetirClick(Sender)
    gb2018Partiler.Visible = true
    gb2018Ittifaklar.Visible = true
End sub

Sub lbHavuzDblClick(Sender)
        Dim idx : idx = lbHavuz.ItemIndex
        Call g_lib.ListBoxDelete(lbHavuz, idx)
End sub

Sub btnClearClick(Sender)
       countClick = 0
       Call g_lib.ListBoxClear(lbHavuz)
End sub

Sub lbPartilerDblClick(Sender)
        Dim idx : idx = lbPartiler.ItemIndex
        Dim selectedId: selectedId = lbPartiler.ListIDs(idx)
        If lbHavuz.ListIDs.IndexOf(selectedId) >= 0 Then
                msgbox "Parti veya İttifak zaten havuzda!"
        Else
                countClick = countClick +1
                Call g_lib.ListBoxInsert(lbPartiler, lbHavuz)
                if countClick = lbPartiler.Items.Count then
                        TWUniButton1.Enabled = true
                end if
        End If
End sub

Sub lbHavuzClick(Sender)
       Dim idx : idx = lbHavuz.ItemIndex
       Dim idParti : idParti = lbHavuz.ListIDs(idx)
End sub

Sub TWUniButton1Click(Sender)
        TWUniButton1.Enabled = false
        countClick = 0

      Redim arrWinners2(600)
      Dim arrIds(8)
      Dim arrMvs(8)
      Dim idx
      Dim idParti
      Dim counter : counter = 0
        Dim j
        for j = 0 to lbHavuz.Count -1 step 1
            idParti = lbHavuz.ListIDs(j)
                If rdPartiler.Checked = true then
                    Dim i
                    for i = 0 to 7 step 1
                                If idParti = findcomponent("UpPartiIdG"&i+1).UTF8Text then
                                        arrMvs(i) = findcomponent("UpPartiMvG"&i+1).UTF8Text
                                        arrIds(i) = findcomponent("UpPartiIdG"&i+1).UTF8Text
                                Dim z
                                for z = 0 to(CInt(arrMvs(i))-1) step 1
                                        arrWinners2(counter) = arrIds(i)
                                        counter = counter + 1
                                next
                                end if
                    next

                elseif rdIttifak.Checked = true then
                    Dim a
                    for a = 0 to 5 step 1
                                If idParti = findcomponent("IttifakIdAA"&a+1).UTF8Text then
                                        arrMvs(a) = findcomponent("IttifakMvAA"&a+1).UTF8Text
                                        arrIds(a) = findcomponent("IttifakIdAA"&a+1).UTF8Text
                                Dim d
                                for d = 0 to(CInt(arrMvs(a))-1) step 1
                                        arrWinners2(counter) = arrIds(a)
                                        counter = counter + 1
                                next
                                end if
                    next
                end if
        next

        If rdPartiler.Checked = true then
           PlayAnim("LOOP")
           PlayAnim("GELIS")
           PlayAnim("PARLAMENTO")
           PlayAnim("MECLIS_SONUCLARI_2")
           PaintParlamento2()
           buffer_send(main_machine)
         elseif rdIttifak.Checked = true then
           PlayAnim("LOOP")
           PlayAnim("GELIS")
           PlayAnim("PARLAMENTO")
           PlayAnim("MECLIS_SONUCLARI_1")
           PaintParlamento2()
           buffer_send(main_machine)
        end if
End sub

Sub btnItemUpClick(Sender)
  TWUniButton1.Enabled = true
  Call g_lib.SwapListItems(lbHavuz, -1)
End sub

Sub btnItemDownClick(Sender)
  TWUniButton1.Enabled = true
  Call g_lib.SwapListItems(lbHavuz, +1)
End sub

Sub lbPartilerClick(Sender)

End sub

Sub Timer1Timer(Sender)
   btn2018Ver.Enabled = true
   Timer1.Enabled = false
End sub