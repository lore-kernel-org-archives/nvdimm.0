Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9BD020957B02
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 11:50:57 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/4] libndctl: fix potential buffer overflow in
 write_cache APIs
Date: Thu,  3 May 2018 12:50:47 -0600
Message-Id: <20180503185050.7559-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We used a local stack variable to hold the sysfs path, which had a
potential to overflow. Instead, switch to the 'scratch space' bdbs->buf
to store the sysfs path as it is correctly sized for it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 59ea82a..2a3ef0c 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3991,10 +3991,10 @@ static int __ndctl_namespace_set_write_cache(struct ndctl_namespace *ndns,
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
 	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	char *path = ndns->ndns_buf;
 	char buf[SYSFS_ATTR_SIZE];
 	int len = ndns->buf_len;
 	const char *bdev;
-	char path[50];
 
 	if (state != 1 && state != 0)
 		return -ENXIO;
@@ -4034,9 +4034,9 @@ NDCTL_EXPORT int ndctl_namespace_write_cache_is_enabled(
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
 	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
 	int len = ndns->buf_len, wc;
+	char *path = ndns->ndns_buf;
 	char buf[SYSFS_ATTR_SIZE];
 	const char *bdev;
-	char path[50];
 
 	if (pfn)
 		bdev = ndctl_pfn_get_block_device(pfn);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
