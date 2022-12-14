Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B01BA24
	for <nvdimm@lists.linux.dev>; Wed, 14 Dec 2022 22:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671055238; x=1702591238;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jzJLupQfWR0UE6bmX9NmgrmSiT/W0DNSMzNsbh18xuE=;
  b=OfKw6pNJErlsMPUVyYKelo76fhg1/nHSx+GO+jsWAEdAYcIDi363JAoK
   uqqK/PFGUaOuTYmUbnPWMw0HP7Uq1X4OqKpAsoECjg/B86trRl/7dKR1X
   NZTjk7zd3GGQCwuG5rr9dl4saVQZAbsaurLd5paCxGm+QaSJJwLEgpqiE
   bsvaWVacSXi52jVZl99pxTuO7z/PhLHBA+mJ4cS6ONagKWuDtA7Ee9sO4
   NtqgPiqbNFwJCuSqcOt6bguqc82HZzI01WObWGDxI9Sw/C+Txi/O/62bi
   5s6VBUHO9Yx5+sLfUaGaKCzynxIW7Yb2oy1esEC9cFFZg5gjUu7MPUHb6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="317233546"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="317233546"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="791406252"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="791406252"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:37 -0800
Subject: [ndctl PATCH v2 3/4] ndctl/libndctl: Allow retrievng of unique_id for
 CXL mem dev
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 14 Dec 2022 15:00:37 -0700
Message-ID: 
 <167105523734.3034751.3059263405298786126.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
References: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

With bus_prefix, retrieve the unique_id of CXL mem device. This will
allow selecting a specific CXL mem device for the security test code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>


---
v2:
- Fix commit subject. (Vishal)
---
 ndctl/lib/libndctl.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index d2e800bc840a..c569178b9a3a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1749,6 +1749,33 @@ NDCTL_EXPORT void ndctl_dimm_refresh_flags(struct ndctl_dimm *dimm)
 		parse_papr_flags(dimm, buf);
 }
 
+static int populate_cxl_dimm_attributes(struct ndctl_dimm *dimm,
+					const char *dimm_base)
+{
+	int rc = 0;
+	char buf[SYSFS_ATTR_SIZE];
+	struct ndctl_ctx *ctx = dimm->bus->ctx;
+	char *path = calloc(1, strlen(dimm_base) + 100);
+	const char *bus_prefix = dimm->bus_prefix;
+
+	if (!path)
+		return -ENOMEM;
+
+	sprintf(path, "%s/%s/id", dimm_base, bus_prefix);
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		dimm->unique_id = strdup(buf);
+		if (!dimm->unique_id) {
+			rc = -ENOMEM;
+			goto err_read;
+		}
+	}
+
+ err_read:
+
+	free(path);
+	return rc;
+}
+
 static int populate_dimm_attributes(struct ndctl_dimm *dimm,
 				    const char *dimm_base)
 {
@@ -2018,6 +2045,7 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 			rc = -ENOMEM;
 			goto out;
 		}
+		rc = populate_cxl_dimm_attributes(dimm, dimm_base);
 	}
 
 	if (rc == -ENODEV) {


