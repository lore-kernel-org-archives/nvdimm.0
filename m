Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com
 [IPv6:2a00:1450:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00F18211ADA2D
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 21:02:29 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id y139so6206106wmc.5
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 21:02:29 -0800 (PST)
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v2] nfit: Mark some functions as __maybe_unused
Date: Tue,  8 Jan 2019 22:00:37 -0700
Message-Id: <20190109050036.17322-1-natechancellor@gmail.com>
In-Reply-To: <20190108045853.5471-1-natechancellor@gmail.com>
References: <20190108045853.5471-1-natechancellor@gmail.com>
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

Mark these functions as __maybe_unused because they are only used when
CONFIG_X86 is set.

Fixes: 4c6926a23b76 ("acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs")
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Mark the functions as __maybe_unused rather than expanding the
  CONFIG_X86, as requested by Dan.

 drivers/acpi/nfit/intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index 850b2927b4e7..f70de71f79d6 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -146,7 +146,7 @@ static int intel_security_change_key(struct nvdimm *nvdimm,
 
 static void nvdimm_invalidate_cache(void);
 
-static int intel_security_unlock(struct nvdimm *nvdimm,
+static int __maybe_unused intel_security_unlock(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *key_data)
 {
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
@@ -227,7 +227,7 @@ static int intel_security_disable(struct nvdimm *nvdimm,
 	return 0;
 }
 
-static int intel_security_erase(struct nvdimm *nvdimm,
+static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *key,
 		enum nvdimm_passphrase_type ptype)
 {
@@ -276,7 +276,7 @@ static int intel_security_erase(struct nvdimm *nvdimm,
 	return 0;
 }
 
-static int intel_security_query_overwrite(struct nvdimm *nvdimm)
+static int __maybe_unused intel_security_query_overwrite(struct nvdimm *nvdimm)
 {
 	int rc;
 	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
@@ -313,7 +313,7 @@ static int intel_security_query_overwrite(struct nvdimm *nvdimm)
 	return 0;
 }
 
-static int intel_security_overwrite(struct nvdimm *nvdimm,
+static int __maybe_unused intel_security_overwrite(struct nvdimm *nvdimm,
 		const struct nvdimm_key_data *nkey)
 {
 	int rc;
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
