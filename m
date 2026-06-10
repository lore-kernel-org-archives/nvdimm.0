Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B67A3264EF
	for <nvdimm@lists.linux.dev>; Wed, 10 Jun 2026 16:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781110661; cv=none; b=BMo3Q/h2DzKrPjoMZemCTb7fzg4ZGOZP8PZxTl2aUsQBtThWuVDSC2RqtNcVDER6oYu6ybQnG5Vwz4hOILzB5EJBHMSJMw9Bwwk395pp9ZSHOuxxx8to1S4iFrKY5C92/tQ4IQywvfJKA17ZgENAnPD6aFkzHKwGCjDyNQECKvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781110661; c=relaxed/simple;
	bh=jB1iHg/vCSqRMMhDPrJ3NBTEeSyGYwXpUPi2XsbP83w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ngPu6/L7VPJ5/UUYcBzYYCAG5mbOAUGLjoYl7DR8f5hKrFmsdTsm62wvDILc4rbdMJYEZJW+p41LpEm/RrausHCulL3lXwmCL+4PzXeEjJ3k25a8BlxwNYa8Zrw6iUy+mr0kIkwlseYZ8Yp996YQDXzppbLGtHyonaR9lx/unDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AXixDy4t; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AXixDy4t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781110658; x=1812646658;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jB1iHg/vCSqRMMhDPrJ3NBTEeSyGYwXpUPi2XsbP83w=;
  b=AXixDy4tj6Anj3EcVrhykY9NzKhzDkxfWbRPCYJw+OToECG6KoHZalTs
   KZCA88ll06/uFWUeA2HdiSGMfVNUflwjl72P3mwVlRILzxD7tsuvL3UA1
   Na1exB9GHrISmz2WY/6N1Z/ETB86xuxU2MvUiCq9px4Znm83jjXVaRw8k
   stiaL9Hi1TRCeedq9VtsNGIedT/CXPWxkR9LUTmgN6z4//Q4SWBUqgC6k
   GML2b0Lf25U/Q57AwinYAzOeY6dmamXjxyikvokeTXQN6Rp+euw4D3z7I
   TIHejIMA4D4eeBz5BUKlOXHkALZpPHTjbaF9Tz+pqDpLcf9fblbo4RpOq
   g==;
X-CSE-ConnectionGUID: IWtMzNZzTAOwdoBzQrBQ4A==
X-CSE-MsgGUID: vI8duCn/SjKp95gaoipY2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="99488744"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="99488744"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:57:37 -0700
X-CSE-ConnectionGUID: ukIE0x+VREK9wPCNxi4zKQ==
X-CSE-MsgGUID: VxO984YfSNCzdsytsVdOkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="246303789"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.110.25]) ([10.125.110.25])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:57:36 -0700
Message-ID: <9c3ab868-27b7-4d33-865b-9308269f764f@intel.com>
Date: Wed, 10 Jun 2026 09:57:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/31] cxl/mem: Configure dynamic capacity interrupts
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <7f2e4fe385415e0b77b58f4bd988bc5895557dcf.1779528761.git.anisa.su@samsung.com>
 <28a8e58d-5bf8-438e-b337-76944d67e297@intel.com>
 <aiZ6TLUwI11Yg1jh@AnisaLaptop.localdomain>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <aiZ6TLUwI11Yg1jh@AnisaLaptop.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/8/26 1:16 AM, Anisa Su wrote:
> On Thu, May 28, 2026 at 09:21:59AM -0700, Dave Jiang wrote:
>>
>>
>> On 5/23/26 2:43 AM, Anisa Su wrote:
>>> From: Ira Weiny <ira.weiny@intel.com>
>>>
>>> Dynamic Capacity Devices (DCD) support extent change notifications
>>> through the event log mechanism.  The interrupt mailbox commands were
>>> extended in CXL 3.1 to support these notifications.  Firmware can't
>>> configure DCD events to be FW controlled but can retain control of
>>> memory events.
>>>
>>> Configure DCD event log interrupts on devices supporting dynamic
>>> capacity.  Disable DCD if interrupts are not supported.
>>>
>>> Care is taken to preserve the interrupt policy set by the FW if FW first
>>> has been selected by the BIOS.
>>>
>>> Accept the 4-byte CXL 2.0 reply on GET Event Interrupt Policy by setting
>>> min_out to CXL_EVENT_INT_POLICY_BASE_SIZE; pre-CXL 3.1 firmware omits
>>> dcd_settings and would otherwise fail the size check.
>>>
>>> Based on an original patch by Navneet Singh.
>>>
>>> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>>> Signed-off-by: Anisa Su <anisa.su@samsung.com>
>>>
>>> ---
>>> Changes:
>>> [anisa: rebase]
>>> [anisa: accept 4-byte CXL 2.0 GET reply via min_out]
>>> [anisa: drop Reviewed-by tags now that the patch carries new changes]
>>> ---
>>>  drivers/cxl/cxlmem.h |  2 ++
>>>  drivers/cxl/pci.c    | 75 ++++++++++++++++++++++++++++++++++++--------
>>>  2 files changed, 64 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
>>> index 10175ca3b7ee..65c009b02da6 100644
>>> --- a/drivers/cxl/cxlmem.h
>>> +++ b/drivers/cxl/cxlmem.h
>>> @@ -218,7 +218,9 @@ struct cxl_event_interrupt_policy {
>>>  	u8 warn_settings;
>>>  	u8 failure_settings;
>>>  	u8 fatal_settings;
>>> +	u8 dcd_settings;
>>>  } __packed;
>>> +#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
>>>  
>>>  /**
>>>   * struct cxl_event_state - Event log driver state
>>> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
>>> index 8d12c684d670..83617439bbd3 100644
>>> --- a/drivers/cxl/pci.c
>>> +++ b/drivers/cxl/pci.c
>>> @@ -557,6 +557,8 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
>>>  		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
>>>  		.payload_out = policy,
>>>  		.size_out = sizeof(*policy),
>>> +		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
>>> +		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
>>>  	};
>>>  	int rc;
>>>  
>>> @@ -569,23 +571,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
>>>  }
>>>  
>>>  static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
>>> -				    struct cxl_event_interrupt_policy *policy)
>>> +				    struct cxl_event_interrupt_policy *policy,
>>> +				    bool native_cxl)
>>>  {
>>>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
>>> +	size_t size_in = CXL_EVENT_INT_POLICY_BASE_SIZE;
>>>  	struct cxl_mbox_cmd mbox_cmd;
>>>  	int rc;
>>>  
>>> -	*policy = (struct cxl_event_interrupt_policy) {
>>> -		.info_settings = CXL_INT_MSI_MSIX,
>>> -		.warn_settings = CXL_INT_MSI_MSIX,
>>> -		.failure_settings = CXL_INT_MSI_MSIX,
>>> -		.fatal_settings = CXL_INT_MSI_MSIX,
>>> -	};
>>> +	/* memory event policy is left if FW has control */
>>> +	if (native_cxl) {
>>> +		*policy = (struct cxl_event_interrupt_policy) {
>>> +			.info_settings = CXL_INT_MSI_MSIX,
>>> +			.warn_settings = CXL_INT_MSI_MSIX,
>>> +			.failure_settings = CXL_INT_MSI_MSIX,
>>> +			.fatal_settings = CXL_INT_MSI_MSIX,
>>> +			.dcd_settings = 0,
>>> +		};
>>> +	}
>>> +
>>> +	if (cxl_dcd_supported(mds)) {
>>> +		policy->dcd_settings = CXL_INT_MSI_MSIX;
>>> +		size_in += sizeof(policy->dcd_settings);
>>> +	}
>>>  
>>>  	mbox_cmd = (struct cxl_mbox_cmd) {
>>>  		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
>>>  		.payload_in = policy,
>>> -		.size_in = sizeof(*policy),
>>> +		.size_in = size_in,
>>>  	};
>>>  
>>>  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
>>> @@ -632,6 +645,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
>>>  	return 0;
>>>  }
>>>  
>>> +static int cxl_irqsetup(struct cxl_memdev_state *mds,
>>> +			struct cxl_event_interrupt_policy *policy,
>>> +			bool native_cxl)
>>> +{
>>> +	struct cxl_dev_state *cxlds = &mds->cxlds;
>>> +	int rc;
>>> +
>>> +	if (native_cxl) {
>>> +		rc = cxl_event_irqsetup(mds, policy);
>>> +		if (rc)
>>> +			return rc;
>>> +	}
>>> +
>>> +	if (cxl_dcd_supported(mds)) {
>>> +		rc = cxl_event_req_irq(cxlds, policy->dcd_settings);
>>> +		if (rc) {
>>> +			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
>>> +			cxl_disable_dcd(mds);
>>> +		}
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static bool cxl_event_int_is_fw(u8 setting)
>>>  {
>>>  	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
>>> @@ -657,18 +694,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
>>>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>>>  			    struct cxl_memdev_state *mds, bool irq_avail)
>>>  {
>>> -	struct cxl_event_interrupt_policy policy;
>>> +	struct cxl_event_interrupt_policy policy = { 0 };
>>> +	bool native_cxl = host_bridge->native_cxl_error;
>>>  	int rc;
>>>  
>>>  	/*
>>>  	 * When BIOS maintains CXL error reporting control, it will process
>>>  	 * event records.  Only one agent can do so.
>>> +	 *
>>> +	 * If BIOS has control of events and DCD is not supported skip event
>>> +	 * configuration.
>>>  	 */
>>> -	if (!host_bridge->native_cxl_error)
>>> +	if (!native_cxl && !cxl_dcd_supported(mds))
>>>  		return 0;
>>>  
>>>  	if (!irq_avail) {
>>>  		dev_info(mds->cxlds.dev, "No interrupt support, disable event processing.\n");
>>> +		if (cxl_dcd_supported(mds)) {
>>> +			dev_info(mds->cxlds.dev, "DCD requires interrupts, disable DCD\n");
>>> +			cxl_disable_dcd(mds);
>>> +		}
>>>  		return 0;
>>>  	}
>>>  
>>> @@ -676,10 +721,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>>>  	if (rc)
>>>  		return rc;
>>>  
>>> -	if (!cxl_event_validate_mem_policy(mds, &policy))
>>> +	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
>>>  		return -EBUSY;
>>>  
>>> -	rc = cxl_event_config_msgnums(mds, &policy);
>>> +	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
>>>  	if (rc)
>>>  		return rc;
>>>  
>>> @@ -687,12 +732,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>>>  	if (rc)
>>>  		return rc;
>>>  
>>> -	rc = cxl_event_irqsetup(mds, &policy);
>>> +	rc = cxl_irqsetup(mds, &policy, native_cxl);
>>>  	if (rc)
>>>  		return rc;
>>>  
>>>  	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
>>
>> Issue that was always there probably, should this check native_cxl so the BIOS owned events are not retrieved?
>>
>> 	if (native_cxl)
>> 		cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
>>
>>
> That makes sense. Would you prefer the fix as a separate patch?

Yes please.

DJ

