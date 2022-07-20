Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4366015
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 16:03:14 +0000 (UTC)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp0l46d7Qz67HnK;
	Wed, 20 Jul 2022 23:59:44 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 18:03:11 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 17:03:10 +0100
Date: Wed, 20 Jul 2022 17:03:06 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, "Tony
 Luck" <tony.luck@intel.com>, Christoph Hellwig <hch@lst.de>,
	<nvdimm@lists.linux.dev>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 03/28] cxl/acpi: Track CXL resources in
 iomem_resource
Message-ID: <20220720170306.00003987@Huawei.com>
In-Reply-To: <165784325943.1758207.5310344844375305118.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784325943.1758207.5310344844375305118.stgit@dwillia2-xfh.jf.intel.com>
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

On Thu, 14 Jul 2022 17:00:59 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Recall that CXL capable address ranges, on ACPI platforms, are published
> in the CEDT.CFMWS (CXL Early Discovery Table: CXL Fixed Memory Window
> Structures). These windows represent both the actively mapped capacity
> and the potential address space that can be dynamically assigned to a
> new CXL decode configuration (region / interleave-set).
> 
> CXL endpoints like DDR DIMMs can be mapped at any physical address
> including 0 and legacy ranges.
> 
> There is an expectation and requirement that the /proc/iomem interface
> and the iomem_resource tree in the kernel reflect the full set of
> platform address ranges. I.e. that every address range that platform
> firmware and bus drivers enumerate be reflected as an iomem_resource
> entry. The hard requirement to do this for CXL arises from the fact that
> facilities like CONFIG_DEVICE_PRIVATE expect to be able to treat empty
> iomem_resource ranges as free for software to use as proxy address
> space. Without CXL publishing its potential address ranges in
> iomem_resource, the CONFIG_DEVICE_PRIVATE mechanism may inadvertently
> steal capacity reserved for runtime provisioning of new CXL regions.
> 
> So, iomem_resource needs to know about both active and potential CXL
> resource ranges. The active CXL resources might already be reflected in
> iomem_resource as "System RAM". insert_resource_expand_to_fit() handles
> re-parenting "System RAM" underneath a CXL window.
> 
> The "_expand_to_fit()" behavior handles cases where a CXL window is not
> a strict superset of an existing entry in the iomem_resource tree. The
> "_expand_to_fit()" behavior is acceptable from the perspective of
> resource allocation. The expansion happens because a conflicting
> resource range is already populated, which means the resource boundary
> expansion does not result in any additional free CXL address space being
> made available. CXL address space allocation is always bounded by the
> orginal unexpanded address range.
> 
> However, the potential for expansion does mean that something like
> walk_iomem_res_desc(IORES_DESC_CXL...) can only return fuzzy answers on
> corner case platforms that cause the resource tree to expand a CXL
> window resource over a range that is not decoded by CXL. This would be
> an odd platform configuration, but if it becomes a problem in practice
> the CXL subsytem could just publish an API that returns definitive
> answers.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I wish this was a bit simpler, (particularly the complex relationship
between the places res is added vs single cleanup location) but having
stared at it for a while I can't figure out a way that works.. *defeated*
:)
 
