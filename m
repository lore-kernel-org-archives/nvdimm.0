Return-Path: <SRS0=ffZ5=4I=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E7EC11D0C
	for <linux-nvdimm@archiver.kernel.org>; Thu, 20 Feb 2020 14:54:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B78B524684
	for <linux-nvdimm@archiver.kernel.org>; Thu, 20 Feb 2020 14:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nuevafactura15.maodevacaeinvestidor.com header.i=@nuevafactura15.maodevacaeinvestidor.com header.b="HIL6IGCp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B78B524684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nuevafactura15.maodevacaeinvestidor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id BB7901007B1FE;
	Thu, 20 Feb 2020 06:55:47 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=80.211.253.18; helo=nuevafactura15.maodevacaeinvestidor.com; envelope-from=facturavencida41209@nuevafactura15.maodevacaeinvestidor.com; receiver=<UNKNOWN> 
Received: from nuevafactura15.maodevacaeinvestidor.com (nuevafactura15.maodevacaeinvestidor.com [80.211.253.18])
	by ml01.01.org (Postfix) with ESMTP id 83ECC1007B1C9
	for <linux-nvdimm@lists.01.org>; Thu, 20 Feb 2020 06:55:45 -0800 (PST)
Received: by nuevafactura15.maodevacaeinvestidor.com (Postfix, from userid 33)
	id 7E03681FE6; Thu, 20 Feb 2020 15:54:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=nuevafactura15.maodevacaeinvestidor.com; s=mail; t=1582210492;
	bh=BLiOcdZ+aZG32aQIF6joWc+lnoyDKJ8BiQ2/srB/qrY=;
	h=To:Subject:Date:From:Reply-To:From;
	b=HIL6IGCpgnERPcCE4iJJjbSsVkCPlvYbLmolsHLeowECZ6s4njWiyv8xLcjCeXSwb
	 fQPS5OnjCA8sE12ipnmAaGxpXgUAYFWzq3y+yzrBC9aGu9eXwaORhUY0NsuO1TBqxV
	 7VA03Xz+H/dzwZ9FCVcxDmdHfX9A5oeugbSXrhs1SLOjXS3OJ964Q8iAiXe3OHUESf
	 Yr41rVc6n9ppZjbG2AlzLwmrA84LMp++iJVdIWLQJ1VDXPHYBlcX/mjiQJKX/S6S0C
	 JIFanlViI5GYOrFrxO/eX6+cVaxepzWv1sjp3dxTxfC8LyrOolmG42kRb3HvO6/Zms
	 GP5XsURKXL3EA==
To: linux-nvdimm@lists.01.org
Subject: =?UTF-8?Q?Su_factura_eletr=C3=B3nica.?=
Date: Thu, 20 Feb 2020 15:54:52 +0100
From: 412684 LinuxMercedes <facturavencida41209@nuevafactura15.maodevacaeinvestidor.com>
Message-ID: <38d1b49a0592361675906732debaaf65@80.211.253.18>
X-Priority: 3
X-Mailer: PHPMailer 5.2.4 (http://code.google.com/a/apache-extras.org/p/phpmailer/)
MIME-Version: 1.0
Message-ID-Hash: LZSTM3UE2DV25MRAFXFXCZGXX7LV6P3Z
X-Message-ID-Hash: LZSTM3UE2DV25MRAFXFXCZGXX7LV6P3Z
X-MailFrom: facturavencida41209@nuevafactura15.maodevacaeinvestidor.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
Reply-To: 412684 LinuxMercedes <facturavencida41209@nuevafactura15.maodevacaeinvestidor.com>
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LZSTM3UE2DV25MRAFXFXCZGXX7LV6P3Z/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Jm5ic3A7DQoNCiAgDQogIA0KICAgIA0KICAgICAgRXN0aW1hZG8gDQogICAgICBjbGllbnRlLCBs
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnDQ0KICAgICAgJm5ic3A7DQogICAgICBTZSANCiAgICAg
IGFkanVudGEgc3UgZmFjdHVyYSBlbGVjdHLDs25pY2EgcGFyYSBlbCZuYnNwO21lcyBkZSBmZWJy
ZXJvLg0KICAgICAgJm5ic3A7DQogICAgICANCiAgICAgICAgDQogICAgICAgIA0KICAgICAgICAg
IA0KICAgICAgICAgICAgDQogICAgICAgICAgICAgIA0KICAgICAgICAgICAgICANCiAgICAgICAg
ICAgICAgICBGYWN0dXJhIA0KICAgICAgICAgICAgICAgICAgMjAuMDIuMjAyMCg2NTJLQikuUERG
DQombmJzcDsNCg0KICANCiAgDQogICAgDQogICAgICBTYWx1ZG9zIA0KICAgICAgQ29yZGlhbGVz
IQ0KICAgICAgTm8gcmVzcG9uZGFzIGEgZXN0ZSBjb3JyZW8gDQogICAgICBlbGVjdHLDs25pY28u
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52
ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpUbyB1bnN1YnNj
cmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1sZWF2ZUBsaXN0cy4wMS5vcmcK
