Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 217251A1E34
 for <linux-nvdimm@lists.01.org>; Sun,  9 Oct 2016 17:35:36 -0700 (PDT)
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Date: Mon, 10 Oct 2016 08:35:21 +0800
Message-Id: <20161010003523.4423-1-haozhong.zhang@intel.com>
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
To: linux-nvdimm@lists.01.org, xen-devel@lists.xenproject.org
Cc: Juergen Gross <jgross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Overview
========
This RFC kernel patch series along with corresponding patch series of
Xen, QEMU and ndctl implements Xen vNVDIMM, which can map the host
NVDIMM devices to Xen HVM domU as vNVDIMM devices.

Xen hypervisor does not include an NVDIMM driver, so it needs the
assistance from the driver in Dom0 Linux kernel to manage NVDIMM
devices. We currently only supports NVDIMM devices in pmem mode.

Design and Implementation
=========================
The complete design can be found at
  https://lists.xenproject.org/archives/html/xen-devel/2016-07/msg01921.html.

All patch series can be found at
  Xen:          https://github.com/hzzhan9/xen.git nvdimm-rfc-v1
  QEMU:         https://github.com/hzzhan9/qemu.git xen-nvdimm-rfc-v1
  Linux kernel: https://github.com/hzzhan9/nvdimm.git xen-nvdimm-rfc-v1
  ndctl:        https://github.com/hzzhan9/ndctl.git pfn-xen-rfc-v1

Xen hypervisor needs assistance from Dom0 Linux kernel for following tasks:
1) Reserve an area on NVDIMM devices for Xen hypervisor to place
   memory management data structures, i.e. frame table and M2P table.
2) Report SPA ranges of NVDIMM devices and the reserved area to Xen
   hypervisor.

For 1), Patch 1 implements a new mode PFN_MODE_XEN to pfn devices, which
make the reservation for Xen hypervisor.

For 2), Patch 2 uses a new Xen hypercall to report the address
information of pfn devices in PFN_MODE_XEN.

How to test
===========
Please refer to the cover letter of Xen patch series
"[RFC XEN PATCH 00/16] Add vNVDIMM support to HVM domains".


Haozhong Zhang (2):
  nvdimm: add PFN_MODE_XEN to pfn device for Xen usage
  xen, nvdimm: report pfn devices in PFN_MODE_XEN to Xen hypervisor

 drivers/nvdimm/namespace_devs.c  |  2 ++
 drivers/nvdimm/nd.h              |  7 +++++
 drivers/nvdimm/pfn_devs.c        | 37 +++++++++++++++++++++---
 drivers/nvdimm/pmem.c            | 61 ++++++++++++++++++++++++++++++++++++++--
 drivers/xen/Makefile             |  2 +-
 drivers/xen/pmem.c               | 53 ++++++++++++++++++++++++++++++++++
 include/linux/pfn_t.h            |  2 ++
 include/xen/interface/platform.h | 13 +++++++++
 include/xen/pmem.h               | 32 +++++++++++++++++++++
 9 files changed, 201 insertions(+), 8 deletions(-)
 create mode 100644 drivers/xen/pmem.c
 create mode 100644 include/xen/pmem.h

-- 
2.10.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
