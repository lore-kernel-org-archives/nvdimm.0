Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa12.fujitsucc.c3s2.iphmx.com (esa12.fujitsucc.c3s2.iphmx.com
 [216.71.156.125])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C08AD20886D9F
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 01:26:15 -0800 (PST)
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: RE: [ndctl PATCH] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Fri, 15 Feb 2019 09:26:02 +0000
Message-ID: <OSAPR01MB3396F103A8B3B5569F26D4DDF7600@OSAPR01MB3396.jpnprd01.prod.outlook.com>
References: <PU1P153MB016948B28D99FE01EE8252DFBF600@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB016948B28D99FE01EE8252DFBF600@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: ja-JP
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
To: 'Dexuan Cui' <decui@microsoft.com>, Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Michael Kelley <mikelley@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of Dexuan Cui
> Sent: Friday, February 15, 2019 3:38 PM
> To: Dave Jiang <dave.jiang@intel.com>; Vishal Verma <vishal.l.verma@intel.com>;
> Dan Williams <dan.j.williams@intel.com>; linux-nvdimm@lists.01.org
> Cc: Michael Kelley <mikelley@microsoft.com>
> Subject: [ndctl PATCH] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
> 
> 
> Currently "ndctl monitor" fails for NVDIMM_FAMILY_HYPERV due to
> "no smart support".
> 
> Actually NVDIMM_FAMILY_HYPERV doesn't use ND_CMD_SMART to get the health
> info. Instead, it uses ND_CMD_CALL, so the checking here can't apply,
> and NVDIMM_FAMILY_HYPERV doesn't support threshold alarms.
> 
> Let's skip the unnecessary checking for NVDIMM_FAMILY_HYPERV.
> 
> With the patch, when an error happens, we can log it with such a message:
> 
> {"timestamp":"1550209474.683237420","pid":3874,"event":
> {"dimm-spares-remaining":false,"dimm-media-temperature":false,
> "dimm-controller-temperature":false,"dimm-health-state":true,
> "dimm-unclean-shutdown":false},"dimm":{"dev":"nmem1",
> "id":"04d5-01-1701-01000000","handle":1,"phys_id":0,"health":
> {"health_state":"critical","shutdown_count":8}}}
> 
> Here the meaning info is:
> "health": {"health_state":"critical","shutdown_count":8}
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  ndctl/lib/libndctl.c   |  5 +++++
>  ndctl/lib/libndctl.sym |  1 +
>  ndctl/libndctl.h       |  1 +
>  ndctl/monitor.c        | 33 ++++++++++++++++++++++++++-------
>  4 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 48bdb27..1186579 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -1550,6 +1550,11 @@ NDCTL_EXPORT struct ndctl_dimm
> *ndctl_dimm_get_next(struct ndctl_dimm *dimm)
>  	return list_next(&bus->dimms, dimm, list);
>  }
> 
> +NDCTL_EXPORT unsigned long ndctl_dimm_get_cmd_family(struct ndctl_dimm
> *dimm)
> +{
> +	return dimm->cmd_family;
> +}
> +
>  NDCTL_EXPORT unsigned int ndctl_dimm_get_handle(struct ndctl_dimm *dimm)
>  {
>  	return dimm->handle;
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index cb9f769..470e895 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -38,6 +38,7 @@ global:
>  	ndctl_bus_wait_probe;
>  	ndctl_dimm_get_first;
>  	ndctl_dimm_get_next;
> +	ndctl_dimm_get_cmd_family;
>  	ndctl_dimm_get_handle;
>  	ndctl_dimm_get_phys_id;
>  	ndctl_dimm_get_vendor;
> diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> index 0debdb6..cb5a8fc 100644
> --- a/ndctl/libndctl.h
> +++ b/ndctl/libndctl.h
> @@ -145,6 +145,7 @@ struct ndctl_dimm *ndctl_dimm_get_next(struct ndctl_dimm
> *dimm);
>          for (dimm = ndctl_dimm_get_first(bus); \
>               dimm != NULL; \
>               dimm = ndctl_dimm_get_next(dimm))
> +unsigned long ndctl_dimm_get_cmd_family(struct ndctl_dimm *dimm);
>  unsigned int ndctl_dimm_get_handle(struct ndctl_dimm *dimm);
>  unsigned short ndctl_dimm_get_phys_id(struct ndctl_dimm *dimm);
>  unsigned short ndctl_dimm_get_vendor(struct ndctl_dimm *dimm);
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 43b2abe..6adc305 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -265,31 +265,50 @@ static bool filter_region(struct ndctl_region *region,
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
> +	 * apply, and it doesn't support threshold alarms.
> +	 */
> +	if (ndctl_dimm_get_cmd_family(dimm) == NVDIMM_FAMILY_HYPERV)

Hi,

I think it would be better to add a checking monitor.event_flags step here.
Users should be notified if they setup monitoring smart threshold events on NVDIMM_FAMILY_HYPERV.

QI

> +		return true;
> +
>  	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
>  		err(&monitor, "%s: no smart support\n", name);
> -		return;
> +		return false;
>  	}
>  	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD))
> {
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
>  		err(&monitor, "%s: enable supported threshold alarms failed\n",
> name);
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
> --
> 2.19.1
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
