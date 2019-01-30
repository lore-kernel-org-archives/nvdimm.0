From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH] libndctl, dimm: Don't require an xlat function
Date: Wed, 30 Jan 2019 22:54:29 +0000
Message-ID: <PU1P153MB016993F3BA944E440C3F5593BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <20190130102645.31032-1-oohall@gmail.com>
 <CAPcyv4i-d=dt1JSnfbBBoyN1XdsfomK1TVo-kvdHNKR=+nmotA@mail.gmail.com>
 <9e91a2899b78fee4aa7f99b9b4a011b147e65ccc.camel@intel.com>
 <CAPcyv4jGYVNbbNZ5Kaw7SpwhH=BW8bgDGcj-80m2XmAKD5-ZEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4jGYVNbbNZ5Kaw7SpwhH=BW8bgDGcj-80m2XmAKD5-ZEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

> From: Linux-nvdimm <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org> On Behalf Of Dan
> Williams
> Sent: Wednesday, January 30, 2019 11:08 AM
> To: Verma, Vishal L <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> Subject: Re: [PATCH] libndctl, dimm: Don't require an xlat function
> 
> On Wed, Jan 30, 2019 at 11:05 AM Verma, Vishal L
> <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >
> >
> > On Wed, 2019-01-30 at 08:38 -0800, Dan Williams wrote:
> > > On Wed, Jan 30, 2019 at 2:27 AM Oliver O'Halloran <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
> > > > commit 62bbfce3cb62 ("libndctl, intel: Add infrastructure for
> > > > firmware_status translation") has the unfortunate side effect of making
> > > > all NDCTL commands fail with -ENOMSG unless an xlat_firmware_status
> > > > function is defined for the DIMM family. This means that none of the
> > > > DIMM label manipulation commands work anymore, unless you happen
> to be
> > > > using an Intel DIMM.
> > > >
> > > > Cc: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Fixes: 62bbfce3cb62 ("libndctl, intel: Add infrastructure for
> firmware_status translation")
> > > > Signed-off-by: Oliver O'Halloran <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > ---
> > > >  ndctl/lib/libndctl.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > > > index 06f835d76117..80d107394a74 100644
> > > > --- a/ndctl/lib/libndctl.c
> > > > +++ b/ndctl/lib/libndctl.c
> > > > @@ -2846,6 +2846,9 @@ NDCTL_EXPORT int
> ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd)
> > > >          * useful), then the xlat function is available separately as well.
> > > >          */
> > > >         xlat_rc = ndctl_cmd_xlat_firmware_status(cmd);
> > > > +       if (xlat_rc == -ENOMSG)
> > > > +               return rc;
> > > > +
> > >
> > > Ah, good point, however I think we should do this instead:
> > >
> > > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > > index 830b791339d2..2fa89162e05e 100644
> > > --- a/ndctl/lib/libndctl.c
> > > +++ b/ndctl/lib/libndctl.c
> > > @@ -2710,7 +2710,7 @@ NDCTL_EXPORT int
> > > ndctl_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
> > >         struct ndctl_dimm_ops *ops = dimm ? dimm->ops : NULL;
> > >
> > >         if (!dimm || !ops || !ops->xlat_firmware_status)
> > > -               return -ENOMSG;
> > > +               return 0;
> > >         return ops->xlat_firmware_status(cmd);
> > >  }
> > >
> > >
> > > A failure to translate just means proceed with the information that we
> > > *do* have, not a failure.
> >
> > Ah good catch and I agree. Dan, will you send a proper patch for this
> > or shall I?
> 
> Go for it :)

Glad to know this will be fixed soon. 

Thanks,
-- Dexuan
