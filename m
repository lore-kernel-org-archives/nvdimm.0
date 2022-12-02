Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2374C71
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 15:50:17 +0000 (UTC)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNy7D5SCJz67KvJ;
	Fri,  2 Dec 2022 23:49:44 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 16:50:15 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 15:50:14 +0000
Date: Fri, 2 Dec 2022 15:50:14 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Robert Richter <rrichter@amd.com>,
	<alison.schofield@intel.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 05/12] cxl/acpi: Move rescan to the workqueue
Message-ID: <20221202155014.00006755@Huawei.com>
In-Reply-To: <166993042884.1882361.5633723613683058881.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993042884.1882361.5633723613683058881.stgit@dwillia2-xfh.jf.intel.com>
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
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 01 Dec 2022 13:33:48 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Now that the cxl_mem driver has a need to take the root device lock, the
> cxl_bus_rescan() needs to run outside of the root lock context.

If possible add a bit more detail here or a reference to the patch
that needs to take the root device lock.

Change seems fine otherwise, so FWIW

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> 
> Tested-by: Robert Richter <rrichter@amd.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/acpi.c      |   17 +++++++++++++++--
>  drivers/cxl/core/port.c |   19 +++++++++++++++++--
>  drivers/cxl/cxl.h       |    3 ++-
>  3 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index c540da0cbf1e..b8407b77aff6 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -511,7 +511,8 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>  		return rc;
>  
>  	/* In case PCI is scanned before ACPI re-trigger memdev attach */
> -	return cxl_bus_rescan();
> +	cxl_bus_rescan();
> +	return 0;
>  }
>  
>  static const struct acpi_device_id cxl_acpi_ids[] = {
> @@ -535,7 +536,19 @@ static struct platform_driver cxl_acpi_driver = {
>  	.id_table = cxl_test_ids,
>  };
>  
> -module_platform_driver(cxl_acpi_driver);
> +static int __init cxl_acpi_init(void)
> +{
> +	return platform_driver_register(&cxl_acpi_driver);
> +}
> +
> +static void __exit cxl_acpi_exit(void)
> +{
> +	platform_driver_unregister(&cxl_acpi_driver);
> +	cxl_bus_drain();
> +}
> +
> +module_init(cxl_acpi_init);
> +module_exit(cxl_acpi_exit);
>  MODULE_LICENSE("GPL v2");
>  MODULE_IMPORT_NS(CXL);
>  MODULE_IMPORT_NS(ACPI);
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 0d2f5eaaca7d..d225267c69bb 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1844,12 +1844,27 @@ static void cxl_bus_remove(struct device *dev)
>  
>  static struct workqueue_struct *cxl_bus_wq;
>  
> -int cxl_bus_rescan(void)
> +static void cxl_bus_rescan_queue(struct work_struct *w)
>  {
> -	return bus_rescan_devices(&cxl_bus_type);
> +	int rc = bus_rescan_devices(&cxl_bus_type);
> +
> +	pr_debug("CXL bus rescan result: %d\n", rc);
> +}
> +
> +void cxl_bus_rescan(void)
> +{
> +	static DECLARE_WORK(rescan_work, cxl_bus_rescan_queue);
> +
> +	queue_work(cxl_bus_wq, &rescan_work);
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_bus_rescan, CXL);
>  
> +void cxl_bus_drain(void)
> +{
> +	drain_workqueue(cxl_bus_wq);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_bus_drain, CXL);
> +
>  bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
>  {
>  	return queue_work(cxl_bus_wq, &cxlmd->detach_work);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index f0ca2d768385..281b1db5a271 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -552,7 +552,8 @@ int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
>  			  struct cxl_dport *parent_dport);
>  struct cxl_port *find_cxl_root(struct device *dev);
>  int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
> -int cxl_bus_rescan(void);
> +void cxl_bus_rescan(void);
> +void cxl_bus_drain(void);
>  struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd,
>  				   struct cxl_dport **dport);
>  bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd);
> 

