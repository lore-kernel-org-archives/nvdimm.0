Return-Path: <SRS0=UApu=7G=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B892C433E0
	for <linux-nvdimm@archiver.kernel.org>; Sun, 24 May 2020 16:06:43 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B5CD820776
	for <linux-nvdimm@archiver.kernel.org>; Sun, 24 May 2020 16:06:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=2yiletisim.com header.i=@2yiletisim.com header.b="BQX5/eNq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5CD820776
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=2yiletisim.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A05E511A66189;
	Sun, 24 May 2020 09:02:50 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=185.15.197.90; helo=linux.arenatasarim.net; envelope-from=officeadmin@2yiletisim.com; receiver=<UNKNOWN> 
Received: from linux.arenatasarim.net (linux.arenatasarim.net [185.15.197.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 79F9911A6617E
	for <linux-nvdimm@lists.01.org>; Sun, 24 May 2020 09:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=2yiletisim.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3Tl8y8EuZpLzy0gf5ZlDEvfc3zZXbtBMrWPxEb5UtQA=; b=BQX5/eNq6vVqyIXRJO+uS7F32D
	lxYMqt13iFNReUgKncG28WB8Xi/VXiWHQmRf1NuWMA5Jg+JDmDNrffO9fskfIOwM+x+TPyjPZ8B2H
	bsZmnU/h7+ooiaqW24rbbgMfHtltplNnPJM9RY7vMZqmIHhSrNw0BLCaambu88UBkuJdEumDlFMeh
	FMeUR0Fsk+kA0g4bZ7baq4jLYoT7Xqq6lENOuPIBuWrblkYb9QG5UBwsYuOO4UztWxOJWoAP92tvm
	ystBYR/yOA0k17pMVtwGpxUqhmTR9R7KHXOXCFGH6Gb4Q/qm8rugSaKgQpGrBDQ/8A4btJULuKeRJ
	saXT19NQ==;
Received: from ip90.ip-37-187-205.eu ([37.187.205.90]:54420 helo=2yiletisim.com)
	by linux.arenatasarim.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <officeadmin@2yiletisim.com>)
	id 1jct92-0002nw-A7
	for linux-nvdimm@lists.01.org; Sun, 24 May 2020 19:06:36 +0300
From: Covid Relief Fund<officeadmin@2yiletisim.com>
To: linux-nvdimm@lists.01.org
Subject: linux-nvdimm@lists.01.org Covid/Pay/2020/ Covid Relief Fund
Date: 24 May 2020 09:06:53 -0700
Message-ID: <20200524090653.C148F98904F43B05@2yiletisim.com>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - linux.arenatasarim.net
X-AntiAbuse: Original Domain - lists.01.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 2yiletisim.com
X-Get-Message-Sender-Via: linux.arenatasarim.net: authenticated_id: officeadmin@2yiletisim.com
X-Authenticated-Sender: linux.arenatasarim.net: officeadmin@2yiletisim.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Message-ID-Hash: T4QGOV6RLISQTZZWTUFI352NVSH5L5GA
X-Message-ID-Hash: T4QGOV6RLISQTZZWTUFI352NVSH5L5GA
X-MailFrom: officeadmin@2yiletisim.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: covidofficeincc@barid.com
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/T4QGOV6RLISQTZZWTUFI352NVSH5L5GA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

linux-nvdimm@lists.01.org Covid/Pay/2020/ Covid Relief Fund

The world banks is making available $400,000 via the 
International Monetary fund  as financial support aid for  
individuals globally.This is due to the current global corona 
virus pandemic.

Your email is selected in a category ''A'' beneficiary program.To 
claim the funds ,provide  your full name with this code 
Covid/Pay/2020/  to the email address provided below..



Stay safe.


Andrew Tweedie
Finance Department Director
International Monetary Fund(IMF)
CORONA RELIEF FUND.
TEL:+1 917 382 1952
covidofficeincc@barid.com
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
