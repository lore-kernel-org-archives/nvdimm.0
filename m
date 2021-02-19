Return-Path: <SRS0=NL4R=HV=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E3DC433DB
	for <linux-nvdimm@archiver.kernel.org>; Fri, 19 Feb 2021 08:11:05 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E09C64EBF
	for <linux-nvdimm@archiver.kernel.org>; Fri, 19 Feb 2021 08:11:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E09C64EBF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vpass.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 38627100EAB06;
	Fri, 19 Feb 2021 00:11:04 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=150.95.223.63; helo=vpass.ne.jp; envelope-from=nmu@vpass.ne.jp; receiver=<UNKNOWN> 
Received: from vpass.ne.jp (v150-95-223-63.1gal.static.cnode.io [150.95.223.63])
	by ml01.01.org (Postfix) with ESMTP id AFCBA100EAB4A
	for <linux-nvdimm@lists.01.org>; Fri, 19 Feb 2021 00:11:00 -0800 (PST)
Message-ID: <623138F7E4B29180DD0DC0A4CA8831F5@vpass.ne.jp>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L44Kr44O844OJ?= <update@vpass.ne.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5LiJ5LqV5L2P5Y+L44Kr44O844OJ44CR55m76Yyy5oOF5aCx44GM5q2j44GX44GP44GC44KK44G+?=
	=?utf-8?B?44Gb44KT?=
Date: Fri, 19 Feb 2021 17:10:56 +0900
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V10.0.14393.2007
Message-ID-Hash: 74FPWBKYJYX4S6XXTXNKQR5ZCL4TZLKB
X-Message-ID-Hash: 74FPWBKYJYX4S6XXTXNKQR5ZCL4TZLKB
X-MailFrom: nmu@vpass.ne.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/74FPWBKYJYX4S6XXTXNKQR5ZCL4TZLKB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

IA0KDQogDQogDQoNCiANCg0KIA0KIA0KDQogDQoNCiANCg0KDQoNCuOBhOOBpOOCguW8iuekvuOC
q+ODvOODieOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBjeOBguOCiuOBjOOBqOOBhuOBlOOBluOBhOOB
vuOBmeOAgg0KDQogIOOBiuWuouanmOOBrueZu+mMsuaDheWgseOBjOato+OBl+OBj+OBguOCiuOB
vuOBm+OCk+OAguOBk+OBruODoeODvOODq+OBp+OBr+OAgeOAjFZwYXNz44CN44Gr44GU55m76Yyy
44Gu5oOF5aCx44Gu5aSJ5pu05Y+X5LuY44KS6Kix5Y+v44GX44Gf44GT44Go44KS44GK55+l44KJ
44Gb44GX44Gm44GK44KK44G+44GZ44CCDQoNCiANCuKUgeKUgeKUgeKUgeKUgeKUgeKUgQ0K4oaS
44GU5aSJ5pu044Gv44GT44Gh44KJ44GL44KJDQrilIHilIHilIHilIHilIHilIHilIENCg0KDQri
lqDilqHilqDkuInkupXkvY/lj4vjgqvjg7zjg4njgYvjgonjga7jgYrnn6XjgonjgZvilqDilqHi
lqANCg0K4pa844Kr44O844OJ44GU5Yip55So44Gu6Zqb44CB5pqX6Ki855Wq5Y+344GM5b+F6KaB
44Gq5aC05ZCI44GM44GU44GW44GE44G+44GZ44CCDQrmmpfoqLznlarlj7fjgpLjgZTlrZjjgZjj
gafjgarjgYTloLTlkIjjga/jgIHlvIrnpL7jg5vjg7zjg6Djg5rjg7zjgrjjgYvjgonnsKHljZjj
gavnhafkvJrjgYrmiYvntprjgY3jgYTjgZ/jgaDjgZHjgb7jgZnjgIINCuOBnOOBsuOAgeOBiuaX
qeOCgeOBq+OBlOeiuuiqjeOBj+OBoOOBleOBhOOAgg0KDQoNCuS4ieS6leS9j+WPi+OCq+ODvOOD
ieagquW8j+S8muekvg0K44CSMTA1LTgwMTEg5p2x5Lqs6YO95riv5Yy65rW35bK4MeS4geebrjLn
laoyMOWPtyDmsZDnlZnjg5Pjg6vjg4fjgqPjg7PjgrANCg0KDQoNCiANCkNvcHlyaWdodCAoQykg
MjAyMSBTdW1pdG9tbyBNaXRzdWkgQ2FyZCBDby4sIEx0ZC4KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBs
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8g
bGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
