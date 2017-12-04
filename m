Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
 by ml01.01.org (Postfix) with ESMTP id 5B00D20356241
 for <linux-nvdimm@lists.01.org>; Mon,  4 Dec 2017 14:32:49 -0800 (PST)
Date: Mon, 4 Dec 2017 23:37:11 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 3/4] edac: Add new memory type for non-volatile DIMMs
Message-ID: <20171204223711.4l7gbd7op7yvsrza@pd.tnic>
References: <cover.1512070562.git.tony.luck@intel.com>
 <862104c26398781e4937c3fca3994cbe75d820ff.1512070562.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <862104c26398781e4937c3fca3994cbe75d820ff.1512070562.git.tony.luck@intel.com>
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

On Thu, Nov 30, 2017 at 12:40:41PM -0800, Tony Luck wrote:
> There are now non-volatile versions of DIMMs. Add a new entry to
> "enum mem_type" and update places that use it with new strings.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/edac/edac_mc.c       | 1 +
>  drivers/edac/edac_mc_sysfs.c | 3 ++-
>  include/linux/edac.h         | 3 +++
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 480072139b7a..8178e74decbf 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -215,6 +215,7 @@ const char * const edac_mem_types[] = {
>  	[MEM_LRDDR3]	= "Load-Reduced DDR3 RAM",
>  	[MEM_DDR4]	= "Unbuffered DDR4 RAM",
>  	[MEM_RDDR4]	= "Registered DDR4 RAM",
> +	[MEM_NVDIMM]	= "Non-volatile RAM",
>  };
>  EXPORT_SYMBOL_GPL(edac_mem_types);
>  
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index e4fcfa84fbd3..53cbb3518efc 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -110,7 +110,8 @@ static const char * const mem_types[] = {
>  	[MEM_DDR3] = "Unbuffered-DDR3",
>  	[MEM_RDDR3] = "Registered-DDR3",
>  	[MEM_DDR4] = "Unbuffered-DDR4",
> -	[MEM_RDDR4] = "Registered-DDR4"
> +	[MEM_RDDR4] = "Registered-DDR4",
> +	[MEM_NVDIMM] = "Non-volatile RAM",
>  };

WTF, there are *two* string arrays with memory types?! How did that
happen?

Can you please remove that above in a prepatch and switch to
edac_mem_types? Or should we switch to this mem_types array instead and
kill edac_mem_types since former is visible in sysfs?

:-( Grrr.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
