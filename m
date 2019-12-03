Return-Path: <SRS0=r690=2A=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_FONT_SIZE_LARGE,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971BFC43603
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Dec 2019 05:15:32 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 462EE20637
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Dec 2019 05:15:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 462EE20637
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gdyanjing.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4D76610113602;
	Mon,  9 Dec 2019 21:18:54 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=157.122.156.242; helo=mail.gdyanjing.com; envelope-from=lizhigang@gdyanjing.com; receiver=<UNKNOWN> 
Received: from mail.gdyanjing.com (unknown [157.122.156.242])
	by ml01.01.org (Postfix) with ESMTP id 15D9A100DC3EC
	for <linux-nvdimm@lists.01.org>; Mon,  9 Dec 2019 21:18:52 -0800 (PST)
Received: by mail.gdyanjing.com (Postfix, from userid 98)
	id 041E094D04F; Sun,  8 Dec 2019 18:16:34 +0800 (CST)
Received: from nwpi (unknown [106.6.41.99])
	by mail.gdyanjing.com (Postfix) with ESMTPA id CA032C35185;
	Tue,  3 Dec 2019 15:36:54 +0800 (CST)
Message-ID: <E6DA6C0711E37CC95989A114457A9774@nwpi>
From: "xi" <lizhigang@gdyanjing.com>
To: <alberts@andrew.cmu.edu>,
	<rbanai@memphis.edu>,
	<huangxinyu@yasn.com.cn>,
	<wrl@njau.edu.cn>,
	<u5230hr@ukpathway.com>,
	<water@zj-create.com>,
	<hr@ql-art.com>,
	<lijipeng@jctc.com.cn>,
	<wanghongbin@100tal.com>,
	<george.cusson@zymark.com>,
	<shhr@htt.cn>,
	<jinan@china-sss.com>,
	<jnjoku@unilag.edu.ng>,
	<stever@seco1.com>,
	<shiwuju@qingdao.gov.cn>,
	<sdtsales@boe.com.cn>,
	<linux-nvdimm@lists.01.org>,
	<psy@zufe.edu.cn>,
	<service@chinarunvc.com>,
	<mgreenwald@5ssl.com>,
	<abuse@vi.net>
Subject: =?gb2312?B?wvTS+NDQv6ijrMvEvP7M16OsxtW/qKOscSAxMTk3MDY=?=
	=?gb2312?B?NjU0NLT6ytW/7qOstPrX39XLo6zPtLHSo6y62r34sNez9qOs?=
	=?gb2312?B?0v6y2NfKvfDAtNS0o6zS/rLYssay+qOsubrC8tL40NC/qLzTztJR?=
	=?gb2312?B?IDExOTcwNjY1NDQ=?=
Date: Tue, 3 Dec 2019 15:57:42 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: BBP7OS25Y6Y2X3TRJIDRIILEIG2MXJWP
X-Message-ID-Hash: BBP7OS25Y6Y2X3TRJIDRIILEIG2MXJWP
X-MailFrom: lizhigang@gdyanjing.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/BBP7OS25Y6Y2X3TRJIDRIILEIG2MXJWP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============2676120676566812361=="

--===============2676120676566812361==
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


--===============2676120676566812361==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============2676120676566812361==--
