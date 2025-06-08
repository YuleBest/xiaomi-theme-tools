# 下载国际版主题字体
# 此脚本可以帮助你快速下载国际版主题商店的字体
# test-v0.1

# By Yule
# 免费分享，禁止商用

# 配置
DOWN_DIR="/storage/emulated/0/Download/xttdown"
mkdir -p "$DOWN_DIR" >/dev/null 2>&1
gr='\033[0;32m'
ye='\033[1;33m'
re='\033[0;31m'
bl='\033[0;36m'
res='\033[0m'
clear

# 环境检查
if [[ "$PREFIX" != "/data/data/com.termux/files/usr" ]]; then
    echo -e "${re}[错误] 仅支持 Termux 环境${res}"
    exit 1
fi
if [ "$BASH" != "/data/data/com.termux/files/usr/bin/bash" ]; then
    echo -e "${re}[错误] 请使用 Bash 运行本脚本${res}"
    exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
    echo -e "${re}[错误] 缺少 jq，请安装后重试${res}"
    exit 1
fi
if ! command -v wget >/dev/null 2>&1; then
    echo -e "${re}[错误] 缺少 wget，请安装后重试${res}"
    exit 1
fi

# 欢迎
echo -e "${bl}小米主题工具集 - 下载国际版主题字体${res}"
echo -e "By 酷安 @于乐Yule"
echo -e "\n----------\n"

# 关键词输入
echo -ne "${ye}请输入字体关键词: ${res}"
read -r KEYWORD
[[ -z "$KEYWORD" ]] && echo -e "${re}输入不能为空，程序退出${res}" && exit 1

NOW_PAGE=0
while true; do
    echo -e "\n${ye}>>> 正在请求搜索接口（第 $((NOW_PAGE+1)) 页）...${res}"
    SEARCH_API="https://thm.market.intl.xiaomi.com/thm/search/npage?category=Font&keywords=${KEYWORD}&page=${NOW_PAGE}"
    resp=$(curl -s "$SEARCH_API")

    # 获取标题和链接
    titles=($(echo "$resp" | jq -r '.apiData.cards[].items[].schema.clicks[].title'))
    links=($(echo "$resp" | jq -r '.apiData.cards[].items[].schema.clicks[].link'))

    count=${#titles[@]}
    if [ "$count" -eq 0 ]; then
        echo -e "${re}- 未找到相关字体，换个关键词试试？${res}"
        exit 1
    fi

    echo -e "${gr}字体列表：${res}"
    for i in "${!titles[@]}"; do
        printf "  ${ye}%2d${res}. %s\n" "$((i + 1))" "${titles[$i]}"
    done

    echo -ne "${ye}请输入序号下载，或输入 n(下一页)/p(上一页)/q(退出): ${res}"
    read -r input

    if [[ "$input" =~ ^[0-9]+$ ]]; then
        INDEX=$((input - 1))
        if [[ "$INDEX" -lt 0 || "$INDEX" -ge "$count" ]]; then
            echo -e "${re}无效序号，请重新输入${res}"
            continue
        fi

        TITLE="${titles[$INDEX]}"
        A_ID="${links[$INDEX]}"
        echo -e "\n${gr}你选择了：${ye}$TITLE${res}${gr}（ID: ${ye}$A_ID${res}${gr}）${res}"

        DETAILS_API="https://api.zhuti.intl.xiaomi.com/app/v9/uipages/theme/${A_ID}"
        echo -e "${ye}\n>>> 获取字体详情...${res}"
        detail=$(curl -s "$DETAILS_API")
        DOWN_URL=$(echo "$detail" | jq -r '.apiData.extraInfo.themeDetail.downloadUrl')

        if [[ "$DOWN_URL" == "null" || -z "$DOWN_URL" ]]; then
            echo -e "${re}[错误] 获取下载链接失败${res}"
            echo "$detail" | jq .
            continue
        fi

        ENCODED_TITLE=$(printf "%s" "$TITLE" | jq -sRr @uri)
        DL_URL="https://f17.market.xiaomi.com/issue/${DOWN_URL}/${ENCODED_TITLE}.mtz"
        SAVE_PATH="${DOWN_DIR}/${TITLE}.mtz"

        echo -e "${bl}下载链接：${res}${DL_URL}"
        echo -e "${bl}保存路径：${res}${SAVE_PATH}"

        echo -e "${ye}\n>>> 开始下载，请稍候...${res}"
        wget -q --show-progress -O "$SAVE_PATH" "$DL_URL"
        echo ""
        if [[ $? -eq 0 ]]; then
            echo -e "${gr}ovo 下载完成！文件已保存到：${ye}${SAVE_PATH}${res}"
        else
            echo -e "${re}>_< 下载失败，请检查网络或链接${res}"
        fi
        exit 0
    elif [[ "$input" == "n" ]]; then
        ((NOW_PAGE++))
    elif [[ "$input" == "p" && "$NOW_PAGE" -gt 0 ]]; then
        ((NOW_PAGE--))
    elif [[ "$input" == "q" ]]; then
        echo -e "${gr}已退出程序，感谢使用！${res}"
        exit 0
    else
        echo -e "${re}无效输入，请重新输入${res}"
    fi
done