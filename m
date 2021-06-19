Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A65A2FB4
	for <nvdimm@lists.linux.dev>; Sat, 19 Jun 2021 01:45:34 +0000 (UTC)
IronPort-SDR: Q+kQ4eg4KIEoiw46X2HsDmYto8XG0NRLfRz9n1BuVsPQW+t+oIRXc/4R+nIOaM7H5qDTA8fG2p
 VPzQLvNmvDyA==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="204816938"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="204816938"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 18:45:32 -0700
IronPort-SDR: 59KvrXc2kBawd0MFZt/WFFUFV9xImsr803XdfOVtmqsW58vwQ/SMNUZFt2836QgLcR9PzOZYEf
 lij3d6Cmg/Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="485881670"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.53])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2021 18:45:31 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [ndctl PATCH] ndctl: remove key from kernel keyring if blob storage fails
Date: Fri, 18 Jun 2021 18:40:55 -0700
Message-Id: <20210619014056.31907-2-alison.schofield@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210619014056.31907-1-alison.schofield@intel.com>
References: <20210619014056.31907-1-alison.schofield@intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

When a new passphrase key is created, the encrypted blob is always
written to storage. If the write to storage fails the passphrase is
not applied to the NVDIMM. That is all good. The unused key however
is left lingering on the kernel keyring. That blocks subsequent
attempts to add a passphrase key for the same NVDIMM. (presumably
after correcting the storage issue)

Unlink the key from the kernel keyring upon failures in key storage.

Fixes: 86b078b44275 ("ndctl: add passphrase management commands")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/util/keys.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index 30cb4c8..dbd622a 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -264,6 +264,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		rc = -errno;
 		fprintf(stderr, "Unable to open file %s: %s\n",
 				path, strerror(errno));
+		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
 		free(buffer);
 		return rc;
 	}
@@ -276,6 +277,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 			rc = -EIO;
 		fprintf(stderr, "Failed to write to %s: %s\n",
 				path, strerror(-rc));
+		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
 		fclose(fp);
 		free(buffer);
 		return rc;

base-commit: 4e646fa490ba4b782afa188dd8818b94c419924e
-- 
2.25.1

