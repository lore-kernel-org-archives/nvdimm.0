Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E78F6002
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818134; x=1689354134;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AeWJ82o6BwFn1NlqdqKUFKk+NqL3Dqc98exzk9j2WHE=;
  b=X2AtudmRmr7N4tss+jn5iKTk7ia781oIceBlz1fTETSef2ywEZ7lw7i+
   N1bHoT2+aJsOv1azuazuBZa3s6T8YKEwMfFoiKScSWWYbPCMWkjNMP7qm
   xa+Yvj7q9LM1eq2cQLLGtWslXrHDT7aBz7Y3rHn1EqSIsWUOFGh9HTZvC
   OAN9PZzZtBGwTNHW/ju8FWJcLBo4wY9MXzVv1O94wVSS6bEVibXnfKXki
   kw9eosxMKhj4D335wsn4R+5WV3fPQwv/8W6232Esm3KBuMaiCdk6CHAC8
   6/uS1jluGmf9xGGLI1o+77B80ionSoCxh0xT9ffAO+3IHHch47ASKYbvc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="349541992"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="349541992"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:01:59 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="685643797"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:01:58 -0700
Subject: [ndctl PATCH v2 02/12] cxl/list: Emit endpoint decoders filtered by
 memdev
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:01:58 -0700
Message-ID: <165781811836.1555691.1997564050287016121.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

For example, dump all the endpoint decoders from memdev 'mem8'.

    cxl list -Di -m 8 -d endpoint

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/filter.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/cxl/filter.c b/cxl/filter.c
index 66fd7420144a..2f88a9d2f398 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -428,7 +428,9 @@ util_cxl_decoder_filter_by_memdev(struct cxl_decoder *decoder,
 				  const char *ident, const char *serial)
 {
 	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+	struct cxl_endpoint *endpoint;
 	struct cxl_memdev *memdev;
+	struct cxl_port *port;
 
 	if (!ident && !serial)
 		return decoder;
@@ -438,6 +440,12 @@ util_cxl_decoder_filter_by_memdev(struct cxl_decoder *decoder,
 			continue;
 		if (cxl_decoder_get_target_by_memdev(decoder, memdev))
 			return decoder;
+		port = cxl_decoder_get_port(decoder);
+		if (!port || !cxl_port_is_endpoint(port))
+			continue;
+		endpoint = cxl_port_to_endpoint(port);
+		if (cxl_endpoint_get_memdev(endpoint) == memdev)
+			return decoder;
 	}
 
 	return NULL;

