Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com
 [IPv6:2a00:1450:4864:20::444])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 174DB211A3216
 for <linux-nvdimm@lists.01.org>; Mon,  7 Jan 2019 20:59:14 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id u4so2703624wrp.3
 for <linux-nvdimm@lists.01.org>; Mon, 07 Jan 2019 20:59:14 -0800 (PST)
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] nfit: Hide unused functions behind CONFIG_X86
Date: Mon,  7 Jan 2019 21:58:53 -0700
Message-Id: <20190108045853.5471-1-natechancellor@gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On arm64 little endian allyesconfig:

drivers/acpi/nfit/intel.c:149:12: warning: unused function 'intel_security_unlock' [-Wunused-function]
static int intel_security_unlock(struct nvdimm *nvdimm,
           ^
drivers/acpi/nfit/intel.c:230:12: warning: unused function 'intel_security_erase' [-Wunused-function]
static int intel_security_erase(struct nvdimm *nvdimm,
           ^
drivers/acpi/nfit/intel.c:279:12: warning: unused function 'intel_security_query_overwrite' [-Wunused-function]
static int intel_security_query_overwrite(struct nvdimm *nvdimm)
           ^
drivers/acpi/nfit/intel.c:316:12: warning: unused function 'intel_security_overwrite' [-Wunused-function]
static int intel_security_overwrite(struct nvdimm *nvdimm,
           ^
4 warnings generated.

These functions are only used in __intel_security_ops when CONFIG_X86 is
set so only define these functions under that same condition.

Fixes: 4c6926a23b76 ("acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/acpi/nfit/intel.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 850b2927b4e7..2ba0f1543940 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -144,6 +144,7 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
 	}
 }
 
+#ifdef CONFIG_X86
 static void nvdimm_invalidate_cache(void);
 
 static int intel_security_unlock(struct nvdimm *nvdimm,
@@ -186,6 +187,7 @@ static int intel_security_unlock(struct nvdimm *nvdimm,
 
 	return 0;
 }
+#endif
 
 static int intel_security_disable(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *key_data)
@@ -227,6 +229,7 @@ static int intel_security_disable(struct nvdimm *nvdimm,
 	return 0;
 }
 
+#ifdef CONFIG_X86
 static int intel_security_erase(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *key,
 		enum nvdimm_passphrase_type ptype)
@@ -360,16 +363,10 @@ static int intel_security_overwrite(struct nvdimm *nvdimm,
  * TODO: define a cross arch wbinvd equivalent when/if
  * NVDIMM_FAMILY_INTEL command support arrives on another arch.
  */
-#ifdef CONFIG_X86
 static void nvdimm_invalidate_cache(void)
 {
 	wbinvd_on_all_cpus();
 }
-#else
-static void nvdimm_invalidate_cache(void)
-{
-	WARN_ON_ONCE("cache invalidation required after unlock\n");
-}
 #endif
 
 static const struct nvdimm_security_ops __intel_security_ops = {
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
