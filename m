Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2A3173
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 20:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641587238; x=1673123238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RUMOTc/ljJwy9J7MTHA84XDFs6eBGfTcIJ0nTk5hs3s=;
  b=RX/XdRD3hf+0qtmUMsDat5Nk10b3EaHvXGQpIKovrG7I4p8oszuKuagk
   oNRQiwpZKnXf53MbVB0ztdw2tSxCTGqdJ/hQJKfZhnbeqrs8wqTJtEPxo
   eu+AkZkJ5CRUvj4wwmpJUY24BKnS1G0OYCzLsm/7Ml991gAoCFs5OwM9d
   4aw+sL303hBPtKjZV8uqjg1E9MjaP72u5AMKoanymzEK/yh1P5qjIupaR
   m+/ecMPl+p+EXfl/0Vu6VqIvwvkcNB4mkugMyL2+btg18n+bw5h+XXMn+
   mhzMXskOLBTtntCwJviCWhY+53wTepkuNzMucAXPwRd7Al9mVfBCMxEbA
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="241752085"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="241752085"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:27:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668876217"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:27:17 -0800
Date: Fri, 7 Jan 2022 12:32:27 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 4/7] cxl: add memdev partition information to
 cxl-list
Message-ID: <20220107203227.GE803588@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <78ff68a062f23cef48fb6ea1f91bcd7e11e4fa6e.1641233076.git.alison.schofield@intel.com>
 <CAPcyv4iE-tVTbU146U+x81SEPMROimETNgxMab68A9YTqOPLqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iE-tVTbU146U+x81SEPMROimETNgxMab68A9YTqOPLqw@mail.gmail.com>

On Thu, Jan 06, 2022 at 01:51:47PM -0800, Dan Williams wrote:
> On Mon, Jan 3, 2022 at 12:11 PM <alison.schofield@intel.com> wrote:
> >
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > Add information useful for managing memdev partitions to cxl-list
> > output. Include all of the fields from GET_PARTITION_INFO and the
> > partitioning related fields from the IDENTIFY mailbox command.
> >
> >     "partition":{
> 
> Perhaps call it "parition_info"?
> 
Got it!

> >       "active_volatile_capacity":273535729664,
> >       "active_persistent_capacity":0,
> >       "next_volatile_capacity":0,
> >       "next_persistent_capacity":0,
> >       "total_capacity":273535729664,
> >       "volatile_only_capacity":0,
> >       "persistent_only_capacity":0,
> >       "partition_alignment":268435456
> >     }
> >
> >    }
> >  ]
> >  ----
> > +-P::
> > +--partition::
> > +       Include partition information in the memdev listing. Example listing:
> 
> How about -I/--partition for partition "Info". I had earmarked -P for
> including "Port" object in the listing.

Sure. -I it is!

> 
> Other than that, looks good:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
snip
