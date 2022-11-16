Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633F812290
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 21:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668635644; x=1700171644;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ssNnKW3m1VbQSW7lIz2fC3HQt73/AjS03MpiKrdcyQQ=;
  b=N6SSLgsQksGJNdv1DEjsWCYPNBVwOblxDYFNdDpghxVu7zvfqZC58eMh
   gG0XCLTvObXUpx7WXrM41OAsCxpi9uyIwRTOcborNe0Wh9yz/xnQFpxoG
   M2IvpV02QZkLQSojw9LmUPPxInBxK7/J9J/FUpu2+/DEGdtHsEMdfBXZQ
   H337ISyXeX7CFu8kK7Uy99/J991qVfdUNW8ntBW/vOhSlX5J3KtzZ+Pq8
   +gCAmxlRqKHmB5sk84+E5PolLSSeZpzDX1Q2ADG/9Z5kpgpTXONxYjueP
   Nrm+PYlgEMp9gCo9HQQEq/Nri/dVoJ0dR7iH3XWzDaEZ2NmCiLuFs2qgJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="376946806"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="376946806"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:54:04 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="639527338"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="639527338"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.31.244]) ([10.212.31.244])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:54:03 -0800
Message-ID: <bbe4be20-5f2e-077f-009a-4ece6b1c9324@intel.com>
Date: Wed, 16 Nov 2022 14:54:02 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v4 12/18] tools/testing/cxl: Add "passphrase secure erase"
 opcode support
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, dave@stgolabs.net
References: <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
 <166845805415.2496228.732168029765896218.stgit@djiang5-desk3.ch.intel.com>
 <20221115110831.00001fa4@Huawei.com>
 <a8ed61db-9bf1-410c-b4e6-7042f48a67ff@intel.com>
 <14ae41bc-2d63-460b-5ac5-a4d94aa39982@intel.com>
 <20221116114335.00006a3d@Huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221116114335.00006a3d@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/16/2022 3:43 AM, Jonathan Cameron wrote:
> On Tue, 15 Nov 2022 10:01:53 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> On 11/15/2022 7:57 AM, Dave Jiang wrote:
>>>
>>>
>>> On 11/15/2022 3:08 AM, Jonathan Cameron wrote:
>>>> On Mon, 14 Nov 2022 13:34:14 -0700
>>>> Dave Jiang <dave.jiang@intel.com> wrote:
>>>>   
>>>>> Add support to emulate a CXL mem device support the "passphrase secure
>>>>> erase" operation.
>>>>>
>>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>> The logic in here gives me a headache but I'm not sure it's correct
>>>> yet...
>>>>
>>>> If you can figure out what is supposed to happen if this is called
>>>> with Passphrase Type == master before the master passphrase has been set
>>>> then you are doing better than me.
>>>>
>>>> Unlike for the User passphrase, where the language " .. and the user
>>>> passphrase
>>>> is not currently set or is not supported by the device, this value is
>>>> ignored."
>>>> to me implies we wipe the device and clear the non existent user pass
>>>> phrase,
>>>> the not set master passphrase case isn't covered as far as I can see.
>>>>
>>>> The user passphrase question raises a futher question (see inline)
>>>>
>>>> Thoughts?
>>>
>>> Guess this is what happens when you bolt on master passphrase support
>>> after defining the spec without its existence, and then move it to a
>>> different spec and try to maintain compatibility between the two in
>>> order to not fork the hardware/firmware....
>>>
>>> Should we treat the no passphrase set instance the same as sending a
>>> Secure Erase (Opcode 4401h)? And then the only case left is no master
>>> pass set but user pass is set.
>>>
>>> if (!master_pass_set && pass_type_master) {
>>>       if (user_pass_set)
>>>           return -EINVAL;
>>>       else
>>>           secure_erase;
>>> }
>>>   
>> This is the current change:
>>
>> +       switch (erase->type) {
>> +       case CXL_PMEM_SEC_PASS_MASTER:
>> +               if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET) {
>> +                       if (memcmp(mdata->master_pass, erase->pass,
>> +                                  NVDIMM_PASSPHRASE_LEN)) {
>> +                               master_plimit_check(mdata);
>> +                               cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>> +                               return -ENXIO;
>> +                       }
>> +                       mdata->master_limit = 0;
>> +                       mdata->user_limit = 0;
>> +                       mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
>> +                       memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
>> +                       mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
> 
>> +               } else if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
>> +                       return -EINVAL;
>> +               }

So while looking at 8.2.9.8.6.3 I stumbled on this line: "When the 
master passphrase is disabled, the device shall return Invalid Input for 
the Passphrase Secure Erase command with the master passphrase". I 
suppose the above would reduce to just else {} instead? And it probably 
wouldn't hurt to have the spec duplicate this line under the passphrase 
secure erase section as well.

> I would add a comment here to say what we aren't faking.  The aim being to show that
> in all the good paths this happens, even though we don't do the other stuff in
> some of them.
> 
> /* Scramble encryption keys so that data is effectively erased */
> 
>> +
>> +               return 0;
>> +       case CXL_PMEM_SEC_PASS_USER:
>> +               if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
>> +                       if (memcmp(mdata->user_pass, erase->pass,
>> +                                  NVDIMM_PASSPHRASE_LEN)) {
>> +                               user_plimit_check(mdata);
>> +                               cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>> +                               return -ENXIO;
>> +                       }
>> +                       mdata->user_limit = 0;
>> +                       mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
>> +                       memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
>> +               }
>> +
> 
> /* Scramble encryption keys so that data is effectively erased */
> here as well for the same reason.
> 
>> +               return 0;
>> +       default:
>> +               fallthrough;
> 
> Might as well return -EINVAL; here and drop the below one.
> 
> Otherwise looks good to me.  We could sprinkle some comments in here to
> hightlight why we have concluded it ought to behave like this.
> If nothing else, I doubt either of us will remember when we look at this
> code in more than a few days time ;)
> 
> Otherwise looks good to me.
> 
> Jonathan
> 
> 
>> +       }
>> +
>> +       return -EINVAL;
>>
>>
>>
>>>>
>>>> Other than that some suggestions inline but nothing functional, so up
>>>> to you.
>>>> Either way
>>>>
>>>> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>>>>   
>>>>> ---
>>>>>    tools/testing/cxl/test/mem.c |   65
>>>>> ++++++++++++++++++++++++++++++++++++++++++
>>>>>    1 file changed, 65 insertions(+)
>>>>>
>>>>> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
>>>>> index 90607597b9a4..fc28f7cc147a 100644
>>>>> --- a/tools/testing/cxl/test/mem.c
>>>>> +++ b/tools/testing/cxl/test/mem.c
>>>>> @@ -362,6 +362,68 @@ static int mock_unlock_security(struct
>>>>> cxl_dev_state *cxlds, struct cxl_mbox_cmd
>>>>>        return 0;
>>>>>    }
>>>>> +static int mock_passphrase_secure_erase(struct cxl_dev_state *cxlds,
>>>>> +                    struct cxl_mbox_cmd *cmd)
>>>>> +{
>>>>> +    struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
>>>>> +    struct cxl_pass_erase *erase;
>>>>> +
>>>>> +    if (cmd->size_in != sizeof(*erase))
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    if (cmd->size_out != 0)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    erase = cmd->payload_in;
>>>>> +    if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
>>>>> +        cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>>>>> +        return -ENXIO;
>>>>> +    }
>>>>> +
>>>>> +    if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT &&
>>>>> +        erase->type == CXL_PMEM_SEC_PASS_USER) {
>>>>> +        cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>>>>> +        return -ENXIO;
>>>>> +    }
>>>>> +
>>>>> +    if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIMIT &&
>>>>> +        erase->type == CXL_PMEM_SEC_PASS_MASTER) {
>>>>> +        cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
>>>>> +        return -ENXIO;
>>>>> +    }
>>>>> +
>>>>> +    if (erase->type == CXL_PMEM_SEC_PASS_MASTER &&
>>>>> +        mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET) {
>>>>> +        if (memcmp(mdata->master_pass, erase->pass,
>>>>> NVDIMM_PASSPHRASE_LEN)) {
>>>>> +            master_plimit_check(mdata);
>>>>> +            cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>>>>> +            return -ENXIO;
>>>>> +        }
>>>>> +        mdata->master_limit = 0;
>>>>> +        mdata->user_limit = 0;
>>>>> +        mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
>>>>> +        memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
>>>>> +        mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
>>>>> +        return 0;
>>>>> +    }
>>>> What to do if the masterpass phrase isn't set?
>>>> Even if we return 0, I'd slightly prefer to see that done locally so
>>>> refactor as
>>>>      if (erase->type == CXL_PMEM_SEC_PASS_MASTER) {
>>>>          if (!(mdata->security_state &
>>>> CXL_PMEM_SEC_STATATE_MASTER_PASS_SET)) {
>>>>              return 0; /* ? */
>>>>          if (memcmp)...
>>>>      } else { /* CXL_PMEM_SEC_PASS_USER */ //or make it a switch.
>>>>   
>>>>> +
>>>>> +    if (erase->type == CXL_PMEM_SEC_PASS_USER &&
>>>>> +        mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
>>>>
>>>> Given we aren't actually scrambling the encryption keys (as we don't
>>>> have any ;)
>>>> it doesn't make a functional difference, but to line up with the spec,
>>>> I would
>>>> consider changing this to explicitly have the path for no user
>>>> passphrase set.
>>>>
>>>>      if (erase->type == CXL_PMEM_SEC_PASS_USER) {
>>>>          if (mdata->security_state & CXL_MEM_SEC_STATE_USER_PASS_SET) {
>>>>                  if (memcmp(mdata->user_pass, erase->pass,
>>>> NVDIMM_PASSPHRASE_LEN)) {
>>>>                  user_plimit_check(mdata);
>>>>                  cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>>>>                  return -ENXIO;
>>>>                }
>>>>
>>>>              mdata->user_limit = 0;
>>>>              mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
>>>>              memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
>>>>          }
>>>>          /* Change encryption keys */
>>>>          return 0;
>>>>      }
>>>>   
>>>>> +        if (memcmp(mdata->user_pass, erase->pass,
>>>>> NVDIMM_PASSPHRASE_LEN)) {
>>>>> +            user_plimit_check(mdata);
>>>>> +            cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
>>>>> +            return -ENXIO;
>>>>> +        }
>>>>> +
>>>>> +        mdata->user_limit = 0;
>>>>> +        mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
>>>>> +        memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
>>>>> +        return 0;
>>>>> +    }
>>>>> +
>>>>> +    return 0;
>>>>
>>>> With above changes you can never reach here.
>>>>   
>>>>> +}
>>>>> +
>>>>>    static int mock_get_lsa(struct cxl_dev_state *cxlds, struct
>>>>> cxl_mbox_cmd *cmd)
>>>>>    {
>>>>>        struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
>>>>> @@ -470,6 +532,9 @@ static int cxl_mock_mbox_send(struct
>>>>> cxl_dev_state *cxlds, struct cxl_mbox_cmd *
>>>>>        case CXL_MBOX_OP_UNLOCK:
>>>>>            rc = mock_unlock_security(cxlds, cmd);
>>>>>            break;
>>>>> +    case CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE:
>>>>> +        rc = mock_passphrase_secure_erase(cxlds, cmd);
>>>>> +        break;
>>>>>        default:
>>>>>            break;
>>>>>        }
>>>>>
>>>>>   
>>>>   
> 
> 
