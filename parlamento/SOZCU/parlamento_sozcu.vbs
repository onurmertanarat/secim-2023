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
Dim idSCTR : idSCTr = 0
Dim idPartiOrderType : idPartiOrderType = ePOT_Pusula
Dim bagimsizDetayli : bagimsizDetayli =  ePRM_BagimsizDetay_NO
Dim cumhurID : cumhurID = ePARTI_CumhurIttifaki
Dim milletID : milletID = ePARTI_MilletIttifaki
Dim countClick : countClick = 0
Dim toplamMVSayisi : toplamMVSayisi = 600
Dim arrWinners()
Dim arrWinners2()
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
    Call g_lib.ListBoxClear(lbPartiler)
    Call g_lib.ListBoxClear(lbHavuz)
    TWUniButton1.Enabled = false
    rdIttifak.Checked = false
    rdPartiler.Checked = true
    cb2018Getir.Checked = false
    SendToVizButtonClick.enabled = false
    ClearTextboxesAll()
    btnYayindaPartilerAA.Visible = false
    btnYayindaIttifaklarAA.Visible = false
    btnYayinaVer2018Partiler.Visible = false
    btnYayinaVer2018Ittifaklar.Visible = false
    gb2018Partiler.Visible = false
    gb2018Ittifaklar.Visible = false
End Sub

Sub ClearTextboxesAll()
       dim a
       for a=1 to 9 step 1
                findcomponent("UPartiAdiG"&a).UTF8Text = ""
                findcomponent("UPartiYuzdeG"&a).UTF8Text = ""
                findcomponent("UPartiMvG"&a).UTF8Text = ""
       next
       dim b
       for b=1 to 3 step 1
                findcomponent("UIttifakAdi"&b).UTF8Text = ""
                findcomponent("UIttifakYuzde"&b).UTF8Text = ""
                findcomponent("UIttifakMv"&b).UTF8Text = ""
       next

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

Sub LoadSceneButtonClickClick(Sender)
    buffer_clear()
    buffer_put("-1 RENDERER SET_OBJECT SCENE*SECIM_2023/SOZCU/IC_EKRANLAR/2_TUR/13_MECLIS_SANDALYE_DAGILIMI")
    buffer_put("-1 RENDERER*STAGE SHOW 0")
    buffer_send(main_machine)
End sub

Sub Btn_Yayindan_AlClick(Sender)
    buffer_clear()
    buffer_put("-1 RENDERER SET_OBJECT ")
    buffer_send(main_machine)
End sub

Sub btnVerileriGuncelleClick(Sender)
    SendToVizButtonClick.Enabled = true
    Call g_lib.ListBoxClear(lbPartiler)
    Call g_lib.ListBoxClear(lbHavuz)

       if rdPartiler.Checked = true AND cb2018Getir.Checked = false then
       '#1
                Call GetPartilerMv(idSCTR, idDataSource, ePRM_IttifakVariant_NO, "UpPartiIdG","UpPartiAdiG","UpPartiYuzdeG","UpPartiMvG", txtAcilanSandikBilgisi)
       elseif rdIttifak.Checked = true AND cb2018Getir.Checked = false then
       '#2
                Call GetIttifaklarMv(idSCTR, idDataSource, ePRM_IttifakVariant_YES, "IttifakIdAA","IttifakAdiAA","IttifakYuzdeAA","IttifakMvAA", txtAcilanSandikBilgisi)
       elseif rdPartiler.Checked = true AND cb2018Getir.Checked = true then
       '#3
                gb2018Partiler.Visible = true
                gb2018Ittifaklar.Visible = true
                Call GetPartilerMv2018(0, eDS_TUIK, ePRM_IttifakVariant_NO, "UPartiIdG","UPartiAdiG","UPartiYuzdeG","UPartiMvG")
       elseif rdIttifak.Checked = true AND cb2018Getir.Checked = true then
       '#4
                gb2018Partiler.Visible = true
                gb2018Ittifaklar.Visible = true
                Call GetIttifaklarMv2018(0, eDS_TUIK, ePRM_IttifakVariant_YES, "UIttifakId","UIttifakAdi","UIttifakYuzde","UIttifakMv")
       else
                exit sub
       end if
End sub

Sub GetPartilerMv2018(idSC, ajans, ittifakVariant, txtId,txtName,txtOy,txtMv)
  Dim arrSonuc()
  Dim acilanSandik
  Dim partiSayisi : partiSayisi = 9
  Dim arrPartiIds(50)
  Dim arrPartiNames(50)
  Dim arrPartiMvs(50)
  Dim arrPartiOy(50)

  Call g_db.SonucListesiTamDetayOrderByMv(arrSonuc, idSC, eSP_2018Genel, ajans, idPartiOrderType, bagimsizDetayli, ittifakVariant, partiSayisi, true, 1)
  if Not g_lib.IsInitialized(arrSonuc) then exit sub

  Dim i
  for i = 0 to UBound(arrSonuc)
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
  if tempCount > 600 then  exit sub
  for a = 0 to (CInt(findcomponent(txtMv&"9").UTF8Text) - 1)
      arrWinners(tempCount) = findcomponent(txtId&"9").UTF8Text
      tempCount = tempCount + 1
  Next
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

Sub GetIttifaklarMv2018(idSC, ajans, ittifakVariant, txtId,txtName,txtOy,txtMv)
  Dim arrSonuc()
  Dim acilanSandik
  Dim ittifakSayisi : ittifakSayisi = 3

  Call g_db.SonucListesiTamDetayOrderByMv(arrSonuc, idSC, eSP_2018Genel, ajans, idPartiOrderType, bagimsizDetayli, ittifakVariant, ittifakSayisi, true, 1)
  if Not g_lib.IsInitialized(arrSonuc) then exit sub

  Dim i
  for i = 0 to UBound(arrSonuc)

                findcomponent(txtName&""&(i+1)).UTF8Text = g_lib.Buyut(Replace(arrSonuc(i).nameAlter," İttifakı Toplam Oyu",""))
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

        findcomponent(txtName&""&(i+1)).UTF8Text = g_lib.Buyut(Replace(arrSonuc(i).nameAlter," İttifakı Toplam Oyu",""))
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

Sub SendToVizButtonClickClick(Sender)
SendToVizButtonClick.enabled = false

       if rdPartiler.Checked = true then
       '#1
                if cb2018Getir.Checked = false then

                        btnYayindaPartilerAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = false
                        btnYayindaPartilerAA.Visible = true
                        btnYayinaVer2018Partiler.Visible = false
                        btnYayinaVer2018Ittifaklar.Visible = false

                        buffer_clear()

                        Call SetActive("14_mayis_mv_logo", 1)

                        Call SetText("baslik_isim", lblParti.UTF8Text)
                        Call SetText("yil",lbl2023.UTF8Text)
                        Call SetActive("ass", "0")
                        Call SetActive("ajansAnka", "0")
                        Call SetActive("ajansAA", "0")

                        Call SetKeyframe("acilan","end","VALUE", g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))
                        Call SetKeyframe("acilan_pie","end","VALUE", g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))

                        if g_lib.CDblSafe(txtAcilanSandikBilgisi.UTF8Text) >= 100 then
                                buffer_put("-1 RENDERER*TREE*@acilan*FUNCTION*Advanced_Counter*inpmask SET ###")
                        else
                                buffer_put("-1 RENDERER*TREE*@acilan*FUNCTION*Advanced_Counter*inpmask SET ####.#")
                        end if

                        Call SetActive("1GRUP","0")
                        Call SetActive("2GRUP","0")
                        Call SetActive("3GRUP","0")
                        Call SetActive("4GRUP","0")
                        Call SetActive("5GRUP","0")
                        Call SetActive("6GRUP","0")
                        Call SetActive("7GRUP","0")
                        Call SetActive("8GRUP","0")

                        dim cntr:cntr = 0
                        dim a

                        for a = 1 to 8 step 1
                            if CInt(findcomponent("UpPartiMvG"&a).UTF8Text) > 0 then
                                  cntr = cntr +1
                            end if
                        next

                        if cntr <= 4 then
                              Call SetActive("ust_grp", "1")
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
                                Call SetMaterial(b5&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&b5).UTF8Text)
                                Call SetMaterial(b5&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&b5).UTF8Text)
                              next

                        elseif cntr > 4 then
                               Call SetActive("ust_grp", "1")
                               Call SetActive("alt_grp", "1")
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
                                            Call SetMaterial(b&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&b).UTF8Text)
                                            Call SetMaterial(b&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&b).UTF8Text)
                                        next
                                        dim c
                                        for c = 5 to 6 step 1
                                            Call SetText(c&"mv", findcomponent("UpPartiMvG"&(c-1)).UTF8Text)
                                            Call SetText(c&"isim", findcomponent("UpPartiAdiG"&(c-1)).UTF8Text)
                                            Call SetMaterial(c&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&(c-1)).UTF8Text)
                                            Call SetMaterial(c&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&(c-1)).UTF8Text)
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
                                            Call SetMaterial(d&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&d).UTF8Text)
                                            Call SetMaterial(d&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&d).UTF8Text)
                                        next
                                        dim e
                                        for e = 5 to 8 step 1
                                            Call SetText(e&"mv", findcomponent("UpPartiMvG"&(e-1)).UTF8Text)
                                            Call SetText(e&"isim", findcomponent("UpPartiAdiG"&(e-1)).UTF8Text)
                                            Call SetMaterial(e&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&(e-1)).UTF8Text)
                                            Call SetMaterial(e&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&(e-1)).UTF8Text)
                                        next
                                elseif cntr = 7 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("4GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        dim f
                                        for f = 1 to 4 step 1
                                            Call SetText(f&"mv", findcomponent("UpPartiMvG"&f).UTF8Text)
                                            Call SetText(f&"isim", findcomponent("UpPartiAdiG"&f).UTF8Text)
                                            Call SetMaterial(f&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&f).UTF8Text)
                                            Call SetMaterial(f&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&f).UTF8Text)
                                        next
                                        dim g
                                        for g = 5 to 7 step 1
                                            Call SetText(g&"mv", findcomponent("UpPartiMvG"&(g)).UTF8Text)
                                            Call SetText(g&"isim", findcomponent("UpPartiAdiG"&(g)).UTF8Text)
                                            Call SetMaterial(g&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&(g)).UTF8Text)
                                            Call SetMaterial(g&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&(g)).UTF8Text)
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
                                            Call SetMaterial(h&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&h).UTF8Text)
                                            Call SetMaterial(h&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UpPartiIdG"&h).UTF8Text)
                                        next
                                end if
                        end if

                        PaintParlamento()
                        PlayAnim("IN")
                        buffer_send(main_machine)

                elseif rdPartiler.Checked = true AND cb2018Getir.Checked = true then
                        btnYayindaPartilerAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = false
                        btnYayindaPartilerAA.Visible = false
                        btnYayinaVer2018Partiler.Visible = true
                        btnYayinaVer2018Ittifaklar.Visible = false

                        buffer_clear()

                        Call SetActive("14_mayis_mv_logo", 0)

                        Call SetText("baslik_isim", lblParti.UTF8Text)
                        Call SetText("yil",lbl2018.UTF8Text)
                        Call SetActive("ass", "0")
                        Call SetActive("ajansAnka", "0")
                        Call SetActive("ajansAA", "0")

                        Call SetActive("1GRUP","0")
                        Call SetActive("2GRUP","0")
                        Call SetActive("3GRUP","0")
                        Call SetActive("4GRUP","0")
                        Call SetActive("5GRUP","0")
                        Call SetActive("6GRUP","0")
                        Call SetActive("7GRUP","0")
                        Call SetActive("8GRUP","0")

                        dim cntr4:cntr4 = 0
                        dim a2018

                        for a2018 = 1 to 8 step 1
                            if CInt(findcomponent("UPartiMvG"&a2018).UTF8Text) > 0 then
                                  cntr4 = cntr4 +1
                            end if
                        next

                        if cntr4 <= 4 then
                              Call SetActive("ust_grp", "1")
                              if cntr4 = 1 then
                                 Call SetActive("1GRUP", "1")
                              elseif cntr4 = 2 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                              elseif cntr4 = 3 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                              elseif cntr4 = 4 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                                Call SetActive("4GRUP", "1")
                              end if

                              dim b6
                              for b6 = 1 to 4 step 1
                                Call SetText(b6&"mv", findcomponent("UPartiMvG"&b6).UTF8Text)
                                Call SetText(b6&"isim", findcomponent("UPartiAdiG"&b6).UTF8Text)
                                Call SetMaterial(b6&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&b6).UTF8Text)
                                Call SetMaterial(b6&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&b6).UTF8Text)
                              next

                        elseif cntr4 > 4 then
                               Call SetActive("ust_grp", "1")
                               Call SetActive("alt_grp", "1")
                                if cntr4 = 5 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        dim b2018
                                        for b2018 = 1 to 3 step 1
                                            Call SetText(b2018&"mv", findcomponent("UPartiMvG"&b2018).UTF8Text)
                                            Call SetText(b2018&"isim", findcomponent("UPartiAdiG"&b2018).UTF8Text)
                                            Call SetMaterial(b2018&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&b2018).UTF8Text)
                                            Call SetMaterial(b2018&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&b2018).UTF8Text)
                                        next
                                        dim c2018
                                        for c2018 = 5 to 6 step 1
                                            Call SetText(c2018&"mv", findcomponent("UPartiMvG"&(c2018-1)).UTF8Text)
                                            Call SetText(c2018&"isim", findcomponent("UPartiAdiG"&(c2018-1)).UTF8Text)
                                            Call SetMaterial(c2018&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&(c2018-1)).UTF8Text)
                                            Call SetMaterial(c2018&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&(c2018-1)).UTF8Text)
                                        next
                                elseif cntr4 = 6 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        dim d2018
                                        for d2018 = 1 to 4 step 1
                                            Call SetText(d2018&"mv", findcomponent("UPartiMvG"&d2018).UTF8Text)
                                            Call SetText(d2018&"isim", findcomponent("UPartiAdiG"&d2018).UTF8Text)
                                            Call SetMaterial(d2018&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&d2018).UTF8Text)
                                            Call SetMaterial(d2018&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&d2018).UTF8Text)
                                        next
                                        dim e2018
                                        for e2018 = 5 to 8 step 1
                                            Call SetText(e2018&"mv", findcomponent("UPartiMvG"&(e2018-1)).UTF8Text)
                                            Call SetText(e2018&"isim", findcomponent("UPartiAdiG"&(e2018-1)).UTF8Text)
                                            Call SetMaterial(e2018&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&(e2018-1)).UTF8Text)
                                            Call SetMaterial(e2018&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&(e2018-1)).UTF8Text)
                                        next
                                elseif cntr4 = 7 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("4GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        dim f2018
                                        for f2018 = 1 to 4 step 1
                                            Call SetText(f2018&"mv", findcomponent("UPartiMvG"&f2018).UTF8Text)
                                            Call SetText(f2018&"isim", findcomponent("UPartiAdiG"&f2018).UTF8Text)
                                            Call SetMaterial(f2018&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&f2018).UTF8Text)
                                            Call SetMaterial(f2018&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&f2018).UTF8Text)
                                        next
                                        dim g2018
                                        for g2018 = 5 to 7 step 1
                                            Call SetText(g2018&"mv", findcomponent("UPartiMvG"&(g2018-1)).UTF8Text)
                                            Call SetText(g2018&"isim", findcomponent("UPartiAdiG"&(g2018-1)).UTF8Text)
                                            Call SetMaterial(g2018&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&(g2018-1)).UTF8Text)
                                            Call SetMaterial(g2018&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"&(g2018-1)).UTF8Text)
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
                                        dim h2018
                                        for h2018 = 1 to 8 step 1
                                            Call SetText(h2018&"mv", findcomponent("UPartiMvG"& h2018).UTF8Text)
                                            Call SetText(h2018&"isim", findcomponent("UPartiAdiG"& h2018).UTF8Text)
                                            Call SetMaterial(h2018&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"& h2018).UTF8Text)
                                            Call SetMaterial(h2018&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UPartiIdG"& h2018).UTF8Text)
                                        next
                                end if
                        end if
                        PaintParlamento()
                        PlayAnim("IN")
                        buffer_send(main_machine)
                else
                        exit sub
                end if
       elseif rdIttifak.Checked = true then

       '#2
                if cb2018Getir.Checked = false then

                        btnYayindaPartilerAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = true
                        btnYayinaVer2018Partiler.Visible = false
                        btnYayinaVer2018Ittifaklar.Visible = false

                        buffer_clear()

                        Call SetActive("14_mayis_mv_logo", 1)
                        Call SetText("baslik_isim", lblIttifak.UTF8Text)
                        Call SetText("yil",lbl2023.UTF8Text)
                        Call SetActive("ass", "0")
                        Call SetActive("ajansAnka", "0")
                        Call SetActive("ajansAA", "0")

                        Call SetKeyframe("acilan","end","VALUE", g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))
                        Call SetKeyframe("acilan_pie","end","VALUE", g_lib.YuzdeKorumaYuvarlama(txtAcilanSandikBilgisi.UTF8Text))

                        if g_lib.CDblSafe(txtAcilanSandikBilgisi.UTF8Text) >= 100 then
                                buffer_put("-1 RENDERER*TREE*@acilan*FUNCTION*Advanced_Counter*inpmask SET ###")
                        else
                                buffer_put("-1 RENDERER*TREE*@acilan*FUNCTION*Advanced_Counter*inpmask SET ####.#")
                        end if

                        Call SetActive("1GRUP","0")
                        Call SetActive("2GRUP","0")
                        Call SetActive("3GRUP","0")
                        Call SetActive("4GRUP","0")
                        Call SetActive("5GRUP","0")
                        Call SetActive("6GRUP","0")
                        Call SetActive("7GRUP","0")
                        Call SetActive("8GRUP","0")

                        dim cntr6:cntr6 = 0
                        dim y1

                        for y1 = 1 to 6 step 1
                            if CInt(findcomponent("IttifakMvAA"&y1).UTF8Text) > 0 then
                                  cntr6 = cntr6 +1
                            end if
                        next

                        if cntr6 <= 4 then
                              Call SetActive("ust_grp", "1")
                              if cntr6 = 1 then
                                 Call SetActive("1GRUP", "1")
                              elseif cntr6 = 2 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                              elseif cntr6 = 3 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                              elseif cntr6 = 4 then
                                Call SetActive("1GRUP", "1")
                                Call SetActive("2GRUP", "1")
                                Call SetActive("3GRUP", "1")
                                Call SetActive("4GRUP", "1")
                              end if

                              dim g2
                              for g2 = 1 to 4 step 1
                                Call SetText(g2&"mv", findcomponent("IttifakMvAA"&g2).UTF8Text)
                                Call SetText(g2&"isim", findcomponent("IttifakAdiAA"&g2).UTF8Text)
                                Call SetMaterial(g2&"legend", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&g2).UTF8Text)
                                Call SetMaterial(g2&"back", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&g2).UTF8Text)
                              next

                        elseif cntr6 > 4 then
                               Call SetActive("ust_grp", "1")
                               Call SetActive("alt_grp", "1")
                                if cntr6 = 5 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        dim b2
                                        for b2 = 1 to 3 step 1
                                            Call SetText(b2&"mv", findcomponent("IttifakMvAA"&b2).UTF8Text)
                                            Call SetText(b2&"isim", findcomponent("IttifakAdiAA"&b2).UTF8Text)
                                            Call SetMaterial(b2&"legend", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&b2).UTF8Text)
                                            Call SetMaterial(b2&"back", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&b2).UTF8Text)
                                        next
                                        dim c2
                                        for c2 = 5 to 6 step 1
                                            Call SetText(c2&"mv", findcomponent("IttifakMvAA"&(c2-1)).UTF8Text)
                                            Call SetText(c2&"isim", findcomponent("IttifakAdiAA"&(c2-1)).UTF8Text)
                                            Call SetMaterial(c2&"legend", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&(c2-1)).UTF8Text)
                                            Call SetMaterial(c2&"back", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&(c2-1)).UTF8Text)
                                        next
                                elseif cntr6 = 6 then
                                        Call SetActive("1GRUP", "1")
                                        Call SetActive("2GRUP", "1")
                                        Call SetActive("3GRUP", "1")
                                        Call SetActive("5GRUP", "1")
                                        Call SetActive("6GRUP", "1")
                                        Call SetActive("7GRUP", "1")
                                        dim d2
                                        for d2 = 1 to 4 step 1
                                            Call SetText(d2&"mv", findcomponent("IttifakMvAA"&d2).UTF8Text)
                                            Call SetText(d2&"isim", findcomponent("IttifakAdiAA"&d2).UTF8Text)
                                            Call SetMaterial(d2&"legend", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&d2).UTF8Text)
                                            Call SetMaterial(d2&"back", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&d2).UTF8Text)
                                        next
                                        dim e2
                                        for e2 = 5 to 7 step 1
                                            Call SetText(e2&"mv", findcomponent("IttifakMvAA"&(e2-1)).UTF8Text)
                                            Call SetText(e2&"isim", findcomponent("IttifakAdiAA"&(e2-1)).UTF8Text)
                                            Call SetMaterial(e2&"legend", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&(e2-1)).UTF8Text)
                                            Call SetMaterial(e2&"back", "SECIM_2023/SOZCU/ITTIFAK_RENK/"&findcomponent("IttifakIdAA"&(e2-1)).UTF8Text)
                                        next
                                end if
                        end if

                        PaintParlamento()
                        PlayAnim("IN")
                        buffer_send(main_machine)

                elseif rdIttifak.Checked = true AND cb2018Getir.Checked = true then

                        btnYayindaPartilerAA.Visible = false
                        btnYayindaIttifaklarAA.Visible = false
                        btnYayindaPartilerAA.Visible = false
                        btnYayinaVer2018Partiler.Visible = false
                        btnYayinaVer2018Ittifaklar.Visible = true

                        buffer_clear()

                        Call SetActive("14_mayis_mv_logo", 0)
                        Call SetText("baslik_isim", lblIttifak.UTF8Text)
                        Call SetText("yil",lbl2018.UTF8Text)
                        Call SetActive("ass", "0")
                        Call SetActive("ajansAnka", "0")
                        Call SetActive("ajansAA", "0")

                        Call SetActive("1GRUP","0")
                        Call SetActive("2GRUP","0")
                        Call SetActive("3GRUP","0")
                        Call SetActive("4GRUP","0")
                        Call SetActive("5GRUP","0")
                        Call SetActive("6GRUP","0")
                        Call SetActive("7GRUP","0")
                        Call SetActive("8GRUP","0")

                        dim cntr5:cntr5 = 0

                        Call SetActive("ust_grp", "1")
                        Call SetActive("1GRUP", "1")
                        Call SetActive("2GRUP", "1")
                        Call SetActive("3GRUP", "1")
                        dim i2018
                        for i2018 = 1 to 3 step 1
                                Call SetText(i2018&"mv", findcomponent("UIttifakMv"& i2018).UTF8Text)
                                Call SetText(i2018&"isim", findcomponent("UIttifakAdi"& i2018).UTF8Text)
                                Call SetMaterial(i2018&"legend", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UIttifakId"& i2018).UTF8Text)
                                Call SetMaterial(i2018&"back", "SECIM_2023/SOZCU/PARTI_RENKLER/"&findcomponent("UIttifakId"& i2018).UTF8Text)
                        next

                        PaintParlamento()
                        PlayAnim("IN")
                        buffer_send(main_machine)
                else
                        exit sub
                end if
       end if
End sub

Sub PaintParlamentoYasakli()
    Dim a
    for a = 1 to 600
       buffer_put("-1 RENDERER*TREE*@"&a&"*FUNCTION*DataMaterialIndex*offset SET 0")
    Next

   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=")
   buffer_put("-1 RENDERER*FUNCTION*DataPool*Data SET Index=0;")
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

Sub cb2018GetirClick(Sender)
  gb2018Partiler.Visible = true
  gb2018Ittifaklar.Visible = true
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

Sub btnClearClick(Sender)
TWUniButton1.Enabled = false
       Call g_lib.ListBoxClear(lbHavuz)
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
        PaintParlamento2()
        PlayAnim("IN")
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

Sub Btn_Yayindan_AlClickClick(Sender)
    buffer_clear()
    buffer_put("-1 RENDERER SET_OBJECT ")
    buffer_send(main_machine)
End sub