# webmonitor
指定されたurlに対して、getリクエストを行い、ステータスコードが200未満あるは400以上れあれば、Slackに通知します。

## 前提

- Python3と、pip3がインストールされていること

## 初期設定

以下を最初に1回実行します。

    ./init.sh

## SlackのWebHookの作成

ブラウザで以下のURLを開いて、Incoming Webhooksの作り方について調べてください。

    https://api.slack.com/custom-integrations#migrating_to_apps

実際は以下のURLを開いてCreate your Slack appをクリックすれば作成できます。

    https://api.slack.com/messaging/webhooks

名前は自分の好きなもの、Workspaceで通知を受けたいSlack Workspaceを指定します。Workspaceの管理者が承認すると、以下に表示されるようになります。

    https://smrjprj.slack.com/apps/manage
    
以下にアクセスします。

    https://api.slack.com/
    
右上のYour Appsをクリックすると作成したアプリが一覧に表示されるのでクリックします。右のFeaturesメニューに"Incoming Webhooks"があるのでクリックします。Webhook URLが表示されるので、これをCopyボタンでコピーします。

## ローカルPCでの実行

以下を実行します。これでvirtualenv環境に入ります。

    . virtualenv/bin/activate

以下で実行します。

    python3 src/__main__.py '{"url": "https://xxx","slack_webhook_url":"https://yyy"}'

ここで、urlに指定しているのが監視対象のURL、slack_webhook_urlに指定しているのが上記で取得したWebhook URLです。実行すると以下のようにステータスコードが表示されます。

    {'status': 200}

URLをわざと存在しないものに変更して、Slackへの通知を確認してください。

## IBM Cloud functionsでの実行

### 名前空間の作成

IBM Cloudにブラウザでアクセスし、ダッシュボードからFunctionsを選びます。上にある"Current Namespace:"のドロップダウンから、Create Namespaceを選びます。Resource group/locationを入力して名前空間を作成します。

CLIでログインしてから以下を実行します(以下のXXXを上で作ったlocationに(東京ならjp-tok)、YYYをリソースグループ名に、ZZZを名前空間におきかえる)

    bx target -r XXX
    bx target -g YYY
    bx fn property set --namespace ZZZ

### デプロイ

アクションをデプロイします(既存のアクションを削除してからデプロイするため、最初の実行の際は削除が失敗しますが無視して良いです)

    ./deploy.sh

IBM Cloudにブラウザでアクセスし、ダッシュボードからFunctionsを選びます。Actionsを見るとwebmonitorが作成されています。

### トリガの作成

定期的に実行するためトリガを作成します。左のメニューからTriggersを選びます。Createを選び、Triggerを選びます。Periodicを選びます。名前を入れて、Time SettingsでCronを選んで、cronパターンを入力します。例えば以下は10分に一度の実行になります。

    */10 * * * *

Createをクリックします。次にトリガにパラメータを付与します。左にメニューからParametersを選びます。Add Parameterを選びます。これまでと同様にurlとslack_webhook_urlを設定します。なおこの画面ではParameter Valueは""で囲まないといけないので注意してください。Saveをクリックして保存します。

最後にトリガにアクションを追加します。左のメニューからConnected Actionsをクリックします。Addをクリックします。Select Existingを選び、作成しておいたwebmonitorアクションを選んでAddします。

これで10分に一度urlの監視が行われるようになります。実行結果は、左にあるMonitorで確認できます。複数のurlを監視したい時は、その分トリガを増やせば良いです。



