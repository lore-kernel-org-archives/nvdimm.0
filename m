Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE87020954CBE
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 11:52:16 -0800 (PST)
From: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/5] EDAC: Drop duplicated array of strings for memory type
 names
Date: Thu, 22 Feb 2018 11:58:07 -0800
Message-Id: <20180222195811.27237-2-tony.luck@intel.com>
In-Reply-To: <20180222195811.27237-1-tony.luck@intel.com>
References: <20180222195811.27237-1-tony.luck@intel.com>
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
To: Borislav Petkov <bp@suse.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Somehow we ended up with two separate arrays of strings to describe
the "enum mem_type" values.

In edac_mc.c we have an exported list edac_mem_types[] that is used
by a couple of drivers in debug messaged.

In edac_mc_sysfs.c we have a private list that is used to display
values in:
  /sys/devices/system/edac/mc/mc*/dimm*/dimm_mem_type
  /sys/devices/system/edac/mc/mc*/csrow*/mem_type
this list was missing a value for MEM_LRDDR3

The string values in the two lists were different :-(

Combining the lists, I kept the values so that the sysfs output
will be unchanged as some scripts may depend on that.

Reported-by: Borislav Petkov <bp@suse.de>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/edac_mc.c       | 40 ++++++++++++++++++++--------------------
 drivers/edac/edac_mc_sysfs.c | 26 ++------------------------
 2 files changed, 22 insertions(+), 44 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 48193f5f3b56..1f61b736e075 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -195,26 +195,26 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 #endif				/* CONFIG_EDAC_DEBUG */
 
 const char * const edac_mem_types[] = {
-	[MEM_EMPTY]	= "Empty csrow",
-	[MEM_RESERVED]	= "Reserved csrow type",
-	[MEM_UNKNOWN]	= "Unknown csrow type",
-	[MEM_FPM]	= "Fast page mode RAM",
-	[MEM_EDO]	= "Extended data out RAM",
-	[MEM_BEDO]	= "Burst Extended data out RAM",
-	[MEM_SDR]	= "Single data rate SDRAM",
-	[MEM_RDR]	= "Registered single data rate SDRAM",
-	[MEM_DDR]	= "Double data rate SDRAM",
-	[MEM_RDDR]	= "Registered Double data rate SDRAM",
-	[MEM_RMBS]	= "Rambus DRAM",
-	[MEM_DDR2]	= "Unbuffered DDR2 RAM",
-	[MEM_FB_DDR2]	= "Fully buffered DDR2",
-	[MEM_RDDR2]	= "Registered DDR2 RAM",
-	[MEM_XDR]	= "Rambus XDR",
-	[MEM_DDR3]	= "Unbuffered DDR3 RAM",
-	[MEM_RDDR3]	= "Registered DDR3 RAM",
-	[MEM_LRDDR3]	= "Load-Reduced DDR3 RAM",
-	[MEM_DDR4]	= "Unbuffered DDR4 RAM",
-	[MEM_RDDR4]	= "Registered DDR4 RAM",
+	[MEM_EMPTY]	= "Empty",
+	[MEM_RESERVED]	= "Reserved",
+	[MEM_UNKNOWN]	= "Unknown",
+	[MEM_FPM]	= "FPM",
+	[MEM_EDO]	= "EDO",
+	[MEM_BEDO]	= "BEDO",
+	[MEM_SDR]	= "Unbuffered-SDR",
+	[MEM_RDR]	= "Registered-SDR",
+	[MEM_DDR]	= "Unbuffered-DDR",
+	[MEM_RDDR]	= "Registered-DDR",
+	[MEM_RMBS]	= "RMBS",
+	[MEM_DDR2]	= "Unbuffered-DDR2",
+	[MEM_FB_DDR2]	= "FullyBuffered-DDR2",
+	[MEM_RDDR2]	= "Registered-DDR2",
+	[MEM_XDR]	= "XDR",
+	[MEM_DDR3]	= "Unbuffered-DDR3",
+	[MEM_RDDR3]	= "Registered-DDR3",
+	[MEM_LRDDR3]	= "Load-Reduced-DDR3-RAM",
+	[MEM_DDR4]	= "Unbuffered-DDR4",
+	[MEM_RDDR4]	= "Registered-DDR4"
 };
 EXPORT_SYMBOL_GPL(edac_mem_types);
 
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index c70ea82c815c..7481955160a4 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -91,28 +91,6 @@ static struct device *mci_pdev;
 /*
  * various constants for Memory Controllers
  */
-static const char * const mem_types[] = {
-	[MEM_EMPTY] = "Empty",
-	[MEM_RESERVED] = "Reserved",
-	[MEM_UNKNOWN] = "Unknown",
-	[MEM_FPM] = "FPM",
-	[MEM_EDO] = "EDO",
-	[MEM_BEDO] = "BEDO",
-	[MEM_SDR] = "Unbuffered-SDR",
-	[MEM_RDR] = "Registered-SDR",
-	[MEM_DDR] = "Unbuffered-DDR",
-	[MEM_RDDR] = "Registered-DDR",
-	[MEM_RMBS] = "RMBS",
-	[MEM_DDR2] = "Unbuffered-DDR2",
-	[MEM_FB_DDR2] = "FullyBuffered-DDR2",
-	[MEM_RDDR2] = "Registered-DDR2",
-	[MEM_XDR] = "XDR",
-	[MEM_DDR3] = "Unbuffered-DDR3",
-	[MEM_RDDR3] = "Registered-DDR3",
-	[MEM_DDR4] = "Unbuffered-DDR4",
-	[MEM_RDDR4] = "Registered-DDR4"
-};
-
 static const char * const dev_types[] = {
 	[DEV_UNKNOWN] = "Unknown",
 	[DEV_X1] = "x1",
@@ -196,7 +174,7 @@ static ssize_t csrow_mem_type_show(struct device *dev,
 {
 	struct csrow_info *csrow = to_csrow(dev);
 
-	return sprintf(data, "%s\n", mem_types[csrow->channels[0]->dimm->mtype]);
+	return sprintf(data, "%s\n", edac_mem_types[csrow->channels[0]->dimm->mtype]);
 }
 
 static ssize_t csrow_dev_type_show(struct device *dev,
@@ -549,7 +527,7 @@ static ssize_t dimmdev_mem_type_show(struct device *dev,
 {
 	struct dimm_info *dimm = to_dimm(dev);
 
-	return sprintf(data, "%s\n", mem_types[dimm->mtype]);
+	return sprintf(data, "%s\n", edac_mem_types[dimm->mtype]);
 }
 
 static ssize_t dimmdev_dev_type_show(struct device *dev,
-- 
2.14.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
