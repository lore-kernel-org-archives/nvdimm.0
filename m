Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46A9421959CB2
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 18:54:54 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Thu, 21 Mar 2019 01:54:52 +0000
Message-ID: <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel@intel.com>
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <9A05C076907C044BAA50D323D5BBA0A0@intel.com>
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


On Wed, 2019-02-20 at 05:11 +0000, Dexuan Cui wrote:
> Currently "ndctl monitor" fails for NVDIMM_FAMILY_HYPERV due to
> "no smart support".
> 
> NVDIMM_FAMILY_HYPERV doesn't use ND_CMD_SMART to get the health info.
> Instead, it uses ND_CMD_CALL, so the checking here can't apply,and it
> doesn't support threshold alarms -- actually it only supports one event:
> ND_EVENT_HEALTH_STATE.
> 
> See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901").
> 
> Let's skip the unnecessary checking for NVDIMM_FAMILY_HYPERV, and make
> sure we only monitor the "dimm-health-state" event and ignore the others.
> 
> With the patch, when an error happens, we log it with such a message:
> 
> {"timestamp":"1550547497.431731497","pid":1571,"event":
> {"dimm-health-state":true},"dimm":{"dev":"nmem1",
> "id":"04d5-01-1701-01000000","handle":1,"phys_id":0,
> "health":{"health_state":"fatal","shutdown_count":8}}}
> 
> Here the meaningful info is:
> "health":{"health_state":"fatal","shutdown_count":8}
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  ndctl/monitor.c | 42 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 43b2abe..43beb06 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -265,31 +265,59 @@ static bool filter_region(struct ndctl_region *region,
>  	return true;
>  }
>  
> -static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
> +static bool ndctl_dimm_test_and_enable_notification(struct ndctl_dimm *dimm)
>  {
> -	struct monitor_dimm *mdimm;
> -	struct monitor_filter_arg *mfa = fctx->monitor;
>  	const char *name = ndctl_dimm_get_devname(dimm);
>  
> +	/*
> +	 * Hyper-V Virtual NVDIMM doesn't use ND_CMD_SMART to get the health
> +	 * info. Instead, it uses ND_CMD_CALL, so the checking here can't
> +	 * apply, and it doesn't support threshold alarms -- actually it only
> +	 * supports one event: ND_EVENT_HEALTH_STATE.
> +	 */
> +	if (ndctl_dimm_get_cmd_family(dimm) == NVDIMM_FAMILY_HYPERV) {
> +		if (monitor.event_flags != ND_EVENT_HEALTH_STATE) {
> +			monitor.event_flags = ND_EVENT_HEALTH_STATE;
> +
> +			notice(&monitor,
> +				"%s: only dimm-health-state can be monitored\n",
> +				name);
> +		}
> +		return true;
> +	}
> +

I'm not sure about the family-specific special casing -- it leaks family
specific details into the common implementation, something that's been
avoidable thus far.

Is there any reason why the ndctl_dimm_is_cmd_supported() can't be made
to fail appropriately for anything that is not supported, by adding the
necessary functions to dimm-ops?

That way if the user enters any of the unsupported options, they will
just fail normally, and the user will be expected to provide the right
options for the environment they know they're running in.

Indeed, I think that patch 3 of this series should never be required :)

>  	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
>  		err(&monitor, "%s: no smart support\n", name);
> -		return;
> +		return false;
>  	}
>  	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD)) {
>  		err(&monitor, "%s: no smart threshold support\n", name);
> -		return;
> +		return false;
>  	}
>  
>  	if (!ndctl_dimm_is_flag_supported(dimm, ND_SMART_ALARM_VALID)) {
>  		err(&monitor, "%s: smart alarm invalid\n", name);
> -		return;
> +		return false;
>  	}
>  
>  	if (enable_dimm_supported_threshold_alarms(dimm)) {
>  		err(&monitor, "%s: enable supported threshold alarms failed\n", name);
> -		return;
> +		return false;
>  	}
>  
> +	return true;
> +}
> +
> +static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
> +{
> +	struct monitor_dimm *mdimm;
> +	struct monitor_filter_arg *mfa = fctx->monitor;
> +	const char *name = ndctl_dimm_get_devname(dimm);
> +
> +
> +	if (!ndctl_dimm_test_and_enable_notification(dimm))
> +		return;
> +
>  	mdimm = calloc(1, sizeof(struct monitor_dimm));
>  	if (!mdimm) {
>  		err(&monitor, "%s: calloc for monitor dimm failed\n", name);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
