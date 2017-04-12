Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x235.google.com (mail-qt0-x235.google.com
 [IPv6:2607:f8b0:400d:c0d::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD95220083167
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 02:14:03 -0700 (PDT)
Received: by mail-qt0-x235.google.com with SMTP id v3so17189904qtd.3
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 02:14:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hKnP_pddKP8Ve6R0n6sXihPeLCw5seq06iHJ=Hc3yaQA@mail.gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
 <CAPcyv4hKnP_pddKP8Ve6R0n6sXihPeLCw5seq06iHJ=Hc3yaQA@mail.gmail.com>
From: "Oliver O'Halloran" <oohall@gmail.com>
Date: Wed, 12 Apr 2017 19:14:02 +1000
Message-ID: <CAOSf1CEtUHeQspR9=sRKJQxxsH==_82L8AzUy10aUj=d=e0_kA@mail.gmail.com>
Subject: Re: ZONE_DEVICE and pmem API support for powerpc
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
Cc: Balbir Singh <bsingharora@gmail.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Reza Arbab <arbab@linux.vnet.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 12, 2017 at 4:22 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Apr 11, 2017 at 10:42 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
>> Hi all,
>>
>> This series adds support for ZONE_DEVICE and the pmem api on powerpc. Namely,
>> support for altmaps and the various bits and pieces required for DAX PMD faults.
>> The first two patches touch generic mm/ code, but otherwise this is fairly well
>> contained in arch/powerpc.
>>
>> If the nvdimm folks could sanity check this series I'd appreciate it.
>
> Quick feedback: I'm in the process of cleaning up and resubmitting my
> patch set to push the pmem api down into the driver directly.
>
>     https://lwn.net/Articles/713064/

That's been on my radar for a while and I was hoping it would be in
4.12. Moving operations into the driver makes a lot of sense from a
design perspective and it should make supporting some of the
contutto's eccentricities a bit easier.

> I'm also reworking memory hotplug to allow sub-section allocations
> which has collided with Michal Hocko's hotplug reworks. It will be
> good to have some more eyes on that work to understand the cross-arch
> implications.
>
>     https://lkml.org/lkml/2017/3/19/146

I'd been putting off looking at this since I figured it would clash
with the hotplug rework and HMM, but I'll see if I can get it working
on ppc.

>> Series is based on next-20170411, but it should apply elsewhere with minor
>> fixups to arch_{add|remove}_memory due to conflicts with HMM.  For those
>> interested in testing this, there is a driver and matching firmware that carves
>> out some system memory for use as an emulated Con Tutto memory card.
>>
>> Driver: https://github.com/oohal/linux/tree/contutto-next
>> Firmware: https://github.com/oohal/skiboot/tree/fake-contutto
>>
>> Edit core/init.c:686 to control the amount of memory borrowed for the emulated
>> device.  I'm keeping the driver out of tree for a until 4.13 since I plan on
>> reworking the firmware interface anyway and There's at least one showstopper
>> bug.
>
> Is this memory card I/O-cache coherent? I.e. existing dma mapping api
> can hand out mappings to it? Just trying to figure out if this the
> existing pmem-definition of ZONE_DEVICE or a new one.

As far as the rest of the system is concerned Con Tutto memory is
identical to normal system memory. All accesses to the card's memory
is mediated by a memory controller which participates in the memory
coherency protocol. That said, the link between the card and the
system is non-coherent so logic on the FPGA can access memory
incoherently. I'm primarily interested in using the card as a memory
platform so I haven't spent a lot of time thinking about the latter
use case, but a different concept of device memory might be required
there.

Oliver
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
