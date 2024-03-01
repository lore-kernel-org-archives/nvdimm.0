Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8B2B9CE
	for <nvdimm@lists.linux.dev>; Fri,  1 Mar 2024 01:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709256687; cv=none; b=qV1UNYPVosiPxVTbx+laE0GW9yMSvDcZU/xjdn70g9Nx51UVseT1/LwiidzRgpkb4uTkZCqkOfSXk2wxcpTSxRJuaQw+KduI3gDmky+tjEvj4sWBWHxA6QLYdsjV2TDZP7HIpkRP93cK6pt9Q9PZlSupz+vxWgAybeNL977Esl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709256687; c=relaxed/simple;
	bh=IFfgLL/7iKupxJb0Z3p3injTxjdnIk4kJXJWMRr4s2U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l5fzH1GcVvbMQ/t8Hba5cDFUFPsOdSMNj7PQwSsmh64PKAEPxCCgK3HtivAHWX3Or5QQYgtiX64Hq2624alN+1XOEu9USe69749onJ14V0Qe/Pv5pIoi4k+XgL7ucK8XlTMhcE1bYRRe3KstSfxdhxXSR16VeQbnrblADTdSnGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KcREh7Jd; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KcREh7Jd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709256684; x=1740792684;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IFfgLL/7iKupxJb0Z3p3injTxjdnIk4kJXJWMRr4s2U=;
  b=KcREh7Jdudb6feafRrGsiCqKBau9tOJWU85DEe5mFTg7/OIC1UPXzQGS
   bqoKIdideMV8qicH6wcjJGQriZhQKa+PZf8SwSx7ouZkzjLrz+XC/Tcqo
   akQOxWBtI/z/waMaughTKM4oNwtMa4p0SjGijJxjEtoG2otGyw7xjQSlq
   /RzEZpj5+I/UrvhipBA3tqzlKo3muB4duszl7NBqm7SlCEvbGPGWrvasc
   h9VNpQj606V+ugkbxjZUMJUCOBNR6l1kXK2dDnXw1hNzPcrfx3E57F/sQ
   MgARG/6LrMiU2/JHFPQUCFBBMyxGJZjApf6DFSfhoIOpYII6cQXRWia99
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="14343101"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="14343101"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 17:31:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7952651"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.136.104])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 17:31:24 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v9 0/7] Support poison list retrieval
Date: Thu, 29 Feb 2024 17:31:15 -0800
Message-Id: <cover.1709253898.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes since v8:
Patch 4/7 cxl/event_trace: add helpers to retrieve tep fields by type
- Add type specific helpers. Avoids the casting in next patch (DaveJ)
- Remove DaveJ tag due to changes

Patch 5/7 cxl/list: collect and parse media_error records
- Avoid goto block by adding helper func find_memdev() (DaveJ)
- Out-dent the success return buried in cxl_decoder_foreach()
- Use updated cxl_get_field_* helpers (DaveJ)
- Add a 'goto put_obj' to unify the put on exit (DaveJ)

- Rebased on latest pending
Link to v8: https://lore.kernel.org/nvdimm/cover.1708653303.git.alison.schofield@intel.com/


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
 cxl/event_trace.c              |  82 +++++++++-
 cxl/event_trace.h              |  14 +-
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 271 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  47 ++++++
 cxl/lib/libcxl.sym             |   2 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   3 +
 test/cxl-poison.sh             | 137 +++++++++++++++++
 test/meson.build               |   2 +
 11 files changed, 638 insertions(+), 4 deletions(-)
 create mode 100644 test/cxl-poison.sh


base-commit: ffbbb0bc246d967d53821184047f1121e02f8a81
-- 
2.37.3

