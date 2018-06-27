Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FBC9211F8869
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 08:33:35 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id w22-v6so2662906otk.5
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 08:33:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49lgb0gsd3.fsf@segfault.boston.devel.redhat.com>
References: <x49po0cgt1r.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gEgib++-hi05Pd67z27dFkbZuq1p0y23EMCq8pGzke=Q@mail.gmail.com>
 <x49lgb0gsd3.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Jun 2018 08:33:34 -0700
Message-ID: <CAPcyv4hVN9hYZq3in9X_SOQx-HMTwU5Oat6pfPvzMynkj-=3PQ@mail.gmail.com>
Subject: Re: [patch] dev-dax: ratelimit unaligned vma warning
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 27, 2018 at 8:29 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> On Wed, Jun 27, 2018 at 8:14 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> This is easily triggered from userspace, so let's ratelimit the warning.
>>>
>>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>>>
>>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>>> index de2f8297a210..16ea90615aac 100644
>>> --- a/drivers/dax/device.c
>>> +++ b/drivers/dax/device.c
>>> @@ -196,7 +196,8 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
>>>
>>>         mask = dax_region->align - 1;
>>>         if (vma->vm_start & mask || vma->vm_end & mask) {
>>> -               dev_info(dev, "%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
>>> +               dev_info_ratelimited(dev,
>>> +                               "%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
>>>                                 current->comm, func, vma->vm_start, vma->vm_end,
>>>                                 mask);
>>
>> Sure, but any reason to not go ahead and convert all of them?
>
> I assume you mean "all of the dev_info calls in this function."

Right.

> If so,
> then no, there's no reason--I'll submit an updated patch.  Are there any
> other paths you know of with this sort of issue?  I didn't see any on a
> quick glance.

No, I think this is the only chatty place I can think of.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
