Return-Path: <SRS0=Fq/z=BS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.6 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C96BC433DF
	for <linux-nvdimm@archiver.kernel.org>; Sat,  8 Aug 2020 00:44:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DFAE2177B
	for <linux-nvdimm@archiver.kernel.org>; Sat,  8 Aug 2020 00:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DFAE2177B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=rakuten.co.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0316012CC8FE2;
	Fri,  7 Aug 2020 17:44:23 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=150.95.221.196; helo=rakuten.co.jp; envelope-from=account-update@rakuten.co.jp; receiver=<UNKNOWN> 
Received: from rakuten.co.jp (v150-95-221-196.ydvw.static.cnode.io [150.95.221.196])
	by ml01.01.org (Postfix) with ESMTP id B341912CC8FDF
	for <linux-nvdimm@lists.01.org>; Fri,  7 Aug 2020 17:44:19 -0700 (PDT)
Received: from oio (unknown [171.99.243.195])
	by rakuten.co.jp with SMTP id 50jkhfDXVczNKg8J.1
	for <linux-nvdimm@lists.01.org>; Sat, 08 Aug 2020 09:44:19 +0900
Sender: account-update@rakuten.co.jp
Message-ID: <202008080944194647282@rakuten.co.jp>
From: "Rakuten" <account-update@rakuten.co.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?5qW95aSp5a6J5YWo55Ww5bi4?=
Date: Sat, 8 Aug 2020 09:44:07 +0900
Mime-Version: 1.0
X-Priority: 3
X-Mailer: Rsn 0
Message-ID-Hash: 5S4O7PIB4IDU24VUT2ECPV6TU4M4ZR3R
X-Message-ID-Hash: 5S4O7PIB4IDU24VUT2ECPV6TU4M4ZR3R
X-MailFrom: account-update@rakuten.co.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5S4O7PIB4IDU24VUT2ECPV6TU4M4ZR3R/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

ICANCiAgDQogIFJha3V0ZW7jgYrlrqLmp5ggDQrmrovlv7XjgarjgYzjgonjgIHjgYLjgarjgZ/j
ga7jgqLjgqvjgqbjg7Pjg4gg44KS5pu05paw44Gn44GN44G+44Gb44KT44Gn44GX44Gf44CC44GT
44KM44Gv44CB44Kr44O844OJ44GM5pyf6ZmQ5YiH44KM44Gr44Gq44Gj44Gf44GL44CCDQroq4vm
sYLlhYjkvY/miYDjgYzlpInmm7TjgZXjgozjgZ/jgarjganjgIHjgZXjgb7jgZbjgb7jgarnkIbn
lLHjgafnmbrnlJ/jgZnjgovlj6/og73mgKfjgYzjgYLjgorjgb7jgZnjgIINCg0K5LuK44Ki44Kr
44Km44Oz44OI44KS56K66KqN44Gn44GN44G+44GZ44CCDQoNCualveWkqeODreOCsOOCpOODsw0K
44Gq44GK44CBMjTmmYLplpPku6XlhoXjgavjgZTnorroqo3jgYzjgarjgYTloLTlkIjjgIHoqqDj
gavpgbrmhr7jgarjgYzjgonjgIHjgqLjgqvjgqbjg7Pjg4jjgpLjg63jg4Pjgq/jgZXjgZvjgabj
gYTjgZ/jgaDjgY/jgZPjgajjgpLorablkYrjgYTjgZ/jgZfjgb7jgZnjgIIgDQrjg5Hjgrnjg6/j
g7zjg4njgpLlpInmm7TjgZfjgZ/opprjgYjjgYzjgarjgYTloLTlkIjjga/jgIHoh7PmgKXvvIgw
MSktNTAtNTgzMC02ODYw44G+44Gn44GK6Zu76Kmx44GP44Gg44GV44GE44CCIA0KICANCuOBiuef
peOCieOBmzoNCsK3IOODkeOCueODr+ODvOODieOBr+iqsOOBq+OCguaVmeOBiOOBquOBhOOBp+OB
j+OBoOOBleOBhOOAgiANCsK3IOWAi+S6uuaDheWgseOBqOmWouS/guOBjOOBquOBj+OAgeaOqOa4
rOOBl+OBq+OBj+OBhOODkeOCueODr+ODvOODieOCkuS9nOaIkOOBl+OBpuOBj+OBoOOBleOBhOOA
guWkp+aWh+Wtl+OBqOWwj+aWh+Wtl+OAgeaVsOWtl+OAgeOBiuOCiOOBs+iomOWPt+OCkuW/heOB
muS9v+eUqOOBl+OBpuOBj+OBoOOBleOBhOOAgiANCsK3IOOCquODs+ODqeOCpOODs+OCouOCq+OC
puODs+ODiOOBlOOBqOOBq+OAgeeVsOOBquOCi+ODkeOCueODr+ODvOODieOCkuS9v+eUqOOBl+OB
puOBj+OBoOOBleOBhOOAgiANCg0KDQrjganjgYbjgZ7jgojjgo3jgZfjgY/jgYrpoZjjgYTjgYTj
gZ/jgZfjgb7jgZnjgIIgDQpSYWt1dGVu77yMSW5jLg0KDQogIA0KDQogIApfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBs
aXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBl
bWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
