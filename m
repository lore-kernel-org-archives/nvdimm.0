Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3EC2C83
	for <nvdimm@lists.linux.dev>; Thu, 28 Oct 2021 04:52:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="253881941"
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="253881941"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 21:52:02 -0700
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="498212206"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 21:52:01 -0700
Date: Wed, 27 Oct 2021 21:52:01 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: nvdimm@lists.linux.dev, aneesh.kumar@linux.ibm.com,
	vaibhav@linux.ibm.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com
Subject: Re: [REPOST PATCH v2 2/2] libndctl/papr: Add limited support for
 inject-smart
Message-ID: <20211028045201.GD3538886@iweiny-DESK2.sc.intel.com>
References: <163491461011.1641479.7752723100626280911.stgit@lep8c.aus.stglabs.ibm.com>
 <163491463468.1641479.2722334385346179478.stgit@lep8c.aus.stglabs.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163491463468.1641479.2722334385346179478.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Fri, Oct 22, 2021 at 09:58:10AM -0500, Shivaprasad G Bhat wrote:
> From: Vaibhav Jain <vaibhav@linux.ibm.com>
> 
> Implements support for ndctl inject-smart command by providing an
> implementation of 'smart_inject*' dimm-ops callbacks. Presently only
> support for injecting unsafe-shutdown and fatal-health states is
> available.
> 
> The patch also introduce various PAPR PDSM structures that are used to
> communicate the inject-smart errors to the papr_scm kernel
> module. This is done via SMART_INJECT PDSM which sends a payload of
> type 'struct nd_papr_pdsm_smart_inject'.
> 
> With the patch following output from ndctl inject-smart command is
> expected for PAPR NVDIMMs:
> 
> $ sudo ndctl inject-smart -fU nmem0
> [
>   {
>     "dev":"nmem0",
>     "flag_failed_flush":true,
>     "flag_smart_event":true,
>     "health":{
>       "health_state":"fatal",
>       "shutdown_state":"dirty",
>       "shutdown_count":0
>     }
>   }
> ]
> 
> $ sudo ndctl inject-smart -N nmem0
> [
>   {
>     "dev":"nmem0",
>     "health":{
>       "health_state":"ok",
>       "shutdown_state":"clean",
>       "shutdown_count":0
>     }
>   }
> ]
> 
> The patch depends on the kernel PAPR PDSM implementation for
> PDSM_SMART_INJECT posted at [1].
> 
> [1] : https://patchwork.kernel.org/project/linux-nvdimm/patch/163091917031.334.16212158243308361834.stgit@82313cf9f602/
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
> Changelog:
> 
> Since v1:
> Link: https://lore.kernel.org/nvdimm/20210712173132.1205192-3-vaibhav@linux.ibm.com/
> * Updates to patch description.
> 
>  ndctl/lib/papr.c      |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/papr_pdsm.h |   17 ++++++++++++++
>  2 files changed, 78 insertions(+)
> 
> diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
> index 42ff200d..b797e1e5 100644
> --- a/ndctl/lib/papr.c
> +++ b/ndctl/lib/papr.c
> @@ -221,6 +221,41 @@ static unsigned int papr_smart_get_shutdown_state(struct ndctl_cmd *cmd)
>  	return health.dimm_bad_shutdown;
>  }
>  
> +static int papr_smart_inject_supported(struct ndctl_dimm *dimm)
> +{
> +	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL))
> +		return -EOPNOTSUPP;
> +
> +	if (!test_dimm_dsm(dimm, PAPR_PDSM_SMART_INJECT))
> +		return -EIO;
> +
> +	return ND_SMART_INJECT_HEALTH_STATE | ND_SMART_INJECT_UNCLEAN_SHUTDOWN;
> +}
> +
> +static int papr_smart_inject_valid(struct ndctl_cmd *cmd)
> +{
> +	if (cmd->type != ND_CMD_CALL ||
> +	    to_pdsm(cmd)->cmd_status != 0 ||
> +	    to_pdsm_cmd(cmd) != PAPR_PDSM_SMART_INJECT)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static struct ndctl_cmd *papr_new_smart_inject(struct ndctl_dimm *dimm)
> +{
> +	struct ndctl_cmd *cmd;
> +
> +	cmd = allocate_cmd(dimm, PAPR_PDSM_SMART_INJECT,
> +			sizeof(struct nd_papr_pdsm_smart_inject));
> +	if (!cmd)
> +		return NULL;
> +	/* Set the input payload size */
> +	to_ndcmd(cmd)->nd_size_in = ND_PDSM_HDR_SIZE +
> +		sizeof(struct nd_papr_pdsm_smart_inject);
> +	return cmd;
> +}
> +
>  static unsigned int papr_smart_get_life_used(struct ndctl_cmd *cmd)
>  {
>  	struct nd_papr_pdsm_health health;
> @@ -255,11 +290,37 @@ static unsigned int papr_smart_get_shutdown_count(struct ndctl_cmd *cmd)
>  
>  	return (health.extension_flags & PDSM_DIMM_DSC_VALID) ?
>  		(health.dimm_dsc) : 0;
> +}
> +
> +static int papr_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable)
> +{
> +	if (papr_smart_inject_valid(cmd) < 0)
> +		return -EINVAL;
> +
> +	to_payload(cmd)->inject.flags |= PDSM_SMART_INJECT_HEALTH_FATAL;
> +	to_payload(cmd)->inject.fatal_enable = enable;
>  
> +	return 0;
> +}
> +
> +static int papr_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd,
> +						 bool enable)
> +{
> +	if (papr_smart_inject_valid(cmd) < 0)
> +		return -EINVAL;
> +
> +	to_payload(cmd)->inject.flags |= PDSM_SMART_INJECT_BAD_SHUTDOWN;
> +	to_payload(cmd)->inject.unsafe_shutdown_enable = enable;
> +
> +	return 0;
>  }
>  
>  struct ndctl_dimm_ops * const papr_dimm_ops = &(struct ndctl_dimm_ops) {
>  	.cmd_is_supported = papr_cmd_is_supported,
> +	.new_smart_inject = papr_new_smart_inject,
> +	.smart_inject_supported = papr_smart_inject_supported,
> +	.smart_inject_fatal = papr_cmd_smart_inject_fatal,
> +	.smart_inject_unsafe_shutdown = papr_cmd_smart_inject_unsafe_shutdown,
>  	.smart_get_flags = papr_smart_get_flags,
>  	.get_firmware_status =  papr_get_firmware_status,
>  	.xlat_firmware_status = papr_xlat_firmware_status,
> diff --git a/ndctl/lib/papr_pdsm.h b/ndctl/lib/papr_pdsm.h
> index f45b1e40..20ac20f8 100644
> --- a/ndctl/lib/papr_pdsm.h
> +++ b/ndctl/lib/papr_pdsm.h
> @@ -121,12 +121,29 @@ struct nd_papr_pdsm_health {
>  enum papr_pdsm {
>  	PAPR_PDSM_MIN = 0x0,
>  	PAPR_PDSM_HEALTH,
> +	PAPR_PDSM_SMART_INJECT,
>  	PAPR_PDSM_MAX,
>  };
> +/* Flags for injecting specific smart errors */
> +#define PDSM_SMART_INJECT_HEALTH_FATAL		(1 << 0)
> +#define PDSM_SMART_INJECT_BAD_SHUTDOWN		(1 << 1)
> +
> +struct nd_papr_pdsm_smart_inject {
> +	union {
> +		struct {
> +			/* One or more of PDSM_SMART_INJECT_ */
> +			__u32 flags;
> +			__u8 fatal_enable;
> +			__u8 unsafe_shutdown_enable;
> +		};
> +		__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
> +	};
> +};
>  
>  /* Maximal union that can hold all possible payload types */
>  union nd_pdsm_payload {
>  	struct nd_papr_pdsm_health health;
> +	struct nd_papr_pdsm_smart_inject inject;
>  	__u8 buf[ND_PDSM_PAYLOAD_MAX_SIZE];
>  } __attribute__((packed));
>  
> 
> 
