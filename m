Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE1BD21954092
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 16:55:48 -0700 (PDT)
Subject: [PATCH v2 1/2] libnvdimm, region: fix flush hint detection crash
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Apr 2017 16:49:56 -0700
Message-ID: <149307779612.7155.12969380677038292861.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149307779085.7155.436029631521340565.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149307779085.7155.436029631521340565.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In the case where a dimm does not have any associated flush hints the
ndrd->flush_wpq array may be uninitialized leading to crashes with the
following signature:

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
 IP: region_visible+0x10f/0x160 [libnvdimm]

 Call Trace:
  internal_create_group+0xbe/0x2f0
  sysfs_create_groups+0x40/0x80
  device_add+0x2d8/0x650
  nd_async_device_register+0x12/0x40 [libnvdimm]
  async_run_entry_fn+0x39/0x170
  process_one_work+0x212/0x6c0
  ? process_one_work+0x197/0x6c0
  worker_thread+0x4e/0x4a0
  kthread+0x10c/0x140
  ? process_one_work+0x6c0/0x6c0
  ? kthread_create_on_node+0x60/0x60
  ret_from_fork+0x31/0x40

Cc: <stable@vger.kernel.org>
Fixes: f284a4f23752 ("libnvdimm: introduce nvdimm_flush() and nvdimm_has_flush()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 8de5a04644a1..24abceda986a 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1000,17 +1000,20 @@ EXPORT_SYMBOL_GPL(nvdimm_flush);
  */
 int nvdimm_has_flush(struct nd_region *nd_region)
 {
-	struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
 	int i;
 
 	/* no nvdimm == flushing capability unknown */
 	if (nd_region->ndr_mappings == 0)
 		return -ENXIO;
 
-	for (i = 0; i < nd_region->ndr_mappings; i++)
-		/* flush hints present, flushing required */
-		if (ndrd_get_flush_wpq(ndrd, i, 0))
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		/* flush hints present / available */
+		if (nvdimm->num_flush)
 			return 1;
+	}
 
 	/*
 	 * The platform defines dimm devices without hints, assume

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
