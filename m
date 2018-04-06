Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B42B226FAA85
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 21:28:48 -0700 (PDT)
Subject: [ndctl PATCH v2 0/3] nfit, address-range-scrub: rework and fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 05 Apr 2018 21:18:51 -0700
Message-ID: <152298833162.13386.16059994933936258291.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1:
* Merge the cleanups and fixes with Dave's reviewed-by
* Rework acpi_nfit_query_poison() to be independent of the spa range
* Rework all acpi_nfit_query_poison() usage to call it once and then
  iterate the result buffer over all SPA ranges
* Make sure the implementation never attempts to scrub / register
  unknown SPA types
* Change no_init_ars to a bool type so it can be specified without an
  '=' character.

---

Given the fact that ARS can take 10s to 100s of seconds it is not
feasible to wait for ARS completion before publishing persistent memory
namespaces. Instead convert the ARS implementation to perform a short
ARS for critical errors, ones that caused a previous system reset,
before registering namespaces. Finally, arrange for all long ARS
operations to run in the background and populate the badblock lists at
run time.

---

Dan Williams (3):
      nfit, address-range-scrub: determine one platform max_ars value
      nfit, address-range-scrub: rework and simplify ARS state machine
      nfit, address-range-scrub: add module option to skip initial ars


 drivers/acpi/nfit/core.c |  542 ++++++++++++++++++++--------------------------
 drivers/acpi/nfit/nfit.h |    6 -
 2 files changed, 243 insertions(+), 305 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
