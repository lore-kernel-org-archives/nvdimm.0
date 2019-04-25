Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id D3300211CD9CD
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 20:06:46 -0700 (PDT)
Subject: Re: [PATCH] arm64: configurable sparsemem section size
References: <20190423203843.2898-1-pasha.tatashin@soleen.com>
 <7f7499bd-8d48-945b-6d69-60685a02c8da@arm.com>
 <CA+CK2bCD11x64pJj5gSnsu5jsUqJyU6o+=J4K8oYAsHqz9ULqQ@mail.gmail.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <cc2f6523-9ebc-54aa-34a1-32a661317342@arm.com>
Date: Thu, 25 Apr 2019 08:36:38 +0530
MIME-Version: 1.0
In-Reply-To: <CA+CK2bCD11x64pJj5gSnsu5jsUqJyU6o+=J4K8oYAsHqz9ULqQ@mail.gmail.com>
Content-Language: en-US
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
To: Pavel Tatashin <patatash@linux.microsoft.com>
Cc: Michal Hocko <mhocko@suse.com>, Takashi Iwai <tiwai@suse.de>, catalin.marinas@arm.com, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, linux-mm <linux-mm@kvack.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Sasha Levin <sashal@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, James Morris <jmorris@namei.org>, "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, Bjorn Helgaas <bhelgaas@google.com>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, sboyd@kernel.org, LKML <linux-kernel@vger.kernel.org>, james.morse@arm.com, andrew.murray@arm.com, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>



On 04/25/2019 01:18 AM, Pavel Tatashin wrote:
> On Wed, Apr 24, 2019 at 5:07 AM Anshuman Khandual
> <anshuman.khandual@arm.com> wrote:
>>
>> On 04/24/2019 02:08 AM, Pavel Tatashin wrote:
>>> sparsemem section size determines the maximum size and alignment that
>>> is allowed to offline/online memory block. The bigger the size the less
>>> the clutter in /sys/devices/system/memory/*. On the other hand, however,
>>> there is less flexability in what granules of memory can be added and
>>> removed.
>>
>> Is there any scenario where less than a 1GB needs to be added on arm64 ?
> 
> Yes, DAX hotplug loses 1G of memory without allowing smaller sections.
> Machines on which we are going to be using this functionality have 8G
> of System RAM, therefore losing 1G is a big problem.
> 
> For details about using scenario see this cover letter:
> https://lore.kernel.org/lkml/20190421014429.31206-1-pasha.tatashin@soleen.com/

Its loosing 1GB because devdax has 2M alignment ? IIRC from Dan's subsection memory
hot add series 2M comes from persistent memory HW controller's limitations. Does that
limitation applicable across all platforms including arm64 for all possible persistent
memory vendors. I mean is it universal ? IIUC subsection memory hot plug series is
still getting reviewed. Hence should not we wait for it to get merged before enabling
applicable platforms to accommodate these 2M limitations.

> 
>>
>>>
>>> Recently, it was enabled in Linux to hotadd persistent memory that
>>> can be either real NV device, or reserved from regular System RAM
>>> and has identity of devdax.
>>
>> devdax (even ZONE_DEVICE) support has not been enabled on arm64 yet.
> 
> Correct, I use your patches to enable ZONE_DEVICE, and  thus devdax on ARM64:
> https://lore.kernel.org/lkml/1554265806-11501-1-git-send-email-anshuman.khandual@arm.com/
> 
>>
>>>
>>> The problem is that because ARM64's section size is 1G, and devdax must
>>> have 2M label section, the first 1G is always missed when device is
>>> attached, because it is not 1G aligned.
>>
>> devdax has to be 2M aligned ? Does Linux enforce that right now ?
> 
> Unfortunately, there is no way around this. Part of the memory can be
> reserved as persistent memory via device tree.
>         memory@40000000 {
>                 device_type = "memory";
>                 reg = < 0x00000000 0x40000000
>                         0x00000002 0x00000000 >;
>         };
> 
>         pmem@1c0000000 {
>                 compatible = "pmem-region";
>                 reg = <0x00000001 0xc0000000
>                        0x00000000 0x80000000>;
>                 volatile;
>                 numa-node-id = <0>;
>         };
> 
> So, while pmem is section aligned, as it should be, the dax device is
> going to be pmem start address + label size, which is 2M. The actual

Forgive my ignorance here but why dax device label size is 2M aligned. Again is that
because of some persistent memory HW controller limitations ?

> DAX device starts at:
> 0x1c0000000 + 2M.
> 
> Because section size is 1G, the hotplug will able to add only memory
> starting from
> 0x1c0000000 + 1G

Got it but as mentioned before we will have to make sure that 2M alignment requirement
is universal else we will be adjusting this multiple times.

> 
>> 27 and 28 do not even compile for ARM64_64_PAGES because of MAX_ORDER and
>> SECTION_SIZE mismatch.

Even with 27 bits its 128 MB section size. How does it solve the problem with 2M ?
The patch just wanted to reduce the memory wastage ?

> 
> Can you please elaborate what configs are you using? I have no
> problems compiling with 27 and 28 bit.

After applying your patch [1] on current mainline kernel [2].

$make defconfig

CONFIG_ARM64_64K_PAGES=y
CONFIG_ARM64_VA_BITS_48=y
CONFIG_ARM64_VA_BITS=48
CONFIG_ARM64_PA_BITS_48=y
CONFIG_ARM64_PA_BITS=48
CONFIG_ARM64_SECTION_SIZE_BITS=27

[1] https://patchwork.kernel.org/patch/10913737/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

It fails with

  CC      arch/arm64/kernel/asm-offsets.s
In file included from ./include/linux/gfp.h:6,
                 from ./include/linux/slab.h:15,
                 from ./include/linux/resource_ext.h:19,
                 from ./include/linux/acpi.h:26,
                 from ./include/acpi/apei.h:9,
                 from ./include/acpi/ghes.h:5,
                 from ./include/linux/arm_sdei.h:14,
                 from arch/arm64/kernel/asm-offsets.c:21:
./include/linux/mmzone.h:1095:2: error: #error Allocator MAX_ORDER exceeds SECTION_SIZE
 #error Allocator MAX_ORDER exceeds SECTION_SIZE
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
