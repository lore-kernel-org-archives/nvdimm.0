Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1521D224DD133
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 15:30:22 -0700 (PDT)
Subject: [PATCH 0/4] Adding support to parse BERT for libnvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 29 Mar 2018 15:37:01 -0700
Message-ID: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, tony.luck@intel.com, rjw@rjwysocki.net, lenb@kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements support for parsing of the BERT records
and adding the error memory ranges to nvdimm badblocks in order for the
kernel to avoid prevent the kernel from accessing those areas. And with
the addition of this support, we can surface the nd regions instead of waiting
for ARS to complete. So the ARS handling is reworked to run in the
background and not block nd region registration.

---

Dave Jiang (4):
      acpi: add find error record in BERT function
      acpi/libnvdimm: search through BERT records and add to nvdimm badblocks
      acpi/nfit: removing ARS timeout and change scrubbing to delayed work
      acpi/nfit: allow knob to disable ARS being issued at kernel boot


 drivers/acpi/apei/bert.c  |  137 +++++++++++++++++++++---
 drivers/acpi/nfit/core.c  |  262 ++++++++++++++++++++-------------------------
 drivers/acpi/nfit/nfit.h  |   13 ++
 drivers/nvdimm/core.c     |    6 +
 include/linux/acpi.h      |   10 ++
 include/linux/libnvdimm.h |    1 
 6 files changed, 271 insertions(+), 158 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
