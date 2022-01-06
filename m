Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB742C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 21:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641504631; x=1673040631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rl3K8/5aCq/nfNXdtWTKkM3vpiduR9F9Zk/QukE0+t8=;
  b=kg6MPnnpS4WyMDAXWXCTzQ/IWoz2CGZqkLlzp4LqWyGMZo1j+w4FIoYh
   hteg+CIzPkEPxFPUk0ajyY1Qvco/tPiYQBr4ak7dY1M5RDw+cychfM7t/
   ow6JfC4TROMvhX0u2Lw8KS1YYFxfVuoVqU6zf3net8/rq6ELNtu+9QbmX
   a2iPA7+G3OPVMZbQr+LsGXJfRacgLrgln9ocO98mEGY4cdh6rND6umqXi
   s6k3i8E7R7PGdMgOW87srb5uc5j6zDC0ydhNWd703zX0X5I7/1BW2av9o
   PtWYRdmaJCfvmyzuPBA0usQ7boIP8aYkUGDTymq5+7g8cV3DMKMCK+yos
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="329085532"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="329085532"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:30:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="611971386"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:30:08 -0800
Date: Thu, 6 Jan 2022 13:30:08 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 1/7] libcxl: add GET_PARTITION_INFO mailbox command
 and accessors
Message-ID: <20220106213008.GI178135@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
References: <cover.1641233076.git.alison.schofield@intel.com>
 <9d3c55cbd36efb6eabec075cc8596a6382f1f145.1641233076.git.alison.schofield@intel.com>
 <20220106201907.GA178135@iweiny-DESK2.sc.intel.com>
 <CAPcyv4h4_V+fugcbU0f_+ZJ9sALdDqAtgovoVhpjzd6cYiBHgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h4_V+fugcbU0f_+ZJ9sALdDqAtgovoVhpjzd6cYiBHgA@mail.gmail.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Thu, Jan 06, 2022 at 01:21:45PM -0800, Dan Williams wrote:
> On Thu, Jan 6, 2022 at 12:19 PM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > On Mon, Jan 03, 2022 at 12:16:12PM -0800, Schofield, Alison wrote:
> > > From: Alison Schofield <alison.schofield@intel.com>
> > >
> > > diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> > > index 89d35ba..7cf9061 100644
> > > --- a/cxl/libcxl.h
> > > +++ b/cxl/libcxl.h
> > > @@ -109,6 +109,11 @@ ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd, void *buf,
> > >               unsigned int length);
> > >  struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
> > >               void *buf, unsigned int offset, unsigned int length);
> > > +struct cxl_cmd *cxl_cmd_new_get_partition_info(struct cxl_memdev *memdev);
> >
> > why 'new'?  Why not:
> >
> > cxl_cmd_get_partition_info()
> >
> > ?
> 
> The "new" is the naming convention inherited from ndctl indicating the
> allocation of a new command object. The motivation is to have a verb /
> action in all of the APIs.

Yea my bad.  I realized that later on.  Sorry.

> 
> >
> > > +unsigned long long cxl_cmd_get_partition_info_get_active_volatile_cap(struct cxl_cmd *cmd);
> > > +unsigned long long cxl_cmd_get_partition_info_get_active_persistent_cap(struct cxl_cmd *cmd);
> > > +unsigned long long cxl_cmd_get_partition_info_get_next_volatile_cap(struct cxl_cmd *cmd);
> > > +unsigned long long cxl_cmd_get_partition_info_get_next_persistent_cap(struct cxl_cmd *cmd);
> >
> > These are pretty long function names.  :-/
> 
> If you think those are long, how about:
> 
> cxl_cmd_health_info_get_media_powerloss_persistence_loss
> 
> The motivation here is to keep data structure layouts hidden behind
> APIs to ease the maintenance of binary compatibility from one library
> release and specification release to the next. The side effect though
> is some long function names in places.

Sure.  I'm ok with that.

Ira

> 
> > I also wonder if the conversion to bytes should be reflected in the function
> > name.  Because returning 'cap' might imply to someone they are getting the raw
> > data field.
> 
> Makes sense.
