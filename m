Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE6274C00
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244682; cv=none; b=gOJ4VJxSN/wRYB9g9GHrTnNxkpRHx4D/pqDJO0ztMH9hdFlpsrOaTaxMyEESun03bT57WXAECHiM/IJvdOC8VkO+latfOyYKfxlNlLHcevYrqqu9xBNgcXn4vzI26OQfTtbueKAj+nM0ap/XVedCiguOYkjKJ0jJ+Af5u2L/APo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244682; c=relaxed/simple;
	bh=Kud6HMPsbXiKtLP09jZPznxuhz8s37krM2PEbQDNYlY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fn/xZYqHd83MhJIb+2Zz2tRytu577s1U3TP4948NiBm3GqTl2jXf1pstQEqL+9jPnKNYXOkXcapU2zgs5X6rr03I7SW2INa4Oa2/ERVKL5Ntz4erGRL85hI6r3+dP2d6wdKh82F28SDhIfMenjJCpLWkzkK0evzFC58QHZvLFmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WS3XgZhi; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WS3XgZhi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709244680; x=1740780680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kud6HMPsbXiKtLP09jZPznxuhz8s37krM2PEbQDNYlY=;
  b=WS3XgZhif7tXDCwrOqfDYsjmodhaeB/gz2ZfAq1jRHkluq5Awl8H0vQg
   8YNpLZM85PoSzIiJ4SgFVdXPMje4KemquvTRaW/F3UDsF5cHkkd0JltGq
   gl3TK58kWMfgN0P0W6bc8gdw3ZXA/G/0ftASzspoeg6FoYsSHgeJY4jQQ
   96vuE5UAVb9q3+z4/rpk7dWB+bCQBInIdUxXn+5FuYcKEY2oxzTfq9HMr
   Dmn14H7dcjuIm6+k9tFVBF1tqVkrQoPKuuQ7Sy0PL/osHcO8NBjxl4lDn
   84NJNx/EVP3IPIqAnh0jVMOjlbN967sMhl5D11WLW7KBXxpSIt5FixPw2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="21213527"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="21213527"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 14:11:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="8540975"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.114.3]) ([10.246.114.3])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 14:11:17 -0800
Message-ID: <519a99b6-9bc9-4e2e-8eef-46f571efb6cc@intel.com>
Date: Thu, 29 Feb 2024 15:11:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/documentation: tidy up cxl-wait-sanitize man
 page format
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20240229212838.2006205-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240229212838.2006205-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/29/24 2:28 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Remove extra '==' to address these asciidoctor complaints:
> 
> Generating Documentation/cxl/cxl-wait-sanitize with a custom command
> ERROR: cxl-wait-sanitize.txt: line 1: non-conforming manpage title
> ERROR: cxl-wait-sanitize.txt: line 3: name section expected
> WARNING: cxl-wait-sanitize.txt: line 4: unterminated example block
> WARNING: cxl-wait-sanitize.txt: line 26: unterminated listing block
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/cxl/cxl-wait-sanitize.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-wait-sanitize.txt b/Documentation/cxl/cxl-wait-sanitize.txt
> index 9047b74f0716..e8f2044e4882 100644
> --- a/Documentation/cxl/cxl-wait-sanitize.txt
> +++ b/Documentation/cxl/cxl-wait-sanitize.txt
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
>  cxl-wait-sanitize(1)
> -======================
> +====================
>  
>  NAME
>  ----
> 
> base-commit: 4d767c0c9b91d254e8ff0d7f0d3be04a498ad9f0
