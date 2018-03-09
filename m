Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1203C2253FB61
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 02:14:39 -0800 (PST)
Date: Fri, 9 Mar 2018 11:20:53 +0100
From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 4/5] firmware: dmi: Add function to look up a handle and
 return DIMM size
Message-ID: <20180309112053.20605672@endymion>
In-Reply-To: <20180222195811.27237-5-tony.luck@intel.com>
References: <20180222195811.27237-1-tony.luck@intel.com>
 <20180222195811.27237-5-tony.luck@intel.com>
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

On Thu, 22 Feb 2018 11:58:10 -0800, Tony Luck wrote:
> When we first scan the SMBIOS table, save the size of the DIMM.
> 
> Provide a function for other code (EDAC driver) to look up the size
> of a DIMM from its SMBIOS handle.

On the principle I'm OK with the idea. My comments on the
implementation details are inline below.

> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/firmware/dmi_scan.c | 31 +++++++++++++++++++++++++++++++
>  include/linux/dmi.h         |  2 ++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index e763e1484331..9947f1f6ef7b 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -32,6 +32,7 @@ static char dmi_ids_string[128] __initdata;
>  static struct dmi_memdev_info {
>  	const char *device;
>  	const char *bank;
> +	u64 size;

A comment stating in which unit the size is stored would be appreciated.

>  	u16 handle;
>  } *dmi_memdev;
>  static int dmi_memdev_nr;
> @@ -386,6 +387,8 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
>  {
>  	const char *d = (const char *)dm;
>  	static int nr;
> +	u64 bytes;
> +	u16 size;
>  
>  	if (dm->type != DMI_ENTRY_MEM_DEVICE || dm->length < 0x12)
>  		return;
> @@ -396,6 +399,20 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
>  	dmi_memdev[nr].handle = get_unaligned(&dm->handle);
>  	dmi_memdev[nr].device = dmi_string(dm, d[0x10]);
>  	dmi_memdev[nr].bank = dmi_string(dm, d[0x11]);
> +
> +	size = get_unaligned((u16 *)&d[0xC]);
> +	if (size == 0)
> +		bytes = 0;
> +	else if (size == 0xffff)
> +		bytes = ~0ul;

Should this not be ~0ull? On 32-bit systems ~0ul would be 0xffffffff not
0xffffffffffffffff.

Also it would be nice to document somewhere that 0 means memory module
not installed and all fs means size is unknown.

> +	else if (size & 0x8000)
> +		bytes = (u64)(size & 0x7fff) << 10;
> +	else if (size != 0x7fff)
> +		bytes = (u64)size << 20;
> +	else
> +		bytes = (u64)get_unaligned((u32 *)&d[0x1C]) << 20;
> +
> +	dmi_memdev[nr].size = bytes;

I'm curious, do you really need to know the amount of memory to the
byte? The SMBIOS specification itself does not support granularity
under 1 kB. I would be very surprised if any machine running Linux
today has memory modules under 1 MB. If storing in MB you wouldn't need
a u64...

>  	nr++;
>  }
>  
> @@ -1065,3 +1082,17 @@ void dmi_memdev_name(u16 handle, const char **bank, const char **device)
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

~0ull?

> +}
> +EXPORT_SYMBOL_GPL(dmi_memdev_size);
> diff --git a/include/linux/dmi.h b/include/linux/dmi.h
> index 46e151172d95..7f5929123b69 100644
> --- a/include/linux/dmi.h
> +++ b/include/linux/dmi.h
> @@ -113,6 +113,7 @@ extern int dmi_walk(void (*decode)(const struct dmi_header *, void *),
>  	void *private_data);
>  extern bool dmi_match(enum dmi_field f, const char *str);
>  extern void dmi_memdev_name(u16 handle, const char **bank, const char **device);
> +extern u64 dmi_memdev_size(u16 handle);
>  
>  #else
>  
> @@ -142,6 +143,7 @@ static inline bool dmi_match(enum dmi_field f, const char *str)
>  	{ return false; }
>  static inline void dmi_memdev_name(u16 handle, const char **bank,
>  		const char **device) { }
> +static inline u64 dmi_memdev_size(u16 handle) { return ~0ul; }

~0ull?

>  static inline const struct dmi_system_id *
>  	dmi_first_match(const struct dmi_system_id *list) { return NULL; }
>  

-- 
Jean Delvare
SUSE L3 Support
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
