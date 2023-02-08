Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2ED7481
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675886443; x=1707422443;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=nofu0ros1HhRpc3R/kAtB2DwGKH81rgPwKoOHg8P+E4=;
  b=YAfXNPPYNTTo8wydEzsbd4m8oPjFkdrkSV65U6P0b8O0HS9aDTm5sNaz
   fMEpNocU/txgiXehDT3p0Hz5RX2trPi7tFgpGLv4GlnVNI3sLF7gD+bYT
   SGIb2THzjvqVx/DS9y1PQwVErzpPPKmKCQCIvbpZUzx+9DK/NczOzT143
   Y38l3CdY7B6gVkBZHyM2CAnpymDWuS3NYa7q3Kk8YUi71rew/BZylIf8C
   uOs0+KzzdmZeG7DbnpK6G3VvIStCCo2f6YnaI+SxKuuJxjz/tt0Lzal+3
   7IeLUT4PLTZO36+pXwL1tJxQpAZtyXoFDIOGyxieXfJL8SxYRf3FFTwt5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="329935448"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="329935448"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776174662"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="776174662"
Received: from laarmstr-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.251.6.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:41 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
Date: Wed, 08 Feb 2023 13:00:28 -0700
Message-Id: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFz/42MC/32NTQ6CMBBGr2Jm7ZhpESOuvIdh0ZYBJsGWtKTRE
 O5u4QAu3/eTt0LiKJzgcVohcpYkwRfQ5xO40fiBUbrCoElXpDRhzpjDZBaZGCMPZZ6QblVTk+O
 +bgjK05rEaKPxbty/M/tO/LA3c+RePofv1RYeJS0hfg99Vnv635QVEtqrtlox3zuyT/ELTxcX3
 tBu2/YDh91zhtAAAAA=
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=3342;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=nofu0ros1HhRpc3R/kAtB2DwGKH81rgPwKoOHg8P+E4=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmP/2dyXPKM/73Jj+Ws/y/reP3f+78y7lf6/ubO9txjC
 SIqm3epdZSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAiNtGMDFd3JKtt1eAuNPGx
 nLH91sqZpWpnTe5EWx6bvUv4/Ez3HFeGPxzFCxfw9Fd5v/SdWr8291f3vc5Z565/qDraKi/Avkq
 YkxsA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

While enumeration of ram type regions already works in libcxl and
cxl-cli, it lacked an attribute to indicate pmem vs. ram. Add a new
'type' attribute to region listings to address this. Additionally, add
support for creating ram regions to the cxl-create-region command. The
region listings are also updated with dax-region information for
volatile regions.

This also includes fixed for a few bugs / usability issues identified
along the way - patches 1, 4, and 6. Patch 5 is a usability improvement
where based on decoder capabilities, the type of a region can be
inferred for the create-region command.

These have been tested against the ram-region additions to cxl_test
which are part of the kernel support patch set[1].
Additionally, tested against qemu using a WIP branch for volatile
support found here[2]. The 'run_qemu' script has a branch that creates
volatile memdevs in addition to pmem ones. This is also in a branch[3]
since it depends on [2].

These cxl-cli / libcxl patches themselves are also available in a
branch at [4].

[1]: https://lore.kernel.org/linux-cxl/167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com/
[2]: https://gitlab.com/jic23/qemu/-/commits/cxl-2023-01-26
[3]: https://github.com/pmem/run_qemu/commits/vv/ram-memdevs
[4]: https://github.com/pmem/ndctl/tree/vv/volatile-regions

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Changes in v2:
- Fix typos in the commit message of patch 1 (Fan)
- Gate the type attr in region listings on mode != 'none' (Dan)
- Clarify unreachability of the default case in collect_minsize() (Ira)
- Simplify the mode setup in set_type_from_decoder() (Dan)
- Fix typo in the commit message of Patch 7 (Dan)
- Remove unneeded daxctl/json.h include from cxl/filter.c (Dan)
- Link to v1: https://lore.kernel.org/r/20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com

---
Dan Williams (2):
      cxl/list: Include regions in the verbose listing
      cxl/list: Enumerate device-dax properties for regions

Vishal Verma (5):
      cxl/region: skip region_actions for region creation
      cxl: add a type attribute to region listings
      cxl: add core plumbing for creation of ram regions
      cxl/region: accept user-supplied UUIDs for pmem regions
      cxl/region: determine region type based on root decoder capability

 Documentation/cxl/cxl-create-region.txt |  6 ++-
 Documentation/cxl/cxl-list.txt          | 31 ++++++++++++++
 Documentation/cxl/lib/libcxl.txt        |  8 ++++
 cxl/lib/private.h                       |  2 +
 cxl/lib/libcxl.c                        | 72 +++++++++++++++++++++++++++++++--
 cxl/filter.h                            |  3 ++
 cxl/libcxl.h                            |  3 ++
 cxl/json.c                              | 23 +++++++++++
 cxl/list.c                              |  3 ++
 cxl/region.c                            | 66 +++++++++++++++++++++++++++---
 cxl/lib/libcxl.sym                      |  7 ++++
 cxl/lib/meson.build                     |  1 +
 cxl/meson.build                         |  3 ++
 13 files changed, 217 insertions(+), 11 deletions(-)
---
base-commit: 08720628d2ba469e203a18c0b1ffbd90f4bfab1d
change-id: 20230120-vv-volatile-regions-063950cef590

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

