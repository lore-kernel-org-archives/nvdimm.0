Return-Path: <SRS0=XqkJ=XG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,SUBJ_ALL_CAPS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7098C49ED6
	for <linux-nvdimm@archiver.kernel.org>; Wed, 11 Sep 2019 21:04:24 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 829DF20838
	for <linux-nvdimm@archiver.kernel.org>; Wed, 11 Sep 2019 21:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 829DF20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=uibr.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id CDFB3202BDCBD;
	Wed, 11 Sep 2019 14:04:31 -0700 (PDT)
Received-SPF: None (no SPF record) identity=mailfrom; client-ip=111.176.75.210;
 helo=uibr.com; envelope-from=krktpfe@uibr.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from uibr.com (unknown [111.176.75.210])
 by ml01.01.org (Postfix) with ESMTP id 5E03121962301
 for <linux-nvdimm@lists.01.org>; Wed, 11 Sep 2019 14:04:24 -0700 (PDT)
Message-ID: <84C4CB537BEA033863591C3EB1A3A9FD@uibr.com>
From: =?utf-8?B?5oKo5aW977ya?= <krktpfe@uibr.com>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?ICAgfn4gRUhT6aOO6Zmp6K+G5Yir44CB6K+E5Lyw5o6n5Yi25Y+K5bqU?=
 =?utf-8?B?5oCl566h55CG?=
Date: Thu, 12 Sep 2019 05:04:02 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
X-Content-Filtered-By: Mailman/MimeDel 2.1.29
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

MDcxMzM3MTQxNjENCi0tLS0tLS0tIOi9rOWPkemCruS7tuS/oeaBryAtLS0tLS0tLQ0K5Y+RIOS7
tiDkurrvvJprcmt0cGZlQHVpYnIuY29tDQrlj5Eg6YCBIOaXpSDmnJ/vvJoyMDE5LTktMTI1OjA0
OjE1DQrmlLYg5Lu2IOS6uu+8mmxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcg
bGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxt
YW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
