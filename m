Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E06D13
	for <nvdimm@lists.linux.dev>; Fri, 13 Aug 2021 10:15:07 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="202729616"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="202729616"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 03:15:06 -0700
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="591068974"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 03:15:04 -0700
Received: from andy by smile with local (Exim 4.94.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1mEUDK-0091rD-Cu; Fri, 13 Aug 2021 13:14:58 +0300
Date: Fri, 13 Aug 2021 13:14:58 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 10/23] libnvdimm/labels: Add uuid helpers
Message-ID: <YRZGInO3vguWR4IA@smile.fi.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854812073.1980150.8157116233571368158.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YROE48iCZNFaDcSo@smile.fi.intel.com>
 <YRQB9Yvh3tmT9An4@smile.fi.intel.com>
 <CAPcyv4jOEfi=RJTeOFTbvkBB+Khfzi5QirrhPxeM4J2bQXRYiQ@mail.gmail.com>
 <YRQik5OnRyYQAm4o@smile.fi.intel.com>
 <CAPcyv4hY9YL7MhkeSu4GYBNo6hbeMRgqnKf8YuLuQ3khSbhn9A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hY9YL7MhkeSu4GYBNo6hbeMRgqnKf8YuLuQ3khSbhn9A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Aug 12, 2021 at 03:34:59PM -0700, Dan Williams wrote:
> On Wed, Aug 11, 2021 at 12:18 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > On Wed, Aug 11, 2021 at 10:11:56AM -0700, Dan Williams wrote:
> > > On Wed, Aug 11, 2021 at 9:59 AM Andy Shevchenko
> > > <andriy.shevchenko@linux.intel.com> wrote:
> > > > On Wed, Aug 11, 2021 at 11:05:55AM +0300, Andy Shevchenko wrote:
> > > > > On Mon, Aug 09, 2021 at 03:28:40PM -0700, Dan Williams wrote:
> > > > > > In preparation for CXL labels that move the uuid to a different offset
> > > > > > in the label, add nsl_{ref,get,validate}_uuid(). These helpers use the
> > > > > > proper uuid_t type. That type definition predated the libnvdimm
> > > > > > subsystem, so now is as a good a time as any to convert all the uuid
> > > > > > handling in the subsystem to uuid_t to match the helpers.
> > > > > >
> > > > > > As for the whitespace changes, all new code is clang-format compliant.
> > > > >
> > > > > Thanks, looks good to me!
> > > > > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > >
> > > > Sorry, I'm in doubt this Rb stays. See below.
> 
> Andy, does this incremental diff restore your reviewed-by? The awkward
> piece of this for me is that it introduces a handful of unnecessary
> memory copies. See some of the new nsl_get_uuid() additions and the
> extra copy in nsl_uuid_equal()

It does, thanks! As for the deeper discussion I think you need to talk to
Christoph. It was his idea to move uuid_t from UAPI to internal kernel type.
And I think it made and still makes sense to be that way.

But if we have already users of uuid_t like you are doing here (without this
patch) then it will be fine I guess. Not my area to advise or decide.

-- 
With Best Regards,
Andy Shevchenko


