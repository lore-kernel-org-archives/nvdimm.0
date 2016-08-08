Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id EBC411A1DF9
 for <linux-nvdimm@lists.01.org>; Mon,  8 Aug 2016 12:10:20 -0700 (PDT)
Date: Mon, 8 Aug 2016 13:10:19 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2] libnvdimm, nd_blk: mask off reserved status bits
Message-ID: <20160808191019.GA965@linux.intel.com>
References: <20160729205912.20436-1-ross.zwisler@linux.intel.com>
 <20160802182653.6647-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802182653.6647-1-ross.zwisler@linux.intel.com>
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
Cc: linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, linux-acpi@vger.kernel.org, stable@vger.kernel.org#v4.2+, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 02, 2016 at 12:26:53PM -0600, Ross Zwisler wrote:
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
> Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: stable@vger.kernel.org # v4.2+

Ping on this patch - through which tree should we merge this for v4.8-rc2?
Dan's nvdimm tree?

> ---
> 
> Changes from V1:
>  - Rebased onto the v4.8 merge tree.  As Joey points out the ND BLK code
>    recently moved from drivers/acpi/nfit.c to drivers/acpi/nfit/core.c.
>    Since we were in the merge window for v4.8 I didn't know what to use as
>    a baseline, so I just used v4.7, which was apparently incorrect.  Sorry
>    about that.
> 
>  - Added Joey's reviewed-by.
> 
> For stable kernels v4.2 and beyond the v1 patch for drivers/acpi/nfit.c
> applies cleanly and should be used.
> 
> ---
>  drivers/acpi/nfit/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 8c234dd..80cc7c0 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1527,11 +1527,12 @@ static u32 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
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
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
