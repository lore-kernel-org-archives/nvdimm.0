Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73612173
	for <nvdimm@lists.linux.dev>; Mon,  3 Jan 2022 20:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641240691; x=1672776691;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8sDi/Kimq1iHRQaPdk6q5S1OO9Z52op8jc+WHkJVM30=;
  b=DKu3Ve0+2Cue/2Pd8SYB/CD+JEBBzA+YMMDhyB2H0p1lIozV3v2MRcBr
   aYguFVSxM3m6KKhQVHDpAfmNmtawfEP/APRxphgWq1U5poOh9UG2QKfD2
   8BwAlcMbvcfVK0AsogpOqxZPYJAhxRwMEZKpcpiW1rbUsMwkX6poOHho0
   gB8nmtVbWyGv2MLGjesPN8p29K7//Hna0RxU/RY3ZAXLuKKe7XS8APuql
   lHo/ix437a+B7CR9eUJuhsda81a0+wLgcWR1M0h6N06akhV6YLyrRKeNJ
   ov9d4lv7DI68PIpvb+ce5BGxT2rdD3UjOoOKjTeh0vdxBl8bz2KEGTTBA
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="229426818"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="229426818"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="512201586"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:30 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 0/7] Add partitioning support for CXL memdevs
Date: Mon,  3 Jan 2022 12:16:11 -0800
Message-Id: <cover.1641233076.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

To support changing partitions on CXL memdevs, first provide access
to device partitioning info. The first 4 patches add accessors to all
the partition info a CXL command parser needs in order to validate
the command. This info is added to cxl list to assist the user in
creating valid partition requests.

# cxl list -MP
[
  {
    "memdev":"mem0",
    "pmem_size":0,
    "ram_size":273535729664,
    "partition":{
      "active_volatile_capacity":273535729664,
      "active_persistent_capacity":0,
      "next_volatile_capacity":268435456,
      "next_persistent_capacity":273267294208,
      "total_capacity":273535729664,
      "volatile_only_capacity":0,
      "persistent_only_capacity":0,
      "partition_alignment":268435456
    }
  }
]

Next introduce libcxl ioctl() interfaces for the SET_PARTITION_INFO
mailbox command and the new CXL command. cxl-cli does the constraints
checking. It does not offer the IMMEDIATE mode option since we do not
have driver support for that yet.

# cxl set-partition-info
 usage: cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]

    -v, --verbose         turn on debug
    -s, --volatile_size <n>
                          next volatile partition size in bytes

Guessing that a libcxl user could send the SET_PARTITION_INFO mailbox
command outside of cxl-cli tool, so a kernel patch that disables the
immediate bit, on the receiving end of the ioctl, follows.

It may be simpler to block the immediate bit in the libcxl API today,
(and as I write this cover letter I'm wondering just how far this goes
astray ;)) However, the kernel patch to peek in the payload sets us on
the path of inspecting set-partition-info mailbox commands in the future,
when immediate mode support is required.

Testing - so far I've only tested w one memdev in a Simics env. So,
next will be growing that Simics config, using cxl_test env, and 
adding a unit test.

Alison Schofield (7):
  libcxl: add GET_PARTITION_INFO mailbox command and accessors
  libcxl: add accessors for capacity fields of the IDENTIFY command
  libcxl: apply CXL_CAPACITY_MULTIPLIER to partition alignment field
  cxl: add memdev partition information to cxl-list
  libcxl: add interfaces for SET_PARTITION_INFO mailbox command
  ndctl, util: use 'unsigned long long' type in OPT_U64 define
  cxl: add command set-partition-info

 Documentation/cxl/cxl-list.txt               |  23 ++++
 Documentation/cxl/cxl-set-partition-info.txt |  27 +++++
 Documentation/cxl/partition-description.txt  |  15 +++
 Documentation/cxl/partition-options.txt      |  19 +++
 Documentation/cxl/Makefile.am                |   3 +-
 cxl/builtin.h                                |   1 +
 cxl/lib/private.h                            |  19 +++
 cxl/libcxl.h                                 |  12 ++
 util/json.h                                  |   1 +
 util/parse-options.h                         |   2 +-
 util/size.h                                  |   1 +
 cxl/cxl.c                                    |   1 +
 cxl/lib/libcxl.c                             | 117 ++++++++++++++++++-
 cxl/lib/libcxl.sym                           |  11 ++
 cxl/list.c                                   |   5 +
 cxl/memdev.c                                 |  89 ++++++++++++++
 util/json.c                                  | 112 ++++++++++++++++++
 17 files changed, 455 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/cxl/cxl-set-partition-info.txt
 create mode 100644 Documentation/cxl/partition-description.txt
 create mode 100644 Documentation/cxl/partition-options.txt

-- 
2.31.1

