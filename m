Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C62E4C64
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 15:02:38 +0000 (UTC)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNx194SnRz689QP;
	Fri,  2 Dec 2022 22:59:25 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Fri, 2 Dec 2022 16:02:34 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 15:02:34 +0000
Date: Fri, 2 Dec 2022 15:02:33 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Robert Richter <rrichter@amd.com>,
	<alison.schofield@intel.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 01/12] cxl/acpi: Simplify cxl_nvdimm_bridge probing
Message-ID: <20221202150233.00003aa4@Huawei.com>
In-Reply-To: <166993040668.1882361.7450361097265836752.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993040668.1882361.7450361097265836752.stgit@dwillia2-xfh.jf.intel.com>
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
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 01 Dec 2022 13:33:26 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> The 'struct cxl_nvdimm_bridge' object advertises platform CXL PMEM
> resources. It coordinates with libnvdimm to attach nvdimm devices and
> regions for each corresponding CXL object. That coordination is
> complicated, i.e. difficult to reason about, and it turns out redundant.
> It is already the case that the CXL core knows how to tear down a
> cxl_region when a cxl_memdev goes through ->remove(), so that pathway
> can be extended to directly cleanup cxl_nvdimm and cxl_pmem_region
> objects.
> 
> Towards the goal of ripping out the cxl_nvdimm_bridge state machine,
> arrange for cxl_acpi to optionally pre-load the cxl_pmem driver so that
> the nvdimm bridge is active synchronously with
> devm_cxl_add_nvdimm_bridge(), and remove all the bind attributes for the
> cxl_nvdimm* objects since the cxl root device and cxl_memdev bind
> attributes are sufficient.
> 
> Tested-by: Robert Richter <rrichter@amd.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Seems reasonable and I can't see a disadvantage in doing this...
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  drivers/cxl/acpi.c |    1 +
>  drivers/cxl/pmem.c |    9 +++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index fb9f72813067..c540da0cbf1e 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -539,3 +539,4 @@ module_platform_driver(cxl_acpi_driver);
>  MODULE_LICENSE("GPL v2");
>  MODULE_IMPORT_NS(CXL);
>  MODULE_IMPORT_NS(ACPI);
> +MODULE_SOFTDEP("pre: cxl_pmem");
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 4c627d67281a..946e171e7d4a 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -99,6 +99,9 @@ static struct cxl_driver cxl_nvdimm_driver = {
>  	.name = "cxl_nvdimm",
>  	.probe = cxl_nvdimm_probe,
>  	.id = CXL_DEVICE_NVDIMM,
> +	.drv = {
> +		.suppress_bind_attrs = true,
> +	},
>  };
>  
>  static int cxl_pmem_get_config_size(struct cxl_dev_state *cxlds,
> @@ -360,6 +363,9 @@ static struct cxl_driver cxl_nvdimm_bridge_driver = {
>  	.probe = cxl_nvdimm_bridge_probe,
>  	.remove = cxl_nvdimm_bridge_remove,
>  	.id = CXL_DEVICE_NVDIMM_BRIDGE,
> +	.drv = {
> +		.suppress_bind_attrs = true,
> +	},
>  };
>  
>  static int match_cxl_nvdimm(struct device *dev, void *data)
> @@ -583,6 +589,9 @@ static struct cxl_driver cxl_pmem_region_driver = {
>  	.name = "cxl_pmem_region",
>  	.probe = cxl_pmem_region_probe,
>  	.id = CXL_DEVICE_PMEM_REGION,
> +	.drv = {
> +		.suppress_bind_attrs = true,
> +	},
>  };
>  
>  /*
> 

