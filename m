Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B2938E126
	for <nvdimm@lists.linux.dev>; Fri, 18 Sep 2026 03:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789701877; cv=none; b=P/m5qNqGtvIKHwDnKWYtQpji8xmKB42Sg5JZTTO+s3BLQiQehHod+4xrgNhH/JrviNXseRpRQInlHJUKgkDHMCzH8JY8KxE5Uo9sEpbxbErUyrgcYFXNlykfIOgSfs747qosY4aYV/theqRwyQh91H+QQI3eyNweKNCYIVMpenE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789701877; c=relaxed/simple;
	bh=IMiA2t8PF7ryssxhuS1Skhk4PglIN9eC+tUJe+dUmw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HzRtlS9H2Oft7wM5RK4H6YdZ7DLhQiT6DP8KJ3+2JXwalwjyiKZVOdV7pWzHIMWqxBcR/Jql8S0YbOO2Vndtwvk5xQkIyCi3qp9TH3F0LuEXPjms2eYc9vp1M/kshz6PU59Fe9kLAVX/w2TTa5DQs4tQ/NV9vKaMIFDeoD+BKR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h2m32yjd; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h2m32yjd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789701875; x=1821237875;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IMiA2t8PF7ryssxhuS1Skhk4PglIN9eC+tUJe+dUmw8=;
  b=h2m32yjd0fRsBRhu6cGknX0RnXdvcB4n5UHkVHAJgr/vXcYH1rtZCfs7
   shKZM9vSDiUoqPOhJdgjBtHBQNvE8usDGul1xnlxU1ArxM4Lor1SRB6Jn
   zGFhTgJ7epJuXvXq8/rPiPddfN5oF3UqohYxy0CWePWl9QuJH3ApRfeDr
   unPKjx+OLko22cB96YdL8+ZXV/l0NoJ+06ZPbd2197H4kSQrrz3YQjDh3
   2622Em+D2R3HRLDwclj67z2m2la4SimQcRuf1QwwJGwYUX+jwdEfOcYsn
   UhuEkGeMEjDvXTYh0ITERXZxaLDDJBQTC6ypW6+itWnTGIOfJ9eAZwru1
   g==;
X-CSE-ConnectionGUID: BDSkXH46SimPZN2+sT1OPQ==
X-CSE-MsgGUID: IGXNH6g6QIe9trIy2e8S8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="90045442"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="90045442"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 20:24:34 -0700
X-CSE-ConnectionGUID: qgrS1QczQAuv/e6rJFNhFA==
X-CSE-MsgGUID: MHtiyldCTaeu7CulBSbu0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="271509459"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.109.63]) ([10.125.109.63])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 20:24:33 -0700
Message-ID: <26018729-d231-4c72-af8e-67c0a46c3911@intel.com>
Date: Thu, 17 Sep 2026 20:24:31 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] nvdimm: ndtest: Return the string length from
 flags_show()
To: Kees Cook <kees@kernel.org>, Bill Wendling <morbo@google.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Guangshuo Li <lgs201920130244@gmail.com>, nvdimm@lists.linux.dev,
 Steven Rostedt <rostedt@goodmis.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-hardening@vger.kernel.org
References: <20260917002312.i.923-kees@kernel.org>
 <20260917002333.2306346-7-kees@kernel.org>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260917002333.2306346-7-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/16/26 5:23 PM, Kees Cook wrote:
> flags_show() build their output with a seq_buf and return seq_buf_used(),
> which may include the trailing NUL byte when the seq_buf has
> overflowed. Use seq_buf_strlen() instead.
> 
> The flag names are far shorter than the PAGE_SIZE buffer sysfs
> provides, so this cannot overflow today.
> 
> Build tested ARCH=x86_64 with GCC 16.2.0, built out of tree with
> make M=tools/testing/nvdimm:
> tools/testing/nvdimm/test/ndtest.o
> 
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ira Weiny <iweiny@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Guangshuo Li <lgs201920130244@gmail.com>
> Cc: <nvdimm@lists.linux.dev>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 2051ad5d4882..f097f2992966 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -693,7 +693,7 @@ static ssize_t flags_show(struct device *dev,
>  	if (seq_buf_used(&s))
>  		seq_buf_printf(&s, "\n");
>  
> -	return seq_buf_used(&s);
> +	return seq_buf_strlen(&s);
>  }
>  static DEVICE_ATTR_RO(flags);
>  

