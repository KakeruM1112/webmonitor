import traceback
import json
from pprint import pprint
import requests
import sys
import slackweb
from requests.exceptions import Timeout

def send_mail():
    pass

def notify_slack(url, status, slack_webhook_url):
    pprint("Notify slack..")
    slack = slackweb.Slack(url = slack_webhook_url)
    slack.notify(text = ("%s returns status: %s" % (url, status)))

def main(args):
    url = args['url']
    slack_webhook_url = args['slack_webhook_url']
    timeout = args.get('timeout', 10) # In seconds. Defaults to 10 seconds.
    try:
        resp = requests.get(url, timeout = timeout)
        status = resp.status_code
        if status < 200 or 400 <= status:
            notify_slack(url, status, slack_webhook_url)
        return {"status": status}
    except Timeout:
        notify_slack(url, "Request timedout. (timeout = %d)" % timeout, slack_webhook_url)
    except:
        notify_slack(url, traceback.format_exc(), slack_webhook_url)

if __name__ == '__main__':
    pprint(main(json.loads(sys.argv[1])))
