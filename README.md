# mq-crawler

基于 [mq-crawler](https://github.com/harehare/mq) 修改的网页爬虫，
项目地址：<https://github.com/raystyle/mq-crawl>。
抓取 HTML 内容并转换为 Markdown，支持使用 [mq](https://mqlang.org) 查询对内容进行过滤和转换。

相比原版的改动：移除了 robots.txt 限制，屏蔽了 chromiumoxide 的 CDP 反序列化警告日志。

## 安装

```sh
cargo install mq-crawler
```

## 快速上手

```powershell
# 爬取页面，Markdown 输出到终端
mq-crawl https://example.com

# 静默输出，只保留 Markdown 内容
mq-crawl https://example.com 2> $null

# 保存到文件
mq-crawl -o ./output https://example.com

# 仅爬取起始页面，不跟踪链接
mq-crawl --depth 0 https://example.com

# 爬取 2 层深度，3 个并发
mq-crawl -c 3 --depth 2 https://example.com
```

Markdown 输出到 **stdout**，日志和统计信息输出到 **stderr**。用 `2> $null`（PowerShell）或 `2>/dev/null`（Bash）屏蔽日志。

## 无头 Chrome

适用于 SPA 等动态页面。

```powershell
# 基本用法
mq-crawl --headless --depth 0 https://spa-example.com

# 等待网络空闲后再提取内容
mq-crawl --headless --headless-network-idle --depth 0 https://spa-example.com

# 等待指定元素出现
mq-crawl --headless --headless-wait-for-selector "main" --depth 0 https://spa-example.com
```

## mq 查询

```powershell
# 仅提取标题
mq-crawl -q '.h' https://example.com

# 提取包含 "News" 的标题
mq-crawl -q '.h | select(contains("News"))' https://example.com

# 提取所有链接
mq-crawl -q '.link.url' https://example.com
```

## 命令行选项

```text
mq-crawl [选项] <URL>

  -d, --crawl-delay <秒数>         请求延迟 [默认: 1]
  -c, --concurrency <N>            并发数 [默认: 1]
      --depth <N>                  最大爬取深度
  -q, --mq-query <查询>           mq 查询
  -o, --output <目录>              输出目录（默认 stdout）
  -f, --format <text|json>         统计信息格式 [默认: text]
      --allowed-domains <域名>     额外允许爬取的域名（逗号分隔）
      --headless                   使用无头 Chrome
      --headless-network-idle      等待网络空闲
      --headless-wait-for-selector <选择器>
                                  等待 CSS 选择器出现
  -U, --webdriver-url <URL>        WebDriver 地址
      --extract-scripts-as-code-blocks
      --generate-front-matter      生成 YAML front matter
      --use-title-as-h1            使用 <title> 作为 H1
```

## 许可证

MIT
