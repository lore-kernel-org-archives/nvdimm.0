Return-Path: <SRS0=d9u0=CZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509DEC43461
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Sep 2020 00:27:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD5BD206DB
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Sep 2020 00:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD5BD206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=rakuten.co.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7E552142B0F2C;
	Tue, 15 Sep 2020 17:26:59 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=118.27.2.65; helo=wf69i.cn; envelope-from=mail@wf69i.cn; receiver=<UNKNOWN> 
Received: from wf69i.cn (v118-27-2-65.1xts.static.cnode.io [118.27.2.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EB1A3142B0F26
	for <linux-nvdimm@lists.01.org>; Tue, 15 Sep 2020 17:26:52 -0700 (PDT)
Received: from rplms (unknown [112.121.165.186])
	by wf69i.cn (Postfix) with ESMTPA id 849A01A96A3
	for <linux-nvdimm@lists.01.org>; Wed, 16 Sep 2020 08:13:27 +0800 (CST)
DKIM-Filter: OpenDKIM Filter v2.11.0 wf69i.cn 849A01A96A3
From: Rakuten-update@rakuten.co.jp <Rakuten-update@rakuten.co.jp>
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44GC44Gq44Gf44Gu44Ki44Kr44Km44Oz44OI44KS5pu05paw44Gn44GN44G+44Gb44KT44Gn44GX44Gf?=
	=?utf-8?B?44CC44GT44KM44Gv44CB44Kr44O844OJ44GM5pyf6ZmQ5YiH44KM44Gr44Gq44Gj44Gf44GL44CC?=
Date: Wed, 16 Sep 2020 08:13:13 +0800
Message-ID: <006d739ae6e7$782ff11a$a483e11c$@rplms>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Message-ID-Hash: 3NP65HCK6ECDDPYD6R7VQYNSSDBHUX7U
X-Message-ID-Hash: 3NP65HCK6ECDDPYD6R7VQYNSSDBHUX7U
X-MailFrom: mail@wf69i.cn
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3NP65HCK6ECDDPYD6R7VQYNSSDBHUX7U/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

5qW95aSp5a6J5YWo44K744Oz44K/44O8ICANCg0KDQoNCg0KDQoNClJha3V0ZW7jgYrlrqLmp5gg
DQoNCuaui+W/teOBquOBjOOCieOAgeOBguOBquOBn+OBruOCouOCq+OCpuODs+ODiOOCkuabtOaW
sOOBp+OBjeOBvuOBm+OCk+OBp+OBl+OBn+OAguOBk+OCjOOBr+OAgeOCq+ODvOODieOBjOacn+mZ
kOWIh+OCjOOBq+OBquOBo+OBn+OBi+OAgg0K6KuL5rGC5YWI5L2P5omA44GM5aSJ5pu044GV44KM
44Gf44Gq44Gp44CB44GV44G+44GW44G+44Gq55CG55Sx44Gn55m655Sf44GZ44KL5Y+v6IO95oCn
44GM44GC44KK44G+44GZ44CCIA0KDQoNCg0K5LuK44Ki44Kr44Km44Oz44OI44KS56K66KqN44Gn
44GN44G+44GZ44CCIA0KDQoNCualveWkqeODreOCsOOCpOODsw0KDQoNCg0KDQrjgarjgYrjgIEy
NOaZgumWk+S7peWGheOBq+OBlOeiuuiqjeOBjOOBquOBhOWgtOWQiOOAgeiqoOOBq+mBuuaGvuOB
quOBjOOCieOAgeOCouOCq+OCpuODs+ODiOOCkuODreODg+OCr+OBleOBm+OBpuOBhOOBn+OBoOOB
j+OBk+OBqOOCkuitpuWRiuOBhOOBn+OBl+OBvuOBmeOAgiANCg0K44OR44K544Ov44O844OJ44KS
5aSJ5pu044GX44Gf6Kaa44GI44GM44Gq44GE5aC05ZCI44Gv44CB6Iez5oCl77yIMDEpLTUwLTU4
MzAtNjg2MOOBvuOBp+OBiumbu+ipseOBj+OBoOOBleOBhOOAgiANCg0KDQoNCuOBiuefpeOCieOB
mzogDQroq4vmsYLlhYjkvY/miYDjgYzlpInmm7TjgZXjgozjgZ/jgarjganjgIHjgZXjgb7jgZbj
gb7jgarnkIbnlLHjgafnmbrnlJ/jgZnjgovlj6/og73mgKfjgYzjgYLjgorjgb7jgZnjgIIgDQoN
Cg0KDQrku4rjgqLjgqvjgqbjg7Pjg4jjgpLnorroqo3jgafjgY3jgb7jgZnjgIIgDQoNCg0K5qW9
5aSp44Ot44Kw44Kk44OzDQoNCg0KDQoNCuOBquOBiuOAgTI05pmC6ZaT5Lul5YaF44Gr44GU56K6
6KqN44GM44Gq44GE5aC05ZCI44CB6Kqg44Gr6YG65oa+44Gq44GM44KJ44CB44Ki44Kr44Km44Oz
44OI44KS44Ot44OD44Kv44GV44Gb44Gm44GE44Gf44Gg44GP44GT44Go44KS6K2m5ZGK44GE44Gf
44GX44G+44GZ44CCIA0KDQrjg5Hjgrnjg6/jg7zjg4njgpLlpInmm7TjgZfjgZ/opprjgYjjgYzj
garjgYTloLTlkIjjga/jgIHoh7PmgKXvvIgwMSktNTAtNTgzMC02ODYw44G+44Gn44GK6Zu76Kmx
44GP44Gg44GV44GE44CCIA0KDQrjgYrnn6XjgonjgZs6IA0KDQrCtyDjg5Hjgrnjg6/jg7zjg4nj
ga/oqrDjgavjgoLmlZnjgYjjgarjgYTjgafjgY/jgaDjgZXjgYTjgIIgDQoNCsK3IOWAi+S6uuaD
heWgseOBqOmWouS/guOBjOOBquOBj+OAgeaOqOa4rOOBl+OBq+OBj+OBhOODkeOCueODr+ODvOOD
ieOCkuS9nOaIkOOBl+OBpuOBj+OBoOOBleOBhOOAguWkp+aWh+Wtl+OBqOWwj+aWh+Wtl+OAgeaV
sOWtl+OAgeOBiuOCiOOBs+iomOWPt+OCkuW/heOBmuS9v+eUqOOBl+OBpuOBj+OBoOOBleOBhOOA
giANCg0Kwrcg44Kq44Oz44Op44Kk44Oz44Ki44Kr44Km44Oz44OI44GU44Go44Gr44CB55Ww44Gq
44KL44OR44K544Ov44O844OJ44KS5L2/55So44GX44Gm44GP44Gg44GV44GE44CCIA0KDQoNCg0K
44Gp44GG44Ge44KI44KN44GX44GP44GK6aGY44GE44GE44Gf44GX44G+44GZ44CCIA0KUmFrdXRl
bu+8jEluYy4gDQoNCg0KDQoNCg0KDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1t
QGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGlt
bS1sZWF2ZUBsaXN0cy4wMS5vcmcK
