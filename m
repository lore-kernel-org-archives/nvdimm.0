Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A1127722
	for <nvdimm@lists.linux.dev>; Wed, 12 Jul 2023 11:58:02 +0000 (UTC)
Received: from [134.238.52.102] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qJYTi-0087tU-Jz; Wed, 12 Jul 2023 12:57:54 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
	(envelope-from <ben@rainbowdash>)
	id 1qJYTh-0005Nt-2J;
	Wed, 12 Jul 2023 12:57:53 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: nvdimm@lists.linux.dev
Cc: linux-acpi@vger.kernel.org,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [RESEND v2] ACPI: NFIT: limit string attribute write
Date: Wed, 12 Jul 2023 12:57:53 +0100
Message-Id: <20230712115753.20688-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we're writing what could be an arbitrary sized string into an attribute
we should probably use sysfs_emit() just to be safe. Most of the other
attriubtes are some sort of integer so unlikely to be an issue so not
altered at this time.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
v2:
  - use sysfs_emit() instead of snprintf.
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 9213b426b125..59c354137627 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1579,7 +1579,7 @@ static ssize_t id_show(struct device *dev,
 {
 	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
-	return sprintf(buf, "%s\n", nfit_mem->id);
+	return sysfs_emit(buf, "%s\n", nfit_mem->id);
 }
 static DEVICE_ATTR_RO(id);
 
-- 
2.40.1

