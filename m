Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 0/3] ACPI 6.1 NFIT Compatibility
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 08 Feb 2016 10:30:53 -0800
Message-ID: <20160208183052.27820.68922.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The latest NFIT specification clarifies that a memory device will have a
control region table per function interface.  Without the fix in [PATCH
1/3] Linux will miscount the number of DIMMs and fail to load the
driver.  The fix is tagged for -stable on the expectation that ACPI 6.1
compatible systems will overlap current -stable development branches.

The latter two patches in the series are verification tests that can be
integrated for 4.6.

---

Dan Williams (3):
      nfit: fix multi-interface dimm handling, acpi6.1 compatibility
      nfit, tools/testing/nvdimm: add format interface code definitions
      nfit, tools/testing/nvdimm: test multiple control regions per-dimm


 drivers/acpi/nfit.c              |   71 +++++++++++-----------
 drivers/acpi/nfit.h              |    6 ++
 tools/testing/nvdimm/test/nfit.c |  125 ++++++++++++++++++++++++++++++--------
 3 files changed, 141 insertions(+), 61 deletions(-)
