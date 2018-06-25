Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69598203369DB
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 08:52:39 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id c6-v6so12973888oiy.0
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 08:52:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180625154346.3A35.E1E9C6FF@jp.fujitsu.com>
References: <20180618134944.587E.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4grkb8Gxn_7MjeyKvFgYsk58Nf9us82XgPfASvpt-QsdQ@mail.gmail.com>
 <20180625154346.3A35.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Jun 2018 08:52:37 -0700
Message-ID: <CAPcyv4izsmGAA3rba0afAoDQBh9EWkOojZHBz4OfHxk-5rgHbQ@mail.gmail.com>
Subject: Re: Bug on ndctl ? (failed to create namespace: No such device or
 address)
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 24, 2018 at 11:43 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> >
>> > This warning seems to be the following line.
>> > ---
>> > static int grow_dpa_allocation(struct nd_region *nd_region,
>> >                 struct nd_label_id *label_id, resource_size_t n)
>> > {
>> >         struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
>> >         bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
>> >         int i;
>> >   :
>> >   :
>> >                 }
>> >
>> >                 dev_WARN_ONCE(&nd_region->dev, rem,                                <----!!!
>> >                                 "allocation underrun: %#llx of %#llx bytes\n",     <----!!!
>> >                                 (unsigned long long) n - rem,                      <----!!!
>> >                                 (unsigned long long) n);                           <----!!!
>> >
>>
>> Yes, this appears to be a kernel bug from when
>> multiple-namespaces-per-region support was added. The accounting of
>> free space that ndctl relies on assumes that all free space is
>> contiguous. This assumption was correct in the original
>> implementation, but not since commit:
>>
>>     a1f3e4d6a0c3 libnvdimm, region: update nd_region_available_dpa()
>> for multi-pmem support
>>
>> The fix has 3 parts:
>>
>> 1/ The kernel needs to fail attempts to allocate discontiguous free space
>>
>> 2/ The kernel needs a new sysfs attribute to export the maximum
>> contiguous free space range
>>
>> 3/ ndctl needs to be updated to pick the max contiguous size rather
>> than the max free space
>
>
> Agree.
>
> Unfortunately, I cound not use the real NVDIMM box which I found this bug now,
> because the box is very busy, and the environment will be available
> a few months later.
>
> If other person can make the above fixes, it will be faster than me.
>
> Anyone?

Yes, we're working on this.

>> Alternatively we could teach the kernel to support discontiguous pmem
>> namespaces, but we would need to check if the EFI namespace
>> specification allows for such a configuration.
>>
>
> I suppose this way is not good way probably.
>
>
> Though I searched EFI specification 2.7a,
> it says just the followings about contiguous namespace,
> and I couldn't find any other description.
>
>  ---
>  6.1 Block Translation Table (BTT) Background
>  A namespace defines a contiguously-addressed range of Non-Volatile Memory
>  conceptually similar to a SCSI Logical Unit (LUN) or a NVM Express
>  namespace.
>  ---
>
> I also searched "NVDIMM Namespace Specification"
> https://pmem.io/documents/NVDIMM_Namespace_Spec.pdf
>
> It say the followings
>  ---
>  2.6 I/O on Namespaces
>  A Persistent Memory namespace, by definition, is a contiguous range
>  of System Physical Address space."
>  ---
>
> So, I could not think that speficications allows discontigous
> pmem namespace.

Yes, that matches my interpretation as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
