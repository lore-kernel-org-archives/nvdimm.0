Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F017DB
	for <nvdimm@lists.linux.dev>; Tue,  4 Jul 2023 08:17:55 +0000 (UTC)
Received: from cpc152649-stkp13-2-0-cust121.10-2.cable.virginm.net ([86.15.83.122] helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qGbEP-002i2E-4L; Tue, 04 Jul 2023 09:17:53 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
	(envelope-from <ben@rainbowdash>)
	id 1qGbEO-0003AV-1k;
	Tue, 04 Jul 2023 09:17:52 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	lenb@kernel.org,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] ACPI: NFIT: limit string attribute write
Date: Tue,  4 Jul 2023 09:17:51 +0100
Message-Id: <20230704081751.12170-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we're writing what could be an arbitrary sized string into an attribute
we should probably use snprintf() just to be safe. Most of the other
attriubtes are some sort of integer so unlikely to be an issue so not
altered at this time.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 9213b426b125..d7e9d9cd16d2 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1579,7 +1579,7 @@ static ssize_t id_show(struct device *dev,
 {
 	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
-	return sprintf(buf, "%s\n", nfit_mem->id);
+	return snprintf(buf, PAGE_SIZE, "%s\n", nfit_mem->id);
 }
 static DEVICE_ATTR_RO(id);
 
-- 
2.40.1

