Return-Path: <SRS0=LwSK=YH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF091C4360C
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Oct 2019 03:36:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 83BB620815
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Oct 2019 03:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83BB620815
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lynxfl.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id AD1F910FC548E;
	Sun, 13 Oct 2019 20:39:28 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=122.191.125.166; helo=lynxfl.org; envelope-from=zsu@lynxfl.org; receiver=<UNKNOWN> 
Received: from lynxfl.org (unknown [122.191.125.166])
	by ml01.01.org (Postfix) with ESMTP id 6FD3610FC548B
	for <linux-nvdimm@lists.01.org>; Sun, 13 Oct 2019 20:39:25 -0700 (PDT)
Message-ID: <1D823CD775DC578781CCEC075259C5BB@lynxfl.org>
From: =?utf-8?B?5byg5YWI55Sf?= <zsu@lynxfl.org>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?5byg5YWI55Sf77ya5oKo55qE5L+h5Lu2?=
Date: Mon, 14 Oct 2019 11:36:17 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: UNV2SEBEJMVWLPOCHQBC66NH6O7HPDI2
X-Message-ID-Hash: UNV2SEBEJMVWLPOCHQBC66NH6O7HPDI2
X-MailFrom: zsu@lynxfl.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UNV2SEBEJMVWLPOCHQBC66NH6O7HPDI2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

5p2l6IeqIHpzdUBseW54Zmwub3JnIOeahOS/oeS7tu+8mg0KIApfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0t
IGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0
byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
