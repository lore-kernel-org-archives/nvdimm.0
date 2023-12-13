Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BC810E2
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 01:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIDWZCJT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702429939; x=1733965939;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=xDLeGxJti/7p/DdUxAtd3xkuT/lWYrK6WGVrDW9tWNU=;
  b=bIDWZCJT6SRZAUWa2BYscHe78kcQ1trBNL43+T0xAVYvuSeHtpb2Szpd
   aSdVitbPMCUwtXmuauC37LmEXD91IzqI+qtfNJhAGM9JVaqjr/ArXfhgl
   PzO+RhGtBr5T4h10kQyrJVj64HweDvsFZuqN+ez21A1SIWB/dFbD108wd
   UndAxPoeYWKYCjUtFyft/tDXNdiECkR0CiRa+KhphSE/ejOmx5hsKbe5k
   Uiv64s27E0OztBO3hs9o25pm28sGCZKQNFsxuhvWfhzQmR/T68KIq8vMc
   +MW/3YIOO/0QzjW2FSFsUGIWgjhmG1gqwoG/tzOcX19yeJ3XI9sAva9JA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="8272286"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="8272286"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 17:12:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="864422611"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="864422611"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 17:12:15 -0800
From: "Huang, Ying" <ying.huang@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,  Dave Jiang
 <dave.jiang@intel.com>,  <linux-kernel@vger.kernel.org>,
  <nvdimm@lists.linux.dev>,  <linux-cxl@vger.kernel.org>,  David
 Hildenbrand <david@redhat.com>,  "Dave Hansen"
 <dave.hansen@linux.intel.com>,  "Li Zhijian" <lizhijian@fujitsu.com>,
  Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v4 3/3] dax: add a sysfs knob to control
 memmap_on_memory behavior
In-Reply-To: <20231212-vv-dax_abi-v4-3-1351758f0c92@intel.com> (Vishal Verma's
	message of "Tue, 12 Dec 2023 12:08:32 -0700")
References: <20231212-vv-dax_abi-v4-0-1351758f0c92@intel.com>
	<20231212-vv-dax_abi-v4-3-1351758f0c92@intel.com>
Date: Wed, 13 Dec 2023 09:10:14 +0800
Message-ID: <87il52x5zd.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Vishal Verma <vishal.l.verma@intel.com> writes:

> Add a sysfs knob for dax devices to control the memmap_on_memory setting
> if the dax device were to be hotplugged as system memory.
>
> The default memmap_on_memory setting for dax devices originating via
> pmem or hmem is set to 'false' - i.e. no memmap_on_memory semantics, to
> preserve legacy behavior. For dax devices via CXL, the default is on.
> The sysfs control allows the administrator to override the above
> defaults if needed.
>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Tested-by: Li Zhijian <lizhijian@fujitsu.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/dax/bus.c                       | 32 ++++++++++++++++++++++++++++++++
>  Documentation/ABI/testing/sysfs-bus-dax | 17 +++++++++++++++++
>  2 files changed, 49 insertions(+)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index ce1356ac6dc2..423adee6f802 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1245,6 +1245,37 @@ static ssize_t numa_node_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(numa_node);
>  
> +static ssize_t memmap_on_memory_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +
> +	return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);
> +}
> +
> +static ssize_t memmap_on_memory_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t len)
> +{
> +	struct dax_device_driver *dax_drv = to_dax_drv(dev->driver);
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +	ssize_t rc;
> +	bool val;
> +
> +	rc = kstrtobool(buf, &val);
> +	if (rc)
> +		return rc;
> +
> +	guard(device)(dev);
> +	if (dev_dax->memmap_on_memory != val &&
> +	    dax_drv->type == DAXDRV_KMEM_TYPE)

Should we check "dev->driver != NULL" here, and should we move

        dax_drv = to_dax_drv(dev->driver);

here with device lock held?

--
Best Regards,
Huang, Ying

> +		return -EBUSY;
> +	dev_dax->memmap_on_memory = val;
> +
> +	return len;
> +}
> +static DEVICE_ATTR_RW(memmap_on_memory);
> +
>  static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
>  	struct device *dev = container_of(kobj, struct device, kobj);
> @@ -1271,6 +1302,7 @@ static struct attribute *dev_dax_attributes[] = {
>  	&dev_attr_align.attr,
>  	&dev_attr_resource.attr,
>  	&dev_attr_numa_node.attr,
> +	&dev_attr_memmap_on_memory.attr,
>  	NULL,
>  };
>  
> diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> index a61a7b186017..b1fd8bf8a7de 100644
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -149,3 +149,20 @@ KernelVersion:	v5.1
>  Contact:	nvdimm@lists.linux.dev
>  Description:
>  		(RO) The id attribute indicates the region id of a dax region.
> +
> +What:		/sys/bus/dax/devices/daxX.Y/memmap_on_memory
> +Date:		October, 2023
> +KernelVersion:	v6.8
> +Contact:	nvdimm@lists.linux.dev
> +Description:
> +		(RW) Control the memmap_on_memory setting if the dax device
> +		were to be hotplugged as system memory. This determines whether
> +		the 'altmap' for the hotplugged memory will be placed on the
> +		device being hotplugged (memmap_on_memory=1) or if it will be
> +		placed on regular memory (memmap_on_memory=0). This attribute
> +		must be set before the device is handed over to the 'kmem'
> +		driver (i.e.  hotplugged into system-ram). Additionally, this
> +		depends on CONFIG_MHP_MEMMAP_ON_MEMORY, and a globally enabled
> +		memmap_on_memory parameter for memory_hotplug. This is
> +		typically set on the kernel command line -
> +		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
