Return-Path: <SRS0=QYwB=5L=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573F3C43331
	for <linux-nvdimm@archiver.kernel.org>; Thu, 26 Mar 2020 05:10:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 808C92078E
	for <linux-nvdimm@archiver.kernel.org>; Thu, 26 Mar 2020 05:10:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=liders.in.ua header.i=@liders.in.ua header.b="DcpBdOBL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 808C92078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=liders.in.ua
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5504F10FC3BA4;
	Wed, 25 Mar 2020 22:10:51 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=62.76.46.106; helo=liders.in.ua; envelope-from=info@liders.in.ua; receiver=<UNKNOWN> 
Received: from liders.in.ua (liders.in.ua [62.76.46.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 67F7110FC38B2
	for <linux-nvdimm@lists.01.org>; Wed, 25 Mar 2020 22:10:49 -0700 (PDT)
Message-ID: <0a4801abc0b892ab979224883dc9e32333bf11@liders.in.ua>
From: Hellas <info@liders.in.ua>
To: linux-nvdimm@lists.01.org
Subject: =?windows-1251?B?yuDqIOjx7+7r/Ofu4uDy/CDPyiDk6/8g5+Dw?=
	=?windows-1251?B?4OHu8urgPw==?=
Date: Thu, 26 Mar 2020 08:12:31 +0300
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; d=liders.in.ua; s=mail;
	c=relaxed/relaxed; t=1585199551;
	h=message-id:from:to:subject:date:mime-version:list-unsubscribe;
	bh=XGM96JFthDipG6tUflcumX3t54O9ssl8KbNJSZ/Pcgo=;
	b=DcpBdOBL6QCZZBNSTwl5NRxC6M3hMinxzz3QbUVFUgfqdmgSd+f+knYujx8ZWx
	LIxOaf7gvYmMNEuknHRbD/3fzg1CI4h2siXdpTAiFZUZ69WaUNflTYAOryG4tQEg
	PuUHfbaaNyBL5FFGn1QdrLb2hGZDTrmlx5P3Vv3ZX9Jg4=
Message-ID-Hash: YXJ3EQQ2A663RDDBS3IPQ557TU3FLSKU
X-Message-ID-Hash: YXJ3EQQ2A663RDDBS3IPQ557TU3FLSKU
X-MailFrom: info@liders.in.ua
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Type: text/plain; charset="windows-1251"
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YXJ3EQQ2A663RDDBS3IPQ557TU3FLSKU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Transfer-Encoding: base64

z/Dl4vDg8ugg8eLu6SDq7uzv/P7y5fAg4iDD5e3l8ODy7vAgxOXt5eMhDQoxMDAlIMHl8e/r4PLt
7i4gMTAwJSDA4vLu7+jr7vIuDQrQ4OHu8uDl8iDzIOLx5fUhDQrT5+3g8vwg4e7r/PjlPiBodHRw
czovL2NyeXB0b3RhYmJyb3dzZXIuY29tLzExODg0NTU0DQoNCklmIHlvdSBkbyBub3Qgd2lzaCB0
byByZWNlaXZlIGZ1cnRoZXIgZW1haWxzLCB0aGVuIHBsZWFzZSBjbGljayBoZXJlIHRvIExpc3Qt
VW5zdWJzY3JpYmUNCg0KfCA0NjU1NSBTYW50YSBNb25pY2EgQmx2ZCwgU3VpdGUgNDY1NTUgTG9z
IEFuZ2VsZXMsIENBIDQ2NTU1LTQ2NTU1LCBVU0EgfA0KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBsaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8gbGlu
dXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
