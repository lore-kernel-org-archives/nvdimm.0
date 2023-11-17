Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1414645F
	for <nvdimm@lists.linux.dev>; Fri, 17 Nov 2023 22:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OITFttQl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700260528; x=1731796528;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PiMVyAJd2EtakTe1T6EhMeFzz7K332PVkpbycCuHGnU=;
  b=OITFttQlI0MrjqX8NEpYLya+t1Id5WLaUBe7Hb/4Ai64jnEQOtC8Dr/S
   vxPVuInrVabKvLGVCMXFW16X1rlzI2ukr/e3lEKbSPRiTVFjerkb1713I
   ziuuHnyH5Hi2HKeDPCVu66xPaik4avOX7GuXhlfOHpBRyA88yE20j4N+j
   Wn24S6KvExssr9ZF+lMoFbunkzfPWTXBM8cLc+ViXnn26IyRa4ZeeD+OY
   2+w3j+oQfSlGwVL+M3bS+TFHZpAKUbl0FrT3CuUEVBkyOXM9FuJLCltsS
   Aav93DXuZsVGAJkYpkmU5Qr7d9hrsEjIdhlbgSKP1c3HQXi+Dwq+iH329
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="376428412"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="376428412"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 14:35:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="831732238"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="831732238"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.159])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 14:35:27 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3 0/5] Support poison list retrieval
Date: Fri, 17 Nov 2023 14:35:19 -0800
Message-Id: <cover.1700258145.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Changes since v2:
- Adjust line break in snprintf (Jonathan, Vishal)
- Replace region|memdev context struct with optional func params (Vishal)
- Include CXL Spec version and update to 3.1 references (Vishal)
- Remove '_poison' descriptor from nested poison objects (Vishal)
- Use existing UTIL_JSON_MEDIA_ERRORS flag (Vishal)
- Replace lengthy if-else with switch-case (Vishal)
- Remove needless fprintf on sysfs fail (Vishal)
- Remove needless jobj inits to NULL (Vishal)
- s/jmedia/jpoison everywhere (Vishal)
- Replace hardcoded memdev w discovered memdev in unit test (Vishal)
- Use test/common define $CXL_TEST_BUS (Vishal)
- Reset rc=1 after setup in unit test (Vishal)
- Add debugfs helpers in unit test (Vishal)
- Syntax fixups in the unit test (Vishal)
- A few minor cleanups in unit test.
- Link to v2:
  https://lore.kernel.org/linux-cxl/cover.1696196382.git.alison.schofield@intel.com/

Changes since v1:
- Replace 'media-error' language with 'poison'.
  At v1 I was spec obsessed and following it's language strictly. Jonathan
  questioned it at the time, and I've come around to simply say poison,
  since that is the language we've all been using for the past year+.
  It also aligns with the inject-poison and clear-poison options that
  have been posted on this list.
- Retrieve poison per region by iterating through the contributing memdevs.
  (The by region trigger was designed out of the driver implementation.)
- Add the HPA and region info to both the by region and by memdev cxl list
  json.
- Applied one review tag to the untouched pid patch. (Jonathan)
- Link to v1:
  https://lore.kernel.org/nvdimm/cover.1668133294.git.alison.schofield@intel.com/


Add the option to include a memory device poison list in cxl list json output.
Examples appended below: by memdev, by region, by memdev and coincidentally
in a region, and no poison found.

Example: By memdev
cxl list -m mem1 --poison -u
{
  "memdev":"mem1",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0x1",
  "numa_node":1,
  "host":"cxl_mem.1",
  "poison":{
    "nr_records":4,
    "records":[
      {
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      },
      {
        "dpa":"0x40001000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      },
      {
        "dpa":"0",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      },
      {
        "dpa":"0x600",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      }
    ]
  }
}

Example: By region
cxl list -r region5 --poison -u
{
  "region":"region5",
  "resource":"0xf110000000",
  "size":"2.00 GiB (2.15 GB)",
  "type":"pmem",
  "interleave_ways":2,
  "interleave_granularity":4096,
  "decode_state":"commit",
  "poison":{
    "nr_records":2,
    "records":[
      {
        "memdev":"mem1",
        "region":"region5",
        "hpa":"0xf110001000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      },
      {
        "memdev":"mem0",
        "region":"region5",
        "hpa":"0xf110000000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      }
    ]
  }
}

Example: By memdev and coincidentally in a region
# cxl list -m mem0 --poison -u
{
  "memdev":"mem0",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0",
  "numa_node":0,
  "host":"cxl_mem.0",
  "poison":{
    "nr_records":1,
    "records":[
      {
        "region":"region5",
        "hpa":"0xf110000000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      }
    ]
  }
}

Example: No poison found
cxl list -m mem9 --poison -u
{
  "memdev":"mem9",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0x9",
  "numa_node":1,
  "host":"cxl_mem.9",
  "poison":{
    "nr_records":0
  }
}

Alison Schofield (5):
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl: add an optional pid check to event parsing
  cxl/list: collect and parse the poison list records
  cxl/list: add --poison option to cxl list
  cxl/test: add cxl-poison.sh unit test

 Documentation/cxl/cxl-list.txt |  64 +++++++++++
 cxl/event_trace.c              |   5 +
 cxl/event_trace.h              |   1 +
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 201 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  47 ++++++++
 cxl/lib/libcxl.sym             |   6 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   2 +
 test/cxl-poison.sh             | 135 ++++++++++++++++++++++
 test/meson.build               |   2 +
 11 files changed, 468 insertions(+)
 create mode 100644 test/cxl-poison.sh


base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.37.3

