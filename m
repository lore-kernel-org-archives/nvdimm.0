Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268833B471
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758123484; cv=none; b=OtiseeLYrk8SUujLG5LcDbwVBEEqgMAnuhCzRceBxTpFs4R00zIZPWthe7Wl9WDO0aMThYCBqWaDj07dS+bUB0RMzExVAJeuPj52b+Lphi2LneqWpAFQVvqhCfSXhTUWjP/EbnuihB3FSTti52+B9exT/hqHKy/4wMR3EOlWgfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758123484; c=relaxed/simple;
	bh=j0Hkr8sHi8/5STCPzojZ4wVrJ+HWHvW45PeNdOOWqaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ngxhMwQx8r37PPefaxdkfUgvSNRttJj06nxxRsiSlvzLIjI7UMkNbzL1R015BFycMoOGbzn3iEGReFZlDOTYi9ItOLYV1gLwbCMvulNCa2Jo/8KiTV09Xmb69jfIjyP8vvo1wDzlQEJhqKyDrokXZkNP3JXJhmbaQOhOwHsWEeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XVKUlqpI; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XVKUlqpI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758123482; x=1789659482;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j0Hkr8sHi8/5STCPzojZ4wVrJ+HWHvW45PeNdOOWqaw=;
  b=XVKUlqpIr+0K+pdVz3gyn0C3N655YnqHFbYZ+uM6MzwDqagsdYRNs65i
   UCSfsUY8UcdtvkDxiNp/oAzSi50sC70UJXS6BKll1st3gwSrBvPGeVp56
   WoorY0J9cB/oT2vPCuoiQW25FE0Zd/lqsiCgqwAQ6VnzvAtPLH3QMSF8S
   ROM/AKYKo4T8dzXtzzFKTu86A7HUyuaMSl7kEsekbW+khVVBuG2uivzdC
   ZzHchEUyR8ODLpptfpDNQ8xo3xogdzwh8VNu4C1v5Tw4wCg3HenahDOTg
   6bHPzYMxQvqJvnJXNct+ws2HTnREkp5VTfkVSLSlcZQY6qVfRjAG0tFfF
   A==;
X-CSE-ConnectionGUID: +bz9rWQhRgC3g1OTc520Lg==
X-CSE-MsgGUID: DmbCsI8wSiS+NrbejiUIhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="77874164"
X-IronPort-AV: E=Sophos;i="6.18,272,1751266800"; 
   d="scan'208";a="77874164"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 08:38:02 -0700
X-CSE-ConnectionGUID: mT5gS3xISFqKPJ/ygijklg==
X-CSE-MsgGUID: EPitxodfQSe2edfO9y6SWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,272,1751266800"; 
   d="scan'208";a="180413389"
Received: from msatwood-mobl.amr.corp.intel.com (HELO [10.125.111.223]) ([10.125.111.223])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 08:38:01 -0700
Message-ID: <fd83a975-8ea8-4117-9e1d-b122d1ee7f48@intel.com>
Date: Wed, 17 Sep 2025 08:38:00 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 00/20] Add CXL LSA 2.1 format support in nvdimm and cxl
 pmem
To: Jonathan Cameron <jonathan.cameron@huawei.com>,
 Neeraj Kumar <s.neeraj@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gost.dev@samsung.com,
 a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <CGME20250917134126epcas5p3e20c773759b91f70a1caa32b9f6f27ff@epcas5p3.samsung.com>
 <20250917134116.1623730-1-s.neeraj@samsung.com>
 <20250917155053.00004c03@huawei.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917155053.00004c03@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 7:50 AM, Jonathan Cameron wrote:
> On Wed, 17 Sep 2025 19:10:56 +0530
> Neeraj Kumar <s.neeraj@samsung.com> wrote:
> 
> 
> Hi,
> Not sure what difference between the two versions I'm seeing is.
> Patch 02 is missing in both of them.
> 
> Jonathan
> 

Neeraj,
If you resend the series again with patch 2 included, please add the prefix RESEND in the patch subjects. Thanks!
