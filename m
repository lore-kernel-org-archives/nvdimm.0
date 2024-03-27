Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2EB14F9C2
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569156; cv=none; b=OOTMik8ZQmBQciPwexC0WXtIzeajx6THaapLi/rb47osGdkI1Xd0/wJNJw43Se2T39g2ZuW+P92rU5absL+SanDQhEeAdFD1Wu3I5fYTI5WZFbo8qMgLcPBx2x5mkqDg25XC/FvINZ+ilgELJzEfrV4YlpHCCi97B0HQyIttARM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569156; c=relaxed/simple;
	bh=Q2UPIhtNNUSN5/C2e5PMoE6y7079jsFhRQ6eGMqKJvA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TOjDG58EK2zdTMJYkN/fY5tLeRx3iufeo9K3XaaZgSOWaqN8gPDthUh32tSk+0yiITXHXIZ18xTUtY8Gnf6HcFDzS/rBalFYVR97Em0FX7LpHbYuZ1JUj31Q3aCmlgjzqXAAvlsvISaCJwm3GSz486CnRO/ZPX6JczlnUpmZ0xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScEwIBbu; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScEwIBbu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569155; x=1743105155;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Q2UPIhtNNUSN5/C2e5PMoE6y7079jsFhRQ6eGMqKJvA=;
  b=ScEwIBbuT5b0poW5L3WGqLx4A0SDlQqg9/ULxBlDyGx+tKCK6ra1oTQC
   EmPfQzjbNOlDJRxWPuWNAYf8rFWpwTUqfAFiBtS28HJpTKOn0s513ejO7
   oIU6wLw0NZcgDjAuG6ZjBaJw17jidwA/nanxAc+zMdgavbBC+ezn1bjP0
   gNTF9cEzdjaSmG2mZSK8gY9FOFiMgBZUegPNq+XOIuQRNhvD3GKIoTPJW
   scXYLqRcj8pJSv3K1IunfSclNU4Y346dy3w2Y9a6RtmQyHhQuZtu0sa0o
   mU8JS0unxqtIIqez0LPsSNtzf/SJ26NcChy2SW1SiWM6OWv9SpKuoQKxI
   w==;
X-CSE-ConnectionGUID: hvPI4a+sQ+m1e6B0C8JMJw==
X-CSE-MsgGUID: pcbwJj5fRaa5F37O5XMmNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6560193"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6560193"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="47616288"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:34 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v12 0/8] Support poison list retrieval
Date: Wed, 27 Mar 2024 12:52:21 -0700
Message-Id: <cover.1711519822.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes since v11:
- Remove needless rc init (DaveJ)
- Update man page examples (Wonjae, Dan)
- Replace fprintf() w err() in libcxl.c  (Fan)
- Update stale --poison comment in unit test (Wonjae)
- Move ndctl/cxl/event_trace.c/.h to ndctl/util/  (Dan)
- Constify the pointer in poison_source array declaration
- Move the json flags from the poison_ctx to event_ctx
- Move intro of poison_ctx to parsing patch, Patch 6
- Add unsupported feature err() message in libcxl.c 
- v11: https://lore.kernel.org/cover.1710386468.git.alison.schofield@intel.com/


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

           More complex cxl list queries can be created by using cxl list object
           and filtering options. The first example below emits all the endpoint
           ports with their decoders and memdevs with media-errors. The second
           example filters that output further by a single memdev.

              # cxl list -DEM -p endpoint --media-errors
              # cxl list -DEM -p mem9 --media-errors


Alison Schofield (8):
  util/trace: move trace helpers from ndctl/cxl/ to ndctl/util/
  util/trace: add an optional pid check to event parsing
  util/trace: pass an event_ctx to its own parse_event method
  util/trace: add helpers to retrieve tep fields by type
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl/list: collect and parse media_error records
  cxl/list: add --media-errors option to cxl list
  cxl/test: add cxl-poison.sh unit test

 Documentation/cxl/cxl-list.txt |  64 ++++++++++-
 cxl/event_trace.h              |  27 -----
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 195 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  53 +++++++++
 cxl/lib/libcxl.sym             |   2 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   3 +
 cxl/meson.build                |   2 +-
 cxl/monitor.c                  |  11 +-
 test/cxl-poison.sh             | 137 +++++++++++++++++++++++
 test/meson.build               |   2 +
 {cxl => util}/event_trace.c    |  68 +++++++++---
 util/event_trace.h             |  42 +++++++
 14 files changed, 562 insertions(+), 49 deletions(-)
 delete mode 100644 cxl/event_trace.h
 create mode 100644 test/cxl-poison.sh
 rename {cxl => util}/event_trace.c (76%)
 create mode 100644 util/event_trace.h


base-commit: 5e9157d6721a878757f0fe8a3c51f06f9e94934a
-- 
2.37.3

