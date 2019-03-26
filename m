Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBA2421959CB2
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 14:56:04 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3 4/5] libndctl: Add a new dimm-op
 cmd_is_supported()
Date: Tue, 26 Mar 2019 21:56:02 +0000
Message-ID: <072e59f43a276b9daa93c131866fc26fabaad626.camel@intel.com>
References: <20190323042028.4310-1-decui@microsoft.com>
 <20190323042028.4310-5-decui@microsoft.com>
In-Reply-To: <20190323042028.4310-5-decui@microsoft.com>
Content-Language: en-US
Content-ID: <FB9B4354D747BB4999282CC3C70C48DD@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dexuan.cui@gmail.com" <dexuan.cui@gmail.com>, "mikelley@microsoft.com" <mikelley@microsoft.com>
Cc: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Sat, 2019-03-23 at 04:20 +0000, Dexuan Cui wrote:
> A NVDIMM family may need to report that it supports a command, even if
> the command is not set in dimm->cmd_mask, e.g. a non-NVDIMM_FAMILY_INTEL
> famimy may support ND_CMD_SMART or some kind of variant of ND_CMD_SMART,
> while the kernel only sets ND_CMD_SMART in the nvdimm->cmd_mask for
> NVDIMM_FAMILY_INTEL.

Hi Dexuan,

Thanks for making the changes, this revision /mostly/ looks good to me
except - 

The kernel dsm mask just seems to be hard-coded in [1]

So is there any reason that that can't simply be allowed to advertise
"everything is supported", similar to what the MSFT family does, and
that should remove the need for playing games with dimm-ops (i.e. now
there is another layer that can affect command support detection).

[1]: https://patchwork.kernel.org/patch/10785277/

> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  ndctl/lib/libndctl.c | 5 +++++
>  ndctl/lib/private.h  | 1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 24b8ad3..4acfb03 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -1769,6 +1769,11 @@ NDCTL_EXPORT int ndctl_dimm_failed_map(struct ndctl_dimm *dimm)
>  NDCTL_EXPORT int ndctl_dimm_is_cmd_supported(struct ndctl_dimm *dimm,
>  		int cmd)
>  {
> +	struct ndctl_dimm_ops *ops = dimm->ops;
> +
> +	if (ops && ops->cmd_is_supported)
> +		return ops->cmd_is_supported(dimm, cmd);
> +
>  	return !!(dimm->cmd_mask & (1ULL << cmd));
>  }
>  
> diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
> index a9d35c5..2ddc1d2 100644
> --- a/ndctl/lib/private.h
> +++ b/ndctl/lib/private.h
> @@ -292,6 +292,7 @@ struct ndctl_bb {
>  
>  struct ndctl_dimm_ops {
>  	const char *(*cmd_desc)(int);
> +	bool (*cmd_is_supported)(struct ndctl_dimm *, int);
>  	struct ndctl_cmd *(*new_smart)(struct ndctl_dimm *);
>  	unsigned int (*smart_get_flags)(struct ndctl_cmd *);
>  	unsigned int (*smart_get_health)(struct ndctl_cmd *);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
