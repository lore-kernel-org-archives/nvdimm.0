Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 670AF1A1E4F
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 20:51:17 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id t73so16701334oie.1
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 20:51:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Oct 2016 20:51:15 -0700
Message-ID: <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
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
To: Stephen Bates <sbates@raithlin.com>
Cc: jgunthorpe@obsidianresearch.com, sbates@raithin.com, "Raj, Ashok  <ashok.raj@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, jim.macdonald@everspin.com, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, haggaie@mellanox.com
List-ID: <linux-nvdimm@lists.01.org>

[ adding Ashok and David for potential iommu comments ]

On Tue, Oct 18, 2016 at 2:42 PM, Stephen Bates <sbates@raithlin.com> wrote:
> This patch follows from an RFC we did earlier this year [1]. This
> patchset applies cleanly to v4.9-rc1.
>
> Updates since RFC
> -----------------
>   Rebased.
>   Included the iopmem driver in the submission.
>
> History
> -------
>
> There have been several attempts to upstream patchsets that enable
> DMAs between PCIe peers. These include Peer-Direct [2] and DMA-Buf
> style patches [3]. None have been successful to date. Haggai Eran
> gives a nice overview of the prior art in this space in his cover
> letter [3].
>
> Motivation and Use Cases
> ------------------------
>
> PCIe IO devices are getting faster. It is not uncommon now to find PCIe
> network and storage devices that can generate and consume several GB/s.
> Almost always these devices have either a high performance DMA engine, a
> number of exposed PCIe BARs or both.
>
> Until this patch, any high-performance transfer of information between
> two PICe devices has required the use of a staging buffer in system
> memory. With this patch the bandwidth to system memory is not compromised
> when high-throughput transfers occurs between PCIe devices. This means
> that more system memory bandwidth is available to the CPU cores for data
> processing and manipulation. In addition, in systems where the two PCIe
> devices reside behind a PCIe switch the datapath avoids the CPU
> entirely.

I agree with the motivation and the need for a solution, but I have
some questions about this implementation.

>
> Consumers
> ---------
>
> We provide a PCIe device driver in an accompanying patch that can be
> used to map any PCIe BAR into a DAX capable block device. For
> non-persistent BARs this simply serves as an alternative to using
> system memory bounce buffers. For persistent BARs this can serve as an
> additional storage device in the system.

Why block devices?  I wonder if iopmem was initially designed back
when we were considering enabling DAX for raw block devices.  However,
that support has since been ripped out / abandoned.  You currently
need a filesystem on top of a block-device to get DAX operation.
Putting xfs or ext4 on top of PCI-E memory mapped range seems awkward
if all you want is a way to map the bar for another PCI-E device in
the topology.

If you're only using the block-device as a entry-point to create
dax-mappings then a device-dax (drivers/dax/) character-device might
be a better fit.

>
> Testing and Performance
> -----------------------
>
> We have done a moderate about of testing of this patch on a QEMU
> environment and on real hardware. On real hardware we have observed
> peer-to-peer writes of up to 4GB/s and reads of up to 1.2 GB/s. In
> both cases these numbers are limitations of our consumer hardware. In
> addition, we have observed that the CPU DRAM bandwidth is not impacted
> when using IOPMEM which is not the case when a traditional path
> through system memory is taken.
>
> For more information on the testing and performance results see the
> GitHub site [4].
>
> Known Issues
> ------------
>
> 1. Address Translation. Suggestions have been made that in certain
> architectures and topologies the dma_addr_t passed to the DMA master
> in a peer-2-peer transfer will not correctly route to the IO memory
> intended. However in our testing to date we have not seen this to be
> an issue, even in systems with IOMMUs and PCIe switches. It is our
> understanding that an IOMMU only maps system memory and would not
> interfere with device memory regions. (It certainly has no opportunity
> to do so if the transfer gets routed through a switch).
>

There may still be platforms where peer-to-peer cycles are routed up
through the root bridge and then back down to target device, but we
can address that when / if it happens.  I wonder if we could (ab)use a
software-defined 'pasid' as the requester id for a peer-to-peer
mapping that needs address translation.

> 2. Memory Segment Spacing. This patch has the same limitations that
> ZONE_DEVICE does in that memory regions must be spaces at least
> SECTION_SIZE bytes part. On x86 this is 128MB and there are cases where
> BARs can be placed closer together than this. Thus ZONE_DEVICE would not
> be usable on neighboring BARs. For our purposes, this is not an issue as
> we'd only be looking at enabling a single BAR in a given PCIe device.
> More exotic use cases may have problems with this.

I'm working on patches for 4.10 to allow mixing multiple
devm_memremap_pages() allocations within the same physical section.
Hopefully this won't be a problem going forward.

> 3. Coherency Issues. When IOMEM is written from both the CPU and a PCIe
> peer there is potential for coherency issues and for writes to occur out
> of order. This is something that users of this feature need to be
> cognizant of. Though really, this isn't much different than the
> existing situation with things like RDMA: if userspace sets up an MR
> for remote use, they need to be careful about using that memory region
> themselves.

We might be able to mitigate this by indicating that the mapping is
busy for device-to-device transfers.  But you're right we could wait
to see how much of a problem this is in practice.

>
> 4. Architecture. Currently this patch is applicable only to x86_64
> architectures. The same is true for much of the code pertaining to
> PMEM and ZONE_DEVICE. It is hoped that the work will be extended to other
> ARCH over time.
>
> References
> ----------
> [1] https://patchwork.kernel.org/patch/8583221/
> [2] http://comments.gmane.org/gmane.linux.drivers.rdma/21849
> [3] http://www.spinics.net/lists/linux-rdma/msg38748.html
> [4] https://github.com/sbates130272/zone-device
>
> Logan Gunthorpe (1):
>   memremap.c : Add support for ZONE_DEVICE IO memory with struct pages.

I haven't yet grokked the motivation for this, but I'll go comment on
that separately.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
