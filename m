Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E414881E86
 for <linux-nvdimm@lists.01.org>; Fri, 18 Nov 2016 09:06:50 -0800 (PST)
Subject: [PATCH v2] libnvdimm: clear poison in mem map metadata
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 18 Nov 2016 10:06:55 -0700
Message-ID: <147948881573.51395.14734124244596181990.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Clearing out the poison in the metadata block of the namespace before
we use it. Range from start + 8k to pfn_sb->dataoff.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/pfn_devs.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index cea8350..30c7eaf 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -527,11 +527,41 @@ static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 		.base_pfn = init_altmap_base(base),
 		.reserve = init_altmap_reserve(base),
 	};
+	sector_t sector;
+	resource_size_t meta_start, meta_size;
+	long cleared;
+	unsigned int sz_align;
 
 	memcpy(res, &nsio->res, sizeof(*res));
 	res->start += start_pad;
 	res->end -= end_trunc;
 
+	meta_start = res->start + SZ_8K;
+	meta_size = offset - meta_start + 1;
+
+	if (meta_start + meta_size > offset)
+		return ERR_PTR(-EINVAL);
+
+	sector = meta_start >> 9;
+	sz_align = ALIGN(meta_size + (meta_start & (512 - 1)), 512);
+
+	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
+		if (IS_ALIGNED(meta_start, 512) && IS_ALIGNED(meta_size, 512)) {
+			cleared = nvdimm_clear_poison(&nd_pfn->dev,
+						      meta_start, meta_size);
+			if (cleared <= 0)
+				return ERR_PTR(-EIO);
+			else {
+				badblocks_clear(&nsio->bb, sector,
+						cleared >> 9);
+				if (cleared != meta_size)
+					return ERR_PTR(-EIO);
+
+			}
+		} else
+			return ERR_PTR(-EIO);
+	}
+
 	if (nd_pfn->mode == PFN_MODE_RAM) {
 		if (offset < SZ_8K)
 			return ERR_PTR(-EINVAL);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
