Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A63A7F
	for <nvdimm@lists.linux.dev>; Sat, 22 Apr 2023 03:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682133004; x=1713669004;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=znHqkqwNSuPjPucEYriJEO69qZyzeo3RyG1Oz5gXgTc=;
  b=gdqPQLBMzGN4g0Zeh6zfJ/xP6d9yCfrBLudn4gWza8Csa+v2mM3EpnIZ
   qjPESiODYfzyuo5ddGKS9JMm2VPWyL6gHiJgoMoEQF5zfqxLe3yWBmSNw
   svUuHqMKiiCrEWzml+ZAW4aE2WemTO13GqJ1JSzlgtJBBqH+olcZpE3NS
   hw02qlsMjjFNN1JkfkFtHepmq8SttcM//A9whNOSIMYbr8k8VeFwJ70+N
   flcD0klQZRVNL/ow+QFgJMA1s98FdeSuVGqqV5jK1HUw+tACJWJI9Vowj
   M4cdSVZdvK6UywhzVmqMzKM/AT0UAbNI08ms81B3QSaf09PBgazotl2bG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="343609096"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="343609096"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 20:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="757092345"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="757092345"
Received: from jwostman-mobl2.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.111.101])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 20:10:03 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH ndctl 0/5] cxl: firmware update support for libcxl and
 cxl-cli
Date: Fri, 21 Apr 2023 21:09:58 -0600
Message-Id: <20230405-vv-fw_update-v1-0-722a7a5baea3@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAZQQ2QC/x2NywrDIBAAfyXsOQtW66H9lVKCjzXZy1Y0MYWQf
 6/pcRiGOaBSYarwHA4o1LjyRzrcxgHC4mQm5NgZtNJG3ZXF1jDt05ajWwkfykZtTQreeOiJd5X
 QFydhuaJMElnmy+RCib//0et9nj9T3Xq1eAAAAA==
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-2eb1a
X-Developer-Signature: v=1; a=openpgp-sha256; l=2475;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=znHqkqwNSuPjPucEYriJEO69qZyzeo3RyG1Oz5gXgTc=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCnOAVw7LYQrLbT0bPpvvfgW1LP+QGhp0lfmXxNED9tlm
 zI/nfmzo5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABPZP4/hf2FynOnGqOXes/0Z
 8vdOutITqKcxW7WV3en51DPe59m5jRgZWl787Pu0QPPuYZaIVJHtCoU1gk99jRTcPVM0172vmbW
 KAQA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Patch 1 is a preparatory patch that teaches memdev based commands to
filter their operand memdevs by bus. This helps restricting unit test
operations to the cxl_test bus.

Patches 2 and 3 add firmware information to the CXL memdev listing. This
is derived from the 'Get FW Info' mailbox command as well as state
information in the kernel's firmware loader mechanism in sysfs.

Patch 4 adds the libcxl APIs to perform a firmware update, and to cancel
an in-progress update, and the cxl-cli command to use these APIs to
start, wait for, and cancel firmware updates. A man page for the new
command is added as well.

Patch 5 adds a unit test to exercise all the features described above in
a cxl_test environment.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Vishal Verma (5):
      cxl/memdev.c: allow filtering memdevs by bus
      cxl/list: print firmware info in memdev listings
      cxl/fw_loader: add APIs to get current state of the FW loader mechanism
      cxl: add an update-firmware command
      test/cxl-update-firmware: add a unit test for firmware update

 Documentation/cxl/cxl-disable-memdev.txt |   2 +
 Documentation/cxl/cxl-enable-memdev.txt  |   2 +
 Documentation/cxl/cxl-free-dpa.txt       |   2 +
 Documentation/cxl/cxl-read-labels.txt    |   2 +
 Documentation/cxl/cxl-reserve-dpa.txt    |   2 +
 Documentation/cxl/cxl-set-partition.txt  |   2 +
 Documentation/cxl/cxl-write-labels.txt   |   3 +
 cxl/lib/private.h                        |  36 ++++
 cxl/lib/libcxl.c                         | 304 +++++++++++++++++++++++++++++++
 cxl/builtin.h                            |   1 +
 cxl/filter.h                             |   5 +
 cxl/libcxl.h                             |  36 ++++
 cxl/cxl.c                                |   1 +
 cxl/filter.c                             |  19 ++
 cxl/json.c                               |  97 ++++++++++
 cxl/list.c                               |   3 +
 cxl/memdev.c                             |  77 +++++++-
 Documentation/cxl/meson.build            |   1 +
 cxl/lib/libcxl.sym                       |  10 +
 test/cxl-update-firmware.sh              | 195 ++++++++++++++++++++
 test/meson.build                         |   2 +
 21 files changed, 801 insertions(+), 1 deletion(-)
---
base-commit: b830c4af984e72e5849c0705669aad2ffa19db13
change-id: 20230405-vv-fw_update-905d253fcb3b

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

