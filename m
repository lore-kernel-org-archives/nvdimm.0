Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA52F24
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 02:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644458472; x=1675994472;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VQQz7fQ3pYLjX9MYiZUYQMtR7bxmHrOJfjZZtYQmuk4=;
  b=bk/umDtYtt/P1xPcrygCDH0K73HJEN5+Ird/CH4h91YGqb1yoY2vrXe0
   vxGPYUHiki42QVqQJxNrPogKj/5x5pnM6dJGfIbZhwHqF2hOdLeDXhBNt
   VKkdRTjCmcy/9Ws1Wmq0eyeyDft5xTjEpL6t5hkY9GyJ1zq2nk6/VDZKR
   P9uaislWcz6vAduJapIUYzxCcPDyc97SLvhJCFmQRI/C/UYdijDKl+95F
   hHkpxk6+MJk/oae7WeFlHBm4SusYRiTAzZEssXwZLX9Nu01opylov5ZHQ
   1XZgzT5x+hztFsBNyYMSopC15/gsFyx4w8EJNVse3AlpiSfcg0TTKSjAh
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="310128827"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="310128827"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 18:01:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="537154202"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 18:01:11 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v5 0/6] Add partitioning support for CXL memdevs
Date: Wed,  9 Feb 2022 18:05:08 -0800
Message-Id: <cover.1644455619.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Provisioning PMEM over CXL requires the ability to view and change
partition layouts of CXL memory devices that support partitioning.
Provide access to these capabilities as defined in the CXL 2.0
specification.

The first 4 patches add accessors for all the information needed
to formulate a new partition layout. This info is accessible via
the libcxl API and a new option in the 'cxl list' command:

Example:
    "partition_info":{
      "active_volatile_size":273535729664,
      "active_persistent_size":0,
      "next_volatile_size":0,
      "next_persistent_size":0,
      "total_size":273535729664,
      "volatile_only_size":0,
      "persistent_only_size":0,
      "partition_alignment_size":268435456
    }

Patch 5 introduces the libcxl interfaces for the CXL SET_PARTITION_INFO
mailbox command and Patch 6 adds the cxl set-partition command.

 Usage: cxl set-partition <mem0> [<mem1>..<memN>] [<options>]

    -v, --verbose         turn on debug
    -S, --serial          use serial numbers to id memdevs
    -t, --type <type>     'pmem' or 'volatile' (Default: 'pmem')
    -s, --size <size>     size in bytes (Default: all available capacity)
    -a, --align           auto-align --size per device's requirement


The cxl set-partition command does not offer the IMMEDIATE mode option
defined in the CXL 2.0 spec because the CXL kernel driver does not
support immediate mode yet. Since userspace could use the libcxl API
to send a SET_PARTITION_INFO mailbox command with immediate mode
selected, a kernel patch that rejects such requests is in review for
the CXL driver.

Changes in v5: (from Dan's review)
- Applied Dan Reviewed-by tags to all except Patch #3
- Cover letter: update the cxl list, and synopsis output.
- Cover letter: s/CXL/'cxl set-partition'/ for clarity.
- Redefine capacity_to_bytes helper to reflect that it converts
  the le64 to uint64_t.
- Add NULL checks (!cmd) in cmd_to_get_partition() and cmd_to_identify().
- replace ?: statements with if() in libcxl get_<field> helpers.
- replace ?: statements with if() in param_to_volatile_size() helper.
- Add a note in Patch 3 log about this early API behavior change.
- Use the cmd_to_identify() and cxl_capacity_to_bytes() pair for
  retrieving partition_align_size.
- Add note about role of cxl_cmd_partition_set_mode() to libcxl.txt
- Updated cxl-set-partition man page.
- command synopsis: update align description to say 'auto-align...'
- command synopsis: update size default by s/partitionable/available
- add and use an enum for param.type
- s/partitionable/available in many places when referring to size available
  to be partitioned.

Changes in v4: (from Dan's review)
- cxl set-partition command: add type (pmem | volatile),
  add defaults for type and size, and add an align option.
- Replace macros with return statements with functions.
- Add cxl_set_partition_set_mode() to the libcxl API.
- Add API documentation to Documentation/cxl/lib/libcxl.txt.
- Use log_err/info mechanism.
- Display memdev JSON info upon completion of set-partition command.
- Remove unneeded casts when accessing command payloads.
- Name changes - like drop _info suffix, use _size instead of _bytes.

Changes in v3:
- Back out the API name change to the partition align accessor.
  The API was already released in v72.
- Man page: collapse into one .txt file. 
- Man page: add to Documentation/meson.build 

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
  cxl: add command 'cxl set-partition'

 Documentation/cxl/cxl-list.txt          |  23 +++
 Documentation/cxl/cxl-set-partition.txt |  68 ++++++++
 Documentation/cxl/lib/libcxl.txt        |  12 ++
 Documentation/cxl/meson.build           |   1 +
 cxl/builtin.h                           |   1 +
 cxl/cxl.c                               |   1 +
 cxl/filter.c                            |   2 +
 cxl/filter.h                            |   1 +
 cxl/json.c                              | 113 +++++++++++++
 cxl/lib/libcxl.c                        | 151 ++++++++++++++++-
 cxl/lib/libcxl.sym                      |  10 ++
 cxl/lib/private.h                       |  18 +++
 cxl/libcxl.h                            |  18 +++
 cxl/list.c                              |   2 +
 cxl/memdev.c                            | 206 ++++++++++++++++++++++++
 util/json.h                             |   1 +
 util/size.h                             |   1 +
 17 files changed, 621 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/cxl/cxl-set-partition.txt

-- 
2.31.1

