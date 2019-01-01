Diamond Chain


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

