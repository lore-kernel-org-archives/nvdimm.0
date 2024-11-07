Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2213F20A5E3
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 11:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730979132; cv=none; b=oDRYM+iKRKQL2Y/ciQBn10I9UoriSL6ipi7Z6l7gAeiA6iWU4FD7MQkSp1V9az2gxyyP4VJrC3jjUlCmRF0tS+/Dvoq0Tk1hPQU1h4ikqcuvQEahOCWD+ZvnCJE3F3t0h2GH5IxmEMuULGgrKplOgmcIYU7AXuHwaS35zQxKxc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730979132; c=relaxed/simple;
	bh=oWZpsdzL8+Oft8QnzpI3UMaHxsB9xIpuOeSvk8blJiE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVb+TtypOmEXZhblwXy+0UzSFLWOK02QI2O2JVYos/02dSVE3n7fhwQ4XNz/TsZ3qVsSHBt4DgmshaDo47V7io08LaSrln9s3wTn5ybSKw9yAkjjLPf2bWoSGGG07P64tdD3w0HxgSB4/4ULDVsqhrNf0pD4mG/+la3z+TqiUOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Xkg0401xQz6LD8H;
	Thu,  7 Nov 2024 19:32:04 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D48DC1400DD;
	Thu,  7 Nov 2024 19:32:07 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 7 Nov
 2024 12:32:07 +0100
Date: Thu, 7 Nov 2024 11:32:05 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 23/27] dax/region: Create resources on sparse DAX
 regions
Message-ID: <20241107113205.00007f53@Huawei.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-23-85c7fa2140fe@intel.com>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
	<20241105-dcd-type2-upstream-v6-23-85c7fa2140fe@intel.com>
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
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 05 Nov 2024 12:38:45 -0600
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
> to signaling the release complete.
> 
> Speculative writes after a release may dirty the cache such that a read
> from a newly surfaced extent may not come from the device.  Call
> cxl_region_invalidate_memregion() prior to bringing a new extent online
> to ensure the cache is marked invalid.
> 
> While these invalidate calls are inefficient they are the best we can do
> to ensure cache consistency without back invalidate.  Furthermore this
> should occur infrequently with sufficiently large extents and work loads
> to not be too bad of an impact.
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
Same again.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
