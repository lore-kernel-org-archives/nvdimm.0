From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [ndctl PATCH v2 3/4] ndctl, lib: implement
 ndctl_dimm_get_cmd_family()
Date: Fri, 22 Mar 2019 01:33:14 +0000
Message-ID: <PU1P153MB016964775966CCD6A47BCB3CBF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01696E7773E8C8129D8CCE8BBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <221ceaa03f0a46d020da7a1c7fcd4d521bf5e09e.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <221ceaa03f0a46d020da7a1c7fcd4d521bf5e09e.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
> Sent: Wednesday, March 20, 2019 6:42 PM
> On Wed, 2019-02-20 at 05:11 +0000, Dexuan Cui wrote:
> > Let's export the family info so we can do some family-specific
> > handling in ndctl/monitor.c for Hyper-V NVDIMM.
> 
> s/Let's//

Will fix it.

> >  ndctl/lib/libndctl.c   | 5 +++++
> >  ndctl/lib/libndctl.sym | 1 +
> >  ndctl/libndctl.h       | 1 +
> >  3 files changed, 7 insertions(+)
> >
> > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > index 48bdb27..1186579 100644
> > --- a/ndctl/lib/libndctl.c
> > +++ b/ndctl/lib/libndctl.c
> > @@ -1550,6 +1550,11 @@ NDCTL_EXPORT struct ndctl_dimm
> *ndctl_dimm_get_next(struct ndctl_dimm *dimm)
> >  	return list_next(&bus->dimms, dimm, list);
> >  }
> >
> > +NDCTL_EXPORT unsigned long ndctl_dimm_get_cmd_family(struct
> ndctl_dimm *dimm)
> > +{
> > +	return dimm->cmd_family;
> > +}
> > +
> >  NDCTL_EXPORT unsigned int ndctl_dimm_get_handle(struct ndctl_dimm
> *dimm)
> >  {
> >  	return dimm->handle;
> > diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> > index cb9f769..470e895 100644
> > --- a/ndctl/lib/libndctl.sym
> > +++ b/ndctl/lib/libndctl.sym
> > @@ -38,6 +38,7 @@ global:
> >  	ndctl_bus_wait_probe;
> >  	ndctl_dimm_get_first;
> >  	ndctl_dimm_get_next;
> > +	ndctl_dimm_get_cmd_family;
> 
> Any new APIs need to go in a new LIBNDCTL_XX section (for this release
> that would be LIBNDCTL_20).
> If you rebase to the current 'pending' branch on github, the section has
> already been created at the bottom, and you can just add to that.

Will fix it

Thanks,
-- Dexuan 
