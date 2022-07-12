Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2501B538B
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 19:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657652882; x=1689188882;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AeWJ82o6BwFn1NlqdqKUFKk+NqL3Dqc98exzk9j2WHE=;
  b=PlKBhURyUxXo7v5h5//QlBYzjYdCE6IUpxBuSlC3RIsceh8VwqEtqgqr
   zthbbQ3XAX8lDea84laF8Uw3SKEFDy4ApzvpCv5K8B+sP8RATH0yfKkM1
   9XWbAF1CMxB7p+oKCNQovSJtoB54mEjGCfC9blMqL8AkUMCxbCslaaIF+
   1HUjr66EGEx1OgN09lKRI7c7d+N2KqkxhCViItO9bkGXqTMAKz0srmQLw
   vCST65uOL4N6AXKmsLBdPoWUfVzOwxM5BAw21R/3gQ3Mkm05PBzo9ArCg
   xOsb2/w9m1sTHCv2EsN1yZzgyoXMe56S7+ADSvoaGvI6yHGSyIhJIEdOw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="348995524"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="348995524"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="570316577"
Received: from sheyting-mobl3.amr.corp.intel.com (HELO [192.168.1.117]) ([10.212.147.156])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:36 -0700
Subject: [ndctl PATCH 02/11] cxl/list: Emit endpoint decoders filtered by
 memdev
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Tue, 12 Jul 2022 12:07:36 -0700
Message-ID: <165765285600.435671.1816486143808105272.stgit@dwillia2-xfh>
In-Reply-To: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
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

