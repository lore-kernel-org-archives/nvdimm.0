Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C464E38D
	for <nvdimm@lists.linux.dev>; Sun,  1 Oct 2023 22:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696199498; x=1727735498;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mNZCtacselnHK6TIb/FXBVQDGDeXn2BK/qzQuSIP0ok=;
  b=BR6CjOeOLDuGv+0QyGKt9/MQAUySK7L3uMFKpiW/O/oLz5s8yBuSdiix
   O827HCjcKRWpgidbKOKzbHTghMoZuTIqF5UzdqIkTj47gaO4SoP8inHce
   hCS0TiiWddYYmwihF6xura4egS3c5w3LHdYkxPCZ+jfZNXkzBDg03bUtu
   +L+y8dQKFYf6IktNVvWuVH52dK83IqFsTa+xALKWtOMNv+mVYnefRFyUD
   JLw5xahVw5eTf9qRbyP+mbyIP++4/E1SM5jp2qqEcZSrefWoB15DPD+bz
   sCRCNMEn8aKBiTSv+FjTdNYIZkv3Ca02OhSUhELjf2ee0bVGGwq0CIzqL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="367618307"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="367618307"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 15:31:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10850"; a="779781944"
X-IronPort-AV: E=Sophos;i="6.03,193,1694761200"; 
   d="scan'208";a="779781944"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.20.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 15:31:37 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v2 0/3] Support poison list retrieval
Date: Sun,  1 Oct 2023 15:31:30 -0700
Message-Id: <cover.1696196382.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

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
    "nr_poison_records":4,
    "poison_records":[
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
    "nr_poison_records":2,
    "poison_records":[
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
    "nr_poison_records":1,
    "poison_records":[
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
    "nr_poison_records":0
  }
}

Alison Schofield (5):
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl: add an optional pid check to event parsing
  cxl/list: collect and parse the poison list records
  cxl/list: add --poison option to cxl list
  cxl/test: add cxl-poison.sh unit test

 Documentation/cxl/cxl-list.txt |  64 ++++++++++
 cxl/event_trace.c              |   5 +
 cxl/event_trace.h              |   1 +
 cxl/filter.h                   |   3 +
 cxl/json.c                     | 208 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  47 ++++++++
 cxl/lib/libcxl.sym             |   6 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   2 +
 test/cxl-poison.sh             | 103 ++++++++++++++++
 test/meson.build               |   2 +
 util/json.h                    |   1 +
 12 files changed, 444 insertions(+)
 create mode 100644 test/cxl-poison.sh


base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.37.3

