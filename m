Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3814272
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 18:01:42 +0000 (UTC)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H1QYD262kz67Ny5;
	Sat,  4 Sep 2021 01:59:44 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 3 Sep 2021 20:01:33 +0200
Received: from localhost (10.52.121.127) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Fri, 3 Sep 2021
 19:01:32 +0100
Date: Fri, 3 Sep 2021 19:01:33 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, kernel test robot <lkp@intel.com>, "Vishal L
 Verma" <vishal.l.verma@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny,
 Ira" <ira.weiny@intel.com>, Ben Widawsky <ben.widawsky@intel.com>
Subject: Re: [PATCH v3 28/28] cxl/core: Split decoder setup into alloc + add
Message-ID: <20210903190133.000003e2@Huawei.com>
In-Reply-To: <CAPcyv4iaff7_YH1OG-yn4vnDbh-QF1DgLdGr8E4LT1bBBvX-yQ@mail.gmail.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982127644.1124374.2704629829686138331.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20210903143345.00006c60@Huawei.com>
	<CAPcyv4iaff7_YH1OG-yn4vnDbh-QF1DgLdGr8E4LT1bBBvX-yQ@mail.gmail.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.121.127]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Fri, 3 Sep 2021 09:26:09 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Fri, Sep 3, 2021 at 6:34 AM Jonathan Cameron
> <Jonathan.Cameron@huawei.com> wrote:
> >
> > On Tue, 24 Aug 2021 09:07:56 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >  
> > > The kbuild robot reports:
> > >
> > >     drivers/cxl/core/bus.c:516:1: warning: stack frame size (1032) exceeds
> > >     limit (1024) in function 'devm_cxl_add_decoder'
> > >
> > > It is also the case the devm_cxl_add_decoder() is unwieldy to use for
> > > all the different decoder types. Fix the stack usage by splitting the
> > > creation into alloc and add steps. This also allows for context
> > > specific construction before adding.
> > >
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>  
> >
> > Trivial comment inline - otherwise looks like a nice improvement.
> >
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>  
> 
> >  
> > > ---
> > >  drivers/cxl/acpi.c     |   74 ++++++++++++++++++++---------
> > >  drivers/cxl/core/bus.c |  124 +++++++++++++++---------------------------------
> > >  drivers/cxl/cxl.h      |   15 ++----
> > >  3 files changed, 95 insertions(+), 118 deletions(-)
> > >  
> >  
> > > @@ -268,6 +275,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > >       struct cxl_port *port;
> > >       struct cxl_dport *dport;
> > >       struct cxl_decoder *cxld;
> > > +     int single_port_map[1], rc;
> > >       struct cxl_walk_context ctx;
> > >       struct acpi_pci_root *pci_root;
> > >       struct cxl_port *root_port = arg;
> > > @@ -301,22 +309,42 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > >               return -ENODEV;
> > >       if (ctx.error)
> > >               return ctx.error;
> > > +     if (ctx.count > 1)
> > > +             return 0;
> > >
> > >       /* TODO: Scan CHBCR for HDM Decoder resources */
> > >
> > >       /*
> > > -      * In the single-port host-bridge case there are no HDM decoders
> > > -      * in the CHBCR and a 1:1 passthrough decode is implied.
> > > +      * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability
> > > +      * Structure) single ported host-bridges need not publish a decoder
> > > +      * capability when a passthrough decode can be assumed, i.e. all
> > > +      * transactions that the uport sees are claimed and passed to the single
> > > +      * dport. Default the range a 0-base 0-length until the first CXL region
> > > +      * is activated.
> > >        */  
> >
> > Is comment in right place or should it be up with the ctx.count > 1  
> 
> This comment is specifically about the implicit decoder, right beneath
> the comment, that is registered in the ctx.count == 1 case. Perhaps
> you were reacting to the spec reference which is generic, but later
> sentences make it clear this comment is about an exception noted in
> that spec reference?

More that the conditional is above that leads to us getting here. 
Probably thrown off by Diff having added the new block that follows this
after the removed block rather than before it.

I'm fine with how you have it here.

J
