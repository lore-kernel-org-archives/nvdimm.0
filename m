Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4A02CA4
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778407; x=1699314407;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uHK2YYam8c0ncpmQvoPPHnkfE14o3EJbSBCJT0s93Ak=;
  b=ZOvTF2bq3Mc0ScjZ5+rqj1edlF/MpS2D7DMFz0YBEyCg1DYKT+plOyaK
   O9Th81nR2fchp3eQz8uRDGd3A0S7aG4PflMfMM0mwJY6V2puD3u+J9eQz
   OXShfTlzP9sLYKb2jVBFsqFVFD6gO0oLvXJEPpBQ6O8ckjilBjIRvoazt
   AcjZaxwoC7Mqh4o8gZZ7/0m+NNwQ6VZzhk7BLtazJJ2jn6Oo2D5fxFZ5A
   pfpaB8t/DwPmjpUPfYmUAX7wp4NFjL7sTKr2h40VHg+I8Bn+SO/A9g2+j
   9YDaoDqvKeFMdR+huMDyVUW0YOkofzRWmmkhMkwwVGyKuo1rdy0OIozN2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="293633979"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="293633979"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:46:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="638172114"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="638172114"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:46:45 -0800
Subject: [ndctl PATCH 00/15] cxl-cli test and usability updates
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:46:45 -0800
Message-ID: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The v6.1-rc4 kernel picks up new cxl_test infrastructure for a switch
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

Dan Williams (15):
      ndctl/test: Move firmware-update.sh to the 'descructive' set
      ndctl/test: Add kernel backtrace detection to some dax tests
      ndctl/clang-format: Move minimum version to 6
      ndctl/clang-format: Fix space after for_each macros
      cxl/list: Always attempt to collect child objects
      cxl/list: Skip emitting pmem_size when it is zero
      cxl/filter: Return json-c topology
      cxl/list: Record cxl objects in json objects
      cxl/region: Make ways an integer argument
      cxl/region: Make granularity an integer argument
      cxl/region: Use cxl_filter_walk() to gather create-region targets
      cxl/region: Trim region size by max available extent
      cxl/region: Default to memdev mode for create with no arguments
      cxl/test: Extend cxl-topology.sh for a single root-port host-bridge
      cxl/test: Test single-port host-bridge region creation


 .clang-format             |   38 ++---
 cxl/filter.c              |   36 +----
 cxl/filter.h              |   22 +++
 cxl/json.c                |   29 +++-
 cxl/list.c                |    7 +
 cxl/region.c              |  346 +++++++++++++++++++++++++++------------------
 test/common               |   10 +
 test/cxl-create-region.sh |   28 ++++
 test/cxl-region-sysfs.sh  |    4 -
 test/cxl-topology.sh      |   53 ++++---
 test/dax.sh               |    2 
 test/daxdev-errors.sh     |    2 
 test/meson.build          |    2 
 test/multi-dax.sh         |    2 
 14 files changed, 363 insertions(+), 218 deletions(-)

base-commit: 1d4dbf6ff6eb988864d154792aaa098a2b11a244
