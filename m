Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C7F281F17
 for <linux-nvdimm@lists.01.org>; Tue,  6 Dec 2016 17:39:02 -0800 (PST)
Subject: [ndctl PATCH] test, device-dax: test read-only mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Dec 2016 17:34:52 -0800
Message-ID: <148107449265.11076.1913078641623047618.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hugh notes:
"I think that is more restrictive than you intended: haven't tried, but
I believe it rejects a PROT_READ, MAP_SHARED, O_RDONLY fd mmap, leaving
no way to mmap /dev/dax without write permission to it."

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/device-dax.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/test/device-dax.c b/test/device-dax.c
index 82154d5c1fff..75b17ed63088 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -201,22 +201,22 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	}
 
 	sprintf(path, "/dev/%s", daxctl_dev_get_devname(dev));
-	fd = open(path, O_RDWR);
+	fd = open(path, O_RDONLY);
 	if (fd < 0) {
-		fprintf(stderr, "%s: failed to open device-dax instance\n",
+		fprintf(stderr, "%s: failed to open(O_RDONLY) device-dax instance\n",
 				daxctl_dev_get_devname(dev));
 		rc = -ENXIO;
 		goto out;
 	}
 
-	buf = mmap(NULL, VERIFY_SIZE, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	buf = mmap(NULL, VERIFY_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
 	if (buf != MAP_FAILED) {
 		fprintf(stderr, "%s: expected MAP_PRIVATE failure\n", path);
 		rc = -ENXIO;
 		goto out;
 	}
 
-	buf = mmap(NULL, VERIFY_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	buf = mmap(NULL, VERIFY_SIZE, PROT_READ, MAP_SHARED, fd, 0);
 	if (buf == MAP_FAILED) {
 		fprintf(stderr, "%s: expected MAP_SHARED success\n", path);
 		return -ENXIO;
@@ -226,6 +226,24 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	if (rc)
 		goto out;
 
+	/* upgrade to a writable mapping */
+	close(fd);
+	munmap(buf, VERIFY_SIZE);
+	fd = open(path, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open(O_RDWR) device-dax instance\n",
+				daxctl_dev_get_devname(dev));
+		rc = -ENXIO;
+		goto out;
+	}
+
+	buf = mmap(NULL, VERIFY_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (buf == MAP_FAILED) {
+		fprintf(stderr, "%s: expected PROT_WRITE + MAP_SHARED success\n",
+				path);
+		return -ENXIO;
+	}
+
 	/*
 	 * Prior to 4.8-final these tests cause crashes, or are
 	 * otherwise not supported.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
