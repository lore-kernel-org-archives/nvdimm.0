Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD18BE7
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667923459; x=1699459459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TUjGvD9RQdG7kZzMsY9tj/iCoE8nnMBkLtziVc6jl8E=;
  b=gZQOlpP96n4Db8NX4DLgaSdghsYBZNcW2+MKWR/4+0r68ye0rE8ay6K+
   h1r2IpW8MUN8BXSC9QDgXbUdZL6dX6V7WQSjEtIefwf4Nm2bCl7Bvjkhy
   GV0+NtvsM1mIzHK8SW4TJbnlkQQxN12gYQMziWE+B8olTt3S55C3ZB9H6
   hhwXU6eKT5IFbpt/s4yRfDJ44++cSdaIewIjJBfazz+VPKpHH6bFL2B/Q
   qZnq/GhoPcv0Ipmm8eo+Kks8TMa0eZmTCg/66/wEOEXPQGuZCjSqrw256
   41OedTRVHof6dLbewFzRrUm+OHSiAEZNpeOycW29y1PkYppxbPsjb8tlG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="290451327"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="290451327"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 08:04:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="881562720"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="881562720"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.11.119])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 08:04:00 -0800
Date: Tue, 8 Nov 2022 08:03:59 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 13/15] cxl/region: Default to memdev mode for
 create with no arguments
Message-ID: <Y2p979yA5W6wklee@aschofie-mobl2>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777848122.1238089.2150948506074701593.stgit@dwillia2-xfh.jf.intel.com>
 <Y2lsYawI3eQayact@aschofie-mobl2>
 <6369995b14772_18432294f0@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6369995b14772_18432294f0@dwillia2-xfh.jf.intel.com.notmuch>

On Mon, Nov 07, 2022 at 03:48:43PM -0800, Dan Williams wrote:
> Alison Schofield wrote:
> > On Sun, Nov 06, 2022 at 03:48:01PM -0800, Dan Williams wrote:
> > > Allow for:
> > > 
> > >    cxl create-region -d decoderX.Y
> > > 
> > > ...to assume (-m -w $(count of memdevs beneath decoderX.Y))
> > 
> > I'm not understanding what the change is here. Poked around a bit
> > and still didn't get it. Help!
> > 
> > Leaving out the -m leads to this:
> > $ cxl create-region -d decoder3.3 mem0 mem1
> > cxl region: parse_create_options: must specify option for target object types (-m)
> > cxl region: cmd_create_region: created 0 regions
> > 
> > Leaving out the the -m and the memdevs fails because the memdev order is
> > not correct. 
> > $ cxl create-region -d decoder3.3
> > cxl region: create_region: region5: failed to set target0 to mem1
> > cxl region: cmd_create_region: created 0 regions
> > 
> > This still works, where I give the -m and the correct order of memdevs.
> > cxl create-region -m -d decoder3.3 mem0 mem1
> 
> Oh, I was not expecting the lack of automatic memdev sorting to rear its
> head so quickly, and thought that "cxl list" order was good enough for
> most configurations.

I wasn't clear on what was being advertised as supported with this
change. I didn't read this as an announcement of automatic region
creation, but it seemed you were hinting at it.

> 
> Can provide more details on your configuration in this case? If this is
> current cxl_test then I already do not expect it to work with anything
> but decoder3.4 since the other decoders have more complicated ordering
> constraints.
> 
> I.e. your:
> 
> cxl create-region -d decoder3.3
> 
> ...worked as expected in that it found some memdevs to attempt to create
> the region, but you got unlucky in the sense that the default order that
> 'cxl list' returns memdevs was incompatible with creating a region.

Pretty much exactly as you say above. My example was w cxl_test
decoder3.3, w 2 HB's. The automagic worked fine w decoder3.4 w 1 HB.

