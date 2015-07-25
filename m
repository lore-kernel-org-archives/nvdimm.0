Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 19/25] pxa2xx-flash: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:39:45 -0400
Message-ID: <20150725023945.8664.34842.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, Brian Norris <computersforpeace@gmail.com>, David Woodhouse <dwmw2@infradead.org>, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_cache() convert its usage in
pxa2xx-flash to memremap.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/mtd/maps/pxa2xx-flash.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index 12fa75df5008..758a8a7f86d9 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -71,8 +71,8 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 		       info->map.name);
 		return -ENOMEM;
 	}
-	info->map.cached =
-		ioremap_cache(info->map.phys, info->map.size);
+	info->map.cached = memremap(info->map.phys, info->map.size,
+			MEMREMAP_CACHE);
 	if (!info->map.cached)
 		printk(KERN_WARNING "Failed to ioremap cached %s\n",
 		       info->map.name);

