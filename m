Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C895282029
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:32:34 -0800 (PST)
Subject: [PATCH 0/8] device-dax: sub-division support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:28:25 -0800
Message-ID: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

>>From [PATCH 6/8] dax: sub-division support:

Device-DAX is a mechanism to establish mappings of performance / feature
differentiated memory with strict fault behavior guarantees.  With
sub-division support a platform owner can provision sub-allocations of a
dax-region into separate devices. The provisioning mechanism follows the
same scheme as the libnvdimm sub-system in that a 'seed' device is
created at initialization time that can be resized from zero to become
enabled.

Unlike the nvdimm sub-system there is no on media labelling scheme
associated with this partitioning. Provisioning decisions are ephemeral
/ not automatically restored after reboot. While the initial use case of
device-dax is persistent memory other uses case may be volatile, so the
device-dax core is unable to assume the underlying memory is pmem.  The
task of recalling a partitioning scheme or permissions on the device(s)
is left to userspace.

For persistent allocations, naming, and permissions automatically
recalled by the kernel, use filesystem-DAX. For a userspace helper
library and utility for manipulating device-dax instances see libdaxctl
and the daxctl utility here: https://github.com/pmem/ndctl

---

Dan Williams (8):
      dax: add region-available-size attribute
      dax: add region 'id', 'size', and 'align' attributes
      dax: register seed device
      dax: use multi-order radix for resource lookup
      dax: refactor locking out of size calculation routines
      dax: sub-division support
      dax: add / remove dax devices after provisioning
      dax: add debug for region available_size


 drivers/dax/Kconfig |    1 
 drivers/dax/dax.c   |  747 ++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 698 insertions(+), 50 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
