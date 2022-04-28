Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E04A138F
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183802; x=1682719802;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OGGG3wfPvKPhHFNm2pE/kyGBmEmBBn2InpMBsH1ScMs=;
  b=hY1kPcCebfhZjLPGjZdPenOeN7+wvh1XOZYa2Cwmn+6moVWAYu+x7MkH
   cXBPeIBGvlU8Ud2omBX0bN7GLZ2m1kNhEJHps1L1umcul01Tbzl62rqVJ
   Cd4t30eQUlbe5a7G9K6ZspkSkDeoBcUd9XAMn2GOTwwbBZl/tdxznHOyA
   vw6tsVFKwoBcfx0S7SXRn8d4ElizcgvY1r+LG3kT7SQGp6T8FFScIDHM2
   p62b0BMxOhV83CKsgR/F7V6voJE9CntJ9CDL72JE6VgrNTun7nWks8Rem
   s8m8NUhpY2IMgVLrkWDtaMDqQt1tdpFsWC48khn0TeVR2aSnZGE6ub2R/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="352871228"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="352871228"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581670809"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:00 -0700
Subject: [ndctl PATCH 00/10] CXL topology unit test
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:00 -0700
Message-ID: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Vishal,

Here is a series that adds a unit test for CXL bus operations around
port discovery and memory device enable/disable events. Along the way it
adds some helper commands ('cxl disable-bus') and calling convention
cleanups ('cxl list -p $port'). Some other miscellaneous fixups and
cleanups are thrown in for good measure.

---

Dan Williams (10):
      build: Move utility helpers to libutil.a
      util: Use SZ_ size macros in display size
      util: Pretty print terabytes
      cxl/port: Fix disable-port man page
      cxl/bus: Add bus disable support
      cxl/list: Auto-enable 'single' mode for port listings
      cxl/memdev: Fix bus_invalidate() crash
      cxl/list: Add support for filtering by host identifiers
      cxl/port: Relax port identifier validation
      cxl/test: Add topology enumeration and hotplug test


 Documentation/cxl/cxl-disable-bus.txt  |   37 +++++++
 Documentation/cxl/cxl-disable-port.txt |    6 -
 Documentation/cxl/lib/libcxl.txt       |   12 ++
 Documentation/cxl/meson.build          |    1 
 cxl/builtin.h                          |    1 
 cxl/bus.c                              |  159 +++++++++++++++++++++++++++++++
 cxl/cxl.c                              |    1 
 cxl/filter.c                           |   12 ++
 cxl/filter.h                           |    1 
 cxl/lib/libcxl.c                       |   18 +++
 cxl/lib/libcxl.sym                     |    1 
 cxl/libcxl.h                           |    1 
 cxl/list.c                             |    1 
 cxl/meson.build                        |    3 -
 cxl/port.c                             |   30 +-----
 daxctl/meson.build                     |    1 
 ndctl/meson.build                      |    2 
 test/common                            |   12 ++
 test/cxl-topology.sh                   |  166 ++++++++++++++++++++++++++++++++
 test/meson.build                       |    2 
 util/json.c                            |   26 ++++-
 util/meson.build                       |    2 
 22 files changed, 448 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/cxl/cxl-disable-bus.txt
 create mode 100644 cxl/bus.c
 create mode 100644 test/cxl-topology.sh

base-commit: 97031db9300654260bc2afb45b3600ac01beaeba
