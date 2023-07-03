Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77C4F9E9
	for <nvdimm@lists.linux.dev>; Mon,  3 Jul 2023 14:08:51 +0000 (UTC)
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qGJBG-007U36-UD; Mon, 03 Jul 2023 14:01:26 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
	(envelope-from <ben@rainbowdash>)
	id 1qGJBG-004BQD-27;
	Mon, 03 Jul 2023 14:01:26 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: acpica-devel@lists.linuxfoundation.org
Cc: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lenb@kernel.org,
	nvdimm@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] ACPICA: actbl2: change to be16/be32 types for big endian data
Date: Mon,  3 Jul 2023 14:01:25 +0100
Message-Id: <20230703130125.997208-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some of the fields in struct acpi_nfit_control_region are used in big
endian format, and thus are generatng warnings from spare where the
member is passed to one of the conversion functions.

Fix the following sparse warnings by changing the data types:

drivers/acpi/nfit/core.c:1403:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1403:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1403:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1403:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1412:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1412:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1412:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1412:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1421:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1421:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1421:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1421:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1430:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1430:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1430:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1430:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1440:25: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1440:25: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1440:25: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1440:25: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1449:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1449:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1449:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1449:41: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1468:41: warning: cast to restricted __le16
drivers/acpi/nfit/core.c:1502:41: warning: cast to restricted __le16
drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1527:41: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1792:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1792:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1792:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1792:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1794:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1794:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1794:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1794:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1795:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1798:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1798:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1798:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1798:33: warning: cast to restricted __be16
drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32
drivers/acpi/nfit/core.c:1799:33: warning: cast to restricted __be32

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/acpi/nfit/core.c |  8 ++++----
 include/acpi/actbl2.h    | 18 +++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 07204d482968..0fcc247fdfac 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2194,15 +2194,15 @@ static const struct attribute_group *acpi_nfit_region_attribute_groups[] = {
 /* enough info to uniquely specify an interleave set */
 struct nfit_set_info {
 	u64 region_offset;
-	u32 serial_number;
+	__be32 serial_number;
 	u32 pad;
 };
 
 struct nfit_set_info2 {
 	u64 region_offset;
-	u32 serial_number;
-	u16 vendor_id;
-	u16 manufacturing_date;
+	__be32 serial_number;
+	__be16 vendor_id;
+	__be16 manufacturing_date;
 	u8 manufacturing_location;
 	u8 reserved[31];
 };
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 0029336775a9..c1df59aa8855 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -1716,18 +1716,18 @@ struct acpi_nfit_smbios {
 struct acpi_nfit_control_region {
 	struct acpi_nfit_header header;
 	u16 region_index;
-	u16 vendor_id;
-	u16 device_id;
-	u16 revision_id;
-	u16 subsystem_vendor_id;
-	u16 subsystem_device_id;
-	u16 subsystem_revision_id;
+	__be16 vendor_id;
+	__be16 device_id;
+	__be16  revision_id;
+	__be16 subsystem_vendor_id;
+	__be16 subsystem_device_id;
+	__be16 subsystem_revision_id;
 	u8 valid_fields;
 	u8 manufacturing_location;
-	u16 manufacturing_date;
+	__be16 manufacturing_date;
 	u8 reserved[2];		/* Reserved, must be zero */
-	u32 serial_number;
-	u16 code;
+	__be32 serial_number;
+	__le16 code;
 	u16 windows;
 	u64 window_size;
 	u64 command_offset;
-- 
2.40.1

