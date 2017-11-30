Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13E412034A79E
 for <linux-nvdimm@lists.01.org>; Thu, 30 Nov 2017 12:36:16 -0800 (PST)
From: Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 0/4] Teach EDAC driver about NVDIMMs
Date: Thu, 30 Nov 2017 12:40:38 -0800
Message-Id: <cover.1512070562.git.tony.luck@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-edac@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

A Skylake server may have some DIMM slots filled with NVDIMMs
instead of normal DDR4 DIMMs. These are enumerated differently
by the memory controller.

Sadly there isn't an easy way to just peek at some memory controller
register to find the size of these DIMMs, so we have to rely on the
NFIT and SMBIOS tables to get that information.

This series only tackles the topology function of the EDAC
driver.  A later series of patches will fix the address translation
parts so that errors in NVDIMMs will be reported correctly.

It's marked "RFC" because it depends on the new ACPCIA version 20171110
which has only just made it to Rafael's tree.

Some of you may only care about some of the parts that touch code you
maintain, but I copied you on all four because you might like to see
the bigger picture.

Tony Luck (4):
  acpi, nfit: Add function to look up nvdimm device and provide SMBIOS
    handle
  firmware: dmi: Add function to look up a handle and return DIMM size
  edac: Add new memory type for non-volatile DIMMs
  EDAC, skx_edac: Detect non-volatile DIMMs

 drivers/acpi/nfit/core.c     | 27 +++++++++++++++++++++
 drivers/edac/Kconfig         |  2 ++
 drivers/edac/edac_mc.c       |  1 +
 drivers/edac/edac_mc_sysfs.c |  3 ++-
 drivers/edac/skx_edac.c      | 56 ++++++++++++++++++++++++++++++++++++++++----
 drivers/firmware/dmi_scan.c  | 29 +++++++++++++++++++++++
 include/acpi/nfit.h          | 19 +++++++++++++++
 include/linux/dmi.h          |  2 ++
 include/linux/edac.h         |  3 +++
 9 files changed, 136 insertions(+), 6 deletions(-)
 create mode 100644 include/acpi/nfit.h


base-commit: 3fc70f8be59950ee2deecefdddb68be19b8cddd1
-- 
2.14.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
