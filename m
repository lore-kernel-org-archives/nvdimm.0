Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4180A15C8C
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667858321; x=1699394321;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=77y+6RWvz1s6W/CMCpJ5abMNoQxwDnKCZXzcy7wM1mk=;
  b=N8vf7qRaYPXjGh7g/esEHs0AUmXOG02ttIr3myhcdloU7VmTUOzNgrDG
   1I2tVMOVTo2SdsKM5vKfpyO8T955p62Zh7BZh84+FId7wZ6e8fSvmrmgl
   fqRFEjlwh5IXHZdqEtf91EUG2QKwt7d1s9LQpRBsA8CatPYW1YgMsWV/H
   sM7EvAX3HdMUFeYLy82bOuJRKuKZYL2mx50hiKe6576DPr2pCBLPOJnd3
   rw/bGdXOwSchlkq6bR5BYiGtoKT+p/iIlv4HqmTJucYZsZCklaNFUxntB
   8KB78xJHNTipKuPWV2F/3D5AoqhIHe2oZNpOWa8nL/Bv3JbhBBjjZa7DX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311687661"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="311687661"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 13:58:40 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="705049005"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="705049005"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.213.168.235]) ([10.213.168.235])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 13:58:40 -0800
Message-ID: <5d88bb70-a927-8261-1217-f1d865851c55@intel.com>
Date: Mon, 7 Nov 2022 13:58:39 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v2 13/19] tools/testing/cxl: Add "passphrase secure erase"
 opcode support
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377436599.430546.9691226328917294997.stgit@djiang5-desk3.ch.intel.com>
 <20221107153537.0000050e@Huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221107153537.0000050e@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2022 7:35 AM, Jonathan Cameron wrote:
> On Wed, 21 Sep 2022 08:32:46 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> Add support to emulate a CXL mem device support the "passphrase secure
>> erase" operation.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>   tools/testing/cxl/test/mem.c |   56 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 56 insertions(+)
>>
>> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
>> index 840378d239bf..a0a58156c15a 100644
>> --- a/tools/testing/cxl/test/mem.c
>> +++ b/tools/testing/cxl/test/mem.c
>> @@ -356,6 +356,59 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
>>   	return 0;
>>   }
>>   
>> +static int mock_passphrase_erase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>> +{
>> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
>> +	struct cxl_pass_erase *erase;
>> +
>> +	if (cmd->size_in != sizeof(*erase))
>> +		return -EINVAL;
>> +
>> +	if (cmd->size_out != 0)
>> +		return -EINVAL;
>> +
>> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
>> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>> +		return -ENXIO;
>> +	}
>> +
> 
> I think we need to check also that the passphrase supplied is not the
> master one in which case the lockout on user passphrase shouldn't matter.

Ok.

> 
>> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
>> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>> +		return -ENXIO;
>> +	}
>> +
>> +	erase = cmd->payload_in;
>> +	if (erase->type == CXL_PMEM_SEC_PASS_MASTER &&
>> +	    mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET &&
>> +	    memcmp(mdata->master_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
>> +		if (++mdata->master_limit == PASS_TRY_LIMIT)
> 
> It's harmless, but I'm not sure I like the adding to this when we've already
> hit the limit.  Maybe only increment if not?

I'll rework the whole thing and have helper function to handle this 
since it's used in quite a few places.

> 
>> +			mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
>> +		cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>> +		return -ENXIO;
>> +	}
>> +
>> +	if (erase->type == CXL_PMEM_SEC_PASS_USER &&
>> +	    mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET &&
>> +	    memcmp(mdata->user_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
>> +		if (++mdata->user_limit == PASS_TRY_LIMIT)
>> +			mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
>> +		cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>> +		return -ENXIO;
>> +	}
>> +
>> +	if (erase->type == CXL_PMEM_SEC_PASS_USER) {
>> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
>> +		mdata->user_limit = 0;
> 
> I think it would be more logical to set this to zero as part of the password
> testing block above rather than down here.
> 
> I also 'think' the user passphrase is wiped even if the secure erase was
> done with the master key.
> "The user passphrase shall be disabled after secure erase, but the master passphrase, if set, shall
> be unchanged" doesn't say anything about only if the user passphrase was the one used to
> perform the erase.

Yeah I'll rework this part.

> 
>> +		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
>> +	} else if (erase->type == CXL_PMEM_SEC_PASS_MASTER) {
>> +		mdata->master_limit = 0;
>> +	}
>> +
>> +	mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
>> +
>> +	return 0;
>> +}
>> +
> 
> 
> 
