Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801B5D302;
	Thu, 14 Dec 2023 08:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk+AZ+DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B431C433C8;
	Thu, 14 Dec 2023 08:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702542670;
	bh=XhtXMTLrB7TaL4OGwCq1/5AnWLeypq+BMzyNEqR5H9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kk+AZ+DVVomEJXbQK/IGA23dG4WisCKhVO6q/x+A8aiuX4YFdzwJtFgPHS/E2cJIK
	 /QDsWd4xgu5UuGhEXCmjVkOjVqZUiygkwA10BRlV00oZLJKvAP4CSEsygOj30LXQxU
	 ZPUuEX4HqOK/bucObq8W7oUoD5kusVE/ub0N7oKk=
Date: Thu, 14 Dec 2023 09:31:07 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Huang Ying <ying.huang@intel.com>, linux-mm@kvack.org,
	Li Zhijian <lizhijian@fujitsu.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v5 4/4] dax: add a sysfs knob to control memmap_on_memory
 behavior
Message-ID: <2023121453-tiling-banshee-5acd@gregkh>
References: <20231214-vv-dax_abi-v5-0-3f7b006960b4@intel.com>
 <20231214-vv-dax_abi-v5-4-3f7b006960b4@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214-vv-dax_abi-v5-4-3f7b006960b4@intel.com>

On Thu, Dec 14, 2023 at 12:37:57AM -0700, Vishal Verma wrote:
> +static ssize_t memmap_on_memory_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +
> +	return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);

checkpatch should have noticed that this should be sysfs_emit(), right?
If not, please make the change anyway.

> diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> index 6359f7bc9bf4..40d9965733b2 100644
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -134,3 +134,20 @@ KernelVersion:	v5.1
>  Contact:	nvdimm@lists.linux.dev
>  Description:
>  		(RO) The id attribute indicates the region id of a dax region.
> +
> +What:		/sys/bus/dax/devices/daxX.Y/memmap_on_memory
> +Date:		October, 2023

It's not October anymore :)

thanks,

greg k-h
