Return-Path: <SRS0=37L1=HY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E0DC433DB
	for <linux-nvdimm@archiver.kernel.org>; Mon, 22 Feb 2021 11:30:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 56B7E64EC3
	for <linux-nvdimm@archiver.kernel.org>; Mon, 22 Feb 2021 11:30:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56B7E64EC3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vpass.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id DA5BE100EBB90;
	Mon, 22 Feb 2021 03:30:58 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=160.251.38.71; helo=vpass.ne.jp; envelope-from=zatg@vpass.ne.jp; receiver=<UNKNOWN> 
Received: from vpass.ne.jp (v160-251-38-71.bzpp.static.cnode.io [160.251.38.71])
	by ml01.01.org (Postfix) with ESMTP id 1E538100EBB72
	for <linux-nvdimm@lists.01.org>; Mon, 22 Feb 2021 03:30:55 -0800 (PST)
Message-ID: <5ADA7258A0FFEA5CA352A0ED2FB81815@vpass.ne.jp>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L44Kr44O844OJ?= <update@vpass.ne.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?VnBhc3PnmbvpjLLmg4XloLHjgYzmraPjgZfjgY/jgYLjgorjgb7jgZvjgpM=?=
Date: Mon, 22 Feb 2021 20:30:43 +0900
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V10.0.14393.2007
Message-ID-Hash: FKV3EXG4HP4RHJOAH4R32EIUYQDQGGSC
X-Message-ID-Hash: FKV3EXG4HP4RHJOAH4R32EIUYQDQGGSC
X-MailFrom: zatg@vpass.ne.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/FKV3EXG4HP4RHJOAH4R32EIUYQDQGGSC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

IA0KDQogDQogDQoNCiANCg0KIA0KIA0KDQogDQoNCiANCg0KDQoNCuOBhOOBpOOCguW8iuekvuOC
q+ODvOODieOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBjeOBguOCiuOBjOOBqOOBhuOBlOOBluOBhOOB
vuOBmeOAgg0KDQogIOOBiuWuouanmOOBruOAjFZwYXNz44CN55m76Yyy5oOF5aCx44GM5q2j44GX
44GP44GC44KK44G+44Gb44KT44CC44GT44Gu44Oh44O844Or44Gn44Gv44CB44CMVnBhc3PjgI3j
gavjgZTnmbvpjLLjga7mg4XloLHjga7lpInmm7Tlj5fku5jjgpLoqLHlj6/jgZfjgZ/jgZPjgajj
gpLjgYrnn6XjgonjgZvjgZfjgabjgYrjgorjgb7jgZnjgIINCg0KIA0K4pSB4pSB4pSB4pSB4pSB
4pSB4pSBDQrihpLjgZTlpInmm7Tjga/jgZPjgaHjgonjgYvjgokNCuKUgeKUgeKUgeKUgeKUgeKU
geKUgQ0KDQoNCuKWoOKWoeKWoOS4ieS6leS9j+WPi+OCq+ODvOODieOBi+OCieOBruOBiuefpeOC
ieOBm+KWoOKWoeKWoA0KDQrilrzjgqvjg7zjg4njgZTliKnnlKjjga7pmpvjgIHmmpfoqLznlarl
j7fjgYzlv4XopoHjgarloLTlkIjjgYzjgZTjgZbjgYTjgb7jgZnjgIINCuaal+iovOeVquWPt+OC
kuOBlOWtmOOBmOOBp+OBquOBhOWgtOWQiOOBr+OAgeW8iuekvuODm+ODvOODoOODmuODvOOCuOOB
i+OCieewoeWNmOOBq+eFp+S8muOBiuaJi+e2muOBjeOBhOOBn+OBoOOBkeOBvuOBmeOAgg0K44Gc
44Gy44CB44GK5pep44KB44Gr44GU56K66KqN44GP44Gg44GV44GE44CCDQoNCg0K5LiJ5LqV5L2P
5Y+L44Kr44O844OJ5qCq5byP5Lya56S+DQrjgJIxMDUtODAxMSDmnbHkuqzpg73muK/ljLrmtbfl
srgx5LiB55uuMueVqjIw5Y+3IOaxkOeVmeODk+ODq+ODh+OCo+ODs+OCsA0KDQoNCg0KIA0KQ29w
eXJpZ2h0IChDKSAyMDIxIFN1bWl0b21vIE1pdHN1aSBDYXJkIENvLiwgTHRkLgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGlu
ZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBh
biBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
