Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1D717F8;
	Thu, 12 May 2022 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652373206; x=1683909206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bEJzRn7q1/rlB9i5X2tc/bhogXPTD7EemZxiqRgZfMg=;
  b=elETzsyYo/jb5dv4eHXLMvRSreSveRc1G6H7MHaw8TG5Jh2mVaeeFufO
   R+3BxjxPRFPu1NbI5/7ujF2tt4NeZ6MZyMKBFx+N92BAO0YvDxL36mUCc
   utynYVniAJiMRM6AohR8g38NWUpf3BV44uR1wju/0/7XsUcsVR+GJtkrK
   G6G4yfrkugithVgfcTfWJW3mTy2flEJth7U++DI+I6RRaWXKXAyY2Hnig
   5RUOFTea9On2Of9Q6J0Si4/zmizTKDe+Cgojx8o2ApP89oXsPf/pZQZef
   v6qfnjHNwgHxAnhA0FjKbuJ8yVyK18+4ho2OGqb+Z1wVGE0PSY5LY0qL0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="257598263"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="257598263"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 09:09:38 -0700
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="594732263"
Received: from wcogara-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.129.107])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 09:09:37 -0700
Date: Thu, 12 May 2022 09:09:31 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 03/15] Revert "cxl/core: Convert decoder range to
 resource"
Message-ID: <20220512160931.2p2eo2vlzpbyxm36@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-4-ben.widawsky@intel.com>
 <CAPcyv4iwNaJTi6DCVrVDLuwY2Cc99u_2BWokfavh3TqVqEa6UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iwNaJTi6DCVrVDLuwY2Cc99u_2BWokfavh3TqVqEa6UA@mail.gmail.com>

On 22-04-13 14:43:48, Dan Williams wrote:
> On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> >
> > This reverts commit 608135db1b790170d22848815c4671407af74e37. All
> 
> Did checkpatch not complain about this being in "commit
> <12-character-commit-id> <commit summary format>"? However, I'd rather
> just drop the revert language and say:
> 
> Change root decoders to reuse the existing ->range field to track the
> decoder's programmed HPA range. The infrastructure to track the
> allocations out of the root decoder range is still a work-in-progress,
> but in the meantime it simplifies the code to always represent the
> current decoder range setting in the ->range field regardless of
> decoder type.
> 
> > decoders do have a host physical address space and the revert allows us
> > to keep that uniformity. Decoder disambiguation will allow for decoder
> > type-specific members which is needed, but will be handled separately.
> >
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> >
> > ---
> > The explanation for why it is impossible to make CFMWS ranges be
> > iomem_resources is explain in a later patch.
> 
> This change stands alone / is independent of any iomem_resource concerns, right?
> 

I think I need to revisit this per the discussion at LSFMM. Ideally a CFMWS
resource would just be insert_resource()'d, but that won't work. I'm going to
attempt what we discussed and this patch will likely go away.

> > ---
> >  drivers/cxl/acpi.c      | 17 ++++++++++-------
> >  drivers/cxl/core/hdm.c  |  2 +-
> >  drivers/cxl/core/port.c | 28 ++++++----------------------
> >  drivers/cxl/cxl.h       |  8 ++------
> >  4 files changed, 19 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > index d15a6aec0331..9b69955b90cb 100644
> > --- a/drivers/cxl/acpi.c
> > +++ b/drivers/cxl/acpi.c
> > @@ -108,8 +108,10 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
> >
> >         cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
> >         cxld->target_type = CXL_DECODER_EXPANDER;
> > -       cxld->platform_res = (struct resource)DEFINE_RES_MEM(cfmws->base_hpa,
> > -                                                            cfmws->window_size);
> > +       cxld->range = (struct range){
> > +               .start = cfmws->base_hpa,
> > +               .end = cfmws->base_hpa + cfmws->window_size - 1,
> > +       };
> >         cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
> >         cxld->interleave_granularity = CFMWS_INTERLEAVE_GRANULARITY(cfmws);
> >
> > @@ -119,13 +121,14 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
> >         else
> >                 rc = cxl_decoder_autoremove(dev, cxld);
> >         if (rc) {
> > -               dev_err(dev, "Failed to add decoder for %pr\n",
> > -                       &cxld->platform_res);
> > +               dev_err(dev, "Failed to add decoder for %#llx-%#llx\n",
> > +                       cfmws->base_hpa,
> > +                       cfmws->base_hpa + cfmws->window_size - 1);
> >                 return 0;
> >         }
> > -       dev_dbg(dev, "add: %s node: %d range %pr\n", dev_name(&cxld->dev),
> > -               phys_to_target_node(cxld->platform_res.start),
> > -               &cxld->platform_res);
> > +       dev_dbg(dev, "add: %s node: %d range %#llx-%#llx\n",
> > +               dev_name(&cxld->dev), phys_to_target_node(cxld->range.start),
> > +               cfmws->base_hpa, cfmws->base_hpa + cfmws->window_size - 1);
> >
> >         return 0;
> >  }
> > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > index c3c021b54079..3055e246aab9 100644
> > --- a/drivers/cxl/core/hdm.c
> > +++ b/drivers/cxl/core/hdm.c
> > @@ -172,7 +172,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
> >                 return -ENXIO;
> >         }
> >
> > -       cxld->decoder_range = (struct range) {
> > +       cxld->range = (struct range) {
> >                 .start = base,
> >                 .end = base + size - 1,
> >         };
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index 74c8e47bf915..86f451ecb7ed 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -73,14 +73,8 @@ static ssize_t start_show(struct device *dev, struct device_attribute *attr,
> >                           char *buf)
> >  {
> >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > -       u64 start;
> >
> > -       if (is_root_decoder(dev))
> > -               start = cxld->platform_res.start;
> > -       else
> > -               start = cxld->decoder_range.start;
> > -
> > -       return sysfs_emit(buf, "%#llx\n", start);
> > +       return sysfs_emit(buf, "%#llx\n", cxld->range.start);
> >  }
> >  static DEVICE_ATTR_ADMIN_RO(start);
> >
> > @@ -88,14 +82,8 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
> >                         char *buf)
> >  {
> >         struct cxl_decoder *cxld = to_cxl_decoder(dev);
> > -       u64 size;
> >
> > -       if (is_root_decoder(dev))
> > -               size = resource_size(&cxld->platform_res);
> > -       else
> > -               size = range_len(&cxld->decoder_range);
> > -
> > -       return sysfs_emit(buf, "%#llx\n", size);
> > +       return sysfs_emit(buf, "%#llx\n", range_len(&cxld->range));
> >  }
> >  static DEVICE_ATTR_RO(size);
> >
> > @@ -1228,7 +1216,10 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
> >         cxld->interleave_ways = 1;
> >         cxld->interleave_granularity = PAGE_SIZE;
> >         cxld->target_type = CXL_DECODER_EXPANDER;
> > -       cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
> > +       cxld->range = (struct range) {
> > +               .start = 0,
> > +               .end = -1,
> > +       };
> >
> >         return cxld;
> >  err:
> > @@ -1342,13 +1333,6 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
> >         if (rc)
> >                 return rc;
> >
> > -       /*
> > -        * Platform decoder resources should show up with a reasonable name. All
> > -        * other resources are just sub ranges within the main decoder resource.
> > -        */
> > -       if (is_root_decoder(dev))
> > -               cxld->platform_res.name = dev_name(dev);
> > -
> >         return device_add(dev);
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_decoder_add_locked, CXL);
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 5102491e8d13..6517d5cdf5ee 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -197,8 +197,7 @@ enum cxl_decoder_type {
> >   * struct cxl_decoder - CXL address range decode configuration
> >   * @dev: this decoder's device
> >   * @id: kernel device name id
> > - * @platform_res: address space resources considered by root decoder
> > - * @decoder_range: address space resources considered by midlevel decoder
> > + * @range: address range considered by this decoder
> >   * @interleave_ways: number of cxl_dports in this decode
> >   * @interleave_granularity: data stride per dport
> >   * @target_type: accelerator vs expander (type2 vs type3) selector
> > @@ -210,10 +209,7 @@ enum cxl_decoder_type {
> >  struct cxl_decoder {
> >         struct device dev;
> >         int id;
> > -       union {
> > -               struct resource platform_res;
> > -               struct range decoder_range;
> > -       };
> > +       struct range range;
> >         int interleave_ways;
> >         int interleave_granularity;
> >         enum cxl_decoder_type target_type;
> > --
> > 2.35.1
> >
