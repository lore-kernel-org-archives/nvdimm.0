Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9ABC11A1DF4
 for <linux-nvdimm@lists.01.org>; Thu, 28 Jul 2016 02:49:38 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] nfit: Get rid of CONFIG_ACPI_NFIT_DEBUG
Date: Thu, 28 Jul 2016 11:49:29 +0200
Message-Id: <1469699369-70824-1-git-send-email-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux NVDIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

CONFIG_ACPI_NFIT_DEBUG is currently used to dump the buffers used in NFIT _DSM
calls. Within the statements guarded by CONFIG_ACPI_NFIT_DEBUG we use dynamic
debugging as well as print_hex_dump_debug(). Change the print_hex_dump_debug()
call to dynamic_hex_dump() so we can enable it on demand and at runtime, not
dependend on a compile time option.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/acpi/Kconfig | 12 ------------
 drivers/acpi/nfit.c  | 28 +++++++++++++---------------
 2 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index b7e2e77..659fb1c 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -462,18 +462,6 @@ config ACPI_NFIT
 	  To compile this driver as a module, choose M here:
 	  the module will be called nfit.
 
-config ACPI_NFIT_DEBUG
-	bool "NFIT DSM debug"
-	depends on ACPI_NFIT
-	depends on DYNAMIC_DEBUG
-	default n
-	help
-	  Enabling this option causes the nfit driver to dump the
-	  input and output buffers of _DSM operations on the ACPI0012
-	  device and its children.  This can be very verbose, so leave
-	  it disabled unless you are debugging a hardware / firmware
-	  issue.
-
 source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 1f0e060..ddff49d 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -246,14 +246,13 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		in_buf.buffer.length = call_pkg->nd_size_in;
 	}
 
-	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
-		dev_dbg(dev, "%s:%s cmd: %d: func: %d input length: %d\n",
-				__func__, dimm_name, cmd, func,
-				in_buf.buffer.length);
-		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
-			in_buf.buffer.pointer,
-			min_t(u32, 256, in_buf.buffer.length), true);
-	}
+	dev_dbg(dev, "%s:%s cmd: %d: func: %d input length: %d\n",
+		__func__, dimm_name, cmd, func,
+		in_buf.buffer.length);
+
+	dynamic_hex_dump("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
+			     in_buf.buffer.pointer,
+			     min_t(u32, 256, in_buf.buffer.length), true);
 
 	out_obj = acpi_evaluate_dsm(handle, uuid, 1, func, &in_obj);
 	if (!out_obj) {
@@ -285,13 +284,12 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		goto out;
 	}
 
-	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
-		dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__,
-				dimm_name, cmd_name, out_obj->buffer.length);
-		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
-				4, out_obj->buffer.pointer, min_t(u32, 128,
-					out_obj->buffer.length), true);
-	}
+	dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__,
+		dimm_name, cmd_name, out_obj->buffer.length);
+
+	dynamic_hex_dump(cmd_name, DUMP_PREFIX_OFFSET, 4,
+			     4, out_obj->buffer.pointer,
+			     min_t(u32, 128, out_obj->buffer.length), true);
 
 	for (i = 0, offset = 0; i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i, buf,
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
