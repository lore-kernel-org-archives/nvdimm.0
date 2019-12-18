Return-Path: <SRS0=X/oK=2I=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3694C43603
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Dec 2019 18:28:41 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8BD032465E
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Dec 2019 18:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=bestmaildelivery.life header.i=sales@bestmaildelivery.life header.b="vH+WtjNL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BD032465E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=bestmaildelivery.life
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 818B310113662;
	Wed, 18 Dec 2019 10:32:03 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=112.137.166.158; helo=bestmaildelivery.life; envelope-from=sales@bestmaildelivery.life; receiver=<UNKNOWN> 
Received: from bestmaildelivery.life (bestmaildelivery.life [112.137.166.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D4C1C10113600
	for <linux-nvdimm@lists.01.org>; Wed, 18 Dec 2019 10:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=default; d=bestmaildelivery.life;
 h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; i=sales@bestmaildelivery.life;
 bh=b/4zymXB4zKdhPeIgSKiG3HTDfw=;
 b=vH+WtjNLvUyVwjB1c+unUQpagZpY5ylsPRAq56znvTD2n2B5rtHwjoRoFdj9pRMHYH+4i0HFerdL
   i7XBLrXP1KSiwuAs6veaub5a+WzStPt90x+79qUeYgJ1LcfJv4Y753r4pWYqCPCTSvie2HssNvj/
   dSLO0YvBzfdd0ey9TvQ=
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns; s=default; d=bestmaildelivery.life;
 b=B6UGQTv/UrIzeABkCYOAJ7tz8QJ0rbG6oaL5/Cl0Nip+LdHakTCcDtlIEMlLXpy+WqgSjESX+8ZQ
   YRxdZrpd/dofEEA40QNPzPXTCWWr+VsmT96SxNal3jNgyyeM4SXG7n9ClmwMO7HQitGVMKjAuRtR
   6GjfBVgG5p7T0HPF1mQ=;
From: =?utf-8?B?57O757uf566h55CG5ZGY?= <sales@bestmaildelivery.life>
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQbGludXgtbnZkaW1tQGxpc3RzLg==?=
	=?utf-8?B?MDEub3Jn44CR6YKu566x5bCG5ruh77yM6K+35Y+K5pe25riF55CG6YKu566x?=
Date: Wed, 18 Dec 2019 10:28:24 -0800
Message-ID: <003355b49cb6$6724fb2c$1bb222e7$@rsmb>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Message-ID-Hash: OSW4OZNHNO3WZGQOISWTUMJDREGHKTUJ
X-Message-ID-Hash: OSW4OZNHNO3WZGQOISWTUMJDREGHKTUJ
X-MailFrom: sales@bestmaildelivery.life
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/OSW4OZNHNO3WZGQOISWTUMJDREGHKTUJ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

ICAgDQrmuKnppqjmj5DnpLrvvJrmgqjnmoTlhY3otLnkvIHkuJrnlLXlrZDpgq7ku7Yg5bey6KKr
5YiX5Li65Y+W5raIDQoNCuWwiuaVrOeahOeUqOaIt++8mg0KDQogICAgICAgICAg5qC55o2u44CK
6Z2e57uP6JCl5oCn5LqS6IGU572R5L+h5oGv5pyN5Yqh5aSH5qGI566h55CG5Yqe5rOV44CL56ys
5Y2B5YWr5p2h5rOV6KeE77yM5oKo55qE5Z+f5ZCN5bCa5pyq6L+b6KGM5aSH5qGI77yM5pqC5pe2
5peg5rOV6K6/6Zeu44CC6K+35Y+C6ICDIOW3peS/oemDqOebuOWFs+Wkh+ahiOa1geeoiyDov5vo
oYznm7jlhbPmk43kvZzjgIIgDQoNCua4qemmqOaPkOekuu+8mg0KDQogICAgICAgICAg5LiA44CB
5q2k6aG16Z2i5piv5o+Q56S66aG16Z2i77yM55So5LqO6K6/6Zeu5Y2z5bCG5Yiw5pyf55qE5Z+f
5oiW55S15a2Q6YKu5Lu25Zyw5Z2A77yM6Iul5oKo5pyJ5YW25LuW5Y6f5Zug6ZyA57un57ut5L2/
55So5q2k6YKu566x6KaB5LmIIOWmguaenOaCqOayoeacieeUs+ivt+atpOWPlua2iO+8jOivt+aM
ieeFp+S7peS4i+atpemqpOaBouWkjeaCqOeahOW4kOaIt+mCrueuseeUqOaIt+eZu+W9lemhteeZ
u+W9leOAgiANCg0KICAgICAgICAgIOS6jOOAgeWmguaenOaCqOW3sue7j+aYr+mCrueuseeUqOaI
t+W5tuS4lOaaguaXtuaXoOazleiusOW9le+8jOaIluiAheaCqOW4jOacm+mAgOiuouWwhuadpeea
hOmAmuefpeaIluaPkOmGkuWPlua2iOS7peWQjueahOmAmuefpeeZu+W9leOAgiANCg0K5oSf6LCi
5oKo55qE6YWN5ZCI77yBDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVA
bGlzdHMuMDEub3JnCg==
