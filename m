Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
 by ml01.01.org (Postfix) with ESMTP id CCF352217CE24
 for <linux-nvdimm@lists.01.org>; Wed,  6 Dec 2017 06:50:57 -0800 (PST)
Date: Wed, 6 Dec 2017 15:55:21 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 4/4] EDAC, skx_edac: Detect non-volatile DIMMs
Message-ID: <20171206145521.awynp5piz75dxzlf@pd.tnic>
References: <cover.1512070562.git.tony.luck@intel.com>
 <da4c989314e82ec29195804ba5349ac3136f74c0.1512070562.git.tony.luck@intel.com>
 <20171205105451.ob23asixm726hysb@pd.tnic>
 <20171205200336.tbx7oypjuca3g6vn@agluck-desk>
 <20171205214441.pfxusrz5lpew5kre@pd.tnic>
 <20171205222429.cxrnnqfdtl6mrflu@agluck-desk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171205222429.cxrnnqfdtl6mrflu@agluck-desk>
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-edac@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 05, 2017 at 02:24:29PM -0800, Luck, Tony wrote:
> So this is what that would look like (on top of existing patches,
> but would be folded into them for next version):
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 5c0c4a358f67..7f0bc4cd5086 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -233,10 +233,11 @@ config EDAC_SKX
>  	tristate "Intel Skylake server Integrated MC"
>  	depends on PCI && X86_64 && X86_MCE_INTEL && PCI_MMCONFIG
>  	select DMI
> -	select ACPI_NFIT
>  	help
>  	  Support for error detection and correction the Intel
> -	  Skylake server Integrated Memory Controllers.
> +	  Skylake server Integrated Memory Controllers. If your
> +	  has non-volatile DIMMs you should also manually select
> +	  CONFIG_ACPI_NFIT
>  
>  config EDAC_PND2
>  	tristate "Intel Pondicherry2"
> diff --git a/drivers/edac/skx_edac.c b/drivers/edac/skx_edac.c
> index f42e382f82b1..8374deb83246 100644
> --- a/drivers/edac/skx_edac.c
> +++ b/drivers/edac/skx_edac.c
> @@ -387,12 +387,16 @@ static int get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
>  	int smbios_handle;
>  	u32 dev_handle;
>  	u16 flags;
> -	u64 size;
> +	u64 size = 0;
>  
>  	dev_handle = ACPI_NFIT_BUILD_DEVICE_HANDLE(dimmno, chan, imc->lmc,
>  						   imc->src_id, 0);
>  
>  	smbios_handle = nfit_get_smbios_id(dev_handle, &flags);
> +	if (smbios_handle == -EOPNOTSUPP) {
> +		pr_warn_once("skx_edac: can't find size of NVDIMM\n");

	" ... find size of NVDIMM. Try enabling CONFIG_ACPI_NFIT.\n"

to make it a bit more user-friendly.

Looks ok, otherwise.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
