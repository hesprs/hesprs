# Local Nextcloud test

One-time Nextcloud 34 instance for local WebDAV testing with network shaping:

- Upload: maximum 3 MiB/s
- Download: maximum 5 MiB/s
- Delay: 300 ms
- Address: `http://127.0.0.1:8080`

## Start

Run:

```bash
cd Bits/Nextcloud
./nextcloud-up
```

WebDAV credentials:

```text
URL:      http://127.0.0.1:8080/remote.php/dav/files/webdav/
Username: webdav
Password: webdav-test-password
```

## Tear down

```bash
cd Bits/Nextcloud
./nextcloud-down
```

Teardown removes containers, temporary data, and images pulled only by this test. No host network qdisc is changed.
