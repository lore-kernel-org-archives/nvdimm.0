Return-Path: <SRS0=qiSW=FE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=BAYES_80,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE3EC64E8A
	for <linux-nvdimm@archiver.kernel.org>; Mon, 30 Nov 2020 21:20:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8CEC12084C
	for <linux-nvdimm@archiver.kernel.org>; Mon, 30 Nov 2020 21:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CEC12084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sgljs.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5138F100ED498;
	Mon, 30 Nov 2020 13:20:27 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=223.150.33.199; helo=sgljs.com; envelope-from=rjvakb@sgljs.com; receiver=<UNKNOWN> 
Received: from sgljs.com (unknown [223.150.33.199])
	by ml01.01.org (Postfix) with ESMTP id 942F9100ED496
	for <linux-nvdimm@lists.01.org>; Mon, 30 Nov 2020 13:20:23 -0800 (PST)
Message-ID: <C5A67D7192D349D9F458ED7B0AC06B1D@sgljs.com>
From: =?utf-8?B?5bCK5pWs55qE55u45YWz6aKG5a+8?= <rjvakb@sgljs.com>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?NjExNuS4muWKoeWRmOWmguS9leWunuW/q+mAn+eOsOS4mue7qeWAjeWing==?=
Date: Tue, 1 Dec 2020 05:20:48 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: E4DABINGFPJZRV6TN6CCPBKPO4P5JOVM
X-Message-ID-Hash: E4DABINGFPJZRV6TN6CCPBKPO4P5JOVM
X-MailFrom: rjvakb@sgljs.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/E4DABINGFPJZRV6TN6CCPBKPO4P5JOVM/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

bGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZw0KICDpmYQg5Lu2IA0KICAgICAgICAg5LqyIOWQrwpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3Jp
YmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
