Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8959D10E2
	for <nvdimm@lists.linux.dev>; Thu, 18 Jan 2024 00:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705537692; cv=none; b=awqj8UPZwTnJ+j02ady2c2b5istL92PWXoJrwawrZthrYePQOlf6tjqvOK7lqUWxkpZB6+X4Ly0E6FVbEeprZ6ioxxOQBCpxWTbMD9orfnYUTDEiyn2e7sXsA2ytk+kFvO5PQhsN5b3T5mx4/bmHz+5h5qmAhl7pnUGbuLDD+2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705537692; c=relaxed/simple;
	bh=38aiVDRqMk+WzofW3UhVaznWbpUJTdKm6gy0ix9vXZk=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding; b=l1qN8vklN0AoUdhLbj5VXrBpsvk651kvPJ5qCNutiBYQTJUMtKk1bnsRh+XhVwz8DbxpglinhqTS0uzPmSTQfJy1APyHo0R1D/WtMD9e1pLwtNjyrkP99bt7fYIRyUQilYQLqfy1edWt5LT35xMe7JoAeGxMLMu9cHUiDcibQE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PleUzIae; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PleUzIae"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705537690; x=1737073690;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=38aiVDRqMk+WzofW3UhVaznWbpUJTdKm6gy0ix9vXZk=;
  b=PleUzIaea31vcTXg7i9ByQK/5dlfzY9x5fN05Wk8UnLa5V3T/Mu/t8wq
   VjAdIKucl0OHYFfFfujDjtQZ6u78ueeavdd0hk74ncUFs3CjmxFEovAmG
   AJihj7IsTjsTVwhsSUoksDuExS2n5afClk6exmwEs3vNJVChEHf3JLpYW
   ufkeCwim+rrPWgOoqU3hoySEiiEuaKWSOth+bFj+UKFfNGybzWyFqepSq
   vIJgrLiVWiD6cV5uz5MxTqG20KbboDB5AF3XUvvN28UD0gekLP05mHADN
   wcMrWulfq0f/XFhZUh0I/kzHx2D2xtav03YterlWQrdLJzQre9a/HoNH8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18904518"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="18904518"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="777577186"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="777577186"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.110.93])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:28:09 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v6 0/7] Support poison list retrieval
Date: Wed, 17 Jan 2024 16:27:59 -0800
Message-Id: <cover.1705534719.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes since v5:
- Use a private parser for cxl_poison events. (Dan)
  Previously used the default parser and re-parsed per the cxl-list
  needs. Replace that with a private parsing method for cxl_poison.
- Add a private context to support private parsers. 
- Add helpers to use with the cxl_poison parser.
- cxl list json: drop nr_records field (Dan)
- cxl list option: replace "poison" w "media-errors" (Dan)
- cxl list json: replace "poison" w "media_errors" (Dan)
- Link to v5: https://lore.kernel.org/linux-cxl/cover.1700615159.git.alison.schofield@intel.com/


Begin cover letter:

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
        "dpa_length":64,
        "source":"Injected"
      },
      {
        "region":"region5",
        "dpa":1073741824,
        "dpa_length":64,
        "hpa":1035355557888,
        "source":"Injected"
      },
      {
        "region":"region5",
        "dpa":1073745920,
        "dpa_length":64,
        "hpa":1035355566080,
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
        "memdev":"mem1",
        "dpa":1073741824,
        "dpa_length":64,
        "hpa":1035355557888,
        "source":"Injected"
      },
      {
        "memdev":"mem1",
        "dpa":1073745920,
        "dpa_length":64,
        "hpa":1035355566080,
        "source":"Injected"
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

 Documentation/cxl/cxl-list.txt |  71 +++++++++++
 cxl/event_trace.c              |  53 +++++++-
 cxl/event_trace.h              |   9 +-
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 218 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  47 +++++++
 cxl/lib/libcxl.sym             |   6 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   2 +
 test/cxl-poison.sh             | 133 ++++++++++++++++++++
 test/meson.build               |   2 +
 11 files changed, 543 insertions(+), 3 deletions(-)
 create mode 100644 test/cxl-poison.sh


base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.37.3

