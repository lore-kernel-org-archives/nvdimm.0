Return-Path: <SRS0=BuUN=DS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCACDC433E7
	for <linux-nvdimm@archiver.kernel.org>; Sun, 11 Oct 2020 21:44:47 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 546EA20791
	for <linux-nvdimm@archiver.kernel.org>; Sun, 11 Oct 2020 21:44:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 546EA20791
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=rakuten.co.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C0A281587B93E;
	Sun, 11 Oct 2020 14:44:46 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=150.95.222.121; helo=rakuten.co.jp; envelope-from=xfmegnwreb@rakuten.co.jp; receiver=<UNKNOWN> 
Received: from rakuten.co.jp (v150-95-222-121.15j2.static.cnode.io [150.95.222.121])
	by ml01.01.org (Postfix) with ESMTP id 4E3251587B93A
	for <linux-nvdimm@lists.01.org>; Sun, 11 Oct 2020 14:44:43 -0700 (PDT)
Message-ID: <6EAC880766F2B131432303842FC8763D@rakuten.co.jp>
From: =?utf-8?B?5qW95aSp5biC5aC0?= <order@rakuten.co.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5qW95aSp5biC5aC044CR5pSv5omV5oOF5aCx5LiA6Ie044GX44Gm44GE44G+44Gb44KTICA=?=
	=?utf-8?B?MjAyMC8xMC8xMiA2OjQ0OjQz?=
Date: Mon, 12 Oct 2020 06:44:34 +0900
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V10.0.14393.2007
Message-ID-Hash: PZANYCVS5EDVTA3AI5IIX527GBFY7XBQ
X-Message-ID-Hash: PZANYCVS5EDVTA3AI5IIX527GBFY7XBQ
X-MailFrom: xfmegnwreb@rakuten.co.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PZANYCVS5EDVTA3AI5IIX527GBFY7XBQ/>
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
NjY5Mzk1LTIwMjAxMDEyLTg5Mw0KW+W6l+iIl+WPl+S7mOaXpeaZgl0gMjAyMC8xMC8xMiA2OjQ0
OjQzDQpb44GK5pSv5omV44GE5pa55rOVXSDjgq/jg6zjgrjjg4Pjg4jjgqvjg7zjg4nmsbrmuIgN
CualveWkqeODreOCsOOCpOODsyDvvJ4NCg0KDQoNCg0KDQrigLvjgq/jg6zjgrjjg4Pjg4jjgqvj
g7zjg4nnlarlj7fjg7vmnInlirnmnJ/pmZDjga7lhaXlipvjgavplpPpgZXjgYTjgYzjgarjgYTj
gYvjgZTnorroqo3jgY/jgaDjgZXjgYTjgIINCuKAu+OCr+ODrOOCuOODg+ODiOOCq+ODvOODieOB
jOWIqeeUqOOBhOOBn+OBoOOBkeOBquOBhOeQhueUseOBq+OBpOOBhOOBpuOBr+OAgeOBlOWIqeeU
qOOBruOCr+ODrOOCuOODg+ODiOOCq+ODvOODieS8muekvuOBvuOBp+OBiuWVj+WQiOOBm+OBj+OB
oOOBleOBhOOAgg0KDQrkuIvoqJjpgKPntaHlhYjjgb7jgafjgYrpm7voqbHjgafjgZTpgKPntaHj
gpLjgYTjgZ/jgaDjgY3jgb7jgZnjgojjgYbjgYrpoZjjgYTjgYTjgZ/jgZfjgb7jgZnjgIIgDQrv
vJzjgZTpgKPntaHlhYjvvJ4NCualveWkqeOCq+ODvOODieagquW8j+S8muekvg0K5L+h55So566h
55CG44Kw44Or44O844OX44CA44Oi44OL44K/44Oq44Oz44Kw44OB44O844OgIA0K6Zu76Kmx55Wq
5Y+3IO+8miAwOTAtMzAzNC0xMDAwIO+8iOWPl+S7mOaZgumWk++8muaXpeacrOaZgumWkzk6MDAg
LSAyMTowMO+8iQ0K4oC75rW35aSW44GL44KJ44Gu6YCj57Wh44Gu5aC05ZCIIO+8miANCjgx77yI
5Zu944Kz44O844OJ77yJLTA5MC0zMDM0LTExMDANCuKAu+a1t+WkluOBi+OCieOCs+ODrOOCr+OD
iOOCs+ODvOODq+OBp+OBrumAo+e1oeOBruWgtOWQiOOAgQ0K5rih6Iiq5YWI44Gn44Gu44Kz44Os
44Kv44OI44Kz44O844Or5Y+X5LuY6Zu76Kmx55Wq5Y+344Gr44GU6YCj57Wh44GE44Gf44Gg44GE
44Gf5b6MIO+8miANCjgx77yI5Zu944Kz44O844OJ77yJLTA5MC00NzQwLTMyNDANCualveWkqeag
quW8j+S8muekvuOAgOOAgA0KaHR0cHM6Ly93d3cucmFrdXRlbi5jby5qcC8NCg0KDQoNCueZuuih
jOWFg++8mualveWkqeOCq+ODvOODieagquW8j+S8muekvg0K44GT44GuReODoeODvOODq+OBr+as
oeOBruOCouODieODrOOCueWum+OBq+mAgeS/oeOBleOCjOOBvuOBl+OBnzpsaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxpc3RzLjAxLm9y
ZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1sZWF2ZUBsaXN0
cy4wMS5vcmcK
