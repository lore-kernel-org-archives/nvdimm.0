Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EED7321F3B412
 for <linux-nvdimm@lists.01.org>; Sun, 29 Oct 2017 12:51:42 -0700 (PDT)
Subject: [PATCH 0/2] acpi, nfit: support for new NVDIMM_FAMILY_INTEL commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 29 Oct 2017 12:49:07 -0700
Message-ID: <150930654766.21067.7295669798909000270.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The latest version of the NVDIMM_FAMILY_INTEL command set adds support
for firmware updates and setting SMART health alarms / thresholds among
other things. Given that these are command payloads that will only ever
be issued by userspace we only wire up the command numbers and revision
ids for use through the ND_CMD_CALL interface.

---

Dan Williams (2):
      acpi, nfit: hide unknown commands from nmemX/commands
      acpi, nfit: add support for NVDIMM_FAMILY_INTEL v1.6 DSMs


 drivers/acpi/nfit/core.c |   63 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/acpi/nfit/nfit.h |   19 +++++++++++++-
 2 files changed, 74 insertions(+), 8 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
