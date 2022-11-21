Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1991EC0
	for <nvdimm@lists.linux.dev>; Mon, 21 Nov 2022 10:57:20 +0000 (UTC)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NG45r5ypVz686xt;
	Mon, 21 Nov 2022 18:54:40 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 11:57:12 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 10:57:11 +0000
Date: Mon, 21 Nov 2022 10:57:11 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 4/5] cxl/list: add --media-errors option to cxl
 list
Message-ID: <20221121105711.0000770c@Huawei.com>
In-Reply-To: <Y3bG884BuHoGnbuE@aschofie-mobl2>
References: <cover.1668133294.git.alison.schofield@intel.com>
	<762edeab529125d3048cf13721360b1a07260531.1668133294.git.alison.schofield@intel.com>
	<20221116130345.000007a8@Huawei.com>
	<Y3bG884BuHoGnbuE@aschofie-mobl2>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 17 Nov 2022 15:42:43 -0800
Alison Schofield <alison.schofield@intel.com> wrote:

> On Wed, Nov 16, 2022 at 01:03:45PM +0000, Jonathan Cameron wrote:
> > On Thu, 10 Nov 2022 19:20:07 -0800
> > alison.schofield@intel.com wrote:
> >   
> > > From: Alison Schofield <alison.schofield@intel.com>
> > > 
> > > The --media-errors option to 'cxl list' retrieves poison lists
> > > from memory devices (supporting the capability) and displays
> > > the returned media-error records in the cxl list json. This
> > > option can apply to memdevs or regions.
> > > 
> > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > ---
> > >  Documentation/cxl/cxl-list.txt | 64 ++++++++++++++++++++++++++++++++++
> > >  cxl/filter.c                   |  2 ++
> > >  cxl/filter.h                   |  1 +
> > >  cxl/list.c                     |  2 ++
> > >  4 files changed, 69 insertions(+)
> > > 
> > > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > > index 14a2b4bb5c2a..24a0cf97cef2 100644
> > > --- a/Documentation/cxl/cxl-list.txt
> > > +++ b/Documentation/cxl/cxl-list.txt
> > > @@ -344,6 +344,70 @@ OPTIONS
> > >  --region::
> > >  	Specify CXL region device name(s), or device id(s), to filter the listing.
> > >  
> > > +-a::
> > > +--media-errors::
> > > +	Include media-error information. The poison list is retrieved
> > > +	from the device(s) and media error records are added to the
> > > +	listing. This option applies to memdevs and regions where
> > > +	devices support the poison list capability.  
> > 
> > I'm not sure media errors is a good name.  The poison doesn't have to originate
> > in the device.  Given we are logging poison with "external" as the source
> > those definitely don't come from the device and may have nothing to do
> > with 'media' as such.
> > 
> > Why not just call it poison?
> >   
> --media-errors probably originated from ndctl tool which used
> that same option name, but it fits in with the CXL Spec language.
> 
> The CXL Spec calls the records returned from the 'Get Poison List'
> command Media Error Records. It refers to poison as media errors.
> So, here, in a command that lists things - the thing(s) being listed
> is(are) 'media error record(s)'. 
> 
> I see what you're saying about 'External' source. Does that mean
> an 'External' source caused an actual media error?

Hmm. I suspect this all evolved.  An External source need not have
anything to do with media (could be corruption in some random cache
or on interconnect or even that a link collapsed potentially).

Ah well, I'm fine with any naming you prefer.  No idea if the NVDIMM
equivalent has a the same issue with externally generated poison.

> 
> So, that 'Why not poison?' answer. I'm easily swayed either way.
> Would you suggest:
> > > +
> > > +----
> > > +# cxl list -m mem11 --media-errors  
> 
> cxl list -m mem1 --poison
> 
> > > +    "media_errors":{
> > > +      "nr_media_errors":1,
> > > +      "media_error_records":[  
> 
> and rename the fields above:
> 	"poison_errors"
> 	"nr_poison_errors"
> 	"poison_error_records"
> 
> 
That works for me, but if it's going to confuse people familiar with
other similar cases, then I don't mind the original naming that much.

Jonathan


