Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A443120082E7E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:14:07 -0700 (PDT)
Subject: [PATCH 0/9] libnvdimm, label: namespace specification v1.2 support
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:08:50 -0700
Message-ID: <149698493023.11651.13036549892428981091.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The recently released UEFI 2.7 Specification [1], includes an updated
version (v1.2) of the NVDIMM Namespace Label Specification that was previously
published on pmem.io [2] (v1.1).

In the process of moving to a UEFI standard definition the v1.2 updates
adds several features for improved cross-OS and pre-OS (EFI driver)
compatibility and safety. The major highlights include:

1/ Support for an "address abstraction guid" so that implementations can
   uniquely identify personalities layered on top of a namespace. A
   standard address abstraction definition example is the BTT (Block
   Translation Table for sector atomicity) layout. A private / local
   abstraction definition example is the Linux device-DAX personality.

2/ Checksums for individual label slots

3/ Additional safety and self-consistency properties like an updated
   interleave-set-cookie algorithm and recording the NFIT address-type-guid
   in the namespace.

UEFI mandates that these labels be accessed through new ACPI methods
_LSI, _LSR, and _LSW (Label Storage {Info,Read,Write}), however support
for those is saved for a later patch series once the ACPICA enabling for
ACPI 6.2 lands in an immutable form in the acpi tree.

These updates pass a run through the nvdimm unit tests and an updated
version of the tests targeting the address-abstraction guid. This set is
based on the 'uuid-types' branch of git.infradead.org/users/hch/uuid.git
which includes Christoph's and Andy's revamp of the kernel's uuid + guid
helper routines.

[1]: http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf
[2]: http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf

---

Dan Williams (9):
      libnvdimm, label: add v1.2 nvdimm label definitions
      libnvdimm, label: add v1.2 interleave-set-cookie algorithm
      libnvdimm, label: honor the lba size specified in v1.2 labels
      libnvdimm, label: populate the type_guid property for v1.2 namespaces
      libnvdimm, label: populate 'isetcookie' for blk-aperture namespaces
      libnvdimm, label: update 'nlabel' and 'position' handling for local namespaces
      libnvdimm, label: add v1.2 label checksum support
      libnvdimm, label: add address abstraction identifiers
      libnvdimm, label: switch to using v1.2 labels by default


 drivers/acpi/nfit/core.c        |   67 +++++++++--
 drivers/nvdimm/btt_devs.c       |    8 +
 drivers/nvdimm/claim.c          |   28 ++++
 drivers/nvdimm/core.c           |    3 
 drivers/nvdimm/dax_devs.c       |    8 +
 drivers/nvdimm/label.c          |  244 +++++++++++++++++++++++++++++++++++----
 drivers/nvdimm/label.h          |   20 +++
 drivers/nvdimm/namespace_devs.c |  211 +++++++++++++++++++++++++++++-----
 drivers/nvdimm/nd.h             |   13 ++
 drivers/nvdimm/pfn_devs.c       |    8 +
 drivers/nvdimm/pmem.c           |    1 
 drivers/nvdimm/region_devs.c    |   43 ++++++-
 include/linux/libnvdimm.h       |    8 +
 include/linux/nd.h              |   12 ++
 14 files changed, 596 insertions(+), 78 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
