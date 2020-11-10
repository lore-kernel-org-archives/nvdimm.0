Return-Path: <SRS0=xdmc=EQ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=3.0 tests=BAYES_50,DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A320EC55ABD
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Nov 2020 20:43:31 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 196AF2064B
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Nov 2020 20:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 196AF2064B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ubicwhyvq.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6C9421667C954;
	Tue, 10 Nov 2020 12:43:30 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=223.150.58.2; helo=ubicwhyvq.net; envelope-from=ckfakyt@ubicwhyvq.net; receiver=<UNKNOWN> 
Received: from ubicwhyvq.net (unknown [223.150.58.2])
	by ml01.01.org (Postfix) with ESMTP id CAC34165C01B1
	for <linux-nvdimm@lists.01.org>; Tue, 10 Nov 2020 12:43:25 -0800 (PST)
Message-ID: <C4652A449B678CC4A7EEB369E64DCDFA@ubicwhyvq.net>
From: =?utf-8?B?5oKo5aW977ya?= <ckfakyt@ubicwhyvq.net>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?QUTvvJrpm4Yv5oiQL+S6py/lk4Ev5byAL+WPke+8iElQRO+8iTI=?=
	=?utf-8?B?MjI1OTY2?=
Date: Wed, 11 Nov 2020 04:43:24 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: DVGXEZVDSN6EBQY45JJKWN6T7RWHTBKX
X-Message-ID-Hash: DVGXEZVDSN6EBQY45JJKWN6T7RWHTBKX
X-MailFrom: ckfakyt@ubicwhyvq.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DVGXEZVDSN6EBQY45JJKWN6T7RWHTBKX/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQrpmYQg5Lu2IA0KICAgICAg5LqyIOWQrwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRp
bW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
