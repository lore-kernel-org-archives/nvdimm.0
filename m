Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D35922119A47D
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 14:37:24 -0800 (PST)
Subject: Re: [PATCH] acpi/nfit/intel: Remove zero initialization in security
 command payloads
References: <154456575434.852018.13818918249999253002.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <f3260bd0-37d1-6e43-1f6d-024d19c73e6b@intel.com>
Date: Tue, 11 Dec 2018 15:37:22 -0700
MIME-Version: 1.0
In-Reply-To: <154456575434.852018.13818918249999253002.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 12/11/18 3:02 PM, Dan Williams wrote:
> C99 struct initialization already zeroes all other fields if any one
> field is initialized.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thanks. I missed those.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/acpi/nfit/intel.c |   13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> index 09317ea23e72..6d5eb4b239a0 100644
> --- a/drivers/acpi/nfit/intel.c
> +++ b/drivers/acpi/nfit/intel.c
> @@ -198,9 +198,6 @@ static int intel_security_disable(struct nvdimm *nvdimm,
>  			.nd_size_out = ND_INTEL_STATUS_SIZE,
>  			.nd_fw_size = ND_INTEL_STATUS_SIZE,
>  		},
> -		.cmd = {
> -			.status = 0,
> -		},
>  	};
>  
>  	if (!test_bit(NVDIMM_INTEL_DISABLE_PASSPHRASE, &nfit_mem->dsm_mask))
> @@ -240,9 +237,6 @@ static int intel_security_erase(struct nvdimm *nvdimm,
>  			.nd_size_out = ND_INTEL_STATUS_SIZE,
>  			.nd_fw_size = ND_INTEL_STATUS_SIZE,
>  		},
> -		.cmd = {
> -			.status = 0,
> -		},
>  	};
>  
>  	if (master)
> @@ -292,13 +286,9 @@ static int intel_security_query_overwrite(struct nvdimm *nvdimm)
>  		.pkg = {
>  			.nd_command = NVDIMM_INTEL_QUERY_OVERWRITE,
>  			.nd_family = NVDIMM_FAMILY_INTEL,
> -			.nd_size_in = 0,
>  			.nd_size_out = ND_INTEL_STATUS_SIZE,
>  			.nd_fw_size = ND_INTEL_STATUS_SIZE,
>  		},
> -		.cmd = {
> -			.status = 0,
> -		},
>  	};
>  
>  	if (!test_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &nfit_mem->dsm_mask))
> @@ -339,9 +329,6 @@ static int intel_security_overwrite(struct nvdimm *nvdimm,
>  			.nd_size_out = ND_INTEL_STATUS_SIZE,
>  			.nd_fw_size = ND_INTEL_STATUS_SIZE,
>  		},
> -		.cmd = {
> -			.status = 0,
> -		},
>  	};
>  
>  	if (!test_bit(NVDIMM_INTEL_OVERWRITE, &nfit_mem->dsm_mask))
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
