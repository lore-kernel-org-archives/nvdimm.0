Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0700321FB7D37
 for <linux-nvdimm@lists.01.org>; Mon,  2 Apr 2018 21:55:57 -0700 (PDT)
Subject: [PATCH 0/6] nfit, address-range-scrub: rework and fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 02 Apr 2018 21:46:01 -0700
Message-ID: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Given the fact that ARS can take 10s to 100s of seconds it is not
feasible to wait for ARS completion before publishing persistent memory
namespaces. Instead convert the ARS implementation to perform a short
ARS for critical errors, ones that caused a previous system reset,
before registering namespaces. Finally, arrange for all long ARS
operations to run in the background and populate the badblock lists at
run time.

While developing this rework a handful of cleanups and fixes also fell
out.

---

Dan Williams (6):
      nfit: fix region registration vs block-data-window ranges
      nfit, address-range-scrub: fix scrub in-progress reporting
      libnvdimm: add an api to cast a 'struct nd_region' to its 'struct device'
      nfit, address-range-scrub: introduce nfit_spa->ars_state
      nfit, address-range-scrub: rework and simplify ARS state machine
      nfit, address-range-scrub: add module option to skip initial ars


 drivers/acpi/nfit/core.c     |  443 ++++++++++++++++++------------------------
 drivers/acpi/nfit/nfit.h     |   13 +
 drivers/nvdimm/nd.h          |    1 
 drivers/nvdimm/region_devs.c |    8 +
 include/linux/libnvdimm.h    |    1 
 5 files changed, 213 insertions(+), 253 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
