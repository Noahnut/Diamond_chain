Diamond Chain
***
NOTE: Deploy contract gas limit 要大於5000000


目前輸入進去的都為鑽石ID，進入Contract要注意跟Owner對應的主要為那個ID在鑽石的Array上的index


對應關係為
ID -> Index -> Owner 


Owner -> Index 找到在Array上鑽石的Profile

***
***
鑽石金額計算公式

克拉數 * 100 * (淨度與顏色分級對照表金額)

NOTE!!!
在Create鑽石時 Color跟Clear請根據國際鑽石分級表代號

Color 


D -> G -> J -> M -> Z

Clear


FL -> VVS -> VS -> SL -> L1

Note:


鑽石等級表可以由公司更改


並在更改完後一定要按ChangeAllprice()


這樣金額才會改變，如果不做將會無法產生鑽石


***
開發者能夠透過gettheDiamond()來發現鑽石公司賣出鑽石

然後就會紀錄起來，透過showallunpay()來找到哪些鑽石是尚未付款


***
***

2018/12/29


@增加Premission控制


  ---創造Contract的就有建立鑽石履歷的權力
  
  
  ---擁有Root權限的可以授權他人為新的Root也可以刪除其他人(實際上這邊可能還需要投票的機制)
  
@增加能夠Show出所有自己本身擁有哪些鑽石

@Bug修正


使用者使用鑽石ID，在合約中會將ID轉成index，在利用index找到鑽石的資訊。

2019/01/01
@Bug修正

讓Create鑽石的id變成唯一


某些函式因為ID->Index的mapping被修改後，沒有被改過故無法運作，目前已修正

2019/01/03

將Tranfser刪除，讓轉移鑽石變成需要雙向確認。

2019/01/05

鑽石價格轉成浮動，會根據鑽石等級表改動

將權限分成開發者、公司、使用者

開發者拿到錢惹
