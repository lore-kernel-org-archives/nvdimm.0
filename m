Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 8B6061A1F35
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:08 -0800 (PST)
Subject: [ndctl PATCH 0/8] updates for v52
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:36:28 -0800
Message-ID: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
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

1/ Add new apis for retrieving the resource base address and the
   effective capacity for pmem namespaces in 'raw' or 'memory' mode.

2/ Add a -t option to 'ndctl list' to filter based on 'pmem' or 'blk'
   region types.

3/ Add a unit test for the new 'clear poison' functionality targeting
   the 4.6 kernel.

4/ Miscellaneous updates and fixlets 

---

Dan Williams (8):
      ndctl: make --enable-local the default
      ndctl: ndctl_{namespace|pfn}_get_resource
      ndctl: refresh dynamic pfn attributes from a duplicate
      ndctl: use the pfn trimmed size for memory mode namespaces
      ndctl create-namespace: fall back to blk if no pmem
      ndctl: make test/dax-dev more robust
      ndctl: add filter-by-type to the 'list' command
      ndctl: test clear poison


 Documentation/ndctl-list.txt |    4 ++
 Makefile.am                  |    3 +-
 builtin-list.c               |   21 +++++++++++++
 builtin-xaction-namespace.c  |   68 ++++++++++++++++++++++++++++++++----------
 configure.ac                 |    4 +-
 lib/libndctl.c               |   38 +++++++++++++++++++++++
 lib/libndctl.sym             |    3 ++
 lib/ndctl/libndctl.h         |    3 ++
 test/clear.sh                |   67 +++++++++++++++++++++++++++++++++++++++++
 test/dax-dev.c               |    7 ++++
 util/json.c                  |   24 +++++++++++----
 11 files changed, 213 insertions(+), 29 deletions(-)
 create mode 100755 test/clear.sh
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
