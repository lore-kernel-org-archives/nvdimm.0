Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795189681;
	b=uiSV5cOjJY8Xb6WJ2xPAg2LpWqBOfmKNFIWp9mdK1cQpR8kja1EyRNp1XL2cfefNPNNU
	 U+wi33H+INZ/t0ZZ6S9sYYbvqsxCiQcWq9Eah4CYrDsYmvMCbQQc2+GWf2Wl6uMtCRate
	 CgiW28fCC6a7weWEdsQD8E33QsdKOPR9MadsR0lzf5WgT5lAgQwCDGrZRrVRge6YEieS8
	 40XOKth47gD2zAG9e4QZxTwm+5QkyaUR+GlMQv90YNM2DS/V8Aks0QUOBUIA/0Neehf4P
	 jh1BNDZwMnj/HYJfnCg1uf4GQkynSV0ATB/Jzjvd0BIm+R0YDInal39mqdrrpBLD8ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795189681;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=3tRfYT9F+qLYbDdoQJAEbwo5ujW2pwpYQDxQNIxKTwc=;
	b=DuYvysst9VVO2nRTOckZDONkNJDlajz3BX/11xZTJZ1LtYQM67hXAIf+XU/HwZyLwvKS
	 pphMTqdVnWp1hoCP59GJA3Jx86NzLrHP7av4htsmlxCr3YlLrfrM6FWmKLQchIPv2Dueb
	 MDFth04tCJIZZGd8s6I9migdv2TX1SOtuLS2C8WG4wydd3JlEYfa94R/LcJTV75xaUbW9
	 Qf/mQ10Wre+UGnyeIPaJ+F8Q02l8yFIQjIapl/IW3thzFL+WOxER7kyMPtpkvvTZseoZk
	 jOy4x9UubmKPJRwb5l+byFWRMvmbdI4M6r4mZdsAZi/YyfnGl35cD6ShhND/LU0Ldew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GnLXHqC9;
	arc=none smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B86606A336
	for <nvdimm@lists.linux.dev>; Fri, 20 Nov 2026 15:48:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54B86606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GnLXHqC9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795189680; x=1826725680;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rY0W6DaBART7hRBtO74JyoGngDhXaNjblf8pvZikVpU=;
  b=GnLXHqC9OvK2Q58YR0lv6Oh+WHYgLMesxK1DgVtWAsxbBfDx+6+2QMGG
   z+LbgEeI6NPNrmAnBWswe3/6YZhq0f+LV5//SLsnB8GHZJo89cY6HGBU7
   K6gaJ09cOHxyz0bdWIcoMKwNwCRu7ptQkcp2ha+xU1p/2jywVaX4hyk7H
   Dh4wTCEgAtyQBwIfhfncje+QH++a5RTzo8lmbY+U+OSH+RFCIlr1YCXzs
   C50vRuqIwi73m18mr2CBGVMeWWSaxWpae3lUP8gBj879NbLYPGuewdyvu
   gJWL/MZcmCpjdl5JPxhkaKpIpWkvSMnk/OrSVu6FWKLboKUjxOyjAJy3/
   A==;
X-CSE-ConnectionGUID: xbxaE9rQTCewTQWQTT3vXQ==
X-CSE-MsgGUID: 9j+bGiP5QCuPpn0S2dXIjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3916511"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3916511"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 07:48:00 -0800
X-CSE-ConnectionGUID: Z8nBTrHcR5uCdm/6cSLbjQ==
X-CSE-MsgGUID: rLphzEoxS3K7iy31/YVltw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="10632751"
Received: from jjgreens-desk24.amr.corp.intel.com (HELO [10.125.109.138]) ([10.125.109.138])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 07:47:59 -0800
Message-ID: <0a0844b4-f0ce-47f2-b6f1-af45ad997155@intel.com>
Date: Fri, 20 Nov 2026 08:47:58 -0700
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
To: Vinod Koul <vkoul@kernel.org>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>,
 Frank Li <Frank.Li@kernel.org>
References: <20261103201547.4079847-1-dave.jiang@intel.com>
 <awAJxeXEA2yykiV-@parshuram>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <awAJxeXEA2yykiV-@parshuram>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/20/26 1:50 AM, Vinod Koul wrote:
> Hi Dave,
> 
> On 03-11-26, 13:15, Dave Jiang wrote:
>> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
>> people from keep emailing his address.
> 
> Can you please add the entry in Credits. We will miss Dan, his
> presence cannot go away, he stays always here.

I think Jason has already put those [1] in Credits and I've amended them for any missing entries. I definitely agree.

> 
> 
>>
>> async_tx will be essentially orphaned. There has been discussion of
>> deprecation for the feature on the dmaengine mailing list.
> 
> I think we can fold this one into dmaengine entry as well

Guess I'm not understanding how you want this to look. I just replaced with Frank for now as he requested [2].


[1]: https://lore.kernel.org/all/0-v1-52697321555d+14e66-tsm_maintainer_jgg@nvidia.com/
[2]: https://lore.kernel.org/linux-cxl/d6a3c6a9-71f7-406d-9ae9-33b3566768eb@intel.com/T/#t
