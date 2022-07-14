Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1276002
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818122; x=1689354122;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tHk5BFH1Cos/EDervPD2cubzgwZ8SswtlBnR3VA2/Po=;
  b=izKbla7jHPcuDqdyssWQZ7E3EUr7tPyPGgpiymgwgSXpNraCeDeTKLk8
   arJEbuvzyoObxyRW9JUWcATcm+iOTB9Uy5HavrULPZy37h4FALrFlaRIk
   1nKLGm05rff/Bt5uXe1XqinVFKNsfGkpdv/pItRwR4e5iBAYN977FInvj
   so81C+UiichsWUr5OQ2zZ20RjvfQxFNA/H+72scoF8mJCEOB7tcnEf9cN
   hwuf9iptPSQdGXlMB+McoJLSvmeN7tQna8ZILCH7EaHQbaSK5/c9hDc2O
   mBaSYqDMeOysmSQklXfesSxexdl+SW8YLI18QN9gEQDSvhxzPBTK4r/L1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="268602397"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="268602397"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:01:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="623499047"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:01:47 -0700
Subject: [ndctl PATCH v2 00/12] cxl: Region provisioning foundation
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Ira Weiny <ira.weiny@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:01:47 -0700
Message-ID: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
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
- Update ccan/list to the latest (Ira, Davidlohr)
- Collect some reviewed-bys (Davidlohr)
- Add man pages for cxl {reserve,free}-dpa (Vishal)
- Reflow some clang-format escapes (Vishal)
- Rename test/cxl-create-region.sh to test/cxl-region-sysfs.h (Vishal)
- Use $CXL in cxl-region-sysfs.sh (Vishal)
[1]: https://lore.kernel.org/r/165765284365.435671.13173937566404931163.stgit@dwillia2-xfh/

---

On the way towards a "cxl create-region" command add support for a unit
test of the raw sysfs interfaces used for region provisioning. This
includes support for listing endpoint decoders filtered by their
associated memdev, listing decoders in id order by default, and managing
DPA allocations. Those capabilities plus some other miscellaneous
cleanups are validated in a new 'cxl-region-sysfs.sh' test.

All of the sysfs ABI leveraged in these updates is provided by this
pending series of updates:

https://lore.kernel.org/linux-cxl/165603869943.551046.3498980330327696732.stgit@dwillia2-xfh/

To date that review has not identified any ABI changes so there is a
reasonable chance that this cxl-cli series will not need to be respun to
address a kernel-side change. That said, the kernel changes need to
complete review and enter linux-next before these proposed patches can
be committed to the ndctl project. In the meantime that kernel review
can be helped along by having test/cxl-region-sysfs.sh as an example of
how the ABI is used.

---

Dan Williams (12):
      cxl/list: Reformat option list
      cxl/list: Emit endpoint decoders filtered by memdev
      cxl/list: Hide 0s in disabled decoder listings
      cxl/list: Add DPA span to endpoint decoder listings
      ccan/list: Import latest list helpers
      cxl/lib: Maintain decoders in id order
      cxl/memdev: Fix json for multi-device partitioning
      cxl/list: Emit 'mode' for endpoint decoder objects
      cxl/set-partition: Accept 'ram' as an alias for 'volatile'
      cxl/memdev: Add {reserve,free}-dpa commands
      cxl/test: Update CXL memory parameters
      cxl/test: Checkout region setup/teardown


 .clang-format                           |    1 
 Documentation/cxl/cxl-free-dpa.txt      |   53 +++++
 Documentation/cxl/cxl-reserve-dpa.txt   |   67 +++++++
 Documentation/cxl/cxl-set-partition.txt |    2 
 Documentation/cxl/lib/libcxl.txt        |   13 +
 Documentation/cxl/meson.build           |    2 
 ccan/list/list.h                        |  258 ++++++++++++++++++++++----
 cxl/builtin.h                           |    2 
 cxl/cxl.c                               |    2 
 cxl/filter.c                            |   12 +
 cxl/filter.h                            |    2 
 cxl/json.c                              |   38 +++-
 cxl/lib/libcxl.c                        |  167 +++++++++++++++++
 cxl/lib/libcxl.sym                      |   11 +
 cxl/lib/private.h                       |    3 
 cxl/libcxl.h                            |   34 +++
 cxl/list.c                              |    9 -
 cxl/memdev.c                            |  308 ++++++++++++++++++++++++++++++-
 ndctl/lib/inject.c                      |    1 
 test/cxl-region-sysfs.sh                |  122 ++++++++++++
 test/cxl-topology.sh                    |   32 ++-
 test/meson.build                        |    2 
 util/list.h                             |   63 +++---
 23 files changed, 1102 insertions(+), 102 deletions(-)
 create mode 100644 Documentation/cxl/cxl-free-dpa.txt
 create mode 100644 Documentation/cxl/cxl-reserve-dpa.txt
 create mode 100644 test/cxl-region-sysfs.sh

base-commit: bbb2cb56f08d95ecf2c7c047a33cc3dd64eb7fde
