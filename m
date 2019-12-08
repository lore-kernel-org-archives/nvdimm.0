Return-Path: <SRS0=r690=2A=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32720C43603
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Dec 2019 23:55:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE15D206A1
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Dec 2019 23:55:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE15D206A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hymyslncj.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E70A110113618;
	Tue, 10 Dec 2019 15:59:07 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=111.176.77.77; helo=hymyslncj.net; envelope-from=eepxc@hymyslncj.net; receiver=<UNKNOWN> 
Received: from hymyslncj.net (unknown [111.176.77.77])
	by ml01.01.org (Postfix) with ESMTP id 92592100DC2C2
	for <linux-nvdimm@lists.01.org>; Tue, 10 Dec 2019 15:58:52 -0800 (PST)
Message-ID: <FD7E2ADA9E7E49C462A9409B7D75266E@hymyslncj.net>
From: =?utf-8?B?5YWz5aqa?= <eepxc@hymyslncj.net>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?bGludXgtbnZkaW1t77ya5oKoIOWlvSDvvIE=?=
Date: Mon, 9 Dec 2019 07:55:19 +0800
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_068D_014D04BB.16F807A0"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: 7YSTMUSDKWBAHEBSW4DFMGTCYZQ6ABJK
X-Message-ID-Hash: 7YSTMUSDKWBAHEBSW4DFMGTCYZQ6ABJK
X-MailFrom: eepxc@hymyslncj.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7YSTMUSDKWBAHEBSW4DFMGTCYZQ6ABJK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>

This is a multi-part message in MIME format.

------=_NextPart_000_068D_014D04BB.16F807A0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

------=_NextPart_000_068D_014D04BB.16F807A0--
