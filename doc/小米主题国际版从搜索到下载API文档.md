# 小米国际版主题商店从搜索到下载 - API 文档

By Yule

本文档说明了怎么通过小米公开的 API 来搜索和下载小米主题商店国际版的主题。
主题的下载需要经过「搜索 - 获取详情 - 下载」三个过程，以下一一说明。

## 搜索主题

API: `https://thm.market.intl.xiaomi.com/thm/search/npage?category=[TYPE]&keywords=[KEYWORD]&page=[NOW_PAGE]`

### 请求参数
- `[TYPE]`: 要搜索的主题类型, 可使用 `Theme`, `Font` 或 `Wallpaper`
- `[KEYWORD]`: 要搜索的关键词，可使用任意英文字符串，不可包含空格
- `[NOW_PAGE]`: 要浏览的页码，可使用 0 以上的整数

### 返回数据
返回的数据为 JSON 格式，以 `https://thm.market.intl.xiaomi.com/thm/search/npage?category=Font&keywords=hello&page=0` 为例，JSON 结构如下：

```json
{
  "apiCode": 0,
  "apiMessage": "success",
  "apiData": {
    "title": "searchNpage",
    "type": "sort",
    "background": "#EFEFF7",
    "tabs": "",
    "root": "https://t17.market.mi-img.com/thumbnail/",
    "hasMore": true,
    "uuid": "searchNpage-Font",
    "cards": [
      {
        "id": "searchNpage-Font-0",
        "background": "#FFFFFF",
        "items": [
          {
            "schema": {
              "clicks": [
                {
                  "pic": "ThemeMarket/08c3cd114d3fb47ee9bd7365ead29a4971ad63ad3",
                  "root": "https://t17.market.mi-img.com/",
                  "link": "392e93fb-86fd-4a9a-8f2b-bc914ce43037",
                  "title": "Hello",
                  "extra": {
                    "assemblyId": "65ff7ad4-19ea-403a-8f1a-e10e99a42a8f",
                    "originPrice": 0,
                    "productPrice": 0
                  },
                  "type": "detail",
                  "trackId": "searchNpage-Font-0-card_0_392e93fb-86fd-4a9a-8f2b-bc914ce43037_0_:0-0-0-0-0-0-0-0-0-0-0:_392e93fb-86fd-4a9a-8f2b-bc914ce43037:es:search-service-85014140-a746-4563-83f8-ae4f38817407",
                  "trackIdV2": "searchNpage-Font-0-card_0_392e93fb-86fd-4a9a-8f2b-bc914ce43037_0"
                },
                # .......
              ],
              "cols": 3,
              "value": "",
              "type": "Font"
            },
            "type": "endlessList"
          }
        ]
      }
    ]
  }
}
```

`.apiData.cards[].items[]` 数组中的每一个 item 就是一个主题，其中，需要注意的是 `title` 和 `link`，分别是主题的标题和定位链接，接下来需要用到。

## 获取主题详情

API: `https://api.zhuti.intl.xiaomi.com/app/v9/uipages/theme/[THEME_LINK]`

### 请求参数
- `[THEME_LINK]`: 即上一步获取到的主题 link

### 返回数据
返回的数据为 JSON 格式，以 `https://thm.market.intl.xiaomi.com/thm/search/npage?category=Font&keywords=hello&page=0` 为例，JSON 结构如下：

```json
{
  "apiCode": "0",
  "apiMessage": "success",
  "apiData": {
    "videoDownTimes": null,
    "hasMore": false,
    "cards": [
      {
        "backgroundColor": null,
        "deepHidden": false,
        "visible": true,
        "hidden": false,
        "trackId": "THEME-DETAIL-PAGE_0_THEME-OVERVIEW-CARD_392e93fb-86fd-4a9a-8f2b-bc914ce43037",
        # ......
    "extraInfo": {
      "themeDetail": {
        "changeLog": null,
        "downloadUrl": "ThemeMarket/0304adae386ae4564807d1b713a44f55711119236",
        "bigVideoUrl": null,
        "smallVideoUrl": null,
        "productType": "FONT",
        "like": false,
        "likeCount": 0,
        "onShelf": true,
        "disCent": 0,
        "disPer": 0,
        "previewVideoList": null,
        "testGroup": false,
        "copyright": false
      },
      "hasRecommend": false
    }
  }
}
```

省略号的地方一般会有一大堆内容，但那些对我们不重要，我们只需要关注 `extraInfo.themeDetail.downloadUrl`。

## 下载主题

API: `https://f17.market.xiaomi.com/issue/${DOWN_URL}/${TITLE}.mtz`

### 请求参数
- `[DOWN_URL]`: 上一步获取到的 downloadUrl
- `[TITLE]`: 第一步获取到的主题 title

## 参考

- [酷安 @清柠乐: 国际版字体提取下载·原理](https://coolapk.com/feed/64749631?s=YWJkOTliZTExMTVlZjMxZzY4NDUxYjQzegA15.3.1&shareUid=18214705&shareFrom=com.coolapk.market_15.3.1)
- [Akimlc 的 App: ThemeTool](https://github.com/Akimlc)