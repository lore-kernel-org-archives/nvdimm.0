Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A8DE1A1E56
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 18:31:51 -0700 (PDT)
Subject: [PATCH 0/2] nfit: fail DSMs that return an unknown status value
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Sep 2016 18:28:47 -0700
Message-ID: <147381652762.13555.2547727388390513900.stgit@dwillia2-desk3.amr.corp.intel.com>
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

When the kernel knows the format of a DSM and is consuming the data
internal to the kernel, it needs to be careful to fail DSMs that return
an error.  Recall that DSMs, ACPI Device Specific Methods, are used by
the kernel to manipulate namespace label data, and scan for media
errors.  For example, if a namespace label read command fails the
returned data is undefined and should not be consumed by the libnvdimm
core to make namespace provisioning decisions.

Also, add new unit test capability to allow dynamic failure injection
for DSMs sent to nfit_test devices.

---

Dan Williams (2):
      nfit: fail DSMs that return non-zero status by default
      tools/testing/nvdimm: test get_config_size DSM failures


 drivers/acpi/nfit/core.c         |   48 +++++++++++++----------
 tools/testing/nvdimm/test/nfit.c |   79 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 105 insertions(+), 22 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
