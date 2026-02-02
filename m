Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F08389469
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770054868; cv=none; b=gdzCRzmBj5fjuIrkBOXuB0lU4dqi0MWmBhQ7ghB3WCDTNKCBQ+8BkrIbGKSc6BWXfcWiV6rqvosTuKhRREPv+0/xtII9/J+mIlrI1eb6ttzeYkMw0EBCo5DFGiIdZLs94NxcZD6rpMTLQQgd73jR3npEM7sMnf6GQk0kcNCuDCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770054868; c=relaxed/simple;
	bh=+YVxmF2myapnZJzWAxzkwc1WbYzrAwrO+lR9xUfX84s=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQ4FLspR86iZY27ESBEASXYriPjFqgGXoYStVYKfX551vjQkl+EwrwcGIuldlVrgdq/9Gi1wV+V3i1Bo9a13CKngN+MkqOTjz1yfFh7LqYlr7cFWZxdOEuf8HVZ4O7LK7n+QWvY0wtySbY+gBUtmWqwzDC3NxRrXHMMB8YCrEFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Z3Q42MMzHnGgg;
	Tue,  3 Feb 2026 01:53:22 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 546A140572;
	Tue,  3 Feb 2026 01:54:20 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 17:54:19 +0000
Date: Mon, 2 Feb 2026 17:54:17 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>
Subject: Re: [PATCH 4/9] drivers/cxl,dax: add dax driver mode selection for
 dax regions
Message-ID: <20260202175417.00000abe@huawei.com>
In-Reply-To: <20260129210442.3951412-5-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-5-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 29 Jan 2026 16:04:37 -0500
Gregory Price <gourry@gourry.net> wrote:

> CXL regions may wish not to auto-configure their memory as dax kmem,
> but the current plumbing defaults all cxl-created dax devices to the
> kmem driver.  This exposes them to hotplug policy, even if the user
> intends to use the memory as a dax device.
> 
> Add plumbing to allow CXL drivers to select whether a DAX region should
> default to kmem (DAXDRV_KMEM_TYPE) or device (DAXDRV_DEVICE_TYPE).
> 
> Add a 'dax_driver' field to struct cxl_dax_region and update
> devm_cxl_add_dax_region() to take a dax_driver_type parameter.
> 
> In drivers/dax/cxl.c, the IORESOURCE_DAX_KMEM flag used by dax driver
> matching code is now set conditionally based on dax_region->dax_driver.
> 
> Exports `enum dax_driver_type` to linux/dax.h for use in the cxl driver.
> 
> All current callers pass DAXDRV_KMEM_TYPE for backward compatibility.
> 
> Cc: John Groves <john@jagalactic.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
LGTM
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


