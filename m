Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [PATCH 1/3] nfit: fix multi-interface dimm handling, acpi6.1
 compatibility
References: <20160208183052.27820.68922.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160208183058.27820.87950.stgit@dwillia2-desk3.amr.corp.intel.com>
 <56B8E842.9080506@hpe.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <56B8F952.2080602@hpe.com>
Date: Mon, 8 Feb 2016 15:23:46 -0500
MIME-Version: 1.0
In-Reply-To: <56B8E842.9080506@hpe.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 2/8/2016 2:10 PM, Linda Knippers wrote:
> On 2/8/2016 1:30 PM, Dan Williams wrote:
>> ACPI 6.1 clarified that multi-interface dimms require multiple control
>> region entries (DCRs) per dimm.  Previously we were assuming that a
>> control region is only present when block-data-windows are present.
> 
> We need to give this a quick test with NVDIMM-N because those types of
> NVDIMMs have control regions without block-data-windows.  We've fixed
> bugs related to that assumption a couple of times.

I can't test the conditions for which these changes were made but the
code continues to work on my NVDIMM-N system where we have control
regions w/o block-data windows.

-- ljk

> 
>> This implementation was done with an eye to be compatibility with the
>> looser ACPI 6.0 interpretation of this table.
>>
>> 1/ When coalescing the memory device (MEMDEV) tables for a single dimm,
>> coalesce on device_handle rather than control region index.
>>
>> 2/ Whenever we disocver a control region with non-zero block windows
> discover
> 
>> re-scan for block-data-window (BDW) entries.
>>
>> We may need to revisit this if a DIMM ever implements a format interface
>> outside of blk or pmem, but that is not on the foreseeable horizon.
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/acpi/nfit.c |   71 +++++++++++++++++++++++++--------------------------
>>  1 file changed, 35 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>> index ad6d8c6b777e..424b362e8fdc 100644
>> --- a/drivers/acpi/nfit.c
>> +++ b/drivers/acpi/nfit.c
>> @@ -469,37 +469,16 @@ static void nfit_mem_find_spa_bdw(struct acpi_nfit_desc *acpi_desc,
>>  	nfit_mem->bdw = NULL;
>>  }
>>  
>> -static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
>> +static void nfit_mem_init_bdw(struct acpi_nfit_desc *acpi_desc,
>>  		struct nfit_mem *nfit_mem, struct acpi_nfit_system_address *spa)
>>  {
>>  	u16 dcr = __to_nfit_memdev(nfit_mem)->region_index;
>>  	struct nfit_memdev *nfit_memdev;
>>  	struct nfit_flush *nfit_flush;
>> -	struct nfit_dcr *nfit_dcr;
>>  	struct nfit_bdw *nfit_bdw;
>>  	struct nfit_idt *nfit_idt;
>>  	u16 idt_idx, range_index;
>>  
>> -	list_for_each_entry(nfit_dcr, &acpi_desc->dcrs, list) {
>> -		if (nfit_dcr->dcr->region_index != dcr)
>> -			continue;
>> -		nfit_mem->dcr = nfit_dcr->dcr;
>> -		break;
>> -	}
>> -
>> -	if (!nfit_mem->dcr) {
>> -		dev_dbg(acpi_desc->dev, "SPA %d missing:%s%s\n",
>> -				spa->range_index, __to_nfit_memdev(nfit_mem)
>> -				? "" : " MEMDEV", nfit_mem->dcr ? "" : " DCR");
>> -		return -ENODEV;
>> -	}
>> -
>> -	/*
>> -	 * We've found enough to create an nvdimm, optionally
>> -	 * find an associated BDW
>> -	 */
>> -	list_add(&nfit_mem->list, &acpi_desc->dimms);
>> -
>>  	list_for_each_entry(nfit_bdw, &acpi_desc->bdws, list) {
>>  		if (nfit_bdw->bdw->region_index != dcr)
>>  			continue;
>> @@ -508,12 +487,12 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
>>  	}
>>  
>>  	if (!nfit_mem->bdw)
>> -		return 0;
>> +		return;
>>  
>>  	nfit_mem_find_spa_bdw(acpi_desc, nfit_mem);
>>  
>>  	if (!nfit_mem->spa_bdw)
>> -		return 0;
>> +		return;
>>  
>>  	range_index = nfit_mem->spa_bdw->range_index;
>>  	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
>> @@ -538,8 +517,6 @@ static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
>>  		}
>>  		break;
>>  	}
>> -
>> -	return 0;
>>  }
>>  
>>  static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
>> @@ -548,7 +525,6 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
>>  	struct nfit_mem *nfit_mem, *found;
>>  	struct nfit_memdev *nfit_memdev;
>>  	int type = nfit_spa_type(spa);
>> -	u16 dcr;
>>  
>>  	switch (type) {
>>  	case NFIT_SPA_DCR:
>> @@ -559,14 +535,18 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
>>  	}
>>  
>>  	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
>> -		int rc;
>> +		struct nfit_dcr *nfit_dcr;
>> +		u32 device_handle;
>> +		u16 dcr;
>>  
>>  		if (nfit_memdev->memdev->range_index != spa->range_index)
>>  			continue;
>>  		found = NULL;
>>  		dcr = nfit_memdev->memdev->region_index;
>> +		device_handle = nfit_memdev->memdev->device_handle;
>>  		list_for_each_entry(nfit_mem, &acpi_desc->dimms, list)
>> -			if (__to_nfit_memdev(nfit_mem)->region_index == dcr) {
>> +			if (__to_nfit_memdev(nfit_mem)->device_handle
>> +					== device_handle) {
>>  				found = nfit_mem;
>>  				break;
>>  			}
>> @@ -579,6 +559,31 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
>>  			if (!nfit_mem)
>>  				return -ENOMEM;
>>  			INIT_LIST_HEAD(&nfit_mem->list);
>> +			list_add(&nfit_mem->list, &acpi_desc->dimms);
>> +		}
>> +
>> +		list_for_each_entry(nfit_dcr, &acpi_desc->dcrs, list) {
>> +			if (nfit_dcr->dcr->region_index != dcr)
>> +				continue;
>> +			/*
>> +			 * Record the control region for the dimm.  For
>> +			 * the ACPI 6.1 case, where there are separate
>> +			 * control regions for the pmem vs blk
>> +			 * interfaces, be sure to record the extended
>> +			 * blk details.
>> +			 */
>> +			if (!nfit_mem->dcr)
>> +				nfit_mem->dcr = nfit_dcr->dcr;
>> +			else if (nfit_mem->dcr->windows == 0
>> +					&& nfit_dcr->dcr->windows)
>> +				nfit_mem->dcr = nfit_dcr->dcr;
>> +			break;
>> +		}
>> +
>> +		if (dcr && !nfit_mem->dcr) {
>> +			dev_err(acpi_desc->dev, "SPA %d missing DCR %d\n",
>> +					spa->range_index, dcr);
>> +			return -ENODEV;
>>  		}
>>  
>>  		if (type == NFIT_SPA_DCR) {
>> @@ -595,6 +600,7 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
>>  				nfit_mem->idt_dcr = nfit_idt->idt;
>>  				break;
>>  			}
>> +			nfit_mem_init_bdw(acpi_desc, nfit_mem, spa);
>>  		} else {
>>  			/*
>>  			 * A single dimm may belong to multiple SPA-PM
>> @@ -603,13 +609,6 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
>>  			 */
>>  			nfit_mem->memdev_pmem = nfit_memdev->memdev;
>>  		}
>> -
>> -		if (found)
>> -			continue;
>> -
>> -		rc = nfit_mem_add(acpi_desc, nfit_mem, spa);
>> -		if (rc)
>> -			return rc;
>>  	}
>>  
>>  	return 0;
>>
>> _______________________________________________
>> Linux-nvdimm mailing list
>> Linux-nvdimm@lists.01.org
>> https://lists.01.org/mailman/listinfo/linux-nvdimm
>>
