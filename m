Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4B8192D69
	for <nvdimm@lists.linux.dev>; Thu,  5 Dec 2024 23:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733441436; cv=none; b=MCl15DyEJt6kHgivtGzTEZ15F+6bCJ1jbjDGnTqYPhklw74B7XbtVuJJ1Qbdbg9hntIpY136TlaWV+5tHrhA0v4cbOEC/tic68jcfOIN/QwcxNDjIhLdh7Iq3whMsbOpP+LY0B1mhw9pVeDvdHAudU4QE5V9p4kfVO3xY4ZXWQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733441436; c=relaxed/simple;
	bh=I/Bbmecpn8RogQU7kB8TZf0KJSzLC1/N7kmtot7TRMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HB3tA11pz7riu8Tb1uuAQuBp++WkYM9+IglloJ5HZcVYz06JpoRb1tdKkphj2xFIUcGveJ8Nonlem0Ba0PLSyWFC/etGKrRYbI8H/+9DqZS6eTrMQrzGrJhn0Aioex14RlSBJpJGhbAas8B3IiW5vPguqV/pUQBqw7PrMEMj2iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JE0tvGEW; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JE0tvGEW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733441434; x=1764977434;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I/Bbmecpn8RogQU7kB8TZf0KJSzLC1/N7kmtot7TRMo=;
  b=JE0tvGEWNjPJAckGWBnkJ7c+VSFyRVxcSyzR34a+kUsYPxaXxAY3cFiW
   GIWPe1WmQlkNqzEUY/YAWpTvrVszAYSVUMFtdos2TmpqhATdGj3ePoQYL
   AZiJ6G9c/fJnyANFabFOGkm5wf+R6skCvG3pT77yBZ88pBzvIrVBjiuYi
   6kAsKNFTzYxpwwzaFb7GHfyyllHGXzWNot93Zvz+xI+ZzeqJjWwN/f5Sh
   92wArqHtnDOcQYw7WWTOvG4l4sdvi8K9PC+FGeyqiJt5DUP1XaPXIxWb3
   80oxed/zdnuBbBz7GbW3/Y9mXUfDzv7De+Aww/QTBMLeNht0otfO/qiLR
   g==;
X-CSE-ConnectionGUID: Ew6Qk2zQS7uFk1wHZ2fF0g==
X-CSE-MsgGUID: OS4iii+qTM22gF/o0LHfPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="37564423"
X-IronPort-AV: E=Sophos;i="6.12,211,1728975600"; 
   d="scan'208";a="37564423"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 15:30:34 -0800
X-CSE-ConnectionGUID: kigTlvqHQOmnUT1IudSx6A==
X-CSE-MsgGUID: FlGBZXefRl6sPWVdfnP/5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,211,1728975600"; 
   d="scan'208";a="98312134"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.108.192])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 15:30:31 -0800
Date: Thu, 5 Dec 2024 15:30:29 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Zijun Hu <zijun_hu@icloud.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@kernel.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas@t-8ch.de>,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-sound@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-block@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, arm-scmi@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-gpio@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org,
	linux-hwmon@vger.kernel.org, linux-media@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
	linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
	netdev@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
Subject: Re: [PATCH v3 01/11] libnvdimm: Simplify nd_namespace_store()
 implementation
Message-ID: <Z1I3lSpcnIIbc7S1@aschofie-mobl2.lan>
References: <20241205-const_dfc_done-v3-0-1611f1486b5a@quicinc.com>
 <20241205-const_dfc_done-v3-1-1611f1486b5a@quicinc.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205-const_dfc_done-v3-1-1611f1486b5a@quicinc.com>

On Thu, Dec 05, 2024 at 08:10:10AM +0800, Zijun Hu wrote:
> From: Zijun Hu <quic_zijuhu@quicinc.com>

Hi Zihun,

Similar to my comment on Patch 10/11, this commit msg can be
explicit:

libnvdimm: Replace namespace_match() w device_find_child_by_name()

> 
> Simplify nd_namespace_store() implementation by  device_find_child_by_name()
                                                  ^using 

Otherwise you can add:
Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  drivers/nvdimm/claim.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index 030dbde6b0882050c90fb8db106ec15b1baef7ca..9e84ab411564f9d5e7ceb687c6491562564552e3 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -67,13 +67,6 @@ bool nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
>  	return claimed;
>  }
>  
> -static int namespace_match(struct device *dev, void *data)
> -{
> -	char *name = data;
> -
> -	return strcmp(name, dev_name(dev)) == 0;
> -}
> -
>  static bool is_idle(struct device *dev, struct nd_namespace_common *ndns)
>  {
>  	struct nd_region *nd_region = to_nd_region(dev->parent);
> @@ -168,7 +161,7 @@ ssize_t nd_namespace_store(struct device *dev,
>  		goto out;
>  	}
>  
> -	found = device_find_child(dev->parent, name, namespace_match);
> +	found = device_find_child_by_name(dev->parent, name);
>  	if (!found) {
>  		dev_dbg(dev, "'%s' not found under %s\n", name,
>  				dev_name(dev->parent));
> 
> -- 
> 2.34.1
> 
> 
