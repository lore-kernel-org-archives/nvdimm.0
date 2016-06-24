Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id C093E1A1DF1
 for <linux-nvdimm@lists.01.org>; Thu, 23 Jun 2016 22:30:48 -0700 (PDT)
Subject: [PATCH] libnvdimm, pfn,
 dax: fix initialization vs autodetect for mode + alignment
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Jun 2016 22:29:34 -0700
Message-ID: <146674610017.2960.6940675811689566985.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Micah Parrish <micah.parrish@hpe.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

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

There was a similar, but incomplete, patch like this for the BTT back in
December of last year: "BTT: Change nd_btt_arena_is_valid() to verify
UUID".  I did not apply it due to the fact that it didn't address
setting changes and I did not fully understand the scope of the problem.

Now with the realization that the kernel silently overriding settings is
problematic, we should consider taking this deterministic behavior over
to the btt.  However, it's not a bug there like it is in the pfn case
because the settings default to an invalid uninitialized value, whereas
pfn devices have a default valid alignment.

 drivers/nvdimm/pfn_devs.c |   51 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index f7718ec685fa..cea8350fbc7e 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -344,6 +344,8 @@ struct device *nd_pfn_create(struct nd_region *nd_region)
 int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 {
 	u64 checksum, offset;
+	unsigned long align;
+	enum nd_pfn_mode mode;
 	struct nd_namespace_io *nsio;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
@@ -386,22 +388,50 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
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
 
-	if (nd_pfn->align == 0)
-		nd_pfn->align = le32_to_cpu(pfn_sb->align);
-	if (nd_pfn->align > nvdimm_namespace_capacity(ndns)) {
+	if (align > nvdimm_namespace_capacity(ndns)) {
 		dev_err(&nd_pfn->dev, "alignment: %lx exceeds capacity %llx\n",
-				nd_pfn->align, nvdimm_namespace_capacity(ndns));
+				align, nvdimm_namespace_capacity(ndns));
 		return -EINVAL;
 	}
 
@@ -411,7 +441,6 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	 * namespace has changed since the pfn superblock was
 	 * established.
 	 */
-	offset = le64_to_cpu(pfn_sb->dataoff);
 	nsio = to_nd_namespace_io(&ndns->dev);
 	if (offset >= resource_size(&nsio->res)) {
 		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
@@ -419,10 +448,11 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -EBUSY;
 	}
 
-	if ((nd_pfn->align && !IS_ALIGNED(offset, nd_pfn->align))
+	if ((align && !IS_ALIGNED(offset, align))
 			|| !IS_ALIGNED(offset, PAGE_SIZE)) {
-		dev_err(&nd_pfn->dev, "bad offset: %#llx dax disabled\n",
-				offset);
+		dev_err(&nd_pfn->dev,
+				"bad offset: %#llx dax disabled align: %#lx\n",
+				offset, align);
 		return -ENXIO;
 	}
 
@@ -502,7 +532,6 @@ static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 	res->start += start_pad;
 	res->end -= end_trunc;
 
-	nd_pfn->mode = le32_to_cpu(nd_pfn->pfn_sb->mode);
 	if (nd_pfn->mode == PFN_MODE_RAM) {
 		if (offset < SZ_8K)
 			return ERR_PTR(-EINVAL);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
