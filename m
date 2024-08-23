Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3269189509
	for <nvdimm@lists.linux.dev>; Fri, 23 Aug 2024 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724432386; cv=none; b=Mb/uJnhs5HV5f4TFqSi1DFXowGQl631sqzSoyiI2/3FnGLy9wMXS8myOXlh0DzgmBhCrfQ9B322ZFrjUIlQdZNdy+XBIyl7O6JEjiIe5NpM3f0OaTsLM+1ovgL8FVJRv+aTUlWHJJyz0VDXygVVlCCPpAROZn8kMz91mA06721g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724432386; c=relaxed/simple;
	bh=e+hxT2QDndoJ143ERmmrHsR0wbLLWxCriqNkKR1iRdU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdxdzflhHEDvqo6fZ83TkoHf4Fb0lMid+AgPffsmtU4IbtUi/9mlKo9Jk6QhIEaz/jZIKbJPa8uTQ8iar8ZogbqH5GHwNy+hL82YINt1oWm5g7Xc4KWPwaTrp56k6QJJ/op9HZ7RcUxpHukoPwqjlplpo7WqRp5cQfxpRut1J3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wr5mp37sSz6J6Bp;
	Sat, 24 Aug 2024 00:55:54 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 16902140A35;
	Sat, 24 Aug 2024 00:59:40 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 23 Aug
 2024 17:59:39 +0100
Date: Fri, 23 Aug 2024 17:59:38 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Chris Mason <clm@fb.com>, Josef Bacik
	<josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Petr Mladek
	<pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-btrfs@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3 13/25] cxl/region: Add sparse DAX region support
Message-ID: <20240823175938.00000917@Huawei.com>
In-Reply-To: <20240816-dcd-type2-upstream-v3-13-7c9b96cba6d7@intel.com>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
	<20240816-dcd-type2-upstream-v3-13-7c9b96cba6d7@intel.com>
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
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 16 Aug 2024 09:44:21 -0500
ira.weiny@intel.com wrote:

> From: Navneet Singh <navneet.singh@intel.com>
> 
> Dynamic Capacity CXL regions must allow memory to be added or removed
> dynamically.  In addition to the quantity of memory available the
> location of the memory within a DC partition is dynamic based on the
> extents offered by a device.  CXL DAX regions must accommodate the
> sparseness of this memory in the management of DAX regions and devices.
> 
> Introduce the concept of a sparse DAX region.  Add a create_dc_region()
> sysfs entry to create such regions.  Special case DC capable regions to
> create a 0 sized seed DAX device to maintain compatibility which
> requires a default DAX device to hold a region reference.
> 
> Indicate 0 byte available capacity until such time that capacity is
> added.
> 
> Sparse regions complicate the range mapping of dax devices.  There is no
> known use case for range mapping on sparse regions.  Avoid the
> complication by preventing range mapping of dax devices on sparse
> regions.
> 
> Interleaving is deferred for now.  Add checks.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

