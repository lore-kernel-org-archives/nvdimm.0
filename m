Return-Path: <SRS0=R0py=H4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52CBC433DB
	for <linux-nvdimm@archiver.kernel.org>; Fri, 26 Feb 2021 08:19:32 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DF96964EE2
	for <linux-nvdimm@archiver.kernel.org>; Fri, 26 Feb 2021 08:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF96964EE2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vpass.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8A7C8100EBBB4;
	Fri, 26 Feb 2021 00:19:31 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=118.27.73.2; helo=vpass.ne.jp; envelope-from=ohsbn@vpass.ne.jp; receiver=<UNKNOWN> 
Received: from vpass.ne.jp (v118-27-73-2.ni1b.static.cnode.io [118.27.73.2])
	by ml01.01.org (Postfix) with ESMTP id 09723100EF250
	for <linux-nvdimm@lists.01.org>; Fri, 26 Feb 2021 00:19:27 -0800 (PST)
Message-ID: <314901153A2D4F0E8142A32B0143F649@vpass.ne.jp>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L44Kr44O844OJ?= <ohsbn@vpass.ne.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5LiJ5LqV5L2P5Y+L44Kr44O844OJ44CR55m76Yyy5oOF5aCx44Gv5pyf6ZmQ5YiH44KM44Gn44GZ?=
	=?utf-8?B?IA==?=
Date: Fri, 26 Feb 2021 17:19:15 +0900
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V10.0.17763.1
Message-ID-Hash: ZYMYM3RDI36ILVQLLOZII2MQI3NAEKOP
X-Message-ID-Hash: ZYMYM3RDI36ILVQLLOZII2MQI3NAEKOP
X-MailFrom: ohsbn@vpass.ne.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZYMYM3RDI36ILVQLLOZII2MQI3NAEKOP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

IA0KDQogDQogDQoNCiANCg0KIA0KIA0KDQogDQoNCiANCg0KDQoNCiAg44GE44Gk44KC5byK56S+
44Kr44O844OJ44KS44GU5Yip55So44GE44Gf44Gg44GN44GC44KK44GM44Go44GG44GU44GW44GE
44G+44GZ44CCDQoNCiAg5pyq5L2/55So44Gu44Gf44KB44CB44GK5a6i5qeY44GuVlBBU1Pnmbvp
jLLmg4XloLHjga7mnInlirnmnJ/pmZDjgYzliIfjgozjgabjgYrjgorjgIHjgqvjg7zjg4njgpLj
gZTliKnnlKjjgYTjgZ/jgaDjgZHjgb7jgZvjgpPjgIIg5byV44GN57aa44GN44GU5Yip55So44GE
44Gf44Gg44GP44Gr44Gv44CB44Ot44Kw44Kk44Oz44GX44Gm5YaN5bqm6Kit5a6a44GX44Gm44GP
44Gg44GV44GE44CCDQoNCiANCuKUgeKUgeKUgeKUgeKUgeKUgeKUgQ0K44GU6Kit5a6a44Gv44GT
44Gh44KJ44GL44KJDQrilIHilIHilIHilIHilIHilIHilIENCg0KDQoNCuOBiumbu+ipseOBp+OB
ruOBiuaJi+e2muOBjQ0K57Sb5aSx55uX6Zuj44OH44K544Kv44CAMDEyMC05MTktNDU244CA77yI
5Y+X5LuY5pmC6ZaT77yPMjTmmYLplpPjg7vlubTkuK3nhKHkvJHvvIkNCg0KDQoNCuS4ieS6leS9
j+WPi+OCq+ODvOODieagquW8j+S8muekvg0K44CSMTA1LTgwMTEg5p2x5Lqs6YO95riv5Yy65rW3
5bK4MeS4geebrjLnlaoyMOWPtyDmsZDnlZnjg5Pjg6vjg4fjgqPjg7PjgrANCg0KDQoNCiANCkNv
cHlyaWdodCAoQykgMjAyMSBTdW1pdG9tbyBNaXRzdWkgQ2FyZCBDby4sIEx0ZC4KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxp
bmcgbGlzdCAtLSBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQg
YW4gZW1haWwgdG8gbGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
