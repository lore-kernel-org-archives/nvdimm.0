Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 341A9211616A6
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 10:07:29 -0700 (PDT)
Subject: Re: [PATCH v2] libnvdimm, dimm: Maximize label transfer size
References: <153842839852.2679462.16816747305002065908.stgit@dwillia2-desk3.amr.corp.intel.com>
 <71e2a4b6-68d9-d90d-b927-90840d8c6ee1@linux.intel.com>
 <CAPcyv4jQ7eAbEaUUP0R_JFKRADGU1kXhMd_Q=Gw5+1Xki5WYjA@mail.gmail.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <051ce2c1-41ed-a42d-7f55-1303f8f33c32@linux.intel.com>
Date: Tue, 2 Oct 2018 10:07:27 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jQ7eAbEaUUP0R_JFKRADGU1kXhMd_Q=Gw5+1Xki5WYjA@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 10/1/2018 3:02 PM, Dan Williams wrote:
> On Mon, Oct 1, 2018 at 2:54 PM Alexander Duyck
> <alexander.h.duyck@linux.intel.com> wrote:
>>
>>
>>
>> On 10/1/2018 2:14 PM, Dan Williams wrote:
>>> Use kvzalloc() to bypass the arbitrary PAGE_SIZE limit of label transfer
>>> operations. Given the expense of calling into firmware, maximize the
>>> amount of label data we transfer per call to be up to the total label
>>> space if allowed by the firmware, or 256K whichever is smaller.
>>>
>>> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>> ---
>>> Changes in v2:
>>> * clamp the max allocation size at 256K in case large label areas with
>>>     unlimited transfer sizes appear in the future.
>>>
>>>    drivers/nvdimm/dimm_devs.c       |   14 ++++++++------
>>>    tools/testing/nvdimm/test/nfit.c |    2 +-
>>>    2 files changed, 9 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
>>> index 863cabc35215..3616e2e47788 100644
>>> --- a/drivers/nvdimm/dimm_devs.c
>>> +++ b/drivers/nvdimm/dimm_devs.c
>>> @@ -111,8 +111,9 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
>>>        if (!ndd->data)
>>>                return -ENOMEM;
>>>
>>> -     max_cmd_size = min_t(u32, PAGE_SIZE, ndd->nsarea.max_xfer);
>>> -     cmd = kzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
>>> +     max_cmd_size = min_t(u32, ndd->nsarea.config_size, SZ_256K);
>>> +     max_cmd_size = min_t(u32, max_cmd_size, ndd->nsarea.max_xfer);
>>> +     cmd = kvzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
>>>        if (!cmd)
>>>                return -ENOMEM;
>>>
>>
>> So I wouldn't use 256K as the limit, maybe 256K minus the sizeof(*cmd).
>> Otherwise you are still allocating additional memory to take care of
>> that little trailing bit that is being added.
> 
> Does it matter? This is a slow / infrequently used path and I do don't
> see the practical difference of 256K vs slightly less than 256K.

It depends on the approach used. From past experience 256K could easily 
become 512K with just that extra bit of overhead. That is why I was 
thinking if we are going to make 256K the limit, we should make that the 
hard limit and not add a little bit extra onto it.

>>> @@ -134,7 +135,7 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
>>>                memcpy(ndd->data + offset, cmd->out_buf, cmd->in_length);
>>>        }
>>>        dev_dbg(ndd->dev, "len: %zu rc: %d\n", offset, rc);
>>> -     kfree(cmd);
>>> +     kvfree(cmd);
>>>
>>>        return rc;
>>>    }
>>> @@ -157,9 +158,10 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
>>>        if (offset + len > ndd->nsarea.config_size)
>>>                return -ENXIO;
>>>
>>> -     max_cmd_size = min_t(u32, PAGE_SIZE, len);
>>> +     max_cmd_size = min_t(u32, ndd->nsarea.config_size, SZ_256K);
>>>        max_cmd_size = min_t(u32, max_cmd_size, ndd->nsarea.max_xfer);
>>> -     cmd = kzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
>>> +     max_cmd_size = min_t(u32, max_cmd_size, len);
>>> +     cmd = kvzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
>>>        if (!cmd)
>>>                return -ENOMEM;
>>>
>>
>> For the set operation I am not sure you have any code that is going to
>> be updating things multiple labels at a time. From what I can tell the
>> largest set call you ever make is probably for a namespace index and
>> odds are that will only ever be 256 or 512 bytes.
> 
> Inside the kernel, true, but we do perform large sets from userspace.
> That said I don't see why this low level routine should encode
> layering violation knowledge of how it might be used.

Can userspace call this directly? I only see 3 callers of this and all 
of them limit themselves to writing either a single namespace index or 
label.

Also we know that the behavior is supposed to be that we only update 
what we have to as it introduces issues if we try to overwrite all of 
the config space. That is why I think it would be better to keep the 
upper limit for writes small anyway. That way we make it painful for 
somebody to do the wrong thing.

>> Also the limitations here could probably use some additional clean-up.
>> For example you have a check for offset + len > config_size above this
>> min_t calls. As such it should be impossible for length to ever be
>> greater than config_size so you shouldn't need to test for the min of
>> both and could just use the min of len versus the max_xfer.
> 
> Again that's a case of this leaf routine encoding assumptions about
> how it might be used. I'd rather be pedantic since this is not a hot
> path.

No. This is me reading the code. Just to be clear, before we start 
trying to determine the max_cmd_size we have the following bit of code:
	if (offset + len > ndd->nsarea.config_size)
		return -ENXIO;

So if that logic is already there how can we have len be greater than 
ndd->nsarea.config_size? As far as I can tell we can't so we could save 
ourselves one of the min_t checks since we know len should always be 
less than or equal to ndd->nsarea.config_size.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
