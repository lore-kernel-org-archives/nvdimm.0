Return-Path: <SRS0=2RnD=BU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D65C433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 10 Aug 2020 21:17:04 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9996E20716
	for <linux-nvdimm@archiver.kernel.org>; Mon, 10 Aug 2020 21:17:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sendgrid.net header.i=@sendgrid.net header.b="mGcJxgFS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9996E20716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=congoactuel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 760F212ED9217;
	Mon, 10 Aug 2020 14:17:04 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=149.72.164.11; helo=wrqvxqhb.outbound-mail.sendgrid.net; envelope-from=bounces+16650384-7a52-linux-nvdimm=lists.01.org@sendgrid.net; receiver=<UNKNOWN> 
Received: from wrqvxqhb.outbound-mail.sendgrid.net (wrqvxqhb.outbound-mail.sendgrid.net [149.72.164.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 6B2B612ED9215
	for <linux-nvdimm@lists.01.org>; Mon, 10 Aug 2020 14:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sendgrid.net;
	h=from:to:subject:mime-version:content-type; s=smtpapi;
	bh=lK/NSzZ8UT8DWpiTp4VLYQezUZF5FhAHZ2ggYcQVCAo=; b=mGcJxgFS3KF14
	gWfa+E4Jd4b4PAq/pXaOcj3icBGKvwfQJr6CJijrZZRuU5524Mq6Un3wg8iZtRZF
	aUVo+X6DSzWRd2kSS0CqTHLxUS08mdKJsllHaVtOoEuAVzvXgGatgCAa4H5eQkuW
	mCibj+HLmx5WFhm7fRP+kZCbOX5KY8=
Received: by filter1842p1mdw1.sendgrid.net with SMTP id filter1842p1mdw1-2477-5F31B94C-3A
        2020-08-10 21:17:00.736093802 +0000 UTC m=+6042.245795778
Received: from congoactuel.com (unknown)
	by ismtpd0043p1mdw1.sendgrid.net (SG) with ESMTP id ho4n0XmQR5ummk2iWPx9hQ
	for <linux-nvdimm@lists.01.org>; Mon, 10 Aug 2020 21:17:00.697 +0000 (UTC)
From: Ivan Lo | Wiloggroup <contact@congoactuel.com>
To: linux-nvdimm@lists.01.org
Subject: Quotation sheet for EFB-CS 20200609
Date: Mon, 10 Aug 2020 21:17:00 +0000 (UTC)
Message-ID: <20200811062141.6BE28A567E25B5AA@congoactuel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_776D805A.585972EC"
X-SG-EID: ke+Bwwuh8DadKJDZimY4ZO2X8vVub/nPehTySyaiYrQR3OARITypw7YgD3WEjJ1hUTNL+j6hCUsD2v
 wrYS6THROD7y5QpRUttXFWtUf/1lCdLFczPoRCOuLyzPN2gIweXB4YRZSjASDd/8pthBaLo+ZoVcxh
 QITpZETizzMdq6IV34tfOqxaV8G+h+SCuZCcyt2aPkE2n5qTYphxXuGEGtfymoy4O5BqmVzUEQDtx0
 AQZ6G8c2Oo3ZivGoNXjfx/
Message-ID-Hash: DS2JWOFFLEUOWPY23X2HAJUI43FKL23F
X-Message-ID-Hash: DS2JWOFFLEUOWPY23X2HAJUI43FKL23F
X-MailFrom: bounces+16650384-7a52-linux-nvdimm=lists.01.org@sendgrid.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DS2JWOFFLEUOWPY23X2HAJUI43FKL23F/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.
------=_NextPart_000_0012_776D805A.585972EC
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_776D805A.585972EC--
