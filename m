Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D3B14A9C
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684768962; x=1716304962;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CnP71/eCe2UsTWRS40zMOMu+oOUjG/L/UA4c/oZhaWE=;
  b=aTJISgCibD+QVTLumKmwn3OfT6MtZDQU05Wm1LTHosuoinBEJbUzCpuc
   ttxObgeJLTOG4Q02hHf4B2AvJfXkdAxRE7N2aK3gkYPDAyFt1Kt23tC+5
   ap6NHPBefMEYGbp8dOdspAMBkMoNgeTKqTjDw6AkXe0qhsA7QRX5cUV+D
   DOGbpDiC8mvpamcTSfo0IlE4xCPDo/2E5Gt0y9qGok27EwDVsZ8Kbl4qj
   H+lAFkg630CHsD6nS88FIlMESqs9DNUo6zI/m/JB5NfZ0p5YY/L+YnYN+
   NMdX/RwoFboMP7ylACmBGkCGN5fR8TazmkmSVosQ1rgWtGZorGUFy2/l4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381182158"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="381182158"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:22:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="703554960"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="703554960"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.173.219]) ([10.213.173.219])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:22:35 -0700
Message-ID: <61a4a468-8530-d082-b03b-a06c14c63517@intel.com>
Date: Mon, 22 May 2023 08:22:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] testing: nvdimm: add missing prototypes for wrapped
 functions
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20230516201415.556858-1-arnd@kernel.org>
 <20230516201415.556858-2-arnd@kernel.org>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230516201415.556858-2-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/16/23 1:14 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The nvdimm test wraps a number of API functions, but these functions
> don't have a prototype in a header because they are all called
> by a different name:
> 
> drivers/nvdimm/../../tools/testing/nvdimm/test/iomap.c:74:15: error: no previous prototype for '__wrap_devm_ioremap' [-Werror=missing-prototypes]
>     74 | void __iomem *__wrap_devm_ioremap(struct device *dev,
>        |               ^~~~~~~~~~~~~~~~~~~
> drivers/nvdimm/../../tools/testing/nvdimm/test/iomap.c:86:7: error: no previous prototype for '__wrap_devm_memremap' [-Werror=missing-prototypes]
>     86 | void *__wrap_devm_memremap(struct device *dev, resource_size_t offset,
>        |       ^~~~~~~~~~~~~~~~~~~~
> ...
> 
> Add prototypes to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   tools/testing/nvdimm/test/nfit_test.h | 29 +++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
> index b5f7a996c4d0..b00583d1eace 100644
> --- a/tools/testing/nvdimm/test/nfit_test.h
> +++ b/tools/testing/nvdimm/test/nfit_test.h
> @@ -207,7 +207,36 @@ typedef struct nfit_test_resource *(*nfit_test_lookup_fn)(resource_size_t);
>   typedef union acpi_object *(*nfit_test_evaluate_dsm_fn)(acpi_handle handle,
>   		 const guid_t *guid, u64 rev, u64 func,
>   		 union acpi_object *argv4);
> +void __iomem *__wrap_devm_ioremap(struct device *dev,
> +		resource_size_t offset, unsigned long size);
> +void *__wrap_devm_memremap(struct device *dev, resource_size_t offset,
> +		size_t size, unsigned long flags);
> +void *__wrap_devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> +pfn_t __wrap_phys_to_pfn_t(phys_addr_t addr, unsigned long flags);
> +void *__wrap_memremap(resource_size_t offset, size_t size,
> +		unsigned long flags);
> +void __wrap_devm_memunmap(struct device *dev, void *addr);
> +void __iomem *__wrap_ioremap(resource_size_t offset, unsigned long size);
> +void __iomem *__wrap_ioremap_wc(resource_size_t offset, unsigned long size);
>   void __wrap_iounmap(volatile void __iomem *addr);
> +void __wrap_memunmap(void *addr);
> +struct resource *__wrap___request_region(struct resource *parent,
> +		resource_size_t start, resource_size_t n, const char *name,
> +		int flags);
> +int __wrap_insert_resource(struct resource *parent, struct resource *res);
> +int __wrap_remove_resource(struct resource *res);
> +struct resource *__wrap___devm_request_region(struct device *dev,
> +		struct resource *parent, resource_size_t start,
> +		resource_size_t n, const char *name);
> +void __wrap___release_region(struct resource *parent, resource_size_t start,
> +		resource_size_t n);
> +void __wrap___devm_release_region(struct device *dev, struct resource *parent,
> +		resource_size_t start, resource_size_t n);
> +acpi_status __wrap_acpi_evaluate_object(acpi_handle handle, acpi_string path,
> +		struct acpi_object_list *p, struct acpi_buffer *buf);
> +union acpi_object * __wrap_acpi_evaluate_dsm(acpi_handle handle, const guid_t *guid,
> +		u64 rev, u64 func, union acpi_object *argv4);
> +
>   void nfit_test_setup(nfit_test_lookup_fn lookup,
>   		nfit_test_evaluate_dsm_fn evaluate);
>   void nfit_test_teardown(void);
