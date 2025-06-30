Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6B6BE4A
	for <nvdimm@lists.linux.dev>; Mon, 30 Jun 2025 07:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751268685; cv=none; b=Y9Iwk90OnB9Qjc9drEPhsH8MSoscse8iH4oLi5gaQanndE9/ZY875MBguSl878u0pLDKKMAE/fpq4BEZtVE3JncgRmErzvxizEOM078NcVFjluk2GRraNBfYwba9ynMWH0WtySlPJbtNo78SLprMa6Xx7/DqhFhev6D3321Mwgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751268685; c=relaxed/simple;
	bh=BsZKEQ661elV0QXZN17WsqZYgj+KxeoouXnGigbl0/w=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=ZLsiMWykGgdblaDhV9Qpt0yrI9P5CikfBprdw21UTJLd+j7UcT8OFMP7nLZW6hZGljEqPesasIpCIOgDvTLU6qYwsVyfetjhttjikpUSPQz6iCJikBN0CKKhGt3n/x/4IMJrP6taND7OaaxKdoVW0aGDSKkvU0yXpcRZFOiQaaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=job2MNzg; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="job2MNzg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1751268660;
	bh=acRuhVJNm/5ao++9HXjaYicVSjhVYVlvUhTL/L3NhF4=;
	h=From:To:Cc:Subject:Date;
	b=job2MNzg534CSW35MTS7uYHibgn3i6L6M8byX+tGd0gBcLjQHXqFp0q6k8klkdSDX
	 0JyUI/Z1Vflj0nxOnBljGvxZGUqD9ixh4sDhzHt90BvfqGlbHZYqwegHh9g8MYaXWY
	 BVEn+x1p2YaM4bvJ2SPLiRInTB3Omu1zCXJs7tAk=
Received: from NUC10 ([39.156.73.10])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 7BA046D9; Mon, 30 Jun 2025 15:30:58 +0800
X-QQ-mid: xmsmtpt1751268658tmilcc3h0
Message-ID: <tencent_96CACDEBC2683EE2A201BFD04C96C5E5A406@qq.com>
X-QQ-XMAILINFO: N9/m7ncAytaJ/aO6cjyypXUsOzV6MDeSlTb4nbDkyPOlq05sUy6sI6pz3JDjmW
	 iA5sfWmBi1j5Gpp0T/mDELImgOIK+twOK++5l3TREaJdM3CyBHyesSXtSOkh96onYioWuOeN6J9B
	 bl5vQv9hxI2oSFqErrLT8qLt4JH8MNoOpjsUqpnL2RT9A+NT0PpX5ez54tDejOdw/LF2UVY7JbA9
	 oAtYf9qwwxvjbVsLWSQvxLRY2/RWiGRfqn9K4vob0ynWoxP3KUvtaSfeYzaAB8nS5uANwm7mQv4d
	 tcCEIkrmr0lAUiSgm+OrDnSTlCeUSQm2xL/rm2laf8uM7bgFuLLxx9at4HHmbNamgqecqzNQuYpk
	 x9wiJCKeao3rMI0uH4m2XfeoGcHByc0nAPejB3bX58CF4zYen/1JwlKvNLIXw7nmlHVlGfCt4dlb
	 I03l5EBsGJdYlP9SEXlhqBQA4Qgc6boY4OmoVy3TTGQjILJlEOtGmFB5oftzk6cmXH7F+MuXbnQP
	 tOratCG9Zhs+F7LdkcI6uRf+ADltr1P70QBjDCUgs5nB3P1KnxQ4c6ecaSs6eRhTLCUIVtUH0rf5
	 tz3/MddZlGuJYNH+NpJbb7pRcxJWT5+MsozG4hZUwmggQf8NHHqOn6Q37JGhJkoEAGUKop4atVSw
	 iEu2Wg0227WjOfCynEFi+GYiBE0NfmXuv9MAACE/kTywrcBAVDj9ce+gUELXnk3s4Y8pTk78xQMG
	 VrXvIXeKGHqQ7puSQwb77F4W7c9bS1MEVhGaHnD6L6tBNRUjxAGwBoF7NA/0TRckb7VnEHPF3CcW
	 W5cpEUllfXqtSpssblQvfby3lo794qB/S5i40uQRo5yERofhnpS04DvJbXZOh8KEDZMQzdMFUZlz
	 WYaVTCH7LkB1pz4/U8p2Xlmrp2oJ8w4A+/18JM7JMFJF43nu0EAiPiLNW7gDz69yAiLIne998Fdj
	 ilBCKZRo09wTEKKZ9GP7Oq6XLArDmZcgf2+hNOoSS5NdonYMBL1A==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: Rong Tao <rtoax@foxmail.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Rong Tao <rongtao@cestc.cn>
Subject: [ndctl PATCH] cxl/monitor.c: Missing bracket
Date: Mon, 30 Jun 2025 15:30:29 +0800
X-OQ-MSGID: <20250630073029.313923-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rong Tao <rongtao@cestc.cn>

Missing a ')'.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 cxl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index 2066f984668d..fee9cdbe9b88 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -65,7 +65,7 @@ static int monitor_event(struct cxl_ctx *ctx)
 	inst = tracefs_instance_create("cxl_monitor");
 	if (!inst) {
 		rc = -errno;
-		err(&monitor, "tracefs_instance_create( failed: %d\n", rc);
+		err(&monitor, "tracefs_instance_create() failed: %d\n", rc);
 		goto inst_err;
 	}
 
-- 
2.50.0

