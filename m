Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860187B
	for <nvdimm@lists.linux.dev>; Wed, 29 Jun 2022 08:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656491486; x=1688027486;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XfMapp4Lpx6knW5KLXt+Mg3dcI04Kale7nDaYY/4qjA=;
  b=c8F9EVLILYgtV10nw3/s/m3phSED3QOUt6euOhxHuUrdSko5TJcrziBX
   n6tlq0BLjqvaoAUvdiWxZT9qQuqalmKj7NfH4Ilhc7LX4//QAYh2HojcD
   Q5qHAq4Y3KVqMBc3wr61DHutx3dkLFpou6ORIxqgaP9elfvqOajt/gajz
   u2mlgqjpU9tc5zUuePWi0lajaA0tDuvouJhs6Lfcu+Kg2SyQip0PeFBae
   Y9wew643Qlm+dazB3bwhlAINcA0nCfni8TxN1xFxKezOMP18N41Q3Uq2B
   qvqAvR9cfMQ9gCkpiTDxOGktKq62bL9h5B78pNcvKgK7v5JsUoCE7neNb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="283065346"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="283065346"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 01:31:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="595149897"
Received: from ac02.sh.intel.com ([10.112.227.141])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2022 01:31:08 -0700
From: "Dennis.Wu" <dennis.wu@intel.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	"Dennis.Wu" <dennis.wu@intel.com>
Subject: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control flush operation
Date: Wed, 29 Jun 2022 16:31:18 +0800
Message-Id: <20220629083118.8737-1-dennis.wu@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

reason: in the current BTT implimentation deepflush is always
used and deepflush is very expensive. Since customer already
know the ADR can protect the WPQ data in memory controller and
no need to call deepflush to get better performance. BTT w/o
deepflush, performance can improve 300%~600% with diff FIO jobs.

How: Add one param "no_deepflush" in the nfit module parameter.
if "modprob nfit no_deepflush=1", customer can get the higher
performance but not strict data security. Before modprob nfit,
you may need to "ndctl disable-region".

Next: In the BTT, use flag to control the data w/o deepflush
in the case "no_deepflush=0".

Signed-off-by: Dennis.Wu <dennis.wu@intel.com>
---
 drivers/acpi/nfit/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e5d7f2bda13f..ec0ad48b0283 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -52,6 +52,10 @@ static bool force_labels;
 module_param(force_labels, bool, 0444);
 MODULE_PARM_DESC(force_labels, "Opt-in to labels despite missing methods");
 
+static bool no_deepflush;
+module_param(no_deepflush, bool, 0644);
+MODULE_PARM_DESC(no_deepflush, "skip deep flush if ADR or no strict security");
+
 LIST_HEAD(acpi_descs);
 DEFINE_MUTEX(acpi_desc_lock);
 
@@ -981,8 +985,10 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc,
 			return err;
 		break;
 	case ACPI_NFIT_TYPE_FLUSH_ADDRESS:
-		if (!add_flush(acpi_desc, prev, table))
-			return err;
+		if (!no_deepflush) {
+			if (!add_flush(acpi_desc, prev, table))
+				return err;
+		}
 		break;
 	case ACPI_NFIT_TYPE_SMBIOS:
 		dev_dbg(dev, "smbios\n");
-- 
2.27.0

