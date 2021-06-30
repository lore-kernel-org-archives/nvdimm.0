Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72E0177
	for <nvdimm@lists.linux.dev>; Wed, 30 Jun 2021 17:52:19 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="294036483"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="294036483"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 10:52:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="476380911"
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by fmsmga004.fm.intel.com with ESMTP; 30 Jun 2021 10:52:18 -0700
Date: Wed, 30 Jun 2021 10:47:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: vishal.l.verma@intel.com, nvdimm@lists.linux.dev, linfeilong@huawei.com,
	lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [ndctl PATCH 2/2] namespace: fix potentail fd leak problem in
 do_xaction_namespace()
Message-ID: <20210630174724.GB25123@alison-desk.jf.intel.com>
References: <d9881921-aef7-5410-1536-71df81227f4b@huawei.com>
 <7a84b450-ac3e-caa9-f280-1b6163466316@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a84b450-ac3e-caa9-f280-1b6163466316@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Jun 15, 2021 at 08:39:20PM +0800, Zhiqiang Liu wrote:
> 
> In do_xaction_namespace(), ri_ctx.f_out should be closed after
> being opened.
> 

Hi Zhiqiang,

The commit message and commit log need to be swapped.

Something like:

Commit message says what the patch does:
[ndctl PATCH 2/2] namespace: Close fd before return in do_xaction_namespace()

Commit log says why it needs to be done:
This prevents a potential file descriptor leak in do_xaction_namespace()

And, same as in Patch 1 - mention it was found by Coverity.

Alison

> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  ndctl/namespace.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 21089d7..55364ac 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -2141,7 +2141,7 @@ static int do_xaction_namespace(const char *namespace,
>  				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
>  			if (rc >= 0)
>  				(*processed)++;
> -			return rc;
> +			goto out;
>  		}
>  	}
> 
> @@ -2152,11 +2152,11 @@ static int do_xaction_namespace(const char *namespace,
>  		rc = file_write_infoblock(param.outfile);
>  		if (rc >= 0)
>  			(*processed)++;
> -		return rc;
> +		goto out;
>  	}
> 
>  	if (!namespace && action != ACTION_CREATE)
> -		return rc;
> +		goto out;
> 
>  	if (verbose)
>  		ndctl_set_log_priority(ctx, LOG_DEBUG);
> @@ -2212,7 +2212,7 @@ static int do_xaction_namespace(const char *namespace,
>  						saved_rc = rc;
>  						continue;
>  				}
> -				return rc;
> +				goto out;
>  			}
>  			ndctl_namespace_foreach_safe(region, ndns, _n) {
>  				ndns_name = ndctl_namespace_get_devname(ndns);
> @@ -2259,7 +2259,7 @@ static int do_xaction_namespace(const char *namespace,
>  					rc = namespace_reconfig(region, ndns);
>  					if (rc == 0)
>  						*processed = 1;
> -					return rc;
> +					goto out;
>  				case ACTION_READ_INFOBLOCK:
>  					rc = namespace_rw_infoblock(ndns, &ri_ctx, READ);
>  					if (rc == 0)
> @@ -2281,9 +2281,6 @@ static int do_xaction_namespace(const char *namespace,
>  	if (ri_ctx.jblocks)
>  		util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
> 
> -	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
> -		fclose(ri_ctx.f_out);
> -
>  	if (action == ACTION_CREATE && rc == -EAGAIN) {
>  		/*
>  		 * Namespace creation searched through all candidate
> @@ -2301,6 +2298,10 @@ static int do_xaction_namespace(const char *namespace,
>  	if (saved_rc)
>  		rc = saved_rc;
> 
> +out:
> +	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
> +		fclose(ri_ctx.f_out);
> +
>  	return rc;
>  }
> 
> -- 
> 2.23.0
> 
> 
> 
> 
> .
> 
> 
> 
