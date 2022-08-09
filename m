Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ED815CB
	for <nvdimm@lists.linux.dev>; Tue,  9 Aug 2022 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660084315; x=1691620315;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uJ0j7F5UQuGiNMvMsZgXUX6HBQS4EnY3+TDCK4xF7aM=;
  b=A38DYifzuj6HHYvuImwbetHO858H6V+7TyukgGZqLCxF2Hk8O1oNoBR9
   If+0d+38Yg7XlLl+cZeCCOWLEjAZ+aG7iqOphEMy8NPCcd67EGNs1XGIz
   SojeQUkclqPhADFxCSnorxHeTUO6xCrt2DKF498Ud1YfxL8MH3YgyrolQ
   JOHkLfIB8CWpCVDo9dGvKWkPAOBLogIfYxzXMf82Iv271kzslSbXZnOPi
   lZdz05FhWcJkOyvbwLGitzg99Xt7TOZmkau0HSNp2sPtWr8m2744+KkdM
   6IrWLR53ogTRvSSfI2E3z12hnAlWmi8Y5ki5Q3zgjlefmtWw3Z8Ekz73x
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="271333286"
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="271333286"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 15:31:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,225,1654585200"; 
   d="scan'208";a="664623936"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.24.249]) ([10.212.24.249])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 15:31:35 -0700
Message-ID: <14d33af5-e8c7-c30d-7cd9-08f55a270992@intel.com>
Date: Tue, 9 Aug 2022 15:31:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH RFC 11/15] cxl/pmem: Add "Unlock" security command support
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791937639.2491387.6281906434880014077.stgit@djiang5-desk3.ch.intel.com>
 <20220804141901.00005a2a@huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220804141901.00005a2a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/4/2022 6:19 AM, Jonathan Cameron wrote:
> On Fri, 15 Jul 2022 14:09:36 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
>
>> Create callback function to support the nvdimm_security_ops() ->unlock()
>> callback. Translate the operation to send "Unlock" security command for CXL
>> mem device.
>>
>> When the mem device is unlocked, arch_invalidate_nvdimm_cache() is called
>> in order to invalidate all CPU caches before attempting to access the mem
>> device.
>>
>> See CXL 2.0 spec section 8.2.9.5.6.4 for reference.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Hi Dave,
>
> One trivial thing inline.
>
> Thanks,
>
> Jonathan
>
>> ---
>>   drivers/cxl/cxlmem.h   |    1 +
>>   drivers/cxl/security.c |   21 +++++++++++++++++++++
>>   2 files changed, 22 insertions(+)
>>
>> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
>> index ced85be291f3..ae8ccd484491 100644
>> --- a/drivers/cxl/cxlmem.h
>> +++ b/drivers/cxl/cxlmem.h
>> @@ -253,6 +253,7 @@ enum cxl_opcode {
>>   	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
>>   	CXL_MBOX_OP_SET_PASSPHRASE	= 0x4501,
>>   	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
>> +	CXL_MBOX_OP_UNLOCK		= 0x4503,
>>   	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
>>   	CXL_MBOX_OP_MAX			= 0x10000
>>   };
>> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
>> index 6399266a5908..d15520f280f0 100644
>> --- a/drivers/cxl/security.c
>> +++ b/drivers/cxl/security.c
>> @@ -114,11 +114,32 @@ static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
>>   	return cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_FREEZE_SECURITY, NULL, 0, NULL, 0);
>>   }
>>   
>> +static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
>> +				    const struct nvdimm_key_data *key_data)
>> +{
>> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
>> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
>> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>> +	u8 pass[NVDIMM_PASSPHRASE_LEN];
>> +	int rc;
>> +
>> +	memcpy(pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
> Why do we need a local copy?  I'd have thought we could just
> pass keydata->data in as the payload for cxl_mbox_send_cmd()
> There might be some value in making it easier to check by
> having a structure defined for this payload (obviously trivial)
> but given we are using an array of length defined by a non CXL
> define, I'm not sure there is any point in the copy.

We end up hitting a compile warning if we just directly pass in because key_data->data has const qualifier.

tools/testing/cxl/../../../drivers/cxl/security.c: In function ‘cxl_pmem_security_unlock’:
tools/testing/cxl/../../../drivers/cxl/security.c:116:40: warning: passing argument 3 of ‘cxl_mbox_send_cmd’ discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
   116 |                                key_data->data, NVDIMM_PASSPHRASE_LEN, NULL, 0);
       |                                ~~~~~~~~^~~~~~
In file included from tools/testing/cxl/../../../drivers/cxl/security.c:8:
tools/testing/cxl/../../../drivers/cxl/cxlmem.h:408:70: note: expected ‘void *’ but argument is of type ‘const u8 *’ {aka ‘const unsigned char *’}
   408 | int cxl_mbox_send_cmd(struct cxl_dev_state *cxlds, u16 opcode, void *in,
       |                                                                ~~~~~~^~


>
>> +	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_UNLOCK,
>> +			       pass, NVDIMM_PASSPHRASE_LEN, NULL, 0);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	/* DIMM unlocked, invalidate all CPU caches before we read it */
>> +	arch_invalidate_nvdimm_cache();
>> +	return 0;
>> +}
>> +
>>   static const struct nvdimm_security_ops __cxl_security_ops = {
>>   	.get_flags = cxl_pmem_get_security_flags,
>>   	.change_key = cxl_pmem_security_change_key,
>>   	.disable = cxl_pmem_security_disable,
>>   	.freeze = cxl_pmem_security_freeze,
>> +	.unlock = cxl_pmem_security_unlock,
>>   };
>>   
>>   const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
>>
>>
