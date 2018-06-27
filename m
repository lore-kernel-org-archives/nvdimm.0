Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4324621B02845
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 08:29:45 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] dev-dax: ratelimit unaligned vma warning
References: <x49po0cgt1r.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gEgib++-hi05Pd67z27dFkbZuq1p0y23EMCq8pGzke=Q@mail.gmail.com>
Date: Wed, 27 Jun 2018 11:29:44 -0400
In-Reply-To: <CAPcyv4gEgib++-hi05Pd67z27dFkbZuq1p0y23EMCq8pGzke=Q@mail.gmail.com>
 (Dan Williams's message of "Wed, 27 Jun 2018 08:18:25 -0700")
Message-ID: <x49lgb0gsd3.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Wed, Jun 27, 2018 at 8:14 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> This is easily triggered from userspace, so let's ratelimit the warning.
>>
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>> index de2f8297a210..16ea90615aac 100644
>> --- a/drivers/dax/device.c
>> +++ b/drivers/dax/device.c
>> @@ -196,7 +196,8 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
>>
>>         mask = dax_region->align - 1;
>>         if (vma->vm_start & mask || vma->vm_end & mask) {
>> -               dev_info(dev, "%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
>> +               dev_info_ratelimited(dev,
>> +                               "%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
>>                                 current->comm, func, vma->vm_start, vma->vm_end,
>>                                 mask);
>
> Sure, but any reason to not go ahead and convert all of them?

I assume you mean "all of the dev_info calls in this function."  If so,
then no, there's no reason--I'll submit an updated patch.  Are there any
other paths you know of with this sort of issue?  I didn't see any on a
quick glance.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
