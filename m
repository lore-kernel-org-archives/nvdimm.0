Return-Path: <SRS0=pk2l=EE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53790C4363A
	for <linux-nvdimm@archiver.kernel.org>; Thu, 29 Oct 2020 02:46:08 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AEEF72076B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 29 Oct 2020 02:46:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEEF72076B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=smb.co.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id CE24216382FAE;
	Wed, 28 Oct 2020 19:46:06 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=165.84.180.109; helo=ihygyyr.monster; envelope-from=xoihm@ihygyyr.monster; receiver=<UNKNOWN> 
Received: from ihygyyr.monster (165084180109.ctinets.com [165.84.180.109])
	by ml01.01.org (Postfix) with ESMTP id 722921636989A
	for <linux-nvdimm@lists.01.org>; Wed, 28 Oct 2020 19:46:04 -0700 (PDT)
Message-ID: <E1C45FC1D0D8E2EAE97A4CFFF861C192@ihygyyr.monster>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L?= <smb-card@smb.co.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ6YeN6KaB44Gq44GK55+l44KJ44Gb44CR44OI44Op44Oz44K244Kv44K344On44Oz5L+d55WZ5Lit?=
Date: Thu, 29 Oct 2020 10:45:52 +0800
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.3.9600.19431
Message-ID-Hash: XXKFIPHECDNDTHVR4KXO374SGJEMLBPG
X-Message-ID-Hash: XXKFIPHECDNDTHVR4KXO374SGJEMLBPG
X-MailFrom: xoihm@ihygyyr.monster
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/XXKFIPHECDNDTHVR4KXO374SGJEMLBPG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQogDQoNCg0K5pys44Oh44O844Or44Gv44OJ44Oh44Kk44Oz44Gu6YGL55So77yI44Oh44O844Or
6YCB5Y+X5L+h44KE44Ob44O844Og44Oa44O844K444Gu6KGo56S677yJ44Gr6Zai44KP44KLDQrp
h43opoHjgarpgJrnn6Xjgajjgarjgorjgb7jgZnjgIINCuOBhOOBpOOCglMgTSBCIEPjgqvjg7zj
g4njgpLjgZTliKnnlKjjgYTjgZ/jgaDjgY3jgYLjgorjgYzjgajjgYbjgZTjgZbjgYTjgb7jgZnj
gIIgDQrlvIrnpL7jgafjga/jgIHjgYrlrqLmp5jjgavlronlv4PjgZfjgabjgqvjg7zjg4njgpLj
gZTliKnnlKjjgYTjgZ/jgaDjgY/jgZPjgajjgpLnm67nmoTjgavjgIENCuesrOS4ieiAheOBq+OC
iOOCi+S4jeato+S9v+eUqOOCkumYsuatouOBmeOCi+ODouODi+OCv+ODquODs+OCsOOCkuihjOOB
o+OBpuOBhOOBvuOBmeOAgg0K5b2T56S+44Gu5qSc5Ye644KS57WM44Gm44CB56ysM+iAheOBjOS4
jeazleaCquaEj+ODreOCsOOCpOODs+OBguOBquOBn+OBruS4ieS6leS9j+WPi+ODi+OCs+OCuXdl
YuOCteODvOODk+OCueOAgiANCg0K44GK5b+Z44GX44GE44Go44GT44KN5aSn5aSJ5oGQ44KM5YWl
44KK44G+44GZ44GM44CB5LiL44Gu44CQ44GK5ZWP44GE5ZCI44KP44Gb56qT5Y+j44CR44G+44Gn
44CBDQrjgarjgYrjgIHjgZTlpZHntITjgYTjgZ/jgaDjgYTjgabjgYTjgovjgqvjg7zjg4njgavj
gaTjgYTjgabjga/jgIHnrKzkuInogIXjgavjgojjgovkuI3mraPkvb/nlKjjga4NCuWPr+iDveaA
p+OBjOOBlOOBluOBhOOBvuOBmeOBruOBp+OAgeOCq+ODvOODieOBruOBlOWIqeeUqOOCkuS4gOaZ
gueahOOBq+WBnOatouOBleOBm+OBpuOBhOOBn+OBoOOBhOOBpuOBhOOCi+OAgQ0K44KC44GX44GP
44Gv5LuK5b6M5YGc5q2i44GV44Gb44Gm44GE44Gf44Gg44GP5aC05ZCI44GM44GU44GW44GE44G+
44GZ44CCDQrjgZTkuI3kvr/jgajjgZTlv4PphY3jgpLjgYrjgYvjgZHjgZfjgb7jgZfjgaboqqDj
gavnlLPjgZfoqLPjgZTjgZbjgYTjgb7jgZvjgpPjgYzjgIENCuS9leOBqOOBnuOBlOeQhuino+iz
nOOCiuOBn+OBj+OBiumhmOOBhOeUs+OBl+OBguOBkuOBvuOBmeOAgg0KDQroh7PmgKXjgIFTIE0g
QiBD44Kr44O844OJ5Lya5ZOh44K144O844OT44K544Gr5L+u5q2j5oOF5aCx44KS5YaN55m76Yyy
44GX44Gm44GP44Gg44GV44GEDQoNCg0K5Lya5ZOh44K144O844OT44K5VnBhc3Pjga7jgZTnmbvp
jLINCnNtYi1jYXJkQHNtYi5jby5qcA0KDQoNCuOAgCAgICAgICAgICAgICAgICAgICAgICAgICAg
IENvcHlyaWdodCAoQykgMjAyMCBTdW1pdG9tbyBNaXRzdWkgQ2FyZCBDby4sIEx0ZC4NCg0KIApf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3Jp
YmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
