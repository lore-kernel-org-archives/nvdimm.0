Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 476E720985980
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 15:45:42 -0700 (PDT)
Subject: [PATCH 0/6] ndctl: add security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 13 Jul 2018 15:45:31 -0700
Message-ID: <153152170933.6787.1111990895827764695.stgit@djiang5-desk3.ch.intel.com>
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

Also a reference helper app is provided to retrieve security information
through the keyutils and kernel key management API.

---

Dave Jiang (6):
      ndctl: add support for display security state
      ndctl: add update to security support
      ndctl: add disable security support
      ndctl: add support for freeze security
      ndctl: add support for secure erase
      ndctl: add request-key upcall reference app


 Documentation/ndctl/Makefile.am                |    7 +
 Documentation/ndctl/ndctl-disable-security.txt |   21 ++++
 Documentation/ndctl/ndctl-freeze-security.txt  |   21 ++++
 Documentation/ndctl/ndctl-list.txt             |    8 +
 Documentation/ndctl/ndctl-secure-erase.txt     |   21 ++++
 Documentation/ndctl/ndctl-update-security.txt  |   21 ++++
 Documentation/ndctl/nvdimm-upcall.txt          |   29 +++++
 Makefile.am                                    |    5 +
 builtin.h                                      |    4 +
 configure.ac                                   |    1 
 contrib/nvdimm.conf                            |   21 ++++
 ndctl.spec.in                                  |    3 +
 ndctl/Makefile.am                              |    5 +
 ndctl/dimm.c                                   |   87 +++++++++++++++
 ndctl/lib/dimm.c                               |   51 +++++++++
 ndctl/lib/libndctl.sym                         |    5 +
 ndctl/libndctl.h                               |    5 +
 ndctl/ndctl.c                                  |    4 +
 ndctl/nvdimm-upcall.c                          |  138 ++++++++++++++++++++++++
 util/json.c                                    |    8 +
 20 files changed, 464 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-disable-security.txt
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt
 create mode 100644 Documentation/ndctl/ndctl-secure-erase.txt
 create mode 100644 Documentation/ndctl/ndctl-update-security.txt
 create mode 100644 Documentation/ndctl/nvdimm-upcall.txt
 create mode 100644 contrib/nvdimm.conf
 create mode 100644 ndctl/nvdimm-upcall.c

--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
