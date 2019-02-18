Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa10.fujitsucc.c3s2.iphmx.com (esa10.fujitsucc.c3s2.iphmx.com
 [68.232.159.247])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1EDE201B044D
 for <linux-nvdimm@lists.01.org>; Sun, 17 Feb 2019 17:52:19 -0800 (PST)
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: RE: [ndctl PATCH] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Mon, 18 Feb 2019 01:52:11 +0000
Message-ID: <OSAPR01MB3396721CFC3535CC201B799DF7630@OSAPR01MB3396.jpnprd01.prod.outlook.com>
References: <PU1P153MB016948B28D99FE01EE8252DFBF600@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <OSAPR01MB3396F103A8B3B5569F26D4DDF7600@OSAPR01MB3396.jpnprd01.prod.outlook.com>
 <PU1P153MB01693A3809BC7EA9B19AC30CBF610@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01693A3809BC7EA9B19AC30CBF610@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Saturday, February 16, 2019 4:26 PM
> To: Qi, Fuli <qi.fuli@fujitsu.com>; Dave Jiang <dave.jiang@intel.com>;
> Vishal Verma <vishal.l.verma@intel.com>; Dan Williams <dan.j.williams@intel.com>;
> linux-nvdimm@lists.01.org
> Cc: Michael Kelley <mikelley@microsoft.com>
> Subject: RE: [ndctl PATCH] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
> 
> > From: qi.fuli@fujitsu.com <qi.fuli@fujitsu.com>
> > Sent: Friday, February 15, 2019 1:26 AM
> > > ...
> > > --- a/ndctl/monitor.c
> > > +++ b/ndctl/monitor.c
> > > @@ -265,31 +265,50 @@ static bool filter_region(struct ndctl_region
> > *region,
> > >  	return true;
> > >  }
> > >
> > > -static void filter_dimm(struct ndctl_dimm *dimm, struct
> > > util_filter_ctx *fctx)
> > > +static bool ndctl_dimm_test_and_enable_notification(struct
> > > +ndctl_dimm
> > *dimm)
> > >  {
> > > -	struct monitor_dimm *mdimm;
> > > -	struct monitor_filter_arg *mfa = fctx->monitor;
> > >  	const char *name = ndctl_dimm_get_devname(dimm);
> > >
> > > +	/*
> > > +	 * Hyper-V Virtual NVDIMM doesn't use ND_CMD_SMART to get the
> > > health
> > > +	 * info. Instead, it uses ND_CMD_CALL, so the checking here can't
> > > +	 * apply, and it doesn't support threshold alarms.
> > > +	 */
> > > +	if (ndctl_dimm_get_cmd_family(dimm) == NVDIMM_FAMILY_HYPERV)
> > > +		return true;
> >
> > Hi,
> >
> > I think it would be better to add a checking monitor.event_flags step here.
> > Users should be notified if they setup monitoring smart threshold
> > events on NVDIMM_FAMILY_HYPERV.
> >
> > QI
> 
> Hi Qi,
> Unluckily NVDIMM_FAMILY_HYPERV doesn't support monitoring smart threshold
> events. Please see the _DSM Interface for Hyper-V Virtual NVDIMM at
> https://uefi.org/RFIC_LIST (Virtual NVDIMM 0x1901).
> 
> So there is no ops->new_smart_threshold defined for NVDIMM_FAMILY_HYPERV.
> 
> The patch only skips the checks for NVDIMM_FAMILY_HYPERV, and the behavior for
> the others remains the same.
> 
> Thanks,
> -- Dexuan

Hi Dexuan,

I am sorry I didn't explain it clearly enough.
I want to say that users may not know that NVDIMM_FAMILY_HYPERV doesn't support monitoring smart threshold events.
If users setup monitoring smart threshold events on NVDIMM_FAMILY_HYPERV by mistake,
it would be more friendly to send them a notification.

Thanks,
  Qi

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
