Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FE652249273B
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 09:32:52 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Fri, 2 Mar 2018 17:38:58 +0000
Message-ID: <1520015040.2693.38.camel@hpe.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
 <1519936477.4592.23.camel@au1.ibm.com>
 <1519936815.4592.25.camel@au1.ibm.com> <20180301205315.GJ19007@ziepe.ca>
 <1519942012.4592.31.camel@au1.ibm.com>
 <CA+55aFy-oAiFJ3WDx4giR1enj65y-YJnZZhY6geFw0ygFyKXfQ@mail.gmail.com>
 <1519943658.4592.34.camel@kernel.crashing.org>
 <1520010446.2693.19.camel@hpe.com>
 <CA+55aFztf2D4NwEkRxnJkD6kK62CWKxmERbALMGoMgFEGLEJZA@mail.gmail.com>
In-Reply-To: <CA+55aFztf2D4NwEkRxnJkD6kK62CWKxmERbALMGoMgFEGLEJZA@mail.gmail.com>
Content-Language: en-US
Content-ID: <DF9DA41A243442459170B104F083FDB9@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "keith.busch@intel.com" <keith.busch@intel.com>, "oliveroh@au1.ibm.com" <oliveroh@au1.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jglisse@redhat.com" <jglisse@redhat.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "bhelgaas@google.com" <bhelgaas@google.com>, "maxg@mellanox.com" <maxg@mellanox.com>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-03-02 at 08:57 -0800, Linus Torvalds wrote:
> On Fri, Mar 2, 2018 at 8:22 AM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> > 
> > FWIW, this thing is called MTRRs on x86, which are initialized by BIOS.
> 
> No.
> 
> Or rather, that's simply just another (small) part of it all - and an
> architected and documented one at that.
> 
> Like the page table caching entries, the memory type range registers
> are really just "secondary information". They don't actually select
> between PCIe and RAM, they just affect the behavior on top of that.
> 
> The really nitty-gritty stuff is not architected, and generally not
> documented outside (possibly) the BIOS writer's guide that is not made
> public.
> 
> Those magical registers contain details like how the DRAM is
> interleaved (if it is), what the timings are, where which memory
> controller handles which memory range, and what are goes to PCIe etc.
> 
> Basically all the actual *steering* information is very much hidden
> away from the kernel (and often from the BIOS too). The parts we see
> at a higher level are just tuning and tweaks.
> 
> Note: the details differ _enormously_ between different chips. The
> setup can be very different, with things like Knights Landing having
> the external cache that can also act as local memory that isn't a
> cache but maps at a different physical address instead etc. That's the
> kind of steering I'm talking about - at a low level how physical
> addresses get mapped to different cache partitions, memory
> controllers, or to the IO system etc.

Right, MRC code is not documented publicly, and it is very much CPU
dependent.  It programs address decoders and maps DRAMs to physical
address as you described.  MTRRs have nothing to do with this memory
controller setting.  That said, MTRRs specify CPU's memory access type,
such as UC and WB.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
