Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDC9121122939
 for <linux-nvdimm@lists.01.org>; Thu,  6 Sep 2018 15:02:54 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl: Suppress command errors if fallback exists
Date: Thu, 6 Sep 2018 21:58:06 +0000
Message-ID: <1536271085.5995.179.camel@intel.com>
References: <20180906185848.31198-1-keith.busch@intel.com>
In-Reply-To: <20180906185848.31198-1-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <640C4E412937A64A9D1C8DE2F90080BD@intel.com>
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
To: "Busch, Keith" <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-09-06 at 12:58 -0600, Keith Busch wrote:
> If a command has a fallback to handle an error, this patch will not
> emit
> an error message and instead let the handler report any errors.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  ndctl/lib/intel.c    | 9 +++++++--
>  ndctl/lib/libndctl.c | 4 +++-
>  2 files changed, 10 insertions(+), 3 deletions(-)

Looks good, applied.

> 
> diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
> index b1254bb..15c5d1a 100644
> --- a/ndctl/lib/intel.c
> +++ b/ndctl/lib/intel.c
> @@ -64,15 +64,17 @@ static struct ndctl_cmd *alloc_intel_cmd(struct
> ndctl_dimm *dimm,
>  static int intel_smart_handle_error(struct ndctl_cmd *cmd)
>  {
>  	struct ndctl_dimm *dimm = cmd->dimm;
> +	struct ndctl_bus *bus = cmd_to_bus(cmd);
> +	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
>  	char *path = NULL, shutdown_count[16] = {};
>  	int fd, rc = cmd->status;
>  
>  	if (!dimm)
> -		return 0;
> +		goto out;
>  
>  	if (asprintf(&path, DEF_TMPFS_DIR "/%s/usc",
>  		     ndctl_dimm_get_devname(dimm)) < 0)
> -		return rc;
> +		goto out;
>  
>  	fd = open(path, O_RDONLY);
>  	if (fd < 0)
> @@ -88,6 +90,9 @@ static int intel_smart_handle_error(struct
> ndctl_cmd *cmd)
>  	close (fd);
>   free_path:
>  	free(path);
> + out:
> +	if (rc)
> +		err(ctx, "failed: %s\n", strerror(errno));
>  	return rc;
>  }
>  
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 226a577..481b110 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -2753,7 +2753,9 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct
> ndctl_cmd *cmd)
>  
>  	fd = open(path, O_RDWR);
>  	if (fd < 0) {
> -		err(ctx, "failed to open %s: %s\n", path,
> strerror(errno));
> +		if (!cmd->handle_error)
> +			err(ctx, "failed to open %s: %s\n", path,
> +				strerror(errno));
>  		rc = -errno;
>  		goto out;
>  	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
