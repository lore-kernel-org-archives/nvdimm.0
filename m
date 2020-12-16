Return-Path: <SRS0=7U0C=FU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=BAYES_50,DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A054C4361B
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Dec 2020 05:07:19 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D744A23130
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Dec 2020 05:07:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D744A23130
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=krsvpkewm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5A5B0100ED499;
	Tue, 15 Dec 2020 21:07:18 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=223.150.59.253; helo=krsvpkewm.com; envelope-from=xv@krsvpkewm.com; receiver=<UNKNOWN> 
Received: from krsvpkewm.com (unknown [223.150.59.253])
	by ml01.01.org (Postfix) with ESMTP id 90CD0100ED497
	for <linux-nvdimm@lists.01.org>; Tue, 15 Dec 2020 21:07:13 -0800 (PST)
Message-ID: <FACCAC50C641E0A4BD9F30F3E480BC8D@krsvpkewm.com>
From: =?utf-8?B?6KKB5YWI55Sf?= <xv@krsvpkewm.com>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?bGludXgtbnZkaW1t6LSo6YeP566h55CG5aaC5L2V6L2s5Y+Y?=
	=?utf-8?B?5Li65YWs5Y+456CU5Y+R5Yaz562W55qE5YWz6ZSu5pSv5pKR?=
Date: Wed, 16 Dec 2020 13:07:12 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: SA2KGSM3Z4GILQIZPJN6OFCRP5IT6MZE
X-Message-ID-Hash: SA2KGSM3Z4GILQIZPJN6OFCRP5IT6MZE
X-MailFrom: xv@krsvpkewm.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SA2KGSM3Z4GILQIZPJN6OFCRP5IT6MZE/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

bGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZw0KIOS6su+8mg0K5aaCIOWvuSDmraQg6K++IOeoiyDm
nIkg6ZyAIOaxgiANCuivt+afpSDmlLYg6ZmEIOS7tiDlhoXlrrkKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAt
LSBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwg
dG8gbGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
