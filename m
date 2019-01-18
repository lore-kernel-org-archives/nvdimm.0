Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB278211B509C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:38:23 -0800 (PST)
Subject: [PATCH v9 00/13] ndctl: add security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Jan 2019 19:38:22 -0700
Message-ID: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements mechanisms that utilize the sysfs knobs
provided by the kernel in order to support the Intel DSM v1.8 spec
that provides security to NVDIMM. The following abilities are added:
1. display security state
2. enable/update passphrase
3. disable passphrase
4. freeze security
5. secure erase
6. overwrite
7. master passphrase enable/update

v9:
- Add install-encrypt-key command. (Dan)
- Change enable-passphrase to setup-passphrase. (Dan)
- Change disable-passphrase to remove-passphrase. (Dan)
- Change ndctl_dimm_get_security() to return state directly and remove
  ndctl_dimm_security_supported(). (Dan)
- Remove ND_SECURITY_UNSUPPORTED state
- change ND_SECURITY_* to NDCTL_SECURITY_*
- Fix man page issues (Dan, Jane)
- Define NDCTL_KEYSDIR in config.h (Dan)
- Break check_key_run_and_discard() to 3 helper functions. (Dan)
- Remove key path input parameter. (Dan)
- Remove master key input parameter. (Dan)
- Fixup various issues in security unit test script. (Vishal)

v8:
- Additional cleanup on test script. (Vishal)
- Change load-keys script into internal command for ndctl. (Dan)

v7:
- Added option to provide path to key directory. (Vishal)
- Cleaned up shell scripts. (Vishal)
- Cleaned up documentation. (Vishal)
- Addressed various comments from Vishal.

v6:
- Fix spelling and grammar errors for documentation. (Jing)
- Change bool for indicate master passphrase and old passphrase to enum.
- Fix key load script master key name.
- Update to match v15 of kernel patch series.

v5:
- Updated to match latest kernel interface (encrypted keys)
- Added overwrite support
- Added support for DSM v1.8 master passphrase operations
- Removed upcall related code
- Moved security state to enum (Dan)
- Change security output "security_state" to just "security". (Dan)
- Break out enable and update passphrase operation. (Dan)
- Security build can be compiled out when keyutils does not exist. (Dan)
- Move all keyutils related operations to libndctl. (Dan)

v4:
- Updated to match latest kernel interface.
- Added unit test for all security calls

v3:
- Added support to inject keys in order to update nvdimm security.

v2:
- Fixup the upcall util to match recent kernel updates for nvdimm security.

---

Dave Jiang (13):
      ndctl: add support for display security state
      ndctl: add command for ndctl to receive the key encryption key (master)
      ndctl: add passphrase update to ndctl
      ndctl: add disable security support
      ndctl: add support for freeze security
      ndctl: add support for sanitize dimm
      ndctl: add unit test for security ops (minus overwrite)
      ndctl: add modprobe conf file and load-keys ndctl command
      ndctl: add overwrite operation support
      ndctl: add wait-overwrite support
      ndctl: master phassphrase management support
      ndctl: add master secure erase support
      ndctl: documentation for security and key management


 Documentation/ndctl/Makefile.am                   |   10 
 Documentation/ndctl/intel-nvdimm-security.txt     |  139 +++++
 Documentation/ndctl/ndctl-freeze-security.txt     |   60 ++
 Documentation/ndctl/ndctl-install-encrypt-key.txt |   31 +
 Documentation/ndctl/ndctl-list.txt                |    8 
 Documentation/ndctl/ndctl-load-keys.txt           |   43 ++
 Documentation/ndctl/ndctl-remove-passphrase.txt   |   28 +
 Documentation/ndctl/ndctl-sanitize-dimm.txt       |   48 ++
 Documentation/ndctl/ndctl-setup-passphrase.txt    |   41 +
 Documentation/ndctl/ndctl-update-passphrase.txt   |   43 ++
 Documentation/ndctl/ndctl-wait-overwrite.txt      |   31 +
 Makefile.am                                       |    4 
 configure.ac                                      |   17 +
 contrib/nvdimm-security.conf                      |    1 
 ndctl.spec.in                                     |    3 
 ndctl/Makefile.am                                 |    5 
 ndctl/builtin.h                                   |    8 
 ndctl/dimm.c                                      |  232 ++++++++
 ndctl/kek.c                                       |  133 +++++
 ndctl/lib/Makefile.am                             |    8 
 ndctl/lib/dimm.c                                  |  183 +++++++
 ndctl/lib/keys.c                                  |  581 +++++++++++++++++++++
 ndctl/lib/libndctl.c                              |   31 +
 ndctl/lib/libndctl.sym                            |   16 +
 ndctl/lib/private.h                               |    1 
 ndctl/libndctl.h                                  |   79 +++
 ndctl/load-keys.c                                 |  257 +++++++++
 ndctl/ndctl.c                                     |    8 
 test/Makefile.am                                  |    4 
 test/security.sh                                  |  223 ++++++++
 util/json.c                                       |   17 +
 31 files changed, 2280 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/ndctl/intel-nvdimm-security.txt
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt
 create mode 100644 Documentation/ndctl/ndctl-install-encrypt-key.txt
 create mode 100644 Documentation/ndctl/ndctl-load-keys.txt
 create mode 100644 Documentation/ndctl/ndctl-remove-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-sanitize-dimm.txt
 create mode 100644 Documentation/ndctl/ndctl-setup-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-wait-overwrite.txt
 create mode 100644 contrib/nvdimm-security.conf
 create mode 100644 ndctl/kek.c
 create mode 100644 ndctl/lib/keys.c
 create mode 100644 ndctl/load-keys.c
 create mode 100755 test/security.sh

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
