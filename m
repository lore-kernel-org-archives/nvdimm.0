Return-Path: <SRS0=drqr=CK=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.6 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E9EC433E6
	for <linux-nvdimm@archiver.kernel.org>; Tue,  1 Sep 2020 22:28:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CB9372078B
	for <linux-nvdimm@archiver.kernel.org>; Tue,  1 Sep 2020 22:28:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB9372078B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ninus.ocn.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8C52713A38C01;
	Tue,  1 Sep 2020 15:28:44 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=160.251.2.226; helo=qwo.mobi; envelope-from=mpqov@qwo.mobi; receiver=<UNKNOWN> 
Received: from qwo.mobi (v160-251-2-226.mwqa.static.cnode.io [160.251.2.226])
	by ml01.01.org (Postfix) with ESMTP id B7F4013A37EBC
	for <linux-nvdimm@lists.01.org>; Tue,  1 Sep 2020 15:28:41 -0700 (PDT)
From: =?utf-8?B?W+alveWkqeW4guWgtOe3iuaApeOBiuefpeOCieOBm10=?= <irie-k@ninus.ocn.ne.jp>
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5qW95aSp57eK5oCl44GK55+l44KJ44Gb44CR?=
Date: Wed, 2 Sep 2020 07:28:36 +0900
Message-ID: <00d0a7fd0e09$672d335b$8ba4a722$@qwo.mobi>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Message-ID-Hash: YQ6GUYYPWPRA37PVWFC4XTAK76KKFASD
X-Message-ID-Hash: YQ6GUYYPWPRA37PVWFC4XTAK76KKFASD
X-MailFrom: mpqov@qwo.mobi
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YQ6GUYYPWPRA37PVWFC4XTAK76KKFASD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQoNCg0KDQoNCuacrOODoeODvOODq+OBr+OBiuWuouanmOOBq+OCiOOCi+OBiuaUr+aJleOBhOaW
ueazleOBruOBlOeiuuiqjeOBjOW/heimgeOBquWgtOWQiOOBq+OBiuefpeOCieOBm+OBmeOCi+OA
geiHquWLlemFjeS/oeODoeODvOODq+OBp+OBmeOAgg0KDQrlrqLmp5gNCg0KICAgICAgICDjgZPj
ga7luqbjga/mpb3lpKnluILloLTlhoXjga7jgrfjg6fjg4Pjg5fjgIxaRVJPQe+8iOOCvOODreOC
ou+8iealveWkqeW4guWgtOW6l+OAjeOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBjeOBvuOBl+OBpuOA
geiqoOOBq+OBguOCiuOBjOOBqOOBhuOBlOOBluOBhOOBvuOBmeOAgg0KICAgICAgICDjgYrlrqLm
p5jjga7jgqLjgqvjgqbjg7Pjg4jjgafnlbDluLjjgarooYzngrrjgYzmpJzlh7rjgZXjgozjgZ/j
gZ/jgoHjgIHjgYrlrqLmp5jjga7ms6jmlofjgaggUmFrdXRlbiDjgqLjgqvjgqbjg7Pjg4jjgpLl
gZzmraLjgZXjgZvjgabjgYTjgZ/jgaDjgYTjgabjgYrjgorjgb7jgZnjgILjgqLjgqvjgqbjg7Pj
g4jjgavjg63jgrDjgqTjg7PjgZfjgabnlLvpnaLjga7mjIfnpLrjgavlvpPjgYbjgZPjgajjgafj
gIHjgqLjgqvjgqbjg7Pjg4jjga7lgZzmraLnirbmhYvjgpLop6PpmaTjgZfjgabjgYTjgZ/jgaDj
gZHjgb7jgZnjgIINCiAgICAgICAg5oGQ44KM5YWl44KK44G+44GZ44GM44CB5Lul5LiL44Gu5oOF
5aCx44KS44GU56K66KqN44Gu44GG44GI44CB44GK5pSv5omV44GE5pa55rOV44Gu5aSJ5pu044CC
DQoNCiANCg0KICAgICAgICAgICAgIFvms6jmlofnlarlj7ddIDI2MzEyNi0yMDIwMDkwMi0wMDkN
CiAgICAgICAgICAgICBb5bqX6IiX5Y+X5LuY5pel5pmCXSAyMDIwLzA5LzAyIDM0MjoxNSANCiAg
ICAgICAgICAgICBb44GK5pSv5omV44GE5pa55rOVXSDjgq/jg6zjgrjjg4Pjg4jjgqvjg7zjg4nm
sbrmuIgg5LiA5ous5omV44GEDQoNCiAgICAgICAgICAgICDigLvjgq/jg6zjgrjjg4Pjg4jjgqvj
g7zjg4nnlarlj7fjg7vmnInlirnmnJ/pmZDjga7lhaXlipvjgavplpPpgZXjgYTjgYzjgarjgYTj
gYvjgZTnorroqo3jgY/jgaDjgZXjgYTjgIINCiAgICAgICAgICAgICDjgq/jg6zjgrjjg4Pjg4jj
gqvjg7zjg4njgYzliKnnlKjjgYTjgZ/jgaDjgZHjgarjgYTnkIbnlLHjgavjgaTjgYTjgabjga/j
gIHjgZTliKnnlKjjga7jgq/jg6zjgrjjg4Pjg4jjgqvjg7zjg4nkvJrnpL7jgb7jgafjgYrllY/l
kIjjgZvjgY/jgaDjgZXjgYTjgIINCualveWkqeODreOCsOOCpOODsyDvvJ4NCg0KDQoNCg0KDQoN
Cg0K5byK56S+44GL44KJ44Gu44Oh44O844Or44KS5biM5pyb44GV44KM44Gq44GE5Lya5ZOh5qeY
44G444KC6YeN6KaB44Gq44GK55+l44KJ44Gb44Go44GX44Gm44GK6YCB44KK44GX44Gm44GK44KK
44G+44GZ44CCDQrmnKzjg6Hjg7zjg6vjgqLjg4njg6zjgrnjga/pgIHkv6HlsILnlKjjgajjgarj
gorjgIHov5Tkv6Hjga/jgYrlj5fjgZHjgZfjgabjgYrjgorjgb7jgZvjgpPjgILjg6Hjg7zjg6vj
gqLjg4njg6zjgrnjga7lpInmm7Tjga/jgIHmpb3lpKllLU5BVknjgojjgorjgYrmiYvntprjgY3j
gY/jgaDjgZXjgYTjgIINCg0K55m66KGM5YWD77ya5qW95aSp44Kr44O844OJ5qCq5byP5Lya56S+
DQoNCiAgICDmpb3lpKnjgqvjg7zjg4njgqLjg5fjg6oNCg0KDQoNCiAgICDjgqLjg5fjg6rjgafj
ga/jgqvjg7Pjgr/jg7PmmI7ntLDnorroqo0NCg0KDQogICAg5oyH57SL6KqN6Ki844Gn44Op44Kv
44Op44Kv44Ot44Kw44Kk44OzDQoNCg0KICAgIOaJi+i7veOBquaTjeS9nOOBp+OCteOCr+OCteOC
r+OBlOWIqeeUqA0KDQoNCg0KDQogICAgDQoNCg0KIA0KDQoNCiANCg0KDQoNCg0KDQoNCg0KDQog
DQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJz
Y3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
