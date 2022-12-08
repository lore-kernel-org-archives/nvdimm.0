Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5DBA460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534879; x=1702070879;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vw3oms0hnl8LXxP/apk+TW2e4HdqRS+/eafSIfXtQtA=;
  b=TCiIYGXDcEZRONXIvcTA+u7Hf9ZR+znFjsCSuXx/dBiLzlNAL6IrKhGf
   xKx4a+MxTonW9yhg1sA3DYQJTYVXMFPlnT6WQZ8Mgt634UaqyK39JbrDy
   mT7Vkfq5JBqt+7Q5nhIu5R09a/8JZ4M+5WkINqkoZLurDsgJWb6wDi6j3
   exHtvgnAlcoqidyAobu4b5VdeqTJaIbOiP3bc5RDYtoLeL9qo/Iywf5Sb
   nuv2aLyH1BKZ3aFFuOx4ZdYUq7yzdJFpPCd1XMeDh6c1vhvmFcNQAqiaZ
   ejOqtTK1vzJkPyXTYCmsCa1v+y5gt2HBjcZ3V+ySYYW2rZyVNCvnYmoj2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318458697"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="318458697"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:27:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="976046954"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="976046954"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:27:58 -0800
Subject: [ndctl PATCH v2 00/18] cxl-cli test and usability updates
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Yi Zhang <yi.zhang@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Bobo WL <lmw.bobo@gmail.com>,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:27:57 -0800
Message-ID: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Changes since v1 [1]:
- Clarify the changelog as to why emitting pmem_size on non-pmem capable
  device is confusing, and clean up the man page to remove stale example
  of "{pmem,ram}_size: 0" (Alison)
- Update the man page for cxl create-region to make it clear that the
  tool maybe able to select the possible memdevs, but it may not still
  require a manual specification of the ordering until the tool can do
  that automatically. (Alison)
- Support specification of the region order in either individual args, a
  comma separated list, or space separated list. (Vishal)
- Fixup count of the target list in the presence of list args. (Vishal)
- Fixup test/cxl-topology.sh to use consistent 'math' context for comparisons
  (Vishal)
- Include some more documentation fixups and list enhancements

[1]: http://lore.kernel.org/r/166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com

---
The v6.1 kernel picks up new cxl_test infrastructure for a switch
attached to a single-port host-bridge. While extending the region
creation and topology tests for that change, some additional updates
were identified. The main one is the ability to elide the "ways"
"memdevs" arguments to 'cxl create-region'. Those parameters are now
derived by the result of a topology walk under the given root decoder.
I.e.:

    cxl create-region -d decoder3.4

...will internally perform a:

    cxl list -M -d decoder3.4

...operation and use those memdevs as region targets.

This also updates 'create-region' size detection to be maximum free
extent in the decoder, or the available capacity in the target memdevs,
whichever is smaller.

Some miscellaneous fixes and updates are included as well.

---

Dan Williams (18):
      ndctl/test: Move firmware-update.sh to the 'destructive' set
      ndctl/test: Add kernel backtrace detection to some dax tests
      ndctl/clang-format: Move minimum version to 6
      ndctl/clang-format: Fix space after for_each macros
      cxl/list: Always attempt to collect child objects
      cxl/list: Add a 'firmware_node' alias
      cxl/list: Add parent_dport attribute to port listings
      cxl/list: Skip emitting pmem_size when it is zero
      cxl/filter: Return json-c topology
      cxl/list: Record cxl objects in json objects
      cxl/region: Make ways an integer argument
      cxl/region: Make granularity an integer argument
      cxl/region: Use cxl_filter_walk() to gather create-region targets
      cxl/region: Trim region size by max available extent
      cxl/Documentation: Fix whitespace typos in create-region man page
      cxl/region: Autoselect memdevs for create-region
      cxl/test: Extend cxl-topology.sh for a single root-port host-bridge
      cxl/test: Test single-port host-bridge region creation


 .clang-format                           |   38 +--
 Documentation/cxl/cxl-create-region.txt |   12 +
 Documentation/cxl/cxl-list.txt          |    5 
 cxl/filter.c                            |   36 +--
 cxl/filter.h                            |   22 ++
 cxl/json.c                              |   57 ++++
 cxl/lib/libcxl.c                        |   69 +++++
 cxl/lib/libcxl.sym                      |    7 +
 cxl/lib/private.h                       |    4 
 cxl/libcxl.h                            |    3 
 cxl/list.c                              |    7 -
 cxl/region.c                            |  406 ++++++++++++++++++++-----------
 test/common                             |   10 +
 test/cxl-create-region.sh               |   28 ++
 test/cxl-region-sysfs.sh                |    4 
 test/cxl-topology.sh                    |   53 ++--
 test/dax.sh                             |    2 
 test/daxdev-errors.sh                   |    2 
 test/meson.build                        |    2 
 test/multi-dax.sh                       |    2 
 util/util.h                             |    9 +
 21 files changed, 537 insertions(+), 241 deletions(-)

base-commit: 1d4dbf6ff6eb988864d154792aaa098a2b11a244
