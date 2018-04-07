Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4487B226516A2
 for <linux-nvdimm@lists.01.org>; Sat,  7 Apr 2018 08:55:48 -0700 (PDT)
Subject: [PATCH v3 0/3] nfit, address-range-scrub: rework and fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 07 Apr 2018 08:45:52 -0700
Message-ID: <152311595210.35426.13667585208560808244.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Changes since v2 [1]:
* Handle -EAGAIN (no result) ars_status responses

---

Given the fact that ARS can take 10s to 100s of seconds it is not
feasible to wait for ARS completion before publishing persistent memory
namespaces. Instead convert the ARS implementation to perform a short
ARS for critical errors, ones that caused a previous system reset,
before registering namespaces. Finally, arrange for all long ARS
operations to run in the background and populate the badblock lists at
run time.

In the extreme situation that an implementation is unable to return
sufficient results in a short scan and the system encounters media
errors that machine check recovery does not handle, an administrator can
arrange to wait for a full ARS scan by doing the following:

1/ Boot with "modprobe.blacklist=nd_pmem" to stop pmem namespaces from
   starting automatically

2/ Call "ndctl wait-scrub" to wait for the OS or BIOS initiated ARS to complete

3/ Manually start up namespaces with the up to date error list
   "modprobe nd_pmem"

---

Dan Williams (3):
      nfit, address-range-scrub: determine one platform max_ars value
      nfit, address-range-scrub: rework and simplify ARS state machine
      nfit, address-range-scrub: add module option to skip initial ars


 drivers/acpi/nfit/core.c |  557 +++++++++++++++++++++-------------------------
 drivers/acpi/nfit/nfit.h |    6 
 2 files changed, 261 insertions(+), 302 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
