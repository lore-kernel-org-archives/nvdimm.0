Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EE4C2C0
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 09:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696239443; x=1727775443;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uRt1ae+PaFLvuL/WtDM9bT7telz1ws3WCIW7qDvGk1I=;
  b=IT/ZvO1IRgfGRw4XpdAwlM6OKaWvPW29YM1knXiBiZTWdijOTP7RxEiU
   KjydYIxa106TsSUcJ7J7qh3bVEeEP3Oykg4Ap1RoNbFtMnr4SaYuvu3dW
   jk497eaocNETmRSAJ+0ZyheCfXl2rW+a0cTn+nhzXCA/LDWLbYXTVAbmJ
   EECcJgyEDB4WWySLIOoY83KhZHcj4nRuhCUBHUelF1c5gpZt6FmYGUwFN
   WJLevZioaP91HZrNDvX0aLJvwu/2uw5nR/TCqVnsITJEQcZIs5pD3D6Kr
   nG/i4Fws/+uMMTCQRZzDdZdjtfRRZQZRWox8dMtsXEUufQ8/Sb1LRSdt9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="361987746"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="361987746"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 02:37:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="997573837"
X-IronPort-AV: E=Sophos;i="6.03,194,1694761200"; 
   d="scan'208";a="997573837"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2023 02:37:07 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97-RC0)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qnFMO-000000027Z7-0xKM;
	Mon, 02 Oct 2023 12:37:04 +0300
Date: Mon, 2 Oct 2023 12:37:03 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rafael.j.wysocki@intel.com, lenb@kernel.org,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com
Subject: Re: [PATCH v1 1/2] ACPI: NFIT: Fix memory leak, and local use of
 devm_*()
Message-ID: <ZRqPP9xT9fqrZLQS@smile.fi.intel.com>
References: <20230926184520.2239723-1-michal.wilczynski@intel.com>
 <20230926184520.2239723-2-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926184520.2239723-2-michal.wilczynski@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Tue, Sep 26, 2023 at 09:45:19PM +0300, Michal Wilczynski wrote:
> devm_*() family of functions purpose is managing memory attached to a
> device. So in general it should only be used for allocations that should
> last for the whole lifecycle of the device. This is not the case for
> acpi_nfit_init_interleave_set(). There are two allocations that are only
> used locally in this function. What's more - if the function exits on
> error path memory is never freed. It's still attached to dev and would
> be freed on device detach, so this leak could be called a 'local leak'.
> 
> Fix this by switching from devm_kcalloc() to kcalloc(), and adding
> proper rollback.

LGTM,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


