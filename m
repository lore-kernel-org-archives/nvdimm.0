Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5014A3FC1
	for <nvdimm@lists.linux.dev>; Mon,  6 Sep 2021 08:52:26 +0000 (UTC)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H32DG1y2rz67drY;
	Mon,  6 Sep 2021 16:50:38 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 6 Sep 2021 10:52:23 +0200
Received: from localhost (10.52.120.86) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 6 Sep 2021
 09:52:22 +0100
Date: Mon, 6 Sep 2021 09:52:23 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>, Vishal
 L Verma <vishal.l.verma@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny,
 Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH v3 25/28] cxl/bus: Populate the target list at decoder
 create
Message-ID: <20210906095223.000009e5@Huawei.com>
In-Reply-To: <CAPcyv4gKd6885ekJTbn_Au9khJSQhDpfdZp2OVcTBO=+=afKBA@mail.gmail.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982125942.1124374.13787583357587804107.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20210903135938.00004b6e@Huawei.com>
	<CAPcyv4gKd6885ekJTbn_Au9khJSQhDpfdZp2OVcTBO=+=afKBA@mail.gmail.com>
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
X-Originating-IP: [10.52.120.86]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Fri, 3 Sep 2021 15:43:25 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Fri, Sep 3, 2021 at 5:59 AM Jonathan Cameron
> <Jonathan.Cameron@huawei.com> wrote:
> >
> > On Tue, 24 Aug 2021 09:07:39 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >  
> > > As found by cxl_test, the implementation populated the target_list for
> > > the single dport exceptional case, it missed populating the target_list
> > > for the typical multi-dport case.  
> >
> > Description makes this sound like a fix, rather than what I think it is
> > which is implementing a new feature...  
> 
> It is finishing a feature where the unfinished state is broken. It
> should never be the case that target_list_show() returns nothing.
> 
> [..]
> > > diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
> > > index 8073354ba232..9a755a37eadf 100644
> > > --- a/drivers/cxl/core/bus.c
> > > +++ b/drivers/cxl/core/bus.c  
> [..]
> > > @@ -493,10 +494,19 @@ cxl_decoder_alloc(struct cxl_port *port, int nr_targets, resource_size_t base,
> > >               .target_type = type,
> > >       };
> > >
> > > -     /* handle implied target_list */
> > > -     if (interleave_ways == 1)
> > > -             cxld->target[0] =
> > > -                     list_first_entry(&port->dports, struct cxl_dport, list);
> > > +     device_lock(&port->dev);
> > > +     for (i = 0; target_map && i < nr_targets; i++) {  
> >
> > Perhaps move target map check much earlier rather than putting it
> > int he loop condition?  I don't think the loop is modifying it...  
> 
> The loop is not modifying target_map, but target_map is allowed to be
> NULL. I was trying to avoid a non-error goto, but a better way to
> solve that would be to make the loop a helper function taken under the
> lock.
Ah. Understood.  I was not appreciating that check need to be under
the device_lock(). Helper function would indeed make this clean - good plan.

Thanks,

Jonathan
