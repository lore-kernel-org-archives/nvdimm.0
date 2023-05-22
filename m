Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC9414AA9
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684768960; x=1716304960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IQ2+8qfjoJ5i8IamNG6HFwxGEud7KiyzPsQbHf9j/Pc=;
  b=TfKFVuc0gdqkVuoxNQcoj7MvDun14HBhW8gF8fpmeK0+ACh5o9MdhsOl
   dQiEVVcuq9nKMZhoqv8PCpzILUccKbWQud/0eR+DheiGy6RMIlBRaDYlN
   +AAej6scLR1lCfRIh/csZbRp0bumQKu7FNC2gkyvKObPi/KRvoQGetKqj
   j4/PTwcVSiCR9hr91Hgq1x68dorAtHlEnrflvex+noMRfDnRpS1wdcZ1u
   vhpDX2iRNOPuAK7SRiYtlkrBfNdj0gKjrp+8ugz3fWw0lEhYDA6y9J1Kp
   /rZm4jNYnerT6wjyc2lGjU9XKM302TqfiMEYYow9amXrsHACBt9FGsFFw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381182121"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="381182121"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:22:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="703554951"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="703554951"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.173.219]) ([10.213.173.219])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:22:26 -0700
Message-ID: <780579b5-3900-da14-3acd-a4d24e02e4ba@intel.com>
Date: Mon, 22 May 2023 08:22:26 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] acpi: nfit: add declaration in a local header
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Len Brown <lenb@kernel.org>,
 nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230516201415.556858-1-arnd@kernel.org>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230516201415.556858-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/16/23 1:14 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The nfit_intel_shutdown_status() function has a __weak defintion
> in nfit.c and an override in acpi_nfit_test.c for testing
> purposes. This works without an extern declaration, but causes
> a W=1 build warning:
> 
> drivers/acpi/nfit/core.c:1717:13: error: no previous prototype for 'nfit_intel_shutdown_status' [-Werror=missing-prototypes]
> 
> Add a declaration in a header that gets included from both
> sides to shut up the warning and ensure that the prototypes
> actually match.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/acpi/nfit/nfit.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> index 6023ad61831a..573bc0de2990 100644
> --- a/drivers/acpi/nfit/nfit.h
> +++ b/drivers/acpi/nfit/nfit.h
> @@ -347,4 +347,6 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>   void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev);
>   bool intel_fwa_supported(struct nvdimm_bus *nvdimm_bus);
>   extern struct device_attribute dev_attr_firmware_activate_noidle;
> +void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem);
> +
>   #endif /* __NFIT_H__ */
