Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A177F602F
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 17:00:10 +0000 (UTC)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp1zW16bGz67tGk;
	Thu, 21 Jul 2022 00:55:35 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 20 Jul 2022 19:00:07 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 18:00:07 +0100
Date: Wed, 20 Jul 2022 18:00:05 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, "Matthew
 Wilcox" <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
	<nvdimm@lists.linux.dev>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 16/28] resource: Introduce alloc_free_mem_region()
Message-ID: <20220720180005.0000190d@Huawei.com>
In-Reply-To: <165784333333.1758207.13703329337805274043.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784333333.1758207.13703329337805274043.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.205.121]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 14 Jul 2022 17:02:13 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The core of devm_request_free_mem_region() is a helper that searches for
> free space in iomem_resource and performs __request_region_locked() on
> the result of that search. The policy choices of the implementation
> conform to what CONFIG_DEVICE_PRIVATE users want which is memory that is
> immediately marked busy, and a preference to search for the first-fit
> free range in descending order from the top of the physical address
> space.
> 
> CXL has a need for a similar allocator, but with the following tweaks:
> 
> 1/ Search for free space in ascending order
> 
> 2/ Search for free space relative to a given CXL window
> 
> 3/ 'insert' rather than 'request' the new resource given downstream
>    drivers from the CXL Region driver (like the pmem or dax drivers) are
>    responsible for request_mem_region() when they activate the memory
>    range.
> 
> Rework __request_free_mem_region() into get_free_mem_region() which
> takes a set of GFR_* (Get Free Region) flags to control the allocation
> policy (ascending vs descending), and "busy" policy (insert_resource()
> vs request_region()).
> 
> As part of the consolidation of the legacy GFR_REQUEST_REGION case with
> the new default of just inserting a new resource into the free space
> some minor cleanups like not checking for NULL before calling
> devres_free() (which does its own check) is included.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/linux-cxl/20220420143406.GY2120790@nvidia.com/
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Given you answered all my questions on v1, I'm fine with this.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
