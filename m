Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A329517D2
	for <nvdimm@lists.linux.dev>; Thu, 11 Sep 2025 00:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757552348; cv=none; b=ofFG9zqxEXDoHYHdg/eiOQxTMY7+V50QwN8qZ104UMBk8K5cezFE3QfSOgTSfSJp8/9/g9SR1ZiLyFtZv0Iw5fEifyjy/VaLQOjKoW9PD5RnZSU+2Y0DxNW+n6CBb0/pif72a7au8NY4Nqp3/ui+T5bTilOY0Aa++nWGJP7SZrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757552348; c=relaxed/simple;
	bh=1PDJzxFfGfCHvBgkGhs2IUqQvAebQxljIXngKDKZe0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Q4ckhubH8gCvx1QE+ulUbMApCaYztt2xJ58nxBMueHPlMx8VH6YwEkSJEeC8diGSzzhG53XolzZR4V4p9o5ED+e6ZrMU0iJF02tYX4o8zLpJe9Sbm5DvCIiX5FyV9xGJdAms56yEacsRbcabKmrf+WzlQiQRCfTIyihf0uC35OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VFIE1+Sl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VFIE1+Sl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757552344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tAbj6OcDfKvJEXKa3ESUNs66JlqMBCcW3djeprN8t8Q=;
	b=VFIE1+Sl+ZJUCHFFbNne6PdZI84pSi1vMVpoKZNtqhH2qyxs0oNV/3RWF+LeimcS3x3Z8a
	Bdznhjskf3ZYHFcftVc8N9zeTXGjQTvaTrGyOw+3ezWsqDq0Je+74QGWGtPtNYGugWYaA+
	eUMQ5s8hjg3Vt/fdyRmbSy+TquvSmAE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-sOhzwXLTPDunDgAbBgqcig-1; Wed,
 10 Sep 2025 20:59:01 -0400
X-MC-Unique: sOhzwXLTPDunDgAbBgqcig-1
X-Mimecast-MFC-AGG-ID: sOhzwXLTPDunDgAbBgqcig_1757552340
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0120619560AE;
	Thu, 11 Sep 2025 00:59:00 +0000 (UTC)
Received: from vm-10-0-76-146.hosted.upshift.rdu2.redhat.com (vm-10-0-76-146.hosted.upshift.rdu2.redhat.com [10.0.76.146])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2B9421955F24;
	Thu, 11 Sep 2025 00:58:58 +0000 (UTC)
From: Yi Zhang <yi.zhang@redhat.com>
To: nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	linux-cxl@vger.kernel.org,
	dave.jiang@intel.com
Subject: [ndctl PATCH] test/dm.sh: fix incorrect script name in cleanup error message
Date: Wed, 10 Sep 2025 20:29:06 -0400
Message-ID: <20250911002906.806359-1-yi.zhang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: e_7c-3XjHA90u82dscoIOziovIuUad3bosdMR1XSJW8_1757552340
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The cleanup() function was incorrectly referencing "test/sub-section.sh"
instead of "test/dm.sh" in its error message.

Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
---
 test/dm.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/dm.sh b/test/dm.sh
index b780a65..e68d491 100755
--- a/test/dm.sh
+++ b/test/dm.sh
@@ -36,7 +36,7 @@ cleanup() {
 	for i in $namespaces
 	do
 		if ! $NDCTL destroy-namespace -f $i; then
-			echo "test/sub-section.sh: cleanup() failed to destroy $i"
+			echo "test/dm.sh: cleanup() failed to destroy $i"
 		fi
 	done
 	exit $rc
-- 
2.45.1

