Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E84A464
	for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 23:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668728565; x=1700264565;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=adfbCIyChUyH/XaMndJVZM8Fc7Ge6yLAY9UqjzkbLPA=;
  b=Ocw6GGWLXmsJpyohkluZsRk8xrXSyrbKq4RTCZ5MP+roqUPvK6iRNMw2
   wp3nwG1OXfvmG2ERB4yRc5LW7ZsDORlRoKmv/caAsYuY2VwXJYR8HtA4y
   /lAVhV7En6xpc77BfxfBbCXgcRT95dZGnNjXpMqbqOjZoTynSs17DO3/S
   /20Jm+Zdlw6Lm8ThoHPz9gukNWYpzsZBmHjZsUD/woitiacnBFU7lOPTS
   Oh9AniWAonrEypFsz7Gzxy1PDUDx2CO96z+eUm4uU6Q6syXnO1tZ+NmIV
   byeByxm/fNOL99eeA7ajs9H51fqpnSRBUN2ImZbZMGfI1O41J+lBi2PYv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="300541224"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="300541224"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 15:42:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="764955036"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="764955036"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.84.12])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 15:42:44 -0800
Date: Thu, 17 Nov 2022 15:42:43 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 4/5] cxl/list: add --media-errors option to cxl list
Message-ID: <Y3bG884BuHoGnbuE@aschofie-mobl2>
References: <cover.1668133294.git.alison.schofield@intel.com>
 <762edeab529125d3048cf13721360b1a07260531.1668133294.git.alison.schofield@intel.com>
 <20221116130345.000007a8@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116130345.000007a8@Huawei.com>

On Wed, Nov 16, 2022 at 01:03:45PM +0000, Jonathan Cameron wrote:
> On Thu, 10 Nov 2022 19:20:07 -0800
> alison.schofield@intel.com wrote:
> 
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > The --media-errors option to 'cxl list' retrieves poison lists
> > from memory devices (supporting the capability) and displays
> > the returned media-error records in the cxl list json. This
> > option can apply to memdevs or regions.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  Documentation/cxl/cxl-list.txt | 64 ++++++++++++++++++++++++++++++++++
> >  cxl/filter.c                   |  2 ++
> >  cxl/filter.h                   |  1 +
> >  cxl/list.c                     |  2 ++
> >  4 files changed, 69 insertions(+)
> > 
> > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > index 14a2b4bb5c2a..24a0cf97cef2 100644
> > --- a/Documentation/cxl/cxl-list.txt
> > +++ b/Documentation/cxl/cxl-list.txt
> > @@ -344,6 +344,70 @@ OPTIONS
> >  --region::
> >  	Specify CXL region device name(s), or device id(s), to filter the listing.
> >  
> > +-a::
> > +--media-errors::
> > +	Include media-error information. The poison list is retrieved
> > +	from the device(s) and media error records are added to the
> > +	listing. This option applies to memdevs and regions where
> > +	devices support the poison list capability.
> 
> I'm not sure media errors is a good name.  The poison doesn't have to originate
> in the device.  Given we are logging poison with "external" as the source
> those definitely don't come from the device and may have nothing to do
> with 'media' as such.
> 
> Why not just call it poison?
> 
--media-errors probably originated from ndctl tool which used
that same option name, but it fits in with the CXL Spec language.

The CXL Spec calls the records returned from the 'Get Poison List'
command Media Error Records. It refers to poison as media errors.
So, here, in a command that lists things - the thing(s) being listed
is(are) 'media error record(s)'. 

I see what you're saying about 'External' source. Does that mean
an 'External' source caused an actual media error?

So, that 'Why not poison?' answer. I'm easily swayed either way.
Would you suggest:
> > +
> > +----
> > +# cxl list -m mem11 --media-errors

cxl list -m mem1 --poison

> > +    "media_errors":{
> > +      "nr_media_errors":1,
> > +      "media_error_records":[

and rename the fields above:
	"poison_errors"
	"nr_poison_errors"
	"poison_error_records"


