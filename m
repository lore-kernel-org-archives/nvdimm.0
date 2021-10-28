Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A002C83
	for <nvdimm@lists.linux.dev>; Thu, 28 Oct 2021 04:45:41 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="217498536"
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="217498536"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 21:45:40 -0700
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="486974095"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 21:45:40 -0700
Date: Wed, 27 Oct 2021 21:45:39 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: nvdimm@lists.linux.dev, aneesh.kumar@linux.ibm.com,
	vaibhav@linux.ibm.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com
Subject: Re: [REPOST PATCH v2 1/2] libndctl, intel: Indicate supported
 smart-inject types
Message-ID: <20211028044539.GC3538886@iweiny-DESK2.sc.intel.com>
References: <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
 <163491461724.1641479.6370717053054036222.stgit@lep8c.aus.stglabs.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163491461724.1641479.6370717053054036222.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Fri, Oct 22, 2021 at 09:57:07AM -0500, Shivaprasad G Bhat wrote:
> From: Vaibhav Jain <vaibhav@linux.ibm.com>
> 

[snip]

>  
> -static int smart_inject(struct ndctl_dimm *dimm)
> +static int smart_inject(struct ndctl_dimm *dimm, unsigned int inject_types)
>  {
>  	const char *name = ndctl_dimm_get_devname(dimm);
>  	struct ndctl_cmd *si_cmd = NULL;
>  	int rc = -EOPNOTSUPP;
>  
> -	send_inject_val(media_temperature)
> -	send_inject_val(ctrl_temperature)
> -	send_inject_val(spares)
> -	send_inject_bool(fatal)
> -	send_inject_bool(unsafe_shutdown)
> +	if (inject_types & ND_SMART_INJECT_MEDIA_TEMPERATURE)
> +		send_inject_val(media_temperature);
>  
> +	if (inject_types & ND_SMART_INJECT_CTRL_TEMPERATURE)
> +		send_inject_val(ctrl_temperature);
> +
> +	if (inject_types & ND_SMART_INJECT_SPARES_REMAINING)
> +		send_inject_val(spares);
> +
> +	if (inject_types & ND_SMART_INJECT_HEALTH_STATE)
> +		send_inject_bool(fatal);
> +
> +	if (inject_types & ND_SMART_INJECT_UNCLEAN_SHUTDOWN)
> +		send_inject_bool(unsafe_shutdown);
>  out:
>  	ndctl_cmd_unref(si_cmd);
>  	return rc;
> @@ -415,8 +423,10 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
>  	struct json_object *jhealth;
>  	struct json_object *jdimms;
>  	struct json_object *jdimm;
> +	unsigned int supported_types;
>  	int rc;
>  
> +	/* Get supported smart injection types */

NIT: this comment is probably unnecessary.

>  	rc = ndctl_dimm_smart_inject_supported(dimm);
>  	switch (rc) {
>  	case -ENOTTY:
> @@ -431,6 +441,15 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
>  		error("%s: smart injection not supported by either platform firmware or the kernel.",
>  			ndctl_dimm_get_devname(dimm));
>  		return rc;
> +	default:
> +		if (rc < 0) {
> +			error("%s: Unknown error %d while checking for smart injection support",
> +			      ndctl_dimm_get_devname(dimm), rc);
> +			return rc;
> +		}
> +		/* Assigning to an unsigned type since rc < 0 */

Comment wrong?

> +		supported_types = rc;
> +		break;
>  	}
>  
>  	if (sctx.op_mask & (1 << OP_SET)) {

[snip]

Other than the comment it looks fine.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

