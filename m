Return-Path: <SRS0=PD3w=7M=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636C0C433DF
	for <linux-nvdimm@archiver.kernel.org>; Sat, 30 May 2020 22:32:44 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F6E82074D
	for <linux-nvdimm@archiver.kernel.org>; Sat, 30 May 2020 22:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=acceswealthservice.xyz header.i=@acceswealthservice.xyz header.b="ajhQffnf";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=acceswealthservice.xyz header.i=@acceswealthservice.xyz header.b="ajhQffnf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F6E82074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=acceswealthservice.xyz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 31469100EAAF1;
	Sat, 30 May 2020 15:28:10 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=46.166.185.243; helo=host.acceswealthservice.xyz; envelope-from=deanj00@acceswealthservice.xyz; receiver=<UNKNOWN> 
Received: from host.acceswealthservice.xyz (unknown [46.166.185.243])
	by ml01.01.org (Postfix) with ESMTP id 6605A100EAB5A
	for <linux-nvdimm@lists.01.org>; Sat, 30 May 2020 15:28:07 -0700 (PDT)
Received: from acceswealthservice.xyz (2t5j.w.time4vps.cloud [212.24.97.110])
	by host.acceswealthservice.xyz (Postfix) with ESMTPA id 240D5F6666
	for <linux-nvdimm@lists.01.org>; Sun, 31 May 2020 00:29:27 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 host.acceswealthservice.xyz 240D5F6666
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=acceswealthservice.xyz; s=default; t=1590877767;
	bh=td/1klW8T5Eyprv/u3iSt1Uq3pUK6RiW9JQei4VLqgo=;
	h=Reply-To:From:To:Subject:Date:From;
	b=ajhQffnfNFxVXfd8VtyTIEaAl6azurgjeWPI+Zw7Dl+X2OQogE3uFGawe1pS8ZTDh
	 korJladjbzAvr5bpX0RmBrp61xvgL2PCRYzwdRXJJ9KN1iMohKDYk1neX71ctQjdJL
	 3FMgz7QtejbhHjHdOs+lV8PN8sjy8YEGXkDK4frw=
DKIM-Filter: OpenDKIM Filter v2.11.0 host.acceswealthservice.xyz 240D5F6666
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=acceswealthservice.xyz; s=default; t=1590877767;
	bh=td/1klW8T5Eyprv/u3iSt1Uq3pUK6RiW9JQei4VLqgo=;
	h=Reply-To:From:To:Subject:Date:From;
	b=ajhQffnfNFxVXfd8VtyTIEaAl6azurgjeWPI+Zw7Dl+X2OQogE3uFGawe1pS8ZTDh
	 korJladjbzAvr5bpX0RmBrp61xvgL2PCRYzwdRXJJ9KN1iMohKDYk1neX71ctQjdJL
	 3FMgz7QtejbhHjHdOs+lV8PN8sjy8YEGXkDK4frw=
From: Dean <deanj00@acceswealthservice.xyz>
To: linux-nvdimm@lists.01.org
Subject: Investment
Date: 31 May 2020 01:29:26 +0300
Message-ID: <20200531012926.9C1704865B8F447A@acceswealthservice.xyz>
Mime-Version: 1.0
Message-ID-Hash: C53ZMD2WMZJXEG2P5ESISG3M35243YP4
X-Message-ID-Hash: C53ZMD2WMZJXEG2P5ESISG3M35243YP4
X-MailFrom: deanj00@acceswealthservice.xyz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: deanj22@accesswealthservices.online
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/C53ZMD2WMZJXEG2P5ESISG3M35243YP4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Good evening. I am Dean Johnston, a broker working with Access 
Wealth Services. I am contacting you because one of my high 
profile clients is interested in investing abroad and has asked 
me to look for individuals and companies with interesting 
business ideas and companies that he can invest in. He wants to 
expand his portfolio and has interest in investing a substantial 
amount of asset abroad. I got your contact (along with other 
contacts) through an online business directory and I thought I'd 
contact you to see if you are interested in this opportunity.

Please indicate your interest by replying back to this email. 
Once I get your response, I will give you more details and we can 
plan a strategy that will be beneficial to all parties.

Best regards

D Johnston
Access Wealth Services
+27319400855
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
