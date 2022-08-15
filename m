Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416771103
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591339; x=1692127339;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w2/nvlWPo1I8sog965RCSF4LJzuFIoHNQKsEdgarIfU=;
  b=K81hI9+2sK2pymhNXayNR90+yIZ5aV6FnLyY5PHE/3aqcuezhIvNyrek
   +/Q/FqJ2OE2D2DH2wfv4u7mGjPWeDSpW4b5cVSF8yxULrpl7BWA3JN0R0
   LBEs+N5w/+TPCvQ6FLmHsg+3IeYIBA7e1Tnaa4d+k77frdHq8MUCya5E7
   NX5gap19gV5+Ji7cf3c4VCVhTr0IabZKdIJcCdykAn0y8RCYYRkVozsO7
   80zPLQeR6vvJNtq2ldXp31iWZTrbRvFhD+4JFXYZheGKSF9YDwJSQCgxg
   Y4q9TTBMKCQPPeU8gRRXz34BWtlQv2SXb9gBH2yeUxCSEGJfes1jRlajQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038707"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038707"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758236"
Received: from smadiset-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.5.99])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:17 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 00/11] cxl: add region management
Date: Mon, 15 Aug 2022 13:22:03 -0600
Message-Id: <20220815192214.545800-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5722; h=from:subject; bh=w2/nvlWPo1I8sog965RCSF4LJzuFIoHNQKsEdgarIfU=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5lwRWiJdm6paMNFGesmM2YYWp5MPzVzwYe6LXZIz+A+s mDbrUUcpC4MYF4OsmCLL3z0fGY/Jbc/nCUxwhJnDygQyhIGLUwAmksbMyLA75OhXvkCdkHO8/wwk3h pq/cz9qxqbtmHt3ocllSU3Ei8z/OGNPP5grcfWGwbmq0XcHhedN4psYt6szHFnxY/Dmy+XCDMBAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Changes since v2[1]:
- Collect review tags
- Fix -r description in the cxl-list man page (Dan)
- Fix typo + some wordsmithing in man libcxl(3) (Dan)
- s/cxl_ep_decoder_get.../cxl_decoder_get.../ (Dan)
- Move regions invalidation from patch 10 to patch 5 (Dan)
- Consolidate mode string to enum in a common helper (Dan)
- Fix a mid-series compile breakage with printing memdev json in the
  region listing.
- Remove the --ep-decoders option (Dan)
- Use a decoder->stale_regions list for stashing duplicate regions
  during region creation. Add the necessary helpers around freeing
  these.
- Don't free regions to invalidate them, use stale_regions instead (Dan)
- Fix a couple of bugs in the create-region unit test where the regions
  array wasn't used correctly leading to weird failures
- Fix max_available_extent json listing to be a size instead of hex
- Add an equals case to the region ordering compare helper (Dan)
- Change the max extent calculations to explicitly add/subtract 1 as
  needed (Dan)


[1]: https://lore.kernel.org/linux-cxl/20220810230914.549611-1-vishal.l.verma@intel.com/

---

Introduce the first cut at a 'cxl create-region' command, which uses the
ABI merged in the kernel in [2], and builds on the create-region foundation
laid out in [3].

This introduces libcxl objects for regions and their memdev mappings,
adds listing support for them, and libcxl APIs to create, enable,
disable, and destroy regions. These are consumed by respective cxl-cli
commands to perform the same region management operations.

The 'cxl create-region' command deserves a bit more detail. Its current
version can be considered a fundamental 'plumbing' implementation. It
allows, and in some cases, requires the user to specify the parameters
for the region being created. Future enhancements to this will allow a
simple 'cxl create-region' invocation to automatically pick suitable
root decoders, memdev endpoints, and interleave settings to create a
maximally sized and interleaved region.

Today, the create-region command requires the following from the user:

  -d <root decoder> : the root decoder (CFMWS window) under which to
  create the region

  <targets>: the memdev (-m) targets that will form the new region

It can pick the following settings automatically (though the user can
also override these if desired):

  -w : interleave ways - picked based on the number of targets supplied

  -g : interleave granularity - selects the interleave granularity
  advertised by the root decoder

  -t : type of region - defaults to pmem. The ram (volatile) type is not
  supported yet.

  -s : size of region - deduced based on sizes of the specified targets

[2]: https://git.kernel.org/torvalds/c/c235698355fa94df7073b51befda7d4be00a0e23
[3]: https://lore.kernel.org/linux-cxl/165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com/


Vishal Verma (11):
  libcxl: add a depth attribute to cxl_port
  cxl/port: Consolidate the debug option in cxl-port man pages
  cxl/memdev: refactor decoder mode string parsing
  libcxl: Introduce libcxl region and mapping objects
  cxl-cli: add region listing support
  libcxl: add low level APIs for region creation
  cxl: add a 'create-region' command
  cxl: add commands to {enable,disable,destroy}-region
  cxl/list: make memdevs and regions the default listing
  test: add a cxl-create-region test
  cxl/decoder: add a max_available_extent attribute

 Documentation/cxl/bus-option.txt         |   5 +
 Documentation/cxl/cxl-create-region.txt  | 112 +++
 Documentation/cxl/cxl-destroy-region.txt |  41 ++
 Documentation/cxl/cxl-disable-port.txt   |   5 +-
 Documentation/cxl/cxl-disable-region.txt |  36 +
 Documentation/cxl/cxl-enable-port.txt    |   5 +-
 Documentation/cxl/cxl-enable-region.txt  |  36 +
 Documentation/cxl/cxl-list.txt           |  13 +-
 Documentation/cxl/debug-option.txt       |   4 +
 Documentation/cxl/decoder-option.txt     |   6 +
 Documentation/cxl/lib/libcxl.txt         |  69 ++
 Documentation/cxl/region-description.txt |   7 +
 cxl/lib/private.h                        |  39 +
 cxl/lib/libcxl.c                         | 902 ++++++++++++++++++++++-
 cxl/builtin.h                            |   4 +
 cxl/filter.h                             |   6 +
 cxl/json.h                               |   5 +
 cxl/libcxl.h                             |  80 +-
 cxl/cxl.c                                |   4 +
 cxl/filter.c                             | 158 +++-
 cxl/json.c                               | 131 ++++
 cxl/list.c                               |  26 +-
 cxl/memdev.c                             |  11 +-
 cxl/region.c                             | 753 +++++++++++++++++++
 .clang-format                            |   2 +
 Documentation/cxl/meson.build            |   7 +
 cxl/lib/libcxl.sym                       |  37 +
 cxl/meson.build                          |   1 +
 test/cxl-create-region.sh                | 125 ++++
 test/meson.build                         |   2 +
 30 files changed, 2580 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/cxl/bus-option.txt
 create mode 100644 Documentation/cxl/cxl-create-region.txt
 create mode 100644 Documentation/cxl/cxl-destroy-region.txt
 create mode 100644 Documentation/cxl/cxl-disable-region.txt
 create mode 100644 Documentation/cxl/cxl-enable-region.txt
 create mode 100644 Documentation/cxl/debug-option.txt
 create mode 100644 Documentation/cxl/decoder-option.txt
 create mode 100644 Documentation/cxl/region-description.txt
 create mode 100644 cxl/region.c
 create mode 100644 test/cxl-create-region.sh

-- 
2.37.1

