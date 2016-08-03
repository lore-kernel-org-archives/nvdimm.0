Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id D3E4D1A1DFF
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 15:58:07 -0700 (PDT)
Subject: [4.6 stable PATCH 2/2] libnvdimm, pfn,
 dax: fix initialization vs autodetect for mode + alignment
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Aug 2016 15:55:43 -0700
Message-ID: <147026494385.9715.17923671008418250054.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147026492600.9715.5445676747822316537.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147026492600.9715.5445676747822316537.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: stable@vger.kernel.org
Cc: Micah Parrish <micah.parrish@hpe.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

commit 1ee6667cd8d183b2fed12f97285f184431d2caf9 upstream.

The updated ndctl unit tests discovered that if a pfn configuration with
a 4K alignment is read from the namespace, that alignment will be
ignored in favor of the default 2M alignment.  The result is that the
configuration will fail initialization with a message like:

    dax6.1: bad offset: 0x22000 dax disabled align: 0x200000

Fix this by allowing the alignment read from the info block to override
the default which is 2M not 0 in the autodetect path.  This also fixes a
similar problem with the mode and alignment settings silently being
overwritten by the kernel when userspace has changed it.  We now will
either overwrite the info block if userspace changes the uuid or fail
and warn if a live setting disagrees with the info block.

Cc: <stable@vger.kernel.org>
Cc: Micah Parrish <micah.parrish@hpe.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |   50 +++++++++++++++++++++++++++++++++++++--------
 drivers/nvdimm/pmem.c     |    1 -
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 58bf68c9c414..84f2372dd0bb 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -329,6 +329,8 @@ struct device *nd_pfn_create(struct nd_region *nd_region)
 int nd_pfn_validate(struct nd_pfn *nd_pfn)
 {
 	u64 checksum, offset;
+	unsigned long align;
+	enum nd_pfn_mode mode;
 	struct nd_namespace_io *nsio;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
@@ -371,20 +373,50 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 		return -ENXIO;
 	}
 
+	align = le32_to_cpu(pfn_sb->align);
+	offset = le64_to_cpu(pfn_sb->dataoff);
+	if (align == 0)
+		align = 1UL << ilog2(offset);
+	mode = le32_to_cpu(pfn_sb->mode);
+
 	if (!nd_pfn->uuid) {
-		/* from probe we allocate */
+		/*
+		 * When probing a namepace via nd_pfn_probe() the uuid
+		 * is NULL (see: nd_pfn_devinit()) we init settings from
+		 * pfn_sb
+		 */
 		nd_pfn->uuid = kmemdup(pfn_sb->uuid, 16, GFP_KERNEL);
 		if (!nd_pfn->uuid)
 			return -ENOMEM;
+		nd_pfn->align = align;
+		nd_pfn->mode = mode;
 	} else {
-		/* from init we validate */
+		/*
+		 * When probing a pfn / dax instance we validate the
+		 * live settings against the pfn_sb
+		 */
 		if (memcmp(nd_pfn->uuid, pfn_sb->uuid, 16) != 0)
 			return -ENODEV;
+
+		/*
+		 * If the uuid validates, but other settings mismatch
+		 * return EINVAL because userspace has managed to change
+		 * the configuration without specifying new
+		 * identification.
+		 */
+		if (nd_pfn->align != align || nd_pfn->mode != mode) {
+			dev_err(&nd_pfn->dev,
+					"init failed, settings mismatch\n");
+			dev_dbg(&nd_pfn->dev, "align: %lx:%lx mode: %d:%d\n",
+					nd_pfn->align, align, nd_pfn->mode,
+					mode);
+			return -EINVAL;
+		}
 	}
 
-	if (nd_pfn->align > nvdimm_namespace_capacity(ndns)) {
+	if (align > nvdimm_namespace_capacity(ndns)) {
 		dev_err(&nd_pfn->dev, "alignment: %lx exceeds capacity %llx\n",
-				nd_pfn->align, nvdimm_namespace_capacity(ndns));
+				align, nvdimm_namespace_capacity(ndns));
 		return -EINVAL;
 	}
 
@@ -394,7 +426,6 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 	 * namespace has changed since the pfn superblock was
 	 * established.
 	 */
-	offset = le64_to_cpu(pfn_sb->dataoff);
 	nsio = to_nd_namespace_io(&ndns->dev);
 	if (offset >= resource_size(&nsio->res)) {
 		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
@@ -402,10 +433,11 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 		return -EBUSY;
 	}
 
-	nd_pfn->align = le32_to_cpu(pfn_sb->align);
-	if (!is_power_of_2(offset) || offset < PAGE_SIZE) {
-		dev_err(&nd_pfn->dev, "bad offset: %#llx dax disabled\n",
-				offset);
+	if ((align && !IS_ALIGNED(offset, align))
+			|| !IS_ALIGNED(offset, PAGE_SIZE)) {
+		dev_err(&nd_pfn->dev,
+				"bad offset: %#llx dax disabled align: %#lx\n",
+				offset, align);
 		return -ENXIO;
 	}
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 58ad81dcd1a5..368efac7a950 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -502,7 +502,6 @@ static int __nvdimm_namespace_attach_pfn(struct nd_pfn *nd_pfn)
 	pmem = dev_get_drvdata(dev);
 	pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
 	pmem->pfn_pad = start_pad + end_trunc;
-	nd_pfn->mode = le32_to_cpu(nd_pfn->pfn_sb->mode);
 	if (nd_pfn->mode == PFN_MODE_RAM) {
 		if (pmem->data_offset < SZ_8K)
 			return -EINVAL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
