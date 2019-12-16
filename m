Return-Path: <SRS0=mu3p=2G=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43906C43603
	for <linux-nvdimm@archiver.kernel.org>; Mon, 16 Dec 2019 01:34:19 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B94120828
	for <linux-nvdimm@archiver.kernel.org>; Mon, 16 Dec 2019 01:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B94120828
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kqyhe.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E5EF510097F18;
	Sun, 15 Dec 2019 17:37:40 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=116.207.14.237; helo=kqyhe.org; envelope-from=hxagptpob@kqyhe.org; receiver=<UNKNOWN> 
Received: from kqyhe.org (unknown [116.207.14.237])
	by ml01.01.org (Postfix) with ESMTP id CFCCD10097F16
	for <linux-nvdimm@lists.01.org>; Sun, 15 Dec 2019 17:37:34 -0800 (PST)
Message-ID: <DAF40CA7836B89CC82D758B66B2B53DC@kqyhe.org>
From: =?utf-8?B?6Ie05LyB5Lia55qE5LiA5bCB5L+h?= <hxagptpob@kqyhe.org>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?OTozNDoxMi9HRCZU5b2i5L2N5YWs5beu5LiO5bC65a+46ZO+?=
	=?utf-8?B?6K6h566XIOWPiiDloZHog7bku7borr7orqHkuI7ms6jloZFsaW51eC1u?=
	=?utf-8?B?dmRpbW1AbGlzdHMuMDEub3Jn?=
Date: Mon, 16 Dec 2019 09:34:08 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: VO5HNH7JRI6FMOWJJ47GBGE2FZTMAWXU
X-Message-ID-Hash: VO5HNH7JRI6FMOWJJ47GBGE2FZTMAWXU
X-MailFrom: hxagptpob@kqyhe.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/VO5HNH7JRI6FMOWJJ47GBGE2FZTMAWXU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

OTozNDoxMiAgIA0K6ZmEICAgICAgIOS7tiAgICAgIOS6siAgICAgICDlkK8NCjk6MzQ6MTIKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1t
IG1haWxpbmcgbGlzdCAtLSBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJl
IHNlbmQgYW4gZW1haWwgdG8gbGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
