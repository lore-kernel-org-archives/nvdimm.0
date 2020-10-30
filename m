Return-Path: <SRS0=oic9=EF=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B48C5517A
	for <linux-nvdimm@archiver.kernel.org>; Fri, 30 Oct 2020 06:57:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 070E521734
	for <linux-nvdimm@archiver.kernel.org>; Fri, 30 Oct 2020 06:57:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 070E521734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ml01.01.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 34A3E1656442C;
	Thu, 29 Oct 2020 23:57:56 -0700 (PDT)
Received-SPF: Softfail (mailfrom) identity=mailfrom; client-ip=195.123.222.191; helo=vpass.ne.jp; envelope-from=gldpkmo@vpass.ne.jp; receiver=<UNKNOWN> 
Received: from vpass.ne.jp (unknown [195.123.222.191])
	by ml01.01.org (Postfix) with ESMTP id 0254C1655D802
	for <linux-nvdimm@lists.01.org>; Thu, 29 Oct 2020 23:57:52 -0700 (PDT)
Sender: gldpkmo@vpass.ne.jp
Message-ID: <39A690B419D8D0C4D309E546B458865D@vpass.ne.jp>
From: "vpass.ne.jp" <vpass.ne.jp@ml01.01.org>
To: <linux-nvdimm@lists.01.org>
Subject: =?utf-8?B?77yc6YeN6KaB77ye44CQ5LiJ5LqV5L2P5Y+L44Kr44O844OJ44CR44GU5Yip55So56K66KqN44Gu44GK?=
	=?utf-8?B?6aGY44GE?=
Date: Thu, 29 Oct 2020 23:57:40 -0800
Mime-Version: 1.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.3.9600.16384
Message-ID-Hash: DKO6MGYM2OTVPGU2ZW6L2AIEGLDCQFZR
X-Message-ID-Hash: DKO6MGYM2OTVPGU2ZW6L2AIEGLDCQFZR
X-MailFrom: gldpkmo@vpass.ne.jp
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DKO6MGYM2OTVPGU2ZW6L2AIEGLDCQFZR/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQoNCuOBhOOBpOOCguW8iuekvuOCq+ODvOODieOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBjeOBguOC
iuOBjOOBqOOBhuOBlOOBluOBhOOBvuOBmeOAgg0KDQrmmKjku4rjga7nrKzkuInogIXkuI3mraPl
iKnnlKjjga7mgKXlopfjgavkvLTjgYTjgIHlvIrnpL7jgafjga/jgIzkuI3mraPliKnnlKjnm6Po
ppbjgrfjgrnjg4bjg6DjgI3jgpLlsI7lhaXjgZfjgIEyNOaZgumWkzM2NeaXpeS9k+WItuOBp+OC
q+ODvOODieOBruOBlOWIqeeUqOOBq+WvvuOBmeOCi+ODouODi+OCv+ODquODs+OCsOOCkuihjOOB
o+OBpuOBiuOCiuOBvuOBmeOAgg0KDQrjgZPjga7jgZ/jgbPjgIHjgZTmnKzkurrmp5jjga7jgZTl
iKnnlKjjgYvjganjgYbjgYvjgpLnorroqo3jgZXjgZvjgabjgYTjgZ/jgaDjgY3jgZ/jgYTjgYrl
j5blvJXjgYzjgYLjgorjgb7jgZfjgZ/jga7jgafjgIHoqqDjgavli53miYvjgarjgYzjgonjgIHj
gqvjg7zjg4njga7jgZTliKnnlKjjgpLkuIDpg6jliLbpmZDjgZXjgZvjgabjgYTjgZ/jgaDjgY3j
gIHjgZTpgKPntaHjgZXjgZvjgabjgYTjgZ/jgaDjgY3jgb7jgZfjgZ/jgIINCg0K44Gk44GN44G+
44GX44Gm44Gv44CB5Lul5LiL44G444Ki44Kv44K744K544Gu5LiK44CB44Kr44O844OJ44Gu44GU
5Yip55So56K66KqN44Gr44GU5Y2U5Yqb44KS44GK6aGY44GE6Ie044GX44G+44GZ44CCDQrjgZTl
m57nrZTjgpLjgYTjgZ/jgaDjgZHjgarjgYTloLTlkIjjgIHjgqvjg7zjg4njga7jgZTliKnnlKjl
iLbpmZDjgYzntpnntprjgZXjgozjgovjgZPjgajjgoLjgZTjgZbjgYTjgb7jgZnjga7jgafjgIHk
uojjgoHjgZTkuobmib/kuIvjgZXjgYTjgIINCg0K4pag44GU5Yip55So56K66KqN44Gv44GT44Gh
44KJDQoNCuOAgGh0dHA6Ly9zemppYWR1b2Z1LmNvbS8NCg0K4pag55m66KGM6ICF4pagDQrkuInk
upXkvY/lj4vjgqvjg7zjg4nmoKrlvI/kvJrnpL4NCuOAgGh0dHBzOi8vd3d3LnNtYmMtY2FyZC5j
b20vDQrjgJIxMDUtODAxMSDmnbHkuqzpg73muK/ljLrmtbflsrgx5LiB55uuMueVqjIw5Y+3IOax
kOeVmeODk+ODq+ODh+OCo+ODs+OCsA0KDQoNCi4uLgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxpbnV4
LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBsaW51
eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
