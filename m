Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C85C18E358;
	Tue, 20 Aug 2024 20:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724184069; cv=none; b=FJPdeD2hakybXr3SrdJBYSW+rujWjwHjMQrFJFWE7hYC29TuzSpwh46B1NEonmiom8n1HmH6kycskifiRZH0GYg9pdje4B6XuzsRKAasDbEmyn2TjMMgWnFNQNoaK1PDGHxYgS+WzGtCps+CHUIiaeYqS4qPu4Dc/AG391F1gKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724184069; c=relaxed/simple;
	bh=G3RNvrfn/rmdf00KPduS38lywE22do+er0WoH4g8YbA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NO9oVlaZK2PVA6IXoza0ypHIujEJKNB5Wt8HmxJ19hMeH009cx2xfY/FL6QRE8kNYFXGQoVduWpnbvAPt8xc/rqSWu8dMz86eEcqoLDmFICQu/CDBUKvD24Ikr5Ui2E+LvCV9HJKR8t/0ea5RCNcAR/ARO3/TV021wCYfoxIhh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jy2cD4IT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jy2cD4IT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724184068; x=1755720068;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G3RNvrfn/rmdf00KPduS38lywE22do+er0WoH4g8YbA=;
  b=Jy2cD4ITsJtMdzU/Kw7aEP+0I/KAqLBSd+TVVGAz7SuUCXYJefDetfA0
   tvYQh9JDJVhgBUEyzstRcxjRccYLKiARFUgRdev/yVwyDUsp5dZMcTfvy
   jHOm6SIvPC+55nKLNy7wmcEcYdg0eiBxnhgIbG6+btBhNAS+EPIJm4DXh
   FGHbcEJzh7hLaEIVzd+9PDxCL83LK7BcjNcFZ1dKELQZrBtiIOEGjxhTP
   na8ch89pVzNdpZX70W4RUkSUGIws8dyiKSmmJy+jqGHnqZzR1TytR1n/C
   f8U/IXIUN1eo8H+SugR65fe9tpdVSSJv5gvJrlJa3Zt9S2VbAY6n63yTP
   g==;
X-CSE-ConnectionGUID: oFr0r9o1Qd+HxcfpxZJH2w==
X-CSE-MsgGUID: c6ip3+p6SIuA6nb/rbwhWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="40024039"
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="40024039"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:01:08 -0700
X-CSE-ConnectionGUID: MGtc9+LvRqKOvSc+fMRBOA==
X-CSE-MsgGUID: 8XHodfx9TNWZxV2ZJK5PSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="65199824"
Received: from cdpresto-mobl2.amr.corp.intel.com.amr.corp.intel.com (HELO [10.125.108.88]) ([10.125.108.88])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:01:07 -0700
Message-ID: <46eacc01-7b23-4f83-af3c-8c5897e44c90@intel.com>
Date: Tue, 20 Aug 2024 13:01:06 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_pmem: Check device status before requesting
 flush
To: Philip Chen <philipchen@chromium.org>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: virtualization@lists.linux.dev, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240820172256.903251-1-philipchen@chromium.org>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240820172256.903251-1-philipchen@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/24 10:22 AM, Philip Chen wrote:
> If a pmem device is in a bad status, the driver side could wait for
> host ack forever in virtio_pmem_flush(), causing the system to hang.
> 
> So add a status check in the beginning of virtio_pmem_flush() to return
> early if the device is not activated.
> 
> Signed-off-by: Philip Chen <philipchen@chromium.org>
> ---
> 
> v2:
> - Remove change id from the patch description
> - Add more details to the patch description
> 
>  drivers/nvdimm/nd_virtio.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index 35c8fbbba10e..97addba06539 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>  	unsigned long flags;
>  	int err, err1;
>  
> +	/*
> +	 * Don't bother to submit the request to the device if the device is
> +	 * not acticated.

s/acticated/activated/

> +	 */
> +	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
> +		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
> +		return -EIO;
> +	}
> +
>  	might_sleep();
>  	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
>  	if (!req_data)
