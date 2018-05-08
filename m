Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D16820945D96
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 14:25:39 -0700 (PDT)
Subject: Re: [PATCH v4 00/14] Copy Offload in NVMe Fabrics with P2P PCI Memory
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180507232346.GI161390@bhelgaas-glaptop.roam.corp.google.com>
 <20180508105759.7dbaa8fe@w520.home>
From: Don Dutile <ddutile@redhat.com>
Message-ID: <c16ecc49-a0f3-152d-785b-a646a3dab60d@redhat.com>
Date: Tue, 8 May 2018 17:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <20180508105759.7dbaa8fe@w520.home>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Alex Williamson <alex.williamson@redhat.com>, Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 05/08/2018 12:57 PM, Alex Williamson wrote:
> On Mon, 7 May 2018 18:23:46 -0500
> Bjorn Helgaas <helgaas@kernel.org> wrote:
> 
>> On Mon, Apr 23, 2018 at 05:30:32PM -0600, Logan Gunthorpe wrote:
>>> Hi Everyone,
>>>
>>> Here's v4 of our series to introduce P2P based copy offload to NVMe
>>> fabrics. This version has been rebased onto v4.17-rc2. A git repo
>>> is here:
>>>
>>> https://github.com/sbates130272/linux-p2pmem pci-p2p-v4
>>> ...
>>
>>> Logan Gunthorpe (14):
>>>    PCI/P2PDMA: Support peer-to-peer memory
>>>    PCI/P2PDMA: Add sysfs group to display p2pmem stats
>>>    PCI/P2PDMA: Add PCI p2pmem dma mappings to adjust the bus offset
>>>    PCI/P2PDMA: Clear ACS P2P flags for all devices behind switches
>>>    docs-rst: Add a new directory for PCI documentation
>>>    PCI/P2PDMA: Add P2P DMA driver writer's documentation
>>>    block: Introduce PCI P2P flags for request and request queue
>>>    IB/core: Ensure we map P2P memory correctly in
>>>      rdma_rw_ctx_[init|destroy]()
>>>    nvme-pci: Use PCI p2pmem subsystem to manage the CMB
>>>    nvme-pci: Add support for P2P memory in requests
>>>    nvme-pci: Add a quirk for a pseudo CMB
>>>    nvmet: Introduce helper functions to allocate and free request SGLs
>>>    nvmet-rdma: Use new SGL alloc/free helper for requests
>>>    nvmet: Optionally use PCI P2P memory
>>>
>>>   Documentation/ABI/testing/sysfs-bus-pci    |  25 +
>>>   Documentation/PCI/index.rst                |  14 +
>>>   Documentation/driver-api/index.rst         |   2 +-
>>>   Documentation/driver-api/pci/index.rst     |  20 +
>>>   Documentation/driver-api/pci/p2pdma.rst    | 166 ++++++
>>>   Documentation/driver-api/{ => pci}/pci.rst |   0
>>>   Documentation/index.rst                    |   3 +-
>>>   block/blk-core.c                           |   3 +
>>>   drivers/infiniband/core/rw.c               |  13 +-
>>>   drivers/nvme/host/core.c                   |   4 +
>>>   drivers/nvme/host/nvme.h                   |   8 +
>>>   drivers/nvme/host/pci.c                    | 118 +++--
>>>   drivers/nvme/target/configfs.c             |  67 +++
>>>   drivers/nvme/target/core.c                 | 143 ++++-
>>>   drivers/nvme/target/io-cmd.c               |   3 +
>>>   drivers/nvme/target/nvmet.h                |  15 +
>>>   drivers/nvme/target/rdma.c                 |  22 +-
>>>   drivers/pci/Kconfig                        |  26 +
>>>   drivers/pci/Makefile                       |   1 +
>>>   drivers/pci/p2pdma.c                       | 814 +++++++++++++++++++++++++++++
>>>   drivers/pci/pci.c                          |   6 +
>>>   include/linux/blk_types.h                  |  18 +-
>>>   include/linux/blkdev.h                     |   3 +
>>>   include/linux/memremap.h                   |  19 +
>>>   include/linux/pci-p2pdma.h                 | 118 +++++
>>>   include/linux/pci.h                        |   4 +
>>>   26 files changed, 1579 insertions(+), 56 deletions(-)
>>>   create mode 100644 Documentation/PCI/index.rst
>>>   create mode 100644 Documentation/driver-api/pci/index.rst
>>>   create mode 100644 Documentation/driver-api/pci/p2pdma.rst
>>>   rename Documentation/driver-api/{ => pci}/pci.rst (100%)
>>>   create mode 100644 drivers/pci/p2pdma.c
>>>   create mode 100644 include/linux/pci-p2pdma.h
>>
>> How do you envison merging this?  There's a big chunk in drivers/pci, but
>> really no opportunity for conflicts there, and there's significant stuff in
>> block and nvme that I don't really want to merge.
>>
>> If Alex is OK with the ACS situation, I can ack the PCI parts and you could
>> merge it elsewhere?
> 
> AIUI from previously questioning this, the change is hidden behind a
> build-time config option and only custom kernels or distros optimized
> for this sort of support would enable that build option.  I'm more than
> a little dubious though that we're not going to have a wave of distros
> enabling this only to get user complaints that they can no longer make
> effective use of their devices for assignment due to the resulting span
> of the IOMMU groups, nor is there any sort of compromise, configure
> the kernel for p2p or device assignment, not both.  Is this really such
> a unique feature that distro users aren't going to be asking for both
> features?  Thanks,
> 
> Alex
At least 1/2 the cases presented to me by existing customers want it in a tunable kernel,
and tunable btwn two points, if the hw allows it to be 'contained' in that manner, which
a (layer of) switch(ing) provides.
To me, that means a kernel cmdline parameter to _enable_, and another sysfs (configfs? ... i'm not a configfs afficionato to say which is best),
method to make two points p2p dma capable.

Worse case, the whole system is one large IOMMU group (current mindset of this static or run-time config option),
or best case (over time, more hw), a secure set of the primary system with p2p-enabled sections, that are deemed 'safe' or 'self-inflicting-unsecure',
the latter the case of today's VM with an assigned device -- can scribble all over the VM, but no other VM and not the host/HV.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
