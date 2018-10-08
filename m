Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A916A21A07A92
 for <linux-nvdimm@lists.01.org>; Mon,  8 Oct 2018 16:55:30 -0700 (PDT)
Subject: [PATCH v12 00/12] Adding security support for nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 08 Oct 2018 16:55:29 -0700
Message-ID: <153904272246.60070.6230977215877367778.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements security support for nvdimm. Mostly adding
new security DSM support from the Intel NVDIMM DSM spec v1.7, but also
adding generic support libnvdimm for other vendors. The most important
security features are unlocking locked nvdimms, and updating/setting security
passphrase to nvdimms.

v12:
- Add a mutex for the cached key and remove key_get/key_put messiness (Dan)
- Move security code to its own C file and wrap under CONFIG_NVDIMM_SECURITY
  in order to fix issue reported by 0-day build without CONFIG_KEYS.

v11:
- Dropped keyring usage. (David)
- Fixed up scanf handling. (David)
- Removed callout info for request_key(). (David)
- Included Dan's patches and folded in some changes from Dan. (Dan)
- Made security_show a weak function to allow test override. (Dan)

v10:
- Change usage of strcmp to sysfs_streq. (Dan)
- Lock nvdimm bus when doing secure erase. (Dan)
- Change dev_info to dev_dbg for dimm unlocked success output. (Dan)

v9:
- Addressed various misc comments. (David, Dan)
- Removed init_cred and replaced with current_cred(). (David)
- Changed NVDIMM_PREFIX to char[] constant (David)
- Moved NVDIMM_PREFIX to include/uapi/linux/ndctl.h (Dan)
- Reworked security_update to use old user key to verify against kernel
  key and then update with new user key. (David)
- Added requirement of disable and erase to require old user key for
  verify. (Dan)
- Updated documentation. (Dave)

v8:
- Make the keys retained by the kernel user searchable in order to find the
  key that needs to be updated for key update.

v7:
- Add CONFIG_KEYS depenency for libnvdimm. (Alison)
- Export lookup_user_key(). (David)
- Modified "update" to take two key ids and and use lookup_user_key() in
  order to improve security.  (David)
- Use key ptrs and key_validate() for cached keys. (David)

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

Dan Williams (2):
      libnvdimm: Drop nvdimm_bus from security_ops interface
      acpi, nfit: Move acpi_nfit_get_security_ops() to generic location

Dave Jiang (10):
      nfit: add support for Intel DSM 1.7 commands
      nfit/libnvdimm: store dimm id as a member to struct nvdimm
      keys: export lookup_user_key to external users
      nfit/libnvdimm: add unlock of nvdimm support for Intel DIMMs
      nfit/libnvdimm: add set passphrase support for Intel nvdimms
      nfit/libnvdimm: add disable passphrase support to Intel nvdimm.
      nfit/libnvdimm: add freeze security support to Intel nvdimm
      nfit/libnvdimm: add support for issue secure erase DSM to Intel nvdimm
      nfit_test: add test support for Intel nvdimm security DSMs
      libnvdimm: add documentation for nvdimm security support


 Documentation/nvdimm/security.txt   |   99 +++++++
 drivers/acpi/nfit/Makefile          |    1 
 drivers/acpi/nfit/core.c            |   68 ++++-
 drivers/acpi/nfit/intel.c           |  369 ++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h           |   70 +++++
 drivers/acpi/nfit/nfit.h            |   20 +-
 drivers/nvdimm/Kconfig              |    5 
 drivers/nvdimm/Makefile             |    1 
 drivers/nvdimm/bus.c                |    8 +
 drivers/nvdimm/dimm.c               |    7 +
 drivers/nvdimm/dimm_devs.c          |   89 +++++++
 drivers/nvdimm/dimm_devs_security.c |  463 +++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h            |    6 
 drivers/nvdimm/nd.h                 |   51 ++++
 include/linux/key.h                 |    3 
 include/linux/libnvdimm.h           |   46 +++
 include/uapi/linux/ndctl.h          |    6 
 security/keys/internal.h            |    2 
 security/keys/process_keys.c        |    1 
 tools/testing/nvdimm/Kbuild         |    3 
 tools/testing/nvdimm/dimm_devs.c    |   39 +++
 tools/testing/nvdimm/test/nfit.c    |  185 ++++++++++++++
 22 files changed, 1522 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/nvdimm/security.txt
 create mode 100644 drivers/acpi/nfit/intel.c
 create mode 100644 drivers/acpi/nfit/intel.h
 create mode 100644 drivers/nvdimm/dimm_devs_security.c
 create mode 100644 tools/testing/nvdimm/dimm_devs.c

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
