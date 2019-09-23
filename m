Return-Path: <SRS0=3Jme=XS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEF0C4CECF
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Sep 2019 15:57:12 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A977220673
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Sep 2019 15:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A977220673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=oplop.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1735C202F4FF9;
	Mon, 23 Sep 2019 08:59:42 -0700 (PDT)
Received-SPF: None (no SPF record) identity=mailfrom; client-ip=122.190.107.119;
 helo=oplop.com; envelope-from=ejg@oplop.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from oplop.com (unknown [122.190.107.119])
 by ml01.01.org (Postfix) with ESMTP id 30A81202EF27C
 for <linux-nvdimm@lists.01.org>; Mon, 23 Sep 2019 08:59:35 -0700 (PDT)
Message-ID: <9F6BA2C1D3FD47205A017FA9A60C9FB1@oplop.com>
From: =?utf-8?B?6K+35oKo5p+l6ZiF5L+h5Lu2?= <ejg@oplop.com>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?5Zue5aSN77ya56CU5Y+R6aG555uu566h55CG5Y+K5Lqn5ZOB57uP55CG?=
Date: Mon, 23 Sep 2019 23:56:54 +0800
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

5Y+R5Lu25Lq6OiAi6K+35oKo5p+l6ZiF5L+h5Lu2Ijs8ZWpnQG9wbG9wLmNvbT4NCuWPkemAgeaX
tumXtDogMjAxOS05LTIzLyAyMzo1NzowNg0K5pS25Lu25Lq6OiAibGludXgtbnZkaW1tIjxsaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnPg0KNjU2NTA1OTUgICDpmYQgIOS7tiAgIOS6siAg5ZCvCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGlt
bSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAx
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
