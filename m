Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34403224488BC
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 11:18:11 -0700 (PDT)
From: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5/5] EDAC, skx_edac: Detect non-volatile DIMMs
Date: Mon, 12 Mar 2018 11:24:30 -0700
Message-Id: <20180312182430.10335-6-tony.luck@intel.com>
In-Reply-To: <20180312182430.10335-1-tony.luck@intel.com>
References: <CAPcyv4iHr9nUAS0SiFeqqDkU8NXZ_x=rkD3YS010Dy-nbHJXmA@mail.gmail.com>
 <20180312182430.10335-1-tony.luck@intel.com>
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
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

This just covers the topology function of the EDAC driver.
We locate which DIMM slots are populated with NVDIMMs and
query the NFIT and SMBIOS tables to get the size.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/edac/Kconfig    |  5 +++-
 drivers/edac/skx_edac.c | 66 ++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 3c4017007647..c12e34564557 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -232,9 +232,12 @@ config EDAC_SBRIDGE
 config EDAC_SKX
 	tristate "Intel Skylake server Integrated MC"
 	depends on PCI && X86_64 && X86_MCE_INTEL && PCI_MMCONFIG
+	select DMI
 	help
 	  Support for error detection and correction the Intel
-	  Skylake server Integrated Memory Controllers.
+	  Skylake server Integrated Memory Controllers. If your
+	  system has non-volatile DIMMs you should also manually
+	  select CONFIG_ACPI_NFIT
 
 config EDAC_PND2
 	tristate "Intel Pondicherry2"
diff --git a/drivers/edac/skx_edac.c b/drivers/edac/skx_edac.c
index 912c4930c9ef..84c18bb1e0cd 100644
--- a/drivers/edac/skx_edac.c
+++ b/drivers/edac/skx_edac.c
@@ -14,6 +14,8 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
@@ -24,6 +26,7 @@
 #include <linux/bitmap.h>
 #include <linux/math64.h>
 #include <linux/mod_devicetable.h>
+#include <acpi/nfit.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
@@ -302,6 +305,7 @@ static int get_dimm_attr(u32 reg, int lobit, int hibit, int add, int minval,
 }
 
 #define IS_DIMM_PRESENT(mtr)		GET_BITFIELD((mtr), 15, 15)
+#define IS_NVDIMM_PRESENT(mcddrtcfg, i)	GET_BITFIELD((mcddrtcfg), (i), (i))
 
 #define numrank(reg) get_dimm_attr((reg), 12, 13, 0, 0, 2, "ranks")
 #define numrow(reg) get_dimm_attr((reg), 2, 4, 12, 1, 6, "rows")
@@ -350,8 +354,6 @@ static int get_dimm_info(u32 mtr, u32 amap, struct dimm_info *dimm,
 	int  banks = 16, ranks, rows, cols, npages;
 	u64 size;
 
-	if (!IS_DIMM_PRESENT(mtr))
-		return 0;
 	ranks = numrank(mtr);
 	rows = numrow(mtr);
 	cols = numcol(mtr);
@@ -383,6 +385,53 @@ static int get_dimm_info(u32 mtr, u32 amap, struct dimm_info *dimm,
 	return 1;
 }
 
+static int get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
+			   int chan, int dimmno)
+{
+	int smbios_handle;
+	u32 dev_handle;
+	u16 flags;
+	u64 size = 0;
+
+	dev_handle = ACPI_NFIT_BUILD_DEVICE_HANDLE(dimmno, chan, imc->lmc,
+						   imc->src_id, 0);
+
+	smbios_handle = nfit_get_smbios_id(dev_handle, &flags);
+	if (smbios_handle == -EOPNOTSUPP) {
+		pr_warn_once("skx_edac: can't find size of NVDIMM. Try enabling CONFIG_ACPI_NFIT\n");
+		goto unknown_size;
+	}
+	if (smbios_handle < 0) {
+		skx_printk(KERN_ERR, "Can't find handle for NVDIMM ADR=%x\n", dev_handle);
+		goto unknown_size;
+	}
+
+	if (flags & ACPI_NFIT_MEM_MAP_FAILED) {
+		skx_printk(KERN_ERR, "NVDIMM ADR=%x is not mapped\n", dev_handle);
+		goto unknown_size;
+	}
+
+	size = dmi_memdev_size(smbios_handle);
+	if (size == ~0ull)
+		skx_printk(KERN_ERR, "Can't find size for NVDIMM ADR=%x/SMBIOS=%x\n",
+			   dev_handle, smbios_handle);
+
+unknown_size:
+	dimm->nr_pages = size >> PAGE_SHIFT;
+	dimm->grain = 32;
+	dimm->dtype = DEV_UNKNOWN;
+	dimm->mtype = MEM_NVDIMM;
+	dimm->edac_mode = EDAC_SECDED; /* likely better than this */
+
+	edac_dbg(0, "mc#%d: channel %d, dimm %d, %llu Mb (%u pages)\n",
+		 imc->mc, chan, dimmno, size >> 20, dimm->nr_pages);
+
+	snprintf(dimm->label, sizeof(dimm->label), "CPU_SrcID#%u_MC#%u_Chan#%u_DIMM#%u",
+		 imc->src_id, imc->lmc, chan, dimmno);
+
+	return 1;
+}
+
 #define SKX_GET_MTMTR(dev, reg) \
 	pci_read_config_dword((dev), 0x87c, &reg)
 
@@ -399,20 +448,24 @@ static int skx_get_dimm_config(struct mem_ctl_info *mci)
 {
 	struct skx_pvt *pvt = mci->pvt_info;
 	struct skx_imc *imc = pvt->imc;
+	u32 mtr, amap, mcddrtcfg;
 	struct dimm_info *dimm;
 	int i, j;
-	u32 mtr, amap;
 	int ndimms;
 
 	for (i = 0; i < NUM_CHANNELS; i++) {
 		ndimms = 0;
 		pci_read_config_dword(imc->chan[i].cdev, 0x8C, &amap);
+		pci_read_config_dword(imc->chan[i].cdev, 0x400, &mcddrtcfg);
 		for (j = 0; j < NUM_DIMMS; j++) {
 			dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
 					     mci->n_layers, i, j, 0);
 			pci_read_config_dword(imc->chan[i].cdev,
 					0x80 + 4*j, &mtr);
-			ndimms += get_dimm_info(mtr, amap, dimm, imc, i, j);
+			if (IS_DIMM_PRESENT(mtr))
+				ndimms += get_dimm_info(mtr, amap, dimm, imc, i, j);
+			else if (IS_NVDIMM_PRESENT(mcddrtcfg, j))
+				ndimms += get_nvdimm_info(dimm, imc, i, j);
 		}
 		if (ndimms && !skx_check_ecc(imc->chan[0].cdev)) {
 			skx_printk(KERN_ERR, "ECC is disabled on imc %d\n", imc->mc);
@@ -468,13 +521,14 @@ static int skx_register_mci(struct skx_imc *imc)
 	pvt = mci->pvt_info;
 	pvt->imc = imc;
 
-	mci->ctl_name = kasprintf(GFP_KERNEL, "Skylake Socket#%d IMC#%d", imc->node_id, imc->lmc);
+	mci->ctl_name = kasprintf(GFP_KERNEL, "Skylake Socket#%d IMC#%d",
+				  imc->node_id, imc->lmc);
 	if (!mci->ctl_name) {
 		rc = -ENOMEM;
 		goto fail0;
 	}
 
-	mci->mtype_cap = MEM_FLAG_DDR4;
+	mci->mtype_cap = MEM_FLAG_DDR4 | MEM_FLAG_NVDIMM;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE;
 	mci->edac_cap = EDAC_FLAG_NONE;
 	mci->mod_name = EDAC_MOD_STR;
-- 
2.14.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
