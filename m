Received: from mgamail.intel.com (unknown [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1CA18C32
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 20:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690834722; x=1722370722;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=9KUxKggT52Nk79ah5F4iJFawpXaXYYz7728SqGS+zRU=;
  b=R1DzH1d3uTAZLlMceeYlOO3Duc/f9ELw9wyGrODgcIXGKq3QYRQsYdDK
   yhHZPYx3BOBw5797hxRTpLIszX4+JcbbTf/LR4De1UGkTLMO9Dp+7HsL1
   /FXwsduBCiCA14tk6AmZ4FaUOKhFW7dtkzI2D8seJlnOO2BoD4g/3GtQg
   lZWgqM69Fx5tsKFWKAEDZWbMNyQxkkBDLIf4jx1S0fcT8oijRsMm8zh8c
   KjPtg3Xz1vcnt62ivL6ni73UiNK/gsafPuGUW1eZG3xlX/gquXxaD/WmA
   3AUfKkFQBAUVDr/w70YoPE8Y1lLT+8kGXVaui1cJMrsZ+WdEyAJUX44iW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="369123385"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="369123385"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 13:18:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="678448228"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="678448228"
Received: from bwoods1-mobl3.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.101.86])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 13:18:41 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Mon, 31 Jul 2023 14:18:26 -0600
Subject: [PATCH ndctl] cxl/memdev: initialize 'rc' in action_update_fw()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230731-coverity-fix-v1-1-9b70ff6aa388@intel.com>
X-B4-Tracking: v=1; b=H4sIABEXyGQC/x2MywqAIBAAf0X2nOADKvqV6BC61l40NKQQ/72l4
 wzMNCiYCQssokHGSoVSZNCDAHfu8UBJnhmMMlZNVkuXKhf3KwM9Er0zc/AjqoDAyZWR9b9bt94
 /LLqN3l4AAAA=
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=886;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=9KUxKggT52Nk79ah5F4iJFawpXaXYYz7728SqGS+zRU=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCknxGUb3u8xLeHY+8LyYtr6La7VEw9/+5rFttDIcsKqY
 wdfLbsu3VHKwiDGxSArpsjyd89HxmNy2/N5AhMcYeawMoEMYeDiFICJnOlmZLj0T/De0/lFs1al
 Xr/2cFrrhfmfVOpTTS0DRGfqJ8dNUjZhZOhhYtmdt+HkvMNVDocTnJanXnvudCimQFKpeca+RqP
 4AkYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Static analysis complains that in some cases, an uninitialized 'rc' can
get returned from action_update_fw(). Since this can only happen in a
'no-op' case, initialize rc to 0.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/memdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/memdev.c b/cxl/memdev.c
index 1ad871a..f6a2d3f 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -679,7 +679,7 @@ static int action_update_fw(struct cxl_memdev *memdev,
 	const char *devname = cxl_memdev_get_devname(memdev);
 	struct json_object *jmemdev;
 	unsigned long flags;
-	int rc;
+	int rc = 0;
 
 	if (param.cancel)
 		return cxl_memdev_cancel_fw_update(memdev);

---
base-commit: 32cec0c5cfe669940107ce030beeb1e02e5a767b
change-id: 20230731-coverity-fix-edc28fd6e0fe

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

