Return-Path: <SRS0=AdRK=ZG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=FROM_LOCAL_NOVOWEL,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3AEC432C3
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 Nov 2019 08:24:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D4A22071B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 Nov 2019 08:24:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D4A22071B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ner.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3AF43100DC43E;
	Thu, 14 Nov 2019 00:26:09 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=122.191.124.152; helo=ner.org; envelope-from=atrbsdmnp@ner.org; receiver=<UNKNOWN> 
Received: from ner.org (unknown [122.191.124.152])
	by ml01.01.org (Postfix) with ESMTP id EA7D5100EA630
	for <linux-nvdimm@lists.01.org>; Thu, 14 Nov 2019 00:26:04 -0800 (PST)
Message-ID: <E34CDBB101AE090B60259BE2A2B89DE4@ner.org>
From: =?utf-8?B?6YK157uP55CG?= <atrbsdmnp@ner.org>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?ZnXvvJrpmLLplJnmioDmnK/lj4rmnInmlYjop6PlhrPpl67popg=?=
Date: Thu, 14 Nov 2019 16:24:25 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: CPQ53BIGGOHH36OW5QMUVRXQN7MNLQHU
X-Message-ID-Hash: CPQ53BIGGOHH36OW5QMUVRXQN7MNLQHU
X-MailFrom: atrbsdmnp@ner.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CPQ53BIGGOHH36OW5QMUVRXQN7MNLQHU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

5p2l6IeqIGF0cmJzZG1ucEBuZXIub3JnIOeahOS/oeS7tu+8mgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0t
IGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0
byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
