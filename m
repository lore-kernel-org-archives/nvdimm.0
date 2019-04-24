Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190423203843.2898-1-pasha.tatashin@soleen.com> <7f7499bd-8d48-945b-6d69-60685a02c8da@arm.com>
In-Reply-To: <7f7499bd-8d48-945b-6d69-60685a02c8da@arm.com>
From: Pavel Tatashin <patatash@linux.microsoft.com>
Date: Wed, 24 Apr 2019 15:48:44 -0400
Message-ID: <CA+CK2bCD11x64pJj5gSnsu5jsUqJyU6o+=J4K8oYAsHqz9ULqQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: configurable sparsemem section size
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, catalin.marinas@arm.com, Will Deacon <will.deacon@arm.com>, rppt@linux.vnet.ibm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, andrew.murray@arm.com, james.morse@arm.com, Marc Zyngier <marc.zyngier@arm.com>, sboyd@kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 24, 2019 at 5:07 AM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> On 04/24/2019 02:08 AM, Pavel Tatashin wrote:
> > sparsemem section size determines the maximum size and alignment that
> > is allowed to offline/online memory block. The bigger the size the less
> > the clutter in /sys/devices/system/memory/*. On the other hand, however,
> > there is less flexability in what granules of memory can be added and
> > removed.
>
> Is there any scenario where less than a 1GB needs to be added on arm64 ?

Yes, DAX hotplug loses 1G of memory without allowing smaller sections.
Machines on which we are going to be using this functionality have 8G
of System RAM, therefore losing 1G is a big problem.

For details about using scenario see this cover letter:
https://lore.kernel.org/lkml/20190421014429.31206-1-pasha.tatashin@soleen.com/

>
> >
> > Recently, it was enabled in Linux to hotadd persistent memory that
> > can be either real NV device, or reserved from regular System RAM
> > and has identity of devdax.
>
> devdax (even ZONE_DEVICE) support has not been enabled on arm64 yet.

Correct, I use your patches to enable ZONE_DEVICE, and  thus devdax on ARM64:
https://lore.kernel.org/lkml/1554265806-11501-1-git-send-email-anshuman.khandual@arm.com/

>
> >
> > The problem is that because ARM64's section size is 1G, and devdax must
> > have 2M label section, the first 1G is always missed when device is
> > attached, because it is not 1G aligned.
>
> devdax has to be 2M aligned ? Does Linux enforce that right now ?

Unfortunately, there is no way around this. Part of the memory can be
reserved as persistent memory via device tree.
        memory@40000000 {
                device_type = "memory";
                reg = < 0x00000000 0x40000000
                        0x00000002 0x00000000 >;
        };

        pmem@1c0000000 {
                compatible = "pmem-region";
                reg = <0x00000001 0xc0000000
                       0x00000000 0x80000000>;
                volatile;
                numa-node-id = <0>;
        };

So, while pmem is section aligned, as it should be, the dax device is
going to be pmem start address + label size, which is 2M. The actual
DAX device starts at:
0x1c0000000 + 2M.

Because section size is 1G, the hotplug will able to add only memory
starting from
0x1c0000000 + 1G

> 27 and 28 do not even compile for ARM64_64_PAGES because of MAX_ORDER and
> SECTION_SIZE mismatch.

Can you please elaborate what configs are you using? I have no
problems compiling with 27 and 28 bit.

Thank you,
Pasha
