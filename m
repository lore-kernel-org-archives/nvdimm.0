Return-Path: <SRS0=sBMZ=HZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CAEC433E6
	for <linux-nvdimm@archiver.kernel.org>; Tue, 23 Feb 2021 15:23:25 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E5B3364E4D
	for <linux-nvdimm@archiver.kernel.org>; Tue, 23 Feb 2021 15:23:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5B3364E4D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vpass.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A1B16100EC1CF;
	Tue, 23 Feb 2021 07:23:24 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=160.251.38.240; helo=vpass.ne.jp; envelope-from=kongrziday@vpass.ne.jp; receiver=<UNKNOWN> 
Received: from vpass.ne.jp (v160-251-38-240.bzpp.static.cnode.io [160.251.38.240])
	by ml01.01.org (Postfix) with ESMTP id D0A13100EF26A
	for <linux-nvdimm@lists.01.org>; Tue, 23 Feb 2021 07:23:20 -0800 (PST)
Message-ID: <6A50345ACD83CA087A55FC4CBFBFDB10@vpass.ne.jp>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L44Kr44O844OJ?= <kongrziday@vpass.ne.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5LiJ5LqV5L2P5Y+L44Kr44O844OJ44CR55m76Yyy5oOF5aCx44KS6KiC5q2j44GX44Gm44GP44Gg?=
	=?utf-8?B?44GV44GE?=
Date: Wed, 24 Feb 2021 00:23:08 +0900
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V10.0.17763.1
Message-ID-Hash: G4Q3BG26NIJBJJJ3MQQMFFC6BYT7DD2R
X-Message-ID-Hash: G4Q3BG26NIJBJJJ3MQQMFFC6BYT7DD2R
X-MailFrom: kongrziday@vpass.ne.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/G4Q3BG26NIJBJJJ3MQQMFFC6BYT7DD2R/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

IA0KDQogDQogDQoNCiANCg0KIA0KIA0KDQogDQoNCiANCg0KDQoNCiAg44GE44Gk44KC5byK56S+
44Kr44O844OJ44KS44GU5Yip55So44GE44Gf44Gg44GN44GC44KK44GM44Go44GG44GU44GW44GE
44G+44GZ44CCDQoNCiAg44GK5a6i5qeY44Gu55m76Yyy5oOF5aCx44GM6ZaT6YGV44Gj44Gm44GE
44KL44Gf44KB44CB44Kr44O844OJ44KS5L2/55So44Gn44GN44G+44Gb44KT44CC44Ot44Kw44Kk
44Oz44GX44Gm5L+u5q2j44GX44Gm44GP44Gg44GV44GE44CCDQoNCiANCuKUgeKUgeKUgeKUgeKU
geKUgeKUgQ0K44GU5aSJ5pu044Gv44GT44Gh44KJ44GL44KJDQrilIHilIHilIHilIHilIHilIHi
lIENCg0KDQoNCuOBiumbu+ipseOBp+OBruOBiuaJi+e2muOBjQ0K57Sb5aSx55uX6Zuj44OH44K5
44Kv44CAMDEyMC05MTktNDU244CA77yI5Y+X5LuY5pmC6ZaT77yPMjTmmYLplpPjg7vlubTkuK3n
hKHkvJHvvIkNCg0KDQoNCuS4ieS6leS9j+WPi+OCq+ODvOODieagquW8j+S8muekvg0K44CSMTA1
LTgwMTEg5p2x5Lqs6YO95riv5Yy65rW35bK4MeS4geebrjLnlaoyMOWPtyDmsZDnlZnjg5Pjg6vj
g4fjgqPjg7PjgrANCg0KDQoNCiANCkNvcHlyaWdodCAoQykgMjAyMSBTdW1pdG9tbyBNaXRzdWkg
Q2FyZCBDby4sIEx0ZC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBsaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8gbGludXgtbnZkaW1tLWxlYXZlQGxp
c3RzLjAxLm9yZwo=
