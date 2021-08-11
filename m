Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA9E17F
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 16:59:42 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="214904705"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="214904705"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 09:59:41 -0700
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="469472103"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 09:59:39 -0700
Received: from andy by smile with local (Exim 4.94.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1mDrZl-008JWR-Az; Wed, 11 Aug 2021 19:59:33 +0300
Date: Wed, 11 Aug 2021 19:59:33 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	Jonathan.Cameron@huawei.com, ben.widawsky@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	ira.weiny@intel.com
Subject: Re: [PATCH 10/23] libnvdimm/labels: Add uuid helpers
Message-ID: <YRQB9Yvh3tmT9An4@smile.fi.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854812073.1980150.8157116233571368158.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YROE48iCZNFaDcSo@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YROE48iCZNFaDcSo@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Aug 11, 2021 at 11:05:55AM +0300, Andy Shevchenko wrote:
> On Mon, Aug 09, 2021 at 03:28:40PM -0700, Dan Williams wrote:
> > In preparation for CXL labels that move the uuid to a different offset
> > in the label, add nsl_{ref,get,validate}_uuid(). These helpers use the
> > proper uuid_t type. That type definition predated the libnvdimm
> > subsystem, so now is as a good a time as any to convert all the uuid
> > handling in the subsystem to uuid_t to match the helpers.
> > 
> > As for the whitespace changes, all new code is clang-format compliant.
> 
> Thanks, looks good to me!
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Sorry, I'm in doubt this Rb stays. See below.

...

> >  struct btt_sb {
> >  	u8 signature[BTT_SIG_LEN];
> > -	u8 uuid[16];
> > -	u8 parent_uuid[16];
> > +	uuid_t uuid;
> > +	uuid_t parent_uuid;

uuid_t type is internal to the kernel. This seems to be an ABI?

> >  	__le32 flags;
> >  	__le16 version_major;
> >  	__le16 version_minor;

...

> >  struct nd_namespace_label {
> > -	u8 uuid[NSLABEL_UUID_LEN];
> > +	uuid_t uuid;

So seems this.

> >  	u8 name[NSLABEL_NAME_LEN];
> >  	__le32 flags;
> >  	__le16 nlabel;

...

I'm not familiar with FS stuff, but looks to me like unwanted changes.
In such cases you have to use export/import APIs. otherwise you make the type
carved in stone without even knowing that it's part of an ABI or some hardware
/ firmware interfaces.

-- 
With Best Regards,
Andy Shevchenko


