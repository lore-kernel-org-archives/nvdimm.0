Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <56952E17.5010007@hpe.com>
References: <1450393200-6802-1-git-send-email-toshi.kani@hpe.com>
	<1450427687.11503.14.camel@kernel.org>
	<1450451737.20148.121.camel@hpe.com>
	<CAPcyv4iBk+DwHRBu=zAzSYrqD3Ni_cdK2630FuREtAhtDk5rdw@mail.gmail.com>
	<1450464730.10450.14.camel@hpe.com>
	<CAPcyv4hsZcg5UB7wJJ25cM4dbOGBx5tj7j6U8bR7r8f7hpP0bw@mail.gmail.com>
	<1452610938.19330.66.camel@hpe.com>
	<CAPcyv4hodeRzf_2BwA0j6zdmPAoV21iBKbBFWkQ2oP0X+uU+1g@mail.gmail.com>
	<56952E17.5010007@hpe.com>
Date: Tue, 12 Jan 2016 08:51:20 -0800
Message-ID: <CAPcyv4ik9Z+wnwPe+mhXzuVDmBhF9zh5bRQf0h4Mi9zN6ZQX+Q@mail.gmail.com>
Subject: Re: [PATCH] BTT: Change nd_btt_arena_is_valid() to verify UUID
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Toshi Kani <toshi.kani@hpe.com>, Vishal Verma <vishal@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, micah.parrish@hpe.com, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 12, 2016 at 8:47 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 1/12/2016 11:38 AM, Dan Williams wrote:
>> On Tue, Jan 12, 2016 at 7:02 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
>>> On Fri, 2015-12-18 at 14:23 -0800, Dan Williams wrote:
>>>> On Fri, Dec 18, 2015 at 10:52 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
>>>>> On Fri, 2015-12-18 at 09:54 -0800, Dan Williams wrote:
>>>>>> On Fri, Dec 18, 2015 at 7:15 AM, Toshi Kani <toshi.kani@hpe.com>
>>>>>> wrote:
>>>>>>> On Fri, 2015-12-18 at 01:34 -0700, Vishal Verma wrote:
>>>>>>>> Also, I wonder if this problem is solved by using libndctl to
>>>>>>>> manage
>>>>>>>> BTTs.
>>>>>>>
>>>>>>> I have not tested with libndctl yet, but I think our bind/unbind
>>>>>>> scripts do the same procedures.
>>>>>>
>>>>>> We loop through all combinations of sector size in our unit test.  If
>>>>>> you want to change the sector size the expectation is that the
>>>>>> namespace is destroyed and fully re-created, especially due to the
>>>>>> fact that changing sector size invalidates all data on the namespace.
>>>>>>
>>>>>> See: https://github.com/pmem/ndctl/blob/master/lib/test-libndctl.c
>>>>>
>>>>> The parent_uuid is not set on our NVDIMM-N systems.  I do not see
>>>>> 'uuid' file under sysfs 'namespaceX.X' per namespace_visible(), either.
>>>>> This concept of creating/destroying a namespace is a bit foreign to us
>>>>> since we've never needed to do.  Can you elaborate how it's supposed to
>>>>> work for NVDIMM-N?
>>>>>
>>>>
>>>> Ugh, yes.  An oversight on my part, let me give this some thought.
>>>> Whatever we decide, I want the libndctl api to be identical for the
>>>> two cases.
>>>>
>>>> I expect the simplest option is to have
>>>> ndctl_namespace_disable_invalidate() destroy the btt-info block in the
>>>> NVDIMM-N case.
>>>
>>> Do you have any update on this?  If we are going to use ndctl to address
>>> this issue, does it mean that we will have to use ndctl to manage BTT?
>>
>> This is my current proposal:
>>
>> https://github.com/pmem/ndctl/blob/pending/Documentation/ndctl-create-namespace.txt
>
> I don't really like "safe" as a mode choice.  The others are "memory" and "raw".
> Could the one using the BTT be "sector" or "atomic" or "btt" or something other
> than "safe"?  Using "safe" implies that the others aren't safe, but they are if
> you use them for their intended purpose and know what you're doing.

Of those alternatives I think "sector" mode is the most clear.
