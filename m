Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3CF92211C64B1
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 17:53:00 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/4] libndctl: fix a couple of theoretical buffer
 overruns
Date: Fri,  1 Feb 2019 18:52:52 -0700
Message-Id: <20190202015253.20051-3-vishal.l.verma@intel.com>
In-Reply-To: <20190202015253.20051-1-vishal.l.verma@intel.com>
References: <20190202015253.20051-1-vishal.l.verma@intel.com>
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

Static analysis reports that the ndctl_dimm_get_security() function can
overflow 'buf'. Just above it, ndctl_dimm_get_available_labels() seems
to make the same mistake. Fix both of these by allocating a buffer of
the correct size.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/dimm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 0a4ca79..22cf4e1 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -582,7 +582,7 @@ NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char *path = dimm->dimm_buf;
 	int rc, len = dimm->buf_len;
-	char buf[20];
+	char buf[SYSFS_ATTR_SIZE];
 
 	if (snprintf(path, len, "%s/available_slots", dimm->dimm_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
@@ -605,8 +605,8 @@ NDCTL_EXPORT enum ndctl_security_state ndctl_dimm_get_security(
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char *path = dimm->dimm_buf;
+	char buf[SYSFS_ATTR_SIZE];
 	int len = dimm->buf_len;
-	char buf[64];
 	int rc;
 
 	if (snprintf(path, len, "%s/security", dimm->dimm_path) >= len) {
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
