Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC51114AA2
	for <nvdimm@lists.linux.dev>; Sat,  7 Oct 2023 07:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="evVRXF9a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696665377; x=1728201377;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=w37Uw2egK4TMI1TPq7330xWPQb1w+wAKmOmwEmrT3m8=;
  b=evVRXF9aD3udB1VKOaG3/LdSnM6YcP4xFswAr+UsKeKSdvAKOQOWcW+O
   uHYok0GjIghEXu05zEw5KqL/vn+rpQZ4m4eTJOpplp05JnenhUQeIR5R1
   Rl17exiK+2R4f05j2B3zViPqZCRFTawZAj7gRW4d2fhB/gvvR3kh/utsE
   RP0W4yUgYif5loM7mbCsXRk4tF+GmZ5HXv7ce74uM7ltVMx1BG8RC9+GU
   aLxxONgk9G7fIALmRf5g4SNK/LMtJzu1n7pq5WT1olMFYfG93M5iofzRr
   0+NmeLYQXWSgPz4nRZ86fWJUu+J5JXSsr9v+0A+3CUvyzGuTpaL6y3cQk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364189416"
X-IronPort-AV: E=Sophos;i="6.03,205,1694761200"; 
   d="scan'208";a="364189416"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2023 00:56:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="702318560"
X-IronPort-AV: E=Sophos;i="6.03,205,1694761200"; 
   d="scan'208";a="702318560"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2023 00:56:13 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97-RC1)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1qp2AV-00000003Y0V-01aV;
	Sat, 07 Oct 2023 10:56:11 +0300
Date: Sat, 7 Oct 2023 10:56:10 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Michal Wilczynski <michal.wilczynski@intel.com>,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rafael.j.wysocki@intel.com, lenb@kernel.org,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com
Subject: Re: [PATCH v2 3/6] ACPI: AC: Replace acpi_driver with platform_driver
Message-ID: <ZSEPGmCyhgSlMGRK@smile.fi.intel.com>
References: <20231006173055.2938160-1-michal.wilczynski@intel.com>
 <20231006173055.2938160-4-michal.wilczynski@intel.com>
 <CAJZ5v0jKJ6iw6Q=uYTf0at+ESkdCF0oWaXRmj7P5VLw+QppKPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0jKJ6iw6Q=uYTf0at+ESkdCF0oWaXRmj7P5VLw+QppKPw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Oct 06, 2023 at 09:47:57PM +0200, Rafael J. Wysocki wrote:
> On Fri, Oct 6, 2023 at 8:33 PM Michal Wilczynski
> <michal.wilczynski@intel.com> wrote:

...

> >  struct acpi_ac {
> >         struct power_supply *charger;
> >         struct power_supply_desc charger_desc;
> > -       struct acpi_device *device;
> > +       struct device *dev;
> 
> I'm not convinced about this change.
> 
> If I'm not mistaken, you only use the dev pointer above to get the
> ACPI_COMPANION() of it, but the latter is already found in _probe(),
> so it can be stored in struct acpi_ac for later use and then the dev
> pointer in there will not be necessary any more.
> 
> That will save you a bunch of ACPI_HANDLE() evaluations and there's
> nothing wrong with using ac->device->handle.  The patch will then
> become almost trivial AFAICS and if you really need to get from ac to
> the underlying platform device, a pointer to it can be added to struct
> acpi_ac without removing the ACPI device pointer from it.

The idea behind is to eliminate data duplication.

> >         unsigned long long state;
> >         struct notifier_block battery_nb;
> >  };

-- 
With Best Regards,
Andy Shevchenko


