Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2837D250EE
	for <nvdimm@lists.linux.dev>; Wed,  4 Oct 2023 22:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INya+KxX"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696457311; x=1727993311;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yznFHA0lQ01H4WPA1Z9QMDpuEgbAMS4fJPI3+gTpSOw=;
  b=INya+KxX4XoBmwr84NEOKboILHEQOiiD/HH93ozibmpzQ/PDDv6hqNtY
   KzEHsj0Fsc5wwdKMPfy/npCLJ0/zjkoCf6tyXSlO1PNGIqheqQ0Cf1/gK
   PtydqLmZ63TVfjpNKo+E/KqC7KROgK2dvOvBvS3ECSfAegSI1talFeCC4
   s3d6GKkxsSyIwfGBOKwpcRH9ykgsOlhi3KGJDVn+FOKYhDnDdZD8vC7fu
   HX02e0qkm5QBrDImokWKjYCs8MlNHAZkDgrPEby3JLZL7GfTctfRqShhZ
   0ldCa0E4+8i+gLO/8HjizRf4rrfNUujIJ4Xx9+/3bnWYvxn8Rh1BgCO07
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="383223399"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="383223399"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 15:08:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="895155804"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="895155804"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.213.170.46])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 15:07:03 -0700
Subject: [NDCTL PATCH 2/2] cxl: Add check for regions before disabling memdev
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Wed, 04 Oct 2023 15:08:30 -0700
Message-ID: <169645731012.624805.15404457479294344934.stgit@djiang5-mobl3>
In-Reply-To: <169645730392.624805.16511039948183288287.stgit@djiang5-mobl3>
References: <169645730392.624805.16511039948183288287.stgit@djiang5-mobl3>
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
 cxl/memdev.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/cxl/memdev.c b/cxl/memdev.c
index f6a2d3f1fdca..314bac082719 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -373,11 +373,21 @@ static int action_free_dpa(struct cxl_memdev *memdev,
 
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
+	if (cxl_port_decoders_committed(port) && !param.force) {
 		log_err(&ml, "%s is part of an active region\n",
 			cxl_memdev_get_devname(memdev));
 		return -EBUSY;


