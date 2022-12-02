Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150014C89
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 17:04:11 +0000 (UTC)
Received: from frapeml100003.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNzmV3VMwz67M6Y;
	Sat,  3 Dec 2022 01:03:38 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100003.china.huawei.com (7.182.85.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 18:04:09 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 17:04:08 +0000
Date: Fri, 2 Dec 2022 17:04:07 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Alison Schofield
	<alison.schofield@intel.com>, <rrichter@amd.com>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 11/12] tools/testing/cxl: Add an RCH topology
Message-ID: <20221202170407.0000030e@Huawei.com>
In-Reply-To: <166993046170.1882361.12460762475782283638.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993046170.1882361.12460762475782283638.stgit@dwillia2-xfh.jf.intel.com>
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
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 01 Dec 2022 13:34:21 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> In an RCH topology a CXL host-bridge as Root Complex Integrated Endpoint
> the represents the memory expander. Unlike a VH topology there is no
> CXL/PCIE Root Port that host the endpoint. The CXL subsystem maps this
> as the CXL root object (ACPI0017 on ACPI based systems) targeting the
> host-bridge as a dport, per usual, but then that dport directly hosts
> the endpoint port.
> 
> Mock up that configuration with a 4th host-bridge that has a 'cxl_rcd'
> device instance as its immediate child.
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

A few trivial things inline.  

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>



> -static struct pci_bus mock_pci_bus[NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST];
> +static struct pci_bus mock_pci_bus[NR_BRIDGES];
>  static struct acpi_pci_root mock_pci_root[ARRAY_SIZE(mock_pci_bus)] = {
>  	[0] = {
>  		.bus = &mock_pci_bus[0],
> @@ -452,7 +493,9 @@ static struct acpi_pci_root mock_pci_root[ARRAY_SIZE(mock_pci_bus)] = {
>  	[2] = {
>  		.bus = &mock_pci_bus[2],
>  	},
> -

I guess fixing this stray space here is fine to avoid a rebase to tidy it up
in original patch which you have on your next branch.

> +	[3] = {
> +		.bus = &mock_pci_bus[3],
> +	},
>  };
>  
>  static bool is_mock_bus(struct pci_bus *bus)
> @@ -738,6 +781,87 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
>  #define SZ_512G (SZ_64G * 8)
>  #endif
>  
> +static __init int cxl_rch_init(void)
> +{
> +	int rc, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_rch); i++) {
> +		int idx = NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST + i;
> +		struct acpi_device *adev = &host_bridge[idx];
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc("cxl_host_bridge", idx);
> +		if (!pdev)
> +			goto err_bridge;
> +
> +		mock_companion(adev, &pdev->dev);
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_bridge;
> +		}
> +
> +		cxl_rch[i] = pdev;

Reason for this suggestion is below.
Move down cxl_rch[i] = pdev;...

> +		mock_pci_bus[idx].bridge = &pdev->dev;
> +		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
> +				       "firmware_node");
> +		if (rc)
> +			goto err_bridge;

to here, and clean up this single loop iteration by having a 
platform_device_unregister in the error path above.

> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(cxl_rcd); i++) {
> +		int idx = NR_MEM_MULTI + NR_MEM_SINGLE + i;
> +		struct platform_device *rch = cxl_rch[i];
> +		struct platform_device *pdev;
> +
> +		pdev = platform_device_alloc("cxl_rcd", idx);
> +		if (!pdev)
> +			goto err_mem;
> +		pdev->dev.parent = &rch->dev;
> +		set_dev_node(&pdev->dev, i % 2);
> +
> +		rc = platform_device_add(pdev);
> +		if (rc) {
> +			platform_device_put(pdev);
> +			goto err_mem;
> +		}
> +		cxl_rcd[i] = pdev;
> +	}
> +
> +	return 0;
> +
> +err_mem:
> +	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
> +		platform_device_unregister(cxl_rcd[i]);
> +err_bridge:
> +	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
> +		struct platform_device *pdev = cxl_rch[i];
> +
> +		if (!pdev)
> +			continue;
> +		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");

Had to look up that this was safe if the file doesn't exist (it is)
I'd rather not have to check, so maybe make the sysfs path
above clean up the device in the loop iteration and only set
cxl_rch[i] once the loop iteration can't fail?  See above.

To my mind doing it that way is more 'obviously correct'
which is never a bad thing.

> +		platform_device_unregister(cxl_rch[i]);
> +	}
> +
> +	return rc;
> +}
> +
> +static void cxl_rch_exit(void)
> +{
> +	int i;
> +
> +	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
> +		platform_device_unregister(cxl_rcd[i]);
> +	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
> +		struct platform_device *pdev = cxl_rch[i];
> +
> +		if (!pdev)
> +			continue;
> +		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");
> +		platform_device_unregister(cxl_rch[i]);
> +	}
> +}
> +

