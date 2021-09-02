Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3111C72
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 17:58:31 +0000 (UTC)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H0pXP6vFyz67KsQ;
	Fri,  3 Sep 2021 01:56:53 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 2 Sep 2021 19:58:28 +0200
Received: from localhost (10.52.127.69) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 2 Sep 2021
 18:58:28 +0100
Date: Thu, 2 Sep 2021 18:58:29 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>
Subject: Re: [PATCH v3 18/28] cxl/pci: Use module_pci_driver
Message-ID: <20210902185829.00001c83@Huawei.com>
In-Reply-To: <162982122234.1124374.8206618857845373193.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982122234.1124374.8206618857845373193.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.127.69]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 24 Aug 2021 09:07:02 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Now that cxl_mem_{init,exit} no longer need to manage debugfs, switch
> back to the smaller form of the boiler plate.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Nice side effect of the refactoring.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/pci.c |   30 ++++++++----------------------
>  1 file changed, 8 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index b8075b941a3a..425e821160b5 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -519,6 +519,13 @@ static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	struct cxl_mem *cxlm;
>  	int rc;
>  
> +	/*
> +	 * Double check the anonymous union trickery in struct cxl_regs
> +	 * FIXME switch to struct_group()
> +	 */
> +	BUILD_BUG_ON(offsetof(struct cxl_regs, memdev) !=
> +		     offsetof(struct cxl_regs, device_regs.memdev));
> +
>  	rc = pcim_enable_device(pdev);
>  	if (rc)
>  		return rc;
> @@ -573,27 +580,6 @@ static struct pci_driver cxl_mem_driver = {
>  	},
>  };
>  
> -static __init int cxl_mem_init(void)
> -{
> -	int rc;
> -
> -	/* Double check the anonymous union trickery in struct cxl_regs */
> -	BUILD_BUG_ON(offsetof(struct cxl_regs, memdev) !=
> -		     offsetof(struct cxl_regs, device_regs.memdev));
> -
> -	rc = pci_register_driver(&cxl_mem_driver);
> -	if (rc)
> -		return rc;
> -
> -	return 0;
> -}
> -
> -static __exit void cxl_mem_exit(void)
> -{
> -	pci_unregister_driver(&cxl_mem_driver);
> -}
> -
>  MODULE_LICENSE("GPL v2");
> -module_init(cxl_mem_init);
> -module_exit(cxl_mem_exit);
> +module_pci_driver(cxl_mem_driver);
>  MODULE_IMPORT_NS(CXL);
> 

