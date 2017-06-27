Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72ACA21A00AC1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 01:14:24 -0700 (PDT)
Received: by mail-pf0-x242.google.com with SMTP id e199so3763618pfh.0
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 01:15:54 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 1/4] libndctl: rename parse_lbasize to parse_sizes
Date: Tue, 27 Jun 2017 18:15:28 +1000
Message-Id: <20170627081531.7389-1-oohall@gmail.com>
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

We want to re-use this code to parse the list of supported alignments
for dax and PFN devices so rename the function to reflect the more
generic usage.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/lib/libndctl.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 4acebc05d6db..aa262f03303e 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -234,12 +234,12 @@ struct ndctl_region {
 };
 
 /**
- * struct ndctl_lbasize - lbasize info for btt and blk-namespace devices
+ * struct ndctl_sizes - list of supported sector or alignments
  * @select: currently selected sector_size
  * @supported: possible sector_size options
  * @num: number of entries in @supported
  */
-struct ndctl_lbasize {
+struct ndctl_sizes {
 	int select;
 	unsigned int *supported;
 	int num;
@@ -270,7 +270,7 @@ struct ndctl_namespace {
 	unsigned long long resource, size;
 	char *alt_name;
 	uuid_t uuid;
-	struct ndctl_lbasize lbasize;
+	struct ndctl_sizes lbasize;
 	int numa_node;
 };
 
@@ -291,7 +291,7 @@ struct ndctl_btt {
 	struct ndctl_region *region;
 	struct ndctl_namespace *ndns;
 	struct list_node list;
-	struct ndctl_lbasize lbasize;
+	struct ndctl_sizes lbasize;
 	unsigned long long size;
 	char *btt_path;
 	char *btt_buf;
@@ -2855,8 +2855,8 @@ static char *get_block_device(struct ndctl_ctx *ctx, const char *block_path)
 	return bdev_name;
 }
 
-static int parse_lbasize_supported(struct ndctl_ctx *ctx, const char *devname,
-		const char *buf, struct ndctl_lbasize *lba);
+static int parse_sizes(struct ndctl_ctx *ctx, const char *devname,
+		const char *buf, struct ndctl_sizes *lba);
 
 static void *add_namespace(void *parent, int id, const char *ndns_base)
 {
@@ -2908,7 +2908,7 @@ static void *add_namespace(void *parent, int id, const char *ndns_base)
 		sprintf(path, "%s/sector_size", ndns_base);
 		if (sysfs_read_attr(ctx, path, buf) < 0)
 			goto err_read;
-		if (parse_lbasize_supported(ctx, devname, buf, &ndns->lbasize) < 0)
+		if (parse_sizes(ctx, devname, buf, &ndns->lbasize) < 0)
 			goto err_read;
 		/* fall through */
 	case ND_DEVICE_NAMESPACE_PMEM:
@@ -3738,8 +3738,8 @@ NDCTL_EXPORT int ndctl_namespace_delete(struct ndctl_namespace *ndns)
 	return 0;
 }
 
-static int parse_lbasize_supported(struct ndctl_ctx *ctx, const char *devname,
-		const char *buf, struct ndctl_lbasize *lba)
+static int parse_sizes(struct ndctl_ctx *ctx, const char *devname,
+		const char *buf, struct ndctl_sizes *lba)
 {
 	char *s = strdup(buf), *end, *field;
 	void *temp;
@@ -3830,7 +3830,7 @@ static void *add_btt(void *parent, int id, const char *btt_base)
 	sprintf(path, "%s/sector_size", btt_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
-	if (parse_lbasize_supported(ctx, devname, buf, &btt->lbasize) < 0)
+	if (parse_sizes(ctx, devname, buf, &btt->lbasize) < 0)
 		goto err_read;
 
 	sprintf(path, "%s/size", btt_base);
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
