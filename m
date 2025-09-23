Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818CB32129C
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 16:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758645517; cv=none; b=iS41euH0+JdIIfovj1K8ijudWIudZ4oLi7BMTFgbDdg9I4PDNoWKv25WoPKcpwKBnDlrg1tAvjSgDonYsNQ1LuVFulslVwvKBK45865H8BgPakcch3JRWQR+wTh0CMEi2lHJ46yLvZEhiQKvLG9LptRRN7+BeNHHYQangTTnq6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758645517; c=relaxed/simple;
	bh=T2jzI5rRYPmkw82UpXljC20KjoBUf1ZvoKZKiSFqJ6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jI+DacwsUCl+BHcvs85hGvJyxAFl4PN0uGhOcz2JZHLtcbjMt6g5s66skjG3wzsyepAjsrpTngzeHqon62hHSiCrcogeSknT9xAKQAgHtSIPOCq0pt8PjwMCnj5fBXlxr93BbKFkoAQ+rUHugCdXdOduW5IOqHTllJTfynYJZs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HslXrp7Q; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HslXrp7Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758645515; x=1790181515;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T2jzI5rRYPmkw82UpXljC20KjoBUf1ZvoKZKiSFqJ6g=;
  b=HslXrp7Qd63CHP0XheLwX8iqpNsywhJUpcg4+syFfBD4cH+D3mxCzvOC
   H4c2eqh1uInk7FBKJm8WRqA39uo1emtONMGHK1Hnp4zNKIafp+Y6Bq5tM
   QFlGCzAHhN2jzYBFNQwuo+aZOEc+wm/TSBwyLDQrVyCPSvW5Z8mvAxoFL
   sDyNr4Oh1Je3STz9TDvra3jAihEXVxZ8Y2kS5QgALNaDasjijPpC4y2sx
   7oS/eBBFMr9Vp0nmtr5miQpbcFa6Do0QPs+3k1JD6Alj9A1pilfjQUIaS
   kWauHHmfNcBtxSNj7ohbt6imON361J/wsvRKtQKNKGtK9EAH0LdOPT6tj
   Q==;
X-CSE-ConnectionGUID: N2imqoJTSJ+T/407l/uRDw==
X-CSE-MsgGUID: 4yp3bSgqRWCMUYhwVB982g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60871251"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60871251"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 09:38:35 -0700
X-CSE-ConnectionGUID: tSHhlroQT5aJYHLmeSDB0Q==
X-CSE-MsgGUID: XEkNDiOFRHyWAhKQFf3NrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="207559953"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.108.174]) ([10.125.108.174])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 09:38:34 -0700
Message-ID: <767ef629-519c-431d-9a89-224ceabf22be@intel.com>
Date: Tue, 23 Sep 2025 09:38:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails
 in ndtest_probe()
To: Guangshuo Li <lgs201920130244@gmail.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Santosh Sivaraj <santosh@fossix.org>, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20250923125953.1859373-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250923125953.1859373-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/23/25 5:59 AM, Guangshuo Li wrote:
> devm_kcalloc() may fail. ndtest_probe() allocates three DMA address
> arrays (dcr_dma, label_dma, dimm_dma) and later unconditionally uses
> them in ndtest_nvdimm_init(), which can lead to a NULL pointer
> dereference under low-memory conditions.
> 
> Check all three allocations and return -ENOMEM if any allocation fails.
> Do not emit an extra error message since the allocator already warns on
> allocation failure.
> 
> Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> Changes in v2:
> - Drop pr_err() on allocation failure; only NULL-check and return -ENOMEM.
> - No other changes.
> ---
>  tools/testing/nvdimm/test/ndtest.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 68a064ce598c..abdbe0c1cb63 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -855,6 +855,9 @@ static int ndtest_probe(struct platform_device *pdev)
>  	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>  				  sizeof(dma_addr_t), GFP_KERNEL);
>  
> +	if (!p->dcr_dma || !p->label_dma || !p->dimm_dma)
> +		return -ENOMEM;

Why not just check as it allocates instead of doing it all at the end? If an allocation failed, no need to attempt to allocate more (which probably leads to more failures).

DJ

> +
>  	rc = ndtest_nvdimm_init(p);
>  	if (rc)
>  		goto err;

