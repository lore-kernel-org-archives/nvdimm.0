Return-Path: <SRS0=MSTB=IC=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1D6C433E0
	for <linux-nvdimm@archiver.kernel.org>; Thu,  4 Mar 2021 10:07:47 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CB30664EF6
	for <linux-nvdimm@archiver.kernel.org>; Thu,  4 Mar 2021 10:07:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB30664EF6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vpass.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 39709100EB34F;
	Thu,  4 Mar 2021 02:07:46 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=160.251.1.254; helo=vpass.ne.jp; envelope-from=zm@vpass.ne.jp; receiver=<UNKNOWN> 
Received: from vpass.ne.jp (v160-251-1-254.wcb6.static.cnode.io [160.251.1.254])
	by ml01.01.org (Postfix) with ESMTP id 25DA4100EF27B
	for <linux-nvdimm@lists.01.org>; Thu,  4 Mar 2021 02:07:42 -0800 (PST)
Message-ID: <C71D9936B9ED3920B428F0E359DEBC41@vpass.ne.jp>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L44Kr44O844OJ?= <zm@vpass.ne.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5LiJ5LqV5L2P5Y+L44Kr44O844OJ44CRVnBhc3PjgYzplbfmnJ/plpPlpInmm7Q=?=
	=?utf-8?B?44GV44KM44Gm44GE44G+44Gb44KT?=
Date: Thu, 4 Mar 2021 19:07:34 +0900
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V10.0.17763.1
Message-ID-Hash: M5SFYXFB47OBQAH4I7V33G67MQGSQINF
X-Message-ID-Hash: M5SFYXFB47OBQAH4I7V33G67MQGSQINF
X-MailFrom: zm@vpass.ne.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/M5SFYXFB47OBQAH4I7V33G67MQGSQINF/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

IA0KDQogDQogDQoNCiANCg0KIA0KIA0KDQogDQoNCiANCg0KDQoNCiAg44GE44Gk44KC5byK56S+
44Kr44O844OJ44KS44GU5Yip55So44GE44Gf44Gg44GN44GC44KK44GM44Go44GG44GU44GW44GE
44G+44GZ44CCDQoNCiAgVnBhc3Pjga7nmbvpjLLmg4XloLHjga9WcGFzc+OBuOOBruODreOCsOOC
pOODs+OBruOBv+OBquOCieOBmuOAgeOCpOODs+OCv+ODvOODjeODg+ODiOOCt+ODp+ODg+ODlOOD
s+OCsOOBrumam+OBq+OAgeOBlOacrOS6uuOCkueiuuiqjeOBmeOCi+mHjeimgeOBquaDheWgseOB
p+OBmeOBruOBp+OAgeWumuacn+eahOOBquOBlOWkieabtOOCkuOBiumhmOOBhOOBhOOBn+OBl+OB
vuOBmeOAgg0KDQrnj77lnKjjg63jgrDjgqTjg7PjgZXjgozjgabjgYTjgosNClZwYXNz44OR44K5
44Ov44O844OJ5pyA57WC5aSJ5pu05pelMjAyMOW5tDjmnIg15pelDQoNCg0KDQogDQrmrKHjgbjp
gLLjgoANCg0KDQrjgYrpm7voqbHjgafjga7jgYrmiYvntprjgY0NCue0m+Wkseebl+mbo+ODh+OC
ueOCr+OAgDAxMjAtOTE5LTQ1NuOAgO+8iOWPl+S7mOaZgumWk++8jzI05pmC6ZaT44O75bm05Lit
54Sh5LyR77yJDQoNCg0KDQrkuInkupXkvY/lj4vjgqvjg7zjg4nmoKrlvI/kvJrnpL4NCuOAkjEw
NS04MDExIOadseS6rOmDvea4r+WMuua1t+WyuDHkuIHnm64y55WqMjDlj7cg5rGQ55WZ44OT44Or
44OH44Kj44Oz44KwDQoNCg0KDQogDQpDb3B5cmlnaHQgKEMpIDIwMjEgU3VtaXRvbW8gTWl0c3Vp
IENhcmQgQ28uLCBMdGQuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxpc3RzLjAx
Lm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1sZWF2ZUBs
aXN0cy4wMS5vcmcK
