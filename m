From: Pankaj Gupta <pagupta@redhat.com>
Subject: [RFC 0/2] kvm "fake DAX" device flushing
Date: Thu,  5 Apr 2018 16:18:31 +0530
Message-ID: <20180405104834.10457-1-pagupta@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org
Cc: jack@suse.cz, stefanha@redhat.com, dan.j.williams@intel.com, riel@surriel.com, haozhong.zhang@intel.com, nilal@redhat.com, kwolf@redhat.com, pbonzini@redhat.com, ross.zwisler@intel.com, david@redhat.com, xiaoguangrong.eric@gmail.com, hch@infradead.org, marcel@redhat.com, mst@redhat.com, niteshnarayanlal@hotmail.com, imammedo@redhat.com, pagupta@redhat.com
List-Id: linux-nvdimm@lists.01.org

We are sharing RFC version of 'fake DAX' flushing
interface for feedback. This is still work in progress
and not yet ready for merging.

Prototype implements two major parts:

- Qemu virtio-pmem device
  It exposes a persistent memory range to KVM guest which at host side is file
  backed memory and works as persistent memory device. In addition to this it
  provides a virtio flushing interface for KVM guest to do a Qemu side sync for
  guest DAX persistent memory range.  

- Guest virtio-pmem driver
  Reads persistent memory range from paravirt device and registers with 'nvdimm_bus'.
  'nvdimm/pmem' driver uses this information to allocate persistent memory range. 
  Also, we have implemented guest side of VIRTIO flushing interface.
  
Changes from previous RFC:

- Reuse existing 'pmem' code instead of creating an entirely new block driver.
- Use VIRTIO driver to register memory information with nvdimm_bus and create
  region_type accordingly. 
- Use VIRTIO flushing interface from existing pmem driver code based on
  registered flushign mechanism.

We have done the implementation based on suggestions here [1]. Previous RFC is
shared here [2]. Details of project idea for 'fake DAX' flushing is shared 
here [3] & [4].

[1] https://marc.info/?l=linux-mm&m=150782346802290&w=2
[2] https://marc.info/?l=kvm&m=151630416506527&w=2
[3] https://www.spinics.net/lists/kvm/msg149761.html
[4] https://www.spinics.net/lists/kvm/msg153095.html

Work yet to be done:

- Qemu RAM address handling independent of PC-DIMM so that memory
  operations(get_free_address) can be used for VIRTIO device type as well. 
  (David Hildenbrand CCed has a prototype for this).
- Qemu device flush functionality trigger with guest fsync on file.
- Qemu live migration work when host page cache is used.
- Multiple virtio-pmem disks support.
- Prepare virtio spec after we get feedback on current approach.

 drivers/nvdimm/region_devs.c     |    7 ++
 drivers/virtio/Kconfig           |   12 +++
 drivers/virtio/Makefile          |    1 
 drivers/virtio/virtio_pmem.c     |  122 +++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h        |    2 
 include/uapi/linux/virtio_ids.h  |    1 
 include/uapi/linux/virtio_pmem.h |   61 +++++++++++++++++++
 7 files changed, 206 insertions(+)
