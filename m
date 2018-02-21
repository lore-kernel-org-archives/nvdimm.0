Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55B2C20954CA6
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 14:22:27 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/2] ndctl: add "all" dimm-id option for update-firmware
Date: Wed, 21 Feb 2018 22:28:19 +0000
Message-ID: <1519252098.24924.23.camel@intel.com>
References: <151925075889.65338.1771943064286480835.stgit@djiang5-desk3.ch.intel.com>
 <151925076435.65338.5271742129529173494.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151925076435.65338.5271742129529173494.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <A6F77C888711E841B2E2E9220EB1E1F0@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2018-02-21 at 15:06 -0700, Dave Jiang wrote:
> Adding all option to allow ndctl to update all DIMMs at once.

I was going to ask that we should also update the documentation for
this command to include the new 'all' behavior, but it looks like
during the revisions of the original series, the documentation update
to list the options explicitly got dropped?

Anyway, can you re-add those, and also talk about --dimm=all there.

On a side note, should we make this more inline with other dimm
commands, such as xable-dimm or read/write-labels, where the dimm name
(or 'all') is a non-option argument? That would make it something like:

  ndctl update-firmware --firmware=<file> nmem0 (or 'all)

> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/update.c |   25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/ndctl/update.c b/ndctl/update.c
> index fc26acf..1b771ff 100644
> --- a/ndctl/update.c
> +++ b/ndctl/update.c
> @@ -77,6 +77,7 @@ struct update_context {
>  	struct ndctl_dimm *dimm;
>  	struct fw_info dimm_fw;
>  	struct ndctl_cmd *start;
> +	bool all;
>  };
>  
>  /*
> @@ -471,16 +472,23 @@ static int get_ndctl_dimm(struct update_context
> *uctx, void *ctx)
>  {
>  	struct ndctl_dimm *dimm;
>  	struct ndctl_bus *bus;
> +	int rc = -ENODEV;
>  
>  	ndctl_bus_foreach(ctx, bus)
>  		ndctl_dimm_foreach(bus, dimm) {
> -			if (!util_dimm_filter(dimm, uctx->dimm_id))
> +			if (!uctx->all &&
> +				!util_dimm_filter(dimm, uctx-
> >dimm_id))
>  				continue;
>  			uctx->dimm = dimm;
> -			return 0;
> +			rc = update_firmware(uctx);
> +			if (rc < 0) {
> +				error("Update firmware for dimm %s
> failed\n",
> +						ndctl_dimm_get_devna
> me(dimm));
> +				continue;
> +			}
>  		}
>  
> -	return -ENODEV;
> +	return rc;
>  }
>  
>  static int verify_fw_file(struct update_context *uctx)
> @@ -573,18 +581,17 @@ int cmd_update_firmware(int argc, const char
> **argv, void *ctx)
>  		return rc;
>  	}
>  
> +	if (strcmp(uctx.dimm_id, "all") == 0)
> +		uctx.all = true;
> +	else
> +		uctx.all = false;
> +
>  	rc = get_ndctl_dimm(&uctx, ctx);
>  	if (rc < 0) {
>  		error("DIMM %s not found", uctx.dimm_id);
>  		return rc;
>  	}
>  
> -	rc = update_firmware(&uctx);
> -	if (rc < 0) {
> -		error("Update firmware failed");
> -		return rc;
> -	}
> -
>  	if (uctx.start)
>  		ndctl_cmd_unref(uctx.start);
>  
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
