import json
import os
from google.cloud import pubsub_v1


service_account = "../config/service-account.json"
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = service_account
PROJECT_ID = "dataengineer-310515"
publisher = pubsub_v1.PublisherClient()


def list_topics():
    project_path = f"projects/{PROJECT_ID}"

    for topic in publisher.list_topics(project_path):
        print(topic)


def publish(topic: str, message: str):

    topic_path = publisher.topic_path(PROJECT_ID, topic)

    message = json.dumps({
        "data": message
    }).encode("utf-8")

    try:
        publish = publisher.publish(topic=topic_path, data=message)
        publish.result()
        return "Message published"
    except Exception as err:
        print(err)


if __name__ == '__main__':
    list_topics()
    # publish(topic="datawarehouse-lab", message="http://encurtador.com.br/BDF58")
