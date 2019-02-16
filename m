From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Sat, 16 Feb 2019 07:25:47 +0000
Message-ID: <PU1P153MB01693A3809BC7EA9B19AC30CBF610@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB016948B28D99FE01EE8252DFBF600@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <OSAPR01MB3396F103A8B3B5569F26D4DDF7600@OSAPR01MB3396.jpnprd01.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <OSAPR01MB3396F103A8B3B5569F26D4DDF7600-OxqQCv4d1nQ3UXb08eLJjncolHNk5qUtvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>
> Sent: Friday, February 15, 2019 1:26 AM
> > ...
> > --- a/ndctl/monitor.c
> > +++ b/ndctl/monitor.c
> > @@ -265,31 +265,50 @@ static bool filter_region(struct ndctl_region
> *region,
> >  	return true;
> >  }
> >
> > -static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
> > +static bool ndctl_dimm_test_and_enable_notification(struct ndctl_dimm
> *dimm)
> >  {
> > -	struct monitor_dimm *mdimm;
> > -	struct monitor_filter_arg *mfa = fctx->monitor;
> >  	const char *name = ndctl_dimm_get_devname(dimm);
> >
> > +	/*
> > +	 * Hyper-V Virtual NVDIMM doesn't use ND_CMD_SMART to get the
> > health
> > +	 * info. Instead, it uses ND_CMD_CALL, so the checking here can't
> > +	 * apply, and it doesn't support threshold alarms.
> > +	 */
> > +	if (ndctl_dimm_get_cmd_family(dimm) == NVDIMM_FAMILY_HYPERV)
> > +		return true;
> 
> Hi,
> 
> I think it would be better to add a checking monitor.event_flags step here.
> Users should be notified if they setup monitoring smart threshold events on
> NVDIMM_FAMILY_HYPERV.
> 
> QI

Hi Qi,
Unluckily NVDIMM_FAMILY_HYPERV doesn't support monitoring smart 
threshold events. Please see the _DSM Interface for Hyper-V Virtual NVDIMM
at https://uefi.org/RFIC_LIST (Virtual NVDIMM 0x1901). 

So there is no ops->new_smart_threshold defined for
NVDIMM_FAMILY_HYPERV.

The patch only skips the checks for NVDIMM_FAMILY_HYPERV, and the behavior
for the others remains the same.

Thanks,
-- Dexuan
