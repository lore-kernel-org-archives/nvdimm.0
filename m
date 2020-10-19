Return-Path: <SRS0=ZwrK=D2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_50,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D45C433DF
	for <linux-nvdimm@archiver.kernel.org>; Mon, 19 Oct 2020 06:42:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D51422260
	for <linux-nvdimm@archiver.kernel.org>; Mon, 19 Oct 2020 06:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D51422260
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E354F124FFCC8;
	Sun, 18 Oct 2020 23:42:55 -0700 (PDT)
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3AA03124FFCC5
	for <linux-nvdimm@lists.01.org>; Sun, 18 Oct 2020 23:42:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: What happens when you unblock someone on Facebook?
From: adomstark121@gmail.com
To: linux-nvdimm@lists.01.org
Date: Mon, 19 Oct 2020 06:42:54 -0000
Message-ID: <20201019064254.2812.85092@ml01.vlan13.01.org>
User-Agent: HyperKitty on https://lists.ofono.org/
Message-ID-Hash: MNV7Q64OQ6BKEGWXWOXBJ73OPPFITDV6
X-Message-ID-Hash: MNV7Q64OQ6BKEGWXWOXBJ73OPPFITDV6
X-MailFrom: adomstark121@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MNV7Q64OQ6BKEGWXWOXBJ73OPPFITDV6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Transfer-Encoding: base64

T25jZSB5b3UgYmxvY2sgc29tZW9uZSBmcm9tIHlvdXIgRmFjZWJvb2sgYWNjb3VudCwgdGhlbiB0
aGV5IGJlY29tZSB1bmFibGUgdG8gc2VlIHlvdXIgcHJvZmlsZSBhcyB3ZWxsIGFzIHRoZXkgZGlk
buKAmXQgc2VuZCB5b3UgYW55IG1lc3NhZ2UgdGhlcmUuIFNvLCBpZiB5b3UgdW5ibG9jayBzb21l
b25lIG9uIEZhY2Vib29rLCB0aGVuIHRoZXkgYmVjb21lIHlvdXIgZnJpZW5kIGFnYWluIG9uIEZh
Y2Vib29rIGFzIHdlbGwgYXMgdGhleSBjYW4gc2VlIHlvdXIgcHJvZmlsZSBhbmQgc2VuZCB5b3Ug
YSBtZXNzYWdlLiBodHRwczovL3d3dy5jdXN0b21lcmNhcmUtZW1haWwuY29tL2Jsb2cvdW5ibG9j
ay1zb21lb25lLW9uLWZhY2Vib29rLwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBs
aXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0t
bGVhdmVAbGlzdHMuMDEub3JnCg==
