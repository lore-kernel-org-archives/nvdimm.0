Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FAE2F26
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 10:00:04 +0000 (UTC)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JqDYf1hdPz67x4b;
	Thu,  3 Feb 2022 17:55:18 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Feb 2022 11:00:01 +0100
Received: from localhost (10.47.78.15) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 3 Feb
 2022 10:00:00 +0000
Date: Thu, 3 Feb 2022 09:59:59 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>, "Ben
 Widawsky" <ben.widawsky@intel.com>, Linux PCI <linux-pci@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 33/40] cxl/mem: Add the cxl_mem driver
Message-ID: <20220203095959.000078f1@Huawei.com>
In-Reply-To: <CAPcyv4jBs4DXGUE0rtyhp2WG2pU45zBv1zGJuLjMfyAKGmfVyw@mail.gmail.com>
References: <164298429450.3018233.13269591903486669825.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164316691403.3437657.5374419213236572727.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20220201124506.000031e2@Huawei.com>
	<CAPcyv4jBs4DXGUE0rtyhp2WG2pU45zBv1zGJuLjMfyAKGmfVyw@mail.gmail.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.78.15]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

Hi Dan,

> > > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > > index b71d40b68ccd..0bbe394f2f26 100644
> > > --- a/drivers/cxl/cxl.h
> > > +++ b/drivers/cxl/cxl.h
> > > @@ -323,6 +323,8 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
> > >  struct cxl_port *find_cxl_root(struct device *dev);
> > >  int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
> > >  int cxl_bus_rescan(void);
> > > +struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd);  
> >
> > Should be in previous patch where the function is defined.  
> 
> Not really, because this patch is the first time it is used outside of
> core/port.c. I would say convert the previous patch to make it static,
> and move the export into this patch, but I'm also tempted to leave
> well enough alone here unless there some additional reason to respin
> patch 32.

I hadn't read this when I sent reply to previous patch v4.  Up to you on
whether you tidy up or not.  Though I'm fairly sure you'll get
a missing static warning if you build previous patch without a header definition.
Agreed adding static then removing it again would be an option, but
meh, too much noise...  The one going the other way (defining a function
before it exists) is probably more important to fix.

