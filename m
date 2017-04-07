Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6848A21A0480F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 16:19:31 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 0/6] Add ndctl check-namespace
Date: Fri,  7 Apr 2017 17:17:57 -0600
Message-Id: <20170407231803.14936-1-vishal.l.verma@intel.com>
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

Changes in v4:
- Change the bitmap code to the kernel's GPLv2 Routines instead of the
  LGPL ccan/bitmap.
- Upgrade a few messages from 'info' to 'err'

Changes in v3:
- Move the addition of ccan/bitmap to its own patch(es) (Dan)
- Drop the changelog update from the spec (Dan)
- Fix the [verse] section in the documentation text for check-namespace (Dan)
- Unify all namespace_disable paths to perform checking for a mounted
  filesystem (Dan)
- Change the logging to use util/log.h (Dan)
- Use BTT_START_OFFSET for the initial offset, and store it in bttc (Jeff, Dan)
- Fix a number of line > 80 chars (everything but strings) (Jeff)
- Fix short write error handling, add fsync (Jeff)
- Save system page size in bttc to avoid calling sysconf repeatedly (Jeff)
- In check_log_map(), loop through the entire log even in case of an error,
  and if there was a saved error, fail. (Jeff)
- btt-check.sh: in the post repair test, validate that the data read back
  is the same as what was written (Jeff)
- Stop playing games with pre-adding/subtracting the initial 4K offset (Jeff)
- btt_read_info doesn't need to use 'rc', return directly.

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

Vishal Verma (6):
  libndctl: add a ndctl_namespace_is_active helper
  libndctl: add a ndctl_namespace_disable_safe() API
  ndctl: move the fletcher64 routine to util/
  util: add util/bitmap in preparation for the BTT checker
  ndctl: add a BTT check utility
  ndctl, test: Add a unit test for the BTT checker

 Documentation/Makefile.am               |   1 +
 Documentation/ndctl-check-namespace.txt |  64 +++
 Documentation/ndctl.txt                 |   1 +
 Makefile.am                             |   4 +-
 builtin.h                               |   1 +
 contrib/ndctl                           |   3 +
 ndctl/Makefile.am                       |   1 +
 ndctl/builtin-check.c                   | 988 ++++++++++++++++++++++++++++++++
 ndctl/builtin-dimm.c                    |  18 +-
 ndctl/builtin-list.c                    |   2 +-
 ndctl/builtin-xaction-namespace.c       | 112 ++--
 ndctl/check.h                           | 127 ++++
 ndctl/lib/libndctl.c                    |  59 ++
 ndctl/lib/libndctl.sym                  |   2 +
 ndctl/libndctl.h.in                     |   3 +
 ndctl/ndctl.c                           |   1 +
 test/Makefile.am                        |   5 +-
 test/btt-check.sh                       | 172 ++++++
 util/bitmap.c                           | 115 ++++
 util/bitmap.h                           |  32 ++
 util/fletcher.c                         |  23 +
 util/fletcher.h                         |   8 +
 util/json.c                             |  17 +-
 util/json.h                             |   1 -
 util/util.h                             |  12 +
 25 files changed, 1696 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/ndctl-check-namespace.txt
 create mode 100644 ndctl/builtin-check.c
 create mode 100644 ndctl/check.h
 create mode 100755 test/btt-check.sh
 create mode 100644 util/bitmap.c
 create mode 100644 util/bitmap.h
 create mode 100644 util/fletcher.c
 create mode 100644 util/fletcher.h

-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
