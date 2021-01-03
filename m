Return-Path: <SRS0=2K3M=GG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.8 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C39DC433DB
	for <linux-nvdimm@archiver.kernel.org>; Sun,  3 Jan 2021 05:09:58 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8AAB420782
	for <linux-nvdimm@archiver.kernel.org>; Sun,  3 Jan 2021 05:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AAB420782
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vpass.ne.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4C673100EF267;
	Sat,  2 Jan 2021 21:09:57 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=43.255.29.229; helo=qao.nfgsreyhtdf.xyz; envelope-from=eg@qao.nfgsreyhtdf.xyz; receiver=<UNKNOWN> 
Received: from qAo.nfgsreyhtdf.xyz (unknown [43.255.29.229])
	by ml01.01.org (Postfix) with ESMTP id 523ED100EF250
	for <linux-nvdimm@lists.01.org>; Sat,  2 Jan 2021 21:09:52 -0800 (PST)
Sender: eg@qAo.nfgsreyhtdf.xyz
Message-ID: <20210103130952376843@qAo.nfgsreyhtdf.xyz>
From: "smbc.co.jp" <smbc@vpass.ne.jp>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?77yc5LiJ5LqV5L2P5Y+L44Kr44O844OJ77ye44GU5Yip55So56K66KqN44Gu44GK6aGY44GE?=
Date: Sun, 3 Jan 2021 13:09:41 +0800
MIME-Version: 1.0
X-mailer: Mmy 2
Message-ID-Hash: NTISVE7SC3WWPYOUUCTDY6NLSPJTLTMS
X-Message-ID-Hash: NTISVE7SC3WWPYOUUCTDY6NLSPJTLTMS
X-MailFrom: eg@qAo.nfgsreyhtdf.xyz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NTISVE7SC3WWPYOUUCTDY6NLSPJTLTMS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQrjgIAgIA0KDQoNCuacrOODoeODvOODq+OBr+ODieODoeOCpOODs+OBrumBi+eUqO+8iOODoeOD
vOODq+mAgeWPl+S/oeOChOODm+ODvOODoOODmuODvOOCuOOBruihqOekuu+8ieOBq+mWouOCj+OC
iw0K6YeN6KaB44Gq6YCa55+l44Go44Gq44KK44G+44GZ44CCDQoNCuOBhOOBpOOCguW8iuekvuOC
q+ODvOODieOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBjeOBguOCiuOBjOOBqOOBhuOBlOOBluOBhOOB
vuOBmeOAgg0KDQrmmKjku4rjga7nrKzkuInogIXkuI3mraPliKnnlKjjga7mgKXlopfjgavkvLTj
gYTjgIHlvIrnpL7jgafjga/jgIzkuI3mraPliKnnlKjnm6Poppbjgrfjgrnjg4bjg6DjgI3jgpLl
sI7lhaXjgZfjgIEyNOaZgumWkzM2NeaXpeS9k+WItuOBp+OCq+ODvOODieOBruOBlOWIqeeUqOOB
q+WvvuOBmeOCi+ODouODi+OCv+ODquODs+OCsOOCkuihjOOBo+OBpuOBiuOCiuOBvuOBmeOAgg0K
DQrjgZPjga7jgZ/jgbPjgIHjgZTmnKzkurrmp5jjga7jgZTliKnnlKjjgYvjganjgYbjgYvjgpLn
orroqo3jgZXjgZvjgabjgYTjgZ/jgaDjgY3jgZ/jgYTjgYrlj5blvJXjgYzjgYLjgorjgb7jgZfj
gZ/jga7jgafjgIHoqqDjgavli53miYvjgarjgYzjgonjgIHjgqvjg7zjg4njga7jgZTliKnnlKjj
gpLkuIDpg6jliLbpmZDjgZXjgZvjgabjgYTjgZ/jgaDjgY3jgIHjgZTpgKPntaHjgZXjgZvjgabj
gYTjgZ/jgaDjgY3jgb7jgZfjgZ/jgIINCg0K44Gk44GN44G+44GX44Gm44Gv44CB5Lul5LiL44G4
44Ki44Kv44K744K544Gu5LiK44CB44Kr44O844OJ44Gu44GU5Yip55So56K66KqN44Gr44GU5Y2U
5Yqb44KS44GK6aGY44GE6Ie044GX44G+44GZ44CCDQrjgZTlm57nrZTjgpLjgYTjgZ/jgaDjgZHj
garjgYTloLTlkIjjgIHjgqvjg7zjg4njga7jgZTliKnnlKjliLbpmZDjgYzntpnntprjgZXjgozj
govjgZPjgajjgoLjgZTjgZbjgYTjgb7jgZnjga7jgafjgIHkuojjgoHjgZTkuobmib/kuIvjgZXj
gYTjgIINCg0K4pag44GU5Yip55So56K66KqN44Gv44GT44Gh44KJ4pagDQoNCg0K6Iez5oCl44CB
UyBNIEIgQ+OCq+ODvOODieS8muWToeOCteODvOODk+OCueOBq+aDheWgseOCkuWGjeeZu+mMsuOB
l+OBpuOBj+OBoOOBleOBhA0KDQoNCuKWoOeZuuihjOiAheKWoA0K5LiJ5LqV5L2P5Y+L44Kr44O8
44OJ5qCq5byP5Lya56S+DQrjgIBodHRwczovL3d3dy5zbWJjLWNhcmQuY29tLw0K44CSMTA1LTgw
MTEg5p2x5Lqs6YO95riv5Yy65rW35bK4MeS4geebrjLnlaoyMOWPtyDmsZDnlZnjg5Pjg6vjg4fj
gqPjg7PjgrANCg0KDQoNCg0KQ29weXJpZ2h0IChDKSAyMDIwIFN1bWl0b21vIE1pdHN1aSBDYXJk
IENvLiwgTHRkLg0KIApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51eC1udmRpbW0tbGVhdmVAbGlz
dHMuMDEub3JnCg==
