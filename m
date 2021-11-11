Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F902C81
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:44:52 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253815"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253815"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:51 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579037"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:51 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 00/16] Initial CXL support
Date: Thu, 11 Nov 2021 13:44:20 -0700
Message-Id: <20211111204436.1560365-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6280; h=from:subject; bh=49apJkqaROZoho3Lce5vLnrkUR0NgTqo+PLdAVKLd7M=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DZMycu9zPbLfK39e6X8K9/JQ6d4zf9/dV1txwTk6vZbp UoBDRykLgxgHg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACZi95/hf0Qdr6hK9Td1lScSh55L/K g3O7tj1wUO0fKbDwQUehItrRn+6S89c3n5nn/rt+Rf2R8hVvV+ybPGF3kLtz0ze3CaJW2fCSMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Changes since v4[1]:

- Collect review tags
- Handle the case where label_size > payload_max. With cxl_test labels
  being 128K, it was easy to hit this case, so add in the handling to
  loop over the label space in payload_max sized chunks to read/write the
  full label area.
- Make label APIs consistent for what size==0 means (Dan)
- Introduce an nvdimm bridge object, and an API to check whether one is
  active, replacing the stub 'cxl_memdev_is_active() API) (Dan)
- Import Linux's FIELD_GET() and use it for health_info accessors (Dan)
- Move all symbols to the v1 group in libcxl.sym since this is the first
  release (Dan)
- Replace the implicit cmd struct casting via (void *) with explicit
  casts to the respective structs (Dan).
- Various man page fixups (Dan)
- Switch json_object_new_uint64 to json_object_new_int, as the former is
  a relatively new API, and unavailable in some distributions of json-c
- Remove error prints for cmd failure in util_cxl_memdev_health_to_json().
  The cmd can fail for a number of reasons, we can just skip printing the
  json in that case.

[1]: https://lore.kernel.org/linux-cxl/20211007082139.3088615-1-vishal.l.verma@intel.com/T/#m9bb81856e45b7e4bff861ccb19af9ba0952e8d47

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

[2]: https://github.com/pmem/ndctl/tree/cxl-2.0v5

Ira Weiny (1):
  ndctl: Add CXL packages to the RPM spec

Vishal Verma (15):
  ndctl: add .clang-format
  cxl: add a cxl utility and libcxl library
  cxl: add a local copy of the cxl_mem UAPI header
  util: add the struct_size() helper from the kernel
  libcxl: add support for command query and submission
  libcxl: add support for the 'Identify Device' command
  libcxl: add GET_HEALTH_INFO mailbox command and accessors
  libcxl: add support for the 'GET_LSA' command
  libcxl: add label_size to cxl_memdev, and an API to retrieve it
  libcxl: add representation for an nvdimm bridge object
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
 cxl/lib/private.h                        |  149 +++
 cxl/lib/libcxl.c                         | 1357 ++++++++++++++++++++++
 cxl/builtin.h                            |   13 +
 cxl/cxl_mem.h                            |  189 +++
 cxl/libcxl.h                             |  117 ++
 util/bitmap.h                            |   85 ++
 util/filter.h                            |    2 +
 util/json.h                              |    4 +
 util/main.h                              |    3 +
 util/size.h                              |   62 +
 util/util.h                              |    6 +
 cxl/cxl.c                                |   99 ++
 cxl/list.c                               |  118 ++
 cxl/memdev.c                             |  324 ++++++
 util/filter.c                            |   20 +
 util/json.c                              |  205 ++++
 .clang-format                            |  162 +++
 .gitignore                               |    7 +-
 Documentation/cxl/Makefile.am            |   61 +
 Documentation/cxl/lib/Makefile.am        |   58 +
 contrib/ndctl                            |  109 ++
 cxl/Makefile.am                          |   22 +
 cxl/lib/Makefile.am                      |   32 +
 cxl/lib/libcxl.pc.in                     |   11 +
 cxl/lib/libcxl.sym                       |   75 ++
 ndctl.spec.in                            |   49 +
 41 files changed, 3695 insertions(+), 4 deletions(-)
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
 create mode 100644 cxl/cxl.c
 create mode 100644 cxl/list.c
 create mode 100644 cxl/memdev.c
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

