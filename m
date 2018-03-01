Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20D98223522AA
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 19:50:13 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 w213tN03060193
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 22:56:21 -0500
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2ge44ym1j9-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 22:56:21 -0500
Received: from localhost
 by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <benh@au1.ibm.com>;
 Thu, 1 Mar 2018 03:56:18 -0000
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
Date: Thu, 01 Mar 2018 14:56:09 +1100
In-Reply-To: <1519876489.4592.3.camel@kernel.crashing.org>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
Mime-Version: 1.0
Message-Id: <1519876569.4592.4.camel@au1.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: benh@au1.ibm.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Oliver OHalloran <oliveroh@au1.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-03-01 at 14:54 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2018-02-28 at 16:39 -0700, Logan Gunthorpe wrote:
> > Hi Everyone,
> 
> 
> So Oliver (CC) was having issues getting any of that to work for us.
> 
> The problem is that acccording to him (I didn't double check the latest
> patches) you effectively hotplug the PCIe memory into the system when
> creating struct pages.
> 
> This cannot possibly work for us. First we cannot map PCIe memory as
> cachable. (Note that doing so is a bad idea if you are behind a PLX
> switch anyway since you'd ahve to manage cache coherency in SW).

Note: I think the above means it won't work behind a switch on x86
either, will it ?

> Then our MMIO space is so far away from our memory space that there is
> not enough vmemmap virtual space to be able to do that.
> 
> So this can only work accross achitectures by using something like HMM
> to create special device struct page's.
> 
> Ben.
> 
> 
> > Here's v2 of our series to introduce P2P based copy offload to NVMe
> > fabrics. This version has been rebased onto v4.16-rc3 which already
> > includes Christoph's devpagemap work the previous version was based
> > off as well as a couple of the cleanup patches that were in v1.
> > 
> > Additionally, we've made the following changes based on feedback:
> > 
> > * Renamed everything to 'p2pdma' per the suggestion from Bjorn as well
> >   as a bunch of cleanup and spelling fixes he pointed out in the last
> >   series.
> > 
> > * To address Alex's ACS concerns, we change to a simpler method of
> >   just disabling ACS behind switches for any kernel that has
> >   CONFIG_PCI_P2PDMA.
> > 
> > * We also reject using devices that employ 'dma_virt_ops' which should
> >   fairly simply handle Jason's concerns that this work might break with
> >   the HFI, QIB and rxe drivers that use the virtual ops to implement
> >   their own special DMA operations.
> > 
> > Thanks,
> > 
> > Logan
> > 
> > --
> > 
> > This is a continuation of our work to enable using Peer-to-Peer PCI
> > memory in NVMe fabrics targets. Many thanks go to Christoph Hellwig who
> > provided valuable feedback to get these patches to where they are today.
> > 
> > The concept here is to use memory that's exposed on a PCI BAR as
> > data buffers in the NVME target code such that data can be transferred
> > from an RDMA NIC to the special memory and then directly to an NVMe
> > device avoiding system memory entirely. The upside of this is better
> > QoS for applications running on the CPU utilizing memory and lower
> > PCI bandwidth required to the CPU (such that systems could be designed
> > with fewer lanes connected to the CPU). However, presently, the
> > trade-off is currently a reduction in overall throughput. (Largely due
> > to hardware issues that would certainly improve in the future).
> > 
> > Due to these trade-offs we've designed the system to only enable using
> > the PCI memory in cases where the NIC, NVMe devices and memory are all
> > behind the same PCI switch. This will mean many setups that could likely
> > work well will not be supported so that we can be more confident it
> > will work and not place any responsibility on the user to understand
> > their topology. (We chose to go this route based on feedback we
> > received at the last LSF). Future work may enable these transfers behind
> > a fabric of PCI switches or perhaps using a white list of known good
> > root complexes.
> > 
> > In order to enable this functionality, we introduce a few new PCI
> > functions such that a driver can register P2P memory with the system.
> > Struct pages are created for this memory using devm_memremap_pages()
> > and the PCI bus offset is stored in the corresponding pagemap structure.
> > 
> > Another set of functions allow a client driver to create a list of
> > client devices that will be used in a given P2P transactions and then
> > use that list to find any P2P memory that is supported by all the
> > client devices. This list is then also used to selectively disable the
> > ACS bits for the downstream ports behind these devices.
> > 
> > In the block layer, we also introduce a P2P request flag to indicate a
> > given request targets P2P memory as well as a flag for a request queue
> > to indicate a given queue supports targeting P2P memory. P2P requests
> > will only be accepted by queues that support it. Also, P2P requests
> > are marked to not be merged seeing a non-homogenous request would
> > complicate the DMA mapping requirements.
> > 
> > In the PCI NVMe driver, we modify the existing CMB support to utilize
> > the new PCI P2P memory infrastructure and also add support for P2P
> > memory in its request queue. When a P2P request is received it uses the
> > pci_p2pmem_map_sg() function which applies the necessary transformation
> > to get the corrent pci_bus_addr_t for the DMA transactions.
> > 
> > In the RDMA core, we also adjust rdma_rw_ctx_init() and
> > rdma_rw_ctx_destroy() to take a flags argument which indicates whether
> > to use the PCI P2P mapping functions or not.
> > 
> > Finally, in the NVMe fabrics target port we introduce a new
> > configuration boolean: 'allow_p2pmem'. When set, the port will attempt
> > to find P2P memory supported by the RDMA NIC and all namespaces. If
> > supported memory is found, it will be used in all IO transfers. And if
> > a port is using P2P memory, adding new namespaces that are not supported
> > by that memory will fail.
> > 
> > Logan Gunthorpe (10):
> >   PCI/P2PDMA: Support peer to peer memory
> >   PCI/P2PDMA: Add sysfs group to display p2pmem stats
> >   PCI/P2PDMA: Add PCI p2pmem dma mappings to adjust the bus offset
> >   PCI/P2PDMA: Clear ACS P2P flags for all devices behind switches
> >   block: Introduce PCI P2P flags for request and request queue
> >   IB/core: Add optional PCI P2P flag to rdma_rw_ctx_[init|destroy]()
> >   nvme-pci: Use PCI p2pmem subsystem to manage the CMB
> >   nvme-pci: Add support for P2P memory in requests
> >   nvme-pci: Add a quirk for a pseudo CMB
> >   nvmet: Optionally use PCI P2P memory
> > 
> >  Documentation/ABI/testing/sysfs-bus-pci |  25 ++
> >  block/blk-core.c                        |   3 +
> >  drivers/infiniband/core/rw.c            |  21 +-
> >  drivers/infiniband/ulp/isert/ib_isert.c |   5 +-
> >  drivers/infiniband/ulp/srpt/ib_srpt.c   |   7 +-
> >  drivers/nvme/host/core.c                |   4 +
> >  drivers/nvme/host/nvme.h                |   8 +
> >  drivers/nvme/host/pci.c                 | 118 ++++--
> >  drivers/nvme/target/configfs.c          |  29 ++
> >  drivers/nvme/target/core.c              |  95 ++++-
> >  drivers/nvme/target/io-cmd.c            |   3 +
> >  drivers/nvme/target/nvmet.h             |  10 +
> >  drivers/nvme/target/rdma.c              |  43 +-
> >  drivers/pci/Kconfig                     |  20 +
> >  drivers/pci/Makefile                    |   1 +
> >  drivers/pci/p2pdma.c                    | 713 ++++++++++++++++++++++++++++++++
> >  drivers/pci/pci.c                       |   4 +
> >  include/linux/blk_types.h               |  18 +-
> >  include/linux/blkdev.h                  |   3 +
> >  include/linux/memremap.h                |  19 +
> >  include/linux/pci-p2pdma.h              | 105 +++++
> >  include/linux/pci.h                     |   4 +
> >  include/rdma/rw.h                       |   7 +-
> >  net/sunrpc/xprtrdma/svc_rdma_rw.c       |   6 +-
> >  24 files changed, 1204 insertions(+), 67 deletions(-)
> >  create mode 100644 drivers/pci/p2pdma.c
> >  create mode 100644 include/linux/pci-p2pdma.h
> > 
> > --
> > 2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
