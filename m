Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 21/25] fbdev: switch from ioremap_wt to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:39:56 -0400
Message-ID: <20150725023955.8664.16490.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, linux-fbdev@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>, rmk+kernel@arm.linux.org.uk, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_wt() convert its usage in
drivers/video/fbdev to memremap.

Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/video/fbdev/amifb.c |    5 +++--
 drivers/video/fbdev/atafb.c |    5 +++--
 drivers/video/fbdev/hpfb.c  |    6 +++---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/amifb.c b/drivers/video/fbdev/amifb.c
index 1d702e13aaff..0cde451046d0 100644
--- a/drivers/video/fbdev/amifb.c
+++ b/drivers/video/fbdev/amifb.c
@@ -52,6 +52,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <asm/irq.h>
 #include <asm/amigahw.h>
@@ -3705,8 +3706,8 @@ default_chipset:
 	 * access the videomem with writethrough cache
 	 */
 	info->fix.smem_start = (u_long)ZTWO_PADDR(videomemory);
-	videomemory = (u_long)ioremap_wt(info->fix.smem_start,
-					 info->fix.smem_len);
+	videomemory = (u_long)memremap(info->fix.smem_start, info->fix.smem_len,
+			MEMREMAP_WT);
 	if (!videomemory) {
 		dev_warn(&pdev->dev,
 			 "Unable to map videomem cached writethrough\n");
diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
index d6ce613e12ad..5615e8c31ea2 100644
--- a/drivers/video/fbdev/atafb.c
+++ b/drivers/video/fbdev/atafb.c
@@ -55,12 +55,12 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 
 #include <asm/setup.h>
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/irq.h>
-#include <asm/io.h>
 
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
@@ -3185,7 +3185,8 @@ int __init atafb_init(void)
 		/* Map the video memory (physical address given) to somewhere
 		 * in the kernel address space.
 		 */
-		external_screen_base = ioremap_wt(external_addr, external_len);
+		external_screen_base = memremap(external_addr, external_len,
+				MEMREMAP_WT);
 		if (external_vgaiobase)
 			external_vgaiobase =
 			  (unsigned long)ioremap(external_vgaiobase, 0x10000);
diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index 9476d196f510..d08c320b06fc 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -14,8 +14,8 @@
 #include <linux/init.h>
 #include <linux/fb.h>
 #include <linux/dio.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/uaccess.h>
 
 static struct fb_info fb_info = {
@@ -241,8 +241,8 @@ static int hpfb_init_one(unsigned long phys_base, unsigned long virt_base)
 	fb_info.fix.line_length = fb_width;
 	fb_height = (in_8(fb_regs + HPFB_FBHMSB) << 8) | in_8(fb_regs + HPFB_FBHLSB);
 	fb_info.fix.smem_len = fb_width * fb_height;
-	fb_start = (unsigned long)ioremap_wt(fb_info.fix.smem_start,
-					     fb_info.fix.smem_len);
+	fb_start = (unsigned long) memremap(fb_info.fix.smem_start,
+					     fb_info.fix.smem_len, MEMREMAP_WT);
 	hpfb_defined.xres = (in_8(fb_regs + HPFB_DWMSB) << 8) | in_8(fb_regs + HPFB_DWLSB);
 	hpfb_defined.yres = (in_8(fb_regs + HPFB_DHMSB) << 8) | in_8(fb_regs + HPFB_DHLSB);
 	hpfb_defined.xres_virtual = hpfb_defined.xres;

