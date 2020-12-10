Return-Path: <SRS0=kph0=FO=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=3.0 tests=BAYES_95,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6BAC4361B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 10 Dec 2020 11:43:03 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 35AB323D57
	for <linux-nvdimm@archiver.kernel.org>; Thu, 10 Dec 2020 11:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35AB323D57
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=knf.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5F162100EB84F;
	Thu, 10 Dec 2020 03:43:02 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=223.150.30.121; helo=knf.net; envelope-from=odjd@knf.net; receiver=<UNKNOWN> 
Received: from knf.net (unknown [223.150.30.121])
	by ml01.01.org (Postfix) with ESMTP id 7EE54100EBBBF
	for <linux-nvdimm@lists.01.org>; Thu, 10 Dec 2020 03:42:55 -0800 (PST)
Message-ID: <69EBE37C68385FDDF2ADA9EA23B2884F@knf.net>
From: =?utf-8?B?5oCl5Lu2?= <odjd@knf.net>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?MTjmioDmnK/lkZjlpoLkvZXln7nlhbvoh6rlt7HnmoTpooblr7zlips=?=
Date: Thu, 10 Dec 2020 19:44:07 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: DYUVJAR275KYPG7SL6QQXC3LJP45FGSD
X-Message-ID-Hash: DYUVJAR275KYPG7SL6QQXC3LJP45FGSD
X-MailFrom: odjd@knf.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DYUVJAR275KYPG7SL6QQXC3LJP45FGSD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

bGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZw0KICAg5Lqy77yaDQrlpoIg5a+5IOatpCDor74g56iL
IOaciemcgOaxgiDor7fmn6Ug5pS26ZmEIOS7tuWGheWuuQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxp
bnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBs
aW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
