Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E3FD210F16BF
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 13:11:58 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2] ndctl: add an api for getting the ars_status
 overflow flag
Date: Wed, 6 Jun 2018 20:11:57 +0000
Message-ID: <1528315915.5328.25.camel@intel.com>
References: <20180606182605.28670-1-vishal.l.verma@intel.com>
 <CAPcyv4iQs8wdSLbCWFisacBYX7TWYy5tLQDqChHwi6qD1hvF6g@mail.gmail.com>
 <1528314837.5328.24.camel@intel.com>
 <CAPcyv4jh_J7haFXHND-rZpjhTXaCkhrXmH0hrJ-+wZykvJZLZw@mail.gmail.com>
In-Reply-To: <CAPcyv4jh_J7haFXHND-rZpjhTXaCkhrXmH0hrJ-+wZykvJZLZw@mail.gmail.com>
Content-Language: en-US
Content-ID: <A6E306A13FA2EC4B88671028E97894F4@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Zloch, Jacek" <jacek.zloch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-06-06 at 13:00 -0700, Dan Williams wrote:
> On Wed, Jun 6, 2018 at 12:53 PM, Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
> > On Wed, 2018-06-06 at 12:51 -0700, Dan Williams wrote:
> > > On Wed, Jun 6, 2018 at 11:26 AM, Vishal Verma <vishal.l.verma@intel.c
> > > om>
> > > wrote:
> > > > The ARS status command defines a 'flags' field that wasn't being
> > > > exposed
> > > > via an API yet. Since there is only one flag defined in ACPI 6.2,
> > > > add a
> > > > helper for retrieving it (overflow flag).
> > > > 
> > > > Reported-by: Jacek Zloch <jacek.zloch@intel.com>
> > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > > ---
> > > >  ndctl/lib/ars.c        | 11 +++++++++++
> > > >  ndctl/lib/libndctl.sym |  1 +
> > > >  ndctl/libndctl.h       |  4 ++++
> > > >  3 files changed, 16 insertions(+)
> > > > 
> > > > v2: instead of exposing the binary representation of flags, provide
> > > > a
> > > > helper for each flag. ACPI currently defines a single 'overflow'
> > > > flag.
> > > > (Dan)
> > > > 
> > > > diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
> > > > index e04b51e..b765c88 100644
> > > > --- a/ndctl/lib/ars.c
> > > > +++ b/ndctl/lib/ars.c
> > > > @@ -269,6 +269,17 @@ NDCTL_EXPORT unsigned long long
> > > > ndctl_cmd_ars_get_record_len(
> > > >         return ars_stat->ars_status->records[rec_index].length;
> > > >  }
> > > > 
> > > > +NDCTL_EXPORT int ndctl_cmd_ars_stat_get_flag_overflow(
> > > > +               struct ndctl_cmd *ars_stat)
> > > > +{
> > > > +       struct ndctl_ctx *ctx =
> > > > ndctl_bus_get_ctx(cmd_to_bus(ars_stat));
> > > > +
> > > > +       if (!validate_ars_stat(ctx, ars_stat))
> > > > +               return -EINVAL;
> > > > +
> > > > +       return (ars_stat->ars_status->flags &
> > > > ND_ARS_STAT_FLAG_OVERFLOW);
> > > > +}
> > > 
> > > How about return bool since it's a flag?
> > 
> > I considered it, but int allows us to return an error for an invalid
> > status
> > command. If we use a bool, should we just return 'false' for a bad
> > command?
> 
> Oh, sorry, missed that. In that case let's do:
> 
>    return !!(ars_stat->ars_status->flags & ND_ARS_STAT_FLAG_OVERFLOW);
> 
> So it's defined to be 0, 1, or -error.

Ok, yep that is better, I'll fix and send a new version.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
