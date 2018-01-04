Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 585B321F833AF
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 10:59:57 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu,  4 Jan 2018 12:01:25 -0700
Message-Id: <20180104190137.7654-1-logang@deltatee.com>
Subject: [PATCH 00/11] Copy Offload in NVMe Fabrics with P2P PCI Memory
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Keith Busch <keith.busch@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hello,

This is a continuation of our work to enable using Peer-to-Peer PCI
memory in NVMe fabrics targets. Many thanks go to Christoph Hellwig who
provided valuable feedback to get these patches to where they are today.

The concept here is to use memory that's exposed on a PCI BAR as
data buffers in the NVME target code such that data can be transferred
from an RDMA NIC to the special memory and then directly to an NVMe
device avoiding system memory entirely. The upside of this is better
QoS for applications running on the CPU utilizing memory and lower
PCI bandwidth required to the CPU (such that systems could be designed
with fewer lanes connected to the CPU). However, presently, the
trade-off is currently a reduction in overall throughput. (Largely due
to hardware issues that would certainly improve in the future).

Due to these trade-offs we've designed the system to only enable using
the PCI memory in cases where the NIC, NVMe devices and memory are all
behind the same PCI switch. This will mean many setups that could likely
work well will not be supported so that we can be more confident it
will work and not place any responsibility on the user to understand
their topology. (We chose to go this route based on feedback we
received at the last LSF). Future work may enable these transfers behind
a fabric of PCI switches or perhaps using a white list of known good
root complexes.

In order to enable this functionality, we introduce a few new PCI
functions such that a driver can register P2P memory with the system.
Struct pages are created for this memory using devm_memremap_pages()
and the PCI bus offset is stored in the corresponding pagemap structure.

Another set of functions allow a client driver to create a list of
client devices that will be used in a given P2P transactions and then
use that list to find any P2P memory that is supported by all the
client devices. This list is then also used to selectively disable the
ACS bits for the downstream ports behind these devices.

In the block layer, we also introduce a P2P request flag to indicate a
given request targets P2P memory as well as a flag for a request queue
to indicate a given queue supports targeting P2P memory. P2P requests
will only be accepted by queues that support it. Also, P2P requests
are marked to not be merged seeing a non-homogenous request would
complicate the DMA mapping requirements.

In the PCI NVMe driver, we modify the existing CMB support to utilize
the new PCI P2P memory infrastructure and also add support for P2P
memory in its request queue. When a P2P request is received it uses the
pci_p2pmem_map_sg() function which applies the necessary transformation
to get the corrent pci_bus_addr_t for the DMA transactions.

In the RDMA core, we also adjust rdma_rw_ctx_init() and
rdma_rw_ctx_destroy() to take a flags argument which indicates whether
to use the PCI P2P mapping functions or not.

Finally, in the NVMe fabrics target port we introduce a new
configuration boolean: 'allow_p2pmem'. When set, the port will attempt
to find P2P memory supported by the RDMA NIC and all namespaces. If
supported memory is found, it will be used in all IO transfers. And if
a port is using P2P memory, adding new namespaces that are not supported
by that memory will fail.

This series is based off of Christoph's v3 series to revamp
dev_pagemap. A git repo of the patches is available here[2].

Logan

Christoph Hellwig (2):
  nvme-pci: clean up CMB initialization
  nvme-pci: clean up SMBSZ bit definitions

Logan Gunthorpe (10):
  pci-p2p: Support peer to peer memory
  pci-p2p: Add sysfs group to display p2pmem stats
  pci-p2p: Add PCI p2pmem dma mappings to adjust the bus offset
  pci-p2p: Clear ACS P2P flags for all client devices
  block: Introduce PCI P2P flags for request and request queue
  IB/core: Add optional PCI P2P flag to rdma_rw_ctx_[init|destroy]()
  nvme-pci: Use PCI p2pmem subsystem to manage the CMB
  nvme-pci: Add support for P2P memory in requests
  nvme-pci: Add a quirk for a pseudo CMB
  nvmet: Optionally use PCI P2P memory

 Documentation/ABI/testing/sysfs-bus-pci |  25 +
 block/blk-core.c                        |   3 +
 drivers/infiniband/core/rw.c            |  22 +-
 drivers/infiniband/ulp/isert/ib_isert.c |   5 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c   |   7 +-
 drivers/nvme/host/core.c                |   4 +
 drivers/nvme/host/nvme.h                |   8 +
 drivers/nvme/host/pci.c                 | 164 ++++---
 drivers/nvme/target/configfs.c          |  29 ++
 drivers/nvme/target/core.c              |  95 +++-
 drivers/nvme/target/io-cmd.c            |   3 +
 drivers/nvme/target/nvmet.h             |  10 +
 drivers/nvme/target/rdma.c              |  41 +-
 drivers/pci/Kconfig                     |  14 +
 drivers/pci/Makefile                    |   1 +
 drivers/pci/p2p.c                       | 781 ++++++++++++++++++++++++++++++++
 include/linux/blk_types.h               |  18 +-
 include/linux/blkdev.h                  |   2 +
 include/linux/memremap.h                |  19 +
 include/linux/nvme.h                    |  22 +-
 include/linux/pci-p2p.h                 |  94 ++++
 include/linux/pci.h                     |   6 +
 include/rdma/rw.h                       |   7 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c       |   6 +-
 24 files changed, 1291 insertions(+), 95 deletions(-)
 create mode 100644 drivers/pci/p2p.c
 create mode 100644 include/linux/pci-p2p.h

--
2.11.0
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
