Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A7A1CF287
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 21:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730325308; cv=none; b=Iwi77elnLW5D15ALQnLGYzZ6ONVlqU8W+sB7N1I6z6eicHt6uZ6FJXJFJRHzfN14+Pjc1XGx9ojMdS9GOuMXvO9IrIYhgpGIAypouE8Q02odAMtpicc5r8KXjZYVb2R/YgJXsKTyf0C6jssI8+ZD3JQhOYJ8rmwHIM0dyrVhJL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730325308; c=relaxed/simple;
	bh=qugSii8g9iMUqaRG1pVF9b91pxsQWMjuGRw75hgVnEA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=P0Kj3niaoUnS3GEAxOG2KDE+osLQEusFWDunsJm952iOtly4DfjtwRc3+0+/HkQm+ESw3L9gHnEBQMOoOqynHVJSUKuhvPhsTY+5mUTCXvVnykTJ2WEdedGHkgA18M1wtVkcxWxQWIGF83SnD/baYlxrzD/yjF9Do28k1x8au10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hqLbWawn; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hqLbWawn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730325306; x=1761861306;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=qugSii8g9iMUqaRG1pVF9b91pxsQWMjuGRw75hgVnEA=;
  b=hqLbWawnlNgbIqwbQm5rkc7HQu48HpgdV6FuxkPkasXaXsvdk/IpHd7K
   /i41R0pGqpwQxt6eRr8RspQ11yJDZh0tKaLREUYxtIlwb7GzwdURj720v
   IBBEHlXaYecQtmOelwDxjl03W2be4oHR3WwBzs9B335ZN+8P8q/EVq80I
   pGU78/HO4gxQRGL4OF8MNVxfXWmh8y0ePjMeGaYYG9oxB35dB94xiz0Vn
   Pedg9ASYmdHmoVdzr6y+0oQRZInqazxj7HzMs25UDrEUDnkoLz/X4ox+1
   Qv3GeulH6Rv63nBJLHDJ5Nr6AVR29ANXnwbnHay8afAXg6owZQHjXh+ha
   g==;
X-CSE-ConnectionGUID: GUZeLeanRXKABbHn3UWN3g==
X-CSE-MsgGUID: /7d0qBIFQVi16YxZF/nEtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="40620509"
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="40620509"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 14:55:05 -0700
X-CSE-ConnectionGUID: oE6suvT4QcCGe50C6jqgbw==
X-CSE-MsgGUID: yhUy9KWqSk6VsDpXI6FSWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="119899950"
Received: from msatwood-mobl.amr.corp.intel.com (HELO localhost) ([10.125.108.161])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 14:55:04 -0700
From: Ira Weiny <ira.weiny@intel.com>
Subject: [ndctl PATCH 0/6] ndctl: DCD additions
Date: Wed, 30 Oct 2024 16:54:43 -0500
Message-Id: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACOrImcC/x2MQQqAIBAAvyJ7TlDzUH0lOpS72l4sVohA/HvSc
 WBmKhQSpgKLqiD0cOErd7CDgnDuOZFm7AzOOG/NaDQG1EKpa047NNbPdEwUEXpxC0V+/9u6tfY
 BjlfXLl0AAAA=
X-Change-ID: 20241030-dcd-region2-2d0149eb8efd
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>, Sushant1 Kumar <sushant1.kumar@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730325302; l=1746;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=qugSii8g9iMUqaRG1pVF9b91pxsQWMjuGRw75hgVnEA=;
 b=KZ+HtGlK66DgionStdtkdrCUCFgXvl7vm+lTEJ48cpRvmk9OozbNQiItsR99zk5P1GAFWzsb6
 ROT8HUjqyBACsOhYjw9G5uOnI85JC60/xhhxajO+m7ryAeHAI5388Sg
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

CXL Dynamic Capacity Device (DCD) support is close to landing in the
upstream kernel.  cxl cli requires some modifications to best interact
with those devices.  This includes creating and viewing details of DCD
regions.  cxl-testing is also valuable in regression testing the kernel
interfaces.

Add preliminary patches with some fixes.  Update cxl cli with DCD
support and add cxl-testing.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Ira Weiny (5):
      ndctl/cxl-events: Don't fail test until event counts are reported
      ndctl/cxl/region: Report max size for region creation
      ndctl: Separate region mode from decoder mode
      ndctl/cxl: Add extent output to region query
      ndctl/cxl/test: Add Dynamic Capacity tests

Navneet Singh (1):
      cxl/region: Add creation of Dynamic capacity regions

 Documentation/cxl/cxl-list.txt |   4 +
 cxl/filter.h                   |   3 +
 cxl/json.c                     |  79 ++++-
 cxl/json.h                     |   3 +
 cxl/lib/libcxl.c               | 248 +++++++++++++++-
 cxl/lib/libcxl.sym             |   9 +
 cxl/lib/private.h              |  19 +-
 cxl/libcxl.h                   |  99 ++++++-
 cxl/list.c                     |   3 +
 cxl/memdev.c                   |   7 +-
 cxl/region.c                   |  53 +++-
 test/cxl-dcd.sh                | 656 +++++++++++++++++++++++++++++++++++++++++
 test/cxl-events.sh             |   8 +-
 test/meson.build               |   2 +
 util/json.h                    |   1 +
 15 files changed, 1173 insertions(+), 21 deletions(-)
---
base-commit: 04815e5f8b87e02a4fb5a61aeebaa5cad25a15c3
change-id: 20241030-dcd-region2-2d0149eb8efd

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

