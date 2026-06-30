Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE0E323417
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 23:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782861717; cv=none; b=aUcfwSjxSVTBKxXyMppk54G59UqjYnkjMkhlF5STMivXxMcwvXdisI60JIF03n3S2xsh5q/8kMfvcyUKV4SrcdSXo0DLSCJhbtm4FxS1mBaBazZ5jnTbkM61nBvXEwLGtBdPMBZcizy76WU9vmJoMTUv9ZY2lJrc4Ed2Ac3o07Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782861717; c=relaxed/simple;
	bh=UhW8eWzfFW6yrzeJ7hIRACnPmZRODtxNX3+GshGuBGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSNBqq8eT4GyB1apeD07G1afXTvHZ39npHXxV7i40HcCdfkNqdmbY/A4nb3OHjb+Azn6gzAE6QCFVbgaK++H75mET6HWpOhOKfAhYFWqSFyXHdn6huxjB1zsMMgnsCCMzF7M5zChJll5gTYy9R/agOJzAL16elFmuozVxpbVTdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GepNzVPo; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GepNzVPo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782861715; x=1814397715;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UhW8eWzfFW6yrzeJ7hIRACnPmZRODtxNX3+GshGuBGk=;
  b=GepNzVPosCecrZLiMI+YY+Mw7nwOxe1GI7UtcxM0RXiurHmg3ke/813q
   XoxV7KyfsKmi2v9LQB/xKvkRM5GEyCd/J6FMnGCr2sYeFujx3uwQp83LC
   44CninziwJ8D2+0hgC6XBJfh22/jw9OFjTHccRktkrfpr4HDcrDMtNnWt
   fuOjf2Eu5zcBg6tT0ECC5MMZmrOCIoxzhE4rhHDd6Fc/askEj8e/3bL3r
   yZF9VOAUmtlNFHc2IETNXOLAnitb9xAGjRdEnTp0/qHYLmo04UwnyVpDJ
   ChM74wHyjUZ8OrzL2E9egJ2yA2zWjaTb8vWR8N/qVbhXZFLf0ATz3V5yk
   A==;
X-CSE-ConnectionGUID: JtMqzJYeRXShyqCFSPfLlg==
X-CSE-MsgGUID: CPoWq628Smq2j/eilzcaAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87268633"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="87268633"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 16:21:54 -0700
X-CSE-ConnectionGUID: BRv9+SekRy6PGEe3aCN1dQ==
X-CSE-MsgGUID: mNSifp1dQgycAKonsWS+Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="250683981"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.110.30]) ([10.125.110.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 16:21:53 -0700
Message-ID: <23e0d98f-e2ba-452e-8266-1d09fb61b7ba@intel.com>
Date: Tue, 30 Jun 2026 16:21:52 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 24/31] dax/bus: Add uuid sysfs attribute to dax
 devices
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-25-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-25-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 6/25/26 4:05 AM, Anisa Su wrote:
> Introduce a read-write 'uuid' sysfs entry at
> /sys/bus/dax/devices/daxX.Y/ with stubbed handlers: show returns the
> null uuid and store returns -EOPNOTSUPP.  A follow-on patch wires both
> directions to dax_resource tracking.
> 
> Document the attribute in the dax sysfs ABI.
> 
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> 
> ---
> Changes:
> - uuid_show() emits the null uuid ("%pUb" of uuid_null) instead of "0".
> - ABI: describe the no-uuid read value as a null uuid instead of "0";
>   bump Date to June, 2026 and KernelVersion to v7.3.
> ---
>  Documentation/ABI/testing/sysfs-bus-dax | 18 ++++++++++++++++++
>  drivers/dax/bus.c                       | 14 ++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> index b34266bfae49..3219c09dea01 100644
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -59,6 +59,24 @@ Description:
>  		backing device for this dax device, emit the CPU node
>  		affinity for this device.
>  
> +What:		/sys/bus/dax/devices/daxX.Y/uuid
> +Date:		June, 2026
> +KernelVersion:	v7.3
> +Contact:	nvdimm@lists.linux.dev
> +Description:
> +		(RW) On read, reports the uuid identifying the capacity
> +		backing this dax device.  A null uuid (all-zeroes) indicates
> +		that the device has no associated uuid — either it is not
> +		backed by DCD capacity, or the backing extents are untagged.
> +
> +		Writes are accepted only on dax devices in sparse (DCD)
> +		regions; writes to non-sparse devices return -EOPNOTSUPP.
> +		Writing a non-null uuid claims every dax_resource in the
> +		parent region whose tag matches the written uuid, consuming
> +		any available capacity in each matching resource.  Writing
> +		"0" is shorthand for the null uuid and claims a single
> +		untagged dax_resource.
> +
>  What:		/sys/bus/dax/devices/daxX.Y/target_node
>  Date:		February, 2019
>  KernelVersion:	v5.1
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index ffa6b303fc9b..f61309a6f934 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1573,6 +1573,19 @@ static ssize_t numa_node_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(numa_node);
>  
> +static ssize_t uuid_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%pUb\n", &uuid_null);
> +}
> +
> +static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
> +			  const char *buf, size_t len)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static DEVICE_ATTR_RW(uuid);
> +
>  static ssize_t memmap_on_memory_show(struct device *dev,
>  				     struct device_attribute *attr, char *buf)
>  {
> @@ -1644,6 +1657,7 @@ static struct attribute *dev_dax_attributes[] = {
>  	&dev_attr_resource.attr,
>  	&dev_attr_numa_node.attr,
>  	&dev_attr_memmap_on_memory.attr,
> +	&dev_attr_uuid.attr,
>  	NULL,
>  };
>  

