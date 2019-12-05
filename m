Return-Path: <SRS0=Mnj5=2M=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_FONT_SIZE_LARGE,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49994C2D0C8
	for <linux-nvdimm@archiver.kernel.org>; Sun, 22 Dec 2019 18:07:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F8DB206D3
	for <linux-nvdimm@archiver.kernel.org>; Sun, 22 Dec 2019 18:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F8DB206D3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tzjk.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7FBD910113695;
	Sun, 22 Dec 2019 10:11:11 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=116.228.222.250; helo=tzjk.net; envelope-from=tzjk@tzjk.net; receiver=<UNKNOWN> 
Received: from tzjk.net (unknown [116.228.222.250])
	by ml01.01.org (Postfix) with SMTP id 8B2BA10113693
	for <linux-nvdimm@lists.01.org>; Sun, 22 Dec 2019 10:11:07 -0800 (PST)
Received: from 106.6.41.99 (HELO LQRSK); Thu, 5 Dec 2019 15:22:15 +0800
Message-ID: <EB2FB60A8DA02334F1D7DB44B106D97F@lqrsk>
From: "kvcrrdwt" <tzjk@tzjk.net>
To: <oprater@ah.com>,
	<kjb@enzemed.com>,
	<linux-nvdimm@lists.01.org>,
	<hr@gtmspm.com>,
	<cs@goitin.com>,
	<filialuo@careerrpo.com>,
	<dudley@sisqtel.net>,
	<allen@zjab.com>,
	<hong023@hong-cert.com>,
	<rokincart@a-c-t.com>
Subject: =?gb2312?B?wvTS+NDQv6ijrMvEvP7M16OsxtW/qKOscSAxMTk3MDY=?=
	=?gb2312?B?NjU0NLT6ytW/7qOstPrX39XLo6zPtLHSo6y62r34sNez9qOs?=
	=?gb2312?B?0v6y2NfKvfDAtNS0o6zS/rLYssay+qOsubrC8tL40NC/qLzTztJR?=
	=?gb2312?B?IDExOTcwNjY1NDQ=?=
Date: Thu, 5 Dec 2019 15:22:53 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: AFQFEQPHCZITEJLESVG3MSLQKWPESWX7
X-Message-ID-Hash: AFQFEQPHCZITEJLESVG3MSLQKWPESWX7
X-MailFrom: tzjk@tzjk.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AFQFEQPHCZITEJLESVG3MSLQKWPESWX7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============6778349696098487432=="

--===============6778349696098487432==
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: base64

PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMCBUcmFuc2l0aW9uYWwv
L0VOIj4NCjxIVE1MPjxIRUFEPg0KPE1FVEEgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PWdi
MjMxMiIgaHR0cC1lcXVpdj1Db250ZW50LVR5cGU+DQo8TUVUQSBuYW1lPUdFTkVSQVRPUiBjb250
ZW50PSJNU0hUTUwgMTAuMDAuOTIwMC4xNjc1MCI+PC9IRUFEPg0KPEJPRFk+DQo8UD48U1RST05H
PjxGT05UIGNvbG9yPXJlZCBzaXplPTY+wvTS+NDQv6ijrMvEvP7M16OsxtW/qKOscSAxMTk3MDY2
NTQ0tPrK1b/uo6y0+tff1cujrM+0sdKjrLravfiw17P2o6zS/rLY18q98MC01LSjrNL+stiyxrL6
o6y5usLy0vjQ0L+ovNPO0lEgMTE5NzA2NjU0NDwvRk9OVD48L1NUUk9ORz48L1A+PC9CT0RZPjwv
SFRNTD4NCg==


--===============6778349696098487432==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============6778349696098487432==--
