Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B9F3D84
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183849; x=1682719849;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PBTLU2Ut0BNAm+/bMqdFhOHLzc/Mr8QrZbbCovHeDwI=;
  b=cc/6q0QxL+wLIudq4jFz7QZ0+HtXdsVEaomZ2bK8La7MaOgP3fntzMAF
   vDube+Eu/ko3iecDORWxTw8jIKZBkePP2m0/w+ZlcE65bnvWUASMFFTj6
   ERlHbUGRtcOweZgi7qUaijHZWGKYyK8G3FlhNPQ59YAfPh77UJBYDBTbD
   16hb5T3g7YxksgqpI1+PFT0eluVCXGP0ujSz4nRLOvMsLSR9TEVXMxmE9
   XkFhp6Ua4RMo32w8db02KyBJuNRAKBjUSspPsXbScgSYOlqBkbX55ksH2
   7LorrhMSfnU9oKXjOTptKUpMlSM1eS+wG4gJWFUyQWe1crm7thwOWI5wi
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265967748"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265967748"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:49 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="879336239"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:48 -0700
Subject: [ndctl PATCH 09/10] cxl/port: Relax port identifier validation
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:48 -0700
Message-ID: <165118384845.1676208.7570620216888371408.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that util_cxl_port_filter() accepts port host identifiers it is no
longer possible to pre-validate that the port arguments follow the "port%d"
format. Instead, let all inputs through and warn if the filter fails to
identify a port.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/port.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/cxl/port.c b/cxl/port.c
index 46a8f32df8e1..89f3916d85aa 100644
--- a/cxl/port.c
+++ b/cxl/port.c
@@ -145,7 +145,6 @@ static int port_action(int argc, const char **argv, struct cxl_ctx *ctx,
 		usage,
 		NULL
 	};
-	unsigned long id;
 
 	log_init(&pl, "cxl port", "CXL_PORT_LOG");
 	argc = parse_options(argc, argv, options, u, 0);
@@ -153,31 +152,10 @@ static int port_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	if (argc == 0)
 		usage_with_options(u, options);
 	for (i = 0; i < argc; i++) {
-		const char *fmt;
-
 		if (strcmp(argv[i], "all") == 0) {
 			argc = 1;
 			break;
 		}
-
-		if (param.endpoint)
-			fmt = "endpoint%lu";
-		else
-			fmt = "port%lu";
-
-		if (sscanf(argv[i], fmt, &id) == 1)
-			continue;
-		if (sscanf(argv[i], "%lu", &id) == 1)
-			continue;
-
-		log_err(&pl, "'%s' is not a valid %s identifer\n", argv[i],
-			param.endpoint ? "endpoint" : "port");
-		err++;
-	}
-
-	if (err == argc) {
-		usage_with_options(u, options);
-		return -EINVAL;
 	}
 
 	if (param.debug) {
@@ -187,7 +165,6 @@ static int port_action(int argc, const char **argv, struct cxl_ctx *ctx,
 		pl.log_priority = LOG_INFO;
 
 	rc = 0;
-	err = 0;
 	count = 0;
 
 	for (i = 0; i < argc; i++) {
@@ -198,15 +175,16 @@ static int port_action(int argc, const char **argv, struct cxl_ctx *ctx,
 
 			endpoint = find_cxl_endpoint(ctx, argv[i]);
 			if (!endpoint) {
-				log_dbg(&pl, "endpoint: %s not found\n",
-					argv[i]);
+				log_notice(&pl, "endpoint: %s not found\n",
+					   argv[i]);
 				continue;
 			}
 			port = cxl_endpoint_get_port(endpoint);
 		} else {
 			port = find_cxl_port(ctx, argv[i]);
 			if (!port) {
-				log_dbg(&pl, "port: %s not found\n", argv[i]);
+				log_notice(&pl, "port: %s not found\n",
+					   argv[i]);
 				continue;
 			}
 		}

