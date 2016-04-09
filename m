Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 7E6C41A1E0C
 for <linux-nvdimm@lists.01.org>; Sat,  9 Apr 2016 12:40:21 -0700 (PDT)
Subject: [ndctl PATCH 0/4] read-labels, destroy-namespace, and misc updates
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Apr 2016 12:39:30 -0700
Message-ID: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

For debug it is useful to be able to dump a DIMM's label area, this
includes a json dump option in addition to a raw binary format.

For completeness with create-namespace, add a destroy-namespace
facility.  This simply refactors the namespace teardown that occurs
during reconfiguration into its own utility.

Finally, a few cleanups and fixups for compiling against older ndctl.h
headers.

---

Dan Williams (4):
      ndctl: fix compile in the HAVE_NDCTL_{ARS|CLEAR_ERROR}=n cases
      ndctl: use filter utility routines zero-labels
      ndctl: new 'read-labels' utility
      ndctl: new 'destroy-namespace' utility


 Documentation/Makefile.am                 |    6 
 Documentation/labels-description.txt      |    6 
 Documentation/labels-options.txt          |   13 +
 Documentation/ndctl-destroy-namespace.txt |   27 ++
 Documentation/ndctl-read-labels.txt       |   30 ++
 Documentation/ndctl-zero-labels.txt       |   23 --
 Makefile.am                               |    1 
 builtin-list.c                            |   21 -
 builtin-read-labels.c                     |  420 +++++++++++++++++++++++++++++
 builtin-xaction-namespace.c               |   61 ++++
 builtin-zero-labels.c                     |   27 --
 builtin.h                                 |    2 
 lib/libndctl-ars.c                        |   18 +
 lib/libndctl.c                            |   10 +
 ndctl.c                                   |    4 
 test/libndctl.c                           |   55 +---
 util/json.c                               |   15 +
 util/json.h                               |    3 
 18 files changed, 638 insertions(+), 104 deletions(-)
 create mode 100644 Documentation/labels-description.txt
 create mode 100644 Documentation/labels-options.txt
 create mode 100644 Documentation/ndctl-destroy-namespace.txt
 create mode 100644 Documentation/ndctl-read-labels.txt
 create mode 100644 builtin-read-labels.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
