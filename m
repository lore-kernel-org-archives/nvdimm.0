Return-Path: <SRS0=AdRK=ZG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A03C432C3
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 Nov 2019 11:13:43 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AC45C2070E
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 Nov 2019 11:13:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC45C2070E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vsujrgyrc.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7826C100DC3C1;
	Thu, 14 Nov 2019 03:15:13 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=58.50.71.196; helo=vsujrgyrc.com; envelope-from=bhtn@vsujrgyrc.com; receiver=<UNKNOWN> 
Received: from vsujrgyrc.com (unknown [58.50.71.196])
	by ml01.01.org (Postfix) with ESMTP id 9189E100DC43E
	for <linux-nvdimm@lists.01.org>; Thu, 14 Nov 2019 03:15:09 -0800 (PST)
Message-ID: <3AC6912DE0CD9297C047CEB9DD2B7FD5@vsujrgyrc.com>
From: =?utf-8?B?6ZKf5Li75Lu7?= <bhtn@vsujrgyrc.com>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?562UIOWkje+8mnBiMGhhdTR05paw5b2i5Yq/5LiL5Yy65Z+f5biC5Zy6?=
	=?utf-8?B?5byA5Y+R5LiO57uP6ZSA5ZWG566h55CG?=
Date: Thu, 14 Nov 2019 19:13:26 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: ARJASZD3Z2AEJJK7OS272W6XOIIFOEMZ
X-Message-ID-Hash: ARJASZD3Z2AEJJK7OS272W6XOIIFOEMZ
X-MailFrom: bhtn@vsujrgyrc.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ARJASZD3Z2AEJJK7OS272W6XOIIFOEMZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

6L2sICDlj5EuLi4uLi4NCuWPkeS7tuS6ujogIumSn+S4u+S7uyI7PGJodG5AdnN1anJneXJjLmNv
bT4NCuWPkemAgeaXtumXtDogMjAxOS0xMS0xNC8gMTk6MTM6MzgNCuaUtuS7tuS6ujogImxpbnV4
LW52ZGltbSI8bGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZz4KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBs
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8g
bGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
