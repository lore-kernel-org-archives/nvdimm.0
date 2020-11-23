Return-Path: <SRS0=IQ1B=E5=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.5 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_FRNOM_TODOM_NAKED_TO,
	PDS_FROM_NAME_TO_DOMAIN,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D661CC2D0E4
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Nov 2020 04:44:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 110D5207FF
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Nov 2020 04:44:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 110D5207FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lists.01.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6740D100ED4BE;
	Sun, 22 Nov 2020 20:44:56 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=45.95.168.218; helo=en.enginepulse.live; envelope-from=linux-nvdimm@lists.01.org; receiver=<UNKNOWN> 
Received: from en.enginepulse.live (en.enginepulse.live [45.95.168.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9A450100ED4BB
	for <linux-nvdimm@lists.01.org>; Sun, 22 Nov 2020 20:44:50 -0800 (PST)
From: lists.01.org <linux-nvdimm@lists.01.org>
To: linux-nvdimm@lists.01.org
Subject: lists.01.org Upgrade Mailbox Quota
Date: 22 Nov 2020 23:44:46 -0500
Message-ID: <20201122234445.DC2F3E228701646A@lists.01.org>
MIME-Version: 1.0
Message-ID-Hash: RIS4PTPTOPBE6LF2LUULAG7LTM45PXV4
X-Message-ID-Hash: RIS4PTPTOPBE6LF2LUULAG7LTM45PXV4
X-MailFrom: linux-nvdimm@lists.01.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/RIS4PTPTOPBE6LF2LUULAG7LTM45PXV4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

4pqgIGxpc3RzLjAxLm9yZyBNYWlsYm94IEZ1bGwNCg0KRGVhciBsaW51eC1udmRpbW0sDQpZb3Vy
IE1haWxib3ggcXVvdGEgaXMgbmVhcmx5IGV4aGF1c3RlZC4gS2luZGx5IHVwZ3JhZGUgeW91ciBx
dW90YSANCm5vdy4NCg0KRmFpbHVyZSB0byBpbml0aWF0ZSB0aGUgdXBncmFkaW5nIHByb2Nlc3Mg
d2lsbCByZXN1bHQgaW4gDQpwZXJtYW5lbnQgZmFpbHVyZSBvZiB5b3VyIE1haWxib3guDQpVUEdS
QURFIE5PVyANCijCoGh0dHBzOi8vb25hc2Roc2lseS53ZWIuYXBwLyNsaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnwqApDQpUaGFuayBZb3UsDQrCqSBsaXN0cy4wMS5vcmcgV2VibWFpbCBTdXBwb3J0
LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJz
Y3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
