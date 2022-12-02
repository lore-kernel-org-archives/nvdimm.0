Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1304C89
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 17:06:02 +0000 (UTC)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNzlY75WGz6880b;
	Sat,  3 Dec 2022 01:02:49 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 18:05:59 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 17:05:58 +0000
Date: Fri, 2 Dec 2022 17:05:58 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, <alison.schofield@intel.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 12/12] cxl/acpi: Set ACPI's CXL _OSC to indicate RCD
 mode support
Message-ID: <20221202170558.00003481@Huawei.com>
In-Reply-To: <166993046717.1882361.10587956243041624761.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993046717.1882361.10587956243041624761.stgit@dwillia2-xfh.jf.intel.com>
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

On Thu, 01 Dec 2022 13:34:27 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Terry Bowman <terry.bowman@amd.com>
> 
> ACPI uses the CXL _OSC support method to communicate the available CXL
> functionality to FW. The CXL _OSC support method includes a field to
> indicate the OS is capable of RCD mode. FW can potentially change it's
> operation depending on the _OSC support method reported by the OS.
> 
> The ACPI driver currently only sets the ACPI _OSC support method to
> indicate CXL VH mode. Change the capability reported to also include
> CXL RCD mode.
> 
> [1] CXL3.0 Table 9-26 'Interpretation of CXL _OSC Support Field'
> 
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> [rrichter@amd.com: Reworded patch description.]
> Signed-off-by: Robert Richter <rrichter@amd.com>
> Link: http://lore.kernel.org/r/Y4cRV/Sj0epVW7bE@rric.localdomain
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Mostly for completeness rather than because a review of this patch
brings any value as it's 'obviously correct'.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/acpi/pci_root.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 4e3db20e9cbb..b3c202d2a433 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -493,6 +493,7 @@ static u32 calculate_cxl_support(void)
>  	u32 support;
>  
>  	support = OSC_CXL_2_0_PORT_DEV_REG_ACCESS_SUPPORT;
> +	support |= OSC_CXL_1_1_PORT_REG_ACCESS_SUPPORT;
>  	if (pci_aer_available())
>  		support |= OSC_CXL_PROTOCOL_ERR_REPORTING_SUPPORT;
>  	if (IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))
> 

