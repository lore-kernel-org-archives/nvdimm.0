Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 295E121109FF6
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 17:47:11 -0700 (PDT)
Subject: [PATCH 0/3] libvdimm: Support namespace enumeration while locked
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jun 2018 17:37:14 -0700
Message-ID: <152902303439.10541.13027910074116606464.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The NVDIMM_FAMILY_INTEL DSM path for manipulating labels explicitly
allows reading the namespace label area while the DIMM is locked. In
contrast the ACPI _LSR method for reading labels only indicates if the
label area is locked and returns no data.

It naturally follows that if the namespace label area is locked, the
DIMM is locked since the driver is prevented from discovering namespace
boundaries.

On platforms where both mechanisms are available, prefer the
NVDIMM_FAMILY_INTEL implementation and support enumerating namespace
boundaries while the DIMM is locked.

In addition to ACPI capability detection and the libnvdimm core change
to fail probe of locked namespaces, provide a capability to inject this
semantic difference via nfit_test.

---

Dan Williams (3):
      libnvdimm: Introduce locked DIMM capacity support
      acpi, nfit: Prefer _DSM over _LSR for namespace label reads
      tools/testing/nvdimm: Make DSM failure code injection an override


 drivers/acpi/nfit/core.c         |   12 +++++++++
 drivers/nvdimm/dimm.c            |   24 +++++++++++++++++--
 drivers/nvdimm/namespace_devs.c  |   23 ++++++++++++++++++
 drivers/nvdimm/nd.h              |    1 +
 tools/testing/nvdimm/test/nfit.c |   49 +++++++++++++++++++++++++-------------
 5 files changed, 89 insertions(+), 20 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
