Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa8.fujitsucc.c3s2.iphmx.com (esa8.fujitsucc.c3s2.iphmx.com
 [68.232.159.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E6C552119EF2B
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 00:40:23 -0800 (PST)
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: RE: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Thu, 21 Feb 2019 08:40:02 +0000
Message-ID: <OSBPR01MB50009900A5FE2E8588AA6367F77E0@OSBPR01MB5000.jpnprd01.prod.outlook.com>
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: ja-JP
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Dexuan Cui' <decui@microsoft.com>, Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Kelley <mikelley@microsoft.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dexuan Cui [mailto:decui@microsoft.com]
> Sent: Wednesday, February 20, 2019 2:12 PM
> To: Dave Jiang <dave.jiang@intel.com>; Vishal Verma
> <vishal.l.verma@intel.com>; Dan Williams <dan.j.williams@intel.com>;
> linux-nvdimm@lists.01.org; Michael Kelley <mikelley@microsoft.com>; Qi,
> Fuli/斉 福利 <qi.fuli@fujitsu.com>; Johannes Thumshirn <jthumshirn@suse.de>
> Subject: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
> 
> 
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
> -static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx
> *fctx)
> +static bool ndctl_dimm_test_and_enable_notification(struct ndctl_dimm
> *dimm)
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

Hi Dexuan,

I think that "monitor" should be a "read-only" command and can't force the users to change their options.
The monitor.event_flags will work for all NVDIMMs to be monitored.
I don't know whether a physical NVDIMM could be mounted on the OS running inside of a virtual machine.
If yes, this forced changing may cause an exception of monitoring smart threshold events on NVDIMM.

Thanks,
 Qi

> +			notice(&monitor,
> +				"%s: only dimm-health-state can be
> monitored\n",
> +				name);
> +		}
> +		return true;
> +	}
> +
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
>  		err(&monitor, "%s: enable supported threshold alarms
> failed\n", name);
> -		return;
> +		return false;
>  	}
> 
> +	return true;
> +}
> +
> +static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx
> *fctx)
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
