Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59D2C210E38BC
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 13:32:36 -0700 (PDT)
Subject: Re: [ndctl PATCH] ndctl: Work around kernel memory corruption
References: <20180813203153.562-1-keith.busch@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <25d9b47d-0010-9f6a-2780-b0bae649bade@intel.com>
Date: Mon, 13 Aug 2018 13:32:35 -0700
MIME-Version: 1.0
In-Reply-To: <20180813203153.562-1-keith.busch@intel.com>
Content-Language: en-US
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
To: Keith Busch <keith.busch@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 08/13/2018 01:31 PM, Keith Busch wrote:
> Kernel commit efda1b5d87cb ("acpi, nfit, libnvdimm: fix / harden
> ars_status output length handling") contained an incorrect ars status
> output size calculation and may overrun the buffer provided by 4
> bytes. This patch adds 4 bytes to the buffer the user space allocates
> so that the kernel's overrun doesn't corrupt the application's heap.
> 
> See kernel patch for more details:
> 
>   https://patchwork.kernel.org/patch/10563103/
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  ndctl/lib/ars.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
> index c78e3bf..bd75131 100644
> --- a/ndctl/lib/ars.c
> +++ b/ndctl/lib/ars.c
> @@ -133,7 +133,16 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_status(struct ndctl_cmd *ar
>  	}
>  
>  	size = sizeof(*cmd) + ars_cap_cmd->max_ars_out;
> -	cmd = calloc(1, size);
> +
> +	/*
> +	 * Older kernels have a bug that miscalculates the output length of the
> +	 * ars status and will overrun the provided buffer by 4 bytes,
> +	 * corrupting the memory. Add an additional 4 bytes in the allocation
> +	 * size to prevent that corruption. See kernel patch for more details:
> +	 *
> +	 *   https://patchwork.kernel.org/patch/10563103/
> +	 */
> +	cmd = calloc(1, size + 4);
>  	if (!cmd)
>  		return NULL;
>  
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
