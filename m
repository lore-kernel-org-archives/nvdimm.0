From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Fri, 22 Mar 2019 02:08:46 +0000
Message-ID: <PU1P153MB0169CA436F52268DD2BEF745BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
To: "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Williams, Dan J" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: Verma, Vishal L <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Sent: Wednesday, March 20, 2019 6:55 PM
> ...
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
> health
> > +	 * info. Instead, it uses ND_CMD_CALL, so the checking here can't
> > +	 * apply, and it doesn't support threshold alarms -- actually it only
> > +	 * supports one event: ND_EVENT_HEALTH_STATE.
> > +	 */
> > +	if (ndctl_dimm_get_cmd_family(dimm) == NVDIMM_FAMILY_HYPERV) {
> > +		if (monitor.event_flags != ND_EVENT_HEALTH_STATE) {
> > +			monitor.event_flags = ND_EVENT_HEALTH_STATE;
> > +
> > +			notice(&monitor,
> > +				"%s: only dimm-health-state can be monitored\n",
> > +				name);
> > +		}
> > +		return true;
> > +	}
> > +
> 
> I'm not sure about the family-specific special casing -- it leaks family
> specific details into the common implementation, something that's been
> avoidable thus far.
> 
> Is there any reason why the ndctl_dimm_is_cmd_supported() can't be made
> to fail appropriately for anything that is not supported, by adding the
> necessary functions to dimm-ops?

IMO there are 2 issues in ndctl/monitor.c: filter_dimm():

1. IMO the cmd numbers ND_CMD_SMART (1) and 
ND_CMD_SMART_THRESHOLD(2) are not really device-neutral. They
work for ndctl/lib/intel.c and it looks they happen to work for 
ndctl/lib/hpe1.c, as hpe "happens" to have:
       NDN_HPE1_CMD_SMART = 1,
       NDN_HPE1_CMD_SMART_THRESHOLD = 2,

But for ndctl/lib/msft.c, 1 and 2 mean different things. See [1].
So the current "ndctl monitor" can't support msft.c.

For ndctl/lib/hyperv.c, 1 and 2 means:
        ND_HYPERV_CMD_GET_HEALTH_INFO = 1,
        ND_HYPERV_CMD_GET_SHUTDOWN_INFO = 2,
They're also incompatible with ND_CMD_SMART and
ND_CMD_SMART_THRESHOLD.
Of source, the current code can "work" since these ND_HYPERV_CMD*
numbers happen to be the same as ND_CMD_SMART and 
ND_CMD_SMART_THRESHOLD. So this may not be an isue for hyperv.c.

2. The current code assumes ND_SMART_ALARM_VALID must be supported.
However, NVDIMM_FAMILY_HYPERV doesn't support it, so currently
ndctl/monitor.c: filter_dimm() reports an error and returns -- for Hyper-V, 
we should not return... hence I made this patch. 

Of source, we can add a new op to dimm->ops, e.g. 
ops->monitor_supported() and then change the common code accordingly,
but I can imagine that would require a lot more changes and I guess it may not
worth that effort? Please share your insights!

> That way if the user enters any of the unsupported options, they will
> just fail normally, and the user will be expected to provide the right
> options for the environment they know they're running in.

When the user enters any of the unsupported options, they will only
get an "no dimms to monitor" error, which gives no hint why the
error happens, and confuses the user...
 
> Indeed, I think that patch 3 of this series should never be required :)
Please see the above.

Thanks,
-- Dexuan

[1] https://docs.microsoft.com/en-us/windows-hardware/drivers/storage/-dsm-interface-for-byte-addressable-energy-backed-function-class--function-interface-1-
