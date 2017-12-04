Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by ml01.01.org (Postfix) with ESMTP id C131920352A8C
 for <linux-nvdimm@lists.01.org>; Mon,  4 Dec 2017 13:33:50 -0800 (PST)
Date: Mon, 4 Dec 2017 22:38:14 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 2/4] firmware: dmi: Add function to look up a handle
 and return DIMM size
Message-ID: <20171204213813.rm32qqeqchx37c5x@pd.tnic>
References: <cover.1512070562.git.tony.luck@intel.com>
 <2fae02861e5c446c0cdd30ba3e00fad55db97807.1512070562.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2fae02861e5c446c0cdd30ba3e00fad55db97807.1512070562.git.tony.luck@intel.com>
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
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-edac@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 30, 2017 at 12:40:40PM -0800, Tony Luck wrote:
> When we first scan the SMBIOS table, save the size of the DIMM.
> 
> Provide a function for other code (EDAC driver) to look up the size
> of a DIMM from its SMBIOS handle.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/firmware/dmi_scan.c | 29 +++++++++++++++++++++++++++++
>  include/linux/dmi.h         |  2 ++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 783041964439..946e86fb1ec6 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -37,6 +37,7 @@ static char dmi_ids_string[128] __initdata;
>  static struct dmi_memdev_info {
>  	const char *device;
>  	const char *bank;
> +	u64 size;
>  	u16 handle;
>  } *dmi_memdev;
>  static int dmi_memdev_nr;
> @@ -395,6 +396,8 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
>  {
>  	const char *d = (const char *)dm;
>  	static int nr;
> +	u64 bytes;
> +	u16 size;
>  
>  	if (dm->type != DMI_ENTRY_MEM_DEVICE || dm->length < 0x12)
>  		return;
> @@ -405,6 +408,18 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
>  	dmi_memdev[nr].handle = get_unaligned(&dm->handle);
>  	dmi_memdev[nr].device = dmi_string(dm, d[0x10]);
>  	dmi_memdev[nr].bank = dmi_string(dm, d[0x11]);

<---- newline here.

> +	size = get_unaligned((u16 *)&d[0xC]);
> +	if (size == 0)
> +		bytes = 0;
> +	else if (size == 0xffff)
> +		bytes = ~0ul;
> +	else if (size & 0x8000)
> +		bytes = (u64)(size & 0x7fff) << 10;
> +	else if (size != 0x7fff)
> +		bytes = (u64)size << 20;
> +	else
> +		bytes = (u64)get_unaligned((u32 *)&d[0x1C]) << 20;

<---- newline here.

> +	dmi_memdev[nr].size = bytes;
>  	nr++;
>  }
>  
> @@ -1073,3 +1088,17 @@ void dmi_memdev_name(u16 handle, const char **bank, const char **device)
>  	}
>  }
>  EXPORT_SYMBOL_GPL(dmi_memdev_name);
> +
> +u64 dmi_memdev_size(u16 handle)
> +{
> +	int n;
> +
> +	if (dmi_memdev) {
> +		for (n = 0; n < dmi_memdev_nr; n++) {
> +			if (handle == dmi_memdev[n].handle)
> +				return dmi_memdev[n].size;
> +		}
> +	}
> +	return ~0ul;
> +}

So dmi_memdev_name() also loops over dmi_memdev and returns bank and
device. This new function returns size.

If code is going to be calling those one after the other, you could do a

	dmi_memdev_desc(u16 handle, struct memdev_desc *desc)

which fills up a descriptor with all fields a caller would need in one
go so that you don't have to iterate multiple times. Looking at struct
dmi_memdev_info, there are no more fields so maybe this is probably
silly though or you can simply return struct dmi_memdev_info directly...

Meh.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
