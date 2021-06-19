Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C917172
	for <nvdimm@lists.linux.dev>; Sat, 19 Jun 2021 01:45:29 +0000 (UTC)
IronPort-SDR: vqvCvQjhB7VMrVL9ZyiBNFyGU3BHQ7qnMn8Pv6OiAsmrH/T1x7pGZhrNngXmjvzgFZ1DD+h61W
 pgy/cLuUcSCQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="187020486"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="187020486"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 18:45:28 -0700
IronPort-SDR: bh6qK3VRtfLHM5Jbxfhkzv9QXgoMwADb1BeOZ1E9pJ6ILJAlVl9j88jWYGLF2smbfHYrpQc+3+
 xKdxDfsropdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="489265509"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.53])
  by fmsmga002.fm.intel.com with ESMTP; 18 Jun 2021 18:45:28 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [ndctl PATCH] ndctl: do not try to load a key already on the kernel keyring
Date: Fri, 18 Jun 2021 18:40:54 -0700
Message-Id: <20210619014056.31907-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.17.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

During a bulk load of kernel keys, an attempt to load a key that is
already on the kernel keyring emits this ndctl error message:
	add_key failed: Invalid argument

and this message in the kernel log:
	encrypted_key: keyword 'load' not allowed when called from .update method

Avoid these error messages by checking the kernel keyring before
trying to load.

Fixes: 9925be9d6793 ("ndctl: add a load-keys command and a modprobe config")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/load-keys.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
index 26648fe..9124d5b 100644
--- a/ndctl/load-keys.c
+++ b/ndctl/load-keys.c
@@ -132,6 +132,16 @@ static int load_dimm_keys(struct loadkeys *lk_ctx)
 			continue;
 		}
 
+		/* Skip if key is already on kernel keyring */
+		key = keyctl_search(KEY_SPEC_USER_KEYRING, "encrypted",
+				    desc, 0);
+
+		if (key > 0) {
+			free(fname);
+			free(blob);
+			continue;
+		}
+
 		key = add_key("encrypted", desc, blob, size,
 				KEY_SPEC_USER_KEYRING);
 		if (key < 0)

base-commit: 4e646fa490ba4b782afa188dd8818b94c419924e
-- 
2.25.1

