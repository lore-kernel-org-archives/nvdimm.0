Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v5 2/8] arch, drivers: don't include <asm/io.h> directly,
 use <linux/io.h> instead
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Aug 2015 20:12:14 -0400
Message-ID: <20150813001214.17702.81461.stgit@otcpl-skl-sds-2.jf.intel.com>
In-Reply-To: <20150813000250.17702.28409.stgit@otcpl-skl-sds-2.jf.intel.com>
References: <20150813000250.17702.28409.stgit@otcpl-skl-sds-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Preparation for uniform definition of ioremap, ioremap_wc, ioremap_wt,
and ioremap_cache, tree-wide.

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/mach-shmobile/pm-rcar.c            |    2 +-
 arch/ia64/kernel/cyclone.c                  |    2 +-
 drivers/isdn/icn/icn.h                      |    2 +-
 drivers/mtd/devices/slram.c                 |    2 +-
 drivers/mtd/nand/diskonchip.c               |    2 +-
 drivers/mtd/onenand/generic.c               |    2 +-
 drivers/scsi/sun3x_esp.c                    |    2 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c |    1 +
 drivers/tty/serial/8250/8250_core.c         |    2 +-
 drivers/video/fbdev/s1d13xxxfb.c            |    3 +--
 drivers/video/fbdev/stifb.c                 |    1 +
 include/linux/io-mapping.h                  |    2 +-
 include/linux/mtd/map.h                     |    2 +-
 include/video/vga.h                         |    2 +-
 14 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-shmobile/pm-rcar.c b/arch/arm/mach-shmobile/pm-rcar.c
index 00022ee56f80..9d3dde00c2fe 100644
--- a/arch/arm/mach-shmobile/pm-rcar.c
+++ b/arch/arm/mach-shmobile/pm-rcar.c
@@ -12,7 +12,7 @@
 #include <linux/err.h>
 #include <linux/mm.h>
 #include <linux/spinlock.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include "pm-rcar.h"
 
 /* SYSC */
diff --git a/arch/ia64/kernel/cyclone.c b/arch/ia64/kernel/cyclone.c
index 4826ff957a3d..5fa3848ba224 100644
--- a/arch/ia64/kernel/cyclone.c
+++ b/arch/ia64/kernel/cyclone.c
@@ -4,7 +4,7 @@
 #include <linux/errno.h>
 #include <linux/timex.h>
 #include <linux/clocksource.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* IBM Summit (EXA) Cyclone counter code*/
 #define CYCLONE_CBAR_ADDR 0xFEB00CD0
diff --git a/drivers/isdn/icn/icn.h b/drivers/isdn/icn/icn.h
index b713466997a0..f8f2e76d34bf 100644
--- a/drivers/isdn/icn/icn.h
+++ b/drivers/isdn/icn/icn.h
@@ -38,7 +38,7 @@ typedef struct icn_cdef {
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/major.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index 2fc4957cbe7f..a70eb83e68f1 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -41,7 +41,7 @@
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <linux/init.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <linux/mtd/mtd.h>
 
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index 7da266a53979..0802158a3f75 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -24,7 +24,7 @@
 #include <linux/rslib.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
diff --git a/drivers/mtd/onenand/generic.c b/drivers/mtd/onenand/generic.c
index 32a216d31141..ab7bda0bb245 100644
--- a/drivers/mtd/onenand/generic.c
+++ b/drivers/mtd/onenand/generic.c
@@ -18,7 +18,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/onenand.h>
 #include <linux/mtd/partitions.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /*
  * Note: Driver name and platform data format have been updated!
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index e26e81de7c45..d50c5ed8f428 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -12,9 +12,9 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 
 #include <asm/sun3x.h>
-#include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/dvma.h>
 
diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 0768bc42a5db..14ef1f67dd42 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/io.h>
 #include "../comedidev.h"
 
 /*
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 37fff12dd4d0..fe902ff52e58 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -38,11 +38,11 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/pm_runtime.h>
+#include <linux/io.h>
 #ifdef CONFIG_SPARC
 #include <linux/sunserialcore.h>
 #endif
 
-#include <asm/io.h>
 #include <asm/irq.h>
 
 #include "8250.h"
diff --git a/drivers/video/fbdev/s1d13xxxfb.c b/drivers/video/fbdev/s1d13xxxfb.c
index 83433cb0dfba..96aa46dc696c 100644
--- a/drivers/video/fbdev/s1d13xxxfb.c
+++ b/drivers/video/fbdev/s1d13xxxfb.c
@@ -32,8 +32,7 @@
 #include <linux/spinlock_types.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <video/s1d13xxxfb.h>
 
diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 735355b0e023..7df4228e25f0 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -64,6 +64,7 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
+#include <linux/io.h>
 
 #include <asm/grfioctl.h>	/* for HP-UX compatibility */
 #include <asm/uaccess.h>
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index c27dde7215b5..e399029b68c5 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -21,7 +21,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/bug.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/page.h>
 
 /*
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 29975c73a953..366cf77953b5 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -27,9 +27,9 @@
 #include <linux/string.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/io.h>
 
 #include <asm/unaligned.h>
-#include <asm/io.h>
 #include <asm/barrier.h>
 
 #ifdef CONFIG_MTD_MAP_BANK_WIDTH_1
diff --git a/include/video/vga.h b/include/video/vga.h
index cac567f22e62..d334e64c1c19 100644
--- a/include/video/vga.h
+++ b/include/video/vga.h
@@ -18,7 +18,7 @@
 #define __linux_video_vga_h__
 
 #include <linux/types.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/vga.h>
 #include <asm/byteorder.h>
 

