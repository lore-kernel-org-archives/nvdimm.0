Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D6679FB
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 18:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668449724; x=1699985724;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t7hVw3n9MUkhnNfoBZhdtVT9ke8JxrpRqMvARGuSX/U=;
  b=Widp7TaaF536btdbGxvQ506LzvojAS4/AV8S5cDTuB5POtE+vYkLA2bM
   A5WWbiulUJd2qu2wx40l2CgY/XyhMCd7fjurAd3P9syNwJlVnnSt7Deyp
   GH1lxVlggHtFBznuqinN2yFB86UYSmLRhtrDwUsQ7dPALrPbj2se8dt8a
   oQyvnteCkZFDKECApjjs9ySZqoRlCzHvxVqCI+qKNxtYhwSIK9tG6QMgw
   K3GlTRMmxYcbfALtjc5/Vio9PXf9SMZAU45kdIJoo6J+PxdwBWjh0in12
   0mirSm8CO0I3B2Qep4odFpiRGAjnGKREy7y926kJmBppqKve1EYBcHWme
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="295405827"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="295405827"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 10:15:24 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="638591582"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="638591582"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.53.251]) ([10.212.53.251])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 10:15:23 -0800
Message-ID: <5edc575b-9251-5333-f099-bae6ebbc0edf@intel.com>
Date: Mon, 14 Nov 2022 11:15:22 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v3 12/18] tools/testing/cxl: Add "passphrase secure erase"
 opcode support
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, dave@stgolabs.net
References: <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
 <166792839079.3767969.17718924625264191957.stgit@djiang5-desk3.ch.intel.com>
 <20221111103748.000051c5@Huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221111103748.000051c5@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/2022 2:37 AM, Jonathan Cameron wrote:
> On Tue, 08 Nov 2022 10:26:30 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> Add support to emulate a CXL mem device support the "passphrase secure
>> erase" operation.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Hi Dave,
> 
> My feedback in previous version was in the wrong place and I think that
> led you to update the wrong error path.
> 
> See inline
> 
> Jonathan
> 
>> ---
>>   tools/testing/cxl/test/mem.c |   59 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 59 insertions(+)
>>
>> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
>> index 90607597b9a4..aa6dda21bc5f 100644
>> --- a/tools/testing/cxl/test/mem.c
>> +++ b/tools/testing/cxl/test/mem.c
>> @@ -362,6 +362,62 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
>>   	return 0;
>>   }
>>   
>> +static int mock_passphrase_secure_erase(struct cxl_dev_state *cxlds,
>> +					struct cxl_mbox_cmd *cmd)
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
>> +	erase = cmd->payload_in;
>> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN &&
>> +	    erase->type != CXL_PMEM_SEC_PASS_MASTER) {
>> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>> +		return -ENXIO;
>> +	}
> 
> A stuck my comment in a rather odd location.  I was commenting not
> on the block above, but rather the one below.
> 
> Frozen it's fixed by providing the master pass phrase - so the
> above should just check if frozen.
> 
> The original comment was about the neck block.  Having failed user
> passcode too many times isn't relevant if the one provided this
> time is the master passcode - so add the
> erase->type != CXL_PMEM_SEC_PASS_MASTER to the next if block.

We probably better off do "erase->type == CXL_PMEM_SEC_PASS_USER" to 
check the limit against the user type?

Also while we are here, I think I'm missing a check against the master 
passphrase limit here as well. So probably we should have something like?

         if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT &&
             erase->type == CXL_PMEM_SEC_PASS_USER) {
                 cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
                 return -ENXIO;
         }

         if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIMIT &&
             erase->type == CXL_PMEM_SEC_PASS_MASTER) {
                 cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
                 return -ENXIO;
         }

> 
>> +
>> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
>> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>> +		return -ENXIO;
>> +	}
>> +
>> +	if (erase->type == CXL_PMEM_SEC_PASS_MASTER &&
>> +	    mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET) {
>> +		if (memcmp(mdata->master_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
>> +			master_plimit_check(mdata);
>> +			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>> +			return -ENXIO;
>> +		}
>> +		mdata->master_limit = 0;
>> +		mdata->user_limit = 0;
>> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
>> +		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
>> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
>> +		return 0;
>> +	}
>> +
>> +	if (erase->type == CXL_PMEM_SEC_PASS_USER &&
>> +	    mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
>> +		if (memcmp(mdata->user_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
>> +			user_plimit_check(mdata);
>> +			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>> +			return -ENXIO;
>> +		}
>> +
>> +		mdata->user_limit = 0;
>> +		mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
>> +		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
>> +		return 0;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>>   {
>>   	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
>> @@ -470,6 +526,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>>   	case CXL_MBOX_OP_UNLOCK:
>>   		rc = mock_unlock_security(cxlds, cmd);
>>   		break;
>> +	case CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE:
>> +		rc = mock_passphrase_secure_erase(cxlds, cmd);
>> +		break;
>>   	default:
>>   		break;
>>   	}
>>
>>
> 
