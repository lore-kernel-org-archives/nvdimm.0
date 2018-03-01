Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x243.google.com (mail-it0-x243.google.com
 [IPv6:2607:f8b0:4001:c0b::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 33FDD20955F32
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 14:25:16 -0800 (PST)
Received: by mail-it0-x243.google.com with SMTP id w19so382309ite.0
 for <linux-nvdimm@lists.01.org>; Thu, 01 Mar 2018 14:31:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519942012.4592.31.camel@au1.ibm.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
 <1519936477.4592.23.camel@au1.ibm.com> <1519936815.4592.25.camel@au1.ibm.com>
 <20180301205315.GJ19007@ziepe.ca> <1519942012.4592.31.camel@au1.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Mar 2018 14:31:23 -0800
Message-ID: <CA+55aFy-oAiFJ3WDx4giR1enj65y-YJnZZhY6geFw0ygFyKXfQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
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
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Oliver OHalloran <oliveroh@au1.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, linux-block <linux-block@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 1, 2018 at 2:06 PM, Benjamin Herrenschmidt <benh@au1.ibm.com> wrote:
>
> Could be that x86 has the smarts to do the right thing, still trying to
> untangle the code :-)

Afaik, x86 will not cache PCI unless the system is misconfigured, and
even then it's more likely to just raise a machine check exception
than cache things.

The last-level cache is going to do fills and spills directly to the
memory controller, not to the PCIe side of things.

(I guess you *can* do things differently, and I wouldn't be surprised
if some people inside Intel did try to do things differently with
trying nvram over PCIe, but in general I think the above is true)

You won't find it in the kernel code either. It's in hardware with
firmware configuration of what addresses are mapped to the memory
controllers (and _how_ they are mapped) and which are not.

You _might_ find it in the BIOS, assuming you understood the tables
and had the BIOS writer's guide to unravel the magic registers.

But you might not even find it there. Some of the memory unit timing
programming is done very early, and by code that Intel doesn't even
release to the BIOS writers except as a magic encrypted blob, afaik.
Some of the magic might even be in microcode.

The page table settings for cacheability are more like a hint, and
only _part_ of the whole picture. The memory type range registers are
another part. And magic low-level uarch, northbridge and memory unit
specific magic is yet another part.

So you can disable caching for memory, but I'm pretty sure you can't
enable caching for PCIe at least in the common case. At best you can
affect how the store buffer works for PCIe.

              Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
