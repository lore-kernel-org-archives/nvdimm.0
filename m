Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D43B64C
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 02:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708654549; cv=none; b=kR6vhZ0g4i8rVuIIqGIkHekpi66VqkhWdxu8GV2vWeKhqhIeG9VRVg8JOrpYPnMospVO0GwQEvdDcznG3g1A+8v5wzlaumsCI3Th6beJ4qcDdwNLNuIwvUigi2NRK42rsskKM3iiNbyTIo8Hr/HH4w/144JRJrbeYDlcWzkDL0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708654549; c=relaxed/simple;
	bh=JUk20NwqniwQOmI3I6NLl+FmxdepcVpTY73qzNzSgFA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a1651kBDpmoPlPbrN3z62MeTi4PxUbxUGIlUzSn46rmceHM6kUkEaz+7+EonIS16k1/x1MVF5bHQwrrDO5rvQlebJXKjRxoH6IyrCNGPhA1KU94NrivAXe70QzZ1M9RxJ0h0qWq2qyamUJ8h7a3EoXmEPFT+0azT7j779VhpbV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BGVCs7ji; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BGVCs7ji"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708654547; x=1740190547;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JUk20NwqniwQOmI3I6NLl+FmxdepcVpTY73qzNzSgFA=;
  b=BGVCs7jiZZE2GlQXVwBVyiQlZMO/+xNGIkuwgP8g7CybWyRHNFzvjuJo
   b9COqpmp7GxbL4OxCaQ0TK2RY3+BIV+5B1HgSphJkdNIxr9b9K4kTrTu/
   6zo9IfqhsS0zSOr9yMLpaSUdyK8VuZxj4MIfFR6RvAc2p7uIjHCxjHwIW
   ekNFxHu+y85iUEFDRcyS7yikEXi8lcwE1nAHngd2g6gf8MHAVZSul1nUG
   jOge6m0xzcj83c1UcsTjzl7V//AkXq5C+crceHhP9N6MjpDz1rBq3T477
   o6Zu6KdDCU2O1lyezUqSU5SSpgAPbpVOFJctcSEapTdprWVdzqtTZ5YzL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="14364237"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="14364237"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10410078"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:46 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v8 0/7] Support poison list retrieval
Date: Thu, 22 Feb 2024 18:15:37 -0800
Message-Id: <cover.1708653303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes since v7:
- Replace spaces w tab in cxl-poison.sh unit test (Vishal)
- Rebase to latest ndctl/pending branch
Link to v7: https://lore.kernel.org/nvdimm/cover.1707351560.git.alison.schofield@intel.com/


Add the option to add a memory devices poison list to the cxl-list
json output. Offer the option by memdev and by region. Sample usage:

# cxl list -m mem1 --media-errors
[
  {
    "memdev":"mem1",
    "pmem_size":1073741824,
    "ram_size":1073741824,
    "serial":1,
    "numa_node":1,
    "host":"cxl_mem.1",
    "media_errors":[
      {
        "dpa":0,
        "length":64,
        "source":"Internal"
      },
      {
        "decoder":"decoder10.0",
        "hpa":1035355557888,
        "dpa":1073741824,
        "length":64,
        "source":"External"
      },
      {
        "decoder":"decoder10.0",
        "hpa":1035355566080,
        "dpa":1073745920,
        "length":64,
        "source":"Injected"
      }
    ]
  }
]

# cxl list -r region5 --media-errors
[
  {
    "region":"region5",
    "resource":1035355553792,
    "size":2147483648,
    "type":"pmem",
    "interleave_ways":2,
    "interleave_granularity":4096,
    "decode_state":"commit",
    "media_errors":[
      {
        "decoder":"decoder10.0",
        "hpa":1035355557888,
        "dpa":1073741824,
        "length":64,
        "source":"External"
      },
      {
        "decoder":"decoder8.1",
        "hpa":1035355566080,
        "dpa":1073745920,
        "length":64,
        "source":"Internal"
      }
    ]
  }
]


Alison Schofield (7):
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl: add an optional pid check to event parsing
  cxl/event_trace: add a private context for private parsers
  cxl/event_trace: add helpers get_field_[string|data]()
  cxl/list: collect and parse media_error records
  cxl/list: add --media-errors option to cxl list
  cxl/test: add cxl-poison.sh unit test

 Documentation/cxl/cxl-list.txt |  79 +++++++++-
 cxl/event_trace.c              |  53 ++++++-
 cxl/event_trace.h              |   9 +-
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 261 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  47 ++++++
 cxl/lib/libcxl.sym             |   2 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   3 +
 test/cxl-poison.sh             | 137 +++++++++++++++++
 test/meson.build               |   2 +
 11 files changed, 594 insertions(+), 4 deletions(-)
 create mode 100644 test/cxl-poison.sh


base-commit: 4d767c0c9b91d254e8ff0d7f0d3be04a498ad9f0
-- 
2.37.3

