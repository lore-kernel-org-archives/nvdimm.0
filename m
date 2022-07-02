Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C3C580C;
	Sat,  2 Jul 2022 02:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656728819; x=1688264819;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Itd5VZeYWgvhgqwjRYotFpcIUxCUBrBmoiwnBbP2D/w=;
  b=PufaJ4A/nh4Fu2eyGgqIH2CgrTiPcht0SDTEdTGUkM+8EdLmLzLOM9EO
   RNmaDcSRge5WrSRX2Rj46OG+nkIomwdVkOSs3jPe39jWGgfYHucpud8eN
   Blf/IkwrA/BC98CMCGi9ACePB1HwBS+Q/kkjqoDelJTbadFWbLinbx3Ai
   Rtj/BkvIStPIyqyp6MZI4XlIaszNsWqxsTaKDyT0pwD9KxtZc8jDzS3G9
   sEdQbam6tp7bL3tmJqDbJUXND8G9naNeiXNRkqmTjYHTbdbY4d3DM6TEH
   US8ebu7u7YN0WFVy6kJSDSc4lVYHGcK5mCPwDxTx1N5Fg1TVN6RgmH3HF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10395"; a="346764682"
X-IronPort-AV: E=Sophos;i="5.92,239,1650956400"; 
   d="scan'208";a="346764682"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 19:26:59 -0700
X-IronPort-AV: E=Sophos;i="5.92,239,1650956400"; 
   d="scan'208";a="648584201"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 19:26:58 -0700
Date: Fri, 1 Jul 2022 19:26:05 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ben Widawsky <bwidawsk@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH 00/46] CXL PMEM Region Provisioning
Message-ID: <20220702022605.GA1592972@alison-desk>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>

On Thu, Jun 23, 2022 at 07:45:00PM -0700, Dan Williams wrote:
> tl;dr: 46 patches is way too many patches to review in one sitting. Jump
> to the PATCH SUMMARY below to find a subset of interest to jump into.
> 
> The series is also posted on the 'preview' branch [1]. Note that branch
> rebases, the tip of that branch at time of posting is:
> 
> 7e5ad5cb1580 cxl/region: Introduce cxl_pmem_region objects
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=preview
>
Dan,

I'm seeing these smatch reports while working off of the preview branch.
Perhaps 0-day has already sent these reports aligned to patches. 

drivers/cxl/core/port.c:1482 cxl_decoder_alloc() warn: is 'alloc' large enough for 'struct cxl_root_decoder'? 0

drivers/cxl/core/port.c:1515 cxl_decoder_alloc() error: potentially dereferencing uninitialized 'cxld'.

drivers/cxl/core/hdm.c:457 cxld_set_interleave() error: uninitialized symbol 'eig'.
drivers/cxl/core/hdm.c:458 cxld_set_interleave() error: uninitialized symbol 'eiw'.
drivers/cxl/core/region.c:192 cxl_region_decode_commit() error: uninitialized symbol 'rc'.
drivers/cxl/core/region.c:201 cxl_region_decode_commit() error: uninitialized symbol 'rc'.
drivers/cxl/core/region.c:443 alloc_hpa() error: uninitialized symbol 'res'.
drivers/cxl/core/region.c:964 cxl_port_setup_targets() error: uninitialized symbol 'peig'.
drivers/cxl/core/region.c:964 cxl_port_setup_targets() error: uninitialized symbol 'peiw'.
drivers/cxl/core/region.c:964 cxl_port_setup_targets() error: uninitialized symbol 'eiw'.
drivers/cxl/core/region.c:968 cxl_port_setup_targets() error: uninitialized symbol 'peiw'.
drivers/cxl/core/region.c:969 cxl_port_setup_targets() error: uninitialized symbol 'peig'.
drivers/cxl/core/region.c:1557 create_pmem_region_store() warn: unsigned 'rc' is never less than zero.

> ---
snip
> 
