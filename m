Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7E04A998
	for <nvdimm@lists.linux.dev>; Thu, 30 Nov 2023 21:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EjIX3tI4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701381099; x=1732917099;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c8xfK4Lwc6GnJO84j+6EtrkLetRcmhaU8H5GJeoQv+o=;
  b=EjIX3tI4vUGKOcvN9j3QBlrP2qgglPk5VO7O4AW7p+kXxkyPjhMKnRRA
   lLKqa5hV3BkkC9dE4GcAJiSR68Rws92T2bPNwYyeIKsD/jsJKoDsr3+Rc
   1sz9C2v0NnH7SzsJqUncC4XitQBD3FCziF+UvF2sIg8rRNpkq0vuMoGLV
   Pmy9fC8EGI0AiFwCWemZxmM+eaE7jJnwv0+IyILdP2S0qcqjliS7AN72y
   OEHaYf/KPE7Bo8gHoKQXfNTz8zBz8jDqwuYLHpucc6EefQPxqtTXh3+Xx
   IEx9qe8FbHcG74dK5tcz2ld7FUUEx3ufGM9tw1YrWMHvUY/STyoUore+/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="373580134"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="373580134"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 13:51:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="745776648"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="745776648"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.212.76.125])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 13:51:37 -0800
Subject: [NDCTL PATCH v3 2/2] cxl: Add check for regions before disabling
 memdev
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com, caoqq@fujitsu.com
Date: Thu, 30 Nov 2023 14:51:37 -0700
Message-ID: <170138109724.2882696.123294980050048623.stgit@djiang5-mobl3>
In-Reply-To: <766e7de9-8f08-73f2-fc7f-253930f95625@fujitsu.com>
References: <766e7de9-8f08-73f2-fc7f-253930f95625@fujitsu.com>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add a check for memdev disable to see if there are active regions present
before disabling the device. This is necessary now regions are present to
fulfill the TODO that was left there. The best way to determine if a
region is active is to see if there are decoders enabled for the mem
device. This is also best effort as the state is only a snapshot the
kernel provides and is not atomic WRT the memdev disable operation. The
expectation is the admin issuing the command has full control of the mem
device and there are no other agents also attempt to control the device.

Reviewed-by: Quanquan Cao <caoqq@fujitsu.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v3:
- Add emission of warning for forcing operation. (Quanquan)
v2:
- Warn if active region regardless of -f. (Alison)
- Expound on -f behavior in man page. (Vishal)
---
 Documentation/cxl/cxl-disable-memdev.txt |    4 +++-
 cxl/memdev.c                             |   20 +++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/Documentation/cxl/cxl-disable-memdev.txt b/Documentation/cxl/cxl-disable-memdev.txt
index c4edb93ee94a..34b720288705 100644
--- a/Documentation/cxl/cxl-disable-memdev.txt
+++ b/Documentation/cxl/cxl-disable-memdev.txt
@@ -27,7 +27,9 @@ include::bus-option.txt[]
 	a device if the tool determines the memdev is in active usage. Recall
 	that CXL memory ranges might have been established by platform
 	firmware and disabling an active device is akin to force removing
-	memory from a running system.
+	memory from a running system. Going down this path does not offline
+	active memory if they are currently online. User is recommended to
+	offline and disable the appropriate regions before disabling the memdevs.
 
 -v::
 	Turn on verbose debug messages in the library (if libcxl was built with
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 2dd2e7fcc4dd..ed962d478048 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -437,14 +437,28 @@ static int action_free_dpa(struct cxl_memdev *memdev,
 
 static int action_disable(struct cxl_memdev *memdev, struct action_context *actx)
 {
+	struct cxl_endpoint *ep;
+	struct cxl_port *port;
+
 	if (!cxl_memdev_is_enabled(memdev))
 		return 0;
 
-	if (!param.force) {
-		/* TODO: actually detect rather than assume active */
+	ep = cxl_memdev_get_endpoint(memdev);
+	if (!ep)
+		return -ENODEV;
+
+	port = cxl_endpoint_get_port(ep);
+	if (!port)
+		return -ENODEV;
+
+	if (cxl_port_decoders_committed(port)) {
 		log_err(&ml, "%s is part of an active region\n",
 			cxl_memdev_get_devname(memdev));
-		return -EBUSY;
+		if (!param.force)
+			return -EBUSY;
+
+		log_err(&ml, "Forcing %s disable with an active region!\n",
+			cxl_memdev_get_devname(memdev));
 	}
 
 	return cxl_memdev_disable_invalidate(memdev);


