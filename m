Return-Path: <SRS0=99yl=5U=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D499C43331
	for <linux-nvdimm@archiver.kernel.org>; Sat,  4 Apr 2020 03:39:15 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A748206F6
	for <linux-nvdimm@archiver.kernel.org>; Sat,  4 Apr 2020 03:39:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A748206F6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nessti.info
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D7465100DCAE7;
	Fri,  3 Apr 2020 20:39:54 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=62.76.177.171; helo=nessti.info; envelope-from=info@nessti.info; receiver=<UNKNOWN> 
Received: from nessti.info (unknown [62.76.177.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 41FCF100DCDFF
	for <linux-nvdimm@lists.01.org>; Fri,  3 Apr 2020 20:39:41 -0700 (PDT)
Message-ID: <0f9318b441438a869386306397013b37c3de62c1@nessti.info>
From: Jeanne <info@nessti.info>
To: linux-nvdimm@lists.01.org
Subject: How to use a PC to earn money?
Date: Sat, 4 Apr 2020 06:38:28 +0300
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; d=nessti.info; s=mail;
	c=relaxed/relaxed; t=1585971508;
	h=message-id:from:to:subject:date:mime-version:list-unsubscribe;
	bh=KrzxrG2CGHOS+7b5L3RbJOsBzjEFi2hLYoCBm9YaM6E=;
	b=GVbQKhYPX0XoWN9I1OOeDg7+5mx5pgjX1BHPrkIrnK5OvXJYkZZToR5DmqSkuj
	IkPdrBvOFPbyhcmIk9ToU6CcWdOy4uEqmXo4QOl6TUeg9bE9+cfhWKtXJBYO4h/6
	PoMdptsaKV00Ru1fvce5niYMP0nRRcqwWWw/hzo67CJvw=
Message-ID-Hash: 5IS343ZNPIBMRBOAS2I5B4EVMIDPCSQV
X-Message-ID-Hash: 5IS343ZNPIBMRBOAS2I5B4EVMIDPCSQV
X-MailFrom: info@nessti.info
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
Content-Type: text/plain; charset="windows-1251"
X-Content-Filtered-By: Mailman/MimeDel 3.1.1
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5IS343ZNPIBMRBOAS2I5B4EVMIDPCSQV/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Transfer-Encoding: base64

VHVybiBZb3VyIENvbXB1dGVyIGludG8gYSAyNFg3IE1vbmV5IEdlbmVyYXRvci4NCg0KMTAwJSBB
dXRvcGlsb3QuIDEwMCUgRlJFRS4NCg0KRXZlcnlvbmUncyBJbnZpdGVkIQ0KDQpHbyB0byBzaXRl
PqBodHRwOi8vYml0Lmx5LzJJaDRkZnINCg0KSWYgeW91IGRvIG5vdCB3aXNoIHRvIHJlY2VpdmUg
ZnVydGhlciBlbWFpbHMsIHRoZW4gcGxlYXNlIGNsaWNrIGhlcmUgdG8gTGlzdC1VbnN1YnNjcmli
ZQ0KDQp8IDg2ODQgU2FudGEgTW9uaWNhIEJsdmQsIFN1aXRlIDg2ODQgTG9zIEFuZ2VsZXMsIENB
IDg2ODQtODY4NCwgVVNBIHwNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxpc3Rz
LjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1sZWF2
ZUBsaXN0cy4wMS5vcmcK
