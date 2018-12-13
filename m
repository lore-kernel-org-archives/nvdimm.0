Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAF7C2119F070
 for <linux-nvdimm@lists.01.org>; Wed, 12 Dec 2018 20:30:35 -0800 (PST)
From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 61/73] acpi/nfit: Fix user-initiated ARS to be
 "ARS-long" rather than "ARS-short"
Date: Wed, 12 Dec 2018 23:28:26 -0500
Message-Id: <20181213042838.75160-61-sashal@kernel.org>
In-Reply-To: <20181213042838.75160-1-sashal@kernel.org>
References: <20181213042838.75160-1-sashal@kernel.org>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit b5fd2e00a60248902315fb32210550ac3cb9f44c ]

A "short" ARS (address range scrub) instructs the platform firmware to
return known errors. In contrast, a "long" ARS instructs platform
firmware to arrange every data address on the DIMM to be read / checked
for poisoned data.

The conversion of the flags in commit d3abaf43bab8 "acpi, nfit: Fix
Address Range Scrub completion tracking", changed the meaning of passing
'0' to acpi_nfit_ars_rescan(). Previously '0' meant "not short", now '0'
is ARS_REQ_SHORT. Pass ARS_REQ_LONG to restore the expected scrub-type
behavior of user-initiated ARS sessions.

Fixes: d3abaf43bab8 ("acpi, nfit: Fix Address Range Scrub completion tracking")
Reported-by: Jacek Zloch <jacek.zloch@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index c5d15752dfb3..75b331f8a16a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1303,7 +1303,7 @@ static ssize_t scrub_store(struct device *dev,
 	if (nd_desc) {
 		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 
-		rc = acpi_nfit_ars_rescan(acpi_desc, 0);
+		rc = acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
 	}
 	device_unlock(dev);
 	if (rc)
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
