Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8FB921A07A80
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 13:24:28 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id u17so161147otj.1
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 13:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190423203843.2898-1-pasha.tatashin@soleen.com>
 <7f7499bd-8d48-945b-6d69-60685a02c8da@arm.com>
 <CA+CK2bCD11x64pJj5gSnsu5jsUqJyU6o+=J4K8oYAsHqz9ULqQ@mail.gmail.com>
 <CA+CK2bB5ahqLrekkTUSdzTE2BPSPbB9nk6nKs+LjTap2oF8X-w@mail.gmail.com>
In-Reply-To: <CA+CK2bB5ahqLrekkTUSdzTE2BPSPbB9nk6nKs+LjTap2oF8X-w@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Apr 2019 13:24:16 -0700
Message-ID: <CAPcyv4gdo5GcS8cbvLQr0Ez09z32VyrbVouW2GVV5UJf8R3HWw@mail.gmail.com>
Subject: Re: [PATCH] arm64: configurable sparsemem section size
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>, Takashi Iwai <tiwai@suse.de>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, linux-mm <linux-mm@kvack.org>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Sasha Levin <sashal@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, James Morris <jmorris@namei.org>, "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Anshuman Khandual <anshuman.khandual@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, Bjorn Helgaas <bhelgaas@google.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, sboyd@kernel.org, LKML <linux-kernel@vger.kernel.org>, james.morse@arm.com, andrew.murray@arm.com, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 24, 2019 at 12:54 PM Pavel Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> <resending> from original email
>
> On Wed, Apr 24, 2019 at 3:48 PM Pavel Tatashin
> <patatash@linux.microsoft.com> wrote:
> >
> > On Wed, Apr 24, 2019 at 5:07 AM Anshuman Khandual
> > <anshuman.khandual@arm.com> wrote:
> > >
> > > On 04/24/2019 02:08 AM, Pavel Tatashin wrote:
> > > > sparsemem section size determines the maximum size and alignment that
> > > > is allowed to offline/online memory block. The bigger the size the less
> > > > the clutter in /sys/devices/system/memory/*. On the other hand, however,
> > > > there is less flexability in what granules of memory can be added and
> > > > removed.
> > >
> > > Is there any scenario where less than a 1GB needs to be added on arm64 ?
> >
> > Yes, DAX hotplug loses 1G of memory without allowing smaller sections.
> > Machines on which we are going to be using this functionality have 8G
> > of System RAM, therefore losing 1G is a big problem.
> >
> > For details about using scenario see this cover letter:
> > https://lore.kernel.org/lkml/20190421014429.31206-1-pasha.tatashin@soleen.com/
> >
> > >
> > > >
> > > > Recently, it was enabled in Linux to hotadd persistent memory that
> > > > can be either real NV device, or reserved from regular System RAM
> > > > and has identity of devdax.
> > >
> > > devdax (even ZONE_DEVICE) support has not been enabled on arm64 yet.
> >
> > Correct, I use your patches to enable ZONE_DEVICE, and  thus devdax on ARM64:
> > https://lore.kernel.org/lkml/1554265806-11501-1-git-send-email-anshuman.khandual@arm.com/
> >
> > >
> > > >
> > > > The problem is that because ARM64's section size is 1G, and devdax must
> > > > have 2M label section, the first 1G is always missed when device is
> > > > attached, because it is not 1G aligned.
> > >
> > > devdax has to be 2M aligned ? Does Linux enforce that right now ?
> >
> > Unfortunately, there is no way around this. Part of the memory can be
> > reserved as persistent memory via device tree.
> >         memory@40000000 {
> >                 device_type = "memory";
> >                 reg = < 0x00000000 0x40000000
> >                         0x00000002 0x00000000 >;
> >         };
> >
> >         pmem@1c0000000 {
> >                 compatible = "pmem-region";
> >                 reg = <0x00000001 0xc0000000
> >                        0x00000000 0x80000000>;
> >                 volatile;
> >                 numa-node-id = <0>;
> >         };
> >
> > So, while pmem is section aligned, as it should be, the dax device is
> > going to be pmem start address + label size, which is 2M. The actual
> > DAX device starts at:
> > 0x1c0000000 + 2M.
> >
> > Because section size is 1G, the hotplug will able to add only memory
> > starting from
> > 0x1c0000000 + 1G

This is yet another example of where we need to break down the section
alignment requirement for arch_add_memory().

https://lore.kernel.org/lkml/155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
