Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2EB0F2118EF60
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:14:46 -0800 (PST)
Subject: [PATCH 11/11] acpi/nfit: prevent indiscriminate DSM payload dumping
 for security DSMs
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:14:45 -0700
Message-ID: <154180168546.70506.10546818094914224030.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, zohar@linux.vnet.ibm.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Right now when debug is enabled, we dump the command buffer
indescriminately. This exposes the clear text payload for security DSMs.
Introducing a kernel config to only dump the payload if the config option
is turned on so the production kernels can leave this option off and not
expose the passphrases.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/Kconfig |    7 +++++++
 drivers/acpi/nfit/core.c  |   24 +++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/Kconfig b/drivers/acpi/nfit/Kconfig
index f7c57e33499e..a0a8eabda2e8 100644
--- a/drivers/acpi/nfit/Kconfig
+++ b/drivers/acpi/nfit/Kconfig
@@ -13,3 +13,10 @@ config ACPI_NFIT
 
 	  To compile this driver as a module, choose M here:
 	  the module will be called nfit.
+
+config NFIT_SECURITY_DEBUG
+	bool "Turn on debugging for NVDIMM security features"
+	depends on ACPI_NFIT
+	help
+	  Turning on debug output for NVDIMM security DSM commands. This
+	  should not be turned on on a production kernel.
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 867e6fea3737..baaf5308de35 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -405,6 +405,21 @@ static u8 nfit_dsm_revid(unsigned family, unsigned func)
 	return id;
 }
 
+static bool is_security_cmd(unsigned int cmd, unsigned int func,
+		unsigned int family)
+{
+	if (cmd != ND_CMD_CALL)
+		return false;
+
+	if (family == NVDIMM_FAMILY_INTEL) {
+		if (func >= NVDIMM_INTEL_GET_SECURITY_STATE &&
+				func <= NVDIMM_INTEL_MASTER_SECURE_ERASE)
+			return true;
+	}
+
+	return false;
+}
+
 int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
 {
@@ -489,9 +504,12 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 
 	dev_dbg(dev, "%s cmd: %d: func: %d input length: %d\n",
 		dimm_name, cmd, func, in_buf.buffer.length);
-	print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
-			in_buf.buffer.pointer,
-			min_t(u32, 256, in_buf.buffer.length), true);
+	if ((call_pkg && !is_security_cmd(cmd, func, call_pkg->nd_family)) ||
+			IS_ENABLED(CONFIG_NFIT_SECURITY_DEBUG)) {
+		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
+				in_buf.buffer.pointer,
+				min_t(u32, 256, in_buf.buffer.length), true);
+	}
 
 	/* call the BIOS, prefer the named methods over _DSM if available */
 	if (nvdimm && cmd == ND_CMD_GET_CONFIG_SIZE

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
