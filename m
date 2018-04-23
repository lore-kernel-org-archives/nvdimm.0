Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E75322512129
 for <linux-nvdimm@lists.01.org>; Mon, 23 Apr 2018 16:31:03 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon, 23 Apr 2018 17:30:32 -0600
Message-Id: <20180423233046.21476-1-logang@deltatee.com>
Subject: [PATCH v4 00/14] Copy Offload in NVMe Fabrics with P2P PCI Memory
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
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Everyone,

Here's v4 of our series to introduce P2P based copy offload to NVMe
fabrics. This version has been rebased onto v4.17-rc2. A git repo
is here:

https://github.com/sbates130272/linux-p2pmem pci-p2p-v4

Thanks,

Logan

Changes in v4:

* Change the original upstream_bridges_match() function to
  upstream_bridge_distance() which calculates the distance between two
  devices as long as they are behind the same root port. This should
  address Bjorn's concerns that the code was to focused on
  being behind a single switch.

* The disable ACS function now disables ACS for all bridge ports instead
  of switch ports (ie. those that had two upstream_bridge ports).

* Change the pci_p2pmem_alloc_sgl() and pci_p2pmem_free_sgl()
  API to be more like sgl_alloc() in that the alloc function returns
  the allocated scatterlist and nents is not required bythe free
  function.

* Moved the new documentation into the driver-api tree as requested
  by Jonathan

* Add SGL alloc and free helpers in the nvmet code so that the
  individual drivers can share the code that allocates P2P memory.
  As requested by Christoph.

* Cleanup the nvmet_p2pmem_store() function as Christoph
  thought my first attempt was ugly.

* Numerous commit message and comment fix-ups

Changes in v3:

* Many more fixes and minor cleanups that were spotted by Bjorn

* Additional explanation of the ACS change in both the commit message
  and Kconfig doc. Also, the code that disables the ACS bits is surrounded
  explicitly by an #ifdef

* Removed the flag we added to rdma_rw_ctx() in favour of using
  is_pci_p2pdma_page(), as suggested by Sagi.

* Adjust pci_p2pmem_find() so that it prefers P2P providers that
  are closest to (or the same as) the clients using them. In cases
  of ties, the provider is randomly chosen.

* Modify the NVMe Target code so that the PCI device name of the provider
  may be explicitly specified, bypassing the logic in pci_p2pmem_find().
  (Note: it's still enforced that the provider must be behind the
   same switch as the clients).

* As requested by Bjorn, added documentation for driver writers.


Changes in v2:

* Renamed everything to 'p2pdma' per the suggestion from Bjorn as well
  as a bunch of cleanup and spelling fixes he pointed out in the last
  series.

* To address Alex's ACS concerns, we change to a simpler method of
  just disabling ACS behind switches for any kernel that has
  CONFIG_PCI_P2PDMA.

* We also reject using devices that employ 'dma_virt_ops' which should
  fairly simply handle Jason's concerns that this work might break with
  the HFI, QIB and rxe drivers that use the virtual ops to implement
  their own special DMA operations.

--

This is a continuation of our work to enable using Peer-to-Peer PCI
memory in the kernel with initial support for the NVMe fabrics target
subsystem. Many thanks go to Christoph Hellwig who provided valuable
feedback to get these patches to where they are today.

The concept here is to use memory that's exposed on a PCI BAR as
data buffers in the NVMe target code such that data can be transferred
from an RDMA NIC to the special memory and then directly to an NVMe
device avoiding system memory entirely. The upside of this is better
QoS for applications running on the CPU utilizing memory and lower
PCI bandwidth required to the CPU (such that systems could be designed
with fewer lanes connected to the CPU).

Due to these trade-offs we've designed the system to only enable using
the PCI memory in cases where the NIC, NVMe devices and memory are all
behind the same PCI switch hierarchy. This will mean many setups that
could likely work well will not be supported so that we can be more
confident it will work and not place any responsibility on the user to
understand their topology. (We chose to go this route based on feedback
we received at the last LSF). Future work may enable these transfers
using a white list of known good root complexes. However, at this time,
there is no reliable way to ensure that Peer-to-Peer transactions are
permitted between PCI Root Ports.

In order to enable this functionality, we introduce a few new PCI
functions such that a driver can register P2P memory with the system.
Struct pages are created for this memory using devm_memremap_pages()
and the PCI bus offset is stored in the corresponding pagemap structure.

When the PCI P2PDMA config option is selected the ACS bits in every
bridge port in the system are turned off to allow traffic to
pass freely behind the root port. At this time, the bit must be disabled
at boot so the IOMMU subsystem can correctly create the groups, though
this could be addressed in the future. There is no way to dynamically
disable the bit and alter the groups.

Another set of functions allow a client driver to create a list of
client devices that will be used in a given P2P transactions and then
use that list to find any P2P memory that is supported by all the
client devices.

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
to use the PCI P2P mapping functions or not. To avoid odd RDMA devices
that don't use the proper DMA infrastructure this code rejects using
any device that employs the virt_dma_ops implementation.

Finally, in the NVMe fabrics target port we introduce a new
configuration boolean: 'allow_p2pmem'. When set, the port will attempt
to find P2P memory supported by the RDMA NIC and all namespaces. If
supported memory is found, it will be used in all IO transfers. And if
a port is using P2P memory, adding new namespaces that are not supported
by that memory will fail.

These patches have been tested on a number of Intel based systems and
for a variety of RDMA NICs (Mellanox, Broadcomm, Chelsio) and NVMe
SSDs (Intel, Seagate, Samsung) and p2pdma devices (Eideticom,
Microsemi, Chelsio and Everspin) using switches from both Microsemi
and Broadcomm.

Logan Gunthorpe (14):
  PCI/P2PDMA: Support peer-to-peer memory
  PCI/P2PDMA: Add sysfs group to display p2pmem stats
  PCI/P2PDMA: Add PCI p2pmem dma mappings to adjust the bus offset
  PCI/P2PDMA: Clear ACS P2P flags for all devices behind switches
  docs-rst: Add a new directory for PCI documentation
  PCI/P2PDMA: Add P2P DMA driver writer's documentation
  block: Introduce PCI P2P flags for request and request queue
  IB/core: Ensure we map P2P memory correctly in
    rdma_rw_ctx_[init|destroy]()
  nvme-pci: Use PCI p2pmem subsystem to manage the CMB
  nvme-pci: Add support for P2P memory in requests
  nvme-pci: Add a quirk for a pseudo CMB
  nvmet: Introduce helper functions to allocate and free request SGLs
  nvmet-rdma: Use new SGL alloc/free helper for requests
  nvmet: Optionally use PCI P2P memory

 Documentation/ABI/testing/sysfs-bus-pci    |  25 +
 Documentation/PCI/index.rst                |  14 +
 Documentation/driver-api/index.rst         |   2 +-
 Documentation/driver-api/pci/index.rst     |  20 +
 Documentation/driver-api/pci/p2pdma.rst    | 166 ++++++
 Documentation/driver-api/{ => pci}/pci.rst |   0
 Documentation/index.rst                    |   3 +-
 block/blk-core.c                           |   3 +
 drivers/infiniband/core/rw.c               |  13 +-
 drivers/nvme/host/core.c                   |   4 +
 drivers/nvme/host/nvme.h                   |   8 +
 drivers/nvme/host/pci.c                    | 118 +++--
 drivers/nvme/target/configfs.c             |  67 +++
 drivers/nvme/target/core.c                 | 143 ++++-
 drivers/nvme/target/io-cmd.c               |   3 +
 drivers/nvme/target/nvmet.h                |  15 +
 drivers/nvme/target/rdma.c                 |  22 +-
 drivers/pci/Kconfig                        |  26 +
 drivers/pci/Makefile                       |   1 +
 drivers/pci/p2pdma.c                       | 814 +++++++++++++++++++++++++++++
 drivers/pci/pci.c                          |   6 +
 include/linux/blk_types.h                  |  18 +-
 include/linux/blkdev.h                     |   3 +
 include/linux/memremap.h                   |  19 +
 include/linux/pci-p2pdma.h                 | 118 +++++
 include/linux/pci.h                        |   4 +
 26 files changed, 1579 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/PCI/index.rst
 create mode 100644 Documentation/driver-api/pci/index.rst
 create mode 100644 Documentation/driver-api/pci/p2pdma.rst
 rename Documentation/driver-api/{ => pci}/pci.rst (100%)
 create mode 100644 drivers/pci/p2pdma.c
 create mode 100644 include/linux/pci-p2pdma.h

--
2.11.0
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
