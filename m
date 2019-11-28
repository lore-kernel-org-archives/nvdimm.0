Return-Path: <SRS0=pnkO=ZU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1B5C432C0
	for <linux-nvdimm@archiver.kernel.org>; Thu, 28 Nov 2019 19:41:06 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0AF392176D
	for <linux-nvdimm@archiver.kernel.org>; Thu, 28 Nov 2019 19:41:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AF392176D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gduptlhh.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 708A2101134F6;
	Thu, 28 Nov 2019 11:44:28 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=122.190.107.252; helo=gduptlhh.org; envelope-from=tlw@gduptlhh.org; receiver=<UNKNOWN> 
Received: from gduptlhh.org (unknown [122.190.107.252])
	by ml01.01.org (Postfix) with ESMTP id 54504101134F4
	for <linux-nvdimm@lists.01.org>; Thu, 28 Nov 2019 11:44:24 -0800 (PST)
Message-ID: <5E42836342D1DE7D60B0059CA07664EB@gduptlhh.org>
From: =?utf-8?B?6K+36L2s5Lqk55u45YWz5Y2V5L2N?= <tlw@gduptlhh.org>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?5aaC5L2V6K6p5oKo55qE5Yqe5YWs5bqU55So5rC05bmz6L+F6YCf5o+Q5Y2H77yBMjAxOQ==?=
	=?utf-8?B?LTExLTI5Mzo0MTowMg==?=
Date: Fri, 29 Nov 2019 03:40:55 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: LE54CMR3FPYO443BQ4FA2FDHBEYN6C7C
X-Message-ID-Hash: LE54CMR3FPYO443BQ4FA2FDHBEYN6C7C
X-MailFrom: tlw@gduptlhh.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LE54CMR3FPYO443BQ4FA2FDHBEYN6C7C/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

5p2lIOiHqiAg6K+36L2s5Lqk55u45YWz5Y2V5L2NICDnmoQg5L+hIOS7tiAuLi4gLi4uCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBt
YWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBz
ZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1sZWF2ZUBsaXN0cy4wMS5vcmcK
