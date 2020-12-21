Return-Path: <SRS0=bCLp=FZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F8EC433DB
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Dec 2020 06:47:43 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D98AB221F7
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Dec 2020 06:47:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D98AB221F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=baliyev.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6D8ED100EF272;
	Sun, 20 Dec 2020 22:47:42 -0800 (PST)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=168.119.102.15; helo=win-9q9gat2do92; envelope-from=info@baliyev.com; receiver=<UNKNOWN> 
Received: from win-9q9gat2do92 (static.15.102.119.168.clients.your-server.de [168.119.102.15])
	by ml01.01.org (Postfix) with ESMTP id B7CAE100EF270
	for <linux-nvdimm@lists.01.org>; Sun, 20 Dec 2020 22:47:39 -0800 (PST)
Received: from [127.0.0.1] (account postmaster@win-9q9gat2do92 HELO static.15.102.119.168.clients.your-server.de)
  by win-9q9gat2do92 (CommuniGate Pro SMTP 6.1.9 _community_)
  with ESMTPSA id 594833 for linux-nvdimm@lists.01.org; Sun, 20 Dec 2020 22:47:33 -0800
From: "support@lists.01.org" <info@baliyev.com>
To: linux-nvdimm@lists.01.org
Subject: New Recording [1391371050]
Date: 20 Dec 2020 22:47:33 -0800
Message-ID: <20201220224733.B2453B4F8D2B4033@baliyev.com>
MIME-Version: 1.0
Message-ID-Hash: D3NEDPXRJFOKB6WHE42OX6DWYPOYD2IY
X-Message-ID-Hash: D3NEDPXRJFOKB6WHE42OX6DWYPOYD2IY
X-MailFrom: info@baliyev.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/D3NEDPXRJFOKB6WHE42OX6DWYPOYD2IY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

wqANCsKgDQoNCklEOiA8IGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcgPg0KDQpBIGNhbGxlciBp
biB5b3VyIGRpcmVjdG9yeSBqdXN0IGxlZnQgeW91IGEgbWVzc2FnZS4NCg0KQ2FsbGVyIDogKzEg
NzAxIDMyOCA5MDEwDQpEYXRlOiAxMi0yMC0yMDIwDQpEdXJhdGlvbjogMDE6MHNlYw0KDQpMaXN0
ZW4gdG8gVm9pY2UgTWVzc8SFZ2UgDQoowqBodHRwczovL3NraXBwZXItdGVzdGluZzM4Mi5maXJl
YmFzZWFwcC5jb20vaS5odG1sP0VPRD1saW51eC1udmRpbW1AbGlzdHMuMDEub3JnJkFTSz1lbkfC
oCkNCg0KRW1haWwgd2FzIHNlbnQgdG8gbGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZw0KDQpZb3Vy
IG1lc3NhZ2UgbGluayBsYXN0IGZvciAxMiBob3Vyc8KgCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxp
bnV4LW52ZGltbS1sZWF2ZUBsaXN0cy4wMS5vcmcK
