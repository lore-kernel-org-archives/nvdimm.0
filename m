Return-Path: <SRS0=gaN0=YI=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	FROM_DOMAIN_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00904C10F14
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Oct 2019 17:45:03 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BCDEC20854
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Oct 2019 17:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCDEC20854
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gspqfpmlq.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 013AA10FCBF4A;
	Tue, 15 Oct 2019 10:48:01 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=122.191.125.70; helo=gspqfpmlq.net; envelope-from=xocptl@gspqfpmlq.net; receiver=<UNKNOWN> 
Received: from gspqfpmlq.net (unknown [122.191.125.70])
	by ml01.01.org (Postfix) with ESMTP id 9047010FCBF47
	for <linux-nvdimm@lists.01.org>; Tue, 15 Oct 2019 10:47:58 -0700 (PDT)
Message-ID: <B574AAC06CD3B46B9ECAAA929E2A7BCF@gspqfpmlq.net>
From: =?utf-8?B?6K+35oKo5p+l6ZiF5L+h5Lu2?= <xocptl@gspqfpmlq.net>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?6K+35oKo5p+l6ZiF5L+h5Lu277ya5oKo55qE5L+h5Lu2?=
Date: Wed, 16 Oct 2019 01:44:58 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: VYFSVDKO646H7TJAD72VQQSVW6N5OIAU
X-Message-ID-Hash: VYFSVDKO646H7TJAD72VQQSVW6N5OIAU
X-MailFrom: xocptl@gspqfpmlq.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/VYFSVDKO646H7TJAD72VQQSVW6N5OIAU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

5p2l6IeqIHhvY3B0bEBnc3BxZnBtbHEubmV0IOeahOS/oeS7tu+8mg0KIApfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBs
aXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBl
bWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
