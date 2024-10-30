Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B221EABA4
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730299463; cv=none; b=Fx+Vah5xEY4nhbvaeV8W3S2vW2IwCZ2rTJsA/VFgyIpKNkt/A9L1KLNk4aimv3++RC/Deyq6cowBJy+q0adlE6wlGHamKZAKUpII7l7ilJfNviG+p5JVZzwOg0WFOhBQbOl8vU0pdn2t/BsQQc4kpvMVdPN17ZMyV+f2HgYyDhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730299463; c=relaxed/simple;
	bh=F2p1CIBhsgGPCFP7JP4hFpvJnWXOIzEKAIw73T3SjtE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WEjVIVbZPhE57850+A+NmTpDPDhmJE/EOrG7Z2ji/30rACiD7f04RM5yYLvYQWqID17tnTX8Jzo7NgoFIBTnNbOVnqD2sgG1n31GeJVa5g8Qp239znh/wV6sxSfB2dQJ7B9BCw4+pRvlds6EYWwNGMYbksAIgdKMD6BerklHMZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XdqWs0Gy4z6GDsD;
	Wed, 30 Oct 2024 22:39:21 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 44F3C140498;
	Wed, 30 Oct 2024 22:44:12 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 30 Oct
 2024 15:44:11 +0100
Date: Wed, 30 Oct 2024 14:44:10 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 23/27] dax/region: Create resources on sparse DAX
 regions
Message-ID: <20241030144410.00001be7@Huawei.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-23-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
	<20241029-dcd-type2-upstream-v5-23-8739cb67c374@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 29 Oct 2024 15:34:58 -0500
ira.weiny@intel.com wrote:

> From: Navneet Singh <navneet.singh@intel.com>
> 
> DAX regions which map dynamic capacity partitions require that memory be
> allowed to come and go.  Recall sparse regions were created for this
> purpose.  Now that extents can be realized within DAX regions the DAX
> region driver can start tracking sub-resource information.
> 
> The tight relationship between DAX region operations and extent
> operations require memory changes to be controlled synchronously with
> the user of the region.  Synchronize through the dax_region_rwsem and by
> having the region driver drive both the region device as well as the
> extent sub-devices.
> 
> Recall requests to remove extents can happen at any time and that a host
> is not obligated to release the memory until it is not being used.  If
> an extent is not used allow a release response.
> 
> When extents are eligible for release.  No mappings exist but data may
> reside in caches not yet written to the device.  Call
> cxl_region_invalidate_memregion() to write back data to the device prior
> to signaling the release complete.  This is inefficient but is the best
> we can do at the moment and should occur infrequently with sufficiently
> large extents and work loads.
> 
> The DAX layer has no need for the details of the CXL memory extent
> devices.  Expose extents to the DAX layer as device children of the DAX
> region device.  A single callback from the driver aids the DAX layer to
> determine if the child device is an extent.  The DAX layer also
> registers a devres function to automatically clean up when the device is
> removed from the region.
> 
> There is a race between extents being surfaced and the dax_cxl driver
> being loaded.  The driver must therefore scan for any existing extents
> while still under the device lock.
> 
> Respond to extent notifications.  Manage the DAX region resource tree
> based on the extents lifetime.  Return the status of remove
> notifications to lower layers such that it can manage the hardware
> appropriately.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
One typo spotted.

Otherwise seems fine to me but not an area I know well yet!

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 0867115aeef2e1b2d4c88b5c38b6648a404b1060..8ebbc4808c3509ff17ac3af045505dc42c003fb0 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h

> +/**
> + * struct dax_resource - For sparse regions; an active resource
> + * @region: dax_region this resources is in
> + * @res: resource
> + * @use_cnt: count the number of uses of this resource
> + *
> + * Changes to the dax_reigon and the dax_resources within it are protected by
dax_region

> + * dax_region_rwsem
> + *
> + * dax_resource's are not intended to be used outside the dax layer.
> + */
> +struct dax_resource {
> +	struct dax_region *region;
> +	struct resource *res;
> +	unsigned int use_cnt;
> +};

