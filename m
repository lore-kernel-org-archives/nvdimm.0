Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1820721157422
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 14:44:48 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3] ndctl: add an api for getting the ars_status
 overflow flag
Date: Wed, 6 Jun 2018 21:44:47 +0000
Message-ID: <1528321485.5328.26.camel@intel.com>
References: <20180606201805.1332-1-vishal.l.verma@intel.com>
 <CAPcyv4ix5=HcQ1+JUxP+PxkGURWS5mhFK2ur1x98bWVzatd_-Q@mail.gmail.com>
In-Reply-To: <CAPcyv4ix5=HcQ1+JUxP+PxkGURWS5mhFK2ur1x98bWVzatd_-Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <7B7CE21DE6D1144B871A90423C80620E@intel.com>
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

On Wed, 2018-06-06 at 13:22 -0700, Dan Williams wrote:
> On Wed, Jun 6, 2018 at 1:18 PM, Vishal Verma <vishal.l.verma@intel.com>
> wrote:
> > The ARS status command defines a 'flags' field that wasn't being
> > exposed
> > via an API yet. Since there is only one flag defined in ACPI 6.2, add a
> > helper for retrieving it (overflow flag).
> > 
> > Reported-by: Jacek Zloch <jacek.zloch@intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  ndctl/lib/ars.c        | 11 +++++++++++
> >  ndctl/lib/libndctl.sym |  1 +
> >  ndctl/libndctl.h       |  4 ++++
> >  3 files changed, 16 insertions(+)
> > 
> > v3: ensure we can only return 0, 1, or -error from this interface.
> > (Dan)
> > 
> > diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
> > index e04b51e..c78e3bf 100644
> > --- a/ndctl/lib/ars.c
> > +++ b/ndctl/lib/ars.c
> > @@ -269,6 +269,17 @@ NDCTL_EXPORT unsigned long long
> > ndctl_cmd_ars_get_record_len(
> >         return ars_stat->ars_status->records[rec_index].length;
> >  }
> > 
> > +NDCTL_EXPORT int ndctl_cmd_ars_stat_get_flag_overflow(
> > +               struct ndctl_cmd *ars_stat)
> > +{
> > +       struct ndctl_ctx *ctx =
> > ndctl_bus_get_ctx(cmd_to_bus(ars_stat));
> > +
> > +       if (!validate_ars_stat(ctx, ars_stat))
> > +               return -EINVAL;
> > +
> > +       return !!(ars_stat->ars_status->flags &
> > ND_ARS_STAT_FLAG_OVERFLOW);
> > +}
> > +
> >  NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
> >                 unsigned long long address, unsigned long long len,
> >                 struct ndctl_cmd *ars_cap)
> > diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> > index c1228e5..e939993 100644
> > --- a/ndctl/lib/libndctl.sym
> > +++ b/ndctl/lib/libndctl.sym
> > @@ -365,4 +365,5 @@ global:
> >         ndctl_cmd_ars_cap_get_clear_unit;
> >         ndctl_namespace_inject_error2;
> >         ndctl_namespace_uninject_error2;
> > +       ndctl_cmd_ars_stat_get_flag_overflow;
> >  } LIBNDCTL_15;
> > diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
> > index be997ac..3d141a6 100644
> > --- a/ndctl/libndctl.h
> > +++ b/ndctl/libndctl.h
> > @@ -187,6 +187,9 @@ int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
> >  int ndctl_dimm_disable(struct ndctl_dimm *dimm);
> >  int ndctl_dimm_enable(struct ndctl_dimm *dimm);
> > 
> > +/* ars_status flags */
> > +#define ND_ARS_STAT_FLAG_OVERFLOW (1 << 0)
> 
> Oh, sorry, one more thing. This should move to ndctl/lib/private.h,
> right?

Yes, good catch, thanks!

> 
> With that you can add:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
