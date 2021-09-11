Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7623FC3
	for <nvdimm@lists.linux.dev>; Sat, 11 Sep 2021 20:20:37 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id r2so5283152pgl.10
        for <nvdimm@lists.linux.dev>; Sat, 11 Sep 2021 13:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3FaEyqKwU/tn6sVBNy0AX0C2xIxgzp0F95buvIwKbKA=;
        b=1hhUmmwDIkypl4GhZ6RzoYuSaM37xk4136jy/jx88atWnKxYO4gZPCetc0kS8ARj1I
         VTLl3Kt248SATLvy547kI96k84CAmVm5A/ykuTavKlSCM4FX0VsOpAhQImgdz9+noiq2
         WJhnpfJwEBtCCMERXpKJW/H3BxnNoAJheG0xQdr3Zuk8GKfTg8kheniqaIOgfr93dIpn
         DCGwHQolRSf781H3lhURKt0wZiSewBOsbVMRSo0gQjsmJLz6VvYFq3fScuQ1VK6kpLII
         2Zg9lp+5wHyvs7hTaf+ED0XZCKnQ4d2u2Y4M/I3MJ0TomezJTvPvs0OBWcxR+ogAk/O9
         2+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3FaEyqKwU/tn6sVBNy0AX0C2xIxgzp0F95buvIwKbKA=;
        b=4Ko3ADbrm0vHlnNRnL8BRgiI4ndQBESrDs1tjrmxUHDaNFyv3f/R7iMnF39QnBTv5X
         C5IPD4C4M2+eC4/OpGmv0J89ifuOj5Y8aXDiJ2xWYrDlawjP31JP21gtK5s2+mVcIf4c
         JD30hHkcyskjrUIzCuHEP8QS1lBEn+V0I48ydZ5fVtx5nBoAjTmIKIdZ646qyM3IQnvl
         dCyQfFwYyEgK+R4gC30gIJDm741wStd0XyT/Kb2CRMlOCqMQYSPoVCtFOW1oA8KuBiDg
         qNP9ckkTIy9mT4hPWQni5hY9LOxK0dKxdeno6+zA6oszYlmavNmRZV1+KQTwyrZEegaJ
         uAiA==
X-Gm-Message-State: AOAM532HpwdB1kvQvPUZg91DBad92u4CamNDKxJIyn38zK14Vc9P6S7x
	396TS9cWhUbVZH0/dv5yF4xT9X3wV90tAldZXc2G8w==
X-Google-Smtp-Source: ABdhPJyzIvCN4Lzt/haHz6bSwAHLJODqQmz88yl5zobM1frdA2uG5bT5OOJzYjHD4lqU2W8ty5NdrnUmYJiwqU2MMlA=
X-Received: by 2002:a62:6d07:0:b0:40a:33cd:d3ea with SMTP id
 i7-20020a626d07000000b0040a33cdd3eamr3770495pfc.61.1631391636742; Sat, 11 Sep
 2021 13:20:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116440612.2460985.14600637290781306289.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210910113348.00007360@Huawei.com> <CAPcyv4jFYw6O2OrrDHb5qSCrNQ3jDH7Jmn4cCBCYsC9bW2yCQQ@mail.gmail.com>
 <20210911171500.zok2rsaaxhcaqu62@intel.com>
In-Reply-To: <20210911171500.zok2rsaaxhcaqu62@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 11 Sep 2021 13:20:25 -0700
Message-ID: <CAPcyv4gNPDwVRaFW3zwzwJzFhW+5mWMxyNn3PoTPaPexCEmrBA@mail.gmail.com>
Subject: Re: [PATCH v4 21/21] cxl/core: Split decoder setup into alloc + add
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-cxl@vger.kernel.org, 
	kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>, 
	Dan Carpenter <dan.carpenter@oracle.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Schofield, Alison" <alison.schofield@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, Sep 11, 2021 at 10:15 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-09-10 11:36:05, Dan Williams wrote:
> > On Fri, Sep 10, 2021 at 3:34 AM Jonathan Cameron
> > <Jonathan.Cameron@huawei.com> wrote:
> > >
> > > On Wed, 8 Sep 2021 22:13:26 -0700
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > > The kbuild robot reports:
> > > >
> > > >     drivers/cxl/core/bus.c:516:1: warning: stack frame size (1032) exceeds
> > > >     limit (1024) in function 'devm_cxl_add_decoder'
> > > >
> > > > It is also the case the devm_cxl_add_decoder() is unwieldy to use for
> > > > all the different decoder types. Fix the stack usage by splitting the
> > > > creation into alloc and add steps. This also allows for context
> > > > specific construction before adding.
> > > >
> > > > With the split the caller is responsible for registering a devm callback
> > > > to trigger device_unregister() for the decoder rather than it being
> > > > implicit in the decoder registration. I.e. the routine that calls alloc
> > > > is responsible for calling put_device() if the "add" operation fails.
> > > >
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > >
> > > A few minor things inline. This one was definitely a case where diff
> > > wasn't being helpful in how it chose to format things!
> > >
> > > I haven't taken the time to figure out if the device_lock() changes
> > > make complete sense as I don't understand the intent.
> > > I think they should be called out in the patch description as they
> > > seem a little non obvious.
> > >
> > > Jonathan
> > >
> > > > ---
> > > >  drivers/cxl/acpi.c      |   84 +++++++++++++++++++++++++----------
> > > >  drivers/cxl/core/bus.c  |  114 ++++++++++++++---------------------------------
> > > >  drivers/cxl/core/core.h |    5 --
> > > >  drivers/cxl/core/pmem.c |    7 ++-
> > > >  drivers/cxl/cxl.h       |   16 +++----
> > > >  5 files changed, 106 insertions(+), 120 deletions(-)
> > > >
> > > > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > > > index 9d881eacdae5..654a80547526 100644
> > > > --- a/drivers/cxl/acpi.c
> > > > +++ b/drivers/cxl/acpi.c
> > > > @@ -82,7 +82,6 @@ static void cxl_add_cfmws_decoders(struct device *dev,
> > > >       struct cxl_decoder *cxld;
> > > >       acpi_size len, cur = 0;
> > > >       void *cedt_subtable;
> > > > -     unsigned long flags;
> > > >       int rc;
> > > >
> > > >       len = acpi_cedt->length - sizeof(*acpi_cedt);
> > > > @@ -119,24 +118,36 @@ static void cxl_add_cfmws_decoders(struct device *dev,
> > > >               for (i = 0; i < CFMWS_INTERLEAVE_WAYS(cfmws); i++)
> > > >                       target_map[i] = cfmws->interleave_targets[i];
> > > >
> > > > -             flags = cfmws_to_decoder_flags(cfmws->restrictions);
> > > > -             cxld = devm_cxl_add_decoder(dev, root_port,
> > > > -                                         CFMWS_INTERLEAVE_WAYS(cfmws),
> > > > -                                         cfmws->base_hpa, cfmws->window_size,
> > > > -                                         CFMWS_INTERLEAVE_WAYS(cfmws),
> > > > -                                         CFMWS_INTERLEAVE_GRANULARITY(cfmws),
> > > > -                                         CXL_DECODER_EXPANDER,
> > > > -                                         flags, target_map);
> > > > -
> > > > -             if (IS_ERR(cxld)) {
> > > > +             cxld = cxl_decoder_alloc(root_port,
> > > > +                                      CFMWS_INTERLEAVE_WAYS(cfmws));
> > > > +             if (IS_ERR(cxld))
> > > > +                     goto next;
> > > > +
> > > > +             cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
> > > > +             cxld->target_type = CXL_DECODER_EXPANDER;
> > > > +             cxld->range = (struct range) {
> > > > +                     .start = cfmws->base_hpa,
> > > > +                     .end = cfmws->base_hpa + cfmws->window_size - 1,
> > > > +             };
> > > > +             cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
> > > > +             cxld->interleave_granularity =
> > > > +                     CFMWS_INTERLEAVE_GRANULARITY(cfmws);
> > > > +
> > > > +             rc = cxl_decoder_add(dev, cxld, target_map);
> > > > +             if (rc)
> > > > +                     put_device(&cxld->dev);
> > > > +             else
> > > > +                     rc = cxl_decoder_autoremove(dev, cxld);
> > > > +             if (rc) {
> > > >                       dev_err(dev, "Failed to add decoder for %#llx-%#llx\n",
> > > >                               cfmws->base_hpa, cfmws->base_hpa +
> > > >                               cfmws->window_size - 1);
> > > > -             } else {
> > > > -                     dev_dbg(dev, "add: %s range %#llx-%#llx\n",
> > > > -                             dev_name(&cxld->dev), cfmws->base_hpa,
> > > > -                              cfmws->base_hpa + cfmws->window_size - 1);
> > > > +                     goto next;
> > > >               }
> > > > +             dev_dbg(dev, "add: %s range %#llx-%#llx\n",
> > > > +                     dev_name(&cxld->dev), cfmws->base_hpa,
> > > > +                     cfmws->base_hpa + cfmws->window_size - 1);
> > > > +next:
> > > >               cur += c->length;
> > > >       }
> > > >  }
> > > > @@ -268,6 +279,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > > >       struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> > > >       struct acpi_pci_root *pci_root;
> > > >       struct cxl_walk_context ctx;
> > > > +     int single_port_map[1], rc;
> > > >       struct cxl_decoder *cxld;
> > > >       struct cxl_dport *dport;
> > > >       struct cxl_port *port;
> > > > @@ -303,22 +315,46 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > > >               return -ENODEV;
> > > >       if (ctx.error)
> > > >               return ctx.error;
> > > > +     if (ctx.count > 1)
> > > > +             return 0;
> > > >
> > > >       /* TODO: Scan CHBCR for HDM Decoder resources */
> > > >
> > > >       /*
> > > > -      * In the single-port host-bridge case there are no HDM decoders
> > > > -      * in the CHBCR and a 1:1 passthrough decode is implied.
> > > > +      * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability
> > > > +      * Structure) single ported host-bridges need not publish a decoder
> > > > +      * capability when a passthrough decode can be assumed, i.e. all
> > > > +      * transactions that the uport sees are claimed and passed to the single
> > > > +      * dport. Default the range a 0-base 0-length until the first CXL region
> > > > +      * is activated.
> > > >        */
> > > > -     if (ctx.count == 1) {
> > > > -             cxld = devm_cxl_add_passthrough_decoder(host, port);
> > > > -             if (IS_ERR(cxld))
> > > > -                     return PTR_ERR(cxld);
> > > > +     cxld = cxl_decoder_alloc(port, 1);
> > > > +     if (IS_ERR(cxld))
> > > > +             return PTR_ERR(cxld);
> > > > +
> > > > +     cxld->interleave_ways = 1;
> > > > +     cxld->interleave_granularity = PAGE_SIZE;
> > > > +     cxld->target_type = CXL_DECODER_EXPANDER;
> > > > +     cxld->range = (struct range) {
> > > > +             .start = 0,
> > > > +             .end = -1,
> > > > +     };
> > > >
> > > > -             dev_dbg(host, "add: %s\n", dev_name(&cxld->dev));
> > > > -     }
> > >
> > > This was previously done without taking the device lock... (see below)
> > >
> > > > +     device_lock(&port->dev);
> > > > +     dport = list_first_entry(&port->dports, typeof(*dport), list);
> > > > +     device_unlock(&port->dev);
> > > >
> > > > -     return 0;
> > > > +     single_port_map[0] = dport->port_id;
> > > > +
> > > > +     rc = cxl_decoder_add(host, cxld, single_port_map);
> > > > +     if (rc)
> > > > +             put_device(&cxld->dev);
> > > > +     else
> > > > +             rc = cxl_decoder_autoremove(host, cxld);
> > > > +
> > > > +     if (rc == 0)
> > > > +             dev_dbg(host, "add: %s\n", dev_name(&cxld->dev));
> > > > +     return rc;
> > > >  }
> > > >
> > > >  static int add_host_bridge_dport(struct device *match, void *arg)
> > > > diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
> > > > index 176bede30c55..be787685b13e 100644
> > > > --- a/drivers/cxl/core/bus.c
> > > > +++ b/drivers/cxl/core/bus.c
> > > > @@ -455,16 +455,18 @@ EXPORT_SYMBOL_GPL(cxl_add_dport);
> > > >
> > > >  static int decoder_populate_targets(struct device *host,
> > > >                                   struct cxl_decoder *cxld,
> > > > -                                 struct cxl_port *port, int *target_map,
> > > > -                                 int nr_targets)
> > > > +                                 struct cxl_port *port, int *target_map)
> > > >  {
> > > >       int rc = 0, i;
> > > >
> > > > +     if (list_empty(&port->dports))
> > > > +             return -EINVAL;
> > > > +
> > >
> > > The code before this patch did this under the device_lock() Perhaps call
> > > out the fact there is no need to do that if we don't need to?
> >
> > Nope, bug, good catch.
> >
>
> While you're changing this might I request you make this change so I can drop my
> patch:
>
> commit fe46c7a3e30129c649e17a4c555699e816cf04e7
> Author: Ben Widawsky <ben.widawsky@intel.com>
> Date:   16 hours ago
>
>     core/bus: Don't error for targetless decoders
>
>     Decoders may not have any targets, endpoints are the best example of
>     this. In order to prevent having to special case, it's easiest to just
>     not return an error when no target map is specified as those endpoints
>     also won't have dports.
>
>     Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
>
> diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
> index c13b6c4d4135..b98b3e343a3d 100644
> --- a/drivers/cxl/core/bus.c
> +++ b/drivers/cxl/core/bus.c
> @@ -547,12 +547,12 @@ static int decoder_populate_targets(struct device *host,
>  {
>         int rc = 0, i;
>
> -       if (list_empty(&port->dports))
> -               return -EINVAL;
> -
>         if (!target_map)
>                 return 0;
>
> +       if (list_empty(&port->dports))
> +               return -EINVAL;
> +
>         device_lock(&port->dev);
>         for (i = 0; i < cxld->nr_targets; i++) {
>                 struct cxl_dport *dport = find_dport(port, target_map[i]);
>

Yes, I will fold that fix in when I address the locking around the
list_empty check.
