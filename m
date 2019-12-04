Return-Path: <SRS0=QN7s=Z2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 090FFC432C0
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Dec 2019 02:28:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 924962073C
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Dec 2019 02:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 924962073C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gdhbjt.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id CB76C100DC2C3;
	Tue,  3 Dec 2019 18:32:16 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=58.248.64.164; helo=gdlhjt.cn; envelope-from=caylj1cwb@gdhbjt.com; receiver=<UNKNOWN> 
Received: from gdlhjt.cn (unknown [58.248.64.164])
	by ml01.01.org (Postfix) with ESMTP id D1855100DC2AD
	for <linux-nvdimm@lists.01.org>; Tue,  3 Dec 2019 18:32:12 -0800 (PST)
X-Richmail-Antispam: sCL2rVi0borhSzeOjpYxWEmrxqxSIjpgsIL2jVqxeZIR0RM=                             
X-RM-SPAM-FLAG: 00000000
Received: from eqicwcuu (unknown[182.110.236.32])
	by rmsmtp-host001-12001 (RichMail) with SMTP id 2ee15de719c0dc3-54527;
	Wed, 04 Dec 2019 10:28:47 +0800 (CST)
X-RM-TRANSID: 2ee15de719c0dc3-54527
Message-ID: <7532E2129D00C0C9CC426F9024A3F0B3@eqicwcuu>
From: "wrztbwuzi" <caylj1cwb@gdhbjt.com>
To: <harsh.lazarus@mile.education>,
	<hr@szrss.com>,
	<linux-nvdimm@lists.01.org>,
	<wendy@gmbright.com>,
	<wax@hcvt.cn>,
	<jwb@cosmic.org>,
	<bill.newman@gtaa.com>,
	<bnally@techtarget.com>,
	<cwchung@nomura.com>,
	<abelmuanza@inacom.og.ao>,
	<bbzx@bbzx.net>,
	<dame@sades.cc>,
	<alisi@hawaii.edu>,
	<cfsup@adobe.com>,
	<chrisaross@boisestate.edu>,
	<nbruno@selu.edu>,
	<sales@wandisplay.com>,
	<compras1@fraedan.com>,
	<dthol@conncoll.edu>,
	<peran@perstorp.com>,
	<xgm6@xgm6.com>
Subject: =?gb2312?B?uN/M9NDUuNDFrsnxx+nIpMTa0sLFxMnjyrHE88TM6v7RqNPVu/PJ4w==?=
	=?gb2312?B?07DKprm30q/Qoc/Ys8ezx9bQtOW/6c3mtb21xMOruty24NDUuNC1xA==?=
	=?gb2312?B?xq/BwdChveO21LDX09DIpA==?=
Date: Wed, 4 Dec 2019 10:26:37 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: E2HS42DN26KE72AFHLOVKAC2DHC43YIZ
X-Message-ID-Hash: E2HS42DN26KE72AFHLOVKAC2DHC43YIZ
X-MailFrom: caylj1cwb@gdhbjt.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/E2HS42DN26KE72AFHLOVKAC2DHC43YIZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============5154115407903840150=="

--===============5154115407903840150==
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: base64

PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMCBUcmFuc2l0aW9uYWwv
L0VOIj4NCjxIVE1MPjxIRUFEPg0KPE1FVEEgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PWdi
MjMxMiIgaHR0cC1lcXVpdj1Db250ZW50LVR5cGU+DQo8TUVUQSBuYW1lPUdFTkVSQVRPUiBjb250
ZW50PSJNU0hUTUwgMTAuMDAuOTIwMC4xNzU1NiI+PC9IRUFEPg0KPEJPRFk+DQo8UD48QSBocmVm
PSJodHRwOi8vaGFkMjAxNS5jb20vIj5odHRwOi8vaGFkMjAxNS5jb20vPC9BPjwvUD4NCjxQPiZu
YnNwOzwvUD4NCjxQPrjfzPTQ1LjQxa7J8cfpyKTE2tLCxcTJ48qxxPPEzOr+0ajT1bvzyePTsMqm
Jm5ic3A7IDwvUD4NCjxQPrm30q/Qoc/Ys8ezx9bQtOW/6c3mtb21xMOruty24NDUuNC1xMavwcHQ
ob3jttSw19PQyKQ8L1A+PC9CT0RZPjwvSFRNTD4NCg==



--===============5154115407903840150==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============5154115407903840150==--
