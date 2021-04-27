import os
from zipfile import ZipFile
import requests
from google.cloud import storage


PATH = "/tmp/"
BUCKET = os.getenv("bucket_name")
FOLDER_ZONE = os.getenv("folder_zone")
storage_client = storage.Client()


def fn_download_data_into_rawzone(event, context):
    """

    :param event:
    :param context:
    :return:
    """
    if "data" in event:

        try:
            filename = event["data"].split("/")[-1]
            download_data(url=event["data"], path=PATH, filename=filename)
            zip_extract(path=PATH, filename=filename)

            bucket = storage_client.get_bucket(bucket_or_name=BUCKET)
            files = os.listdir(path=PATH)

            for file in files:
                blob = bucket.blob(blob_name=FOLDER_ZONE + "/" + file)
                blob.upload_from_filename(filename=PATH + file)

            print("Job finished!")

        except Exception as err:
            print(err)


def download_data(url: str, path: str, filename: str):
    header = {
        "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) "
                      "Chrome/50.0.2661.75 Safari/537.36",
        "X-Requested-With": "XMLHttpRequest"
    }
    file = requests.get(url=url, headers=header)
    zip_file = open(path + filename, "wb")
    zip_file.write(file.content)
    zip_file.close()


def zip_extract(path: str, filename: str):
    try:
        zip_file = ZipFile(path + filename, 'r')
        zip_file.extractall(path)
        zip_file.close()
        os.remove(path + filename)
    except Exception as err:
        print(err)
