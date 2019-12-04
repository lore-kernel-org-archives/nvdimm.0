Return-Path: <SRS0=QN7s=Z2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFD0C432C3
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Dec 2019 01:56:10 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C530F205ED
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Dec 2019 01:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C530F205ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gyyepxc.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 09E5E100DC2B8;
	Tue,  3 Dec 2019 17:59:33 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=116.207.15.155; helo=gyyepxc.net; envelope-from=vv@gyyepxc.net; receiver=<UNKNOWN> 
Received: from gyyepxc.net (unknown [116.207.15.155])
	by ml01.01.org (Postfix) with ESMTP id BFF69100DC41F
	for <linux-nvdimm@lists.01.org>; Tue,  3 Dec 2019 17:59:28 -0800 (PST)
Message-ID: <06C95BA1F77BE5C2908962B710778C58@gyyepxc.net>
From: =?utf-8?B?5ZKM5L6D?= <vv@gyyepxc.net>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?5Lqn5ZOB57uT5p6E6K6+6K6h55+l6K+G55qE5LqG6Kej5LiO5bqU55So5Y+K6L+b5Ye65Y+j5LyB5Lia?=
	=?utf-8?B?5YWz5Yqh566h55CGOTo1NjowNg==?=
Date: Wed, 4 Dec 2019 09:56:02 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: 2MRU4SAI22BL7WD2QSZ5FNEAIOPXZJOJ
X-Message-ID-Hash: 2MRU4SAI22BL7WD2QSZ5FNEAIOPXZJOJ
X-MailFrom: vv@gyyepxc.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2MRU4SAI22BL7WD2QSZ5FNEAIOPXZJOJ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

TWVzc2FnZS1JRDogMDYyODI5MTQ0MTI2Ng0KRnJvbTogPT93bWN5cmo/Pz0gPGxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmc+DQpUbzogPHZ2QGd5eWVweGMubmV0Pg0KwrfCt+ivpsK3wrfmg4XCt8K3
6KeBwrfCt+mZhMK3wrfku7bCt8K3Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1s
ZWF2ZUBsaXN0cy4wMS5vcmcK
