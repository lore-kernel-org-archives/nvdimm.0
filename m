Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC71D13E7C0
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 18:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750551; cv=none; b=WgiZPibWtLUogVSKdEUWA8fSl/5D4uaJmSatjv/7jDQgtyX4PXaH3NCRFWNTc/uDDfjVA/jZZLL1Vrt0lG4DCmN6gkwl4KZQZfQJx3y7Cha5FlGU4CvqOoarGXcjb0VNRW0X73Jeo+g1qRr43XzV0UTG+uFeIp5rY6hbLo/3DII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750551; c=relaxed/simple;
	bh=Gzo7tfYAFi9IZGWe3CFYwrYmh9mt784+NMEaUejByRM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jaf1BLP6GbEq3vCwIzfh/9SVgIY4yzxrO7NCThS2XFGDIIzS3lg7pBs0IvqObGfLscv1EjPE3YQmS9FwvM1SgWBl7uYEj5qSu/N7JErw9eRxWwZ4R3Wjln61Vd+Ah+/8BwFhHnhW6LME4fnwgN72wpJRcvm/WUmPl4IpwuK6LlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EZaePpAt; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EZaePpAt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709750550; x=1741286550;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Gzo7tfYAFi9IZGWe3CFYwrYmh9mt784+NMEaUejByRM=;
  b=EZaePpAtv6RvmyF4y0QLIBT0CzZ6l1bZgLLDwA+Pcu1IXBDssG/Ebzhk
   0rr9dp9p8I4dSsN7vaNSeKRW1WXhY6WpcR3V8Rp4gXUHLUS1azPaI922L
   1Q7kXS+3soLYjpt80tzOdgusg3VEpYZrwpqmlQDpdfzUa3Y+BAUJATpl3
   M5ynOH3SZfCeK3BPkEWKsx7W6Qkz6k/rzM+mqtyGGZK614E2RBBJ9+dg2
   NDQHRUeiQ/nKU2SGffRB3ibLFoQjAnkzA2YY9U1AY/P6Sss0QgAorFP6f
   gih0i3adcfnBOUW24K6IIQZ0ZZK1dvvb35ol8DMraKUqauvOBwnWRahZc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15819817"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15819817"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9925958"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.9.155])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:29 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v10 0/7] Support poison list retrieval
Date: Wed,  6 Mar 2024 10:42:19 -0800
Message-Id: <cover.1709748564.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes since v9:
- Replace the multi-use 'name' var, with multiple descriptive
  flavors: memdev_name, region_name, decoder_name (DaveJ)
- Use a static string table for poison source lookup (DaveJ)
- Rebased on latest pending
Link to v9: https://lore.kernel.org/r/cover.1709253898.git.alison.schofield@intel.com/


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
  cxl/event_trace: add helpers to retrieve tep fields by type
  cxl/list: collect and parse media_error records
  cxl/list: add --media-errors option to cxl list
  cxl/test: add cxl-poison.sh unit test

 Documentation/cxl/cxl-list.txt |  79 +++++++++-
 cxl/event_trace.c              |  82 ++++++++++-
 cxl/event_trace.h              |  14 +-
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 257 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  47 ++++++
 cxl/lib/libcxl.sym             |   2 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   3 +
 test/cxl-poison.sh             | 137 ++++++++++++++++++
 test/meson.build               |   2 +
 11 files changed, 624 insertions(+), 4 deletions(-)
 create mode 100644 test/cxl-poison.sh


base-commit: e0d0680bd3e554bd5f211e989480c5a13a023b2d
-- 
2.37.3

