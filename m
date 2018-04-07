Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B6A47226516AA
 for <linux-nvdimm@lists.01.org>; Sat,  7 Apr 2018 08:00:43 -0700 (PDT)
Subject: [PATCH] libnvdimm,
 dimm: fix dpa reservation vs uninitialized label area
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 07 Apr 2018 07:50:46 -0700
Message-ID: <152311264681.13507.15332881622190583231.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, Krzysztof Rusocki <krzysztof.rusocki@intel.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

At initialization time the 'dimm' driver caches a copy of the memory
device's label area and reserves address space for each of the
namespaces defined.

However, as can be seen below, the reservation occurs even when the
index blocks are invalid:

 nvdimm nmem0: nvdimm_init_config_data: len: 131072 rc: 0
 nvdimm nmem0: config data size: 131072
 nvdimm nmem0: __nd_label_validate: nsindex0 labelsize 1 invalid
 nvdimm nmem0: __nd_label_validate: nsindex1 labelsize 1 invalid
 nvdimm nmem0: : pmem-6025e505: 0x1000000000 @ 0xf50000000 reserve <-- bad

Gate dpa reservation on the presence of valid index blocks.

Cc: <stable@vger.kernel.org>
Fixes: 4a826c83db4e ("libnvdimm: namespace indices: read and validate")
Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index f8913b8124b6..233907889f96 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -67,9 +67,11 @@ static int nvdimm_probe(struct device *dev)
 	ndd->ns_next = nd_label_next_nsindex(ndd->ns_current);
 	nd_label_copy(ndd, to_next_namespace_index(ndd),
 			to_current_namespace_index(ndd));
-	rc = nd_label_reserve_dpa(ndd);
-	if (ndd->ns_current >= 0)
-		nvdimm_set_aliasing(dev);
+	if (ndd->ns_current >= 0) {
+		rc = nd_label_reserve_dpa(ndd);
+		if (rc == 0)
+			nvdimm_set_aliasing(dev);
+	}
 	nvdimm_clear_locked(dev);
 	nvdimm_bus_unlock(dev);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
