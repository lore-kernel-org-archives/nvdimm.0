Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ABDEC1
	for <nvdimm@lists.linux.dev>; Tue, 21 Jun 2022 11:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655812631; x=1687348631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bs/0j/OtFGIBL6GNtWcTVuEeu+2d9SQNaMwWjvKuGwM=;
  b=DsO29diPhujQa5/Ce1z2ZA8xi9z1tfd0kTzWBozOM6+xuh3y7sW4LEA0
   8eXXKvlanIAQf6aFnZP5TbXdJKgAU/h9QLs7TjoB7eI9xoHhJKhfWQCcm
   jU4A+C0b7aXp/ImElrWz8gDNnvVF/r6n2DAFX1Wr7vebheAbiA5ziQx2f
   2iPweEs4tzSzjQfEtdvc5F2brPwldcRqAIr1f0ss4qMWCiIL9hXO5lHbW
   kgUFA6ESBkZeN8JeFS0QIa5qJD+cPHoEjB3+M9na4YL1TbyNZwWGozgLS
   X/ikeli1biS8HzybHMD4bozWslocTCVsHDhQwNMXnkcS5lJgBydtwpbW2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="259920917"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="259920917"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:57:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="614719605"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:57:09 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1o3cVG-000r00-Cp;
	Tue, 21 Jun 2022 14:57:06 +0300
Date: Tue, 21 Jun 2022 14:57:06 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v1 1/1] nvdimm/namespace: drop nested variable in
 create_namespace_pmem()
Message-ID: <YrGyEgXM9pvCTEc1@smile.fi.intel.com>
References: <20220607164937.33967-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607164937.33967-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Tue, Jun 07, 2022 at 07:49:37PM +0300, Andy Shevchenko wrote:
> Kernel build bot reported:
> 
>   namespace_devs.c:1991:10: warning: Local variable 'uuid' shadows outer variable [shadowVariable]
> 
> Refactor create_namespace_pmem() by dropping a nested version of
> the same variable.

Any comments on this and other two patches?

-- 
With Best Regards,
Andy Shevchenko


