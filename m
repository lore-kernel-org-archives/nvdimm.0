Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3A02C80
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 08:21:54 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="249511701"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="249511701"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:53 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568555073"
Received: from abishekh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:53 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 00/17] Initial CXL support
Date: Thu,  7 Oct 2021 02:21:22 -0600
Message-Id: <20211007082139.3088615-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6502; h=from:subject; bh=of5rUB96XbBWvsbnML3DYWLhtbtCSVQfzrwEb9NRE88=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlxa/+de3B0f95mDXbTE3fXT5kjv7wwL7JoWp+Ynv/hJ5fd vu9/0lHKwiDGwSArpsjyd89HxmNy2/N5AhMcYeawMoEMYeDiFICJKP9kZDiy607jGgbH90p7woKnit ySPHL3+9vk2Wu23JjY/e7Ik73PGRmmKV1rb/2w5CVjDYvf1It7JOLvLGT8v+Pxv8kbzxVz7WnjAQA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Changes since v3[1]:

- Collect review tags
- Add the kernel's struct_size() helper for trailing array struct
  calculations (Dan)
- Drop test/libcxl - to be re-added after switching to an in-kernel
  emulation/unit test regime 'cxl_test', similar to 'nfit_test' (Dan)
- Rename some verb_X_verb instances to drop the double verb (Dan)
- Rename '{get,set}_lsa' to '{read,write}_labels' in libcxl APIs (Dan)
- Add accessor APIs for health flags instead of leaking binary
  representations to library users (Dan)
- Rename '{get,set,zero}_lsa' APIs to '{read,write,zero}_label' (Dan)
- Add health info to cxl-list
- Fix a bug where a newly minted cmd struct didn't have a non-zero status
  (This allowed a flow like cxl_cmd_new_<foo> followed by
  cxl_cmd_<foo>_get_<field>() to silently succeed, where the second
  accessor call should've failed because cxl_cmd_submit was omitted.
- Change the cxl_cmd_read_label_get_payload() API to refrain from simply
  returning a void pointer, that is easy to access out of bounds. Instead,
  expect a buf/len pair that libcxl then copies the payload into (Dan)

[1]: https://lore.kernel.org/linux-cxl/a86b057ccdd8e0a087d300dfc7dc315a3bf32e95.camel@intel.com/

---

These patches add a new utility and library to support CXL devices.
This comprehends the kernel's sysfs layout for CXL devices, and
implements a command submission harness for CXL mailbox commands via
ioctl()s defined by the cxl_mem driver. 

These patches include:
- libcxl representation of cxl_mem devices
- A command submission harness through libcxl
- A 'cxl-list' command which displays information about a device
- cxl-{read,write,zero}-labels commands for Label Storage Area
  manipulation

An ndctl branch with these patches is also available at [2]

[2]: https://github.com/pmem/ndctl/tree/cxl-2.0v4

Ira Weiny (1):
  ndctl: Add CXL packages to the RPM spec

Vishal Verma (16):
  ndctl: add .clang-format
  cxl: add a cxl utility and libcxl library
  cxl: add a local copy of the cxl_mem UAPI header
  util: add the struct_size() helper from the kernel
  libcxl: add support for command query and submission
  libcxl: add support for the 'Identify Device' command
  libcxl: add GET_HEALTH_INFO mailbox command and accessors
  libcxl: add support for the 'GET_LSA' command
  util/hexdump: Add a util helper to print a buffer in hex
  libcxl: add label_size to cxl_memdev, and an API to retrieve it
  libcxl: add a stub interface to determine whether a memdev is active
  libcxl: add interfaces for label operations
  cxl: add commands to read, write, and zero labels
  Documentation/cxl: add library API documentation
  cxl-cli: add bash completion
  cxl: add health information to cxl-list

 Documentation/cxl/cxl-list.txt           |   68 ++
 Documentation/cxl/cxl-read-labels.txt    |   33 +
 Documentation/cxl/cxl-write-labels.txt   |   32 +
 Documentation/cxl/cxl-zero-labels.txt    |   29 +
 Documentation/cxl/cxl.txt                |   34 +
 Documentation/cxl/human-option.txt       |    8 +
 Documentation/cxl/labels-description.txt |    8 +
 Documentation/cxl/labels-options.txt     |   17 +
 Documentation/cxl/lib/cxl_new.txt        |   43 +
 Documentation/cxl/lib/libcxl.txt         |   56 +
 Documentation/cxl/memdev-option.txt      |    4 +
 Documentation/cxl/verbose-option.txt     |    5 +
 configure.ac                             |    4 +
 Makefile.am                              |   14 +-
 Makefile.am.in                           |    5 +
 cxl/lib/private.h                        |  140 +++
 cxl/lib/libcxl.c                         | 1265 ++++++++++++++++++++++
 cxl/builtin.h                            |   13 +
 cxl/cxl_mem.h                            |  189 ++++
 cxl/libcxl.h                             |  116 ++
 util/bitmap.h                            |   23 +
 util/filter.h                            |    2 +
 util/hexdump.h                           |    8 +
 util/json.h                              |    4 +
 util/main.h                              |    3 +
 util/size.h                              |   62 ++
 util/util.h                              |    6 +
 cxl/cxl.c                                |   99 ++
 cxl/list.c                               |  118 ++
 cxl/memdev.c                             |  314 ++++++
 util/filter.c                            |   20 +
 util/hexdump.c                           |   53 +
 util/json.c                              |  215 ++++
 .clang-format                            |  162 +++
 .gitignore                               |    7 +-
 Documentation/cxl/Makefile.am            |   61 ++
 Documentation/cxl/lib/Makefile.am        |   58 +
 contrib/ndctl                            |  109 ++
 cxl/Makefile.am                          |   22 +
 cxl/lib/Makefile.am                      |   32 +
 cxl/lib/libcxl.pc.in                     |   11 +
 cxl/lib/libcxl.sym                       |   87 ++
 ndctl.spec.in                            |   49 +
 43 files changed, 3604 insertions(+), 4 deletions(-)
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
 create mode 100644 util/hexdump.h
 create mode 100644 cxl/cxl.c
 create mode 100644 cxl/list.c
 create mode 100644 cxl/memdev.c
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

