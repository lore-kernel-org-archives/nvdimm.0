Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x243.google.com (mail-qt0-x243.google.com
 [IPv6:2607:f8b0:400d:c0d::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C54A21A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 21:21:54 -0700 (PDT)
Received: by mail-qt0-x243.google.com with SMTP id c45so6501064qtb.0
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 21:21:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1491961986.8380.13.camel@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-9-oohall@gmail.com>
 <1491961986.8380.13.camel@gmail.com>
From: "Oliver O'Halloran" <oohall@gmail.com>
Date: Thu, 13 Apr 2017 14:21:53 +1000
Message-ID: <CAOSf1CHr2uMC1f5fMkqVpS7-J1K20cHShjp7FcNawV2KL4D_Dw@mail.gmail.com>
Subject: Re: [PATCH 8/9] powerpc/mm: Wire up hpte_removebolted for powernv
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
To: Balbir Singh <bsingharora@gmail.com>
Cc: Rashmica Gupta <rashmica.g@gmail.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Anton Blanchard <anton@samba.org>, Reza Arbab <arbab@linux.vnet.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 11:53 AM, Balbir Singh <bsingharora@gmail.com> wrote:
> On Wed, 2017-04-12 at 03:42 +1000, Oliver O'Halloran wrote:
>> From: Rashmica Gupta <rashmica.g@gmail.com>
>>
>> Adds support for removing bolted (i.e kernel linear mapping) mappings on
>> powernv. This is needed to support memory hot unplug operations which
>> are required for the teardown of DAX/PMEM devices.
>>
>> Cc: Rashmica Gupta <rashmica.g@gmail.com>
>> Cc: Anton Blanchard <anton@samba.org>
>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>> ---
>> Could the original author of this add their S-o-b? I pulled it out of
>> Rashmica's memtrace patch, but I remember someone saying Anton wrote
>> it originally.
>> ---
>>  arch/powerpc/mm/hash_native_64.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
>> index 65bb8f33b399..9ba91d4905a4 100644
>> --- a/arch/powerpc/mm/hash_native_64.c
>> +++ b/arch/powerpc/mm/hash_native_64.c
>> @@ -407,6 +407,36 @@ static void native_hpte_updateboltedpp(unsigned long newpp, unsigned long ea,
>>       tlbie(vpn, psize, psize, ssize, 0);
>>  }
>>
>> +/*
>> + * Remove a bolted kernel entry. Memory hotplug uses this.
>> + *
>> + * No need to lock here because we should be the only user.
>
> As long as this is after the necessary isolation and is called from
> arch_remove_memory(), I think we should be fine
>
>> + */
>> +static int native_hpte_removebolted(unsigned long ea, int psize, int ssize)
>> +{
>> +     unsigned long vpn;
>> +     unsigned long vsid;
>> +     long slot;
>> +     struct hash_pte *hptep;
>> +
>> +     vsid = get_kernel_vsid(ea, ssize);
>> +     vpn = hpt_vpn(ea, vsid, ssize);
>> +
>> +     slot = native_hpte_find(vpn, psize, ssize);
>> +     if (slot == -1)
>> +             return -ENOENT;
>
> If slot == -1, it means someone else removed the HPTE entry? Are we racing?
> I suspect we should never hit this situation during hotunplug, specifically
> since this is bolted.

Or the slot was never populated in the first place. I'd rather keep
the current behaviour since it aligns with the behaviour of
pSeries_lpar_hpte_removebolted and we might hit these situations in
the future if the sub-section hotplug patches are merged (big if...).

>
>> +
>> +     hptep = htab_address + slot;
>> +
>> +     /* Invalidate the hpte */
>> +     hptep->v = 0;
>
> Under DEBUG or otherwise, I would add more checks like
>
> 1. was hpte_v & HPTE_V_VALID and BOLTED set? If not, we've already invalidated
> that hpte and we can skip the tlbie. Since this was bolted you might be right
> that it is always valid and bolted

A VM_WARN_ON() if the bolted bit is clear might be appropriate. We
don't need to check the valid bit since hpte_native_find() will fail
if it's cleared.

>
>> +
>> +     /* Invalidate the TLB */
>> +     tlbie(vpn, psize, psize, ssize, 0);
>
> The API also does not clear linear_map_hash_slots[] under DEBUG_PAGEALLOC

I'm not sure what API you're referring to here. The tracking for
linear_map_hash_slots[] is agnostic of mmu_hash_ops so we shouldn't be
touching it here. It also looks like DEBUG_PAGEALLOC is a bit broken
with hotplugged memory anyway so I think that's a fix for a different
patch.

>
>> +     return 0;
>> +}
>> +
>> +
>
> Balbir Singh.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
