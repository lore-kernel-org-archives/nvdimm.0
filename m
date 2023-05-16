Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04859290FE
	for <nvdimm@lists.linux.dev>; Tue, 16 May 2023 20:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732D4C433D2;
	Tue, 16 May 2023 20:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684268061;
	bh=foQZo0SMEEOSfOdU0XLlammV/Ut/rproT2TVSSLaIUk=;
	h=From:To:Cc:Subject:Date:From;
	b=OM32YbEUQC5xVxtE0YnqTboB3+rRk0HRaUEGVOOJ6CQ2+Xf9Ikx8Q/laibk1Wk/r5
	 zQtmUYJ75+J76otp5VRLXteHm89654iO8R6rWKS5KxYFlzpQOkplskfGmZjtJa2xDk
	 norKmHvyyTC15SHkhEv2YPqslSB9xpHsqG+z+k4WS719hGcO4cSuOSz6B4jtcCC+P6
	 LjLfNHcARYJD1QoI9T6NFZvpCNF1CrhweY/gjT6PpXfY+5tkTiaK/mBaVyGQTbVijY
	 kvpHyzXPwM2L5Muj3Oqwv6J2d7X6o/wiEKDpW0g9oEFSIofNWdss8e7a6k5QofBdnT
	 nK8gDBJcEL6QQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Len Brown <lenb@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] acpi: nfit: add declaration in a local header
Date: Tue, 16 May 2023 22:14:07 +0200
Message-Id: <20230516201415.556858-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The nfit_intel_shutdown_status() function has a __weak defintion
in nfit.c and an override in acpi_nfit_test.c for testing
purposes. This works without an extern declaration, but causes
a W=1 build warning:

drivers/acpi/nfit/core.c:1717:13: error: no previous prototype for 'nfit_intel_shutdown_status' [-Werror=missing-prototypes]

Add a declaration in a header that gets included from both
sides to shut up the warning and ensure that the prototypes
actually match.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/acpi/nfit/nfit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 6023ad61831a..573bc0de2990 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -347,4 +347,6 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev);
 bool intel_fwa_supported(struct nvdimm_bus *nvdimm_bus);
 extern struct device_attribute dev_attr_firmware_activate_noidle;
+void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem);
+
 #endif /* __NFIT_H__ */
-- 
2.39.2

