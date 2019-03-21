Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12BFC21959CB2
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 18:34:19 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 2/4] libndctl: NVDIMM_FAMILY_HYPERV: add
 .smart_get_shutdown_count (Function 2)
Date: Thu, 21 Mar 2019 01:34:17 +0000
Message-ID: <301702909683ab34e65609696e2e60f98eadc15d.camel@intel.com>
References: <PU1P153MB01698DBBE02A896DFB8FB4EBBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01698DBBE02A896DFB8FB4EBBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <41FED50F2B73084C948426907B6FBAD7@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "decui@microsoft.com" <decui@microsoft.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "mikelley@microsoft.com" <mikelley@microsoft.com>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-02-20 at 05:10 +0000, Dexuan Cui wrote:
> With the patch, "ndctl list --dimms --health --idle" can show
> "shutdown_count" now, e.g.
> 
> {
>     "dev":"nmem0",
>     "id":"04d5-01-1701-00000000",
>     "handle":0,
>     "phys_id":0,
>     "health":{
>       "health_state":"ok",
>       "shutdown_count":2
>     }
> }
> 
> The patch has to directly call ndctl_cmd_submit() in
> hyperv_cmd_smart_get_flags() and hyperv_cmd_smart_get_shutdown_count() to
> get the needed info, because util_dimm_health_to_json() only submits *one*
> command, and unluckily for Hyper-V Virtual NVDIMM we need to call both
> Function 1 and 2 to get the needed info.
> 
> My feeling is that it's not very good to directly call ndctl_cmd_submit(),
> but by doing this we don't need to make any change to the common code, and
> I'm unsure if it's good to change the common code just for Hyper-V.

I thought about this, and this approach seems reasonable to me. I agree
that there is not precedent for submitting a command from the various
family libraries, but I think the way dimm-ops are structured, this
seems warranted. The way I see it is a dimm op means "get X information
for this family", and however it needs to be obtained is just a detail
specific to that DSM family. For intel it happens to be in the smart
information, but if it happens to be a separate DSM, that is also fine.

I do think this commentary in the changelog can be reworded. Consider
changing the first-person narrative to a more 'informational' or
'imperative' one. For example: "The 'smart_get_shutdown_count' dimm-op
is expected to return a shutdown count, but for the HYPERV family, this
is only available from a separate DSM. Perform a command submission in
the 'hyperv_cmd_smart_get_shutdown_count' dimm op to retrieve this, so
that a smart health listing can display this information"


Apart from the commit message comments in the previous patch, also
consider wrapping commit messages to a 72 column width [1].

[1]: https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  ndctl/lib/hyperv.c | 62 ++++++++++++++++++++++++++++++++++++++++------
>  ndctl/lib/hyperv.h |  7 ++++++
>  2 files changed, 62 insertions(+), 7 deletions(-)
> 
> diff --git a/ndctl/lib/hyperv.c b/ndctl/lib/hyperv.c
> index b303d50..e8ec142 100644
> --- a/ndctl/lib/hyperv.c
> +++ b/ndctl/lib/hyperv.c
> @@ -22,7 +22,8 @@
>  #define CMD_HYPERV_STATUS(_c) (CMD_HYPERV(_c)->u.status)
>  #define CMD_HYPERV_SMART_DATA(_c) (CMD_HYPERV(_c)->u.smart.data)
>  
> -static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
> +static struct ndctl_cmd *hyperv_dimm_cmd_new_cmd(struct ndctl_dimm *dimm,
> +						 unsigned int command)

The 'new' in the function name is a bit confusing, as 'new' functions
are also used for cmd allocation. I'd suggest following the intel.c
convention and calling it 'alloc_hyperv_cmd'.

Maybe consider calling it this right from the start in patch 1, and also
having the wrapper for the new smart command in patch 1 - this way there
is less unrelated thrash in this patch, and makes it easier to review.

>  {
>  	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
>  	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
> @@ -35,8 +36,7 @@ static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>  		return NULL;
>  	}
>  
> -	if (test_dimm_dsm(dimm, ND_HYPERV_CMD_GET_HEALTH_INFO) ==
> -			  DIMM_DSM_UNSUPPORTED) {
> +	if (test_dimm_dsm(dimm, command) ==  DIMM_DSM_UNSUPPORTED) {
>  		dbg(ctx, "unsupported function\n");
>  		return NULL;
>  	}
> @@ -54,7 +54,7 @@ static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>  
>  	hyperv = CMD_HYPERV(cmd);
>  	hyperv->gen.nd_family = NVDIMM_FAMILY_HYPERV;
> -	hyperv->gen.nd_command = ND_HYPERV_CMD_GET_HEALTH_INFO;
> +	hyperv->gen.nd_command = command;
>  	hyperv->gen.nd_fw_size = 0;
>  	hyperv->gen.nd_size_in = offsetof(struct nd_hyperv_smart, status);
>  	hyperv->gen.nd_size_out = sizeof(hyperv->u.smart);
> @@ -65,34 +65,74 @@ static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>  	return cmd;
>  }
>  
> -static int hyperv_smart_valid(struct ndctl_cmd *cmd)
> +static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
> +{
> +	return hyperv_dimm_cmd_new_cmd(dimm, ND_HYPERV_CMD_GET_HEALTH_INFO);
> +}
> +
> +static int hyperv_cmd_valid(struct ndctl_cmd *cmd, unsigned int command)
>  {
>  	if (cmd->type != ND_CMD_CALL ||
>  	    cmd->size != sizeof(*cmd) + sizeof(struct nd_pkg_hyperv) ||
>  	    CMD_HYPERV(cmd)->gen.nd_family != NVDIMM_FAMILY_HYPERV ||
> -	    CMD_HYPERV(cmd)->gen.nd_command != ND_HYPERV_CMD_GET_HEALTH_INFO ||
> +	    CMD_HYPERV(cmd)->gen.nd_command != command ||
>  	    cmd->status != 0 ||
>  	    CMD_HYPERV_STATUS(cmd) != 0)
>  		return cmd->status < 0 ? cmd->status : -EINVAL;
>  	return 0;
>  }
>  
> +static int hyperv_smart_valid(struct ndctl_cmd *cmd)
> +{
> +	return hyperv_cmd_valid(cmd, ND_HYPERV_CMD_GET_HEALTH_INFO);
> +}
> +

Similar comment as above. In general this sort of refactoring can be
done in two ways:

   1. If you know the end result at the start, just create the generic
   helpers then, so future patches don't have the thrash.

   2. If the changes are in prior code, and if the refactoring is
   extensive, split it out into its own functionally equivalent patch,
   so that the meat of *this* change is not cluttered by unrelated
   refactoring.

>  static int hyperv_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
>  {
>  	return CMD_HYPERV_STATUS(cmd) == 0 ? 0 : -EINVAL;
>  }
>  
> +static int hyperv_get_shutdown_count(struct ndctl_cmd *cmd,
> +				     unsigned int *count)

No need to split this line, it fits within 80 columns.

> +{
> +	unsigned int command = ND_HYPERV_CMD_GET_SHUTDOWN_INFO;
> +	struct ndctl_cmd *cmd_get_shutdown_info;
> +	int rc;
> +
> +	cmd_get_shutdown_info = hyperv_dimm_cmd_new_cmd(cmd->dimm, command);
> +	if (!cmd_get_shutdown_info)
> +		return -EINVAL;
> +
> +	if (ndctl_cmd_submit(cmd_get_shutdown_info) < 0 ||

The return value from ndctl_cmd_submit() only indicates that the kernel
was successfully able to send the DSM to the platform firmware. It does
*not* capture any failures indicated by the platform in the 'status'
field of the cmd struct. We should be ensuring that was also successful
by calling the hyperv_cmd_xlat_firmware_status for the cmd.
Alternatively, instead of the ndctl_cmd_submit() API, you could also use
the newly added (in ndctl-64) ndctl_cmd_submit_xlat() API, which calls
the dimm-op for 'xlat_firmware_status' if present to do a status
translation, and present it in the return value.

> +	    hyperv_cmd_valid(cmd_get_shutdown_info, command) < 0) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	*count = CMD_HYPERV(cmd_get_shutdown_info)->u.shutdown_info.count;
> +	rc = 0;
> +out:
> +	ndctl_cmd_unref(cmd_get_shutdown_info);
> +	return rc;
> +}
> +
>  static unsigned int hyperv_cmd_smart_get_flags(struct ndctl_cmd *cmd)
>  {
>  	int rc;
> +	unsigned int count;
> +	unsigned int flags = 0;
>  
>  	rc = hyperv_smart_valid(cmd);
>  	if (rc < 0) {
>  		errno = -rc;
>  		return 0;
>  	}
> +	flags |= ND_SMART_HEALTH_VALID;
>  
> -	return ND_SMART_HEALTH_VALID;
> +	if (hyperv_get_shutdown_count(cmd, &count) == 0)
> +		flags |= ND_SMART_SHUTDOWN_COUNT_VALID;
> +
> +	return flags;
>  }
>  
>  static unsigned int hyperv_cmd_smart_get_health(struct ndctl_cmd *cmd)
> @@ -121,9 +161,17 @@ static unsigned int hyperv_cmd_smart_get_health(struct ndctl_cmd *cmd)
>  	return health;
>  }
>  
> +static unsigned int hyperv_cmd_smart_get_shutdown_count(struct ndctl_cmd *cmd)
> +{
> +	unsigned int count;
> +
> +	return hyperv_get_shutdown_count(cmd, &count) == 0 ? count : UINT_MAX;

I'd prefer the long form rc = func(); if (rc) .. here.
Also, shouldn't we set errno appropriately in the UINT_MAX case?

> +}
> +
>  struct ndctl_dimm_ops * const hyperv_dimm_ops = &(struct ndctl_dimm_ops) {
>  	.new_smart = hyperv_dimm_cmd_new_smart,
>  	.smart_get_flags = hyperv_cmd_smart_get_flags,
>  	.smart_get_health = hyperv_cmd_smart_get_health,
> +	.smart_get_shutdown_count = hyperv_cmd_smart_get_shutdown_count,
>  	.xlat_firmware_status = hyperv_cmd_xlat_firmware_status,
>  };
> diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
> index 8e55a97..5232d60 100644
> --- a/ndctl/lib/hyperv.h
> +++ b/ndctl/lib/hyperv.h
> @@ -19,6 +19,7 @@ enum {
>  
>  	/* non-root commands */
>  	ND_HYPERV_CMD_GET_HEALTH_INFO = 1,
> +	ND_HYPERV_CMD_GET_SHUTDOWN_INFO = 2,
>  };
>  
>  /*
> @@ -38,9 +39,15 @@ struct nd_hyperv_smart {
>  	};
>  } __attribute__((packed));
>  
> +struct nd_hyperv_shutdown_info {
> +	 __u32   status;
> +	 __u32   count;
> +} __attribute__((packed));
> +
>  union nd_hyperv_cmd {
>  	__u32			status;
>  	struct nd_hyperv_smart	smart;
> +	struct nd_hyperv_shutdown_info shutdown_info;
>  } __attribute__((packed));
>  
>  struct nd_pkg_hyperv {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
