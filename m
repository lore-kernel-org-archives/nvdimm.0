Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
 (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D173422352283
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 14:28:48 -0800 (PST)
Message-ID: <1519943658.4592.34.camel@kernel.crashing.org>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 02 Mar 2018 09:34:18 +1100
In-Reply-To: <CA+55aFy-oAiFJ3WDx4giR1enj65y-YJnZZhY6geFw0ygFyKXfQ@mail.gmail.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
 <1519936477.4592.23.camel@au1.ibm.com>
 <1519936815.4592.25.camel@au1.ibm.com> <20180301205315.GJ19007@ziepe.ca>
 <1519942012.4592.31.camel@au1.ibm.com>
 <CA+55aFy-oAiFJ3WDx4giR1enj65y-YJnZZhY6geFw0ygFyKXfQ@mail.gmail.com>
Mime-Version: 1.0
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Oliver OHalloran <oliveroh@au1.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, linux-block <linux-block@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-03-01 at 14:31 -0800, Linus Torvalds wrote:
> On Thu, Mar 1, 2018 at 2:06 PM, Benjamin Herrenschmidt <benh@au1.ibm.com> wrote:
> > 
> > Could be that x86 has the smarts to do the right thing, still trying to
> > untangle the code :-)
> 
> Afaik, x86 will not cache PCI unless the system is misconfigured, and
> even then it's more likely to just raise a machine check exception
> than cache things.
> 
> The last-level cache is going to do fills and spills directly to the
> memory controller, not to the PCIe side of things.
> 
> (I guess you *can* do things differently, and I wouldn't be surprised
> if some people inside Intel did try to do things differently with
> trying nvram over PCIe, but in general I think the above is true)
> 
> You won't find it in the kernel code either. It's in hardware with
> firmware configuration of what addresses are mapped to the memory
> controllers (and _how_ they are mapped) and which are not.

Ah thanks ! Thanks explains. We can fix that on ppc64 in our linear
mapping code by checking the address vs. memblocks to chose the right
page table attributes.

So the main problem on our side is to figure out the problem of too big
PFNs. I need to look at this with Aneesh, we might be able to make
things fit with a bit of wrangling.

> You _might_ find it in the BIOS, assuming you understood the tables
> and had the BIOS writer's guide to unravel the magic registers.
> 
> But you might not even find it there. Some of the memory unit timing
> programming is done very early, and by code that Intel doesn't even
> release to the BIOS writers except as a magic encrypted blob, afaik.
> Some of the magic might even be in microcode.
> 
> The page table settings for cacheability are more like a hint, and
> only _part_ of the whole picture. The memory type range registers are
> another part. And magic low-level uarch, northbridge and memory unit
> specific magic is yet another part.
> 
> So you can disable caching for memory, but I'm pretty sure you can't
> enable caching for PCIe at least in the common case. At best you can
> affect how the store buffer works for PCIe.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
