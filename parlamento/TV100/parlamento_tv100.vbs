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
  Dim ret : ret  =  InitClass([_template], [_scripter])
  If ret <> CFnRetOk Then
    MsgBox "InitForm : Classlar init edilirken problem meydana geldi"
    Exit Sub
  End If

  InnerInitForm()
End Sub

Sub InnerInitForm()
        TWUniButton1.Enabled = false
        SendToVizButtonClick.enabled = false
        Call g_lib.ListBoxClear(lbPartiler)
        Call g_lib.ListBoxClear(lbHavuz)
        rdPartiler.Checked = true
        ClearTextboxesAll()
        btnYayindaPartilerAA.Visible = false
        btnYayindaIttifaklarAA.Visible = false
End Sub

Sub ClearTextboxesAll()
       dim q
       for q=1 to 10 step 1
                findcomponent("UpPartiAdiG"&q).UTF8Text = ""
                findcomponent("UpPartiYuzdeG"&q).UTF8Text = ""
                findcomponent("UpPartiMvG"&q).UTF8Text = ""
       next
       dim w
       for w=1 to 4 step 1
               findcomponent("IttifakAdiAA"&w).UTF8Text = ""
               findcomponent("IttifakYuzdeAA"&w).UTF8Text = ""
               findcomponent("IttifakMvAA"&w).UTF8Text = ""
       next
       txtAcilanSandikBilgisi.UTF8Text = ""
End Sub

Sub GetDatasAA()
       Call GetPartilerMv(0, "UpPartiIdG","UpPartiAdiG","UpPartiYuzdeG","UpPartiMvG", txtAcilanSandikBilgisi)
End Sub

Sub GetPartilerMv(idSC, ajans, ittifakVariant, txtId,txtName,txtOy,txtMv, txtAcilan)
  Dim arrSonuc()
  Dim acilanSandik
  Dim partiSayisi : partiSayisi = 10
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

        findcomponent(txtName&""&(i+1)).UTF8Text = arrSonuc(i).nameAlter
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
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"9").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"9").UTF8Text
      tempCount = tempCount + 1
  Next
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"10").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"10").UTF8Text
      tempCount = tempCount + 1
  Next

End Sub

Sub GetIttifaklarMv(idSC, ajans, ittifakVariant, txtId,txtName,txtOy,txtMv, txtAcilan)
  Dim arrSonuc()
  Dim acilanSandik
  Dim ittifakSayisi : ittifakSayisi = 4

  acilansandik = g_db.AcilanSandikYuzdeDetay(idSC, currentGenel, ajans, true)
  txtAcilan.UTF8Text = g_lib.YuzdeKorumaYuvarlama(acilansandik)

  Call g_db.SonucListesiDetayOrderByMv(arrSonuc, idSC, currentGenel, ajans, idPartiOrderType, bagimsizDetayli, ittifakVariant, ittifakSayisi, true, 1)
  if Not g_lib.IsInitialized(arrSonuc) then exit sub

  Dim i
  for i = 0 to UBound(arrSonuc)

        If arrSonuc(i).mvB > 0 Then
                lbPartiler.Items.Add(arrSonuc(i).nameShort)
                lbPartiler.ListIDs.Add(arrSonuc(i).idParti)
        Else

        End If

        findcomponent(txtName&""&(i+1)).UTF8Text = Replace(arrSonuc(i).nameShort," İttifakı Toplam Oyu","")
        findcomponent(txtOy&""&(i+1)).UTF8Text = g_lib.YuzdeKorumaYuvarlamaDigit(arrSonuc(i).yuzde,1)
        findcomponent(txtId&""&(i+1)).UTF8Text = arrSonuc(i).idParti
        findcomponent(txtMv&""&(i+1)).UTF8Text = arrSonuc(i).mvB
  next

  dim g
  for g = 1 to 4 step 1
      if findcomponent("IttifakAdiAA"&g).UTF8Text = lblEmek1.UTF8Text then
             findcomponent("IttifakAdiAA"&g).UTF8Text = "EMEK"
             'msgbox "im"
      end if
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

End Sub

Sub btnVerileriGuncelleClick(Sender)
        SendToVizButtonClick.enabled = true
        Call g_lib.ListBoxClear(lbPartiler)
        Call g_lib.ListBoxClear(lbHavuz)

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
    buffer_put("-1 RENDERER SET_OBJECT SCENE*SECIM_2023/TV100/IC_EKRANLAR/2_TUR/09_MECLIS_DAGILIMI_PARTILER_ve_ITTIFAKLAR")
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

Sub YasakliPartilerAnka()
       buffer_clear()
       Call SetActive("1GRUP","1")
       Call SetActive("2GRUP","1")
       Call SetActive("3GRUP","1")
       Call SetActive("4GRUP","1")
       Call SetActive("5GRUP","1")
       Call SetActive("6GRUP","1")
       Call SetActive("7GRUP","1")
       Call SetActive("8GRUP","1")

       Call SetText("sandikAA", tbAcilanSandikAnka.UTF8Text)
       Call SetKeyFrame("ringAA", "out", "VALUE", 360*(CDbl(0))/100)
       Call SetImage("LOGO_SANDIK","SECIM_2023/FOX/AJANSLAR/anka")
       Call SetMaterial("sandikgrupSOL","SECIM_2023/FOX/AJANSLAR/anka")

       dim i
       for i = 1 To 8 Step 1
        Call SetText(i&"mv", findcomponent("PartiMvG"&i).UTF8Text)
        Call SetText(i&"isim", findcomponent("PartiAdiG"&i).UTF8Text)
        Call SetImage(i&"logo", "/SECIM_2023/FOX/ADAY_FOTO/-1")
        Call SetImage(i&"renk", "/SECIM_2023/FOX/ADAY_MATERIAL/-1")
       next

        PlayAnim("LOOP")
        PlayAnim("GELIS")
        PlayAnim("PARLAMENTO")
        Call PlayAnim("MECLIS_SONUCLARI_2")

        Call PaintParlamentoYasakli()
        buffer_send(main_machine)
End Sub

Sub YasakliPartilerAA()
       buffer_clear()

       Call SetActive("1GRUP","1")
       Call SetActive("2GRUP","1")
       Call SetActive("3GRUP","1")
       Call SetActive("4GRUP","1")
       Call SetActive("5GRUP","1")
       Call SetActive("6GRUP","1")
       Call SetActive("7GRUP","1")
       Call SetActive("8GRUP","1")

       Call SetText("sandikAA", txtAcilanSandikBilgisi.UTF8Text)
       Call SetKeyFrame("ringAA", "out", "VALUE", 360*(CDbl(0))/100)
       Call SetImage("LOGO_SANDIK","SECIM_2023/FOX/AJANSLAR/aa")
       Call SetMaterial("sandikgrupSOL","SECIM_2023/FOX/AJANSLAR/aa")

       dim i
       for i = 1 To 8 Step 1
        Call SetText(i&"mv", findcomponent("UpPartiMvG"&i).UTF8Text)
        Call SetText(i&"isim", findcomponent("UpPartiAdiG"&i).UTF8Text)
        Call SetImage(i&"logo", "/SECIM_2023/FOX/ADAY_FOTO/-1")
        Call SetImage(i&"renk", "/SECIM_2023/FOX/ADAY_MATERIAL/-1")
       next

        PlayAnim("LOOP")
        PlayAnim("GELIS")
        PlayAnim("PARLAMENTO")
        Call PlayAnim("MECLIS_SONUCLARI_2")

        Call PaintParlamentoYasakli()
        buffer_send(main_machine)
End Sub

Sub YasakliIttifaklarAA()
       buffer_clear()

       Call SetActive("GRUP1","1")
       Call SetActive("GRUP2","1")
       Call SetActive("GRUP3","1")
       Call SetActive("GRUP4","1")
       Call SetActive("GRUP5","1")
       Call SetActive("GRUP6","1")

       dim p
       for p = 1 to 8 step 1
                Call SetActive("ittifaklogo"&p, "0")
                Call SetActive("isim"&p, "1")
       next

       Call SetText("sandikAA", txtAcilanSandikBilgisi.UTF8Text)
       Call SetKeyFrame("ringAA", "out", "VALUE", 360*(CDbl(0))/100)
       Call SetImage("LOGO_SANDIK","SECIM_2023/FOX/AJANSLAR/aa")
       Call SetMaterial("sandikgrupSOL","SECIM_2023/FOX/AJANSLAR/aa")

       dim i
       for i = 1 To 6 Step 1
        Call SetText("mv"&i, findcomponent("IttifakMvAA"&i).UTF8Text)
        Call SetText("isim"&i, findcomponent("IttifakAdiAA"&i).UTF8Text)
        Call SetImage("renk"&i, "/SECIM_2023/FOX/ADAY_MATERIAL/-1")
       next

        PlayAnim("LOOP")
        PlayAnim("GELIS")
        PlayAnim("PARLAMENTO")
        Call PlayAnim("MECLIS_SONUCLARI_1")

        Call PaintParlamentoYasakli()

        buffer_send(main_machine)
End Sub

Sub YasakliIttifaklarAnka()
       buffer_clear()

       Call SetActive("GRUP1","1")
       Call SetActive("GRUP2","1")
       Call SetActive("GRUP3","1")
       Call SetActive("GRUP4","1")
       Call SetActive("GRUP5","1")
       Call SetActive("GRUP6","1")

       dim p
       for p = 1 to 8 step 1
                Call SetActive("ittifaklogo"&p, "0")
                Call SetActive("isim"&p, "1")
       next

       Call SetText("sandikAA", tbAcilanSandikAnka.UTF8Text)
       Call SetKeyFrame("ringAA", "out", "VALUE", 360*(CDbl(0))/100)
       Call SetImage("LOGO_SANDIK","SECIM_2023/FOX/AJANSLAR/anka")
       Call SetMaterial("sandikgrupSOL","SECIM_2023/FOX/AJANSLAR/anka")

       dim i
       for i = 1 To 6 Step 1
        Call SetText("mv"&i, findcomponent("IttifakMvAnka"&i).UTF8Text)
        Call SetText("isim"&i, findcomponent("IttifakAdiAnka"&i).UTF8Text)
        Call SetImage("renk"&i, "/SECIM_2023/FOX/ADAY_MATERIAL/-1")
       next

        PlayAnim("LOOP")
        PlayAnim("GELIS")
        PlayAnim("PARLAMENTO")
        Call PlayAnim("MECLIS_SONUCLARI_1")

        Call PaintParlamentoYasakli()

        buffer_send(main_machine)
End Sub

Sub PaintParlamentoYasakli()
    Dim a
    for a = 1 to 600
       buffer_put("-1 RENDERER*TREE*@"&a&"*FUNCTION*DataMaterialIndex*offset SET 0")
    Next

   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=")
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=0;")

        Call Playanim("PARLAMENTO")
End Sub

Sub SendToVizButtonClickClick(Sender)
        SendToVizButtonClick.enabled = false

       if rdPartiler.Checked = true then
       '#1
                        btnYayindaIttifaklarAA.Visible = false
                        btnYayindaPartilerAA.Visible = true

                        buffer_clear()

                        Call SetActive("partiler", 1)
                        Call SetActive("ittifaklar", 0)

                        Call SetActive("ajansANKA", 0)

                        Call SetText("AA_BASLIK1", baslikParti.UTF8Text)

                        Call SetText("sandikAA", txtAcilanSandikBilgisi.UTF8Text)
                        Call SetKeyFrame("sandikAA", "out", "VALUE", g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))

                        if g_lib.CDblSafe(txtAcilanSandikBilgisi.UTF8Text) >= 100 then
                                buffer_put("-1 RENDERER*TREE*@sandikAA*FUNCTION*Advanced_Counter*inpmask SET ###")
                        else
                                buffer_put("-1 RENDERER*TREE*@sandikAA*FUNCTION*Advanced_Counter*inpmask SET ####.#")
                        end if

                        Call SetActive("1GRUP","0")
                        Call SetActive("2GRUP","0")
                        Call SetActive("3GRUP","0")
                        Call SetActive("4GRUP","0")
                        Call SetActive("5GRUP","0")
                        Call SetActive("6GRUP","0")
                        Call SetActive("7GRUP","0")
                        Call SetActive("8GRUP","0")
                        Call SetActive("9GRUP","0")
                        Call SetActive("10GRUP","0")

                        dim counter:counter = 0
                        dim l

                        for l = 1 to 10 step 1
                            if CInt(findcomponent("UpPartiMvG"&l).UTF8Text) > 0 then
                                  counter = counter +1
                            end if
                        next

                        if counter <= 5 then
                              Call SetActive("alt2", "1")
                              if counter = 1 then
                                 Call SetActive("1GRUP", "1")
                              elseif counter = 2 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                              elseif counter = 3 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                              elseif counter = 4 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                                Call SetActive("4GRUP", "1")
                              elseif counter = 5 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                                Call SetActive("4GRUP", "1")
                                Call SetActive("5GRUP", "1")
                              end if
                              dim tt
                              for tt = 1 to 5 step 1
                                  Call SetText(tt&"mv", findcomponent("UpPartiMvG"&tt).UTF8Text)
                                  Call SetText(tt&"isim", findcomponent("UpPartiAdiG"&tt).UTF8Text)
                                  Call SetImage(tt&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&tt).UTF8Text)
                              next
                        elseif counter > 5 then
                               Call SetActive("alt2", "1")
                               Call SetActive("ust2", "1")
                                if counter = 6 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        Call SetActive("8GRUP", "1")
                                        dim n
                                        for n = 1 to 3 step 1
                                            Call SetText(n&"mv", findcomponent("UpPartiMvG"&n).UTF8Text)
                                            Call SetText(n&"isim", findcomponent("UpPartiAdiG"&n).UTF8Text)
                                            Call SetImage(n&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&n).UTF8Text)
                                        next
                                        dim m
                                        for m = 6 to 8 step 1
                                            Call SetText(m&"mv", findcomponent("UpPartiMvG"&(m-2)).UTF8Text)
                                            Call SetText(m&"isim", findcomponent("UpPartiAdiG"&(m-2)).UTF8Text)
                                            Call SetImage(m&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&(m-2)).UTF8Text)
                                        next
                                elseif counter = 7 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("4GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        Call SetActive("8GRUP", "1")
                                        dim u
                                        for u = 1 to 4 step 1
                                            Call SetText(u&"mv", findcomponent("UpPartiMvG"&u).UTF8Text)
                                            Call SetText(u&"isim", findcomponent("UpPartiAdiG"&u).UTF8Text)
                                            Call SetImage(u&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&u).UTF8Text)
                                        next
                                        for m = 6 to 8 step 1
                                            Call SetText(m&"mv", findcomponent("UpPartiMvG"&(m-1)).UTF8Text)
                                            Call SetText(m&"isim", findcomponent("UpPartiAdiG"&(m-1)).UTF8Text)
                                            Call SetImage(m&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&(m-1)).UTF8Text)
                                        next
                                elseif counter = 8 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("4GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        Call SetActive("8GRUP", "1")
                                        Call SetActive("9GRUP", "1")
                                        dim j
                                        for j = 1 to 4 step 1
                                            Call SetText(j&"mv", findcomponent("UpPartiMvG"&j).UTF8Text)
                                            Call SetText(j&"isim", findcomponent("UpPartiAdiG"&j).UTF8Text)
                                            Call SetImage(j&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&j).UTF8Text)
                                        next
                                        dim p
                                        for p = 6 to 9 step 1
                                            Call SetText(p&"mv", findcomponent("UpPartiMvG"&(p-1)).UTF8Text)
                                            Call SetText(p&"isim", findcomponent("UpPartiAdiG"&(p-1)).UTF8Text)
                                            Call SetImage(p&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&(p-1)).UTF8Text)
                                        next
                                elseif counter = 9 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("4GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        Call SetActive("8GRUP", "1")
                                        Call SetActive("9GRUP", "1")
                                        dim k
                                        for k = 1 to 9 step 1
                                            Call SetText(k&"mv", findcomponent("UpPartiMvG"&k).UTF8Text)
                                            Call SetText(k&"isim", findcomponent("UpPartiAdiG"&k).UTF8Text)
                                            Call SetImage(k&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&k).UTF8Text)
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
                                        Call SetActive("9GRUP", "1")
                                        Call SetActive("10GRUP", "1")
                                        dim h
                                        for h = 1 to 10 step 1
                                            Call SetText(h&"mv", findcomponent("UpPartiMvG"&h).UTF8Text)
                                            Call SetText(h&"isim", findcomponent("UpPartiAdiG"&h).UTF8Text)
                                            Call SetImage(h&"logo", "SECIM_2023/TV100/PARTI_LOGO/"&findcomponent("UpPartiIdG"&h).UTF8Text)
                                        next
                                end if
                        end if

                        PaintParlamento()
                        PlayAnim("IN")
                        PlayAnim("MECLIS")
                        buffer_send(main_machine)

       elseif rdIttifak.Checked = true then
       '#2
                        btnYayindaPartilerAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = true

                        buffer_clear()

                        Call SetActive("partiler", 0)
                        Call SetActive("ittifaklar", 1)

                        Call SetActive("ajansANKA", 0)

                        Call SetText("AA_BASLIK1", baslikIttifaklar.UTF8Text)

                        Call SetText("sandikAA", txtAcilanSandikBilgisi.UTF8Text)
                        Call SetKeyFrame("sandikAA", "out", "VALUE", g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))

                        if g_lib.CDblSafe(txtAcilanSandikBilgisi.UTF8Text) >= 100 then
                                buffer_put("-1 RENDERER*TREE*@sandikAA*FUNCTION*Advanced_Counter*inpmask SET ###")
                        else
                                buffer_put("-1 RENDERER*TREE*@sandikAA*FUNCTION*Advanced_Counter*inpmask SET ####.#")
                        end if

                        Call SetActive("GRUP1","0")
                        Call SetActive("GRUP2","0")
                        Call SetActive("GRUP3","0")
                        Call SetActive("GRUP4","0")

                        dim counter3:counter3 = 0
                        dim o

                        for o = 1 to 4 step 1
                            if CInt(findcomponent("IttifakMvAA"&o).UTF8Text) > 0 then
                                  counter3 = counter3 +1
                            end if
                        next

                        if counter3 <= 4 then
                              if counter3 = 1 then
                                 Call SetActive("GRUP1", "1")
                              elseif counter3 = 2 then
                                Call SetActive("GRUP1", "1")
                                Call SetActive("GRUP2", "1")
                              elseif counter3 = 3 then
                                Call SetActive("GRUP1", "1")
                                Call SetActive("GRUP2", "1")
                                Call SetActive("GRUP3", "1")
                              elseif counter3 = 4 then
                                Call SetActive("GRUP1", "1")
                                Call SetActive("GRUP2", "1")
                                Call SetActive("GRUP3", "1")
                                Call SetActive("GRUP4", "1")
                              end if
                        end if

                        dim e
                        for e = 1 To 4 Step 1
                                if findcomponent("IttifakAdiAA"&e).UTF8Text = lblDiger1.UTF8Text then
                                        Call SetText("isim"&e, lblDiger2.UTF8Text)
                                        Call SetText("mv"&e, findcomponent("IttifakMvAA"&e).UTF8Text)
                                        Call SetImage("ittifak_renk_"&e, "SECIM_2023/TV100/ITTIFAK_MATERIAL/renkler/"&findcomponent("IttifakIdAA"&e).UTF8Text)
                                else
                                        Call SetText("isim"&e, findcomponent("IttifakAdiAA"&e).UTF8Text)
                                        Call SetText("mv"&e, findcomponent("IttifakMvAA"&e).UTF8Text)
                                        Call SetImage("ittifak_renk_"&e, "SECIM_2023/TV100/ITTIFAK_MATERIAL/renkler/"&findcomponent("IttifakIdAA"&e).UTF8Text)
                                        Call SetImage("ittifak_logo"&e, "SECIM_2023/TV100/ITTIFAK_MATERIAL/parlemento/"&findcomponent("IttifakIdAA"&e).UTF8Text)
                                end if

                        next

                        PlayAnim("IN")
                        PlayAnim("MECLIS")
                        Call PaintParlamento()
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

Sub PaintParlamento()
    Dim a
    for a = 1 to 600
       buffer_put("-1 RENDERER*TREE*@"&a&"*FUNCTION*DataMaterialIndex*offset SET 0")
    Next

    Dim i
    for i = 0 to UBound(arrWinners)
        buffer_put("-1 RENDERER*TREE*@"&(i+1)&"*FUNCTION*DataMaterialIndex*offset SET "& SetId(arrWinners(i)) )
    Next
    buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=")
    buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=0;")
    Playanim("MECLIS")
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
if rdIttifak.Checked = true then
        buffer_clear()
        buffer_put("-1 RENDERER*STAGE*$MECLIS_SONUCLARI_1 CONTINUE")
        buffer_send(main_machine)
else
        exit sub
end if
End sub

Sub rdIttifakClick(Sender)
        btn2018Ver.Enabled = true
End sub

Sub rdPartilerClick(Sender)
        btn2018Ver.Enabled = false
End sub

Sub btnClearClick(Sender)
TWUniButton1.Enabled = false
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

Sub lbHavuzDblClick(Sender)
TWUniButton1.Enabled = false
        Dim idx : idx = lbHavuz.ItemIndex
        Call g_lib.ListBoxDelete(lbHavuz, idx)
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
                    for i = 0 to 9 step 1
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
                    for a = 0 to 3 step 1
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

        PlayAnim("IN")
        Call PaintParlamento2()
        buffer_send(main_machine)
End sub

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