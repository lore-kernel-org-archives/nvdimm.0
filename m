Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BCF62A
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 03:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668136812; x=1699672812;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jUkCAYfbxlEUpB+Kch5mmsGnTydZUzk+4WocmIT1Hm4=;
  b=nFgVCsVLadWVzizjCCcxYvWUQIHL3xdTy25bsSo/9MNJT/fmxGsOhe//
   G1Ygkqp7kuSjSqLIUE6VyawYMZIhietpkjH7raIWINiTxWdsmhd1L9/tF
   7nixvI0WjpOa6DD9hdgn3NlXqjV7s0O+Tduj+pJuN5Za8EdAd2ZWxYOma
   9cCQd4KQb1oeJ6rYyaEiz+525UGAgzoqys0fmeE1mkyfjCwL2HYEtIgdo
   l6MnahZEGwHBCC3ROs74ItImdyNVUm69a89lgs5CPJSDizaQt/8KnK1wi
   wno0+1GM5n/3lnmsVncduFp5JE3py7bw//G1MspZ0w3WpZPGN7cMa/s/D
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373638345"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="373638345"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743129950"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743129950"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.161.45])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:11 -0800
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 0/3] Support poison list retrieval
Date: Thu, 10 Nov 2022 19:20:03 -0800
Message-Id: <cover.1668133294.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes RFC->v1:
- Resync with DaveJ's v5 monitor patchset. [1]
  (It provides the event tracing functionality used here.)
- Resync with the kernel patchset adding poison list support. [2]
- Add cxl-get-poison.sh unit test to cxl test suite.
- JSON object naming cleanups, replace spaces with '_'.
- Use common event pid field to restrict events to this cxl list instance.
- Use json_object_get_int64() for addresses.
- Remove empty hpa fields. Add back with dpa->hpa translation.

[1] https://lore.kernel.org/linux-cxl/166803877747.145141.11853418648969334939.stgit@djiang5-desk3.ch.intel.com/
[2] https://lore.kernel.org/linux-cxl/cover.1668115235.git.alison.schofield@intel.com/

The first patch adds a libcxl API for triggering the read of a
poison list from a memory device. Users of that API will need to
trace the kernel events to collect the error records.

Patches 2 adds a PID filtering option to event tracing and then
patches 3 & 4 add a pretty option, --media-errors to cxl list.
The last patch (5) adds a unit test to the cxl test suite.

Examples:
cxl list -m mem2 --media-errors
[
  {
    "memdev":"mem2",
    "pmem_size":1073741824,
    "ram_size":0,
    "serial":2,
    "host":"cxl_mem.2",
    "media_errors":{
      "nr_media_errors":2,
      "media_error_records":[
        {
          "dpa":64,
          "length":128,
          "source":"Injected",
          "flags":"Overflow,",
          "overflow_time":1656711046
        },
        {
          "dpa":192,
          "length":192,
          "source":"Internal",
          "flags":"Overflow,",
          "overflow_time":1656711046
        },
      ]
    }
  }
]

# cxl list -r region5 --media-errors
[
  {
    "region":"region5",
    "resource":1035623989248,
    "size":2147483648,
    "interleave_ways":2,
    "interleave_granularity":4096,
    "decode_state":"commit",
    "media_errors":{
      "nr_media_errors":2,
      "media_error_records":[
        {
          "memdev":"mem2",
          "dpa":0,
          "length":64,
          "source":"Internal",
          "flags":"",
          "overflow_time":0
        },
	{
          "memdev":"mem5",
          "dpa":0,
          "length":256,
          "source":"Injected",
          "flags":"",
          "overflow_time":0
        }
      ]
    }
  }
]

Alison Schofield (5):
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl: add an optional pid check to event parsing
  cxl/list: collect and parse the poison list records
  cxl/list: add --media-errors option to cxl list
  test: add a cxl-get-poison test

 Documentation/cxl/cxl-list.txt |  64 ++++++++++++
 cxl/event_trace.c              |   5 +
 cxl/event_trace.h              |   1 +
 cxl/filter.c                   |   2 +
 cxl/filter.h                   |   1 +
 cxl/json.c                     | 185 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  44 ++++++++
 cxl/lib/libcxl.sym             |   6 ++
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   2 +
 test/cxl-get-poison.sh         |  78 ++++++++++++++
 test/meson.build               |   2 +
 12 files changed, 392 insertions(+)
 create mode 100644 test/cxl-get-poison.sh

-- 
2.37.3

