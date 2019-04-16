Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E93F6212108C4
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 05:57:27 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] libnvdimm/label: Check for a disabled nmem when deleting
 labels
References: <x49bm17qabg.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gh8xC+JBfmE15DzWp0vKPcQagf4AmWgmUqM9Hb_a_+Yw@mail.gmail.com>
Date: Tue, 16 Apr 2019 08:57:25 -0400
In-Reply-To: <CAPcyv4gh8xC+JBfmE15DzWp0vKPcQagf4AmWgmUqM9Hb_a_+Yw@mail.gmail.com>
 (Dan Williams's message of "Mon, 15 Apr 2019 15:04:06 -0700")
Message-ID: <x49ftqi6rbe.fsf@segfault.boston.devel.redhat.com>
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

> On Mon, Apr 15, 2019 at 1:32 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Hi,
>>
>> We ran into a situation where one dimm's label area was corrupt (it had
>> multiple entries for the same DPA), and so that nmem was disabled.  The
>> region as a whole was enabled, though.  In this case, there was a single
>> namespace that showed up as disabled.  Trying to reconfigure that
>> namespace resulted in the following panic:
>
> I'm concerned that there is a seed device for userspace to get its
> hopes up thinking it can do anything with the region.

That looked to be by design, to me.  I thought we kept the region active
in case you wanted to create a dimm local (blk) namespace.

>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
>> [  108.386384] #PF error: [normal kernel read fault]
>> [  108.391090] PGD 11c3eae5067 P4D 11c3eae5067 PUD 11c262c9067 PMD 0
>> [  108.397267] Oops: 0000 [#1] SMP NOPTI
>> [  108.400936] CPU: 39 PID: 3838 Comm: ndctl Not tainted 5.1.0-rc5 #1
>> [  108.407114] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS SE5C620.86B.0D.01.0286.011120190816 01/11/2019
>> [  108.417200] RIP: 0010:preamble_next+0xd/0x60 [libnvdimm]
>> ...
>>
>> The problem is that there is no driver data associated with the
>> nd_mapping in this case.  Check for that.
>>
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>> Reported-by: Zhang Yi <yizhan@redhat.com>
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index f3d753d3169c..da1f28d8c9e6 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -1217,7 +1217,7 @@ static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
>>                 return 0;
>>
>>         /* no index || no labels == nothing to delete */
>> -       if (!preamble_next(ndd, &nsindex, &free, &nslot))
>> +       if (!ndd || !preamble_next(ndd, &nsindex, &free, &nslot))
>>                 return 0;
>
> This looks ok, but I think I'd prefer to fix init_active_labels() to
> make sure it is failing region activation. I suspect something is
> wrong with this logic, but nothing is immediately coming to mind.

I also worry that, if there had been available space in the region,
new namespace creation could fail in the same way.

>                 /*
>                  * If the dimm is disabled then we may need to prevent
>                  * the region from being activated.
>                  */
>                 if (!ndd) {
>                         if (test_bit(NDD_LOCKED, &nvdimm->flags))
>                                 /* fail, label data may be unreadable */;
>                         else if (test_bit(NDD_ALIASING, &nvdimm->flags))
>                                 /* fail, labels needed to disambiguate dpa */;
>                         else
>                                 return 0;
>
>                         dev_err(&nd_region->dev, "%s: is %s, failing probe\n",
>                                         dev_name(&nd_mapping->nvdimm->dev),
>                                         test_bit(NDD_LOCKED, &nvdimm->flags)
>                                         ? "locked" : "disabled");
>                         return -ENXIO;
>                 }

I also looked at this logic.  The only thing wrong here, I think, is
that you don't need to disable the region for a locked dimm (unless all
dimms are locked).

>
> I'll try to reproduce...

OK.  If you can create custom labels, I'd say that would be the easiest
way to reproduce this.

Thanks!
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
