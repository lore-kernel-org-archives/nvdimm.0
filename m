Return-Path: <owner-linux-mm@kvack.org>
References: <20190613094326.24093-1-hch@lst.de>
 <CAPcyv4jBdwYaiVwkhy6kP78OBAs+vJme1UTm47dX4Eq_5=JgSg@mail.gmail.com>
 <283e87e8-20b6-0505-a19b-5d18e057f008@deltatee.com>
 <CAPcyv4hx=ng3SxzAWd8s_8VtAfoiiWhiA5kodi9KPc=jGmnejg@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d0da4c86-ef52-b981-06af-b37e3e0515ee@deltatee.com>
Date: Thu, 13 Jun 2019 14:24:20 -0600
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hx=ng3SxzAWd8s_8VtAfoiiWhiA5kodi9KPc=jGmnejg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: dev_pagemap related cleanups
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, nouveau@lists.freedesktop.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>



On 2019-06-13 2:21 p.m., Dan Williams wrote:
> On Thu, Jun 13, 2019 at 1:18 PM Logan Gunthorpe <logang@deltatee.com> wrote:
>>
>>
>>
>> On 2019-06-13 12:27 p.m., Dan Williams wrote:
>>> On Thu, Jun 13, 2019 at 2:43 AM Christoph Hellwig <hch@lst.de> wrote:
>>>>
>>>> Hi Dan, Jérôme and Jason,
>>>>
>>>> below is a series that cleans up the dev_pagemap interface so that
>>>> it is more easily usable, which removes the need to wrap it in hmm
>>>> and thus allowing to kill a lot of code
>>>>
>>>> Diffstat:
>>>>
>>>>  22 files changed, 245 insertions(+), 802 deletions(-)
>>>
>>> Hooray!
>>>
>>>> Git tree:
>>>>
>>>>     git://git.infradead.org/users/hch/misc.git hmm-devmem-cleanup
>>>
>>> I just realized this collides with the dev_pagemap release rework in
>>> Andrew's tree (commit ids below are from next.git and are not stable)
>>>
>>> 4422ee8476f0 mm/devm_memremap_pages: fix final page put race
>>> 771f0714d0dc PCI/P2PDMA: track pgmap references per resource, not globally
>>> af37085de906 lib/genalloc: introduce chunk owners
>>> e0047ff8aa77 PCI/P2PDMA: fix the gen_pool_add_virt() failure path
>>> 0315d47d6ae9 mm/devm_memremap_pages: introduce devm_memunmap_pages
>>> 216475c7eaa8 drivers/base/devres: introduce devm_release_action()
>>>
>>> CONFLICT (content): Merge conflict in tools/testing/nvdimm/test/iomap.c
>>> CONFLICT (content): Merge conflict in mm/hmm.c
>>> CONFLICT (content): Merge conflict in kernel/memremap.c
>>> CONFLICT (content): Merge conflict in include/linux/memremap.h
>>> CONFLICT (content): Merge conflict in drivers/pci/p2pdma.c
>>> CONFLICT (content): Merge conflict in drivers/nvdimm/pmem.c
>>> CONFLICT (content): Merge conflict in drivers/dax/device.c
>>> CONFLICT (content): Merge conflict in drivers/dax/dax-private.h
>>>
>>> Perhaps we should pull those out and resend them through hmm.git?
>>
>> Hmm, I've been waiting for those patches to get in for a little while now ;(
> 
> Unless Andrew was going to submit as v5.2-rc fixes I think I should
> rebase / submit them on current hmm.git and then throw these cleanups
> from Christoph on top?

Whatever you feel is best. I'm just hoping they get in sooner rather
than later. They do fix a bug after all. Let me know if you want me to
retest the P2PDMA stuff after the rebase.

Thanks,

Logan
