Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E638F20945528
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 11:36:15 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 0/2] NVDIMM memory error notification support 
Date: Thu,  8 Jun 2017 12:36:56 -0600
Message-Id: <20170608183658.24731-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.2 defines a new ACPI notification value to NVDIMM Root Device.
This allows BIOS to inform the OS that new uncorrectable memory error
is detected during run-time.

This patch-set adds support of this notification, which starts ARS and
updates badblocks information to prevent the OS from consuming the new
error.

v2:
 - Set flags Bit[1] for Start ARS. (Dan Williams)

Link: http://www.uefi.org/sites/default/files/resources/ACPI_6_2.pdf
---
Toshi Kani (2):
  1/2 acpi/nfit: Add support of NVDIMM memory error notification in ACPI 6.2
  2/2 acpi/nfit: Issue Start ARS to retrieve existing records

---
 drivers/acpi/nfit/core.c   | 40 ++++++++++++++++++++++++++++++++--------
 drivers/acpi/nfit/mce.c    |  2 +-
 drivers/acpi/nfit/nfit.h   |  4 +++-
 include/uapi/linux/ndctl.h |  1 +
 4 files changed, 37 insertions(+), 10 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
