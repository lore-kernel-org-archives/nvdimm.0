Return-Path: <SRS0=leEO=BV=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F5DC433E1
	for <linux-nvdimm@archiver.kernel.org>; Tue, 11 Aug 2020 17:27:27 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CF15220782
	for <linux-nvdimm@archiver.kernel.org>; Tue, 11 Aug 2020 17:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=shieldpremiumpaintgh.com header.i=@shieldpremiumpaintgh.com header.b="an0PHyAQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF15220782
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=congoactuel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4BAE012E62107;
	Tue, 11 Aug 2020 10:27:26 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=149.72.68.197; helo=wrqvqqcr.outbound-mail.sendgrid.net; envelope-from=bounces+2503710-919f-linux-nvdimm=lists.01.org@en.shieldpremiumpaintgh.com; receiver=<UNKNOWN> 
Received: from wrqvqqcr.outbound-mail.sendgrid.net (wrqvqqcr.outbound-mail.sendgrid.net [149.72.68.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BFC8112E62105
	for <linux-nvdimm@lists.01.org>; Tue, 11 Aug 2020 10:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shieldpremiumpaintgh.com;
	h=from:subject:mime-version:to:content-type;
	s=s1; bh=XsjTwt21WI2/tTlDZpPUO9gf3HZNHFU711/Z0w8uFcI=;
	b=an0PHyAQlhxq7J39EXxURWiEdt0KVmmeqSA5KYsep2UJoAU2pGaQxM3vMUm9fKTD3bEN
	vkdFdM536lIdAAS9LGAHrpTNiKmckczxZTXIoOSyxnaEZyqU2qiJ6vt5DaHov4NjqHGyqX
	QIaITdgZF+DmP9yghqtzwTFPEOpHkmkv0=
Received: by filterdrecv-p1mdw1-asgard-a-5fd4df4599-dklbv with SMTP id filterdrecv-p1mdw1-asgard-a-5fd4df4599-dklbv-14-5F32D4FA-7C
        2020-08-11 17:27:22.545043304 +0000 UTC m=+333658.716419137
Received: from congoactuel.com (unknown)
	by ismtpd0041p1mdw1.sendgrid.net (SG) with ESMTP id pUtw0oD7QC6QPmCSXi_ipw
	for <linux-nvdimm@lists.01.org>; Tue, 11 Aug 2020 17:27:22.272 +0000 (UTC)
From: Ivan Lo | Wiloggroup <contact@congoactuel.com>
Subject: Quotation sheet for EFB-CS 20200609
Date: Tue, 11 Aug 2020 17:27:22 +0000 (UTC)
Message-ID: <20200812023203.09A5EC0D8A38422A@congoactuel.com>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?pIEfBIDQe+iTJGeB5K+gwvAH2CDdBVk7qaxrzpPn0JqiArbaf9OtawReIsUznl?=
 =?us-ascii?Q?7YDuu0jp4q7p9e=2FQQw7Xwx0UME1jE3584y9LZZJ?=
 =?us-ascii?Q?Ty04x0P+fiDQ+xn05lRy3+2awB9O3mneoHUEYuD?=
 =?us-ascii?Q?AnzwFlc9zgcyiRsMWGJcvFdjtJlrGm5bXdbXrfx?=
 =?us-ascii?Q?Ijkv7qAY76ep5+T3bNrNQBWe6Il6=2FNhg2Aj9oBM?=
 =?us-ascii?Q?fpzZ9BCYC+rD6nkWBwi8loo7DQrSHmQkjIAQu+0?=
 =?us-ascii?Q?A6OyxeRx4VNll5W=2FlJwhWSSFeWKyzkSotre2JRo?=
 =?us-ascii?Q?TWQ=3D?=
To: linux-nvdimm@lists.01.org
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_0D899B3A.0D8E6BAD"
Message-ID-Hash: ZDXQOGBVS5QAEE5LYHRTOLK6IPN3H7RA
X-Message-ID-Hash: ZDXQOGBVS5QAEE5LYHRTOLK6IPN3H7RA
X-MailFrom: bounces+2503710-919f-linux-nvdimm=lists.01.org@en.shieldpremiumpaintgh.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZDXQOGBVS5QAEE5LYHRTOLK6IPN3H7RA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_0D899B3A.0D8E6BAD
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_0D899B3A.0D8E6BAD--
