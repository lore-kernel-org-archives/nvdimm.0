Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDA8A21184E66
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:13:46 -0800 (PST)
Subject: [PATCH 00/11] Additional patches for nvdimm security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:13:45 -0700
Message-ID: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, zohar@linux.vnet.ibm.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series adds additional support for nvdimm security.
1. Converted logon keys to encrypted-keys.
2. Add overwrite DSM support
3. Add DSM 1.8 master passphrase support

The patch series is based off the branch from here:
https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/log/?h=for-5.0/nvdimm-security

Instead of squashing the previous changes, they are kept for history purposes
to document how we arrived to the current iteration.

Mimi,
Patch 1 requires your ack as it makes changes to encrypted-keys by adding
the nvdimm key format type. Dan wanted to restrict the key to 32bytes
during creation. I also wouldn't mind if you take a look at patch 2 and
make sure I'm providing correct usage of encrypted keys. Thank you!

---

Dave Jiang (11):
      keys-encrypted: add nvdimm key format type to encrypted keys
      libnvdimm/security: change clear text nvdimm keys to encrypted keys
      libnvdimm/security: add override module param for key self verification
      libnvdimm/security: introduce NDD_SECURITY_BUSY flag
      acpi/nfit, libnvdimm/security: Add security DSM overwrite support
      tools/testing/nvdimm: Add overwrite support for nfit_test
      libnvdimm/security: add overwrite status notification
      libnvdimm/security: add documentation for ovewrite
      acpi/nfit, libnvdimm/security: add Intel DSM 1.8 master passphrase support
      tools/testing/nvdimm: add Intel DSM 1.8 support for nfit_test
      acpi/nfit: prevent indiscriminate DSM payload dumping for security DSMs


 Documentation/nvdimm/security.txt        |   68 +++-
 drivers/acpi/nfit/Kconfig                |    7 
 drivers/acpi/nfit/core.c                 |   31 ++
 drivers/acpi/nfit/intel.c                |  245 +++++++++++++++
 drivers/acpi/nfit/intel.h                |   22 +
 drivers/acpi/nfit/nfit.h                 |    7 
 drivers/nvdimm/core.c                    |    3 
 drivers/nvdimm/dimm.c                    |    3 
 drivers/nvdimm/dimm_devs.c               |   50 +++
 drivers/nvdimm/nd-core.h                 |    9 -
 drivers/nvdimm/nd.h                      |   19 +
 drivers/nvdimm/region_devs.c             |    7 
 drivers/nvdimm/security.c                |  496 +++++++++++++++++-------------
 include/linux/libnvdimm.h                |   22 +
 security/keys/encrypted-keys/encrypted.c |   29 +-
 tools/testing/nvdimm/dimm_devs.c         |    2 
 tools/testing/nvdimm/test/nfit.c         |  141 +++++++++
 17 files changed, 895 insertions(+), 266 deletions(-)

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
