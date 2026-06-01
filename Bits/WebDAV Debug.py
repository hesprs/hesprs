#!/usr/bin/env python3
import requests

# Configuration
SERVER_URL = "http://localhost:5173"  # Base WebDAV endpoint
USERNAME = "your_account@xxx.org"  # Username
PASSWORD = "your_password"  # Your password or app token
FOLDER_PATH = "/test/"  # absolute folder path on server


def main():
    session = requests.Session()
    session.auth = (USERNAME, PASSWORD)
    target_url = SERVER_URL.rstrip("/") + FOLDER_PATH

    propfind_body = b"""<?xml version="1.0" encoding="utf-8"?>
<D:propfind xmlns:D="DAV:">
  <D:allprop/>
</D:propfind>"""

    resp_prop = session.request(
        "PROPFIND", target_url, headers={"Depth": "1"}, data=propfind_body
    )
    resp_prop.raise_for_status()
    print(resp_prop.text)


if __name__ == "__main__":
    main()
