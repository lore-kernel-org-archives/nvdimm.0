Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E478E2F33
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 19:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657652845; x=1689188845;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wjsmbeBXwg3Ws8z30RpvRi2AEvpWkmtoACcQP2+Cuu0=;
  b=ac1iGU2QeMZz7wquRKpPnDYfhbdd227Vp+0K0aBI5JybeZKrO3hasTgu
   iar2TnE1I68zlJ+02Ly7UpyVfSykJQHrR+Nb6InziAvaIj/q5O9cE43Sc
   blYGEyoo3GMI/KLACZKMlyTcnbOaFRUxQjaW2gQ5ndrx3FGQ4JcMci1Aq
   vX5LBWDYEkwJ2bSnhgMTvwSDf38VhfL12In+Z+A/r4cJu4jonssLthmHh
   znf5jrwruj1SWct1zeNwrBU7BxnKk45nZ54o+EWNuOJquVGFJjP8U7Q3N
   8u0ZMGTVXnL6SgsZetat7e29xEIZl7bzHZi49p5U4xKrUeC0BMDho8miQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285047415"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="285047415"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:24 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="599484210"
Received: from sheyting-mobl3.amr.corp.intel.com (HELO [192.168.1.117]) ([10.212.147.156])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:24 -0700
Subject: [ndctl PATCH 00/11] cxl: Region provisioning foundation
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Tue, 12 Jul 2022 12:07:23 -0700
Message-ID: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On the way towards a "cxl create-region" command add support for a unit
test of the raw sysfs interfaces used for region provisioning. This
includes support for listing endpoint decoders filtered by their
associated memdev, listing decoders in id order by default, and managing
DPA allocations. Those capabilities plus some other miscellaneous
cleanups are validated in a new 'cxl-create-region.sh' test.

All of the sysfs ABI leveraged in these updates is provided by this
pending series of updates:

https://lore.kernel.org/linux-cxl/165603869943.551046.3498980330327696732.stgit@dwillia2-xfh/

To date that review has not identified any ABI changes so there is a
reasonable chance that this cxl-cli series will not need to be respun to
address a kernel-side change. That said, the kernel changes need to
complete review and enter linux-next before these proposed patches can
be committed to the ndctl project. In the meantime that kernel review
can be helped along by having test/cxl-region-create.sh as an example of
how the ABI is used.

---

Dan Williams (11):
      cxl/list: Reformat option list
      cxl/list: Emit endpoint decoders filtered by memdev
      cxl/list: Hide 0s in disabled decoder listings
      cxl/list: Add DPA span to endpoint decoder listings
      cxl/lib: Maintain decoders in id order
      cxl/memdev: Fix json for multi-device partitioning
      cxl/list: Emit 'mode' for endpoint decoder objects
      cxl/set-partition: Accept 'ram' as an alias for 'volatile'
      cxl/memdev: Add {reserve,free}-dpa commands
      cxl/test: Update CXL memory parameters
      cxl/test: Checkout region setup/teardown


 .clang-format                           |    1 
 Documentation/cxl/cxl-set-partition.txt |    2 
 Documentation/cxl/lib/libcxl.txt        |   13 +
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
 cxl/memdev.c                            |  304 ++++++++++++++++++++++++++++++-
 test/cxl-region-create.sh               |  122 ++++++++++++
 test/cxl-topology.sh                    |   32 ++-
 test/meson.build                        |    2 
 util/list.h                             |   61 ++++++
 18 files changed, 784 insertions(+), 33 deletions(-)
 create mode 100644 test/cxl-region-create.sh

base-commit: bbb2cb56f08d95ecf2c7c047a33cc3dd64eb7fde
