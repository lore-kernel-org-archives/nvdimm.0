Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360DD4C89
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 16:38:25 +0000 (UTC)
Received: from frapeml100007.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNz842hFNz686wr;
	Sat,  3 Dec 2022 00:35:32 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100007.china.huawei.com (7.182.85.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 17:38:20 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 16:38:19 +0000
Date: Fri, 2 Dec 2022 16:38:18 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>, "Robert
 Richter" <rrichter@amd.com>, <alison.schofield@intel.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <20221202163818.00002c93@Huawei.com>
In-Reply-To: <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
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
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 01 Dec 2022 13:34:05 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Robert Richter <rrichter@amd.com>
> 
> A downstream port must be connected to a component register block.
> For restricted hosts the base address is determined from the RCRB. The
> RCRB is provided by the host's CEDT CHBS entry. Rework CEDT parser to
> get the RCRB and add code to extract the component register block from
> it.
> 
> RCRB's BAR[0..1] point to the component block containing CXL subsystem
> component registers. MEMBAR extraction follows the PCI base spec here,
> esp. 64 bit extraction and memory range alignment (6.0, 7.5.1.2.1). The
> RCRB base address is cached in the cxl_dport per-host bridge so that the
> upstream port component registers can be retrieved later by an RCD
> (RCIEP) associated with the host bridge.
> 
> Note: Right now the component register block is used for HDM decoder
> capability only which is optional for RCDs. If unsupported by the RCD,
> the HDM init will fail. It is future work to bypass it in this case.
> 
> Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Robert Richter <rrichter@amd.com>
> Link: https://lore.kernel.org/r/Y4dsGZ24aJlxSfI1@rric.localdomain
> [djbw: introduce devm_cxl_add_rch_dport()]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Trivial moans that may have something to do with it being near going home time
on a Friday.

Otherwise looks sensible though this was a fairly superficial look.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>



> ---
>  drivers/cxl/acpi.c            |   51 ++++++++++++++++++++++++++++-----
>  drivers/cxl/core/port.c       |   53 ++++++++++++++++++++++++++++++----
>  drivers/cxl/core/regs.c       |   64 +++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h             |   16 ++++++++++
>  tools/testing/cxl/Kbuild      |    1 +
>  tools/testing/cxl/test/cxl.c  |   10 ++++++
>  tools/testing/cxl/test/mock.c |   19 ++++++++++++
>  tools/testing/cxl/test/mock.h |    3 ++
>  8 files changed, 203 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 50d82376097c..db8173f3ee10 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c

>  struct cxl_chbs_context {
> -	struct device *dev;
> -	unsigned long long uid;
> -	resource_size_t chbcr;
> +	struct device		*dev;
> +	unsigned long long	uid;
> +	resource_size_t		rcrb;
> +	resource_size_t		chbcr;
> +	u32			cxl_version;
>  };

I'm not keen on this style change because it slightly obscures the meaningful
changes in this diff + I suspect it's not consistent with rest of the file.



> diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
> index ec178e69b18f..28ed0ec8ee3e 100644
> --- a/drivers/cxl/core/regs.c
> +++ b/drivers/cxl/core/regs.c
> @@ -307,3 +307,67 @@ int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
>  	return -ENODEV;
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_find_regblock, CXL);
> +
> +resource_size_t cxl_rcrb_to_component(struct device *dev,
> +				      resource_size_t rcrb,
> +				      enum cxl_rcrb which)
> +{
> +	resource_size_t component_reg_phys;
> +	u32 bar0, bar1;
> +	void *addr;
> +	u16 cmd;
> +	u32 id;
> +
> +	if (which == CXL_RCRB_UPSTREAM)
> +		rcrb += SZ_4K;
> +
> +	/*
> +	 * RCRB's BAR[0..1] point to component block containing CXL
> +	 * subsystem component registers. MEMBAR extraction follows
> +	 * the PCI Base spec here, esp. 64 bit extraction and memory
> +	 * ranges alignment (6.0, 7.5.1.2.1).
> +	 */
> +	if (!request_mem_region(rcrb, SZ_4K, "CXL RCRB"))
> +		return CXL_RESOURCE_NONE;
> +	addr = ioremap(rcrb, SZ_4K);
> +	if (!addr) {
> +		dev_err(dev, "Failed to map region %pr\n", addr);
> +		release_mem_region(rcrb, SZ_4K);
> +		return CXL_RESOURCE_NONE;
> +	}
> +
> +	id = readl(addr + PCI_VENDOR_ID);
> +	cmd = readw(addr + PCI_COMMAND);
> +	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
> +	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
> +	iounmap(addr);
> +	release_mem_region(rcrb, SZ_4K);
> +
> +	/*
> +	 * Sanity check, see CXL 3.0 Figure 9-8 CXL Device that Does Not
> +	 * Remap Upstream Port and Component Registers
> +	 */
> +	if (id == U32_MAX) {
> +		if (which == CXL_RCRB_DOWNSTREAM)
> +			dev_err(dev, "Failed to access Downstream Port RCRB\n");
> +		return CXL_RESOURCE_NONE;
> +	}
> +	if (!(cmd & PCI_COMMAND_MEMORY))
> +		return CXL_RESOURCE_NONE;
> +	if (bar0 & (PCI_BASE_ADDRESS_MEM_TYPE_1M | PCI_BASE_ADDRESS_SPACE_IO))

Trivial: A positive match on what we do want might be better...

I had to got look up MEM_TYPE_1M to find out what on earth it was (marked obsolete which
I guess isn't surprising.... )

Up to you though...

> +		return CXL_RESOURCE_NONE;
> +
> +	component_reg_phys = bar0 & PCI_BASE_ADDRESS_MEM_MASK;
> +	if (bar0 & PCI_BASE_ADDRESS_MEM_TYPE_64)
> +		component_reg_phys |= ((u64)bar1) << 32;
> +
> +	if (!component_reg_phys)
> +		return CXL_RESOURCE_NONE;
> +
> +	/* MEMBAR is block size (64k) aligned. */
> +	if (!IS_ALIGNED(component_reg_phys, CXL_COMPONENT_REG_BLOCK_SIZE))
> +		return CXL_RESOURCE_NONE;
> +
> +	return component_reg_phys;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_rcrb_to_component, CXL);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 281b1db5a271..1342e4e61537 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h



>  #define CXL_RESOURCE_NONE ((resource_size_t) -1)
>  #define CXL_TARGET_STRLEN 20
>  
> @@ -486,12 +494,16 @@ cxl_find_dport_by_dev(struct cxl_port *port, const struct device *dport_dev)
>   * @dport: PCI bridge or firmware device representing the downstream link
>   * @port_id: unique hardware identifier for dport in decoder target list
>   * @component_reg_phys: downstream port component registers
> + * @rcrb: base address for the Root Complex Register Block
> + * @rch: Indicate whether this dport was enumerated in RCH or VH mode

Clarify this as
	Indicate this dport was enumerated in RCH rather than VH mode.

a boolean with an or in the comment is confusing!

>   * @port: reference to cxl_port that contains this downstream port
>   */
>  struct cxl_dport {
>  	struct device *dport;
>  	int port_id;
>  	resource_size_t component_reg_phys;
> +	resource_size_t rcrb;
> +	bool rch;
>  	struct cxl_port *port;
>  };

