Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96B46211575C7
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 14:36:14 -0700 (PDT)
Subject: Re: [PATCH 2/2] nvdimm: Set device node in nd_device_register
References: <20180925204801.6182.73167.stgit@localhost.localdomain>
 <20180925205307.6182.26453.stgit@localhost.localdomain>
 <CAPcyv4jpUNP4mySPr5jYogpf5ZMPgpTu9oOjC89ZYHa=vL1JwQ@mail.gmail.com>
 <bcd44872-1961-79ff-f1a5-8ab2c2a99c20@linux.intel.com>
 <CAPcyv4jhxGubqLiHC=jqy2Bn7XQALUUoFcfEVKCUSeqGWCstLA@mail.gmail.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <c6a5b7b0-954a-d84f-4927-03e51a016394@linux.intel.com>
Date: Tue, 25 Sep 2018 14:35:33 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jhxGubqLiHC=jqy2Bn7XQALUUoFcfEVKCUSeqGWCstLA@mail.gmail.com>
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
Cc: zwisler@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 9/25/2018 2:32 PM, Dan Williams wrote:
> On Tue, Sep 25, 2018 at 2:11 PM Alexander Duyck
> <alexander.h.duyck@linux.intel.com> wrote:
>>
>>
>>
>> On 9/25/2018 2:08 PM, Dan Williams wrote:
>>> On Tue, Sep 25, 2018 at 1:56 PM Alexander Duyck
>>> <alexander.h.duyck@linux.intel.com> wrote:
>>>>
>>>> This change makes it so that we don't repeatedly overwrite the device node
>>>> for nvdimm regions. The earliest we can set the node is immediately after
>>>> calling device init, so I have moved the code there so we can avoid
>>>> rewriting the node with each uevent.
>>>>
>>>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>>> ---
>>>>    drivers/nvdimm/bus.c |   16 ++++++++++------
>>>>    1 file changed, 10 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
>>>> index 9148015ed803..96f4d0e1706a 100644
>>>> --- a/drivers/nvdimm/bus.c
>>>> +++ b/drivers/nvdimm/bus.c
>>>> @@ -54,12 +54,6 @@ static int to_nd_device_type(struct device *dev)
>>>>
>>>>    static int nvdimm_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
>>>>    {
>>>> -       /*
>>>> -        * Ensure that region devices always have their numa node set as
>>>> -        * early as possible.
>>>> -        */
>>>> -       if (is_nd_region(dev))
>>>> -               set_dev_node(dev, to_nd_region(dev)->numa_node);
>>>>           return add_uevent_var(env, "MODALIAS=" ND_DEVICE_MODALIAS_FMT,
>>>>                           to_nd_device_type(dev));
>>>>    }
>>>> @@ -519,6 +513,16 @@ void __nd_device_register(struct device *dev)
>>>>    void nd_device_register(struct device *dev)
>>>>    {
>>>>           device_initialize(dev);
>>>> +
>>>> +       /*
>>>> +        * Ensure that region devices always have their NUMA node set as
>>>> +        * early as possible. This way we are able to make certain that any
>>>> +        * memory associated with the creation and the creation itself of
>>>> +        * the region is associated with the correct node.
>>>> +        */
>>>> +       if (is_nd_region(dev))
>>>> +               set_dev_node(dev, to_nd_region(dev)->numa_node);
>>>> +
>>>>           __nd_device_register(dev);
>>>
>>> Any reason to not put this inside __nd_device_register()? If you're ok
>>> with that I can just fix up when applying.
>>
>> I put it here since regions never call __nd_device_register directly,
>> they always call nd_device_register. I figured that by placing it here
>> we reduce the impact of this on the other devices that aren't going to
>> need it.
> 
> I can't imagine there's much of an impact because we're already
> reading the cacheline that has dev->parent so dev->type is already
> there. If we're going to add support for looking up the parent node to
> schedule namespace registration work to the proper core I would expect
> that to appear in the __nd_device_register() common code as well.
> 
> In general the only consideration for calling nd_device_register() vs
> __nd_device_register() is whether or not you want a
> device_initialize() to occur.

Yeah, I kind of gathered that. If you want to move it feel free to.

- Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
