Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 372EC21D0DE59
 for <linux-nvdimm@lists.01.org>; Fri, 14 Dec 2018 13:09:03 -0800 (PST)
Subject: [PATCH v6 00/12] ndctl: add security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 14 Dec 2018 14:09:03 -0700
Message-ID: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
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
To: "vishal.l.verma."@intel.com, dan.j.williams@intel.com
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

Dave Jiang (12):
      ndctl: add support for display security state
      ndctl: add passphrase update to ndctl
      ndctl: add disable security support
      ndctl: add support for freeze security
      ndctl: add support for sanitize dimm
      ndctl: add unit test for security ops (minus overwrite)
      ndctl: setup modprobe rules
      ndctl: add overwrite operation support
      ndctl: add overwrite-wait support
      ndctl: master phassphrase management support
      ndctl: add master secure erase support
      ndctl: documentation for security and key management


 Documentation/ndctl/Makefile.am                  |    8 
 Documentation/ndctl/intel-nvdimm-security.txt    |  139 ++++++
 Documentation/ndctl/ndctl-disable-passphrase.txt |   29 +
 Documentation/ndctl/ndctl-enable-passphrase.txt  |   44 ++
 Documentation/ndctl/ndctl-freeze-security.txt    |   22 +
 Documentation/ndctl/ndctl-list.txt               |    8 
 Documentation/ndctl/ndctl-sanitize-dimm.txt      |   44 ++
 Documentation/ndctl/ndctl-update-passphrase.txt  |   40 ++
 Documentation/ndctl/ndctl-wait-overwrite.txt     |   31 +
 Makefile.am                                      |   10 
 builtin.h                                        |    6 
 configure.ac                                     |   14 +
 contrib/ndctl-loadkeys.sh                        |   24 +
 contrib/nvdimm_modprobe.conf                     |    1 
 ndctl.spec.in                                    |    2 
 ndctl/Makefile.am                                |    3 
 ndctl/dimm.c                                     |  242 ++++++++++-
 ndctl/lib/Makefile.am                            |    8 
 ndctl/lib/dimm.c                                 |  203 +++++++++
 ndctl/lib/keys.c                                 |  501 ++++++++++++++++++++++
 ndctl/lib/libndctl.sym                           |   19 +
 ndctl/libndctl.h                                 |   76 +++
 ndctl/ndctl.c                                    |    6 
 test/Makefile.am                                 |    4 
 test/security.sh                                 |  191 ++++++++
 util/json.c                                      |   31 +
 26 files changed, 1693 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/ndctl/intel-nvdimm-security.txt
 create mode 100644 Documentation/ndctl/ndctl-disable-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-enable-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt
 create mode 100644 Documentation/ndctl/ndctl-sanitize-dimm.txt
 create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-wait-overwrite.txt
 create mode 100755 contrib/ndctl-loadkeys.sh
 create mode 100644 contrib/nvdimm_modprobe.conf
 create mode 100644 ndctl/lib/keys.c
 create mode 100755 test/security.sh

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
