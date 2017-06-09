Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04AF721A143FE
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:33:01 -0700 (PDT)
Subject: [ndctl PATCH] util: distinguish error codes for sysfs_{read,
 write}_attr()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:27:44 -0700
Message-ID: <149698606405.12023.3409783083697026090.stgit@dwillia2-desk3.amr.corp.intel.com>
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

There are occasions where it would be good to know the difference
between a sysfs attribute failing to be accessed because we could not
open versus could not read/write.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/sysfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/util/sysfs.c b/util/sysfs.c
index 31d1a898eba2..7905455890dc 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -34,13 +34,13 @@ int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
 
 	if (fd < 0) {
 		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
-		return -1;
+		return -ENOENT;
 	}
 	n = read(fd, buf, SYSFS_ATTR_SIZE);
 	close(fd);
 	if (n < 0 || n >= SYSFS_ATTR_SIZE) {
 		log_dbg(ctx, "failed to read %s: %s\n", path, strerror(errno));
-		return -1;
+		return -EIO;
 	}
 	buf[n] = 0;
 	if (n && buf[n-1] == '\n')
@@ -56,7 +56,7 @@ static int write_attr(struct log_ctx *ctx, const char *path,
 
 	if (fd < 0) {
 		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
-		return -1;
+		return -ENOENT;
 	}
 	n = write(fd, buf, len);
 	close(fd);
@@ -64,7 +64,7 @@ static int write_attr(struct log_ctx *ctx, const char *path,
 		if (!quiet)
 			log_dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
 					strerror(errno));
-		return -1;
+		return -EIO;
 	}
 	return 0;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
