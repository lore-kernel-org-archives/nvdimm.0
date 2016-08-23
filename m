Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4702B1A1E1E
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 14:56:35 -0700 (PDT)
Subject: [PATCH 0/3] acpi, nfit: nvdimm notification support + tests
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 14:54:11 -0700
Message-ID: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1 added an "NFIT Health Event Notification" for nvdimm devices.
When this fires, system software is expected to issue a DSM to retrieve
the latest health values.  For the NFIT driver this notification
arrives as an event on the sysfs 'flags' attribute for an nfit/nvdimm
device.  The 'flags' attribute reflects the "NVDIMM State Flags" of the
"5.2.25.3 NVDIMM Region Mapping Structure", and when read indicates if
the platform supports sending health events.

---

Dan Williams (3):
      tools/testing/nvdimm: unit test for acpi_nfit_notify()
      acpi, nfit: add dimm device notification support
      tools/testing/nvdimm: unit test for acpi_nvdimm_notify()


 drivers/acpi/nfit/core.c          |  112 ++++++++++++++++++++++++++++++++-----
 drivers/acpi/nfit/nfit.h          |    7 ++
 drivers/nvdimm/dimm_devs.c        |    6 ++
 include/linux/libnvdimm.h         |    1 
 tools/testing/nvdimm/Kbuild       |    1 
 tools/testing/nvdimm/test/iomap.c |   17 ++++++
 tools/testing/nvdimm/test/nfit.c  |   64 +++++++++++++++++++--
 7 files changed, 188 insertions(+), 20 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
