Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0878B2EA494
	for <nvdimm@lists.linux.dev>; Mon, 30 Jun 2025 21:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317345; cv=none; b=i4Vb4DSK+MJJYq/z7SbrUjODoNZj603khCDXmlj53I4XLKzOZT9nWay4wQAMZSQzzZ5HKmTSf+ECQNBATrbGuNQafeQCcJ73nGM66qmc0jwTNAOQ1b+d0zJK4euFWPaUdcb0Y6Ub7aOHQgbovMcwaKFdDa9dBTFvLVKPjGNWfCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317345; c=relaxed/simple;
	bh=RQ9Ky/6/KVQ3YUcfQQ7KC4jRAwp+hsO8cL8Q6Owvs1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OAaHi8evtuRxFkJaOJrmc4k4qlYL1KqKygFD7+pQy4zXQQCSPHppx3fegpjY2esN5zhVsb7RJWZSl2TJ9er6WcQir6Y5bzcMgeV4/DRfXlKLOQte3WTIkDKSt9Ck+ph9hIsSkJuh6ceBDr7jUbdK3SL/7RB9GlocllbsXJk+5V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ydpb2oxV; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ydpb2oxV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751317344; x=1782853344;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RQ9Ky/6/KVQ3YUcfQQ7KC4jRAwp+hsO8cL8Q6Owvs1M=;
  b=Ydpb2oxVNyge7glDxKVXdjDoS3izYcBB4pW7/FIn8UeI2efLdnG2jueo
   OsXhYw4w+W1C5atg7NyRqx900DclbW3WUICYf9lHjT47ycjAdvM8k2mxM
   J75syXpY3+vgPaVowSsR/GeKji0hXcXLOr1eMOsdmU3C16eKPRPeF9JWA
   bzfA/UfLbozqRIJORrDvoWLvycXMRjzSFvU3uPR7GjzWLaDuSmqNKsHGf
   R9vQjolb9NKQ+JqBgA8qVlJ8U236AoX52tPL2DqwBUbzLoiWVAjqfREcZ
   Q3v5CEVWHiceJMg7F/mVv+/DawOWYrxawNxH+szE3B72QlXIwjGUGAbnS
   Q==;
X-CSE-ConnectionGUID: TGxQjWPkQwm/c/6d6mS1Sw==
X-CSE-MsgGUID: QVdd5rjzR2mGgDw7Kc9Phw==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="52673078"
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="52673078"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 14:02:23 -0700
X-CSE-ConnectionGUID: AFPzN98XQZeEffui51iWSw==
X-CSE-MsgGUID: Ky0175FOTA2fRhpPFkMh7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="154032796"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.125.109.132]) ([10.125.109.132])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 14:02:23 -0700
Message-ID: <4e10c38d-cca3-49c2-a5d8-449fd1c0d9d2@intel.com>
Date: Mon, 30 Jun 2025 14:02:22 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] libnvdimm: Don't use "proxy" headers
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>
References: <20250627142001.994860-1-andriy.shevchenko@linux.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250627142001.994860-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/27/25 7:19 AM, Andy Shevchenko wrote:
> Update header inclusions to follow IWYU (Include What You Use)
> principle.
> 
> Note that kernel.h is discouraged to be included as it's written
> at the top of that file.
> 
> While doing that, sort headers alphabetically.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> 
> v2: reshuffled includes and forward declarations (Ira)
> 
>  include/linux/libnvdimm.h | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index e772aae71843..28f086c4a187 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -6,12 +6,12 @@
>   */
>  #ifndef __LIBNVDIMM_H__
>  #define __LIBNVDIMM_H__
> -#include <linux/kernel.h>
> +
> +#include <linux/io.h>
>  #include <linux/sizes.h>
> +#include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <linux/uuid.h>
> -#include <linux/spinlock.h>
> -#include <linux/bio.h>
>  
>  struct badrange_entry {
>  	u64 start;
> @@ -80,7 +80,9 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
>  		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
>  		unsigned int buf_len, int *cmd_rc);
>  
> +struct attribute_group;
>  struct device_node;
> +struct module;
>  struct nvdimm_bus_descriptor {
>  	const struct attribute_group **attr_groups;
>  	unsigned long cmd_mask;
> @@ -121,6 +123,8 @@ struct nd_mapping_desc {
>  	int position;
>  };
>  
> +struct bio;
> +struct resource;
>  struct nd_region;
>  struct nd_region_desc {
>  	struct resource *res;
> @@ -147,8 +151,6 @@ static inline void __iomem *devm_nvdimm_ioremap(struct device *dev,
>  	return (void __iomem *) devm_nvdimm_memremap(dev, offset, size, 0);
>  }
>  
> -struct nvdimm_bus;
> -
>  /*
>   * Note that separate bits for locked + unlocked are defined so that
>   * 'flags == 0' corresponds to an error / not-supported state.
> @@ -238,6 +240,9 @@ struct nvdimm_fw_ops {
>  	int (*arm)(struct nvdimm *nvdimm, enum nvdimm_fwa_trigger arg);
>  };
>  
> +struct kobject;
> +struct nvdimm_bus;
> +
>  void badrange_init(struct badrange *badrange);
>  int badrange_add(struct badrange *badrange, u64 addr, u64 length);
>  void badrange_forget(struct badrange *badrange, phys_addr_t start,

