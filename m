Return-Path: <SRS0=gkLb=6G=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	SUBJ_ALL_CAPS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43352C55186
	for <linux-nvdimm@archiver.kernel.org>; Wed, 22 Apr 2020 23:33:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B92B62076E
	for <linux-nvdimm@archiver.kernel.org>; Wed, 22 Apr 2020 23:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=host.condomyar.com header.i=@host.condomyar.com header.b="w8IfgO50"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B92B62076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=daehwagm.co.kr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1F9F810FC33E2;
	Wed, 22 Apr 2020 16:33:09 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=95.216.21.251; helo=tiger.mrservers.net; envelope-from=leo@daehwagm.co.kr; receiver=<UNKNOWN> 
Received: from tiger.mrservers.net (tiger.mrservers.net [95.216.21.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7F089100A029E
	for <linux-nvdimm@lists.01.org>; Wed, 22 Apr 2020 16:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=host.condomyar.com; s=default; h=Content-Type:MIME-Version:Message-ID:Date:
	Subject:To:From:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=p23oDjF3g+BLk0N9DY0rEBhs/he1CLBcKenGRgMxVaA=; b=w8IfgO50ot+dtpqac0Mrt6zOzi
	7PFsWvHs2aWDqSezy8vbs1VZzSOnCNeEGbynxAHt0ljk526NBPtMWeF0CTFwaVd2HD5sdbHvBhN5D
	o6S62I21kAfj4RqNVZDVY1WZ8wwoeNyjajfeLgrPpgVnuEIOlB3jEPjBN1p/cRUmDecyTHPp2vOrs
	hnHmImNam2mm01VDXJm8UFzS+umL0EqoG2Pk/FEqyU9Mqc8UIki6oeOqtE4R0t8TVfFvrUh0GWp6f
	pPgX433XbzSPdbia8E2PcC9XRKWYmx2m6N7j5NnyaVEQcQfFyLMwrharMMr5t2udGvsSEb2Yd9oIV
	fVfRHUhw==;
Received: from hwsrv-714897.hostwindsdns.com ([142.11.249.189]:58337 helo=daehwagm.co.kr)
	by tiger.mrservers.net with esmtpa (Exim 4.93)
	(envelope-from <leo@daehwagm.co.kr>)
	id 1jROrp-0001qD-Mo
	for linux-nvdimm@lists.01.org; Thu, 23 Apr 2020 04:03:22 +0430
From: Leo <leo@daehwagm.co.kr>
To: linux-nvdimm@lists.01.org
Subject: RFQ-1324455663 API 5L X 60
Date: 22 Apr 2020 16:33:20 -0700
Message-ID: <20200422163319.5D1EF745496D6467@daehwagm.co.kr>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_993F02CA.1F0313C0"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - tiger.mrservers.net
X-AntiAbuse: Original Domain - lists.01.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - daehwagm.co.kr
X-Get-Message-Sender-Via: tiger.mrservers.net: authenticated_id: smtpf0x-jfg5w@host.condomyar.com
X-Authenticated-Sender: tiger.mrservers.net: smtpf0x-jfg5w@host.condomyar.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Message-ID-Hash: NN3E4KKWWYRKWJFEQV5ZB2LUB3PWBA22
X-Message-ID-Hash: NN3E4KKWWYRKWJFEQV5ZB2LUB3PWBA22
X-MailFrom: leo@daehwagm.co.kr
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NN3E4KKWWYRKWJFEQV5ZB2LUB3PWBA22/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0012_993F02CA.1F0313C0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_0012_993F02CA.1F0313C0--
