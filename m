Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF804C9F
	for <nvdimm@lists.linux.dev>; Thu, 14 Mar 2024 04:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710389129; cv=none; b=Ph6K4zgsAD/TALxO4OUk+kqRdAo23OFf5Nk5Ow/LKGC7n3L9wwKvOAMnTpmDhLqxa56VrwhjtNqypB+gwknrc0eMc6ORjyYuiCSVWiGTtnIk7CZgPUrwNU428Rw2S/zyRAaXKwo6tIhqW9xSTFj3YPEAJifyQgTfrIwVMRvOi/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710389129; c=relaxed/simple;
	bh=EaKbqpHO5xCRlrkZCuvSvii8yZ59ISemW5bsW9qEMWE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WlFfnjl5pDD4ijB7xIIRbP+/2KaML4getBVf9W0mn99BnKm3qYqF7Z/8Uy5odeiqoqw0KzW2OWwpn5PqNRm65azlSLOPYjDUK4Ez/z3Lw9ReO8XkIJl6qy1DtVZNDxiF9vzbZaI/OqViECF2lneWc9a5oF/9D8dygYTRHRthwSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HO6JMiaq; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HO6JMiaq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710389128; x=1741925128;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EaKbqpHO5xCRlrkZCuvSvii8yZ59ISemW5bsW9qEMWE=;
  b=HO6JMiaq40T9Lz9gtVDCZG+nZ9f9yJCJrA5LuWnSnGa00WMv6/PLKhTj
   xJUwM5FuKomK/hO0hFfLgVJNUgv5uasmSn9dtlfr4+PPrMqTPHVCjvDgJ
   q+wx4LDDFxI0gNhMFTCnf9kjfpQ5GpIihnnYgFwcooswytLb606qtQL5G
   K3m8Q4caEP21towO2kc4EyMXcVHsqzljyX35X20O/YdW0wYSydyV/2w2W
   YcJb2SMEBTNvN0aqiC3fvbGfqfrAZUJxt1nFVodBclPgw5OTZRh4W9P1a
   dMy0SgqPBJ5jj57rxVyWWKn/DQcxzBCeX/6Y5hylyJq7bAUBXFHsh76UZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11012"; a="22648790"
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="22648790"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,124,1708416000"; 
   d="scan'208";a="12080666"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.131])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 21:05:26 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v11 0/7] Support poison list retrieval
Date: Wed, 13 Mar 2024 21:05:16 -0700
Message-Id: <cover.1710386468.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes since v10:
- Use offset, length notation in json output (Dan)
- Remove endpoint decoder from json output
- Man page updates to reflect above changes
- Remove open coded tep_find_field() (Dan)
- Use raw instead of custom string helper 
- Use get_field_val() in u8,32,64 helpers instead of _raw (Dan)
- Pass event_ctx to its own parsing method as a typical 'this' pointer (Dan)
- Replace private_ctx w poison_ctx in event_ctx. This addresses Dan's
  feedback to avoid a void* but stops short of his suggestion to wrap
  event_ctx in a private_ctx for this single use case.
- v10: https://lore.kernel.org/linux-cxl/cover.1709748564.git.alison.schofield@intel.com/


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

       In the above example, region mappings can be found using: "cxl list -p
       mem9 --decoders"

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

       In the above example, memdev mappings can be found using: "cxl list -r
       region5 --targets" and "cxl list -d <decoder_name>"



Alison Schofield (7):
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl/event_trace: add an optional pid check to event parsing
  cxl/event_trace: support poison context in event parsing
  cxl/event_trace: add helpers to retrieve tep fields by type
  cxl/list: collect and parse media_error records
  cxl/list: add --media-errors option to cxl list
  cxl/test: add cxl-poison.sh unit test

 Documentation/cxl/cxl-list.txt |  62 ++++++++++-
 cxl/event_trace.c              |  51 ++++++++-
 cxl/event_trace.h              |  19 +++-
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 194 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  47 ++++++++
 cxl/lib/libcxl.sym             |   2 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   3 +
 test/cxl-poison.sh             | 137 +++++++++++++++++++++++
 test/meson.build               |   2 +
 11 files changed, 514 insertions(+), 8 deletions(-)
 create mode 100644 test/cxl-poison.sh


base-commit: e0d0680bd3e554bd5f211e989480c5a13a023b2d
-- 
2.37.3

