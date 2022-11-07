Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB51122AC
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 20:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667852403; x=1699388403;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2VjpYFb5KbHNYYEFpzbSLB5FLS77xoi7On0yjXcJprU=;
  b=E7FA++Qem6BhYOSZICcQwxtbueiASuLbFDlpRJCqp1klDaTpmz5SG8dO
   vIafcLvqbvwFJ6/TLIlwxH9ymeNezY9dSew1ZHUuDEEi2/k+NoltMOdJC
   4yxLQMNNc7h1P8inTKP6phbm06tjYIDpzhHwmy2nysNw6YQJBc3SJcC/9
   yAXVWusOBOgx9mfl5jMw5Q0KLSVTjN+eJg/D4ntDABpqJwrFeLChsK3o5
   LH3XIKDkWT2J3+ipYpFaSpafOebSwASyos4zBvomgVJUUCRWXte4R9q1z
   eF70vhs7XW2/jl/30r0OV1E0WmgWG5zSEiwzapNl70p8RcXe+fb25y5ov
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311670139"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311670139"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 12:19:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="741647318"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="741647318"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.213.168.235]) ([10.213.168.235])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 12:19:47 -0800
Message-ID: <ff5b655c-a9bf-4b2f-e54a-b48d75d02ad4@intel.com>
Date: Mon, 7 Nov 2022 12:19:46 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v2 12/19] cxl/pmem: Add "Passphrase Secure Erase" security
 command support
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377436014.430546.12077333298585882653.stgit@djiang5-desk3.ch.intel.com>
 <20221107152543.00001128@Huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221107152543.00001128@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2022 7:25 AM, Jonathan Cameron wrote:
> On Wed, 21 Sep 2022 08:32:40 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> Create callback function to support the nvdimm_security_ops() ->erase()
>> callback. Translate the operation to send "Passphrase Secure Erase"
>> security command for CXL memory device.
>>
>> When the mem device is secure erased, arch_invalidate_nvdimm_cache() is
>> called in order to invalidate all CPU caches before attempting to access
>> the mem device again.
>>
>> See CXL 2.0 spec section 8.2.9.5.6.6 for reference.
> Update references now 3.0 is out.

I'll do that for the entire series.

> 
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> A few minor things inline.
> 
>> ---
>>   drivers/cxl/core/mbox.c      |    1 +
>>   drivers/cxl/cxlmem.h         |    8 ++++++++
>>   drivers/cxl/security.c       |   29 +++++++++++++++++++++++++++++
>>   include/uapi/linux/cxl_mem.h |    1 +
>>   4 files changed, 39 insertions(+)
>>
>> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
>> index 243b01e2de85..88538a7ccc83 100644
>> --- a/drivers/cxl/core/mbox.c
>> +++ b/drivers/cxl/core/mbox.c
>> @@ -70,6 +70,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
>>   	CXL_CMD(DISABLE_PASSPHRASE, 0x40, 0, 0),
>>   	CXL_CMD(FREEZE_SECURITY, 0, 0, 0),
>>   	CXL_CMD(UNLOCK, 0x20, 0, 0),
>> +	CXL_CMD(PASSPHRASE_ERASE, 0x40, 0, 0),
>>   };
>>   
>>   /*
>> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
>> index 4e6897e8eb7d..1266df3b2d3d 100644
>> --- a/drivers/cxl/cxlmem.h
>> +++ b/drivers/cxl/cxlmem.h
>> @@ -278,6 +278,7 @@ enum cxl_opcode {
>>   	CXL_MBOX_OP_DISABLE_PASSPHRASE	= 0x4502,
>>   	CXL_MBOX_OP_UNLOCK		= 0x4503,
>>   	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
>> +	CXL_MBOX_OP_PASSPHRASE_ERASE	= 0x4505,
> Hmm. Name is a bit ambiguous. Is it erasing the passphrase or the data?
> Perhaps full
> 	CXL_MBOX_O_PASSPHRASE_SECURE_ERASE is a little better?

Ok, will update.

> 
>>   	CXL_MBOX_OP_MAX			= 0x10000
>>   };
>>   
>> @@ -400,6 +401,13 @@ struct cxl_disable_pass {
>>   	u8 pass[NVDIMM_PASSPHRASE_LEN];
>>   } __packed;
>>   
>> +/* passphrase erase payload */
> Same here.

Ok.

> 
>> +struct cxl_pass_erase {
>> +	u8 type;
>> +	u8 reserved[31];
>> +	u8 pass[NVDIMM_PASSPHRASE_LEN];
>> +} __packed;
>> +
>>   enum {
>>   	CXL_PMEM_SEC_PASS_MASTER = 0,
>>   	CXL_PMEM_SEC_PASS_USER,
>> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
>> index 8bfdcb58d381..df4cf26e366a 100644
>> --- a/drivers/cxl/security.c
>> +++ b/drivers/cxl/security.c
>> @@ -128,12 +128,41 @@ static int cxl_pmem_security_unlock(struct nvdimm *nvdimm,
>>   	return 0;
>>   }
>>   
>> +static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
>> +					      const struct nvdimm_key_data *key,
>> +					      enum nvdimm_passphrase_type ptype)
>> +{
>> +	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
>> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
>> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>> +	struct cxl_pass_erase erase;
>> +	int rc;
>> +
>> +	if (!cpu_cache_has_invalidate_memregion())
>> +		return -EOPNOTSUPP;
>> +
>> +	erase.type = ptype == NVDIMM_MASTER ?
>> +		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
>> +	memcpy(erase.pass, key->data, NVDIMM_PASSPHRASE_LEN);
>> +	/* Flush all cache before we erase mem device */
>> +	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
>> +	rc =  cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_PASSPHRASE_ERASE,
> 
> extra space.

Yup. Thanks!

> 
>> +				&erase, sizeof(erase), NULL, 0);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	/* mem device erased, invalidate all CPU caches before data is read */
>> +	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
>> +	return 0;
>> +}
>> +
>>   static const struct nvdimm_security_ops __cxl_security_ops = {
>>   	.get_flags = cxl_pmem_get_security_flags,
>>   	.change_key = cxl_pmem_security_change_key,
>>   	.disable = cxl_pmem_security_disable,
>>   	.freeze = cxl_pmem_security_freeze,
>>   	.unlock = cxl_pmem_security_unlock,
>> +	.erase = cxl_pmem_security_passphrase_erase,
>>   };
>>   
>>   const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
>> diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
>> index 95dca8d4584f..6da25f2e1bf9 100644
>> --- a/include/uapi/linux/cxl_mem.h
>> +++ b/include/uapi/linux/cxl_mem.h
>> @@ -46,6 +46,7 @@
>>   	___C(DISABLE_PASSPHRASE, "Disable Passphrase"),			  \
>>   	___C(FREEZE_SECURITY, "Freeze Security"),			  \
>>   	___C(UNLOCK, "Unlock"),						  \
>> +	___C(PASSPHRASE_ERASE, "Passphrase Secure Erase"),		  \
>>   	___C(MAX, "invalid / last command")
>>   
>>   #define ___C(a, b) CXL_MEM_COMMAND_ID_##a
>>
>>
> 
