Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x241.google.com (mail-qk0-x241.google.com
 [IPv6:2607:f8b0:400d:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94EC9210D6CE2
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 01:44:15 -0700 (PDT)
Received: by mail-qk0-x241.google.com with SMTP id c126-v6so1000272qkd.7
 for <linux-nvdimm@lists.01.org>; Thu, 02 Aug 2018 01:44:15 -0700 (PDT)
From: oceanhehy@gmail.com
Subject: [PATCH v2] ACPI: nfit: remove redundant assignment if nfit_mem found
Date: Thu,  2 Aug 2018 04:44:04 -0400
Message-Id: <1533199444-29607-1-git-send-email-oceanhehy@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, rjw@rjwysocki.net, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

When nfit_mem is found via list_for_each_entry, it has already been
assigned valid value. There is no need to assign it again in the following
codes.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
v1: https://patchwork.kernel.org/patch/10553277/
v2: Sorry for noise. I got an email problem, so I have to resend to loop 
linux-nvdimm@lists.01.org.

 drivers/acpi/nfit/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7c47900..85dde54 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1048,9 +1048,7 @@ static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
 				break;
 			}
 
-		if (found)
-			nfit_mem = found;
-		else {
+		if (!found) {
 			nfit_mem = devm_kzalloc(acpi_desc->dev,
 					sizeof(*nfit_mem), GFP_KERNEL);
 			if (!nfit_mem)
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
