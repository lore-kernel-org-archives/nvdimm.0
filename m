Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE7563A8
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 19:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695669659; x=1727205659;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OpTLJSCzmnb0yiCSrGuA6JifdeQHVr2HSi/CGtXmI+0=;
  b=AB9asTMVL0hZkcQc3l+m7UPeEsmFuoxXu4/ksOrKH+NOj8acwKMne1sz
   ew0ZjlcxzegBXpkmSfbqK+VoUXgaK4BJNZejtOwi421zvxNqdUGaJ/w1/
   jeeWtXxgBHPj6vS0K+okfMg/OazYjs44OPI3j6vkarn8lNl7GFcjJLPeW
   yeGBONw2t2b+Z7dNphM5K3w6v2UEEVidKb8AHh1mA3EGHUAoGD0ghUmFw
   DhfOCvSGMbpz0bi9gwHRg7aFT6tBFB5BomUtON8It6BCW0VWaIEOyrd2r
   r3M/K9zqeheGre37B0FXzN4a9Tz/lbFUJzo3cIG5KdBcM3iABIcfr54ve
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="380223104"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="380223104"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 12:20:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995504800"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="995504800"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.209.161.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 12:20:40 -0700
Subject: [PATCH 2/2] cxl: Add check for regions before disabling memdev
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, lizhijian@fujitsu.com,
 yangx.jy@fujitsu.com, caoqq@fujitsu.com
Date: Mon, 25 Sep 2023 12:20:40 -0700
Message-ID: <169566964012.3704458.3768477727985056846.stgit@djiang5-mobl3>
In-Reply-To: <169566963425.3704458.5249885814603187091.stgit@djiang5-mobl3>
References: <169566963425.3704458.5249885814603187091.stgit@djiang5-mobl3>
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
 cxl/memdev.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/cxl/memdev.c b/cxl/memdev.c
index f6a2d3f1fdca..644369321649 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -373,11 +373,36 @@ static int action_free_dpa(struct cxl_memdev *memdev,
 
 static int action_disable(struct cxl_memdev *memdev, struct action_context *actx)
 {
+	struct cxl_decoder *decoder;
+	struct cxl_endpoint *ep;
+	bool committed = false;
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
+	/*
+	 * Look for a committed decoder, which indicates that the region the
+	 * memdev belongs to is active. This is best effort as the decoder
+	 * state is pulled from sysfs and not atomic. The caller should be in
+	 * control of the device to prevent state changes for the decoder.
+	 */
+	cxl_decoder_foreach(port, decoder) {
+		if (cxl_decoder_is_committed(decoder)) {
+			committed = true;
+			break;
+		}
+	}
+
+	if (committed && !param.force) {
 		log_err(&ml, "%s is part of an active region\n",
 			cxl_memdev_get_devname(memdev));
 		return -EBUSY;


