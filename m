Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F87C2C80
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 22:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643668459; x=1675204459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=guc+t4X8qIxtDZg/LzaCnykg5raQFyS2HDN3b5+XTRY=;
  b=UmRrrpaiL+IxX1YGYci4uw4WimcEL4AjzPS0bjtdZUwo7MuTm0RJtg17
   341AxixPcmuMmLmi8QK0tpryPE2gs16p7XXgge2oiovKo/dQDwHTwSJYD
   k83dD2v3kwWY4ePhsnrGcW6BFeXVo4bMnyTGgaPRjxu+oUd96zFkbTV2q
   8sA7in7M/nk/S3yCIVRFDq07CTLquPtYYw1qBp35aFTJXeSdilNmYO729
   wUJpkzqXurnigPa9dox8utXYid+mT+jiASuRouhpIK3nIfQ87Nu9w0B45
   p7u0psQf7CBa3XqDQ5MMHXD5tHFn3p2SjttzElk8HQ2BCqa8uqN+wLJZa
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247517696"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247517696"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 14:34:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="598981452"
Received: from sssheth-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.130.247])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 14:34:08 -0800
Date: Mon, 31 Jan 2022 14:34:06 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 08/40] cxl/core/port: Rename bus.c to port.c
Message-ID: <20220131223406.cbtqnytamfy5jsdx@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298416136.3018233.15442880970000855425.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298416136.3018233.15442880970000855425.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:29:21, Dan Williams wrote:
> Given it is dominated by port infrastructure, and will only acquire
> more, rename bus.c to port.c.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>

[snip]

I wouldn't be opposed to keep bus.c for some of the core functionality, but that
file would be so small at this point it's fine to save for later.
