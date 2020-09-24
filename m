Return-Path: <SRS0=b8rN=DB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.8 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10C0C4727D
	for <linux-nvdimm@archiver.kernel.org>; Thu, 24 Sep 2020 20:54:38 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A82EA221EB
	for <linux-nvdimm@archiver.kernel.org>; Thu, 24 Sep 2020 20:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A82EA221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=rakuten.co.jp
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C3116152E6735;
	Thu, 24 Sep 2020 13:54:37 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=2400:8500:1801:451:160:251:11:80; helo=alkwfq04222.cn; envelope-from=noreply@nxe56.cn; receiver=<UNKNOWN> 
Received: from alkwfq04222.cn (v160-251-11-80.6v79.static.cnode.io [IPv6:2400:8500:1801:451:160:251:11:80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BD28E149D9086
	for <linux-nvdimm@lists.01.org>; Thu, 24 Sep 2020 13:54:33 -0700 (PDT)
Received: from azttxg (unknown [112.121.165.186])
	by alkwfq04222.cn (Postfix) with ESMTPA id C333E1E8368
	for <linux-nvdimm@lists.01.org>; Fri, 25 Sep 2020 04:27:51 +0800 (CST)
DKIM-Filter: OpenDKIM Filter v2.11.0 alkwfq04222.cn C333E1E8368
From: Rakuten-card@rakuten.co.jp <Rakuten-card@rakuten.co.jp>
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?44CQ5qW95aSp5Lya5ZOh44CR44GC44Gq44Gf44Gu44Ki44Kr44Km44Oz44OI44Gv55uX6Zuj44Gu5Y2x?=
	=?utf-8?B?6Zm644Gr44GV44KJ44GV44KM44Gm44GE44G+44GZ?=
Date: Fri, 25 Sep 2020 04:27:37 +0800
Message-ID: <009f17dfaff0$f1898704$e6b35129$@azttxg>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Message-ID-Hash: UA4WYSIQJCS66NU4WZLGAK2FPRGBM7JM
X-Message-ID-Hash: UA4WYSIQJCS66NU4WZLGAK2FPRGBM7JM
X-MailFrom: noreply@nxe56.cn
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UA4WYSIQJCS66NU4WZLGAK2FPRGBM7JM/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

44GC44Gq44Gf44Gu44Ki44Kr44Km44Oz44OI44Gv55Ww5bi46KGM54K644Gn5Yi26ZmQ44GV44KM
44Gm44GE44G+44GZDQoNCldpbmRvd3MgWFAgU1Ay44KS44GU5Yip55So44Gn55S75YOP44GM6KGo
56S644GV44KM44Gq44GE5pa544G4DQoNCg0K5qW95aSp44GL44KJ44Gu44GU5oyo5ou244Gn44GZ
44CBDQrjgYrlrqLmp5jjga7jgqLjgqvjgqbjg7Pjg4jjga7kv53orbfjgpLph43oppbjgZfjgabj
gYrjgorjgb7jgZnjgIINCuOBguOBquOBn+OBruOCouOCq+OCpuODs+ODiOOBq+eVsOW4uOOBquih
jOWLleOBjOOBguOCi+OBk+OBqOOCkueiuuiqjeOBl+OBvuOBl+OBn+OAgg0K44GC44Gq44Gf44Gu
44Ki44Kr44Km44Oz44OI44GM5qW95aSp44Gu5Yip55So6KaP5YmH44Gr5ZCI6Ie044GZ44KL44KI
44GG44Gr44CBDQrjgqLjgqvjgqbjg7Pjg4jjga7nlbDluLjjga7oqbPntLDjgpLnorroqo3jgZfj
gabjgIHnlbDluLjjgpLop6PpmaTjgZfjgabjgY/jgaDjgZXjgYTjgIINCg0K44GK5a6i5qeY44Gu
5Lya5ZOh5oOF5aCxDQrjgZTnmbvpjLLjgYTjgZ/jgaDjgYTjgZ/jg6bjg7zjgrYgSUTvvJpsaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnIOeVsOW4uOOCkueiuuiqjeOBl+OAgeino+mZpOOBmeOCiyAN
CuKAu+OCouOCq+OCpuODs+ODiOOBrueVsOW4uOOCkuWJiumZpOOBl+OBquOBhOOBqOOAgeOCouOC
q+OCpuODs+ODiOOBruS9v+eUqOOBqOiyqeWjsua0u+WLleOCkuWBnOatouOBmeOCi+WPr+iDveaA
p+OBjOOBguOCiuOBvuOBmeOAgiANCg0K4oC755S76Z2i44Gu5oyH56S644Gr5b6T44Gj44Gm6Kej
6Zmk44KS57aa44GR44Gm44GP44Gg44GV44GE44CCIA0KDQoNCg0KDQrjgZTnkIbop6PjgYLjgorj
gYzjgajjgYbjgZTjgZbjgYTjgb7jgZnvvIEgDQrilqDjgZPjga7jg6Hjg7zjg6vjga/pgIHkv6Hl
sILnlKjjg6Hjg7zjg6vjgqLjg4njg6zjgrnjgYvjgonphY3kv6HjgZXjgozjgabjgYTjgb7jgZnj
gILjgZTov5Tkv6HjgYTjgZ/jgaDjgYTjgabjgoLjgYrnrZTjgYjjgafjgY3jgb7jgZvjgpPjga7j
gafjgZTkuobmib/jgY/jgaDjgZXjgYTjgIIgDQrilqDlgIvkurrmg4XloLHjga7lj5bmibHjgYTj
gavjgaTjgYTjgabjga/lgIvkurrmg4XloLHkv53orbfmlrnph53jgpLjgZTopqfjgY/jgaDjgZXj
gYTjgIIgDQrilqDjgZTnmbvpjLLjgavlv4PjgYLjgZ/jgorjgYzjgarjgYTloLTlkIjjgIHjgZTo
s6rllY/nrYnjga7jgYLjgovmlrnjga/jgIHjgZPjgaHjgonjga7jg5jjg6vjg5fjg5rjg7zjgrjj
gZTlj4Lnhafjga7jgYbjgYjjgIHjgYrllY/jgYTlkIjjgo/jgZvjg5Xjgqnjg7zjg6DjgYvjgonj
gZTpgKPntaHjgY/jgaDjgZXjgYTjgIIgDQrmpb3lpKnluILloLQgICDmpb3lpKnjgrDjg6vjg7zj
g5fkuIDopqcgICDnt4/lkIjmoYjlhoXmiYAgICDjg6njg7Pjgq3jg7PjgrAgICDjg5jjg6vjg5cg
ICDlgIvkurrmg4XloLHkv53orbfmlrnph50NCsKpIFJha3V0ZW4sIEluYy4gDQoNCg0KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdCAtLSBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNl
bmQgYW4gZW1haWwgdG8gbGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
