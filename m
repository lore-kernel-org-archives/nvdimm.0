Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19EF72
	for <nvdimm@lists.linux.dev>; Sat, 19 Jun 2021 01:45:32 +0000 (UTC)
IronPort-SDR: FXBaFFzN8MiK3ESdvLR7p/uWOj1v3ypnlanW0gBRnL8qpsXrLzbKEiFuhvb0xrGzZOc2v3WfCj
 QKB+DV+pZUMw==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="204816937"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="204816937"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 18:45:31 -0700
IronPort-SDR: oDn1q7i+fYELmCFAwvV/PVSpoYizZ4rQ0uVIKNlsB8dC0b4AXITkvO7etF0Y29EDQQzQqjIdiK
 wA8x7lNA8Z9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="485881671"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.53])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2021 18:45:31 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [ndctl PATCH] ndctl: return -errno when keyctl_read_alloc() fails
Date: Fri, 18 Jun 2021 18:40:56 -0700
Message-Id: <20210619014056.31907-3-alison.schofield@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210619014056.31907-1-alison.schofield@intel.com>
References: <20210619014056.31907-1-alison.schofield@intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

When keyctl_read_alloc() fails during key creation a stale rc
value is returned as a key serial number, rather than the errno
from keyctl_read_alloc(). The nvdimm driver eventually discovers
it's a bad key serial number, and the entire operation fails as
it should.

Fail immediately by using the available errno correctly.

Fixes: 86b078b44275 ("ndctl: add passphrase management commands")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/util/keys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index 30cb4c8..d1cc890 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -254,6 +254,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 
 	size = keyctl_read_alloc(key, &buffer);
 	if (size < 0) {
+		rc = -errno;
 		fprintf(stderr, "keyctl_read_alloc failed: %s\n", strerror(errno));
 		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
 		return rc;

base-commit: 4e646fa490ba4b782afa188dd8818b94c419924e
-- 
2.25.1

