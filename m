Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E666327EFF0
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285571; cv=none; b=guhBNwrvmloOiw/N+fRtLRcRWqs03/XuLkPspFr0Abd9Vci+uhlLc3mrK1X5PHiQSdca3eYkkCwvMGcv3+4XcNIlQsvdG1j/4V6+DHXS0z2CRBhu6RR6XcJnUG5uLqDqq29fF3+0ofa5kn8eDWZL7oYZaMnbUjam/6SpkjlEo1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285571; c=relaxed/simple;
	bh=bMX1Ihvk003PInbi1Mlj89qjqXENKcai/7lS1MwqeyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rB+dmA59+Numcifr4UvfXhpgp2961dl5TeQfoF9U5tIOVXTrJvTpCJBDs0BYbRD+8Jvg5PeD3iHbfoalUWKvHykxb8y2mtQVjo29I2h0s2QA7yU0VbRm0UoCs8dEcvYJm4zMKHzgf7PVyG0BlPquIMuI30v6YXQZlcEw6TKV3w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jSeHKvaZ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jSeHKvaZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285570; x=1781821570;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bMX1Ihvk003PInbi1Mlj89qjqXENKcai/7lS1MwqeyM=;
  b=jSeHKvaZh/ML2beAMJQ7lYdCNu+NW17bskoeHT118dW72tWzuLxitKNY
   PoA/Rw2SHVyT4Wls+5GDzfK4UxUI5ftMTHiWCYxDioMtRzgJLsTazR1wm
   fy0xreEkJuqSVZtFRuNrt9h1jFtcxHPeIJEkbbaypGKSGi37lcO6uAPoT
   lQlDTDrqoB5TbDTnYqq7XYLXNF+kGSrep0I6XOmgGCxYYnaWgHUEsoJH0
   r+5slaPHWIf8NN2GYVlN1yrf+cafZya2EsyhF5WMyhIq+gCecui/wkbZi
   8mfPaIPhJvZHiWapXAGEBwEgG1kHNpTy/EIYGQ5AF4f50/d6QUh4Qaqz1
   w==;
X-CSE-ConnectionGUID: //rUjMn5TiC7lHB1i6CPXw==
X-CSE-MsgGUID: ahtnxS2kQpyQDN5y+zxVaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52675866"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52675866"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:26:09 -0700
X-CSE-ConnectionGUID: oAJhSwbnTxeZUu4NC95B5A==
X-CSE-MsgGUID: vWP63M+bTf6T6EyuV9g4nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="149824690"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.125.108.99]) ([10.125.108.99])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:26:08 -0700
Message-ID: <80b30472-dc74-498f-9469-41f5a829de94@intel.com>
Date: Wed, 18 Jun 2025 15:26:06 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 2/5] test: Fix 'ndctl' dependency in
 test/sub-section.sh
To: Dan Williams <dan.j.williams@intel.com>, alison.schofield@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20250618222130.672621-1-dan.j.williams@intel.com>
 <20250618222130.672621-3-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250618222130.672621-3-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/18/25 3:21 PM, Dan Williams wrote:
> The test fails with:
> 
> "sub-section.sh: line 23: ndctl: command not found"
> 
> ...it should be using the built ndctl program, not the one installed in the
> filesystem.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/sub-section.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/sub-section.sh b/test/sub-section.sh
> index 77b963355c8f..5acc25eefe87 100755
> --- a/test/sub-section.sh
> +++ b/test/sub-section.sh
> @@ -20,7 +20,7 @@ MIN_AVAIL=$((TEST_SIZE*4))
>  MAX_NS=10
>  NAME="subsection-test"
>  
> -ndctl list -N | jq -r ".[] | select(.name==\"subsection-test\") | .dev"
> +$NDCTL list -N | jq -r ".[] | select(.name==\"subsection-test\") | .dev"
>  
>  rc=$FAIL
>  cleanup() {

