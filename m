Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69C552194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 10:03:55 -0700 (PDT)
Subject: [PATCH 0/5] libnvdimm: acpi updates and a revert
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 09:58:11 -0700
Message-ID: <149218909065.3926.1234846095650907678.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With Dave's recent fix [1], we can restore error clearing for btt i/o in
4.12.

ACPI 6.1 introduced new health state flags. Beyond reflecting them in
the dimmX/flags sysfs attribute we also need to handle the deeper
implications of the ACPI_NFIT_MEM_MAP_FAILED flag which changes
assumptions on how the driver discovers dimms. In the "map failed" case
there may missing or no SPA entries associated with a dimm. Those dimms
should still be registered with libnvdimm so that the error state can be
communicated and recovery attempted.

[1]: https://patchwork.kernel.org/patch/9680035/

---

Dan Williams (5):
      Revert "libnvdimm: band aid btt vs clear poison locking"
      acpi, nfit: add support for acpi 6.1 dimm state flags
      tools/testing/nvdimm: test acpi 6.1 health state flags
      acpi, nfit: support "map failed" dimms
      acpi, nfit: limit ->flush_probe() to initialization work


 drivers/acpi/nfit/core.c         |   61 +++++++++++++++++++++++++++++++-------
 drivers/acpi/nfit/nfit.h         |    1 +
 drivers/nvdimm/claim.c           |   10 +-----
 tools/testing/nvdimm/test/nfit.c |   40 +++++++++++++++++++++++--
 4 files changed, 88 insertions(+), 24 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
