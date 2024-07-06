Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5D3C8F3
	for <nvdimm@lists.linux.dev>; Sat,  6 Jul 2024 06:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247101; cv=none; b=NwBRTzmPWQQBQrv3ltKynM3A4RGgSHuOAMd8SdSm9R2aN7oUgyDmey0sdjpYN+qFw+YNt8MvSt7zcEa95vBDSeiuZF6iyDilD17wD6LrPTYUSoYnMAJWRuCji+ObBhj8CRk0jyH5VUc3WQenfqne2d/hb4F9DihGCo5L8UzUebI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247101; c=relaxed/simple;
	bh=GdL/hQ7B038iaETrQENZY+mXI0lOSi4SnxnZJKroKo0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KwZstZEQ37keuzX3BeME2XMtJCxnrXl/WJSRgsYkyh4jjQkZhB3QFZQrMwkCI/BKUUJPqanMZIK9f2cpzlsMjSWNCWsKiujS1QZGrLvlPrT8rGzYe4MUgTRAfnoyS4tiOZktX8iXtTGkb4U8+s2WKWJPJC6anMgiBjaZv0/bteE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bhARBjYp; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bhARBjYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720247099; x=1751783099;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GdL/hQ7B038iaETrQENZY+mXI0lOSi4SnxnZJKroKo0=;
  b=bhARBjYpHfYnTQOQgELTclx1KzEghuL3cU19ryaYJEE6T5YrE4Uq6Ut3
   Gn3/A5QbJxISl+5yL3JQgfjiS8sFI+XZweHCo2DU7ZAYpV2yNOl/s5+V3
   Ig0pUeonJ1FyhdGWfst6SSXTvYDgii5fuK8ZmWblHeAizfDLKL+qIf/ny
   dpOOJrYCAyOe0a8EWoxIOWsnhYQEpH2FfUAe2dfqoySpT01aMtOdDDHz4
   UaHCOZneL0bQURnwCPfEQ+eQRCe8sRE7JCxc3D386iddcw0PsM5KZuwh/
   nJETXBiZTGBRK6W0fvX6cjZnAE9ikjp3oIzKvdEhiXfxXujTsmQxLlH5K
   w==;
X-CSE-ConnectionGUID: 40WApSnhSMCHbI+mDxoJaw==
X-CSE-MsgGUID: 4xlwEW27Q9OqbRBwppy1DA==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17166924"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17166924"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:24:58 -0700
X-CSE-ConnectionGUID: k5oQ35zWThikLMLdijeGQQ==
X-CSE-MsgGUID: 0jmJrseESPCmrDuO4PQMHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="78172481"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.72.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:24:58 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v13 0/8] Support poison list retrieval
Date: Fri,  5 Jul 2024 23:24:46 -0700
Message-Id: <cover.1720241079.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>


Patches 1 & 3 need review.

Changes since v12:
- There were no responses on the mailing list to v12.
- Remove add-on query suggestions from the --media-errors section of
  the man page. Developers continue to debate what the user needs in
  regard to cxl list queries beyond the basic list by memdev and by
  region. The only direct user feedback is that they want the poison
  list capability added to ndctl. Since the command line query and the
  json output are solid, move ahead and get this into the hands of 
  users. Let the user experience drive enhanced queries.
Link to v12:
https://lore.kernel.org/cover.1711519822.git.alison.schofield@intel.com/


Begin cover letter:

Add the option to add a memory devices poison list to the cxl-list
json output. Offer the option by memdev and by region. 

From the man page cxl-list:

       -L, --media-errors
           Include media-error information. The poison list is retrieved from
           the device(s) and media_error records are added to the listing.
           Apply this option to memdevs and regions where devices support the
           poison list capability. "offset:" is relative to the region
           resource when listing by region and is the absolute device DPA when
           listing by memdev. "source:" is one of: External, Internal,
           Injected, Vendor Specific, or Unknown, as defined in CXL
           Specification v3.1 Table 8-140.

           # cxl list -m mem9 --media-errors -u
           {
             "memdev":"mem9",
             "pmem_size":"1024.00 MiB (1073.74 MB)",
             "pmem_qos_class":42,
             "ram_size":"1024.00 MiB (1073.74 MB)",
             "ram_qos_class":42,
             "serial":"0x5",
             "numa_node":1,
             "host":"cxl_mem.5",
             "media_errors":[
               {
                 "offset":"0x40000000",
                 "length":64,
                 "source":"Injected"
               }
             ]
           }

           # cxl list -r region5 --media-errors -u
           {
             "region":"region5",
             "resource":"0xf110000000",
             "size":"2.00 GiB (2.15 GB)",
             "type":"pmem",
             "interleave_ways":2,
             "interleave_granularity":4096,
             "decode_state":"commit",
             "media_errors":[
               {
                 "offset":"0x1000",
                 "length":64,
                 "source":"Injected"
               },
               {
                 "offset":"0x2000",
                 "length":64,
                 "source":"Injected"
               }
             ]
           }



Alison Schofield (8):
  util/trace: move trace helpers from ndctl/cxl/ to ndctl/util/
  util/trace: add an optional pid check to event parsing
  util/trace: pass an event_ctx to its own parse_event method
  util/trace: add helpers to retrieve tep fields by type
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl/list: collect and parse media_error records
  cxl/list: add --media-errors option to cxl list
  cxl/test: add cxl-poison.sh unit test

 Documentation/cxl/cxl-list.txt |  56 +++++++++-
 cxl/event_trace.h              |  27 -----
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 195 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  53 +++++++++
 cxl/lib/libcxl.sym             |   6 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   3 +
 cxl/meson.build                |   2 +-
 cxl/monitor.c                  |  11 +-
 test/cxl-poison.sh             | 137 +++++++++++++++++++++++
 test/meson.build               |   2 +
 {cxl => util}/event_trace.c    |  68 +++++++++---
 util/event_trace.h             |  42 +++++++
 14 files changed, 558 insertions(+), 49 deletions(-)
 delete mode 100644 cxl/event_trace.h
 create mode 100644 test/cxl-poison.sh
 rename {cxl => util}/event_trace.c (76%)
 create mode 100644 util/event_trace.h


base-commit: 16f45755f991f4fb6d76fec70a42992426c84234
-- 
2.37.3

