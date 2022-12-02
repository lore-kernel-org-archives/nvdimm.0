Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1204C71
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 15:42:33 +0000 (UTC)
Received: from frapeml100002.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNxvF0ZWPz6HJWY;
	Fri,  2 Dec 2022 23:39:21 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100002.china.huawei.com (7.182.85.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 16:42:30 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 15:42:30 +0000
Date: Fri, 2 Dec 2022 15:42:29 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Robert Richter <rrichter@amd.com>,
	<alison.schofield@intel.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 03/12] cxl/pmem: Refactor nvdimm device registration,
 delete the workqueue
Message-ID: <20221202154229.00004673@Huawei.com>
In-Reply-To: <166993041773.1882361.16444301376147207609.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993041773.1882361.16444301376147207609.stgit@dwillia2-xfh.jf.intel.com>
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
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 01 Dec 2022 13:33:37 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> The three objects 'struct cxl_nvdimm_bridge', 'struct cxl_nvdimm', and
> 'struct cxl_pmem_region' manage CXL persistent memory resources. The
> bridge represents base platform resources, the nvdimm represents one or
> more endpoints, and the region is a collection of nvdimms that
> contribute to an assembled address range.
> 
> Their relationship is such that a region is torn down if any component
> endpoints are removed. All regions and endpoints are torn down if the
> foundational bridge device goes down.
> 
> A workqueue was deployed to manage these interdependencies, but it is
> difficult to reason about, and fragile. A recent attempt to take the CXL
> root device lock in the cxl_mem driver was reported by lockdep as
> colliding with the flush_work() in the cxl_pmem flows.
> 
> Instead of the workqueue, arrange for all pmem/nvdimm devices to be torn
> down immediately and hierarchically. A similar change is made to both
> the 'cxl_nvdimm' and 'cxl_pmem_region' objects. For bisect-ability both
> changes are made in the same patch which unfortunately makes the patch
> bigger than desired.
> 
> Arrange for cxl_memdev and cxl_region to register a cxl_nvdimm and
> cxl_pmem_region as a devres release action of the bridge device.
> Additionally, include a devres release action of the cxl_memdev or
> cxl_region device that triggers the bridge's release action if an endpoint
> exits before the bridge. I.e. this allows either unplugging the bridge,
> or unplugging and endpoint to result in the same cleanup actions.
> 
> To keep the patch smaller the cleanup of the now defunct workqueue
> infrastructure is saved for a follow-on patch.
> 
> Tested-by: Robert Richter <rrichter@amd.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I wouldn't say it's the most confident review tag I've ever given, but I've
taken another look at it and couldn't identify any remaining issues...

So with that in mind
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>



