Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C93126C16
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821489; cv=none; b=XEZ7AkbzBFoHGBb9bvIr2GYmAy66DccmHxwK/m/nYt3tmC3S6AB875vC0/KcOZ/p2mDVuj7YL6AUAbUffErv1I8QOYT82RuaKx41gEKiTyadPpUZpQqgBtGO25Ymdz+0nmgWQW9OYxJZ/XW2yeynoauDNal5dxiKKLHibfgHFqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821489; c=relaxed/simple;
	bh=rK85sHmQtKCO2Afs14jSFMnLdI6YngB9mHMJU1lUMSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uLO40l+ySb27sYWMG7SjI9j9NZ6hwrxNl/PQ9olqbz+Xsuzi53ub5ALAS7/XYQ0YBUlwjiKeXtIStWL2OXiyODwQYmvUjtiPtpWETBYPVC35U3JzLafoPilYw9ckiRtjHxZDV3ACNdJ8jwv8Td1p7XX1aCy7L7Bc6quWhLbRayk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZSGHX4JR; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZSGHX4JR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730821487; x=1762357487;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rK85sHmQtKCO2Afs14jSFMnLdI6YngB9mHMJU1lUMSc=;
  b=ZSGHX4JReXsYAxTe/Cig+4SZJP2UOsOYkhCznYeEjBuOiwj3Z09lsiVP
   p3gtBcNsjTduVblrZYorVVwvElPVZvb0bNklieoGcta6S+lbiy2nnyEIy
   jW8ghjuX/tjfdvOs7n/bvuMjYexr1f4e1Wxgl7JRjuZeMDNfQ3dEC5GyN
   eDzexDzxmFSL9aAPjTv+npoBmG6uYl01s0S7iZaPIwavFwzZCf2NkhlOb
   w1iN+MZAG+ufBmv1i/+VfERKWnD2JTPPhsu8RGlyVyHgJ++VkSMfrYQZt
   JzKqZH/+F/2P6F8k/7Aq7kfmMd6W1cuyMn/XNC2TbvA0Ls35OJf21Rf3w
   g==;
X-CSE-ConnectionGUID: o+fvAm64Qdaif5kKvoDvnQ==
X-CSE-MsgGUID: 7wnhSoOsRfK5FmCAhqhLZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48038000"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48038000"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 07:44:47 -0800
X-CSE-ConnectionGUID: BbUz2X9pQ/Ky5oCpyhIkmw==
X-CSE-MsgGUID: coHPLzPcRcacX97FXQnt3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84459742"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.109.253]) ([10.125.109.253])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 07:44:46 -0800
Message-ID: <37e180b0-df8b-4fc6-bd40-3779eba47030@intel.com>
Date: Tue, 5 Nov 2024 08:44:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 1/6] ndctl/cxl-events: Don't fail test until
 event counts are reported
To: Ira Weiny <ira.weiny@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>,
 Navneet Singh <navneet.singh@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-1-be057b479eeb@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20241104-dcd-region2-v2-1-be057b479eeb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/4/24 7:10 PM, Ira Weiny wrote:
> In testing DCD event modifications a failed cxl-event test lacked
> details on the event counts.  This was because the greps were failing
> the test rather than the check against the counts.
> 
> Suppress the grep failure and rely on event count checks for pass/fail
> of the test.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/cxl-events.sh | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> index ff4f3fdff1d8f6fd80f093126a27bf14b52d167f..c216d6aa9148c938a649cb22656127b3df440039 100644
> --- a/test/cxl-events.sh
> +++ b/test/cxl-events.sh
> @@ -71,10 +71,10 @@ echo 0 > /sys/kernel/tracing/tracing_on
>  echo "TEST: Events seen"
>  trace_out=$(cat /sys/kernel/tracing/trace)
>  
> -num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}")
> -num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}")
> -num_failure=$(grep -c "log=Failure" <<< "${trace_out}")
> -num_info=$(grep -c "log=Informational" <<< "${trace_out}")
> +num_overflow=$(grep -c "cxl_overflow" <<< "${trace_out}" || true)
> +num_fatal=$(grep -c "log=Fatal" <<< "${trace_out}" || true)
> +num_failure=$(grep -c "log=Failure" <<< "${trace_out}" || true)
> +num_info=$(grep -c "log=Informational" <<< "${trace_out}" || true)
>  echo "     LOG     (Expected) : (Found)"
>  echo "     overflow      ($num_overflow_expected) : $num_overflow"
>  echo "     Fatal         ($num_fatal_expected) : $num_fatal"
> 

