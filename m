Return-Path: <SRS0=/BNo=ES=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.1 required=3.0 tests=BAYES_50,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9730C2D0A3
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Nov 2020 09:35:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AAB7C221FC
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Nov 2020 09:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=miral-logistics.com header.i=offices@miral-logistics.com header.b="CRpwzw8+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAB7C221FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=miral-logistics.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EC9C9100EF265;
	Thu, 12 Nov 2020 01:35:20 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.84.196.252; helo=poi0.miral-logistics.com; envelope-from=offices@miral-logistics.com; receiver=<UNKNOWN> 
Received: from poi0.miral-logistics.com (poi0.miral-logistics.com [45.84.196.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1BF00100EF260
	for <linux-nvdimm@lists.01.org>; Thu, 12 Nov 2020 01:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=default; d=miral-logistics.com;
 h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
 i=offices@miral-logistics.com;
 bh=y9mJNhqINIyqyPOE/r2YiiZrnzVbWgHefajYHgqowDc=;
 b=CRpwzw8+bij5leS/5RWlcMbikpCINV1IJDmaMkUq3KmyUTqVzOMui986cH/NIfTqBGVs60V+sbTA
   jWd44Fv38fsD2XVIN60SAU1cMgC/USqs62LwBf8tFmEFmh6q/GkL0jBjvOSKlfmaPJAAFLlA7ml7
   W5i0CCtWSWLnT9Y2GRw=
thread-index: Ada41x8HrVQ6au4GTiqbS8hDoxwLTg==
Thread-Topic: AL HASHIMYA TRADING Revised  Order Request 778988647TGTTU
From: =?utf-8?Q?Moinuddin?= <offices@miral-logistics.com>
To: <linux-nvdimm@lists.01.org>
Subject: AL HASHIMYA TRADING Revised  Order Request 778988647TGTTU
Date: Thu, 12 Nov 2020 01:35:13 -0800
Message-ID: <E3604DEDCF494063AEAF1B2AC9A7A888@WIN344VU98D3RU>
MIME-Version: 1.0
Content-Class: urn:content-classes:message
Importance: normal
Priority: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.3.9600.19846
Message-ID-Hash: DEGOJ3CXJKAYJS5OZRCP7GSW5E5TY2KZ
X-Message-ID-Hash: DEGOJ3CXJKAYJS5OZRCP7GSW5E5TY2KZ
X-MailFrom: offices@miral-logistics.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DEGOJ3CXJKAYJS5OZRCP7GSW5E5TY2KZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
