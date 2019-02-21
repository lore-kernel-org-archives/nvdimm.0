From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
Date: Thu, 21 Feb 2019 18:30:42 +0000
Message-ID: <PU1P153MB016950BB76440DE9F413A615BF7E0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <OSBPR01MB50009900A5FE2E8588AA6367F77E0@OSBPR01MB5000.jpnprd01.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <OSBPR01MB50009900A5FE2E8588AA6367F77E0-zhdMvvdcU0ZckHoPmfvix3colHNk5qUtvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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
To: "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>
> Sent: Thursday, February 21, 2019 12:40 AM
> > ...
> > +	/*
> > +	 * Hyper-V Virtual NVDIMM doesn't use ND_CMD_SMART to get the
> > health info. Instead, it uses ND_CMD_CALL, so the checking here can't
> > +	 * apply, and it doesn't support threshold alarms -- actually it only
> > +	 * supports one event: ND_EVENT_HEALTH_STATE.
> > +	 */
> > +	if (ndctl_dimm_get_cmd_family(dimm) == NVDIMM_FAMILY_HYPERV) {
> > +		if (monitor.event_flags != ND_EVENT_HEALTH_STATE) {
> > +			monitor.event_flags = ND_EVENT_HEALTH_STATE;
> > +
> > +			notice(&monitor, "%s: only dimm-health-state can be
> >               monitored\n", name);

> Hi Dexuan,
> I think that "monitor" should be a "read-only" command and can't force the
> users to change their options.
> The monitor.event_flags will work for all NVDIMMs to be monitored.
> I don't know whether a physical NVDIMM could be mounted on the OS
> running inside of a virtual machine.
> If yes, this forced changing may cause an exception of monitoring smart
> threshold events on NVDIMM.
> 
> Thanks,
>  Qi

Hi Qi,
Generally speaking, I agree with you, but here the fact is that we can only
monitor this one single event "dimm-health-state" for Hyper-V Virtual NVDIMM,
and the other events are meaningless for Hyper-V Virtual NVDIMM, as they're
not supported by Hyper-V Virtual NVDIMM.

So, if the user specifies more events than just "dimm-health-state", or the user
doesn't specify "dimm-health-state", it's reasonable to force monitor.event_flags
to equal to ND_EVENT_HEALTH_STATE, and I explicitly print a warning.

The line "monitor.event_flags = ND_EVENT_HEALTH_STATE" only runs in a Linux
VM running on Hyper-V. It can't adversely affect bare metal cases. In a Linux
VM on Hyper-V, all the NVDIMMs appearing in the VM are Hyper-V Virtual NVDIMMs.

A physical NVDIMM can't be directly passed through to a VM and the hypervisors
(e.g., Xen, KVM, Hyper-V, Qemu, etc.) have to virtualize it to make it available to a
VM. In a VM, the NVDIMM_FAMILY is NVDIMM_FAMILY_HYPERV only when
the VM runs on Hyper-V. 

So I think we should be good. :-)
 
Thanks,
-- Dexuan
