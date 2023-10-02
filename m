Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA699CA43
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 09:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696239506; x=1727775506;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EKeqTQ7lBi8p0ds3MCDEOA0gTab2eJ95FzFsr/E1n6o=;
  b=GIhR3itioi27aWSbkpJijnN15OtmrJuZ9bQkNCbaof1JH2PtQ28IAjuK
   CaEqHyGdGY4S/jglx5TlwYKVohPFD28p7/77xbGX+uoQqSoaF6jwhZWMR
   4klQTTOiNqqIjTOneeRqP2bxqYTBaI97Wlen4ZElDtTwhNAR7k0mk6Qso
   RJZ7HUbVR3H0Mq5PCm782CPljljS6zQXR5f6Y2Srk0haNcvpMVBJyDw5D
   0IwkG5aRTuR9pPtl2mjqcp6H3xlB0LQiXn8yTBu8luwy/KcZctnQ1MR/0
   D9Hsd65r48vLCOJTHnZyOMHkBfWrHLBnAv/tanXXJo7VgRYq9KA4w6OJg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="382516183"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="382516183"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 02:38:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="1081591596"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="1081591596"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 02:38:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97-RC0)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qnFNc-000000027aE-1EzC;
	Mon, 02 Oct 2023 12:38:20 +0300
Date: Mon, 2 Oct 2023 12:38:20 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rafael.j.wysocki@intel.com, lenb@kernel.org,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v1 2/2] ACPI: NFIT: Use modern scope based rollback
Message-ID: <ZRqPjLfITntN3cKr@smile.fi.intel.com>
References: <20230926184520.2239723-1-michal.wilczynski@intel.com>
 <20230926184520.2239723-3-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926184520.2239723-3-michal.wilczynski@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Tue, Sep 26, 2023 at 09:45:20PM +0300, Michal Wilczynski wrote:
> Change rollback in acpi_nfit_init_interleave_set() to use modern scope
> based attribute __free(). This is similar to C++ RAII and is a preferred
> way for handling local memory allocations.

LGTM,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


