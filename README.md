# SKDemo

1.圖片列表頁面用UICollectionViewCompositionalLayout來製作每個cell item的變化。

2.image fetch data時存cache, 以urlString當key。

3.首頁navigation bar搜尋列，可搜尋相簿名稱，大小寫均可。

4.剛進入頁面時GET三支api，concurrent的方式併發同時執行後DispatchGroup notify做後續。
