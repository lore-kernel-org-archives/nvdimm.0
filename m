Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA0AE2253FB77
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 02:31:46 -0800 (PST)
Date: Fri, 9 Mar 2018 11:38:01 +0100
From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 5/5] EDAC, skx_edac: Detect non-volatile DIMMs
Message-ID: <20180309113801.14b06cdf@endymion>
In-Reply-To: <20180222195811.27237-6-tony.luck@intel.com>
References: <20180222195811.27237-1-tony.luck@intel.com>
 <20180222195811.27237-6-tony.luck@intel.com>
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
To: Tony Luck <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, linux-nvdimm@lists.01.org, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki  <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo" <qiuxu.zhuo@intel.com>, Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>, Borislav Petkov <bp@suse.de>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Tony,

On Thu, 22 Feb 2018 11:58:11 -0800, Tony Luck wrote:
> This just covers the topology function of the EDAC driver.
> We locate which DIMM slots are populated with NVDIMMs and
> query the NFIT and SMBIOS tables to get the size.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/edac/Kconfig    |  5 +++-
>  drivers/edac/skx_edac.c | 68 ++++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 66 insertions(+), 7 deletions(-)
> (...)
> +static int get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
> +			   int chan, int dimmno)
> +{
> +	int smbios_handle;
> +	u32 dev_handle;
> +	u16 flags;
> +	u64 size = 0;
> +
> +	dev_handle = ACPI_NFIT_BUILD_DEVICE_HANDLE(dimmno, chan, imc->lmc,
> +						   imc->src_id, 0);
> +
> +	smbios_handle = nfit_get_smbios_id(dev_handle, &flags);
> +	if (smbios_handle == -EOPNOTSUPP) {
> +		pr_warn_once("skx_edac: can't find size of NVDIMM. Try enabling CONFIG_ACPI_NFIT\n");
> +		goto unknown_size;

I'm curious why you continue in this (worse) error case, but stop on
all other (some presumably less critical) error cases? Specifically I
can't see how an unknown size returned by the dmi subsystem can be worse
than not being able to query the size at all.

> +	}
> +	if (smbios_handle < 0) {
> +		skx_printk(KERN_ERR, "Can't find handle for NVDIMM ADR=%x\n", dev_handle);
> +		return 0;
> +	}
> +
> +	if (flags & ACPI_NFIT_MEM_MAP_FAILED) {
> +		skx_printk(KERN_ERR, "NVDIMM ADR=%x is not mapped\n", dev_handle);
> +		return 0;
> +	}
> +
> +	size = dmi_memdev_size(smbios_handle);
> +	if (size == ~0ul) {

If you agree with my comment on previous patch then this becomes ~0ull.

> +		skx_printk(KERN_ERR, "Can't find size for NVDIMM ADR=%x/SMBIOS=%x\n",
> +			   dev_handle, smbios_handle);
> +		return 0;
> +	}
> +
> +unknown_size:
> +	edac_dbg(0, "mc#%d: channel %d, dimm %d, %lld Mb (%lld pages)\n",

%llu instead of %lld (twice)?

> +		 imc->mc, chan, dimmno, size >> 20, size >> PAGE_SHIFT);
> +
> +	dimm->nr_pages = size >> PAGE_SHIFT;

If you moved the debug print after, you wouldn't have to do the shift
twice.

> +	dimm->grain = 32;
> +	dimm->dtype = DEV_UNKNOWN;
> +	dimm->mtype = MEM_NVDIMM;
> +	dimm->edac_mode = EDAC_SECDED; /* likely better than this */
> +
> +	snprintf(dimm->label, sizeof(dimm->label), "CPU_SrcID#%u_MC#%u_Chan#%u_DIMM#%u",
> +		 imc->src_id, imc->lmc, chan, dimmno);
> +
> +	return 1;
> +}

-- 
Jean Delvare
SUSE L3 Support
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
