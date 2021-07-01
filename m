Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9851229CA
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:15 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606870"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606870"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:13 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271277"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:12 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 00/21] Initial CXL support
Date: Thu,  1 Jul 2021 14:09:44 -0600
Message-Id: <20210701201005.3065299-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v2[1]:

- Some minor cleanups and formatting (Ben)
- Update cxl_mem.h to the latest kernel version (Ben)
- Add .clang-format (Ben)
- Add label commands to cxl-clu - {read,write,zero}-labels
- Add libcxl and cxl-cli to the RPM spec
- Add bash-completion for cxl-cli
- 

[1]: https://lore.kernel.org/linux-cxl/20210219020331.725687-1-vishal.l.verma@intel.com/

---

These patches add a new utility and library to support CXL devices.
This comprehends the kernel's sysfs layout for CXL devices, and
implements a command submission harness for CXL mailbox commands via
ioctl()s definied by the cxl_mem driver. 

These patches include:
- libcxl representation of cxl_mem devices
- A command submission harness through libcxl
- A 'cxl-list' command which displays information about a device
- cxl-{read,write,zero}-labels commands for Label Storage Area
  manipulation
- Unit tests to exercise several libcxl APIs and perform mailbox
  commands.

Patch 15 is an RFC - maybe this should just be dropped entirely for now
until there is a concept of active/disabled memdevs. It is useful as a
placeholder as it allows for a way to pre-insert checks in places
we expect the device to be active or disabled.

An ndctl branch with these patches is also available at [2]

[2]: https://github.com/pmem/ndctl/tree/cxl-2.0v2

Ira Weiny (1):
  ndctl: Add CXL packages to the RPM spec

Vishal Verma (20):
  ndctl: add .clang-format
  cxl: add a cxl utility and libcxl library
  cxl: add a local copy of the cxl_mem UAPI header
  libcxl: add support for command query and submission
  libcxl: add support for the 'Identify Device' command
  test: rename 'ndctl_test' to 'test_ctx'
  test: rename 'ndctl_test_*' helpers to 'test_*'
  test: introduce a libcxl unit test
  libcxl: add GET_HEALTH_INFO mailbox command and accessors
  libcxl: add support for the 'GET_LSA' command
  util/hexdump: Add a util helper to print a buffer in hex
  test/libcxl: add a test for {set, get}_lsa commands
  test/libcxl: introduce a command size fuzzing test
  libcxl: add lsa_size to cxl_memdev, and an API to retrieve it
  libcxl: PLACEHOLDER: add an interface to determine whether a memdev is
    active
  libcxl: add interfaces for label operations
  test/libcxl: add a test for cxl_memdev_{get,set}_lsa
  cxl: add commands to read, write, and zero labels
  Documentation/cxl: add library API documentation
  cxl-cli: add bash completion

 Documentation/cxl/cxl-list.txt           |   64 ++
 Documentation/cxl/cxl-read-labels.txt    |   33 +
 Documentation/cxl/cxl-write-labels.txt   |   32 +
 Documentation/cxl/cxl-zero-labels.txt    |   29 +
 Documentation/cxl/cxl.txt                |   34 +
 Documentation/cxl/human-option.txt       |    8 +
 Documentation/cxl/labels-description.txt |    8 +
 Documentation/cxl/labels-options.txt     |   17 +
 Documentation/cxl/lib/cxl_new.txt        |   43 +
 Documentation/cxl/lib/libcxl.txt         |   56 ++
 Documentation/cxl/memdev-option.txt      |    4 +
 Documentation/cxl/verbose-option.txt     |    5 +
 configure.ac                             |    4 +
 Makefile.am                              |   14 +-
 Makefile.am.in                           |    5 +
 cxl/lib/private.h                        |  104 +++
 cxl/lib/libcxl.c                         | 1026 ++++++++++++++++++++++
 cxl/builtin.h                            |   13 +
 cxl/cxl_mem.h                            |  189 ++++
 cxl/libcxl.h                             |   91 ++
 test.h                                   |   40 +-
 test/libcxl-expect.h                     |   13 +
 util/filter.h                            |    2 +
 util/hexdump.h                           |    8 +
 util/json.h                              |    3 +
 util/main.h                              |    3 +
 cxl/cxl.c                                |   99 +++
 cxl/list.c                               |  113 +++
 cxl/memdev.c                             |  314 +++++++
 ndctl/bat.c                              |    8 +-
 ndctl/test.c                             |    8 +-
 test/ack-shutdown-count-set.c            |   16 +-
 test/blk_namespaces.c                    |   14 +-
 test/core.c                              |   32 +-
 test/dax-dev.c                           |   10 +-
 test/dax-pmd.c                           |   13 +-
 test/dax-poison.c                        |    6 +-
 test/daxdev-errors.c                     |    2 +-
 test/device-dax.c                        |   26 +-
 test/dpa-alloc.c                         |   14 +-
 test/dsm-fail.c                          |   14 +-
 test/libcxl.c                            |  553 ++++++++++++
 test/libndctl.c                          |   84 +-
 test/multi-pmem.c                        |   23 +-
 test/parent-uuid.c                       |   13 +-
 test/pmem_namespaces.c                   |   14 +-
 test/revoke-devmem.c                     |   12 +-
 util/filter.c                            |   20 +
 util/hexdump.c                           |   53 ++
 util/json.c                              |   26 +
 .clang-format                            |  162 ++++
 .gitignore                               |    7 +-
 Documentation/cxl/Makefile.am            |   61 ++
 Documentation/cxl/lib/Makefile.am        |   58 ++
 README.md                                |    2 +-
 contrib/ndctl                            |  109 +++
 cxl/Makefile.am                          |   22 +
 cxl/lib/Makefile.am                      |   32 +
 cxl/lib/libcxl.pc.in                     |   11 +
 cxl/lib/libcxl.sym                       |   67 ++
 ndctl.spec.in                            |   49 ++
 test/Makefile.am                         |   15 +-
 62 files changed, 3749 insertions(+), 181 deletions(-)
 create mode 100644 Documentation/cxl/cxl-list.txt
 create mode 100644 Documentation/cxl/cxl-read-labels.txt
 create mode 100644 Documentation/cxl/cxl-write-labels.txt
 create mode 100644 Documentation/cxl/cxl-zero-labels.txt
 create mode 100644 Documentation/cxl/cxl.txt
 create mode 100644 Documentation/cxl/human-option.txt
 create mode 100644 Documentation/cxl/labels-description.txt
 create mode 100644 Documentation/cxl/labels-options.txt
 create mode 100644 Documentation/cxl/lib/cxl_new.txt
 create mode 100644 Documentation/cxl/lib/libcxl.txt
 create mode 100644 Documentation/cxl/memdev-option.txt
 create mode 100644 Documentation/cxl/verbose-option.txt
 create mode 100644 cxl/lib/private.h
 create mode 100644 cxl/lib/libcxl.c
 create mode 100644 cxl/builtin.h
 create mode 100644 cxl/cxl_mem.h
 create mode 100644 cxl/libcxl.h
 create mode 100644 test/libcxl-expect.h
 create mode 100644 util/hexdump.h
 create mode 100644 cxl/cxl.c
 create mode 100644 cxl/list.c
 create mode 100644 cxl/memdev.c
 create mode 100644 test/libcxl.c
 create mode 100644 util/hexdump.c
 create mode 100644 .clang-format
 create mode 100644 Documentation/cxl/Makefile.am
 create mode 100644 Documentation/cxl/lib/Makefile.am
 create mode 100644 cxl/Makefile.am
 create mode 100644 cxl/lib/Makefile.am
 create mode 100644 cxl/lib/libcxl.pc.in
 create mode 100644 cxl/lib/libcxl.sym


base-commit: 4e646fa490ba4b782afa188dd8818b94c419924e
-- 
2.31.1

