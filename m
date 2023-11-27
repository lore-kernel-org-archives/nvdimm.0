Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA102565
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OPsK5tHt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701057644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6KL4meGH1VBpK0txM6+IBEe0gpSpOaKW2gq1YmYsFHs=;
	b=OPsK5tHturbRKzCRwR7on+x2HYuElyqWVcEsY1x/9a7I6D3TzyMznNRj+PNYZuTz3mA2wu
	EUvOs0y27X58cr7mA2qxYrxJqt5rvLhdPPCAfOoHeNS8dtIHUAxjWYte1MffJ7v1l8Ls+W
	hoohqmSzf2nbDUpyig7+I1w6yH6R+Bo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-AUUpy3XDPgygAi3pxt0DCA-1; Sun,
 26 Nov 2023 23:00:38 -0500
X-MC-Unique: AUUpy3XDPgygAi3pxt0DCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27DB41C0170C;
	Mon, 27 Nov 2023 04:00:38 +0000 (UTC)
Received: from fedora34.. (unknown [10.66.146.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A4711121307;
	Mon, 27 Nov 2023 04:00:35 +0000 (UTC)
From: Yi Zhang <yi.zhang@redhat.com>
To: nvdimm@lists.linux.dev
Cc: gregkh@linuxfoundation.org,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Subject: [PATCH] ndtest: fix typo class_regster -> class_register
Date: Mon, 27 Nov 2023 12:00:26 +0800
Message-Id: <20231127040026.362729-1-yi.zhang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Fixes: dd6cad2dcb58 ("testing: nvdimm: make struct class structures constant")
Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
---
 tools/testing/nvdimm/test/ndtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index fd26189d53be..b8419f460368 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -924,7 +924,7 @@ static __init int ndtest_init(void)
 
 	nfit_test_setup(ndtest_resource_lookup, NULL);
 
-	rc = class_regster(&ndtest_dimm_class);
+	rc = class_register(&ndtest_dimm_class);
 	if (rc)
 		goto err_register;
 
-- 
2.34.3

