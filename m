Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8A92FB6
	for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 23:33:09 +0000 (UTC)
IronPort-SDR: /l6RvPkod9pNnCd/u9vWCMBAaNZevyfAyOEnwx6DEAWnlAbNRV4WVyo+CtagZ1Sij0yQ/bGMpg
 Oc3O8OYbGazw==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266498723"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="266498723"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 16:33:06 -0700
IronPort-SDR: TMD8eOBKFQ5rPABXxD8oJlahtK9Xr8wEwnHnGPPHkZI5ru9IhuKQIDk5IuF9oIQZOZPzxb4J3r
 3FfQucixDQMA==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="414665240"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 16:33:05 -0700
Subject: [ndctl PATCH 1/2] ndctl/scrub: Stop translating return values
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev
Date: Wed, 26 May 2021 16:33:04 -0700
Message-ID: <162207198482.3715490.5994844104395495686.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162207197868.3715490.6562405741837220139.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162207197868.3715490.6562405741837220139.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for triggering a poll loop within ndctl_bus_start_scrub(),
stop translating return values into -EOPNOTSUPP.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index aa36a3c87c57..e5641feec23d 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1354,14 +1354,8 @@ static int __ndctl_bus_get_scrub_state(struct ndctl_bus *bus,
 NDCTL_EXPORT int ndctl_bus_start_scrub(struct ndctl_bus *bus)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
-	int rc;
 
-	rc = sysfs_write_attr(ctx, bus->scrub_path, "1\n");
-	if (rc == -EBUSY)
-		return rc;
-	else if (rc < 0)
-		return -EOPNOTSUPP;
-	return 0;
+	return sysfs_write_attr(ctx, bus->scrub_path, "1\n");
 }
 
 NDCTL_EXPORT int ndctl_bus_get_scrub_state(struct ndctl_bus *bus)

