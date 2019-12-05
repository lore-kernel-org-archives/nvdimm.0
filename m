Return-Path: <SRS0=dklJ=Z3=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4DAC43603
	for <linux-nvdimm@archiver.kernel.org>; Thu,  5 Dec 2019 06:15:26 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 09DDF22464
	for <linux-nvdimm@archiver.kernel.org>; Thu,  5 Dec 2019 06:15:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09DDF22464
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=snupg.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 16BB310113327;
	Wed,  4 Dec 2019 22:18:47 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=1.85.42.195; helo=root.domain; envelope-from=wujing@snupg.com; receiver=<UNKNOWN> 
Received: from root.domain (unknown [1.85.42.195])
	by ml01.01.org (Postfix) with ESMTP id 27100100DC2D7
	for <linux-nvdimm@lists.01.org>; Wed,  4 Dec 2019 22:18:43 -0800 (PST)
Received: by root.domain (CSmail for UNIX, from userid 503)
	id 95732AB23; Thu,  5 Dec 2019 13:04:57 +0800 (CST)
Received: from lx (unknown [182.110.236.32])
	by root.domain (CSmail for UNIX) with ESMTPA id A1250A707;
	Thu,  5 Dec 2019 13:04:56 +0800 (CST)
Message-ID: <7E7FC68D34EE32AF0079BF6A998870DC@lx>
From: "jhb" <wujing@snupg.com>
To: <hr@zuo-chuang.com>,
	<wonghin.lee@aia.com>,
	<xxl@dongri.com>,
	<monty@monty.com.cn>,
	<info@batonsoft.com>,
	<linux-nvdimm@lists.01.org>,
	<zunliang.ding@hspharm.cn>,
	<jay@toky.com>,
	<perkinja@udmercy.edu>,
	<preston@ukec.net>,
	<info@pulsar-inc.com>,
	<service@be-tech.com.cn>,
	<mumbai@halarship.com>,
	<slgs@hawaii.edu>,
	<admissions@scsu.edu>,
	<nituzu@eged.com>,
	<smsgcx@imu.edu.cn>,
	<sales-manager@feellife.com>,
	<srp336@optimum.com>,
	<hr@ichido.com.cn>
Subject: =?gb2312?B?tv7Krsvqv7TXxbfHs6PE27fbxMy320LLq8LtzrLDyMPD19PJs7ei?=
	=?gb2312?B?yc/Iq8Lj19TD/rrcysfT1bvzsrvSqrTtuf3DwMWux/PIxMfzx/PE4w==?=
Date: Thu, 5 Dec 2019 13:11:50 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: EGC55DMUH4Z4PEZEWXONOXZF5UQDC5HJ
X-Message-ID-Hash: EGC55DMUH4Z4PEZEWXONOXZF5UQDC5HJ
X-MailFrom: wujing@snupg.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/EGC55DMUH4Z4PEZEWXONOXZF5UQDC5HJ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============0749674337615551782=="

--===============0749674337615551782==
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: base64

PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMCBUcmFuc2l0aW9uYWwv
L0VOIj4NCjxIVE1MPjxIRUFEPg0KPE1FVEEgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PWdi
MjMxMiIgaHR0cC1lcXVpdj1Db250ZW50LVR5cGU+DQo8TUVUQSBuYW1lPUdFTkVSQVRPUiBjb250
ZW50PSJNU0hUTUwgMTAuMDAuOTIwMC4xNzU1NiI+PC9IRUFEPg0KPEJPRFk+DQo8UD48QSBocmVm
PSJodHRwOi8vaGFkMjAxNS5jb20vIj5odHRwOi8vaGFkMjAxNS5jb20vPC9BPjwvUD4NCjxQPiZu
YnNwOzwvUD4NCjxQPrb+yq7L6r+018W3x7OjxNu328TMt9tCy6vC7c6yw8jDw9fTybO3osnPyKvC
49fUw/663MrH09W787K70qq07bn9Jm5ic3A7IDwvUD4NCjxQPsPAxa7H88jEx/PH88TjPC9QPjwv
Qk9EWT48L0hUTUw+DQo=


--===============0749674337615551782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============0749674337615551782==--
