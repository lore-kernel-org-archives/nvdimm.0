Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F04988221D
 for <linux-nvdimm@lists.01.org>; Wed, 22 Feb 2017 14:48:40 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 0/3] Add ndctl check-namespace
Date: Wed, 22 Feb 2017 15:47:21 -0700
Message-Id: <20170222224724.7696-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

I think I've covered all the review comments, but do let me know in case
I missed something!

Changes in v2:
- Move checking functionality to a separate file (Dan, Jeff)
- Rename btt-structs.h to check.h (Dan)
- Don't provide a configure option for building the checker, always
  build it in. (Dan, Jeff)
- Fix the Documentation example to also include disable-namespace (Linda)
- Update the description text to note the namespace needs to be disabled
  before checking (Linda)
- Use util/size.h for sizes (Dan)
- Use --repair to do repairs instead of --dry-run to disable repairs (Dan)
- Fix btt_read_info short read error handling (Jeff)
- Simplify the map lookup/write routines (Jeff)
- Differentiate the use off BTT_PG_SIZE, sysconf(_SC_PAGESIZE), and SZ_4K
  (for the fixed start offset) in the different places they're used (Jeff)
- Add the missing msync when copying over info2 (Jeff)
- Add unit tests to test the checker (Jeff)
- Add a missing error case check in do_xaction_namespace for check
- Add a --force option that allows running on an active namespace (Jeff)
- Add a bitmap test for checking all internal blocks are referenced exactly
  once between the map and flog (Jeff)
- Remove unused #defines in check.h
- Add comments to explain what we do with raw_mode (Jeff)
- Add some sanity checking when parsing an arena's metadata (Jeff)
- Refactor some read-verify sequences into a helper that combines the two (Jeff)
- Additional bounds checking on the 'offset' in recover_first_sb attempt 3 (Jeff)
- Add a missing ACTION_DESTROY string in parse_namespace_options (Dan)
- Use uXX, and cpu_to_XX from ccan/endian (Dan)
- Move the fletcher64 Routing to util/ as it is shared by builtin-dimm.c (Dan)
- Open the raw block device only once with O_EXCL instead of every time on
  read/write/mmap (Dan)
- Add a new 'inform' routing in util/usage.c, and use it for some non-critical
  messages (Dan)
- Remove namespace_is_offline() from builtin-check.c. Instead, use
  util_namespace_active() from util/json.c
- Add a missing return value check after info block restoration in
  discover_arenas


Vishal Verma (3):
  ndctl: move the fletcher64 routine to util/
  ndctl: add a BTT check utility
  ndctl, test: Add a unit test for the BTT checker

 Documentation/Makefile.am               |   1 +
 Documentation/ndctl-check-namespace.txt |  64 +++
 Documentation/ndctl.txt                 |   1 +
 Makefile.am                             |   7 +-
 builtin.h                               |   1 +
 ccan/bitmap/LICENSE                     |   1 +
 ccan/bitmap/bitmap.c                    | 125 +++++
 ccan/bitmap/bitmap.h                    | 243 +++++++++
 contrib/ndctl                           |   3 +
 licenses/LGPL-2.1                       | 508 +++++++++++++++++
 ndctl.spec.in                           |   5 +-
 ndctl/Makefile.am                       |   1 +
 ndctl/builtin-check.c                   | 938 ++++++++++++++++++++++++++++++++
 ndctl/builtin-dimm.c                    |  18 +-
 ndctl/builtin-xaction-namespace.c       |  66 ++-
 ndctl/check.h                           | 123 +++++
 ndctl/ndctl.c                           |   1 +
 test/Makefile.am                        |   5 +-
 test/btt-check.sh                       | 167 ++++++
 util/fletcher.c                         |  23 +
 util/fletcher.h                         |   8 +
 util/usage.c                            |  15 +
 util/util.h                             |   9 +
 23 files changed, 2311 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/ndctl-check-namespace.txt
 create mode 120000 ccan/bitmap/LICENSE
 create mode 100644 ccan/bitmap/bitmap.c
 create mode 100644 ccan/bitmap/bitmap.h
 create mode 100644 licenses/LGPL-2.1
 create mode 100644 ndctl/builtin-check.c
 create mode 100644 ndctl/check.h
 create mode 100755 test/btt-check.sh
 create mode 100644 util/fletcher.c
 create mode 100644 util/fletcher.h

-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
