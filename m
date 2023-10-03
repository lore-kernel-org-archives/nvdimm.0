Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7328F3FC2
	for <nvdimm@lists.linux.dev>; Tue,  3 Oct 2023 08:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696322928; x=1727858928;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x8PAGnQYc2NcxY6KGr2gS4Kpd9E+7T9nG0n2qjbE0G4=;
  b=QksVYY/PydsOsI1tR+g4ZQQ6n+PiLgvYDtnByps4sxPVAMsSzaueD26w
   mE0an0Tfka4B52w4zoge55PrvC/VjsR4wVp44zYNzoYqkPK8u8QVnGOFD
   lpmxDjDmMzHb8qTYkAal+wDNXl6fW7bMCBbLgcWH8sgxzhP7EPVDL+Gc0
   14g7S59gF3OgIahf/GtL0iF70ciWJeEXaS8h6D+KARdag5VQelPvwuOPK
   /YWJDudSpLH7iM6J1e1+LNzAqcNOIqzChYwBB3HATakvdcKz7FqaASkkO
   x44FWnrcRFfMPXE9HFsehvhIbASdbc6QYR/BZZVG5CoIRIm69rorfs74a
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="380101443"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="380101443"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 01:48:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10851"; a="727546647"
X-IronPort-AV: E=Sophos;i="6.03,196,1694761200"; 
   d="scan'208";a="727546647"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 01:48:42 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97-RC1)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qnb55-00000002R9j-2xen;
	Tue, 03 Oct 2023 11:48:39 +0300
Date: Tue, 3 Oct 2023 11:48:39 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v1 1/1] ACPI: NFIT: Switch to use
 acpi_evaluate_dsm_typed()
Message-ID: <ZRvVZylnYeIBDEH/@smile.fi.intel.com>
References: <20231002135458.2603293-1-andriy.shevchenko@linux.intel.com>
 <ec5029b0-553c-4a6c-b2a9-ef9943e553dc@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec5029b0-553c-4a6c-b2a9-ef9943e553dc@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Oct 02, 2023 at 10:27:02PM +0200, Wilczynski, Michal wrote:
> On 10/2/2023 3:54 PM, Andy Shevchenko wrote:

...

> > +	out_obj = acpi_evaluate_dsm_typed(handle, guid, revid, func, &in_obj, ACPI_TYPE_BUFFER);
> 
> This line is 90 characters long, wouldn't it be better to split it ?

I dunno it's a problem, but if people insist, I can redo that.

...

> > +	if (!out_obj || out_obj->buffer.length < sizeof(smart)) {
> >  		dev_dbg(dev->parent, "%s: failed to retrieve initial health\n",
> >  				dev_name(dev));
> 
> While at it maybe fix alignment ? :-)

I don't think it's in scope of this change.

> >  		ACPI_FREE(out_obj);
> 
> Just nitpicks, functionally code seems correct to me.
> Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>

Thank you!

-- 
With Best Regards,
Andy Shevchenko


