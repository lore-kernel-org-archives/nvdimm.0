From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] kvm "fake DAX" device
Date: Fri, 31 Aug 2018 19:00:15 +0530
Message-ID: <20180831133019.27579-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

 This patch series has implementation for "fake DAX". 
 "fake DAX" is fake persistent memory(nvdimm) in guest 
 which allows to bypass the guest page cache. This also
 implements a VIRTIO based asynchronous flush mechanism.  
 
 Sharing guest driver and qemu device changes in separate 
 patch sets for easy review and it has been tested together. 
 
 Details of project idea for 'fake DAX' flushing interface 
 is shared [2] & [3].

 Implementation is divided into two parts:
 New virtio pmem guest driver and qemu code changes for new 
 virtio pmem paravirtualized device.

1. Guest virtio-pmem kernel driver
---------------------------------
   - Reads persistent memory range from paravirt device and 
     registers with 'nvdimm_bus'.  
   - 'nvdimm/pmem' driver uses this information to allocate 
     persistent memory region and setup filesystem operations 
     to the allocated memory. 
   - virtio pmem driver implements asynchronous flushing 
     interface to flush from guest to host.

2. Qemu virtio-pmem device
---------------------------------
   - Creates virtio pmem device and exposes a memory range to 
     KVM guest. 
   - At host side this is file backed memory which acts as 
     persistent memory. 
   - Qemu side flush uses aio thread pool API's and virtio 
     for asynchronous guest multi request handling. 

   David Hildenbrand CCed also posted a modified version[4] of 
   qemu virtio-pmem code based on updated Qemu memory device API. 

 Virtio-pmem errors handling:
 ----------------------------------------
  Checked behaviour of virtio-pmem for below types of errors
  Need suggestions on expected behaviour for handling these errors?

  - Hardware Errors: Uncorrectable recoverable Errors: 
  a] virtio-pmem: 
    - As per current logic if error page belongs to Qemu process, 
      host MCE handler isolates(hwpoison) that page and send SIGBUS. 
      Qemu SIGBUS handler injects exception to KVM guest. 
    - KVM guest then isolates the page and send SIGBUS to guest 
      userspace process which has mapped the page. 
  
  b] Existing implementation for ACPI pmem driver: 
    - Handles such errors with MCE notifier and creates a list 
      of bad blocks. Read/direct access DAX operation return EIO 
      if accessed memory page fall in bad block list.
    - It also starts backgound scrubbing.  
    - Similar functionality can be reused in virtio-pmem with MCE 
      notifier but without scrubbing(no ACPI/ARS)? Need inputs to 
      confirm if this behaviour is ok or needs any change?

Changes from RFC v3: [1]
- Rebase to latest upstream - Luiz
- Call ndregion->flush in place of nvdimm_flush- Luiz
- kmalloc return check - Luiz
- virtqueue full handling - Stefan
- Don't map entire virtio_pmem_req to device - Stefan
- request leak,correct sizeof req- Stefan
- Move declaration to virtio_pmem.c

Changes from RFC v2:
- Add flush function in the nd_region in place of switching
  on a flag - Dan & Stefan
- Add flush completion function with proper locking and wait
  for host side flush completion - Stefan & Dan
- Keep userspace API in uapi header file - Stefan, MST
- Use LE fields & New device id - MST
- Indentation & spacing suggestions - MST & Eric
- Remove extra header files & add licensing - Stefan

Changes from RFC v1:
- Reuse existing 'pmem' code for registering persistent 
  memory and other operations instead of creating an entirely 
  new block driver.
- Use VIRTIO driver to register memory information with 
  nvdimm_bus and create region_type accordingly. 
- Call VIRTIO flush from existing pmem driver.

Pankaj Gupta (3):
   nd: move nd_region to common header
   libnvdimm: nd_region flush callback support
   virtio-pmem: Add virtio-pmem guest driver

[1] https://lkml.org/lkml/2018/7/13/102
[2] https://www.spinics.net/lists/kvm/msg149761.html
[3] https://www.spinics.net/lists/kvm/msg153095.html  
[4] https://marc.info/?l=qemu-devel&m=153555721901824&w=2

 drivers/acpi/nfit/core.c         |    7 -
 drivers/nvdimm/claim.c           |    3 
 drivers/nvdimm/nd.h              |   39 -----
 drivers/nvdimm/pmem.c            |   12 +
 drivers/nvdimm/region_devs.c     |   12 +
 drivers/virtio/Kconfig           |    9 +
 drivers/virtio/Makefile          |    1 
 drivers/virtio/virtio_pmem.c     |  255 +++++++++++++++++++++++++++++++++++++++
 include/linux/libnvdimm.h        |    4 
 include/linux/nd.h               |   40 ++++++
 include/uapi/linux/virtio_ids.h  |    1 
 include/uapi/linux/virtio_pmem.h |   40 ++++++
 12 files changed, 374 insertions(+), 49 deletions(-)
