Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F1330F82
	for <nvdimm@lists.linux.dev>; Thu, 19 Oct 2023 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pe/8HNvs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697729801; x=1729265801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vuyr/wjcaq45z5sHIWsOKl3qqIBusIoS8TyidC9xcRM=;
  b=Pe/8HNvsBfm3o0Gju/AoTl7D8Lbgz19q3OtUHRdZZ7RuqcyO6K4rzTvA
   TN+/aC1YtY0nilgvf+6iAwY9gE+BTsLydFB2fZ2DDjNGx5yHFhxy/KbQM
   qU12dNAtGETXEbcW+F9dR3HO736wcnmblGQFZfcT+XgvwX5H2fklCuwo9
   OFIuXhXVrZYWZok5vFeN+HkikYZIzNB1+nx4lUdukrIIYFb6vJDY0vrXb
   e7Piq8NOHkYkQG1KbAdDl0oizDhqbl0eT9cavFoF5U6aMPmcAOtp+XJrw
   yCpkfPUaqsGZKWEytlr5Tt7c3K3b4cwIGMIvdHNYgmjnWbfLTBQJu4TzA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="386109293"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="386109293"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 08:36:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="1004277332"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="1004277332"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 08:36:38 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97-RC2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1qtV4d-00000006ur5-1sLB;
	Thu, 19 Oct 2023 18:36:35 +0300
Date: Thu, 19 Oct 2023 18:36:35 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Michal Wilczynski <michal.wilczynski@intel.com>, nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v1 1/1] ACPI: NFIT: Switch to use
 acpi_evaluate_dsm_typed()
Message-ID: <ZTFNA3M7OaiIoIw+@smile.fi.intel.com>
References: <20231002135458.2603293-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231002135458.2603293-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Oct 02, 2023 at 04:54:58PM +0300, Andy Shevchenko wrote:
> The acpi_evaluate_dsm_typed() provides a way to check the type of the
> object evaluated by _DSM call. Use it instead of open coded variant.

Dan, do you have any comments?

-- 
With Best Regards,
Andy Shevchenko


