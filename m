Return-Path: <SRS0=dklJ=Z3=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF1FC43603
	for <linux-nvdimm@archiver.kernel.org>; Thu,  5 Dec 2019 01:47:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D1A18206DB
	for <linux-nvdimm@archiver.kernel.org>; Thu,  5 Dec 2019 01:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1A18206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=wholeton.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F10C7101134E8;
	Wed,  4 Dec 2019 17:51:06 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=121.14.240.9; helo=wholeton.com; envelope-from=cj@wholeton.com; receiver=<UNKNOWN> 
Received: from wholeton.com (unknown [121.14.240.9])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 314A1100DC3EF
	for <linux-nvdimm@lists.01.org>; Wed,  4 Dec 2019 17:51:03 -0800 (PST)
Received: from kdfz ([182.110.236.32])
	(authenticated bits=0)
	by wholeton.com (8.13.8/8.13.1) with ESMTP id xB4NQ6DS005907;
	Thu, 5 Dec 2019 07:26:07 +0800
Message-ID: <C762DA41A83BCC3BE9B065BDBE553CC2@kdfz>
From: "kuyx" <cj@wholeton.com>
To: <linux-nvdimm@lists.01.org>, <jcarter@aerialdata.com>,
        <tiffany@quirky.com>, <tricon@tritech.com>, <affinity@opentext.com>,
        <dejiang@trmhw.com>, <tembo@mopipi.ub.bw>, <stagewright@ccc.edu>,
        <info@safseasia.org>, <chzhou@csu.edu.cn>, <action@cnaction.net>,
        <email@osii.com>, <info@ranktrackr.com>, <szb@zufe.edu.cn>,
        <chenqi.sh@cscline.com>, <yangrl@bnu.edu.cn>, <dfguo@hitachi.cn>,
        <diioofjsrjq@mail2honey.com>, <lanmei0002@new-purse.com>,
        <zhaiyujia@lanou3g.com>, <ensr@mtaonline.net>
Subject: =?gb2312?B?tPPJ8XhoaHjQwtf3tPPRp9bGt/7Ktc+wyfrJs7eiuPfKvbPp?=
	=?gb2312?B?suWxrLLZwazQ+Neyu/fFvsW+1rHP7Ljfs7HS+b3Qyrm+orLZztJL?=
	=?gb2312?B?S7jnuLvSu7T6Q2FvQrjn19zNs8zXt7+089W9xOrEs9axsqU=?=
	=?gb2312?B?xr3MqLWjuNnW97KlvKvGt7ray7/G+NbKzfi67MWuyfG088PbuN/H5Q==?=
	=?gb2312?B?zt7LrtOhzerV+7DmKCk=?=
Date: Thu, 5 Dec 2019 09:42:10 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: XSOU7ZNOSSGCVBSBJQAKCTVWXXUEUTKC
X-Message-ID-Hash: XSOU7ZNOSSGCVBSBJQAKCTVWXXUEUTKC
X-MailFrom: cj@wholeton.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/XSOU7ZNOSSGCVBSBJQAKCTVWXXUEUTKC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============1522664666906863643=="

--===============1522664666906863643==
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: base64

PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMCBUcmFuc2l0aW9uYWwv
L0VOIj4NCjxIVE1MPjxIRUFEPg0KPE1FVEEgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PWdi
MjMxMiIgaHR0cC1lcXVpdj1Db250ZW50LVR5cGU+DQo8TUVUQSBuYW1lPUdFTkVSQVRPUiBjb250
ZW50PSJNU0hUTUwgMTAuMDAuOTIwMC4xNzU1NiI+PC9IRUFEPg0KPEJPRFk+DQo8UD48QSBocmVm
PSJodHRwOi8vaGFkMjAxNS5jb20vIj5odHRwOi8vaGFkMjAxNS5jb20vPC9BPjwvUD4NCjxQPiZu
YnNwOzwvUD4NCjxQPrTzyfF4aGh40MLX97Tz0afWxrf+yrXPsMn6ybO3orj3yr2z6bLlsayy2cGs
0PjXsrv3xb7Fvtaxz+y437Ox0vm90Mq5vqKy2c7SJm5ic3A7IDwvUD4NCjxQPktLuOe4u9K7tPpD
YW9CuOfX3M2zzNe3v7Tz1b3E6sSz1rGypca9zKi1o7jZ1veypbyrxre62su/xvjWys34uuzFrsnx
tPPD27jfx+XO3suu06HN6tX7sOYoKTwvUD48L0JPRFk+PC9IVE1MPg0K


--===============1522664666906863643==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============1522664666906863643==--
