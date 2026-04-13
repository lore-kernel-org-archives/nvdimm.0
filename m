Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D027A2C031E
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096749; cv=none; b=jpn+w44t4qHqXcWcrN8rGyhmPBy5yC3KanwcND3vk/hSBl+J94mVUf8NLYtIQOXgyo5Rchmg7Vz3Y9Aj2M0dajO0C3FRseJSwDYpvk5lS76Zf5ITGE5YhskBvN4ifxUeYznBsGk7NRp1kRkA+KL2owmPYgCj5QyWMNyzO+eFF/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096749; c=relaxed/simple;
	bh=hYX0m8El0e7JbM0seA0zgW/XLhcFeqneBwankDKddQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Clpq0USfp7d8oIJk3C7eavJ+UBfN9VUyMWZUnnMpPZ/CQ4idXZMVkTm5TGrXicsmxacuJwVnh7gBijp0qHqAVOmPDPgoWA3P997uJsQwPYqkauqK77W5QoYqHrOwK3l5DTEKrWWJFxLBIo4q51nHsrE40xUAhoD92Mc691ffFOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wdmi/uzj; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wdmi/uzj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776096747; x=1807632747;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hYX0m8El0e7JbM0seA0zgW/XLhcFeqneBwankDKddQU=;
  b=Wdmi/uzjqrVXYOg5ImHejCtltnxIMVbhSAxfnWAsvSSnPBdM7/HeIGH+
   sfrZNmvMe1LxxyE3B26H3XFfaTJVoYKCSSsMF/y3o6tdBg9/NlowUz69k
   3IN4IIB7LJ3DlZLnqLLCuQWNyV/8u2J5gyKTrAZ4LnqWfWvbTq2r7Tdxb
   Weog1/Sa6pHAaKTHKYRxBYGij40fDHWD/G27lRJ79EJ3fJAv6Jcn+CJ/c
   Rr1A1nS/2p6Lhg7NcQiZ8qML0bAJ52QA13kv8uAb+2oCTc972mC/ujwOm
   e78X48Xk3/sX9fUgMBkNWsWohWxKoJ8ab00rfnRHlbpewr+A1C0HfUPSW
   w==;
X-CSE-ConnectionGUID: 0kFnp35tRlK78PO+DSvUog==
X-CSE-MsgGUID: TYM8puynThmCfQlgmqLg9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11758"; a="76202819"
X-IronPort-AV: E=Sophos;i="6.23,177,1770624000"; 
   d="scan'208";a="76202819"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 09:12:26 -0700
X-CSE-ConnectionGUID: nrwgHC0NS7apn4kFFSA+Uw==
X-CSE-MsgGUID: ybx229t5SgCL83V0YaNXZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,177,1770624000"; 
   d="scan'208";a="233856721"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.175]) ([10.125.109.175])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 09:12:24 -0700
Message-ID: <5946384b-e35c-460d-8b2c-4e995b1c07e3@intel.com>
Date: Mon, 13 Apr 2026 09:12:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dax/fsdev: fix uninitialized kaddr in
 fsdev_dax_zero_page_range()
To: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Dan Carpenter <dan.carpenter@linaro.org>, John Groves <John@Groves.net>
References: <20260412154944.461748-1-john@jagalactic.com>
 <0100019d8262cda2-9714d31c-8fc1-4ca5-b32d-4df678240d14-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019d8262cda2-9714d31c-8fc1-4ca5-b32d-4df678240d14-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/26 8:50 AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> __fsdev_dax_direct_access() returns -EFAULT without setting *kaddr when
> dax_pgoff_to_phys() returns -1 (pgoff out of range). The return value
> was ignored, leaving kaddr uninitialized before being passed to
> fsdev_write_dax().
> 
> Check the return value and propagate the error.
> 
> Thanks to Dan Carpenter and the smatch project for reporting this.
> 
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dax/fsdev.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index 4499d9621f33..188b2526bee4 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -80,9 +80,12 @@ static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,
>  			pgoff_t pgoff, size_t nr_pages)
>  {
>  	void *kaddr;
> +	long rc;
>  
>  	WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);
> -	__fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);
> +	rc = __fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);
> +	if (rc < 0)
> +		return rc;
>  	fsdev_write_dax(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);
>  	return 0;
>  }
> 
> base-commit: 2ae624d5a555d47a735fb3f4d850402859a4db77

