Return-Path: <SRS0=iqJD=EP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3307C5517A
	for <linux-nvdimm@archiver.kernel.org>; Mon,  9 Nov 2020 07:03:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DE76B206C0
	for <linux-nvdimm@archiver.kernel.org>; Mon,  9 Nov 2020 07:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE76B206C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ml01.01.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2F9601656765D;
	Sun,  8 Nov 2020 23:03:57 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=185.14.29.128; helo=vpass.ne.jp; envelope-from=dxn@vpass.ne.jp; receiver=<UNKNOWN> 
Received: from vpass.ne.jp (unknown [185.14.29.128])
	by ml01.01.org (Postfix) with ESMTP id 8AFD815B019A8
	for <linux-nvdimm@lists.01.org>; Sun,  8 Nov 2020 23:03:54 -0800 (PST)
Sender: dxn@vpass.ne.jp
Message-ID: <278FA34A8F425AE2D28AB5710B2CDC4B@vpass.ne.jp>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L44Kr44O844OJ?= <vpass.ne.jp@ml01.01.org>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?77yc6YeN6KaB77ye44CQ5LiJ5LqV5L2P5Y+L44Kr44O844OJ44CR44GU5Yip55So56K66KqN44Gu44GK?=
	=?utf-8?B?6aGY44GE?=
Date: Sun, 8 Nov 2020 23:03:42 -0800
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.3.9600.16384
Message-ID-Hash: KUSIUARMS4ZGRCXTHDF7LLPS2UADBMDD
X-Message-ID-Hash: KUSIUARMS4ZGRCXTHDF7LLPS2UADBMDD
X-MailFrom: dxn@vpass.ne.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KUSIUARMS4ZGRCXTHDF7LLPS2UADBMDD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQoNCuOBhOOBpOOCguW8iuekvuOCq+ODvOODieOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBjeOBguOC
iuOBjOOBqOOBhuOBlOOBluOBhOOBvuOBmeOAgg0KDQrmmKjku4rjga7nrKzkuInogIXkuI3mraPl
iKnnlKjjga7mgKXlopfjgavkvLTjgYTjgIHlvIrnpL7jgafjga/jgIzkuI3mraPliKnnlKjnm6Po
ppbjgrfjgrnjg4bjg6DjgI3jgpLlsI7lhaXjgZfjgIEyNOaZgumWkzM2NeaXpeS9k+WItuOBp+OC
q+ODvOODieOBruOBlOWIqeeUqOOBq+WvvuOBmeOCi+ODouODi+OCv+ODquODs+OCsOOCkuihjOOB
o+OBpuOBiuOCiuOBvuOBmeOAgg0KDQrjgZPjga7jgZ/jgbPjgIHjgZTmnKzkurrmp5jjga7jgZTl
iKnnlKjjgYvjganjgYbjgYvjgpLnorroqo3jgZXjgZvjgabjgYTjgZ/jgaDjgY3jgZ/jgYTjgYrl
j5blvJXjgYzjgYLjgorjgb7jgZfjgZ/jga7jgafjgIHoqqDjgavli53miYvjgarjgYzjgonjgIHj
gqvjg7zjg4njga7jgZTliKnnlKjjgpLkuIDpg6jliLbpmZDjgZXjgZvjgabjgYTjgZ/jgaDjgY3j
gIHjgZTpgKPntaHjgZXjgZvjgabjgYTjgZ/jgaDjgY3jgb7jgZfjgZ/jgIINCg0K44Gk44GN44G+
44GX44Gm44Gv44CB5Lul5LiL44G444Ki44Kv44K744K544Gu5LiK44CB44Kr44O844OJ44Gu44GU
5Yip55So56K66KqN44Gr44GU5Y2U5Yqb44KS44GK6aGY44GE6Ie044GX44G+44GZ44CCDQrjgZTl
m57nrZTjgpLjgYTjgZ/jgaDjgZHjgarjgYTloLTlkIjjgIHjgqvjg7zjg4njga7jgZTliKnnlKjl
iLbpmZDjgYzntpnntprjgZXjgozjgovjgZPjgajjgoLjgZTjgZbjgYTjgb7jgZnjga7jgafjgIHk
uojjgoHjgZTkuobmib/kuIvjgZXjgYTjgIINCg0K4pag44GU5Yip55So56K66KqN44Gv44GT44Gh
44KJDQoNCuOAgGh0dHA6Ly9zbWNjLWNhY2MubWFjYy54eXovDQoNCuKWoOeZuuihjOiAheKWoA0K
5LiJ5LqV5L2P5Y+L44Kr44O844OJ5qCq5byP5Lya56S+DQrjgIBodHRwOi8vc21jYy1jYWNjLm1h
Y2MueHl6Lw0K44CSMTA1LTgwMTEg5p2x5Lqs6YO95riv5Yy65rW35bK4MeS4geebrjLnlaoyMOWP
tyDmsZDnlZnjg5Pjg6vjg4fjgqPjg7PjgrANCg0KDQouLi4KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBs
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8g
bGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
