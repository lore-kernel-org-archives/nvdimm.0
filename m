Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-ID: <5797DE97.5080508@redhat.com>
Date: Tue, 26 Jul 2016 18:05:11 -0400
From: Linda Knippers <lknipper@redhat.com>
MIME-Version: 1.0
Subject: Re: btt ndctl question
References: <5797C9DE.3070901@redhat.com>
 <20160726205843.GA5520@omniknight.lm.intel.com>
 <1469568262.7270.5.camel@intel.com>
 <CAPcyv4hbfMYptiA_m_EbLiqLWpVWB6kaDxg7TE6g7+F=PpoKiA@mail.gmail.com>
 <20160726214139.GB5520@omniknight.lm.intel.com>
 <CAPcyv4gSTp63J6P927Ys9ZJMqm0RnDqzdxgWEGksq-ZR5RiAig@mail.gmail.com>
In-Reply-To: <CAPcyv4gSTp63J6P927Ys9ZJMqm0RnDqzdxgWEGksq-ZR5RiAig@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/26/2016 05:55 PM, Dan Williams wrote:
> On Tue, Jul 26, 2016 at 2:41 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
>> On 07/26, Dan Williams wrote:
>>> On Tue, Jul 26, 2016 at 2:24 PM, Verma, Vishal L
>>> <vishal.l.verma@intel.com> wrote:
>>>> On Tue, 2016-07-26 at 14:58 -0600, Vishal Verma wrote:
>>>>> On 07/26, Linda Knippers wrote:
>>>>>>
>>>>>> My system has 4 8G NVDIMMs and I have them configured in different
>>>>>> ways, as you can
>>>>>> see from the ndctl output:
>>>>>>
>>>>>> $ ndctl list
>>>>>> [
>>>>>>   {
>>>>>>     "dev":"namespace3.0",
>>>>>>     "mode":"raw",
>>>>>>     "size":8589934592,
>>>>>>     "blockdev":"pmem3"
>>>>>>   },
>>>>>>   {
>>>>>>     "dev":"namespace2.0",
>>>>>>     "mode":"memory",
>>>>>>     "size":8587837440,
>>>>>>     "uuid":"2567d762-68ae-486b-a6eb-2d3ab1b9dca9",
>>>>>>     "blockdev":"pmem2"
>>>>>>   },
>>>>>>   {
>>>>>>     "dev":"namespace1.0",
>>>>>>     "mode":"sector",
>>>>>>     "uuid":"44fb474e-7db8-4438-ad95-05ecb9f2075e",
>>>>>>     "sector_size":4096,
>>>>>>     "blockdev":"pmem1s"
>>>>>>   },
>>>>>>   {
>>>>>>     "dev":"namespace0.0",
>>>>>>     "mode":"memory",
>>>>>>     "size":8453619712,
>>>>>>     "uuid":"933ed54b-5b64-47f1-8409-c88f7c846522",
>>>>>>     "blockdev":"pmem0"
>>>>>>   }
>>>>>> ]
>>>>>>
>>>>>> The two memory namespaces have different sizes because one is --
>>>>>> map=dev and the other is --map=mem.
>>>>>> It would be nice if the map option was displayed but my question is
>>>>>> about the size value for the
>>>>>> btt device, or lack of one.
>>>>>>
>>>>>> All the namespaces show a size except for the btt.  The btt only
>>>>>> shows a sector size.  There
>>>>>> is no size value exposed by the btt sysfs information, which is
>>>>>> probably why it's not in ndctl.
>>>>>>
>>>>>> I know the size can be gotten from the block device but it looks
>>>>>> like an omission here.
>>>>>> Is this a bug or a feature?
>>>>>
>>>>> Probably an omission :)
>>>>> This patch should expose a size attribute in sysfs:
>>>>>
>>>>> $ cat /sys/bus/nd/devices/btt7.0/size
>>>>> 32440320
>>>>>
>>>>> I can look at the 'ndctl list' enabling too if this looks good.
>>>>>
>>>>> 8<------
>>>>>
>>>>> From fb119bf4380d1d65d82754e581bbd41161c2100f Mon Sep 17 00:00:00 2001
>>>>> From: Vishal Verma <vishal.l.verma@intel.com>
>>>>> Date: Tue, 26 Jul 2016 14:54:39 -0600
>>>>> Subject: [PATCH] nvdimm, btt: add a size attribute for BTTs
>>>>>
>>>>> To be consistent with other namespaces, expose a 'size' attribute for
>>>>> BTT devices also.
>>>>>
>>>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>>>> Reported-by: Linda Knippers <linda.knippers@hpe.com>
>>>>> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>>>>> ---
>>>>>  drivers/nvdimm/btt.c      |  1 +
>>>>>  drivers/nvdimm/btt_devs.c | 15 +++++++++++++++
>>>>>  drivers/nvdimm/nd.h       |  1 +
>>>>>  3 files changed, 17 insertions(+)
>>>>>
>>>>> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
>>>>> index 68a7c3c..71ce0dc 100644
>>>>> --- a/drivers/nvdimm/btt.c
>>>>> +++ b/drivers/nvdimm/btt.c
>>>>> @@ -1270,6 +1270,7 @@ static int btt_blk_init(struct btt *btt)
>>>>>               }
>>>>>       }
>>>>>       set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >>
>>>>> 9);
>>>>> +     btt->nd_btt->size = btt->nlba * btt->sector_size;
>>>>
>>>> Blargh, I think I was a bit hasty; I think this should be:
>>>>
>>>> +       btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
>>>>
>>>> Right? (I always get bit by integer promotion rules...)
>>>
>>> ...but at this point we're identical to what the block layer is
>>> reporting.  The other 'size' attributes are communicating the raw
>>> byte-aligned capacity of the namespace minus local driver overhead.
>>
>> Wouldn't we want to be identical to what the block layer is reporting?
>> The only difference would come from removing any sub-sector capacity in
>> our case - is that information useful/desirable? I'd think being
>> consistent with the block layer reporting makes most sense..
>>
> 
> It does for btt, but since it's impossible for btt/size to a return a
> different answer than block/size, userspace should just look at
> block/size.
> 
> We have the 'size' attribute independent of sector alignment for the
> other configurations because those use cases might be ignoring the
> block interface... well only in the device-dax case now that we
> de-featured raw block-device dax.
> 
> I guess we could just go ahead and add just to be symmetrical, but the
> motivation for the other 'size' attributes is that they could identify
> capacity lost to sector alignment.

The units reported by the block layer are different (512 byte blocks vs. bytes)
so I like having the btt size here in bytes like for the other cases.

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
