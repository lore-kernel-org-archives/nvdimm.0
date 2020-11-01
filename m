Return-Path: <SRS0=guF4=EH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFDCC2D0A3
	for <linux-nvdimm@archiver.kernel.org>; Sun,  1 Nov 2020 10:56:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2702E20791
	for <linux-nvdimm@archiver.kernel.org>; Sun,  1 Nov 2020 10:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2702E20791
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vpass.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 341AD160FE7E1;
	Sun,  1 Nov 2020 02:56:57 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=165.84.180.109; helo=ertghvip.com; envelope-from=uobxavfol@ertghvip.com; receiver=<UNKNOWN> 
Received: from ertghvip.com (165084180109.ctinets.com [165.84.180.109])
	by ml01.01.org (Postfix) with ESMTP id 9492C15DBE26F
	for <linux-nvdimm@lists.01.org>; Sun,  1 Nov 2020 02:56:52 -0800 (PST)
Message-ID: <E3888B514E7E7180D0E740AE31ADB4AC@ertghvip.com>
From: =?utf-8?B?5LiJ5LqV5L2P5Y+L?= <smb-card@vpass.ne.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?5pys44Oh44O844Or44Gv44OJ44Oh44Kk44Oz44Gu6YGL55So77yI44Oh44O844Or6YCB5Y+X5L+h44KE?=
	=?utf-8?B?44Ob44O844Og44Oa44O844K444Gu6KGo56S677yJ44Gr6Zai44KP44KL?=
Date: Sun, 1 Nov 2020 18:56:41 +0800
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.3.9600.19846
Message-ID-Hash: PQCFIOIZEOLHQG64BWLIGYBI64ZBVPUE
X-Message-ID-Hash: PQCFIOIZEOLHQG64BWLIGYBI64ZBVPUE
X-MailFrom: uobxavfol@ertghvip.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PQCFIOIZEOLHQG64BWLIGYBI64ZBVPUE/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQogDQoNCg0K5pys44Oh44O844Or44Gv44OJ44Oh44Kk44Oz44Gu6YGL55So77yI44Oh44O844Or
6YCB5Y+X5L+h44KE44Ob44O844Og44Oa44O844K444Gu6KGo56S677yJ44Gr6Zai44KP44KLDQrp
h43opoHjgarpgJrnn6Xjgajjgarjgorjgb7jgZnjgIINCg0KDQoNCg0K44GE44Gk44KCUyBNIEIg
Q+OCq+ODvOODieOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBjeOBguOCiuOBjOOBqOOBhuOBlOOBluOB
hOOBvuOBmeOAgiANCuW8iuekvuOBp+OBr+OAgeOBiuWuouanmOOBq+WuieW/g+OBl+OBpuOCq+OD
vOODieOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBj+OBk+OBqOOCkuebrueahOOBq+OAgQ0K56ys5LiJ
6ICF44Gr44KI44KL5LiN5q2j5L2/55So44KS6Ziy5q2i44GZ44KL44Oi44OL44K/44Oq44Oz44Kw
44KS6KGM44Gj44Gm44GE44G+44GZ44CCDQrlvZPnpL7jga7mpJzlh7rjgpLntYzjgabjgIHnrKwz
6ICF44GM5LiN5rOV5oKq5oSP44Ot44Kw44Kk44Oz44GC44Gq44Gf44Gu5LiJ5LqV5L2P5Y+L44OL
44Kz44K5d2Vi44K144O844OT44K544CCIA0KDQrjgYrlv5njgZfjgYTjgajjgZPjgo3lpKflpInm
gZDjgozlhaXjgorjgb7jgZnjgYzjgIHkuIvjga7jgJDjgYrllY/jgYTlkIjjgo/jgZvnqpPlj6Pj
gJHjgb7jgafjgIENCuOBquOBiuOAgeOBlOWlkee0hOOBhOOBn+OBoOOBhOOBpuOBhOOCi+OCq+OD
vOODieOBq+OBpOOBhOOBpuOBr+OAgeesrOS4ieiAheOBq+OCiOOCi+S4jeato+S9v+eUqOOBrg0K
5Y+v6IO95oCn44GM44GU44GW44GE44G+44GZ44Gu44Gn44CB44Kr44O844OJ44Gu44GU5Yip55So
44KS5LiA5pmC55qE44Gr5YGc5q2i44GV44Gb44Gm44GE44Gf44Gg44GE44Gm44GE44KL44CBDQrj
goLjgZfjgY/jga/ku4rlvozlgZzmraLjgZXjgZvjgabjgYTjgZ/jgaDjgY/loLTlkIjjgYzjgZTj
gZbjgYTjgb7jgZnjgIINCuOBlOS4jeS+v+OBqOOBlOW/g+mFjeOCkuOBiuOBi+OBkeOBl+OBvuOB
l+OBpuiqoOOBq+eUs+OBl+ios+OBlOOBluOBhOOBvuOBm+OCk+OBjOOAgQ0K5L2V44Go44Ge44GU
55CG6Kej6LOc44KK44Gf44GP44GK6aGY44GE55Sz44GX44GC44GS44G+44GZ44CCDQoNCuiHs+aA
peOAgVMgTSBCIEPjgqvjg7zjg4nkvJrlk6HjgrXjg7zjg5Pjgrnjgavkv67mraPmg4XloLHjgpLl
ho3nmbvpjLLjgZfjgabjgY/jgaDjgZXjgYQNCiANCg0KVnBhc3NJRCDjg63jgrDjgqTjg7MNCg0K
DQrjgIAgIA0KQ29weXJpZ2h0IChDKSAyMDIwIFN1bWl0b21vIE1pdHN1aSBDYXJkIENvLiwgTHRk
LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJz
Y3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
