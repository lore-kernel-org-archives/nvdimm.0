Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78B44224BBC5E
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 13:47:12 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, sysfs: null terminate buffer on error
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 20 Mar 2018 13:44:37 -0700
Message-ID: <152157867701.19898.6466178424544300544.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Terminate the buffer for sysfs_read_attr() users that might not
properly handle the error code.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/sysfs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/util/sysfs.c b/util/sysfs.c
index e067f065a820..0440fd0f49a3 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -39,6 +39,7 @@ int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
 	n = read(fd, buf, SYSFS_ATTR_SIZE);
 	close(fd);
 	if (n < 0 || n >= SYSFS_ATTR_SIZE) {
+		buf[0] = 0;
 		log_dbg(ctx, "failed to read %s: %s\n", path, strerror(errno));
 		return -errno;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
