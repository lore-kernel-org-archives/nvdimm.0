Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4BA0224DCA55
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 16:20:47 -0800 (PST)
Subject: Re: [PATCH v3 1/2] ndctl: add check for update firmware supported
References: <152037991431.39785.10704524597897615503.stgit@djiang5-desk3.ch.intel.com>
 <152037997577.39785.391131497352047651.stgit@djiang5-desk3.ch.intel.com>
 <1520554210.6316.56.camel@intel.com>
 <CAPcyv4g_BSfP0Rg+8izUM-TyM1thmHMt4nmgijR7vKwMVsvv9A@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <6a9fb3ca-c6fa-2c0d-6531-778e14723e99@intel.com>
Date: Thu, 8 Mar 2018 17:27:02 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g_BSfP0Rg+8izUM-TyM1thmHMt4nmgijR7vKwMVsvv9A@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 03/08/2018 05:23 PM, Dan Williams wrote:
> On Thu, Mar 8, 2018 at 4:10 PM, Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
>>
>> On Tue, 2018-03-06 at 16:46 -0700, Dave Jiang wrote:
>>> Adding generic and intel support function to allow check if update
>>> firmware
>>> is supported by the kernel.
>>>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>>  ndctl/lib/firmware.c   |   11 +++++++++++
>>>  ndctl/lib/intel.c      |   24 ++++++++++++++++++++++++
>>>  ndctl/lib/libndctl.sym |    1 +
>>>  ndctl/lib/private.h    |    1 +
>>>  ndctl/libndctl.h       |    1 +
>>>  ndctl/update.c         |   13 +++++++++++++
>>>  6 files changed, 51 insertions(+)
>>>
>>> diff --git a/ndctl/lib/firmware.c b/ndctl/lib/firmware.c
>>> index f6deec5d..277b5399 100644
>>> --- a/ndctl/lib/firmware.c
>>> +++ b/ndctl/lib/firmware.c
>>> @@ -107,3 +107,14 @@ ndctl_cmd_fw_xlat_firmware_status(struct
>>> ndctl_cmd *cmd)
>>>       else
>>>               return FW_EUNKNOWN;
>>>  }
>>> +
>>> +NDCTL_EXPORT int
>>> +ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm)
>>> +{
>>> +     struct ndctl_dimm_ops *ops = dimm->ops;
>>> +
>>> +     if (ops && ops->fw_update_supported)
>>> +             return ops->fw_update_supported(dimm);
>>> +     else
>>> +             return -ENOTTY;
>>> +}
>>> diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
>>> index cee5204c..a4f0af26 100644
>>> --- a/ndctl/lib/intel.c
>>> +++ b/ndctl/lib/intel.c
>>> @@ -650,6 +650,29 @@ intel_dimm_cmd_new_lss(struct ndctl_dimm *dimm)
>>>       return cmd;
>>>  }
>>>
>>> +static int intel_dimm_fw_update_supported(struct ndctl_dimm *dimm)
>>> +{
>>> +     struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
>>> +
>>> +     if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
>>> +             dbg(ctx, "unsupported cmd: %d\n", ND_CMD_CALL);
>>> +             return -EOPNOTSUPP;
>>> +     }
>>> +
>>> +     /*
>>> +      * We only need to check FW_GET_INFO. If that isn't
>>> supported then
>>> +      * the others aren't either.
>>> +      */
>>
>> Since this is an is_supported type function, for completeness,
>> shouldn't we just check for all the related DSMs? I agree we will
>> probably never hit the case where say FW_GET_INFO is supported but
>> others aren't, but just adding in the other checks is probably better
>> than the possibility of running into a case where this passes but one
>> of the other functions isn't supported.
> 
> Some of them aren't required for example I think this gauntlet of
> checks is overkill, especially when we consider other vendor firmware
> update mechanisms that might not implement all of these...
> 
>         fw->store_size = ndctl_cmd_fw_info_get_storage_size(cmd);
>         if (fw->store_size == UINT_MAX)
>                 return -ENXIO;
> 
>         fw->update_size = ndctl_cmd_fw_info_get_max_send_len(cmd);
>         if (fw->update_size == UINT_MAX)
>                 return -ENXIO;
> 
>         fw->query_interval = ndctl_cmd_fw_info_get_query_interval(cmd);
>         if (fw->query_interval == UINT_MAX)
>                 return -ENXIO;
> 
>         fw->max_query = ndctl_cmd_fw_info_get_max_query_time(cmd);
>         if (fw->max_query == UINT_MAX)
>                 return -ENXIO;
> 
>         fw->run_version = ndctl_cmd_fw_info_get_run_version(cmd);
>         if (fw->run_version == ULLONG_MAX)
>                 return -ENXIO;
> 
> ...so yes, I think it would be could to expand the 'supported' checks,
> but only to the bare minimum that would allow a firmware update to
> complete.
> 

At least for the Intel firmware update, every one of the DSM calls are
required to complete all the steps.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
