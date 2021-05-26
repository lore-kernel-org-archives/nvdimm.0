Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B93E6D14
	for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 23:33:16 +0000 (UTC)
IronPort-SDR: TRgd3U3mI/rZMTugYrIo+IC0THR94Lp0wJ7O9YGLN7wiYYrQFWuc6ytdIIiBVRjtBNpHz2ZI5e
 9J/ud0K5PsFQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="200711374"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="200711374"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 16:33:12 -0700
IronPort-SDR: SjQnqfseiNcmE3V1WE8qsCwzen3xkSCHaDZPycThijQ/ed5uEL+OHqYp/EJoGQ65HWaJ9WAAK+
 XScQhPsvxjqA==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="480317405"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 16:33:11 -0700
Subject: [ndctl PATCH 2/2] ndctl/scrub: Reread scrub-engine status at start
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Krzysztof Rusocki <krzysztof.rusocki@intel.com>, nvdimm@lists.linux.dev
Date: Wed, 26 May 2021 16:33:10 -0700
Message-ID: <162207199057.3715490.2469820075085914776.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given that the kernel has exponential backoff to cover the lack of
interrupts for scrub completion status there is a reasonable likelihood
that 'ndctl start-scrub' is issued while the hardware/platform scrub-state
is idle, but the kernel engine poll timer has not fired.

Trigger at least one poll cycle for the kernel to re-read the scrub-state
before reporting that ARS is busy.

Reported-by: Krzysztof Rusocki <krzysztof.rusocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index e5641feec23d..536e142cf6af 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1354,8 +1354,18 @@ static int __ndctl_bus_get_scrub_state(struct ndctl_bus *bus,
 NDCTL_EXPORT int ndctl_bus_start_scrub(struct ndctl_bus *bus)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	int rc;
+
+	rc = sysfs_write_attr(ctx, bus->scrub_path, "1\n");
 
-	return sysfs_write_attr(ctx, bus->scrub_path, "1\n");
+	/*
+	 * Try at least 1 poll cycle before reporting busy in case this
+	 * request hits the kernel's exponential backoff while the
+	 * hardware/platform scrub state is idle.
+	 */
+	if (rc == -EBUSY && ndctl_bus_poll_scrub_completion(bus, 1, 1) == 0)
+		return sysfs_write_attr(ctx, bus->scrub_path, "1\n");
+	return rc;
 }
 
 NDCTL_EXPORT int ndctl_bus_get_scrub_state(struct ndctl_bus *bus)

