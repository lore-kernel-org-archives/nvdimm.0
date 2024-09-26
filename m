Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5696284E1C;
	Thu, 26 Sep 2024 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727363720; cv=none; b=uaWo6WTQtnwAgxQBhIhdN6dABQNEU9GdRorKRuS8tnQbWs86A7f+KjLGGUo6BmJXtyHpqBo3qdLlyIPPwDYJoBM+JjS+djPu2FOSwu46f9xobhbpb8ir0MSuvoPpMdkDp0NviHAPctlwemmsCrIlYiazFjtybKe5PcM8TBfwX2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727363720; c=relaxed/simple;
	bh=YPzxdxvGESKuT97Yzzwzz/CT+lFMvs+6MCOdn6nyo/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E3zS6aW0oB3h3P/B2K9XArkFdyTvkD26gi5uFpPITMtOcCjbmkyAyT7NqNqxI426RAaINQgd6sLeeq2rIQjSW197cAcgyAv7uz+PLB+fqgAJnkTuXao7ipq8l6R1a2fRWDQ+/jc/5HKSvrOXc1KnypRGebutFjSeQuI7f+azTN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T3alerrp; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T3alerrp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727363718; x=1758899718;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YPzxdxvGESKuT97Yzzwzz/CT+lFMvs+6MCOdn6nyo/Q=;
  b=T3alerrpbVOifndGEYmQkLnF6tZPQifumU4ftppBsStN7Dp7EAtlUhvo
   wcGiTv3XAargUCx1btb3xCy/w5eygPuiN18RJm78pCQFa/fuy/TVEsi99
   PNP+RIrRIbQCMo/KMNqOwgX9WvO/A1wSmYMnNFMOoMNl32Z2ad2rV2Kr9
   RcsByuprKHcU4m1S7nc0AxtrnDE+Yc5OZrKKf4g+bSZrgeSB5jLw6Fjz0
   IfXzbMPUa8C/MDUYI4PVAH3pRMT9sKRjOK4vuxCm0hfW/eVPZeAfPqMID
   Ox31xZbi0wAZy5ICNpd1I5EUouM32Ud78P7fHF6j3PfP30BYsseVSZ0h8
   Q==;
X-CSE-ConnectionGUID: 1Zv4y5oySMi1QOeefZv+OA==
X-CSE-MsgGUID: 5ql8/81cRv+2/y++Jj1PMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11207"; a="26564375"
X-IronPort-AV: E=Sophos;i="6.11,155,1725346800"; 
   d="scan'208";a="26564375"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2024 08:15:17 -0700
X-CSE-ConnectionGUID: QVu2zMJ1RGaWVukMqY8elA==
X-CSE-MsgGUID: cZ/L4QykRWCZlO3gJeTlvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,155,1725346800"; 
   d="scan'208";a="77023727"
Received: from agladkov-desk.ger.corp.intel.com (HELO [10.125.111.194]) ([10.125.111.194])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2024 08:15:18 -0700
Message-ID: <fe8bc21c-b684-4a51-a1c4-2b58412a38d1@intel.com>
Date: Thu, 26 Sep 2024 08:15:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] nvdimm: Correct some typos in comments
To: Shen Lichuan <shenlichuan@vivo.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, pankaj.gupta.linux@gmail.com
Cc: nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
References: <20240926075700.10122-1-shenlichuan@vivo.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240926075700.10122-1-shenlichuan@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/26/24 12:57 AM, Shen Lichuan wrote:
> Fixed some confusing typos that were currently identified with codespell,
> the details are as follows:
> 
> -in the code comments:
> drivers/nvdimm/nd_virtio.c:100: repsonse ==> response
> drivers/nvdimm/pfn_devs.c:542: namepace ==> namespace
> drivers/nvdimm/pmem.c:319: reenable ==> re-enable
> 
> Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/nd_virtio.c | 2 +-
>  drivers/nvdimm/pfn_devs.c  | 2 +-
>  drivers/nvdimm/pmem.c      | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
> index f55d60922b87..c3f07be4aa22 100644
> --- a/drivers/nvdimm/nd_virtio.c
> +++ b/drivers/nvdimm/nd_virtio.c
> @@ -97,7 +97,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
>  		dev_info(&vdev->dev, "failed to send command to virtio pmem device\n");
>  		err = -EIO;
>  	} else {
> -		/* A host repsonse results in "host_ack" getting called */
> +		/* A host response results in "host_ack" getting called */
>  		wait_event(req_data->host_acked, req_data->done);
>  		err = le32_to_cpu(req_data->resp.ret);
>  	}
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 586348125b61..cfdfe0eaa512 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -539,7 +539,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  
>  	if (!nd_pfn->uuid) {
>  		/*
> -		 * When probing a namepace via nd_pfn_probe() the uuid
> +		 * When probing a namespace via nd_pfn_probe() the uuid
>  		 * is NULL (see: nd_pfn_devinit()) we init settings from
>  		 * pfn_sb
>  		 */
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 210fb77f51ba..d81faa9d89c9 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -316,7 +316,7 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>   * range, filesystem turns the normal pwrite to a dax_recovery_write.
>   *
>   * The recovery write consists of clearing media poison, clearing page
> - * HWPoison bit, reenable page-wide read-write permission, flush the
> + * HWPoison bit, re-enable page-wide read-write permission, flush the
>   * caches and finally write.  A competing pread thread will be held
>   * off during the recovery process since data read back might not be
>   * valid, and this is achieved by clearing the badblock records after

