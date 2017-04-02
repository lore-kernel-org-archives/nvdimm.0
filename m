Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 50A4021A18AAB
 for <linux-nvdimm@lists.01.org>; Sat,  1 Apr 2017 19:26:06 -0700 (PDT)
Subject: Re: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-2-git-send-email-logang@deltatee.com>
 <cb102386-0314-a3a3-ed44-b42debdf1512@codeaurora.org>
 <7158f2e8-2016-f398-e77f-0fcbe6cb41dd@deltatee.com>
 <e6a74aeb-9f54-51c5-8ad9-3b6fb92c03b3@codeaurora.org>
 <0280fbb4-ba9e-ac64-6bb3-b72590a54e57@deltatee.com>
 <0ae27bca-21be-b89c-aba4-6cc9766ebd7b@codeaurora.org>
 <c8edc480-a2ac-a763-8438-18f3396db483@deltatee.com>
 <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
 <c5d7da85-41fd-2769-fcf8-b3c2a1fab95f@deltatee.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <f0448277-9381-5c3d-d194-1efa1d1b44a6@codeaurora.org>
Date: Sat, 1 Apr 2017 22:26:01 -0400
MIME-Version: 1.0
In-Reply-To: <c5d7da85-41fd-2769-fcf8-b3c2a1fab95f@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Logan,

I added Alex and Bjorn above.

On 4/1/2017 6:16 PM, Logan Gunthorpe wrote:
> Hey,
> 
> On 31/03/17 08:17 PM, okaya@codeaurora.org wrote:
>> See drivers/pci and drivers/acpi directory.
> 
> The best I could find was the date of the firmware/bios. I really don't
> think that makes sense to tie the two together. And really the more that
> I think about it trying to do a date cutoff for this seems crazy without
> very comprehensive hardware testing done. I have no idea which AMD chips
> have decent root ports for this and then if we include all of ARM and
> POWERPC, etc there's a huge amount of unknown hardware. Saying that the
> system's firmware has to be written after 2016 seems like an arbitrary
> restriction that isn't likely to correlate to any working systems.

I recommended a combination of blacklist + p2p capability + BIOS date.
Not just BIOS date. BIOS date by itself is useless.

As you may or may not be aware, PCI defines capability registers for
discovering features. Unfortunately, there is no direct p2p capability
register. 

However, Access Control Services (ACS) capability register has flags
indicating p2p functionality. p2p feature needs to be discovered from ACS. 

https://pdos.csail.mit.edu/~sbw/links/ECN_access_control_061011.pdf

This is just one of the many P2P capability flags.

"ACS P2P Request Redirect: must be implemented by Root Ports that support peer-to-peer
traffic with other Root Ports5; must be implemented by Switch Downstream Ports."

If the root port or a switch does not have ACS capability, p2p is not allowed.
If these p2p flags are not set, don't allow p2p feature.

The normal expectation from any system (root port/switch) is not to set these
bits unless p2p feature is present/working.

However, there could be systems in the field with ACS capability but broken HW
or broken FW. 

This is when the BIOS date helps so that you don't break existing systems.

The right thing in my opinion is 

1. blacklist by pci vendor/device id like any other pci quirk in quirks.c.
2. Require this feature for recent HW/BIOS by checking the BIOS date.
3. Check the p2p capability from ACS. 

> 
> I still say the only sane thing to do is allow all switches and then add
> a whitelist of root ports that are known to work well. If we care about
> preventing broken systems in a comprehensive way then that's the only
> thing that is going to work.

We can't guarentee all switches will work either. See above for instructions
on when this feature should be enabled.

Let's step back for a moment.

If we think about logical blocks here, p2pmem is a pci user. It should
not walk the bus and search for possible good things by itself. We don't
usually put code into the kernel's driver directory for specific arch/
specific devices. There are hundreds of device drivers in the kernel. 
None of them are guarenteed to work in any architecture but they don't
prohibit use either.

System integrators like me test these drivers against their own systems,
find bugs to remove arch specific assumptions and post patches.

p2pmem is potentially just one of the many users of p2p capability in the
system.

This p2p detection needs to be done by some p2p driver inside the 
drivers/pci directory or inside drivers/pci/probe.c.

This p2p driver needs to verify ACS permissions similar to what
pci_device_group() does.

If the system is p2p capable, this p2p driver sets p2p_capable bit in 
struct pci_dev.

p2pmem driver then uses this bit to decide when it should enable its feature.

Bjorn and Alex needs to device about the final solution as they maintain both
PCI and virtualization (ACS) respectively.

Sinan

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
