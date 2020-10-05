Return-Path: <SRS0=jgyp=DM=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.8 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C04C35257
	for <linux-nvdimm@archiver.kernel.org>; Mon,  5 Oct 2020 03:29:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1BB0F207C4
	for <linux-nvdimm@archiver.kernel.org>; Mon,  5 Oct 2020 03:29:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BB0F207C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=rakuten.co.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 690E7154E40E3;
	Sun,  4 Oct 2020 20:29:17 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=118.27.72.97; helo=rakuten.co.jp; envelope-from=hh@rakuten.co.jp; receiver=<UNKNOWN> 
Received: from rakuten.co.jp (v118-27-72-97.thcj.static.cnode.io [118.27.72.97])
	by ml01.01.org (Postfix) with ESMTP id 43CF2154E40E1
	for <linux-nvdimm@lists.01.org>; Sun,  4 Oct 2020 20:29:13 -0700 (PDT)
Message-ID: <A37D15EE7E71E5F73C7E94D804CE3DBA@rakuten.co.jp>
From: =?utf-8?B?5qW95aSp5biC5aC0?= <info@rakuten.co.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5qW95aSp5biC5aC044CR44GU5rOo5paH44GM44Kt44Oj44Oz44K744Or44Gr44Gq44KK44G+44GX?=
	=?utf-8?B?44GfICAyMDIwLzEwLzA1IDEyOjI5Og==?=
	=?utf-8?B?MTM=?=
Date: Mon, 5 Oct 2020 12:29:09 +0900
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V10.0.14393.2007
Message-ID-Hash: J2JJ3FYX7F4CXZQ25Z4VKVZUAA73GJRA
X-Message-ID-Hash: J2JJ3FYX7F4CXZQ25Z4VKVZUAA73GJRA
X-MailFrom: hh@rakuten.co.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/J2JJ3FYX7F4CXZQ25Z4VKVZUAA73GJRA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

IA0KDQoNCg0K5pys44Oh44O844Or44Gv44GK5a6i5qeY44GU5rOo5paH44GM44Kt44Oj44Oz44K7
44Or44Gr44Gq44KK44G+44GX44Gf44Gq5aC05ZCI44Gr44GK55+l44KJ44Gb44GZ44KLDQpsaW51
eC1udmRpbW3mp5gNCiAg44GT44Gu5bqm44CBIEJUT+ODkeOCveOCs+ODs+WwgumWgOW6l+OBrlBD
LU1BWCDjgafjga7jgZTms6jmlofjgYzjgq3jg6Pjg7Pjgrvjg6vjgajjgarjgorjgb7jgZfjgZ/j
gIINCiAg44Kt44Oj44Oz44K744Or44Gu55CG55Sx44Gq44Gp44Gr6Zai44GZ44KL44GK5ZWP44GE
5ZCI44Gb44Gv44CB5LiL6KiY44GuVVJM44KS44Kv44Oq44OD44Kv44GX44Gm44GP44Gg44GV44GE
44CCDQrmpb3lpKnjg63jgrDjgqTjg7MgDQoNCg0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQpb5rOo5paHSURdIDY3NTE2NC0yMDIwMTAwNS03NTANClvos7zlhaXml6XmmYJdIDIwMjAvMTAv
MDUgMTI6Mjk6MTMNClvos7zlhaXllYblk4FdIFNPTlkg44OH44K444K/44Or44Kr44Oh44OpIERT
Qy1SWDEwTTMgRjIuNC00LjAgMjQtNjAwbW0gMjAxMOS4h+eUu+e0oCDjg5bjg6njg4Pjgq8gQ3li
ZXItc2hvdCBEU0MtUlgxME0zDQpb44GK5pSv5omV44GE5pa55rOVXSDjgq/jg6zjgrjjg4Pjg4jj
gqvjg7zjg4nmsbrmuIgNClvlkIjoqIjph5HpoY1dOTUsODAw5YaGDQotLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQrjgZPjga7jg6Hjg7zjg6vjgavlv4PlvZPjgZ/jgorjgYzjgarjgYTloLTlkIjj
goTkuI3pg73lkIjnrYnnmbrnlJ/jgZfjgZ/loLTlkIjjga/ku6XkuIvjga7jg6Hjg7zjg6vjgqLj
g4njg6zjgrnlrpvjgavjgZTmhI/opovjgYrlr4TjgZvjgY/jgaDjgZXjgYTjgIINCnN1cHBvcnRA
cmFrdXRlbi5jby5qcA0K5LiL6KiY6YCj57Wh5YWI44G+44Gn44GK6Zu76Kmx44Gn44GU6YCj57Wh
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
