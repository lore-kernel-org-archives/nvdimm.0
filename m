Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36C9321159902
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 21:36:08 -0700 (PDT)
Subject: [PATCH 0/3] acpi, nfit: Add dirty shutdown count to sysfs
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Sep 2018 21:24:20 -0700
Message-ID: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The Intel NVDIMM command specification publishes a dirty-shutdown-count
in addition to the dirty-shutdown / flush-failed indication that comes
from the ACPI NFIT. This is expected to be a common property of NVDIMMs
and is a static hardware health detail to be cached / exported via
sysfs.

Add plumbing for retrieving this data at driver load time, publish the
count, and use the dynamically retrieved dirty-shutdown indicator to
augment the existing 'flush_failed' flag.

---

Dan Williams (3):
      acpi, nfit: Introduce nfit_mem flags
      acpi, nfit: Collect shutdown status
      tools/testing/nvdimm: Populate dirty shutdown data


 drivers/acpi/nfit/core.c              |  115 ++++++++++++++++++++++++++++-----
 drivers/acpi/nfit/intel.h             |   34 ++++++++++
 drivers/acpi/nfit/nfit.h              |   11 +++
 tools/testing/nvdimm/Kbuild           |    1 
 tools/testing/nvdimm/acpi_nfit_test.c |    8 ++
 tools/testing/nvdimm/test/nfit.c      |    3 +
 tools/testing/nvdimm/test/nfit_test.h |   24 -------
 7 files changed, 152 insertions(+), 44 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
