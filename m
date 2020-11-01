Return-Path: <SRS0=guF4=EH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8900FC2D0A3
	for <linux-nvdimm@archiver.kernel.org>; Sun,  1 Nov 2020 22:41:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D6DCA2225B
	for <linux-nvdimm@archiver.kernel.org>; Sun,  1 Nov 2020 22:41:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6DCA2225B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vpass.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9615F16442DC5;
	Sun,  1 Nov 2020 14:41:28 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=165.84.180.109; helo=ertghvip.com; envelope-from=pyfpooe@ertghvip.com; receiver=<UNKNOWN> 
Received: from ertghvip.com (165084180109.ctinets.com [165.84.180.109])
	by ml01.01.org (Postfix) with ESMTP id 2BFF215F0E5D0
	for <linux-nvdimm@lists.01.org>; Sun,  1 Nov 2020 14:41:25 -0800 (PST)
Message-ID: <FAFB2252592626F62A1CAAD27A0A57F5@ertghvip.com>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L44Kr44O844OJ?= <thankyou@vpass.ne.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ6YeN6KaB44CR44OI44Op44Oz44K244Kv44K344On44Oz5L+d55WZ5Lit?=
Date: Mon, 2 Nov 2020 06:41:11 +0800
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.3.9600.19846
Message-ID-Hash: FG2KAPJTSDX54WSGKAVVFKEI4M55GO3H
X-Message-ID-Hash: FG2KAPJTSDX54WSGKAVVFKEI4M55GO3H
X-MailFrom: pyfpooe@ertghvip.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/FG2KAPJTSDX54WSGKAVVFKEI4M55GO3H/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

44GK5a6i5qeY5ZCE5L2NDQrmnIDlvozjga7kuovli5njgavllY/poYzjgYzjgYLjgorjgb7jgZfj
gZ/jgonjgIHkuIvoqJjjga7jg6rjg7Pjgq/jgpLjgq/jg6rjg4Pjgq/jgZfjgabjgIHov5Tph5Ho
oajjgpLoqJjlhaXjgZfjgabjgY/jgaDjgZXjgYTjgIINCuaUr+aJleOBhOOBruW9ouW8jw0K4pSB
4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSBDQrlubPntKDjga/lvIrn
pL7jgqvjg7zjg4njgarjgonjgbPjgavjgqTjg7Pjgr/jg7zjg43jg4Pjg4jjgrXjg7zjg5Pjgrnj
gIxWcGFzc+OAjeOCkuOBlOaEm+eUqOOBhOOBn+OBoOOBjeOAgeWOmuOBj+W+oeekvOeUs+OBl+S4
iuOBkuOBvuOBmeOAgg0K44GT44Gu5bqm44CB44CMVnBhc3PjgI3jgavjgabkuIvoqJjjgYrmiYvn
tprjgY3jgYzlrozkuobjgYTjgZ/jgZfjgb7jgZfjgZ/jga7jgafjgIHmnKzjg6Hjg7zjg6vjgavj
gabjgZTmoYjlhoXjgYTjgZ/jgZfjgb7jgZnjgIINCuKXj+S4ieS6leS9j+WPi+OCq+ODvOODieOD
rOOCv+ODvOOBruOBlOeZu+mMsuODu+ino+mZpA0K4pag4pah4pag5LiJ5LqV5L2P5Y+L44Kr44O8
44OJ44GL44KJ44Gu44GK55+l44KJ44Gb44CA4pag4pah4pagDQrku4rlvozjgajjgoLjgIxWcGFz
c+OAjeOBruOBlOWIqeeUqOOCkuOCiOOCjeOBl+OBj+OBiumhmOOBhOOBhOOBn+OBl+OBvuOBmeOA
gg0K4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSB4pSBDQrkuInkupXk
vY/lj4vjgqvjg7zjg4nmoKrlvI/kvJrnpL4NCnRoYW5reW91QHZwYXNzLm5lLmpwIA0K4oC75pys
44Oh44O844Or44Gv6YCB5L+h5bCC55So44Gn44GZ44CCDQrigLvmnKzjg6Hjg7zjg6vjga/jgIxW
cGFzc+OAjeOBq+ODoeODvOODq+OCouODieODrOOCueOCkuOBlOeZu+mMsuOBhOOBn+OBoOOBhOOB
puOBiuOCiuOAgeOAjFZwYXNz44CN44Gn5ZCE56iu44GK55Sz44GX6L6844G/44KS44GV44KM44Gf
5pa544Gr44GK6YCB44KK44GX44Gm44GE44G+44GZ44CCDQrilIHilIHilIHilIHilIHilIHilIHi
lIHilIHilIHilIHilIHilIHilIHilIEKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBsaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8gbGludXgtbnZkaW1t
LWxlYXZlQGxpc3RzLjAxLm9yZwo=
