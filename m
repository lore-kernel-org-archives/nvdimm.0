Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F174821103987
 for <linux-nvdimm@lists.01.org>; Tue, 28 Aug 2018 15:52:26 -0700 (PDT)
Subject: [PATCH v3 0/6] ndctl: add security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 28 Aug 2018 15:51:45 -0700
Message-ID: <153549661384.5723.4757814248604794802.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com
Cc: dhowells@redhat.com, alison.schofield@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following series implements mechanisms that utilize the sysfs knobs
provided by the kernel in order to support the Intel DSM v1.7 spec
that provides security to NVDIMM. The following abilities are added:
1. display security state
2. update security
3. disable security
4. freeze security
5. secure erase

Also a reference helper app is provided to retrieve security information
through the keyutils and kernel key management API.

v3:
- Added support to inject keys in order to update nvdimm security.

v2:
- Fixup the upcall util to match recent kernel updates for nvdimm security.

---

Dave Jiang (6):
      ndctl: add support for display security state
      ndctl: add update to security support
      ndctl: add disable security support
      ndctl: add support for freeze security
      ndctl: add support for sanitize dimm
      ndctl: add request-key upcall reference app


 Documentation/ndctl/Makefile.am                |    7 +
 Documentation/ndctl/ndctl-disable-security.txt |   21 +++
 Documentation/ndctl/ndctl-freeze-security.txt  |   21 +++
 Documentation/ndctl/ndctl-list.txt             |    8 +
 Documentation/ndctl/ndctl-sanitize.txt         |   32 ++++
 Documentation/ndctl/ndctl-update-security.txt  |   56 +++++++
 Documentation/ndctl/nvdimm-upcall.txt          |   33 ++++
 builtin.h                                      |    4 +
 configure.ac                                   |    1 
 ndctl.spec.in                                  |    2 
 ndctl/Makefile.am                              |    5 +
 ndctl/dimm.c                                   |  180 +++++++++++++++++++++++-
 ndctl/lib/Makefile.am                          |    4 -
 ndctl/lib/dimm.c                               |   55 +++++++
 ndctl/lib/keys.c                               |  130 +++++++++++++++++
 ndctl/lib/libndctl.sym                         |   11 +
 ndctl/libndctl.h                               |   11 +
 ndctl/ndctl.c                                  |    4 +
 ndctl/nvdimm-upcall.c                          |  138 ++++++++++++++++++
 util/json.c                                    |    8 +
 20 files changed, 718 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-disable-security.txt
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt
 create mode 100644 Documentation/ndctl/ndctl-sanitize.txt
 create mode 100644 Documentation/ndctl/ndctl-update-security.txt
 create mode 100644 Documentation/ndctl/nvdimm-upcall.txt
 create mode 100644 ndctl/lib/keys.c
 create mode 100644 ndctl/nvdimm-upcall.c

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
