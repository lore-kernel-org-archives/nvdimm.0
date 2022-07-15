Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B5217F3
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 06:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657866369; x=1689402369;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Xn9r5O+bolINQGPwGnn2lHCCcrCKqIydA/HZpyOLVY4=;
  b=ZB4n+ulqgQR7zPBcFnJhkRiZ2QjyoZoeU8IllXHFAsBGJPbJ2WmP3X9Q
   PbHCDiVm4DUekMLccZOD9EuBI67dOvkiy8kovBQJFfuDtXNZaS7r04syp
   dxPvIUKdwgrv6L5g7psSme5Z2pKGn73aSZKdTOgenXSLiXvlESZRymyks
   8gg+p+vpqvpQflHcuMPZmA/A4dzFAYDkgNnU1kHf98pGOIjB9aZ9QSJC6
   qu29aw3P9H13p1lq/yCIxhbDYb5Rct7JbUUGRve6zIRUc0diOMl+Auw4Z
   6O5dlzJKvcX5xJY1055+xtfplS94hpqZTM62NpAdVFMjQvnOqGWVTVvdN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266125529"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="266125529"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:08 -0700
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="546544601"
Received: from saseiper-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.71.32])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:07 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/8] cxl: add region management
Date: Fri, 15 Jul 2022 00:25:42 -0600
Message-Id: <20220715062550.789736-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4192; h=from:subject; bh=Xn9r5O+bolINQGPwGnn2lHCCcrCKqIydA/HZpyOLVY4=; b=owGbwMvMwCXGf25diOft7jLG02pJDEkXObJO835QMZqyXSKezXnS021it39xyOzh27Pu2a07StdP ds7e21HKwiDGxSArpsjyd89HxmNy2/N5AhMcYeawMoEMYeDiFICJJPxj+B8Rz7bqwTTV60v26EWd6l pQndi8c/EuhseWQeIueSufHtrL8M9w6icRaY0z0TpR4fndF2NZ/nTpJs14rmMvusrNIa/tBjcA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Introduce the first cut at a 'cxl create-region' command, which uses the
ABI proposed by the kernel patches in [1], and builds on the
create-region foundation laid out in [2].

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

  -m or -e <targets>: the memdev or endpoint decoder targets that will
  form the new region

It can pick the following settings automatically (though the user can
also override these if desired):

  -w : interleave ways - picked based on the number of memdev / endpoint
  decoder targets supplied

  -g : interleave granularity - defaults to the interleave granularity
  advertised by the root decoder

  -t : type of region - defaults to pmem. The ram (volatile) type is not
  supported yet.

  -s : size of region - deduced based on sizes of the specified targets

[1]: https://lore.kernel.org/linux-cxl/165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com/
[2]: https://lore.kernel.org/linux-cxl/165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com/

Vishal Verma (8):
  libcxl: add a depth attribute to cxl_port
  cxl/port: Consolidate the debug option in cxl-port man pages
  libcxl: Introduce libcxl region and mapping objects
  cxl-cli: add region listing support
  libcxl: add low level APIs for region creation
  cxl: add a 'create-region' command
  cxl: add commands to {enable,disable,destroy}-region
  cxl/list: make memdevs and regions the default listing

 Documentation/cxl/cxl-create-region.txt  | 111 ++++
 Documentation/cxl/cxl-destroy-region.txt |  39 ++
 Documentation/cxl/cxl-disable-port.txt   |   5 +-
 Documentation/cxl/cxl-disable-region.txt |  34 +
 Documentation/cxl/cxl-enable-port.txt    |   5 +-
 Documentation/cxl/cxl-enable-region.txt  |  34 +
 Documentation/cxl/cxl-list.txt           |  13 +-
 Documentation/cxl/debug-option.txt       |   4 +
 Documentation/cxl/decoder-option.txt     |   6 +
 Documentation/cxl/region-description.txt |   7 +
 cxl/lib/private.h                        |  37 ++
 cxl/lib/libcxl.c                         | 795 ++++++++++++++++++++++-
 cxl/builtin.h                            |   4 +
 cxl/filter.h                             |   6 +
 cxl/json.h                               |   5 +
 cxl/libcxl.h                             |  64 +-
 cxl/cxl.c                                |   4 +
 cxl/filter.c                             | 121 +++-
 cxl/json.c                               | 123 ++++
 cxl/list.c                               |  26 +-
 cxl/region.c                             | 699 ++++++++++++++++++++
 .clang-format                            |   2 +
 Documentation/cxl/meson.build            |   7 +
 cxl/lib/libcxl.sym                       |  36 +
 cxl/meson.build                          |   1 +
 25 files changed, 2143 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/cxl/cxl-create-region.txt
 create mode 100644 Documentation/cxl/cxl-destroy-region.txt
 create mode 100644 Documentation/cxl/cxl-disable-region.txt
 create mode 100644 Documentation/cxl/cxl-enable-region.txt
 create mode 100644 Documentation/cxl/debug-option.txt
 create mode 100644 Documentation/cxl/decoder-option.txt
 create mode 100644 Documentation/cxl/region-description.txt
 create mode 100644 cxl/region.c

-- 
2.36.1

