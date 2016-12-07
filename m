Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D567C81FCF
 for <linux-nvdimm@lists.01.org>; Tue,  6 Dec 2016 16:43:29 -0800 (PST)
Subject: [PATCH 0/5] acpi, nfit: acpi_nfit_ctl() corner case fixes + tests
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Dec 2016 16:39:20 -0800
Message-ID: <148107115997.25138.3445497812509173966.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

>>From [PATCH 5/5] tools/testing/nvdimm: unit test acpi_nfit_ctl():
---

A recent flurry of bug discoveries in the nfit driver's DSM marshalling
routine has highlighted the fact that we do not have unit test coverage
for this routine. Add a self-test of acpi_nfit_ctl() routine before
probing the "nfit_test.0" device. This mocks stimulus to acpi_nfit_ctl()
and if any of the tests fail "nfit_test.0" will be unavailable causing
the rest of the tests to not run / fail.
    
This unit test will also be a place to land reproductions of quirky
BIOS behavior discovered in the field and ensure the kernel does not
regress against implementations it has seen in practice.

---

The problems addressed in this round of fixes date are concentrated
around the variable-length output from the ARS (Address Range Scrub)
Status command, and the proper handling of per-command extended status
values.

They are urgent as improper handling of ARS commands can lead to a
platform that fails to boot. If there are media errors in the boot path
on a platform that does not support machine-check recovery we rely on
the ARS to inform the pmem driver which address ranges may trigger a
machine-check when read.

---

Dan Williams (4):
      acpi, nfit, libnvdimm: fix / harden ars_status output length handling
      acpi, nfit: validate ars_status output buffer size
      acpi, nfit: fix bus vs dimm confusion in xlat_status
      tools/testing/nvdimm: unit test acpi_nfit_ctl()

Vishal Verma (1):
      acpi, nfit: fix extended status translations for ACPI DSMs


 drivers/acpi/nfit/core.c              |   54 +++++---
 drivers/acpi/nfit/nfit.h              |    2 
 drivers/nvdimm/bus.c                  |   25 +++
 include/linux/libnvdimm.h             |    2 
 tools/testing/nvdimm/Kbuild           |    1 
 tools/testing/nvdimm/test/iomap.c     |   23 +++
 tools/testing/nvdimm/test/nfit.c      |  236 ++++++++++++++++++++++++++++++++-
 tools/testing/nvdimm/test/nfit_test.h |    8 +
 8 files changed, 324 insertions(+), 27 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
