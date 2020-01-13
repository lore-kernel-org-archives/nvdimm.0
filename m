Return-Path: <SRS0=iRRW=3C=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A54FC33CAE
	for <linux-nvdimm@archiver.kernel.org>; Mon, 13 Jan 2020 04:25:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D33EE2187F
	for <linux-nvdimm@archiver.kernel.org>; Mon, 13 Jan 2020 04:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fossix-org.20150623.gappssmtp.com header.i=@fossix-org.20150623.gappssmtp.com header.b="zyUr2rNp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D33EE2187F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fossix.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4F8F510097DFF;
	Sun, 12 Jan 2020 20:28:35 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::544; helo=mail-pg1-x544.google.com; envelope-from=santosh@fossix.org; receiver=<UNKNOWN> 
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B036910097DFC
	for <linux-nvdimm@lists.01.org>; Sun, 12 Jan 2020 20:28:33 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id z124so4047582pgb.13
        for <linux-nvdimm@lists.01.org>; Sun, 12 Jan 2020 20:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rEiu61hfrDzYCZ0RHWcn4hvsw8N3anJIhVYEsMNyMbA=;
        b=zyUr2rNpwCUcHC8LupUDDfaqysLNcMF3XeafndkxtOOBH3GPCxbkX/x5F1xGWpCRhr
         ATz2QxSCGRI22Sp+0WaJ/nCxKkNYRUe+JhFNXjqcK2b8omfXm/RuW81mcxV7x1Wm3C61
         jVKkQpjT1miBROiMKq6UkN+Y7dm5QIe0wxpQz9rsk0yZ5eYD+pa11fxV9y/XL85O9hqy
         HAifi7zlNNXSsJGb4+ZfEi4xuuIA6y+Rp/vVTb1Ou70/nlqM1p0C7MmnM/BJgx43uLz5
         H0WF4y9CD2ys2P+t2UVWaV/RCAuP4AVirKy1ZJZUJfFahaqZBZLJgavhYgj702JHgZjC
         uoBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rEiu61hfrDzYCZ0RHWcn4hvsw8N3anJIhVYEsMNyMbA=;
        b=Y8hbo51e6HnW/qeRc5HMNusOODUeUiIoaAJ2Z60ylKPowWL8VtFBC91Ak0QxU+hVhT
         o5NjRKTW92bYC3xVrP7S0YhKkeQuT9jriA1mR8TqDGETR6DjQXnIP/Eb2rpPzmqAdYrU
         Pg5JRiZ5p7mHp8OITVkwsXPa27tjKf8Se08X7FzcvGDAhMvjCCj1c/ChumdFNoWnEuIK
         JgggnZHSva8zJ/GeWxfq4v4fBmOow/Dp9IT2vgmlQrtRkCK5zYJtub8MxEleQmxVhlmi
         c/lqAFgAEzjKItYoh0xg3un9Vz/W+yEFzi+Y1ai68qoZhC7nzpfPsLhNV5aVkpzmO4+L
         WZjA==
X-Gm-Message-State: APjAAAVj3ZqK8sP+M4uGUSrBz1sGPbjaxBso/kNysxG7z0XHm0Z3bxfQ
	7sKQByqSVE6SHTUr5dpx36bgSKflxkY=
X-Google-Smtp-Source: APXvYqzERxyIwm035rvmSi5yW+D2D8L6PK6zHFzJIfgIpHS3//qQPnm9hGYSEKf6ZHXHk9ePXzY4ow==
X-Received: by 2002:a62:14cc:: with SMTP id 195mr17102037pfu.160.1578889514347;
        Sun, 12 Jan 2020 20:25:14 -0800 (PST)
Received: from santosiv.in.ibm.com ([129.41.84.74])
        by smtp.gmail.com with ESMTPSA id 64sm12028331pfd.48.2020.01.12.20.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jan 2020 20:25:13 -0800 (PST)
From: Santosh Sivaraj <santosh@fossix.org>
To: linux-nvdimm@lists.01.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 ndctl] ndctl/namespace: Fix enable-namespace error for seed namespaces
Date: Mon, 13 Jan 2020 09:54:53 +0530
Message-Id: <20200113042453.3579711-1-santosh@fossix.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Message-ID-Hash: U7YDJNSYCMXMPARJSVM4SJGTYHBF5Z7U
X-Message-ID-Hash: U7YDJNSYCMXMPARJSVM4SJGTYHBF5Z7U
X-MailFrom: santosh@fossix.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: harish@linux.ibm.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/U7YDJNSYCMXMPARJSVM4SJGTYHBF5Z7U/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

'ndctl enable-namespace all' tries to enable seed namespaces too, which results
in a error like

libndctl: ndctl_namespace_enable: namespace1.0: failed to enable

Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
---
 ndctl/lib/libndctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 6596f94..9c6ccb8 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -4010,11 +4010,16 @@ NDCTL_EXPORT int ndctl_namespace_enable(struct ndctl_namespace *ndns)
 	const char *devname = ndctl_namespace_get_devname(ndns);
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
 	struct ndctl_region *region = ndns->region;
+	unsigned long long size = ndctl_namespace_get_size(ndns);
 	int rc;
 
 	if (ndctl_namespace_is_enabled(ndns))
 		return 0;
 
+	/* Don't try to enable idle namespace (no capacity allocated) */
+	if (size == 0)
+		return -ENXIO;
+
 	rc = ndctl_bind(ctx, ndns->module, devname);
 
 	/*
-- 
2.24.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
