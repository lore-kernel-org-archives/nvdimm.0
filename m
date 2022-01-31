Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D84A3FE3
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 22:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643668802; x=1675204802;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ssB0iV/cMxck25dO81DeYUJAunxOtDWbLOabp/wUCZA=;
  b=FffjjZSIi37GnBLI4iVdGDsj2yO3wK7rniFNhZLN1sL63ZcV6cw1gKDu
   FMTCLoVYdc2v0CLnOsBT1HYJ44F1d8yklK7M1P8XwIArP+hxz3qH9HVCP
   4/efu/mAWf+PaNuuJf4bbVnL/yQmigjAZZw1X5s0RHWmuCPTAmg0cOLCa
   hbKZZgTN6RsVNuvpXu95VefvYwK6qciO02/oZkkOUtPJjGyCpI8AgB2zz
   S1RqLF8X/Qwp6IvdsAJABhNtR0CRN5V34xSplM8i2Nqdo9lfqaxjpdZ9p
   R52pu8ESvVCbRJUfAKLedrtQk32Lu91k9/Is1SG4jpxm6rwHN/IeVaLj1
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247335393"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247335393"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 14:40:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="626525085"
Received: from sssheth-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.130.247])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 14:40:01 -0800
Date: Mon, 31 Jan 2022 14:39:59 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, linux-pci@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 12/40] cxl/core: Fix cxl_probe_component_regs() error
 message
Message-ID: <20220131223959.l4uvkjwzu2t3k5lt@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298418268.3018233.17790073375430834911.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298418268.3018233.17790073375430834911.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:29:42, Dan Williams wrote:
> Fix a '\n' vs '/n' typo.
> 
> Fixes: 08422378c4ad ("cxl/pci: Add HDM decoder capabilities")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Ben Widawsky <ben.widawsky@intel.com

[snip]
