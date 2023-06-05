Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA42DDC0
	for <nvdimm@lists.linux.dev>; Mon,  5 Jun 2023 20:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685996471; x=1717532471;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=81sx6UUTH7YrmfPTbmZ8hZtmX/56vuvO4aJSVPZN/Y8=;
  b=DNP9ninuY1Hj+cdW/O+j6252yhw3WMY6JysLR0XNUNV/ytkujL4Ri9gk
   wXDjVOipMhWoU0+8qlfYjUNxg3T3lt9o5/6W49H2qdQXNZOldv/LXC96o
   DZC+7csSKffmBKpp45fRDlMHr73sFaeCLvNyL+l/7dN1yIxAkq1+nZ4Uj
   +Ps/SEACl7+S7SKdm34Fv8Cco8ADOdHZxMujOIrxOJYaFJcbLtziUc+fx
   nsHHMpvpbunEWIIFYdIi+eW9DV1zoumOltxyEFC+FcDYgqQE3TTA1Nl5G
   2LraRkDA3/qBhuZ6VGyvuUSLaOXI9MICJzPEGhbtWobI8CsVmg3WZgnlj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336093170"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="336093170"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="832934294"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="832934294"
Received: from kmsalzbe-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.209.52.9])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:10 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH ndctl v2 0/5] cxl: firmware update support for libcxl and
 cxl-cli
Date: Mon, 05 Jun 2023 14:21:02 -0600
Message-Id: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAK5DfmQC/3WNQQ6CMBBFr0K6dkxpbYiuvIchZtoOMIkW0mLVE
 O5uYe/y/Z+Xt4hEkSmJS7WISJkTj6GAOlTCDRh6AvaFhZJKy5M0kDN07/tr8jgTnKXxyujOWW1
 FUSwmAhsxuGGTJgqeQ789U6SOP3vo1hYeOM1j/O7dXG/rn0SuQUKjFDZoLBLqK4eZHkc3PkW7r
 usPVUi3+8IAAAA=
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-02a79
X-Developer-Signature: v=1; a=openpgp-sha256; l=2866;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=81sx6UUTH7YrmfPTbmZ8hZtmX/56vuvO4aJSVPZN/Y8=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCl1zlsr/GPULbnmbql2e+hsuOTkRe9dr82m880xnvvyh
 /zPc3/WdpSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAie5sYGTaE3vR5oVV8qzS6
 L42v9/Q1re+ZWdoNk5gSxGt+Pnk5+w0jw5Xcb0f/nN6vo38u8OMkEeO2jFan3zLXrQ1XnPkSuTr
 sPgcA
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
Changes in v2:
- Add the missing Documentation/cxl/cxl-update-firmware file to the patchset
- Change &foo->bar[0] to foo->bar in a few places (Dave)
- clean up error path freeing in add_cxl_memdev_fwl() (Dave)
- Link to v1: https://lore.kernel.org/r/20230405-vv-fw_update-v1-0-722a7a5baea3@intel.com

---
Vishal Verma (5):
      cxl/memdev.c: allow filtering memdevs by bus
      cxl/list: print firmware info in memdev listings
      cxl/fw_loader: add APIs to get current state of the FW loader mechanism
      cxl: add an update-firmware command
      test/cxl-update-firmware: add a unit test for firmware update

 Documentation/cxl/cxl-disable-memdev.txt  |   2 +
 Documentation/cxl/cxl-enable-memdev.txt   |   2 +
 Documentation/cxl/cxl-free-dpa.txt        |   2 +
 Documentation/cxl/cxl-read-labels.txt     |   2 +
 Documentation/cxl/cxl-reserve-dpa.txt     |   2 +
 Documentation/cxl/cxl-set-partition.txt   |   2 +
 Documentation/cxl/cxl-update-firmware.txt |  85 +++++++++
 Documentation/cxl/cxl-write-labels.txt    |   3 +
 cxl/lib/private.h                         |  36 ++++
 cxl/lib/libcxl.c                          | 299 ++++++++++++++++++++++++++++++
 cxl/builtin.h                             |   1 +
 cxl/filter.h                              |   5 +
 cxl/libcxl.h                              |  36 ++++
 cxl/cxl.c                                 |   1 +
 cxl/filter.c                              |  19 ++
 cxl/json.c                                |  97 ++++++++++
 cxl/list.c                                |   3 +
 cxl/memdev.c                              |  77 +++++++-
 Documentation/cxl/meson.build             |   1 +
 cxl/lib/libcxl.sym                        |  10 +
 test/cxl-update-firmware.sh               | 195 +++++++++++++++++++
 test/meson.build                          |   2 +
 22 files changed, 881 insertions(+), 1 deletion(-)
---
base-commit: b830c4af984e72e5849c0705669aad2ffa19db13
change-id: 20230405-vv-fw_update-905d253fcb3b

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

