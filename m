Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9EF92195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 15:57:42 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 2/2] libnvdimm: clear region badblock in nvdimm_clear_poison()
Date: Thu, 27 Apr 2017 16:57:06 -0600
Message-Id: <20170427225706.26791-2-toshi.kani@hpe.com>
In-Reply-To: <20170427225706.26791-1-toshi.kani@hpe.com>
References: <20170427225706.26791-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Badblocks are tracked at both region and device levels.
pmem_clear_poison() and nsio_rw_bytes() call nvdimm_clear_poison()
and then badblocks_clear() to clear badblocks at the device level.
However, it does not update badblocks at the region level, which
makes them inconsistent.

Change nvdimm_clear_poison() to update backblocks at the region
level to keep them consistent.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
---
Based on 'libnvdimm-for-next'.
---
 drivers/nvdimm/bus.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 43ddfd4..998332d 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -179,6 +179,7 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 	struct nvdimm_bus_descriptor *nd_desc;
 	struct nd_cmd_clear_error clear_err;
 	struct nd_cmd_ars_cap ars_cap;
+	struct resource res;
 	u32 clear_err_unit, mask;
 	int cmd_rc, rc;
 
@@ -222,6 +223,14 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 	if (clear_err.cleared > 0)
 		nvdimm_forget_poison(nvdimm_bus, phys, clear_err.cleared);
 
+	if (clear_err.cleared > 0 && clear_err.cleared / 512) {
+		nvdimm_bus_lock(&nvdimm_bus->dev);
+		res.start = phys;
+		res.end = phys + clear_err.cleared - 1;
+		__nvdimm_bus_badblocks_clear(nvdimm_bus, &res);
+		nvdimm_bus_unlock(&nvdimm_bus->dev);
+	}
+
 	return clear_err.cleared;
 }
 EXPORT_SYMBOL_GPL(nvdimm_clear_poison);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
