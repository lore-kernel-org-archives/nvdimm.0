Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com
 [IPv6:2607:f8b0:4864:20::843])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B44852122CA9A
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 08:08:40 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id a17so18131771qth.3
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 08:08:40 -0700 (PDT)
From: Qian Cai <cai@lca.pw>
Subject: [RESEND PATCH] nvdimm: fix some compilation warnings
Date: Tue, 14 May 2019 11:07:35 -0400
Message-Id: <20190514150735.39625-1-cai@lca.pw>
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
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
List-ID: <linux-nvdimm@lists.01.org>

Several places (dimm_devs.c, core.c etc) include label.h but only
label.c uses NSINDEX_SIGNATURE, so move its definition to label.c
instead.
In file included from drivers/nvdimm/dimm_devs.c:23:
drivers/nvdimm/label.h:41:19: warning: 'NSINDEX_SIGNATURE' defined but
not used [-Wunused-const-variable=]

The commit d9b83c756953 ("libnvdimm, btt: rework error clearing") left
an unused variable.
drivers/nvdimm/btt.c: In function 'btt_read_pg':
drivers/nvdimm/btt.c:1272:8: warning: variable 'rc' set but not used
[-Wunused-but-set-variable]

Last, some places abuse "/**" which is only reserved for the kernel-doc.
drivers/nvdimm/bus.c:648: warning: cannot understand function prototype:
'struct attribute_group nd_device_attribute_group = '
drivers/nvdimm/bus.c:677: warning: cannot understand function prototype:
'struct attribute_group nd_numa_attribute_group = '

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/nvdimm/btt.c   | 6 ++----
 drivers/nvdimm/bus.c   | 4 ++--
 drivers/nvdimm/label.c | 2 ++
 drivers/nvdimm/label.h | 2 --
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 4671776f5623..9f02a99cfac0 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1269,11 +1269,9 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 
 		ret = btt_data_read(arena, page, off, postmap, cur_len);
 		if (ret) {
-			int rc;
-
 			/* Media error - set the e_flag */
-			rc = btt_map_write(arena, premap, postmap, 0, 1,
-				NVDIMM_IO_ATOMIC);
+			btt_map_write(arena, premap, postmap, 0, 1,
+				      NVDIMM_IO_ATOMIC);
 			goto out_rtt;
 		}
 
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 7ff684159f29..2eb6a6cfe9e4 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -642,7 +642,7 @@ static struct attribute *nd_device_attributes[] = {
 	NULL,
 };
 
-/**
+/*
  * nd_device_attribute_group - generic attributes for all devices on an nd bus
  */
 struct attribute_group nd_device_attribute_group = {
@@ -671,7 +671,7 @@ static umode_t nd_numa_attr_visible(struct kobject *kobj, struct attribute *a,
 	return a->mode;
 }
 
-/**
+/*
  * nd_numa_attribute_group - NUMA attributes for all devices on an nd bus
  */
 struct attribute_group nd_numa_attribute_group = {
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index f3d753d3169c..02a51b7775e1 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -25,6 +25,8 @@ static guid_t nvdimm_btt2_guid;
 static guid_t nvdimm_pfn_guid;
 static guid_t nvdimm_dax_guid;
 
+static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
+
 static u32 best_seq(u32 a, u32 b)
 {
 	a &= NSINDEX_SEQ_MASK;
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index e9a2ad3c2150..4bb7add39580 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -38,8 +38,6 @@ enum {
 	ND_NSINDEX_INIT = 0x1,
 };
 
-static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
-
 /**
  * struct nd_namespace_index - label set superblock
  * @sig: NAMESPACE_INDEX\0
-- 
2.20.1 (Apple Git-117)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
