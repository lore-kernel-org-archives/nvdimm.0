Return-Path: <SRS0=IBTI=YB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9769C4360C
	for <linux-nvdimm@archiver.kernel.org>; Tue,  8 Oct 2019 16:01:06 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A585E2070B
	for <linux-nvdimm@archiver.kernel.org>; Tue,  8 Oct 2019 16:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A585E2070B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=uhhkcwvla.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id DBE3D10FC38A1;
	Tue,  8 Oct 2019 09:03:36 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=111.176.69.251; helo=uhhkcwvla.net; envelope-from=iedu@uhhkcwvla.net; receiver=<UNKNOWN> 
Received: from uhhkcwvla.net (unknown [111.176.69.251])
	by ml01.01.org (Postfix) with ESMTP id 76D2010FC38A0
	for <linux-nvdimm@lists.01.org>; Tue,  8 Oct 2019 09:03:32 -0700 (PDT)
Message-ID: <5EFBD6E76B173E5760E4B557A8595C1E@uhhkcwvla.net>
From: =?utf-8?B?6LW15Li75Lu7?= <iedu@uhhkcwvla.net>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?5ZueIOWkje+8mjQwODA1MzYgIOS6pyDlk4Eg57uTIOaehA==?=
	=?utf-8?B?IOiuviDorqE=?=
Date: Wed, 9 Oct 2019 00:00:50 +0800
MIME-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-ID-Hash: XOTC4XWEJNKSZGODNJHMZA3EZ3ASV73O
X-Message-ID-Hash: XOTC4XWEJNKSZGODNJHMZA3EZ3ASV73O
X-MailFrom: iedu@uhhkcwvla.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/XOTC4XWEJNKSZGODNJHMZA3EZ3ASV73O/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

5p2l6IeqbGludXgtbnZkaW1t55qE6YKu5Lu2Li4uLi4uDQrlj5Hku7bkuro6ICLotbXkuLvku7si
OzxpZWR1QHVoaGtjd3ZsYS5uZXQ+DQrlj5HpgIHml7bpl7Q6IDIwMTktMTAtOS8gMDowMTowMg0K
5pS25Lu25Lq6OiAibGludXgtbnZkaW1tIjxsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnPgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0g
bWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUg
c2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
