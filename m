Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E872C80
	for <nvdimm@lists.linux.dev>; Wed, 12 Jan 2022 06:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641968914; x=1673504914;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JDv1dddvwYO1p7gaboiyqEnd33tSdsa/qI5+PGi6IkA=;
  b=UzFSmaDviwJ/PUNwdiIueyXYJZS1lv7CcBYt2VUFTVIk558gCS9DEDvg
   HDmyzAVie1lkHyWmNynur0KYYsz4v5o6npxnBIeRDArfZZ8Ad0dHJSOGT
   BOwfo9rmTRabbMX6pxbz+J4oYfNrrYrKoRnySk5Izvtjdx8hsMHaWnnHu
   XeS4N24D1eb6bXhUTmWYLgZ5p6xkw4uaWHaP/Opm6hjs6smMq8wpytGzZ
   KekDJekoZjXJD0HXGgMax/4Ck0MO3ADBvhZWRN8lacTU6m9Zgwlb2325F
   RHlK42Slb7XV8AuB7ck759XlfIqO4ykDiesqJQOwmLVXiuIRlYFQ2ruAn
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="304407178"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="304407178"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 22:28:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="529051344"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 22:28:33 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 0/6] Add partitioning support for CXL memdevs
Date: Tue, 11 Jan 2022 22:33:28 -0800
Message-Id: <cover.1641965853.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Users may want to view and change partition layouts of CXL memory
devices that support partitioning. Provide userspace access to
the device partitioning capabilities as defined in the CXL 2.0
specification.

The first 4 patches add accessors for all the information needed
to formulate a new partition layout. This info is accessible via
the libcxl API and a new option in the cxl list command:

    "partition_info":{
      "active_volatile_bytes":273535729664,
      "active_persistent_bytes":0,
      "next_volatile_bytes":268435456,
      "next_persistent_bytes":273267294208,
      "total_bytes":273535729664,
      "volatile_only_bytes":0,
      "persistent_only_bytes":0,
      "partition_alignment_bytes":268435456
    }

Patch 5 introduces the libcxl interfaces for the SET_PARTITION_INFO
mailbox command and Patch 6 adds the new CXL command: 

# cxl set-partition-info
 usage: cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]

    -v, --verbose         turn on debug
    -s, --volatile_size <n>
                          next volatile partition size in bytes

The CXL command does not offer the IMMEDIATE mode option defined
in the CXL 2.0 spec because the CXL kernel driver does not support
immediate mode yet. Since userspace could use the libcxl API to
send a SET_PARTITION_INFO mailbox command with immediate mode
selected, a kernel patch that rejects such requests is in review
for the CXL driver.

Tested with one memdev in a Simics environment. Still need to
expand that Simics config, use cxl_test, and add a unit test.

Repo: https://github.com/AlisonSchofield/ndctl/tree/as/partitions

Changes in v2:
- Rebase onto https://github.com/pmem/ndctl.git djbw/meson.
- Clarify that capacities are reported in bytes. (Ira)
  This led to renaming accessors like *_capacity to  *_bytes and 
  a spattering of changes in the man pages and commit messages.
- Add missing cxl_cmd_unref() when creating json objects. (Ira)
- Change the cxl list option to: -I --partition (Dan) 
- Use OPT_STRING for the --volatile_size parameter (Dan, Vishal)
- Drop extra _get_ in accessor names. (Vishal)
- Add an accessor for the SET_PARTITION_INFO mbox cmd flag.
- Display usage_with_options if size parameter is missing.
- Drop the OPT64 define patch. Use OPT_STRING instead.

Alison Schofield (6):
  libcxl: add GET_PARTITION_INFO mailbox command and accessors
  libcxl: add accessors for capacity fields of the IDENTIFY command
  libcxl: return the partition alignment field in bytes
  cxl: add memdev partition information to cxl-list
  libcxl: add interfaces for SET_PARTITION_INFO mailbox command
  cxl: add command set-partition-info

 Documentation/cxl/cxl-list.txt               |  23 ++++
 Documentation/cxl/cxl-set-partition-info.txt |  27 ++++
 Documentation/cxl/partition-description.txt  |  15 +++
 Documentation/cxl/partition-options.txt      |  20 +++
 cxl/builtin.h                                |   1 +
 cxl/cxl.c                                    |   1 +
 cxl/json.c                                   | 114 +++++++++++++++++
 cxl/lib/libcxl.c                             | 124 ++++++++++++++++++-
 cxl/lib/libcxl.sym                           |  15 ++-
 cxl/lib/private.h                            |  18 +++
 cxl/libcxl.h                                 |  15 ++-
 cxl/list.c                                   |   5 +
 cxl/memdev.c                                 | 101 +++++++++++++++
 util/json.h                                  |   1 +
 util/size.h                                  |   1 +
 15 files changed, 477 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/cxl/cxl-set-partition-info.txt
 create mode 100644 Documentation/cxl/partition-description.txt
 create mode 100644 Documentation/cxl/partition-options.txt


base-commit: 25062cf34c70012f5d42ce1fef7e2dc129807c10
prerequisite-patch-id: d34c91059d77651eaf1e71adb6135b397f64c056
prerequisite-patch-id: 72a64823dc720b5c7b65fe949d75e9f6fbf79035
prerequisite-patch-id: f9fd1d50d96896f27ce1d6df59d1aa8ea06795ab
prerequisite-patch-id: 0e904349e14e74754a22bd72ce97add030d80e90
prerequisite-patch-id: 331899e7b565c625ef0647f71057850a919535d8
prerequisite-patch-id: 0ddeb2219011fe7b272cbbf59bc046bf26ee1bc7
prerequisite-patch-id: fe1023948a0202cca8d641e694de425512512f92
prerequisite-patch-id: 48b0b8feddcc98201f3c75b15bb1ed13d30e1269
prerequisite-patch-id: 5a9be92f860c0bf9144772b550d62e0c0a463e7c
prerequisite-patch-id: 113e1fa147e96ba5d4127246cc3dcae895d33e7c
prerequisite-patch-id: 03ad3eb99d14b51a0d0a48dfb3f6f3b2f84bac24
prerequisite-patch-id: 6c9b29768efc178c37d62c53501a98bc7baa9934
prerequisite-patch-id: d4086981a857f5f2d3720f33e1c823f906b3211f
prerequisite-patch-id: 3ad6ea54cc6430977c8ae4a0833e22499f1ccd96
prerequisite-patch-id: d4ff0ee2dc988440e0cad26d43e1a740fb89fbfd
prerequisite-patch-id: e33606c2a4ab9ac74034cb3bde8947317274d8b3
prerequisite-patch-id: e7b57274d44fd9cdf1b64ca802b33afe255cef44
-- 
2.31.1

