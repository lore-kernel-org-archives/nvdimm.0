Return-Path: <SRS0=nK7J=ZW=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC915C432C0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 30 Nov 2019 21:33:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 967132082E
	for <linux-nvdimm@archiver.kernel.org>; Sat, 30 Nov 2019 21:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 967132082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=masterkeychrysler.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1C31310113308;
	Sat, 30 Nov 2019 13:37:09 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=192.190.42.45; helo=localhost.localdomain; envelope-from=info@masterkeychrysler.com; receiver=<UNKNOWN> 
Received: from localhost.localdomain (unknown [192.190.42.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 344DA100DC2C2
	for <linux-nvdimm@lists.01.org>; Sat, 30 Nov 2019 13:37:07 -0800 (PST)
Received: from zwvyfmwv (unknown [182.111.170.135])
	by localhost.localdomain (Postfix) with ESMTPA id 730362BF521;
	Sat, 30 Nov 2019 16:17:20 +0100 (CET)
Message-ID: <DA6FF065AAAC99EA6D1D3A5A48C27B2B@zwvyfmwv>
From: "sjlhsjzb" <info@masterkeychrysler.com>
To: <krahme@boyden.com>,
	<jack@collecta.com>,
	<hr@guorn.com>,
	<adngroh@syylmy.com>,
	<vinod@aceskill.com>,
	<wanghong@eqilai.com>,
	<eotubo@br.ibm.com>,
	<rick.lee@tekni-plex.com>,
	<info@ijzerenman.com>,
	<josh.pabst@smdpstudio.com>,
	<dlewey@tauck.com>,
	<zhaopin@fenrir-tec.com>,
	<gujarat@autonics.com>,
	<linux-nvdimm@lists.01.org>,
	<www@cnu.edu>,
	<hi@yetang.com>,
	<broy1@binghamton.edu>,
	<fenglin@ujs.edu.cn>,
	<jazyjoez@keanefed.com>,
	<chenkunpeng@hiwayslaw.com>,
	<hr@ztgt.cn>
Subject: =?gb2312?B?zNjJq9ChwsO53bn+4LZLVNSytLLNtcXE47bH4NChu++6zbTzxMw=?=
	=?gb2312?B?ydm4vrykx+nFvsW+x7DH6cnu0rvOx76rxre+xrXqzbXFxMz9ttS7sA==?=
	=?gb2312?B?w7LLxrTzs6TNyLjfzPTDwMWux+7Xt7K7yeHW1dPatbHJz8HL1tDE6g==?=
	=?gb2312?B?xNDB7LW8tcTH6bi+?=
Date: Sun, 1 Dec 2019 00:00:32 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: VLL3IDRD4O4T5LH5CWKA2FJK5GCMWVNT
X-Message-ID-Hash: VLL3IDRD4O4T5LH5CWKA2FJK5GCMWVNT
X-MailFrom: info@masterkeychrysler.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/VLL3IDRD4O4T5LH5CWKA2FJK5GCMWVNT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============5669613267871092646=="

--===============5669613267871092646==
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: base64

PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMCBUcmFuc2l0aW9uYWwv
L0VOIj4NCjxIVE1MPjxIRUFEPg0KPE1FVEEgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PWdi
MjMxMiIgaHR0cC1lcXVpdj1Db250ZW50LVR5cGU+DQo8TUVUQSBuYW1lPUdFTkVSQVRPUiBjb250
ZW50PSJNU0hUTUwgMTAuMDAuOTIwMC4xNzU1NiI+PC9IRUFEPg0KPEJPRFk+DQo8UD48QSBocmVm
PSJodHRwOi8vaGFkMjAxNS5jb20vIj5odHRwOi8vaGFkMjAxNS5jb20vPC9BPjwvUD4NCjxQPiZu
YnNwOzwvUD4NCjxQPszYyavQocLDud25/uC2S1TUsrSyzbXFxOO2x+DQobvvus2088TMydm4vryk
x+nFvsW+x7DH6cnu0rvOxyZuYnNwOyA8L1A+DQo8UD6+q8a3vsa16s21xcTM/bbUu7DDssvGtPOz
pM3IuN/M9MPAxa7H7te3srvJ4dbV09q1scnPwcvW0MTqxNDB7LW8tcTH6bi+PC9QPjwvQk9EWT48
L0hUTUw+DQo=


--===============5669613267871092646==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============5669613267871092646==--
