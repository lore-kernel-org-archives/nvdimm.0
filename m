Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05ED9222DE15F
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 13:40:24 -0800 (PST)
Subject: [PATCH v2] libnvdimm: re-enable deep flush for pmem devices
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 12 Feb 2018 14:46:13 -0700
Message-ID: <151847194459.58291.11339638808076622981.stgit@djiang5-desk3.ch.intel.com>
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
Cc: ross.zwisler@intel.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Re-enable deep flush so that users always have a way to be sure that a write
does make it all the way out to the NVDIMM. The PMEM driver writes always
make it "all the way to the NVDIMM", and it relies on the ADR mechanism to
flush the write buffers on power failure. Deep flush is there to explicitly
flush those write buffers to protect against (rare) ADR failure.
This change prevents a regression in deep flush behavior so that applications
can continue to depend on fsync() as a mechanism to trigger deep flush in the
filesystem-dax case.

Fixes: 06e8ccdab15f4 ("acpi: nfit: Add support for detect platform CPU cache flush on power loss")

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2: Updated commit patch header from Dan's comments.

 drivers/nvdimm/pmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 10041ac4032c..06f8dcc52ca6 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -335,8 +335,7 @@ static int pmem_attach_disk(struct device *dev,
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 		fua = 0;
 	}
-	wbc = nvdimm_has_cache(nd_region) &&
-		!test_bit(ND_REGION_PERSIST_CACHE, &nd_region->flags);
+	wbc = nvdimm_has_cache(nd_region);
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(&ndns->dev))) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
