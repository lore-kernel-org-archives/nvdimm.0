Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 5/6] nvdimm: Increase max envelope size for IOCTL
Date: Sun, 13 Dec 2015 18:54:26 -0700
Message-Id: <86a53c9b31149819e77dfb564b2f451c55379052.1450036445.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1450036445.git.jerry.hoemann@hpe.com>
References: <cover.1450036445.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1450036445.git.jerry.hoemann@hpe.com>
References: <cover.1450036445.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: robert.moore@intel.com, lv.zheng@intel.com, rafael.j.wysocki@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

In __nd_ioctl must first read in the fixed sized portion of an ioctl
so that it can then determine the size of the variable part.

Prepare for ND_CMD_CALL_DSM calls which have larger fixed portion
wrapper.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/linux/libnvdimm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 3f021dc..b0a2f60 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -27,7 +27,7 @@ enum {
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 	ND_CMD_MAX_ELEM = 4,
-	ND_CMD_MAX_ENVELOPE = 16,
+	ND_CMD_MAX_ENVELOPE = 256,
 	ND_CMD_ARS_STATUS_MAX = SZ_4K,
 	ND_MAX_MAPPINGS = 32,
 
-- 
1.7.11.3

