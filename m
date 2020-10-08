Return-Path: <SRS0=isdP=DP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF60C4363D
	for <linux-nvdimm@archiver.kernel.org>; Thu,  8 Oct 2020 01:04:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E28DE20882
	for <linux-nvdimm@archiver.kernel.org>; Thu,  8 Oct 2020 01:04:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E28DE20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=rakuten.co.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3C36D159388C6;
	Wed,  7 Oct 2020 18:04:01 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=150.95.221.54; helo=rakuten.co.jp; envelope-from=jurzxuwwzj@rakuten.co.jp; receiver=<UNKNOWN> 
Received: from rakuten.co.jp (v150-95-221-54.ydvw.static.cnode.io [150.95.221.54])
	by ml01.01.org (Postfix) with ESMTP id 3E09A159388C4
	for <linux-nvdimm@lists.01.org>; Wed,  7 Oct 2020 18:03:57 -0700 (PDT)
Message-ID: <8B0F150DE225B49405A1EF77ED43C01C@rakuten.co.jp>
From: =?utf-8?B?5qW95aSp5biC5aC0?= <order@rakuten.co.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5qW95aSp5biC5aC044CR5rOo5paH5oOF5aCx5LiA6Ie044GX44Gm44GE44G+44Gb44KTICA=?=
	=?utf-8?B?MjAyMC8xMC8wOCAxMDowMzo1Nw==?=
Date: Thu, 8 Oct 2020 10:03:52 +0900
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V10.0.14393.2007
Message-ID-Hash: XX2CMSRVZ27U25DEQSZBTNE7R57QEJMR
X-Message-ID-Hash: XX2CMSRVZ27U25DEQSZBTNE7R57QEJMR
X-MailFrom: jurzxuwwzj@rakuten.co.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/XX2CMSRVZ27U25DEQSZBTNE7R57QEJMR/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQrmnKzjg6Hjg7zjg6vjga/jgYrlrqLmp5jjgavjgojjgovjgYrmpb3lpKnjgqLjgqvjgqbjg7Pj
g4jjga7jgZTmm7TmlrDjgYzlv4XopoHjgarloLTlkIjjgavjgYrnn6XjgonjgZvjgZnjgosNCmxp
bnV4LW52ZGltbeanmA0KICAg44GK5a6i5qeY44Gu5rOo5paH44Go5qW95aSp44Ki44Kr44Km44Oz
44OI44KS5YGc5q2i44GV44Gb44Gm44GE44Gf44Gg44GE44Gm44GK44KK44G+44GZ44CC6KuL5rGC
5YWI5L2P5omA44GM5aSJ5pu044GV44KM44Gf44Gq44Gp44CB55CG55Sx44Gn55m655Sf44GZ44KL
5Y+v6IO95oCn44GM44GC44KK44G+44GZ44CC44Ki44Kr44Km44Oz44OI44Gr44Ot44Kw44Kk44Oz
44GX44Gm55S76Z2i44Gu5oyH56S644Gr5b6T44GG44GT44Go44Gn44CB44Ki44Kr44Km44Oz44OI
44Gu5YGc5q2i54q25oWL44KS6Kej6Zmk44GX44Gm44GE44Gf44Gg44GR44G+44GZ44CCDQogIOS4
i+iomOOBq+OBguOCi+OCv+ODluOCkuOCr+ODquODg+OCr+OBl+OBpuOBhOOBn+OBoOOBjeOAgeaz
qOaWh+aDheWgseOCkuOBlOeiuuiqjeOBvuOBn+OBr+WkieabtOOAgg0KW+azqOaWh+eVquWPt10g
OTYxNTY1LTIwMjAxMDA4LTcwMg0KW+W6l+iIl+WPl+S7mOaXpeaZgl0gMjAyMC8xMC8wOCAxMDow
Mzo1Nw0KW+OBiuaUr+aJleOBhOaWueazlV0g44Kv44Os44K444OD44OI44Kr44O844OJ5rG65riI
DQrmpb3lpKnjg63jgrDjgqTjg7Mg77yeDQoNCg0KDQoNCg0K4oC744Kv44Os44K444OD44OI44Kr
44O844OJ55Wq5Y+344O75pyJ5Yq55pyf6ZmQ44Gu5YWl5Yqb44Gr6ZaT6YGV44GE44GM44Gq44GE
44GL44GU56K66KqN44GP44Gg44GV44GE44CCDQrigLvjgq/jg6zjgrjjg4Pjg4jjgqvjg7zjg4nj
gYzliKnnlKjjgYTjgZ/jgaDjgZHjgarjgYTnkIbnlLHjgavjgaTjgYTjgabjga/jgIHjgZTliKnn
lKjjga7jgq/jg6zjgrjjg4Pjg4jjgqvjg7zjg4nkvJrnpL7jgb7jgafjgYrllY/lkIjjgZvjgY/j
gaDjgZXjgYTjgIINCg0K5LiL6KiY6YCj57Wh5YWI44G+44Gn44GK6Zu76Kmx44Gn44GU6YCj57Wh
44KS44GE44Gf44Gg44GN44G+44GZ44KI44GG44GK6aGY44GE44GE44Gf44GX44G+44GZ44CCIA0K
77yc44GU6YCj57Wh5YWI77yeDQrmpb3lpKnjgqvjg7zjg4nmoKrlvI/kvJrnpL4NCuS/oeeUqOeu
oeeQhuOCsOODq+ODvOODl+OAgOODouODi+OCv+ODquODs+OCsOODgeODvOODoCANCumbu+ipseeV
quWPtyDvvJogMDkwLTMwMzQtMTAwMCDvvIjlj5fku5jmmYLplpPvvJrml6XmnKzmmYLplpM5OjAw
IC0gMjE6MDDvvIkNCuKAu+a1t+WkluOBi+OCieOBrumAo+e1oeOBruWgtOWQiCDvvJogDQo4Me+8
iOWbveOCs+ODvOODie+8iS0wOTAtMzAzNC0xMTAwDQrigLvmtbflpJbjgYvjgonjgrPjg6zjgq/j
g4jjgrPjg7zjg6vjgafjga7pgKPntaHjga7loLTlkIjjgIENCua4oeiIquWFiOOBp+OBruOCs+OD
rOOCr+ODiOOCs+ODvOODq+WPl+S7mOmbu+ipseeVquWPt+OBq+OBlOmAo+e1oeOBhOOBn+OBoOOB
hOOBn+W+jCDvvJogDQo4Me+8iOWbveOCs+ODvOODie+8iS0wOTAtNDc0MC0zMjQwDQrmpb3lpKnm
oKrlvI/kvJrnpL7jgIDjgIANCmh0dHBzOi8vd3d3LnJha3V0ZW4uY28uanAvDQoNCg0KDQrnmbro
oYzlhYPvvJrmpb3lpKnjgqvjg7zjg4nmoKrlvI/kvJrnpL4NCuOBk+OBrkXjg6Hjg7zjg6vjga/m
rKHjga7jgqLjg4njg6zjgrnlrpvjgavpgIHkv6HjgZXjgozjgb7jgZfjgZ86bGludXgtbnZkaW1t
QGxpc3RzLjAxLm9yZwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlz
dHMuMDEub3JnCg==
