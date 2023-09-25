Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43936FB8
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695656857; x=1727192857;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+K5Fipx1dZqTJlRL8mpcXqKkwlqbuDzbtNFslPySHKo=;
  b=KX+QRxWTNcSka1Q8ICqVbTEF9LVXFc3CAJEuzAYTJuE63fwPqyQimdiv
   8B9VMbnppX2+OGsIhPd1GlOzQ1ZLyZFEkaTQU0SVSW9WQWyTiFuhBB4t6
   98UzT0Ples58aZsfwe+gunQrlZUEViqigbmy1fjrAhkyuqX8aGTspumfX
   TRcmKt1N6c8wsVtvO1qM72bWs9Ucc0vPMoZtBQQSTOnury2qoHh9EEeIQ
   nx4wRpNXhjSIwCrGl9V8a6xfssHocCLUp7XSB4XYG+QTQiCDCqIVYkJN/
   fQUn0ovATT9Kzh4GUuNhY8tTpeZlF7u5e7jWLKhP8ojPB510sdt5Ln/1k
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="445394511"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="445394511"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 08:47:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="814019337"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="814019337"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 08:47:34 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97-RC0)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1qkno3-00000000Nnc-1SGH;
	Mon, 25 Sep 2023 18:47:31 +0300
Date: Mon, 25 Sep 2023 18:47:31 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Michal Wilczynski <michal.wilczynski@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, rafael.j.wysocki@intel.com, lenb@kernel.org,
	dan.j.williams@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, rui.zhang@intel.com
Subject: Re: [PATCH v1 9/9] ACPI: NFIT: Don't use KBUILD_MODNAME for driver
 name
Message-ID: <ZRGrk8/0UMd9FuFH@smile.fi.intel.com>
References: <20230925144842.586829-1-michal.wilczynski@intel.com>
 <20230925144842.586829-10-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925144842.586829-10-michal.wilczynski@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Sep 25, 2023 at 05:48:42PM +0300, Michal Wilczynski wrote:
> Driver name is part of the ABI, so it should be hard-coded, as ABI
> should be always kept backward compatible. Prevent ABI from changing
> accidentally in case KBUILD_MODNAME change.

This is up to maintainers, probably we won't have any users outside of existing
model (instantiating via ACPI ID). All the above is "strictly speaking"...

-- 
With Best Regards,
Andy Shevchenko


