Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38D5F211E372D
 for <linux-nvdimm@lists.01.org>; Mon, 11 Jun 2018 20:28:58 -0700 (PDT)
From: Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 0/4] resource: Use list_head to link sibling resource
Date: Tue, 12 Jun 2018 11:28:27 +0800
Message-Id: <20180612032831.29747-1-bhe@redhat.com>
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
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, robh+dt@kernel.org, dan.j.williams@intel.com, nicolas.pitre@linaro.org, josh@joshtriplett.org, fengguang.wu@intel.com, bp@suse.de
Cc: brijesh.singh@amd.com, devicetree@vger.kernel.org, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, keith.busch@intel.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, kys@microsoft.com, frowand.list@gmail.com, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, dyoung@redhat.com, thomas.lendacky@amd.com, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, jglisse@redhat.com, seanpaul@chromium.org, bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, ebiederm@xmission.com, devel@linuxdriverproject.org, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

This patchset is doing:
1) Replace struct resource's sibling list from singly linked list to
list_head. Clearing out those pointer operation within singly linked
list for better code readability.
2) Based on list_head replacement, add a new function
walk_system_ram_res_rev() which can does reversed iteration on
iomem_resource's siblings.
3) Change kexec_file loading to search system RAM top down for kernel
loadin, using walk_system_ram_res_rev().

Note:
This patchset passed testing on my kvm guest, x86_64 arch with network
enabling. The thing we need pay attetion to is that a root resource's
child member need be initialized specifically with LIST_HEAD_INIT() if
statically defined or INIT_LIST_HEAD() for dynamically definition. Here
Just like we do for iomem_resource/ioport_resource, or the change in
get_pci_domain_busn_res().


Links of the old post (Boris pointed out that we should use
https://lkml.kernel.org/r/Message-ID, while it can't be opened from
my side, so paste all of them here.):
v4:
https://lkml.kernel.org/r/20180507063224.24229-1-bhe@redhat.com
https://lkml.org/lkml/2018/5/7/36

v3:
https://lkml.kernel.org/r/20180419001848.3041-1-bhe@redhat.com
https://lkml.org/lkml/2018/4/18/767

v2:
https://lkml.kernel.org/r/20180408024724.16812-1-bhe@redhat.com
https://lkml.org/lkml/2018/4/7/169

v1:
https://lkml.kernel.org/r/20180322033722.9279-1-bhe@redhat.com
https://lkml.org/lkml/2018/3/21/952

Changelog:
v4->v5:
  Add new patch 0001 to move duplicated reparent_resources() to
  kernel/resource.c to make it be shared by different ARCH-es.

  Fix several code bugs reported by test robot on ARCH powerpc and
  microblaze.
v3->v4:
  Fix several bugs test robot reported. Rewrite cover letter and patch
  log according to reviewer's comment.

v2->v3:
  Rename resource functions first_child() and sibling() to
  resource_first_chils() and resource_sibling(). Dan suggested this.

  Move resource_first_chils() and resource_sibling() to linux/ioport.h
  and make them as inline function. Rob suggested this. Accordingly add
  linux/list.h including in linux/ioport.h, please help review if this
  bring efficiency degradation or code redundancy.

  The change on struct resource {} bring two pointers of size increase,
  mention this in git log to make it more specifically, Rob suggested
  this.

v1->v2:
  Use list_head instead to link resource siblings. This is suggested by
  Andrew.

  Rewrite walk_system_ram_res_rev() after list_head is taken to link
  resouce siblings.

Baoquan He (4):
  resource: Move reparent_resources() to kernel/resource.c and make it
    public
  resource: Use list_head to link sibling resource
  resource: add walk_system_ram_res_rev()
  kexec_file: Load kernel at top of system RAM if required

 arch/arm/plat-samsung/pm-check.c            |   6 +-
 arch/microblaze/pci/pci-common.c            |  41 +----
 arch/powerpc/kernel/pci-common.c            |  39 +----
 arch/sparc/kernel/ioport.c                  |   2 +-
 arch/xtensa/include/asm/pci-bridge.h        |   4 +-
 drivers/eisa/eisa-bus.c                     |   2 +
 drivers/gpu/drm/drm_memory.c                |   3 +-
 drivers/gpu/drm/gma500/gtt.c                |   5 +-
 drivers/hv/vmbus_drv.c                      |  52 +++---
 drivers/input/joystick/iforce/iforce-main.c |   4 +-
 drivers/nvdimm/namespace_devs.c             |   6 +-
 drivers/nvdimm/nd.h                         |   5 +-
 drivers/of/address.c                        |   4 +-
 drivers/parisc/lba_pci.c                    |   4 +-
 drivers/pci/host/vmd.c                      |   8 +-
 drivers/pci/probe.c                         |   2 +
 drivers/pci/setup-bus.c                     |   2 +-
 include/linux/ioport.h                      |  21 ++-
 kernel/kexec_file.c                         |   2 +
 kernel/resource.c                           | 259 ++++++++++++++++++----------
 20 files changed, 244 insertions(+), 227 deletions(-)

-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
