Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D59462218E95B
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 14:19:59 -0800 (PST)
Date: Tue, 5 Dec 2017 14:24:29 -0800
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH 4/4] EDAC, skx_edac: Detect non-volatile DIMMs
Message-ID: <20171205222429.cxrnnqfdtl6mrflu@agluck-desk>
References: <cover.1512070562.git.tony.luck@intel.com>
 <da4c989314e82ec29195804ba5349ac3136f74c0.1512070562.git.tony.luck@intel.com>
 <20171205105451.ob23asixm726hysb@pd.tnic>
 <20171205200336.tbx7oypjuca3g6vn@agluck-desk>
 <20171205214441.pfxusrz5lpew5kre@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171205214441.pfxusrz5lpew5kre@pd.tnic>
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
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-edac@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 05, 2017 at 10:44:41PM +0100, Borislav Petkov wrote:
> On Tue, Dec 05, 2017 at 12:03:37PM -0800, Luck, Tony wrote:
> > I could. But what happens when someone ends up on a system with
> > an edac driver configured without ACPI_NFIT that does have NVDIMMs?
> 
> Same thing when you land on a system with a kernel where the driver for
> a piece of hw is not enabled. I mean, this won't be an issue on distros
> as there *everything* is enabled but for tailored configs, where people
> want skx_edac but don't need the nvdimm part.
> 
> > I can make a stub version of nfit_get_smbios_id() that returns some
> > error code ... and have the EDAC driver report size==0.
> > 
> > Would that be OK?
> 
> Sure, thanks!

So this is what that would look like (on top of existing patches,
but would be folded into them for next version):

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 5c0c4a358f67..7f0bc4cd5086 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -233,10 +233,11 @@ config EDAC_SKX
 	tristate "Intel Skylake server Integrated MC"
 	depends on PCI && X86_64 && X86_MCE_INTEL && PCI_MMCONFIG
 	select DMI
-	select ACPI_NFIT
 	help
 	  Support for error detection and correction the Intel
-	  Skylake server Integrated Memory Controllers.
+	  Skylake server Integrated Memory Controllers. If your
+	  has non-volatile DIMMs you should also manually select
+	  CONFIG_ACPI_NFIT
 
 config EDAC_PND2
 	tristate "Intel Pondicherry2"
diff --git a/drivers/edac/skx_edac.c b/drivers/edac/skx_edac.c
index f42e382f82b1..8374deb83246 100644
--- a/drivers/edac/skx_edac.c
+++ b/drivers/edac/skx_edac.c
@@ -387,12 +387,16 @@ static int get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
 	int smbios_handle;
 	u32 dev_handle;
 	u16 flags;
-	u64 size;
+	u64 size = 0;
 
 	dev_handle = ACPI_NFIT_BUILD_DEVICE_HANDLE(dimmno, chan, imc->lmc,
 						   imc->src_id, 0);
 
 	smbios_handle = nfit_get_smbios_id(dev_handle, &flags);
+	if (smbios_handle == -EOPNOTSUPP) {
+		pr_warn_once("skx_edac: can't find size of NVDIMM\n");
+		goto unknown_size;
+	}
 	if (smbios_handle < 0) {
 		skx_printk(KERN_ERR, "Can't find handle for NVDIMM ADR=%x\n", dev_handle);
 		return 0;
@@ -410,6 +414,7 @@ static int get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
 		return 0;
 	}
 
+unknown_size:
 	edac_dbg(0, "mc#%d: channel %d, dimm %d, %lld Mb (%lld pages)\n",
 		 imc->mc, chan, dimmno, size >> 20, size >> PAGE_SHIFT);
 
diff --git a/include/acpi/nfit.h b/include/acpi/nfit.h
index 1eee1e32e72e..f58e9eee6e6a 100644
--- a/include/acpi/nfit.h
+++ b/include/acpi/nfit.h
@@ -14,6 +14,13 @@
 #ifndef __ACPI_NFIT_H
 #define __ACPI_NFIT_H
 
+#if defined(CONFIG_ACPI_NFIT) || defined(CONFIG_ACPI_NFIT_MODULE)
 int nfit_get_smbios_id(u32 device_handle, u16 *flags);
+#else
+static inline int nfit_get_smbios_id(u32 device_handle, u16 *flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 #endif /* __ACPI_NFIT_H */
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
