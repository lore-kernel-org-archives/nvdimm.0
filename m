Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8572B21A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 14:34:46 -0700 (PDT)
Subject: [PATCH 0/3] dynamic_hex_dump cleanup
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 14:28:53 -0700
Message-ID: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-acpi@vger.kernel.org, Jason Baron <jbaron@akamai.com>
List-ID: <linux-nvdimm@lists.01.org>

More than one driver has worked around the fact that
print_hex_dump_debug() requires CONFIG_DYNAMIC_DEBUG=y to build. Provide
a dynamic_hex_dump() so that drivers that want the extra debugging to be
turned off in the CONFIG_DYNAMIC_DEBUG=n can use dynamic_hex_dump()
directly.

I'm fine to carry this whole set through nvdimm.git if no one sees any
issues.

---

Dan Williams (3):
      printk: provide generic dynamic_hex_dump fallback
      virtio, rpmsg: switch to dynamic_hex_dump()
      acpi, nfit: kill ACPI_NFIT_DEBUG, switch to dynamic_hex_dump()


 drivers/acpi/nfit/Kconfig        |   12 ------------
 drivers/acpi/nfit/core.c         |   21 ++++++++-------------
 drivers/rpmsg/virtio_rpmsg_bus.c |    6 ------
 include/linux/dynamic_debug.h    |    6 ++++++
 4 files changed, 14 insertions(+), 31 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
