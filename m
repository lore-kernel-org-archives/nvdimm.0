Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649AE33D7
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 18:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669314913; x=1700850913;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CsyxjhJUa/MGvulmq3/ORKqKfwgMC1x1T5ChyWQbDr8=;
  b=aONPWd22Fx8M/bAOg9JlqKrR41ejrOZZteKm0gcJnj9fUOMLoVzfmyzR
   NtEibUneMkOaRhnWaDV20v3PlJTTSIelldeVypeGAuSZX+YMg0cBYY7eU
   TAwujC2ZfOVlwC6UxR4wp2IPPHiKm4DzPN1QmG82wm0WbasBGmKsCVhjJ
   LSOK1K3aA2gry5J4QOMbjx8Zh28Rli+4B4pBLpomnaLX2W9+Ew3UnIzqq
   yui4LsM/CY0foklCunX/Ai33aPefTgIK8SsX0TU8egUYPTG13b5M+yFLA
   wkQy4Ss4YYN/Rk+rSCTqwOC7aqsM+lKBtL8BwOSCI6VyuUVBcvWEoLJm6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314386021"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="314386021"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="816925943"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="816925943"
Received: from aglevin-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.65.252])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:10 -0800
Subject: [PATCH v4 06/12] tools/testing/cxl: Make mock CEDT parsing more
 robust
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 24 Nov 2022 10:35:10 -0800
Message-ID: <166931491054.2104015.16722069708509650823.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Accept any cxl_test topology device as the first argument in
cxl_chbs_context. This is in preparation for reworking the detection of
the component registers across VH and RCH topologies. Move
mock_acpi_table_parse_cedt() beneath the definition of is_mock_port()
and use is_mock_port() instead of the explicit mock cxl_acpi device
check.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/cxl.c |   80 +++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index facfcd11cb67..42a34650dd2f 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -320,46 +320,6 @@ static int populate_cedt(void)
 	return 0;
 }
 
-/*
- * WARNING, this hack assumes the format of 'struct
- * cxl_cfmws_context' and 'struct cxl_chbs_context' share the property that
- * the first struct member is the device being probed by the cxl_acpi
- * driver.
- */
-struct cxl_cedt_context {
-	struct device *dev;
-};
-
-static int mock_acpi_table_parse_cedt(enum acpi_cedt_type id,
-				      acpi_tbl_entry_handler_arg handler_arg,
-				      void *arg)
-{
-	struct cxl_cedt_context *ctx = arg;
-	struct device *dev = ctx->dev;
-	union acpi_subtable_headers *h;
-	unsigned long end;
-	int i;
-
-	if (dev != &cxl_acpi->dev)
-		return acpi_table_parse_cedt(id, handler_arg, arg);
-
-	if (id == ACPI_CEDT_TYPE_CHBS)
-		for (i = 0; i < ARRAY_SIZE(mock_cedt.chbs); i++) {
-			h = (union acpi_subtable_headers *)&mock_cedt.chbs[i];
-			end = (unsigned long)&mock_cedt.chbs[i + 1];
-			handler_arg(h, arg, end);
-		}
-
-	if (id == ACPI_CEDT_TYPE_CFMWS)
-		for (i = 0; i < ARRAY_SIZE(mock_cfmws); i++) {
-			h = (union acpi_subtable_headers *) mock_cfmws[i];
-			end = (unsigned long) h + mock_cfmws[i]->header.length;
-			handler_arg(h, arg, end);
-		}
-
-	return 0;
-}
-
 static bool is_mock_bridge(struct device *dev)
 {
 	int i;
@@ -410,6 +370,46 @@ static bool is_mock_port(struct device *dev)
 	return false;
 }
 
+/*
+ * WARNING, this hack assumes the format of 'struct cxl_cfmws_context'
+ * and 'struct cxl_chbs_context' share the property that the first
+ * struct member is cxl_test device being probed by the cxl_acpi
+ * driver.
+ */
+struct cxl_cedt_context {
+	struct device *dev;
+};
+
+static int mock_acpi_table_parse_cedt(enum acpi_cedt_type id,
+				      acpi_tbl_entry_handler_arg handler_arg,
+				      void *arg)
+{
+	struct cxl_cedt_context *ctx = arg;
+	struct device *dev = ctx->dev;
+	union acpi_subtable_headers *h;
+	unsigned long end;
+	int i;
+
+	if (!is_mock_port(dev) && !is_mock_dev(dev))
+		return acpi_table_parse_cedt(id, handler_arg, arg);
+
+	if (id == ACPI_CEDT_TYPE_CHBS)
+		for (i = 0; i < ARRAY_SIZE(mock_cedt.chbs); i++) {
+			h = (union acpi_subtable_headers *)&mock_cedt.chbs[i];
+			end = (unsigned long)&mock_cedt.chbs[i + 1];
+			handler_arg(h, arg, end);
+		}
+
+	if (id == ACPI_CEDT_TYPE_CFMWS)
+		for (i = 0; i < ARRAY_SIZE(mock_cfmws); i++) {
+			h = (union acpi_subtable_headers *) mock_cfmws[i];
+			end = (unsigned long) h + mock_cfmws[i]->header.length;
+			handler_arg(h, arg, end);
+		}
+
+	return 0;
+}
+
 static int host_bridge_index(struct acpi_device *adev)
 {
 	return adev - host_bridge;

