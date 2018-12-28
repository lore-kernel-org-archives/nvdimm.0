Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95B59211A1E4D
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 21:04:30 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm for 4.21
Date: Fri, 28 Dec 2018 05:04:27 +0000
Message-ID: <4880b31d0d32c38a675048be903814a062907125.camel@intel.com>
Content-Language: en-US
Content-ID: <976809911326ED40870ABAB033F3CB69@intel.com>
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.21

...to receive the libnvdimm update for 4.21.

The vast bulk of this update is the new support for the security
capabilities of some nvdimms. It was rebased at the end of last week to
remove randconfig breakage detected in -next. It has since appeared in
subsequent -next releases with no reported issues. The userspace
tooling for this capability is still a work in progress, but the
changes survive the existing libnvdimm unit tests. The changes also
pass manual checkout on hardware and the new nfit_test emulation of the
security capability.

The touches of the security/keys/ files have received the necessary
acks from Mimi and David. Those changes were necessary to allow for a
new generic encrypted-key type, and allow the nvdimm sub-system to
lookup key material referenced by the libnvdimm-sysfs interface.

---

The following changes since commit 40e020c129cfc991e8ab4736d2665351ffd1468d:

  Linux 4.20-rc6 (2018-12-09 15:31:00 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.21

for you to fetch changes up to 4b5f747e82b12b6d8ab815fc259827a615c7f2c3:

  Merge miscellaneous libnvdimm updates for 4.21 (2018-12-27 19:54:10 -0800)

----------------------------------------------------------------
libnvdimm for 4.21

* Add support for the security features of nvdimm devices that
  implement a security model similar to ATA hard drive security. The
  security model supports locking access to the media at
  device-power-loss, to be unlocked with a passphrase, and secure-erase
  (crypto-scramble).

  Unlike the ATA security case where the kernel expects device
  security to be managed in a pre-OS environment, the libnvdimm security
  implementation allows key provisioning and key-operations at OS
  runtime. Keys are managed with the kernel's encrypted-keys facility to
  provide data-at-rest security for the libnvdimm key material. The
  usage model mirrors fscrypt key management, but is driven via
  libnvdimm sysfs.

* Miscellaneous updates for api usage and comment fixes.

----------------------------------------------------------------
Andy Shevchenko (2):
      libnvdimm, label: Switch to bitmap_zalloc()
      libnvdimm, namespace: Replace kmemdup() with kstrndup()

Dan Williams (2):
      libnvdimm/security: Quiet security operations
      Merge miscellaneous libnvdimm updates for 4.21

Dave Jiang (16):
      acpi/nfit: Add support for Intel DSM 1.8 commands
      acpi/nfit, libnvdimm: Store dimm id as a member to struct nvdimm
      keys: Export lookup_user_key to external users
      keys-encrypted: add nvdimm key format type to encrypted keys
      acpi/nfit, libnvdimm: Introduce nvdimm_security_ops
      acpi/nfit, libnvdimm: Add freeze security support to Intel nvdimm
      acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs
      acpi/nfit, libnvdimm: Add disable passphrase support to Intel nvdimm.
      acpi/nfit, libnvdimm: Add enable/update passphrase support for Intel nvdimms
      acpi/nfit, libnvdimm: Add support for issue secure erase DSM to Intel nvdimm
      acpi/nfit, libnvdimm/security: Add security DSM overwrite support
      acpi/nfit, libnvdimm/security: add Intel DSM 1.8 master passphrase support
      tools/testing/nvdimm: Add test support for Intel nvdimm security DSMs
      tools/testing/nvdimm: Add overwrite support for nfit_test
      tools/testing/nvdimm: add Intel DSM 1.8 support for nfit_test
      libnvdimm/security: Add documentation for nvdimm security support

Ocean He (2):
      libnvdimm, bus: Check id immediately following ida_simple_get
      ACPI/nfit: Adjust annotation for why return 0 if fail to find NFIT at start

 Documentation/nvdimm/security.txt                 | 141 +++++++
 Documentation/security/keys/trusted-encrypted.rst |   6 +-
 drivers/acpi/nfit/Kconfig                         |  11 +
 drivers/acpi/nfit/Makefile                        |   1 +
 drivers/acpi/nfit/core.c                          | 103 ++++-
 drivers/acpi/nfit/intel.c                         | 388 ++++++++++++++++++
 drivers/acpi/nfit/intel.h                         |  76 ++++
 drivers/acpi/nfit/nfit.h                          |  24 +-
 drivers/nvdimm/Kconfig                            |   5 +
 drivers/nvdimm/Makefile                           |   1 +
 drivers/nvdimm/bus.c                              |  33 +-
 drivers/nvdimm/dimm.c                             |  16 +-
 drivers/nvdimm/dimm_devs.c                        | 210 +++++++++-
 drivers/nvdimm/label.c                            |   7 +-
 drivers/nvdimm/namespace_devs.c                   |   3 +-
 drivers/nvdimm/nd-core.h                          |  57 +++
 drivers/nvdimm/nd.h                               |   8 +
 drivers/nvdimm/region_devs.c                      |   5 +
 drivers/nvdimm/security.c                         | 454 ++++++++++++++++++++++
 include/linux/key.h                               |   3 +
 include/linux/libnvdimm.h                         |  76 +++-
 security/keys/encrypted-keys/encrypted.c          |  29 +-
 security/keys/internal.h                          |   2 -
 security/keys/process_keys.c                      |   1 +
 tools/testing/nvdimm/Kbuild                       |   3 +
 tools/testing/nvdimm/dimm_devs.c                  |  41 ++
 tools/testing/nvdimm/test/nfit.c                  | 321 +++++++++++++++
 27 files changed, 1971 insertions(+), 54 deletions(-)
 create mode 100644 Documentation/nvdimm/security.txt
 create mode 100644 drivers/acpi/nfit/intel.c
 create mode 100644 drivers/nvdimm/security.c
 create mode 100644 tools/testing/nvdimm/dimm_devs.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
