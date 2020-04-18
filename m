Return-Path: <SRS0=XhsV=6C=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2330C38A29
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 18:41:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 964412223D
	for <linux-nvdimm@archiver.kernel.org>; Sat, 18 Apr 2020 18:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kQXoOERE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 964412223D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id AC9B610FC62CE;
	Sat, 18 Apr 2020 11:41:44 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:7c80:54:e::133; helo=bombadil.infradead.org; envelope-from=rdunlap@infradead.org; receiver=<UNKNOWN> 
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 0417010FC52A1
	for <linux-nvdimm@lists.01.org>; Sat, 18 Apr 2020 11:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=BNcb4DjvEal/26p9FFLHA1PNQV3UKc32zHdLl0ttKSE=; b=kQXoOERERzpS0IoQotzhrC17AM
	BDqI0juPogoA1CutrU8uGOPsgmnH4QRxJkDAbfNciiSq0Z69PFmgx/TEZQgstSuVQf4s8ApWyZOIN
	N0IbkOKt56gcF//A3Gy0d9YkRaR0LroHAHn9xHV3q9Bg5gPjWHvSwd3aZ1XMnWGalvGvI3KsnHTOi
	PkF+38XbJVP04POPyWZMr+qjWfRfv/aYYUcvlXgcFpJEXyrtNbDsB0vSWbenyA4qfTd9ifIw7FyGe
	xHv6sxTZM8XTMTEwomUpQxoXy67XId7pgN/x2b6xhXYuH0hEoT/2krPvePcGZYn4RwiePLRAa3KKE
	lj06imMg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1jPsOx-0007rZ-5c; Sat, 18 Apr 2020 18:41:15 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] fs: fix empty-body warning in posix_acl.c
Date: Sat, 18 Apr 2020 11:41:04 -0700
Message-Id: <20200418184111.13401-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200418184111.13401-1-rdunlap@infradead.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
MIME-Version: 1.0
Message-ID-Hash: NETWCNKDK6VUURHGY7WPQKSQ4MLVQESN
X-Message-ID-Hash: NETWCNKDK6VUURHGY7WPQKSQ4MLVQESN
X-MailFrom: rdunlap@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Randy Dunlap <rdunlap@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Zzy Wysm <zzy@zzywysm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NETWCNKDK6VUURHGY7WPQKSQ4MLVQESN/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Rml4IGdjYyBlbXB0eS1ib2R5IHdhcm5pbmcgd2hlbiAtV2V4dHJhIGlzIHVzZWQ6DQoNCi4uL2Zz
L3Bvc2l4X2FjbC5jOiBJbiBmdW5jdGlvbiDigJhnZXRfYWNs4oCZOg0KLi4vZnMvcG9zaXhfYWNs
LmM6MTI3OjIyOiB3YXJuaW5nOiBzdWdnZXN0IGJyYWNlcyBhcm91bmQgZW1wdHkgYm9keSBpbiBh
biDigJhpZuKAmSBzdGF0ZW1lbnQgWy1XZW1wdHktYm9keV0NCiAgIC8qIGZhbGwgdGhyb3VnaCAq
LyA7DQogICAgICAgICAgICAgICAgICAgICAgXg0KDQpTaWduZWQtb2ZmLWJ5OiBSYW5keSBEdW5s
YXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz4NCkNjOiBBbGV4YW5kZXIgVmlybyA8dmlyb0B6ZW5p
di5saW51eC5vcmcudWs+DQpDYzogbGludXgtZnNkZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBM
aW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQpDYzogQW5kcmV3
IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4NCi0tLQ0KIGZzL3Bvc2l4X2FjbC5j
IHwgICAgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQ0KDQotLS0gbGludXgtbmV4dC0yMDIwMDMyNy5vcmlnL2ZzL3Bvc2l4X2FjbC5jDQorKysgbGlu
dXgtbmV4dC0yMDIwMDMyNy9mcy9wb3NpeF9hY2wuYw0KQEAgLTEyNCw3ICsxMjQsNyBAQCBzdHJ1
Y3QgcG9zaXhfYWNsICpnZXRfYWNsKHN0cnVjdCBpbm9kZSAqDQogCSAqIGJlIGFuIHVubGlrZWx5
IHJhY2UuKQ0KIAkgKi8NCiAJaWYgKGNtcHhjaGcocCwgQUNMX05PVF9DQUNIRUQsIHNlbnRpbmVs
KSAhPSBBQ0xfTk9UX0NBQ0hFRCkNCi0JCS8qIGZhbGwgdGhyb3VnaCAqLyA7DQorCQlkb19lbXB0
eSgpOyAvKiBmYWxsIHRocm91Z2ggKi8NCiANCiAJLyoNCiAJICogTm9ybWFsbHksIHRoZSBBQ0wg
cmV0dXJuZWQgYnkgLT5nZXRfYWNsIHdpbGwgYmUgY2FjaGVkLgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0t
IGxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0
byBsaW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
