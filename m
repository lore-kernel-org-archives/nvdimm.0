Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08D9F21D0DE59
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 15:28:36 -0700 (PDT)
Subject: [PATCH v4 0/7] ndctl: add security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 15:28:35 -0700
Message-ID: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
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
provided by the kernel in order to support the Intel DSM v1.7 spec
that provides security to NVDIMM. The following abilities are added:
1. display security state
2. update security
3. disable security
4. freeze security
5. secure erase
6. kernel unlock upcall support

v4:
- Updated to match latest kernel interface.
- Added unit test for all security calls

v3:
- Added support to inject keys in order to update nvdimm security.

v2:
- Fixup the upcall util to match recent kernel updates for nvdimm security.

---

Dave Jiang (7):
      ndctl: add support for display security state
      ndctl: add update to security support
      ndctl: add disable security support
      ndctl: add support for freeze security
      ndctl: add support for sanitize dimm
      ndctl: add request-key upcall reference app
      ndctl: add unit test for security ops (minus overwrite)


 Documentation/ndctl/Makefile.am                |    7 +
 Documentation/ndctl/ndctl-disable-security.txt |   48 +++++
 Documentation/ndctl/ndctl-freeze-security.txt  |   21 ++
 Documentation/ndctl/ndctl-list.txt             |    8 +
 Documentation/ndctl/ndctl-sanitize.txt         |   52 +++++
 Documentation/ndctl/ndctl-update-security.txt  |   56 ++++++
 Documentation/ndctl/nvdimm-upcall.txt          |   33 +++
 Makefile.am                                    |    5 +
 builtin.h                                      |    4 
 configure.ac                                   |    5 +
 contrib/nvdimm.conf                            |    1 
 ndctl.spec.in                                  |    3 
 ndctl/Makefile.am                              |    7 +
 ndctl/dimm.c                                   |  228 +++++++++++++++++++++++-
 ndctl/lib/Makefile.am                          |    4 
 ndctl/lib/dimm.c                               |   63 +++++++
 ndctl/lib/keys.c                               |  139 +++++++++++++++
 ndctl/lib/libndctl.sym                         |   11 +
 ndctl/libndctl.h                               |   18 ++
 ndctl/ndctl.c                                  |    4 
 ndctl/nvdimm-upcall.c                          |  154 ++++++++++++++++
 test/Makefile.am                               |    3 
 test/security.sh                               |  187 ++++++++++++++++++++
 util/json.c                                    |    8 +
 24 files changed, 1054 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-disable-security.txt
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt
 create mode 100644 Documentation/ndctl/ndctl-sanitize.txt
 create mode 100644 Documentation/ndctl/ndctl-update-security.txt
 create mode 100644 Documentation/ndctl/nvdimm-upcall.txt
 create mode 100644 contrib/nvdimm.conf
 create mode 100644 ndctl/lib/keys.c
 create mode 100644 ndctl/nvdimm-upcall.c
 create mode 100755 test/security.sh

--
Signature
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
