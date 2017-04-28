Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BC5C219493C2
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 14:35:02 -0700 (PDT)
Subject: [PATCH 3/3] acpi, nfit: kill ACPI_NFIT_DEBUG,
 switch to dynamic_hex_dump()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 14:29:09 -0700
Message-ID: <149341494933.35578.4269653029034926839.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Inevitably when one actually needs to debug a DSM issue it's on a
distribution kernel that has CONFIG_ACPI_NFIT_DEBUG=n. The config symbol
is only there to avoid the compile error due to the missing fallback for
print_hex_dump_debug in the CONFIG_DYNAMIC_DEBUG=n case. Now that the
compile error is fixed the nfit driver can call dynamic_hex_dump()
directly, and enable debug of unmodified distro kernels.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/Kconfig |   12 ------------
 drivers/acpi/nfit/core.c  |   21 ++++++++-------------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/nfit/Kconfig b/drivers/acpi/nfit/Kconfig
index dd0d53c52552..6d3351452ea2 100644
--- a/drivers/acpi/nfit/Kconfig
+++ b/drivers/acpi/nfit/Kconfig
@@ -12,15 +12,3 @@ config ACPI_NFIT
 
 	  To compile this driver as a module, choose M here:
 	  the module will be called nfit.
-
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
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 261eea1d2906..ca391a2cbe63 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -268,14 +268,11 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		in_buf.buffer.length = call_pkg->nd_size_in;
 	}
 
-	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
-		dev_dbg(dev, "%s:%s cmd: %d: func: %d input length: %d\n",
-				__func__, dimm_name, cmd, func,
-				in_buf.buffer.length);
-		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
+	dev_dbg(dev, "%s:%s cmd: %d: func: %d input length: %d\n",
+			__func__, dimm_name, cmd, func, in_buf.buffer.length);
+	dynamic_hex_dump("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
 			in_buf.buffer.pointer,
 			min_t(u32, 256, in_buf.buffer.length), true);
-	}
 
 	out_obj = acpi_evaluate_dsm(handle, uuid, 1, func, &in_obj);
 	if (!out_obj) {
@@ -307,13 +304,11 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		goto out;
 	}
 
-	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
-		dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__,
-				dimm_name, cmd_name, out_obj->buffer.length);
-		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
-				4, out_obj->buffer.pointer, min_t(u32, 128,
-					out_obj->buffer.length), true);
-	}
+	dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__, dimm_name,
+			cmd_name, out_obj->buffer.length);
+	dynamic_hex_dump(cmd_name, DUMP_PREFIX_OFFSET, 4, 4,
+			out_obj->buffer.pointer,
+			min_t(u32, 128, out_obj->buffer.length), true);
 
 	for (i = 0, offset = 0; i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i, buf,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
