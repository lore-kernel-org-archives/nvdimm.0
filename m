Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED33FE3
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 23:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643672895; x=1675208895;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eDPeWOjMherCcGDr1JOeWJR93GZStedgJ56UblsLTQM=;
  b=LPstTN/5cTCMZ85FHRUDiRG6g7++n2C1AntmpM3hW3ICHWeJWywHjAOX
   b19y8UQ40S9nGGN0g7kJq2s0Q8c3JrRTsZ4zsF4BvH4zM/8uL3zPcwyLO
   8eSLPnK1qhNxsTPq736vBOLvy9feBkP3p+oceUao7jpqGp3jhDjCPt24O
   abbFG+3lEFE/riO2+jlvqmusJkz46MM/xD1e+2IWw53UaHaW8BYpCaLGl
   E3WVbNaRa6KuERIj8OIFJjUAZqfZ5SO/y7ZNqaOkaQ/FpvCw1jy8/DvBL
   gsX7MBziINoYska1na5WUiRfX/GjIdLhqb/G1LnAf/ilIglvvpdSaCxKU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="272053914"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="272053914"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:48:11 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="630198344"
Received: from sssheth-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.130.247])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:48:11 -0800
Date: Mon, 31 Jan 2022 15:48:10 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>,
	linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 20/40] cxl/pci: Rename pci.h to cxlpci.h
Message-ID: <20220131234810.5ebiyq56zpve6zhr@intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298422510.3018233.14693126572756675563.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164298422510.3018233.14693126572756675563.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-23 16:30:25, Dan Williams wrote:
> Similar to the mem.h rename, if the core wants to reuse definitions from
> drivers/cxl/pci.h it is unable to use <pci.h> as that collides with
> archs that have an arch/$arch/include/asm/pci.h, like MIPS.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Ben Widawsky <ben.widawsky@intel.com>

[snip]
