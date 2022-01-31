Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AE62C80
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 23:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643672533; x=1675208533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yjQHh0Yfr1scPww3LtRFqwgJl85g3BYaKqA4/Bg6Km4=;
  b=Rq1H0ITgtrOTjHadPgcONrq9lZpHljjxn3tIddCpLRAg7QWk/sDnn8cK
   K79YGhJw/YOJGwNkkLmdcct8Bnqa8I1yxRt9bW1bry6B5SLBhCFpUSKVU
   tZCf23iuopJ3CAMEO5mdBPBXqUjoyhKC6GsIS56mhPQIxxP70QOEu1XbK
   Hef9Ggs3ES/kZSwg5qgmetzy56S8aHJCbBgTNx2I34IC6LwCywMjQxO/z
   8S58YLyk5O0BA7Jb/k9zfm531vlgko6zm24ALu6ipgwiYYe5D3dyUlQ3c
   baOlsJgDWW3q02oWspeGbS+qHjO8R6aGdNsVddZidp11UVsRlG+/Un76H
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247345890"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="247345890"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:41:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="522844661"
Received: from sssheth-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.130.247])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:41:54 -0800
Date: Mon, 31 Jan 2022 15:41:52 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH v4 17/40] cxl/port: Introduce cxl_port_to_pci_bus()
Message-ID: <20220131234152.ttpp5xkiunrxv3zp@intel.com>
References: <164298420951.3018233.1498794101372312682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164364745633.85488.9744017377155103992.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164364745633.85488.9744017377155103992.stgit@dwillia2-desk3.amr.corp.intel.com>

On 22-01-31 08:44:52, Dan Williams wrote:
> Add a helper for converting a PCI enumerated cxl_port into the pci_bus
> that hosts its dports. For switch ports this is trivial, but for root
> ports there is no generic way to go from a platform defined host bridge
> device, like ACPI0016 to its corresponding pci_bus. Rather than spill
> ACPI goop outside of the cxl_acpi driver, just arrange for it to
> register an xarray translation from the uport device to the
> corresponding pci_bus.
> 
> This is in preparation for centralizing dport enumeration in the core.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>

[snip]
