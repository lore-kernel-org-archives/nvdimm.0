Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1E19C21DFA7BA
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 16:19:02 -0700 (PDT)
Subject: [ndctl PATCH 0/6] ndctl: 'write-labels' and other misc updates
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 16:13:51 -0700
Message-ID: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Nicholas Moulin <nicholas.w.moulin@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The primary change is the creation of a new 'write-labels' utility that
can replay the output from 'read-labels' back onto a given device
(nmem). This capability is then used to regression test label
compatibility.

Unrelated to write-labels support this series also takes the opportunity
to:

* clean up the source file names for the ndctl utility commands
* add some missing documentation
* fixup the summary output of dimm-related commands

---

Dan Williams (6):
      ndctl: drop "builtin" prefix from source file names
      Documentation, list: add --device-dax, -X description to man page
      Documentation, list: add --mode, -m description to man page
      ndctl, dimm: add 'write-labels' command
      ndctl, dimm: fix count display in the presence of errors
      test: add interleave set compatibility test


 Documentation/ndctl-list.txt      |   28 ++++++++
 builtin.h                         |    1 
 ndctl/Makefile.am                 |   16 ++--
 ndctl/bat.c                       |    0 
 ndctl/check.c                     |    0 
 ndctl/create-nfit.c               |    0 
 ndctl/dimm.c                      |  138 +++++++++++++++++++++++++++++++++----
 ndctl/list.c                      |    0 
 ndctl/namespace.c                 |    0 
 ndctl/ndctl.c                     |    1 
 ndctl/region.c                    |    0 
 ndctl/test.c                      |    0 
 test/Makefile.am                  |   11 ++-
 test/label-compat.sh              |   61 ++++++++++++++++
 test/nmem1.bin                    |  Bin
 test/nmem2.bin                    |  Bin
 test/nmem3.bin                    |  Bin
 test/nmem4.bin                    |  Bin
 18 files changed, 228 insertions(+), 28 deletions(-)
 rename ndctl/{builtin-bat.c => bat.c} (100%)
 rename ndctl/{builtin-check.c => check.c} (100%)
 rename ndctl/{builtin-create-nfit.c => create-nfit.c} (100%)
 rename ndctl/{builtin-dimm.c => dimm.c} (88%)
 rename ndctl/{builtin-list.c => list.c} (100%)
 rename ndctl/{builtin-xaction-namespace.c => namespace.c} (100%)
 rename ndctl/{builtin-xable-region.c => region.c} (100%)
 rename ndctl/{builtin-test.c => test.c} (100%)
 create mode 100755 test/label-compat.sh
 create mode 100644 test/nmem1.bin
 create mode 100644 test/nmem2.bin
 create mode 100644 test/nmem3.bin
 create mode 100644 test/nmem4.bin
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
