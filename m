Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADE4443B
	for <nvdimm@lists.linux.dev>; Thu, 13 Oct 2022 23:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665704347; x=1697240347;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6gEW5eDpcXcP9ftEKEoxli8QEZf2PjnG400RLgjW1jc=;
  b=SkdjdVSFqdtR/0XVcxRacMpVZ/hUQsQYkZMgyPzK659DeTOuyHUJpbeG
   LVGT+4DZ/uDN6SYMn9qvEtMZJJlYbCfA1ph042Wt0ZWP2gUp6jeQKUIM8
   Caoh58GZtGdegkVqUfmKbtGAHH5pVmsVgt+EhNYijjLqcOReJKI/70x88
   2htfLgFjXqn2qdCtu8oL5K8c1kFj3h90XhUKaVhjaEhSGglrHpCbWWGCA
   3xL6Bhbh/j8MabC0/Mso55yqsmZGG7fxGxV53CZZ1hnb5SRX+81oF5jzd
   PhOweYJSL5KefHb1h9jQwdCKcCJYPXw3TOFC1kqew6C92p9c+HuywBqK4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="285620549"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="285620549"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:39:06 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="872527636"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="872527636"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.171.186])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 16:39:05 -0700
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl RFC 0/3] Support poison list retrieval
Date: Thu, 13 Oct 2022 16:39:00 -0700
Message-Id: <cover.1665699750.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The RFC label is because this is built upon in flight patchsets
making it unlikely others can try it out. It depends upon the
tracing support in Dave's monitor patchset [1], and the kernel
driver support for poison in this patchset [2].

The first patch adds a libcxl API for triggering the read of a
poison list from a memory device. Users of that API will need to
trace the kernel events to collect the error records.

Patches 2 & 3 offer a pretty option, --media-errors to cxl list 
where the the poison list is read, results collected and parsed,
and the media error records included in the JSON list output.

The JSON output of 'cxl list' does not include all the same fields
that are available in the 'cxl_poison' trace event.

Trace events of 'cxl_poison' always include these fields:
region: memdev: pcidev: hpa: dpa: length: source: flags: overflow_time:

'cxl list --media-errors' omits fields that seem useless in the
context of the cxl list command:
- Do not repeat the memdev, region, or pcidev's that are
  already included in the list output.
- Only include 'hpa' when media errors are listed by region.

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
      "nr media-errors":2,
      "media-error records":[
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
      "nr media-errors":2,
      "media-error records":[
        {
          "memdev":"mem2",
          "hpa":0,
          "dpa":0,
          "length":64,
          "source":"Reserved",
          "flags":"",
          "overflow_time":0
        },
	{
          "memdev":"mem5",
          "hpa":0,
          "dpa":384,
          "length":256,
          "source":"Injected",
          "flags":"",
          "overflow_time":0
        }
      ]
    }
  }
]

[1] https://lore.kernel.org/nvdimm/166363103019.3861186.3067220004819656109.stgit@djiang5-desk3.ch.intel.com/
[2] https://lore.kernel.org/linux-cxl/cover.1665606782.git.alison.schofield@intel.com/

Alison Schofield (3):
  libcxl: add interfaces for GET_POISON_LIST mailbox commands
  cxl/list: collect and parse the poison list records
  cxl/list: add --media-errors option to cxl list

 Documentation/cxl/cxl-list.txt |  66 +++++++++++
 cxl/filter.c                   |   2 +
 cxl/filter.h                   |   1 +
 cxl/json.c                     | 197 +++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.c               |  40 +++++++
 cxl/lib/libcxl.sym             |   6 +
 cxl/libcxl.h                   |   2 +
 cxl/list.c                     |   2 +
 8 files changed, 316 insertions(+)

-- 
2.37.3

