Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 439E121A07A80
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 12:50:06 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id b15-v6so2923950oib.10
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 12:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <153724975102.55312.9664009456306267501.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153724975617.55312.7253687867673718680.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1537298146.5995.239.camel@intel.com>
In-Reply-To: <1537298146.5995.239.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Sep 2018 12:49:53 -0700
Message-ID: <CAPcyv4hGEewBk=TSO6ey50u1uoguoD7BVD96qCw+0d+hKkdHYA@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/3] ndctl: Introduce dirty-dimm command
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
To: Vishal L Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 18, 2018 at 12:15 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
>
> On Mon, 2018-09-17 at 22:49 -0700, Dan Williams wrote:
> > Some DIMMs provide a facility to track dirty-shutdown events. The
> > counter only rolls forward after the OS sets a latch. This allows the
> > agent tracking dirty shutdowns to ignore events that occur while the
> > capacity has not been written. For these DIMMs dirty-dimm will trigger
> > the counter to roll to the next state. The shutdown state can be
> > retrieved with 'ndctl list -DH'
> >
> > Cc: Keith Busch <keith.busch@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  Documentation/ndctl/Makefile.am          |    1 +
> >  Documentation/ndctl/ndctl-dirty-dimm.txt |   29 +++++++++++++++++++++++++++++
> >  builtin.h                                |    1 +
> >  ndctl/dimm.c                             |   28 ++++++++++++++++++++++++++++
> >  ndctl/ndctl.c                            |    1 +
> >  5 files changed, 60 insertions(+)
> >  create mode 100644 Documentation/ndctl/ndctl-dirty-dimm.txt
>
> The series generally looks good to me, just a couple comments below:
>
> >
> > diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> > index a4203f354000..595e4e4096a5 100644
> > --- a/ndctl/dimm.c
> > +++ b/ndctl/dimm.c
> > @@ -61,6 +61,19 @@ static int action_zero(struct ndctl_dimm *dimm, struct action_context *actx)
> >       return ndctl_dimm_zero_labels(dimm);
> >  }
> >
> > +static int action_dirty(struct ndctl_dimm *dimm, struct action_context *actx)
> > +{
> > +     struct ndctl_cmd *cmd;
> > +
> > +     cmd = ndctl_dimm_cmd_new_ack_shutdown_count(dimm);
> > +     if (!cmd)
> > +             return -EOPNOTSUPP;
> > +     ndctl_cmd_submit(cmd);
>
> Shouldn't we report any errors here?

Yeah, I expect failure here is likely to be common, so we shouldn't be
silent about it.

> > +     ndctl_cmd_unref(cmd);
> > +
> > +        return 0;
>
>         ^ stray whitespace?

Yup, and now I also a few asciidoctor reported nits, will resend.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
