Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6997320359E80
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:39:08 -0700 (PDT)
Subject: [PATCH 00/11] Adding security support for nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 02 Jul 2018 16:39:07 -0700
Message-ID: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, alison.schofield@intel.com, keyrings@vger.kernel.org, keescook@chromium.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements security support for nvdimm. Mostly adding
new security DSM support from the Intel NVDIMM DSM spec v1.7, but also
adding generic support libnvdimm for other vendors. The most important
security features are unlocking locked nvdimms, and updating/setting security
passphrase to nvdimms.

Security folks, thanks in advance for taking a look at my key management
implementation and making sure that I'm doing something sane. Mainly you'll
want to review patches 2, 4, and 5 as most relevant ones that need scrutiny.

---

Dave Jiang (11):
      nfit: adding support for Intel DSM 1.7 commands
      libnvdimm: create keyring to store security keys
      nfit/libnvdimm: store dimm id as a member to struct nvdimm
      nfit/libnvdimm: add unlock of nvdimm support for Intel DIMMs
      nfit/libnvdimm: add set passphrase support for Intel nvdimms
      nfit/libnvdimm: add disable passphrase support to Intel nvdimm.
      nfit/libnvdimm: add freeze security support to Intel nvdimm
      nfit/libnvdimm: add support for issue secure erase DSM to Intel nvdimm
      nfit_test: adding context to dimm_dev for nfit_test
      nfit_test: adding test support for Intel nvdimm security DSMs
      libnvdimm: adding documentation for nvdimm security support


 Documentation/nvdimm/security    |   70 ++++++++
 drivers/acpi/nfit/Makefile       |    2 
 drivers/acpi/nfit/core.c         |   61 +++++--
 drivers/acpi/nfit/intel.c        |  348 ++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h        |  104 +++++++++++
 drivers/acpi/nfit/nfit.h         |   24 ---
 drivers/nvdimm/bus.c             |    2 
 drivers/nvdimm/dimm.c            |   97 +++++++++++
 drivers/nvdimm/dimm_devs.c       |  332 ++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h         |    4 
 drivers/nvdimm/nd.h              |    2 
 include/linux/libnvdimm.h        |   35 ++++
 tools/testing/nvdimm/Kbuild      |    1 
 tools/testing/nvdimm/test/nfit.c |  226 +++++++++++++++++++++++--
 14 files changed, 1254 insertions(+), 54 deletions(-)
 create mode 100644 Documentation/nvdimm/security
 create mode 100644 drivers/acpi/nfit/intel.c
 create mode 100644 drivers/acpi/nfit/intel.h

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
