Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4ECD21BADAB2
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 13:58:31 -0700 (PDT)
Subject: [PATCH v6 00/11] Adding security support for nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 25 Jul 2018 13:58:30 -0700
Message-ID: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements security support for nvdimm. Mostly adding
new security DSM support from the Intel NVDIMM DSM spec v1.7, but also
adding generic support libnvdimm for other vendors. The most important
security features are unlocking locked nvdimms, and updating/setting security
passphrase to nvdimms.

Security folks, thanks in advance for taking a look at my key management
implementation and making sure that I'm doing something sane. Mainly you'll
want to review patches 2, 4, and 5 as most relevant ones that need scrutiny.

v6:
- Fix intel DSM data structures to use defined size for passphrase (Robert)
- Fix memcpy size to use sizeof data structure member (Robert)
- Fix defined dimm id length (Robert)
- Making intel_security_ops const (Eric)
- Remove unused var in nvdimm_key_search() (Eric)
- Added wbinvd before secure erase is issued (Robert)
- Removed key_put_sync() usage (David)
- Use init_cred instead of creating own cred (David)
    - Exported init_cred symbol
- Move keyring to dedicated (David)
- Use logon_key_type and friends instead of creating custom (David)
- Use key_lookup() with stored key serial (David)
    - Exported key_lookup() symbol
- Mark passed in key data as const (David)
- Added comment for change_pass_phrase to explain how it works (David)
- Unlink key when it's being removed from keyring. (David)
- Removed request_key() from all security ops except update and unlock.
- Update will now update the existing key's payload with the new key's
  retrieved from userspace when the new payload is accepted by nvdimm.

v5:
- Moved dimm_id initialization (Dan)
- Added a key_put_sync() in order to run key_gc_work and cleanup old key. (Dan)
- Added check to block security state changes while DIMM is active. (Dan)

v4:
- flip payload layout for update passphrase to make it easier on userland.

v3:
- Set x86 wrappers for x86 only bits. (Dan)
- Fixed up some verbiage in commit headers.
- Put in usage of sysfs_streq() for sysfs inputs.
- 0-day build fixes for non-x86 archs.

v2:
- Move inclusion of intel.h to relevant source files and not in nfit.h. (Dan)
- Moved security ring relevant code to dimm_devs.c. (Dan)
- Added dimm_id to nfit_mem to avoid recreate per sysfs show call. (Dan)
- Added routine to return security_ops based on family supplied. (Dan)
- Added nvdimm_key_data struct to wrap raw passphrase string. (Dan)
- Allocate firmware package on stack. (Dan)
- Added missing frozen state detection when retrieving security state.

---

Dave Jiang (11):
      nfit: add support for Intel DSM 1.7 commands
      libnvdimm: create keyring to store security keys
      nfit/libnvdimm: store dimm id as a member to struct nvdimm
      nfit/libnvdimm: add unlock of nvdimm support for Intel DIMMs
      nfit/libnvdimm: add set passphrase support for Intel nvdimms
      nfit/libnvdimm: add disable passphrase support to Intel nvdimm.
      nfit/libnvdimm: add freeze security support to Intel nvdimm
      nfit/libnvdimm: add support for issue secure erase DSM to Intel nvdimm
      nfit_test: add context to dimm_dev for nfit_test
      nfit_test: add test support for Intel nvdimm security DSMs
      libnvdimm: add documentation for nvdimm security support


 Documentation/nvdimm/security    |   70 +++++++
 drivers/acpi/nfit/Makefile       |    1 
 drivers/acpi/nfit/core.c         |   58 ++++--
 drivers/acpi/nfit/intel.c        |  382 +++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h        |   82 ++++++++
 drivers/acpi/nfit/nfit.h         |   20 ++
 drivers/nvdimm/bus.c             |    2 
 drivers/nvdimm/core.c            |    7 +
 drivers/nvdimm/dimm.c            |    7 +
 drivers/nvdimm/dimm_devs.c       |  397 ++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h         |    6 +
 drivers/nvdimm/nd.h              |    2 
 include/linux/libnvdimm.h        |   42 ++++
 kernel/cred.c                    |    1 
 security/keys/key.c              |    1 
 tools/testing/nvdimm/Kbuild      |    1 
 tools/testing/nvdimm/test/nfit.c |  227 ++++++++++++++++++++--
 17 files changed, 1272 insertions(+), 34 deletions(-)
 create mode 100644 Documentation/nvdimm/security
 create mode 100644 drivers/acpi/nfit/intel.c
 create mode 100644 drivers/acpi/nfit/intel.h

--
Signature
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
