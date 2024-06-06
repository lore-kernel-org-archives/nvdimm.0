Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5761519924E;
	Thu,  6 Jun 2024 16:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690370; cv=none; b=h9qPGddrOkeKHjzd6CbrT+jlhRdqSBWjy31Bvi50FqRMy7rYUKC+U+QaYdUtoneWYA1qpR1TeF/rL+S5fTNOuDFumZkE1xpyGjvjkVvXOZVfiFEYuz5Y4QW+ltp6zRlaGijpg/d8Nh8Nu6pvsfry56oP2v0YX4MV6U+lGqeKsQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690370; c=relaxed/simple;
	bh=FLkgxi+pF25xhHIbp2IkfKVsNIEObURWbTxALpl5xow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uLTuwDhnA4ih6EnTcScKtewuG3ZQa8aKOtSs55ULH5ykoLVC1s3ySkjUzyl2DDnFb0qQN+hxUnpZurNyOwlu4o/G2kj4H6ePGxU1/v3KhYon0V07Ajqy/pvwlWuTgVakIihHwAaVJ+VqrEItgzU6WNqEZfAzQPvrL8oCP+SmxLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UhIfQ4IP; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhIfQ4IP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717690369; x=1749226369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FLkgxi+pF25xhHIbp2IkfKVsNIEObURWbTxALpl5xow=;
  b=UhIfQ4IPqJPInGZG/lqNpgYj5z4dkv2TJKWM7XaVSqADsg7oIo/7xuwE
   a0lORgX/IZKD9Cedi0ft4KbmPSd9uSAlwWPmNZsE4yD+ZccRAm66vhOih
   cbY3uYDU4/CdHXw2l7HM3EAGZttkD91/z9wZydHThsqGAQWLPYhQXPQ0K
   MD9Nf/k0WNdfI8bZalVfjlSE/gnNdbKXf34bOxdhH/eRCujVIoiUpbOsb
   JU3jzx+NKgHqoKCzHaZQLlidUQ7FfgpRVqXdOYU6LWZl+cJhA+BWvgI+S
   gGgQEh+mmCObeoPvZwhLk4s29UEJ9kuMgw0kK1UI6NRNII+dWXcQG7sWn
   g==;
X-CSE-ConnectionGUID: 1Q29yw6qSPaRSeOKL4A4WQ==
X-CSE-MsgGUID: nb5HED58T46rX0MzktTIdQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="18164962"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="18164962"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:12:48 -0700
X-CSE-ConnectionGUID: +lPHS99LR8SsXcZGmjMI2w==
X-CSE-MsgGUID: fiUbgt3HR1m8ltR79Nforw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="38467602"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.109.168]) ([10.125.109.168])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:12:48 -0700
Message-ID: <5bc0ab49-c24b-4057-9bad-5193328f2cc1@intel.com>
Date: Thu, 6 Jun 2024 09:12:47 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] nvdimm: add missing MODULE_DESCRIPTION() macros
To: Jeff Johnson <quic_jjohnson@quicinc.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
 Oliver O'Halloran <oohall@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kernel-janitors@vger.kernel.org
References: <20240526-md-drivers-nvdimm-v1-1-9e583677e80f@quicinc.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240526-md-drivers-nvdimm-v1-1-9e583677e80f@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/26/24 10:07 AM, Jeff Johnson wrote:
> Fix the 'make W=1' warnings:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/libnvdimm.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_pmem.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_btt.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_e820.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/of_pmem.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/nvdimm/nd_virtio.o
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/btt.c       | 1 +
>  drivers/nvdimm/core.c      | 1 +
>  drivers/nvdimm/e820.c      | 1 +
>  drivers/nvdimm/nd_virtio.c | 1 +
>  drivers/nvdimm/of_pmem.c   | 1 +
>  drivers/nvdimm/pmem.c      | 1 +
>  6 files changed, 6 insertions(+)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 1e5aedaf8c7b..a47acc5d05df 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1721,6 +1721,7 @@ static void __exit nd_btt_exit(void)
>  
>  MODULE_ALIAS_ND_DEVICE(ND_DEVICE_BTT);
>  MODULE_AUTHOR("Vishal Verma <vishal.l.verma@linux.intel.com>");
> +MODULE_DESCRIPTION("NVDIMM Block Translation Table");
>  MODULE_LICENSE("GPL v2");
>  module_init(nd_btt_init);
>  module_exit(nd_btt_exit);
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index 2023a661bbb0..f4b6fb4b9828 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -540,6 +540,7 @@ static __exit void libnvdimm_exit(void)
>  	nvdimm_devs_exit();
>  }
>  
> +MODULE_DESCRIPTION("NVDIMM (Non-Volatile Memory Device) core module");
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Intel Corporation");
>  subsys_initcall(libnvdimm_init);
> diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
> index 4cd18be9d0e9..008b9aae74ff 100644
> --- a/drivers/nvdimm/e820.c
> +++ b/drivers/nvdimm/e820.c
> @@ -69,5 +69,6 @@ static struct platform_driver e820_pmem_driver = {
>  module_platform_driver(e820_pmem_driver);
>  
>  MODULE_ALIAS("platform:e820_pmem*");
> +MODULE_DESCRIPTION("NVDIMM support for e820 type-12 memory");
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Intel Corporation");
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 1f8c667c6f1e..35c8fbbba10e 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -123,4 +123,5 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>  	return 0;
>  };
>  EXPORT_SYMBOL_GPL(async_pmem_flush);
> +MODULE_DESCRIPTION("Virtio Persistent Memory Driver");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index d3fca0ab6290..5134a8d08bf9 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -111,5 +111,6 @@ static struct platform_driver of_pmem_region_driver = {
>  
>  module_platform_driver(of_pmem_region_driver);
>  MODULE_DEVICE_TABLE(of, of_pmem_region_match);
> +MODULE_DESCRIPTION("NVDIMM Device Tree support");
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("IBM Corporation");
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 598fe2e89bda..57cb30f8a3b8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -768,4 +768,5 @@ static struct nd_device_driver nd_pmem_driver = {
>  module_nd_driver(nd_pmem_driver);
>  
>  MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
> +MODULE_DESCRIPTION("NVDIMM Persistent Memory Driver");
>  MODULE_LICENSE("GPL v2");
> 
> ---
> base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
> change-id: 20240526-md-drivers-nvdimm-121215a4b93f
