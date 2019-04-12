Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tc-sys-mailedm04.tc.baidu.com (mx57.baidu.com [61.135.168.57])
 by ml01.01.org (Postfix) with ESMTP id A20AA211EB2B8
 for <linux-nvdimm@lists.01.org>; Thu, 11 Apr 2019 19:10:08 -0700 (PDT)
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
 by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id 56CCA236C005
 for <linux-nvdimm@lists.01.org>; Fri, 12 Apr 2019 10:10:06 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] acpi/nfit: ensure that intel passphrase length is not larger
 than nvdimm
Date: Fri, 12 Apr 2019 10:10:05 +0800
Message-Id: <1555035005-6070-1-git-send-email-lirongqing@baidu.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Both are same now, but if length of nvdimm passphrase is changed to
less than intel passphrase length, OOB access will happen

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/acpi/nfit/intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
index f70de71f79d6..9517fb0fd8b9 100644
--- a/drivers/acpi/nfit/intel.c
+++ b/drivers/acpi/nfit/intel.c
@@ -248,6 +248,8 @@ static int __maybe_unused intel_security_erase(struct nvdimm *nvdimm,
 		},
 	};
 
+	BUILD_BUG_ON(NVDIMM_PASSPHRASE_LEN < ND_INTEL_PASSPHRASE_SIZE);
+
 	if (!test_bit(cmd, &nfit_mem->dsm_mask))
 		return -ENOTTY;
 
-- 
2.16.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
