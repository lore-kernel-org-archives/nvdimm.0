Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972AA22D9ED
	for <nvdimm@lists.linux.dev>; Fri, 22 Aug 2025 15:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755878251; cv=none; b=Rh6DQuFuCcf7sFiorYUlbc0ORjtCUJLXq3bT2CyIavHsPm7/NIy5cP6iETNyKYIKWLdrLZHwd83unbaQjECpB4/hEoRLy6uLud7+TR3efKrLK4gJ6/bdMFxIS7CC6F9KgN7Ufld4RL4wxrwgAYISspS4wGFbFVno7FidnTd47qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755878251; c=relaxed/simple;
	bh=VTvWYONoPQlidR1PcWGtJ3rkoTBIL+7MaLtuPcQXVQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YSBVsW3FiR6dmMBpYoJuOazs7LqoSTYY/kCtDFQswKT+/o5xHnAVetTqsfYsewGODPW90IH51M9yq4J1N7LjmcrmdslsihNab+Ej7x5NbPA5PHt47LhC6/GSPObeVPDbOwpJC3spy8Zq0W3IuPbhulfSZbzEe0WvBNDKgOZqeME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pv4OIA7b; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pv4OIA7b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755878249; x=1787414249;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=VTvWYONoPQlidR1PcWGtJ3rkoTBIL+7MaLtuPcQXVQY=;
  b=Pv4OIA7b7QyDaxdMpFxo5qKqovWLTnbocxMXtLV/pvoGg4e43Vu2idva
   IF8ArbZLjVH1tWRH3cno7evP2zUulTE0mcb/oe5ig+GetSfb3PKc0a+IM
   dLnxs5dSxLI42Le34w/uYvF4xQ8Yq01YivUMEL5wZwzt9da5QVEefocNw
   LdX0I5Mr2PuiAtkiTnFlkAtVNuGH/cINredos06LB0vybx8jFV2Khkbt5
   DYdZAK8MVaGHLp6Z1UbipctbWPmbRABOqLqHUyglcg8AGoDvWbM+Le7Bh
   aAZaF7MEtt5GvDSQVjBQm6Qejkv4i6B7EAq+KIGEinAHqnVwRbyivjw9F
   w==;
X-CSE-ConnectionGUID: zkN5Ob8mTv2BRRbZ+59zZw==
X-CSE-MsgGUID: 7u8I/Ik4SdaR4R5BBNWuJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="75773136"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="75773136"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 08:57:29 -0700
X-CSE-ConnectionGUID: 9ao948mvQ0enjwx7gAyhww==
X-CSE-MsgGUID: NrI1+PMcRY+jgQlV/37Nxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="174054327"
Received: from dustinle-mobl1.gar.corp.intel.com (HELO [10.247.119.220]) ([10.247.119.220])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 08:57:27 -0700
Message-ID: <c3b27607-6878-4dd6-875d-532850577527@intel.com>
Date: Fri, 22 Aug 2025 08:57:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/common: document magic number
 CXL_TEST_QOS_CLASS=42
To: marc.herbert@linux.intel.com, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, alison.schofield@intel.com
References: <20250822025533.1159539-2-marc.herbert@linux.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250822025533.1159539-2-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/21/25 7:55 PM, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> This magic number must match kernel code. Make that corresponding kernel
> code much less time-consuming to find.
> 
> Additionally, that same one-line reference indirectly documents the
> minimum kernel version required by the test(s) using this value (only
> cxl-qos-class.sh at this time)
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/common | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/test/common b/test/common
> index 2d076402ef7c..1ab62be6994f 100644
> --- a/test/common
> +++ b/test/common
> @@ -155,4 +155,5 @@ check_dmesg()
>  }
>  
>  # CXL COMMON
> +# Test constant defined in kernel commit v6.8-rc2-9-g117132edc690
>  CXL_TEST_QOS_CLASS=42

