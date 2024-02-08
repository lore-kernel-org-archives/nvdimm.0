Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C2D1E497
	for <nvdimm@lists.linux.dev>; Thu,  8 Feb 2024 01:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707354121; cv=none; b=FFbALr2QH7wTh1shHF7L4Z2Ugt+TLX1iYNP8yYnp2ugCtkrievAI1/pcRx/kJYfTiMpKPui+GsoT9mcOaxQrdM8Qqe2o+TR2eF6qZrO+qAgXy3O/FVpnK9cZNFTDE4T4HMGqTCLRlHeQQF9BFnSNeroC6kNLvE1soToj7VAnNkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707354121; c=relaxed/simple;
	bh=JBTcvj2cPgAZOhyGTx563pqYvLf2niFuF6dZRKXFC6Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EFtuZYDF3OBmjjYlabvdDQI9U3u5jAmV+bKASgMLVOFECkTQfDVFePNrFzuOrQw1kW2JpgpPWhroh9C+K7PnYmXiEdEn2i20SgGSqIJwgi5XR0CfabT5t0k0NGCL9hP7GFzDI5Afyx39j4P+HDQ6dzVVZHLpy+Q71DwHLmCyuk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VfSTD+V5; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VfSTD+V5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707354119; x=1738890119;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JBTcvj2cPgAZOhyGTx563pqYvLf2niFuF6dZRKXFC6Q=;
  b=VfSTD+V5E49IZvTeEDumgEGopL23Z4EeTIIvcZFINK5/GgPoVTUnt2MA
   ykOvuaLT3Q1tsvQJGTwRRzug5YObrQHWvUA/et3rJQzC7Sa/vx1BsADh9
   kLN3cYS3kOEKbAHVxSC0Y7h4sqfkY7QAKvUA5X+1BAmyZaO1JWPQMoPij
   5FJbjSrj/WEvF7K7e75v42+l4ZUA+bG9JCT5a3b0OIReX8atHq2DdZ34g
   UdUFI9RkFr70LhW7u7q6D/lwkah94NskRcsXp9vNuRpiEFm1xcQxwfYzQ
   wHQdp0+pNOo30bi0wE8jd0xyJiNwf2tFgsRdRhZcD8HPmIjQkUIhSqiwR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="18629882"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="18629882"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 17:01:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="1529241"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.105.224])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 17:01:49 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v7 0/7] Support poison list retrieval
Date: Wed,  7 Feb 2024 17:01:39 -0800
Message-Id: <cover.1707351560.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes since v6:
- Remove region and memdev names from json media-error record (Dan)
- Rename dpa_length to length in json media-error record (Dan)
- Add the endpoint decoder name to json media-error record (Dan)
- Document the 'Source' field in the cxl-list man page (Dan)
- Add media-errors to -vvv option
- cxl/test: Set nr_found to 0 directly, when poison list is empty
- cxl/test: Remove leftover -r in cxl list command
- Picked up a few Reviewed-by tags (DaveJ)
Link to v6: https://lore.kernel.org/linux-cxl/cover.1705534719.git.alison.schofield@intel.com/


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
 cxl/lib/libcxl.sym             |   6 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   3 +
 test/cxl-poison.sh             | 137 +++++++++++++++++
 test/meson.build               |   2 +
 11 files changed, 598 insertions(+), 4 deletions(-)
 create mode 100644 test/cxl-poison.sh


base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.37.3

