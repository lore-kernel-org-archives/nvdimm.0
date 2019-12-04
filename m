Return-Path: <SRS0=QN7s=Z2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_FONT_SIZE_LARGE,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C24CC43603
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Dec 2019 10:32:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A425A206DB
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Dec 2019 10:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A425A206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=unitrispharma.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0FEC310113326;
	Wed,  4 Dec 2019 02:36:18 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=180.167.180.174; helo=unitrispharma.com; envelope-from=cheng.zheng@unitrispharma.com; receiver=<UNKNOWN> 
Received: from unitrispharma.com (unknown [180.167.180.174])
	by ml01.01.org (Postfix) with SMTP id CFA37100EEB96
	for <linux-nvdimm@lists.01.org>; Wed,  4 Dec 2019 02:36:14 -0800 (PST)
Received: from tbfklm ([172.16.30.1])
	(envelope-sender <cheng.zheng@unitrispharma.com>)
	by 172.16.30.10 with ESMTP
	for <foilf@legis.la.gov>; Wed, 04 Dec 2019 18:30:22 +0800
Message-ID: <B319A7E0573533776669879A82599CC6@tbfklm>
From: "wbhnnn" <cheng.zheng@unitrispharma.com>
To: <foilf@legis.la.gov>,
	<byron@sentralize.com>,
	<hssldy@zsu.edu.cn>,
	<zhouzhou@beenvip.com>,
	<sylvia@cedarville.edu>,
	<saps@saps.cn>,
	<miya87@onsalon.com>,
	<gbjk@thermeon.com>,
	<ahuseynova@osi-az.org>,
	<mcgauran@idnsi.net>,
	<xjx@ujs.edu.cn>,
	<miquel@lsi.upc.edu>,
	<linux-nvdimm@lists.01.org>,
	<ghaaf@mckinsey.com>,
	<towery@towery.com.cn>,
	<leo@cooper.edu>,
	<kxyfob26078@chacuo.net>,
	<compas.pa@entelchile.net>,
	<huxb@hjmlawyer.com>,
	<sale@orientools.net>,
	<msds@struktol.com>
Subject: =?gb2312?B?wvTS+NDQv6ijrMvEvP7M16OsxtW/qKOscSAxMTk3MDY=?=
	=?gb2312?B?NjU0NLT6ytW/7qOstPrX39XLo6zPtLHSo6y62r34sNez9qOs?=
	=?gb2312?B?0v6y2NfKvfDAtNS0o6zS/rLYssay+qOsubrC8tL40NC/qLzTztJR?=
	=?gb2312?B?IDExOTcwNjY1NDQ=?=
Date: Wed, 4 Dec 2019 18:30:46 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: 32TBL3F6CGWLO5HEBJ7KVQNDMTFGGZVV
X-Message-ID-Hash: 32TBL3F6CGWLO5HEBJ7KVQNDMTFGGZVV
X-MailFrom: cheng.zheng@unitrispharma.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/32TBL3F6CGWLO5HEBJ7KVQNDMTFGGZVV/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============0821031265029150199=="

--===============0821031265029150199==
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


--===============0821031265029150199==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============0821031265029150199==--
