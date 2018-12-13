Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E42F4211A1E36
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 08:48:22 -0800 (PST)
Subject: [PATCH v14 00/17] Adding security support for nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 13 Dec 2018 09:48:21 -0700
Message-ID: <154471935968.55644.4424661179787827497.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements security support for nvdimm based on Intel
DSM spec v1.8. The passphrase is protected by encrypted-key and managed
through the kernel key management framework. The security features
supported are security state show, passphrase enable/update, passphrase
disable, crypto erase, overwrite, and master passphrase enable/update and
erase. Instead of allowing the security DSMs being issued via ioctl, the
features are managed through a sysfs attribute that accept the relevant
keyid for the encrypted-key(s).

v14:
- Cleanup security_store input parsing. (Dan)
- Move overwrite query to system workqueue. (Dan)
- Add code to cleanup work items on nvdimm removal. (Dan)
- Add nvdimm bus locking for overwrite query. (Dan)
- Make parameter to determine passphrase type an enum. (Dan)
- Remove master passphrase states and reuse existing states. (Dan)
- Cleanup C99 initialization. (Dan)
- Fix typos and grammar errors in documentation. (Jing)

v13:
- Rebased to v4.20-rc5 and combined/squashed various patches from the two
  patch series. Various cleanups from Dan. (Mimi)
- Change encrypted-key nvdimm key format to enc32 key format to make it
  generic for future usages. (Dan)
- Output error code for nvdimm_setup_security_events() failure. (Robert)
- Make nfit_test output consistent. (Robert)

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

Dan Williams (1):
      acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs

Dave Jiang (16):
      acpi/nfit: Add support for Intel DSM 1.8 commands
      acpi/nfit, libnvdimm: Store dimm id as a member to struct nvdimm
      keys: Export lookup_user_key to external users
      keys-encrypted: add nvdimm key format type to encrypted keys
      acpi/nfit, libnvdimm: Introduce nvdimm_security_ops
      acpi/nfit, libnvdimm: Add freeze security support to Intel nvdimm
      acpi/nfit, libnvdimm: Add disable passphrase support to Intel nvdimm.
      acpi/nfit, libnvdimm: Add enable/update passphrase support for Intel nvdimms
      acpi/nfit, libnvdimm: Add support for issue secure erase DSM to Intel nvdimm
      libnvdimm/security: introduce NDD_SECURITY_BUSY flag
      acpi/nfit, libnvdimm/security: Add security DSM overwrite support
      acpi/nfit, libnvdimm/security: add Intel DSM 1.8 master passphrase support
      tools/testing/nvdimm: Add test support for Intel nvdimm security DSMs
      tools/testing/nvdimm: Add overwrite support for nfit_test
      tools/testing/nvdimm: add Intel DSM 1.8 support for nfit_test
      libnvdimm/security: Add documentation for nvdimm security support


 Documentation/nvdimm/security.txt                 |  141 ++++++
 Documentation/security/keys/trusted-encrypted.rst |    6 
 drivers/acpi/nfit/Kconfig                         |   11 +
 drivers/acpi/nfit/Makefile                        |    1 
 drivers/acpi/nfit/core.c                          |   93 ++++
 drivers/acpi/nfit/intel.c                         |  388 ++++++++++++++++++
 drivers/acpi/nfit/intel.h                         |   76 ++++
 drivers/acpi/nfit/nfit.h                          |   25 +
 drivers/nvdimm/Kconfig                            |    4 
 drivers/nvdimm/Makefile                           |    1 
 drivers/nvdimm/bus.c                              |   22 +
 drivers/nvdimm/dimm.c                             |   16 +
 drivers/nvdimm/dimm_devs.c                        |  205 +++++++++
 drivers/nvdimm/nd-core.h                          |   29 +
 drivers/nvdimm/nd.h                               |    8 
 drivers/nvdimm/region_devs.c                      |    5 
 drivers/nvdimm/security.c                         |  456 +++++++++++++++++++++
 include/linux/key.h                               |    3 
 include/linux/libnvdimm.h                         |   75 +++
 security/keys/encrypted-keys/encrypted.c          |   29 +
 security/keys/internal.h                          |    2 
 security/keys/process_keys.c                      |    1 
 tools/testing/nvdimm/Kbuild                       |    3 
 tools/testing/nvdimm/dimm_devs.c                  |   41 ++
 tools/testing/nvdimm/test/nfit.c                  |  321 +++++++++++++++
 25 files changed, 1919 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/nvdimm/security.txt
 create mode 100644 drivers/acpi/nfit/intel.c
 create mode 100644 drivers/nvdimm/security.c
 create mode 100644 tools/testing/nvdimm/dimm_devs.c

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
