Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69E712CDA5
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 00:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779841906; cv=none; b=pXla+xCUztw/Yv2FjPhrx+0bPa9ruI8sYisRImTXU2klWj7aIkNL46jKBuU0L9Evr+7q31eGCiPwiJPB4jGDQMbFdCjEKEVInoFbkDantjEbfgqZixEKyBj+QNwNTrPHnoxY6EoSnh3WLFBHu/CtinHqxXnx9KFmbewrwC8LuWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779841906; c=relaxed/simple;
	bh=UCEpl2ldoOyCARtje0cO8ROZGrkrKkIhM58jOkVtcD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pV6FRygrrQuIFYKojzP2DUJ9ti9wZQWCDH9HFaT9FjjQhp8JQaeMdlYDSrWagLCRj46pXDXjvpZcfHnxa/AwQe7Q9kFh5xueIMdQ9gI6QIWjjYcldau6ocDm2fVGppZM8fntKGf8ZLjA0cxJ0To1SWpjufwrE70fhq4wes/0jeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hncho/c+; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hncho/c+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779841904; x=1811377904;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UCEpl2ldoOyCARtje0cO8ROZGrkrKkIhM58jOkVtcD0=;
  b=Hncho/c+IaQyLpS8mI513y78vyv8UhLlHnTrQ4nvwlJqBiNCRfUoS+Me
   6MES7cPUHB8O8tFdBmqF+Bhm9wQIHmiIhP68mc2DsqAFapaCnCFR/yd/J
   I2o0P1xlIADTTYLvkwEbc3bl8bS5/AQKDcWlTiOv55wY9adDhBSWRR8um
   CqSBH6qfLJdtmuuujM2CWkrFOZxte6xkxMLLc7EbwBDyhximpgUmEQdLO
   uA2YJc3d56IdU3TIKAs6EoABwLrKmcZhOpxqJBvZ47RESecAF7mv17kk3
   iKM9typqcHFRhXDapiLOM7OGIFSsoJEzKUO9hNfksU1c6SpTq1c6j46+u
   g==;
X-CSE-ConnectionGUID: gV5xCplRROGxwmHImuu4qA==
X-CSE-MsgGUID: Mfmb9vJRQ2yJe0PT8uTsrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="91357958"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="91357958"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 17:31:43 -0700
X-CSE-ConnectionGUID: CxrNtg1MTceJ35zGdIKHRQ==
X-CSE-MsgGUID: x3w93BQ3RjSI3HXoz85gqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="246336693"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.201]) ([10.125.110.201])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 17:31:42 -0700
Message-ID: <eb4212d1-bea2-452a-a7f6-886d325301a5@intel.com>
Date: Tue, 26 May 2026 17:31:41 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 7/7] dax: fsdev.c minor formatting cleanup
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Dan Williams <djbw@kernel.org>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191937.79247-1-john@jagalactic.com>
 <0100019e512117cd-2a9b3b34-6f2c-42e3-9110-71aef0463358-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019e512117cd-2a9b3b34-6f2c-42e3-9110-71aef0463358-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/22/26 12:19 PM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> Address some comments from Jonathan that were missed in the merged
> series. Fix line wrapping in fsdev_dax_recovery_write() and
> fsdev_dax_zero_page_range() signatures.
> 
> Fixes: 099c81a1f0ab ("dax: Add dax_operations for use by fs-dax on fsdev dax")

No need for fixes tag when addressing white space and text formatting issues. Not a bug fix.

> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/dax/fsdev.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
> index f74fd1bb7f4c5..dafa24761e8ff 100644
> --- a/drivers/dax/fsdev.c
> +++ b/drivers/dax/fsdev.c
> @@ -45,8 +45,8 @@ static void fsdev_write_dax(void *addr, struct page *page,
>  }
>  
>  static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> -			long nr_pages, enum dax_access_mode mode, void **kaddr,
> -			unsigned long *pfn)
> +		long nr_pages, enum dax_access_mode mode, void **kaddr,
> +		unsigned long *pfn)
>  {
>  	struct dev_dax *dev_dax = dax_get_private(dax_dev);
>  	size_t size = nr_pages << PAGE_SHIFT;
> @@ -90,7 +90,8 @@ static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,
>  	long rc;
>  
>  	WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);
> -	rc = __fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS, &kaddr, NULL);
> +	rc = __fsdev_dax_direct_access(dax_dev, pgoff, 1, DAX_ACCESS,
> +				       &kaddr, NULL);
>  	if (rc < 0)
>  		return rc;
>  	fsdev_write_dax(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);
> @@ -98,15 +99,15 @@ static int fsdev_dax_zero_page_range(struct dax_device *dax_dev,
>  }
>  
>  static long fsdev_dax_direct_access(struct dax_device *dax_dev,
> -		  pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,
> -		  void **kaddr, unsigned long *pfn)
> +		pgoff_t pgoff, long nr_pages, enum dax_access_mode mode,
> +		void **kaddr, unsigned long *pfn)
>  {
>  	return __fsdev_dax_direct_access(dax_dev, pgoff, nr_pages, mode,
>  					 kaddr, pfn);
>  }
>  
> -static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
> -		void *addr, size_t bytes, struct iov_iter *i)
> +static size_t fsdev_dax_recovery_write(struct dax_device *dax_dev,
> +		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
>  {
>  	return _copy_from_iter_flushcache(addr, bytes, i);
>  }

