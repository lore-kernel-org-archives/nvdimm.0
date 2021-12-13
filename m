Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3FE173
	for <nvdimm@lists.linux.dev>; Mon, 13 Dec 2021 20:46:32 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="238639314"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="238639314"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 12:46:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="660986846"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 12:46:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id 11196144; Mon, 13 Dec 2021 22:46:35 +0200 (EET)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] ACPI: NFIT: Import GUID before use
Date: Mon, 13 Dec 2021 22:46:32 +0200
Message-Id: <20211213204632.56735-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Strictly speaking the comparison between guid_t and raw buffer
is not correct. Import GUID to variable of guid_t type and then
compare.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/acpi/nfit/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7dd80acf92c7..e5d7f2bda13f 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -678,10 +678,12 @@ static const char *spa_type_name(u16 type)
 
 int nfit_spa_type(struct acpi_nfit_system_address *spa)
 {
+	guid_t guid;
 	int i;
 
+	import_guid(&guid, spa->range_guid);
 	for (i = 0; i < NFIT_UUID_MAX; i++)
-		if (guid_equal(to_nfit_uuid(i), (guid_t *)&spa->range_guid))
+		if (guid_equal(to_nfit_uuid(i), &guid))
 			return i;
 	return -1;
 }
-- 
2.33.0

