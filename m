Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0C41E496
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 20:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jm2lRUh3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701204296; x=1732740296;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xiWunW3tLxatCcTsfAT92QSg8IT5oJt1XnrD1Z6qJbw=;
  b=Jm2lRUh3nsZ5Q4bTzWm9gFs0GYI1/otVxGQHBrnifVqXMHSpUKsoHRiT
   gsz+tWp2TZeT0mdf4mA0iD/shMfCBbqtU1u1QnnKTC7cWSXJDTyg7cpJP
   C3Xgda8X4DoY2JRcKgGXgNVZbutTfUFb1OXM70+AqAlwwgYpaWQlRaByf
   U5WJMZgQSeHf8J/vce2aiqmxWropYEye10nquiLp7Ok5V2VDc5XqXIRDo
   13iI74+hNtcw97ZSugUbRZCKNvAgrH4hrmXG06YCpozQWNECIbZf47M8j
   T922wnXKLIpfRVkh53r1oBRL8oQ59fTd65dtT7EPV5YqDuT6f9ztm1H4R
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="424171260"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="424171260"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 12:43:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="834761200"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="834761200"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.209.164.208])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 12:43:57 -0800
Subject: [NDCTL PATCH v2 2/2] cxl: Add check for regions before disabling
 memdev
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com, caoqq@fujitsu.com
Date: Tue, 28 Nov 2023 13:43:57 -0700
Message-ID: <170120423751.2725915.8152057882418377474.stgit@djiang5-mobl3>
In-Reply-To: <170120423159.2725915.14670830315829916850.stgit@djiang5-mobl3>
References: <170120423159.2725915.14670830315829916850.stgit@djiang5-mobl3>
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

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v2:
- Warn if active region regardless of -f. (Alison)
- Expound on -f behavior in man page. (Vishal)
---
 Documentation/cxl/cxl-disable-memdev.txt |    4 +++-
 cxl/memdev.c                             |   17 ++++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

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
index 2dd2e7fcc4dd..1d3121915284 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -437,14 +437,25 @@ static int action_free_dpa(struct cxl_memdev *memdev,
 
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
 	}
 
 	return cxl_memdev_disable_invalidate(memdev);


