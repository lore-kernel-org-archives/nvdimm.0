Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.nue.novell.com (smtp.nue.novell.com [195.135.221.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE80E1A1E12
 for <linux-nvdimm@lists.01.org>; Sun, 31 Jul 2016 23:01:03 -0700 (PDT)
Date: Mon, 1 Aug 2016 14:00:49 +0800
From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] libnvdimm, nd_blk: mask off reserved status bits
Message-ID: <20160801060049.GI9236@linux-rxt1.site>
References: <20160729205912.20436-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160729205912.20436-1-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Ross,

On Fri, Jul 29, 2016 at 02:59:12PM -0600, Ross Zwisler wrote:
> The "NVDIMM Block Window Driver Writer's Guide":
> 
> http://pmem.io/documents/
> http://pmem.io/documents/NVDIMM_DriverWritersGuide-July-2016.pdf
> 
> defines the layout of the block window status register.  For the July 2016
> version of the spec linked to above, this happens in Figure 4 on page 26.
> 
> The only bits defined in this spec are bits 31, 5, 4, 2, 1 and 0.  The rest
> of the bits in the status register are reserved, and there is a warning
> following the diagram that says:
> 
>   Note: The driver cannot assume the value of the RESERVED bits in the
>   status register are zero. These reserved bits need to be masked off, and
>   the driver must avoid checking the state of those bits.
> 
> This change ensures that for hardware implementations that set these
> reserved bits in the status register, the driver won't incorrectly fail the
> block I/Os.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/acpi/nfit.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 1f0e060..375c10f 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c

The drivers/acpi/nfit.c is moved to drivers/acpi/nfit/core.c

> @@ -1396,11 +1396,12 @@ static u32 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
>  {
>  	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
>  	u64 offset = nfit_blk->stat_offset + mmio->size * bw;
> +	const u32 STATUS_MASK = 0x80000037;
>  
>  	if (mmio->num_lines)
>  		offset = to_interleave_offset(offset, mmio);
>  
> -	return readl(mmio->addr.base + offset);
> +	return readl(mmio->addr.base + offset) & STATUS_MASK;
>  }
>  
>  static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
> -- 
> 2.9.0

Other parts are good to me.

Reviewed-by: Lee, Chun-Yi <jlee@suse.com>

Regards
Joey Lee
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
