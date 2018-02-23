Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F942222F4E37
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 23:02:31 -0800 (PST)
Subject: [ndctl PATCH] ndctl,
 firmware-update: kill usage of flock() in verify_fw_file()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Feb 2018 22:59:27 -0800
Message-ID: <151936916717.18166.15323371299792291219.stgit@dwillia2-desk3.amr.corp.intel.com>
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

It serves no purpose, we never explicitly unlock it, and it causes
needless failures if the firmware file happens to be on a filesystem
that does not support file locks.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/update.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/ndctl/update.c b/ndctl/update.c
index 4ca6a0d0f744..0f0f0d8172c4 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -470,12 +470,6 @@ static int verify_fw_file(struct update_context *uctx)
 	if (uctx->fw_fd < 0)
 		return -errno;
 
-	rc = flock(uctx->fw_fd, LOCK_EX | LOCK_NB);
-	if (rc < 0) {
-		rc = -errno;
-		goto cleanup;
-	}
-
 	if (fstat(uctx->fw_fd, &st) < 0) {
 		rc = -errno;
 		goto cleanup;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
