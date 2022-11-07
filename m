Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9A72F37
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667847729; x=1699383729;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vty6bEH9GGPz9InbbRoli/5mySF27uGjMLiSatxag9s=;
  b=NP1pwmjdNWNGiF3paONX38UJofFclJwZcSswnH6vLR4j7/KhlH2LAqDQ
   6dEahkkqBYZZ3J+DfnUfkBZodGmNWSOC8SvecjPWJPFDMGm9MpI9suDIo
   UloFCjViyk8yPb7RX6ynzhDUC83bZhbG4ZTrf3MPWd2k/hzisZH3yeyrE
   kMAeYeLnHxyyQaSXbyF88wDhV/Uuo5ZQLvyrk/HXOJC0CRbXBFuUPbOQL
   GOyEKfvL2EMMNQ0EFSlkUuQzn0omzUPpuxcbFN464LWFBUAgCpVjXKeNC
   //XxwJCP6n7V9JJNZZQ+VVyjgpf3iGM+hkZKESy7YRqIxEUH3s4a86Ufj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293864272"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293864272"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 11:01:47 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="630597490"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="630597490"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.213.168.235]) ([10.213.168.235])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 11:01:46 -0800
Message-ID: <57305aec-2d39-ce5a-0d47-ee1110834d26@intel.com>
Date: Mon, 7 Nov 2022 11:01:45 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v2 09/19] tools/testing/cxl: Add "Freeze Security State"
 security opcode support
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377434213.430546.16329545604946404040.stgit@djiang5-desk3.ch.intel.com>
 <20221107144411.000079eb@Huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221107144411.000079eb@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2022 6:44 AM, Jonathan Cameron wrote:
> On Wed, 21 Sep 2022 08:32:22 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> Add support to emulate a CXL mem device support the "Freeze Security State"
>> operation.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>   tools/testing/cxl/test/mem.c |   27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
>> index 40dccbeb9f30..b24119b0ea76 100644
>> --- a/tools/testing/cxl/test/mem.c
>> +++ b/tools/testing/cxl/test/mem.c
>> @@ -290,6 +290,30 @@ static int mock_disable_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_
>>   	return 0;
>>   }
>>   
>> +static int mock_freeze_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>> +{
>> +	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
>> +
>> +	if (cmd->size_in != 0)
>> +		return -EINVAL;
>> +
>> +	if (cmd->size_out != 0)
>> +		return -EINVAL;
>> +
>> +	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
> 
> There are list of commands that should return invalid security state in
> 8.2.9.8.6.5 but doesn't include Freeze Security state.
> Hence I think this is idempotent and writing to frozen when frozen succeeds
> - it just doesn't change anything.

Ok will return 0.

> 
>> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>> +		return -ENXIO;
>> +	}
>> +
>> +	if (!(mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET)) {
> 
> This needs a spec reference.  (which is another way of saying I'm not sure
> why it is here).

Will remove. It feels like the spec around this area is rather sparse 
and missing a lot of details. i.e. freezing security w/o security set.

> 
>> +		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>> +		return -ENXIO;
>> +	}
>> +
>> +	mdata->security_state |= CXL_PMEM_SEC_STATE_FROZEN;
>> +	return 0;
>> +}
>> +
>>   static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
>>   {
>>   	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
>> @@ -392,6 +416,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>>   	case CXL_MBOX_OP_DISABLE_PASSPHRASE:
>>   		rc = mock_disable_passphrase(cxlds, cmd);
>>   		break;
>> +	case CXL_MBOX_OP_FREEZE_SECURITY:
>> +		rc = mock_freeze_security(cxlds, cmd);
>> +		break;
>>   	default:
>>   		break;
>>   	}
>>
>>
> 
> 
