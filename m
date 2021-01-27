Return-Path: <SRS0=fE4Y=G6=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C4EC433DB
	for <linux-nvdimm@archiver.kernel.org>; Wed, 27 Jan 2021 23:01:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AAD6264DD0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 27 Jan 2021 23:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAD6264DD0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kleine-koenig.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 13D5B100EB340;
	Wed, 27 Jan 2021 15:01:32 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=94.130.110.236; helo=antares.kleine-koenig.org; envelope-from=uwe@kleine-koenig.org; receiver=<UNKNOWN> 
Received: from antares.kleine-koenig.org (antares.kleine-koenig.org [94.130.110.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C1065100EB33D
	for <linux-nvdimm@lists.01.org>; Wed, 27 Jan 2021 15:01:29 -0800 (PST)
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
	id E2374AE0D2A; Thu, 28 Jan 2021 00:01:26 +0100 (CET)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 1/3] device-dax: Prevent registering drivers without probe or remove callback
Date: Thu, 28 Jan 2021 00:01:22 +0100
Message-Id: <20210127230124.109522-1-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Message-ID-Hash: Z4AFUZPD2MDLHXBS6CLHMYFZ2Y4QN44O
X-Message-ID-Hash: Z4AFUZPD2MDLHXBS6CLHMYFZ2Y4QN44O
X-MailFrom: uwe@kleine-koenig.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/Z4AFUZPD2MDLHXBS6CLHMYFZ2Y4QN44O/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhlIGJ1cyBwcm9iZSBhbmQgcmVtb3ZlIGZ1bmN0aW9ucyAoZGF4X2J1c19wcm9iZSBhbmQgZGF4
X2J1c19yZW1vdmUNCnJlc3BlY3RpdmVseSkgY2FsbCB0aGVzZSBmdW5jdGlvbnMgd2l0aG91dCBj
aGVja2luZyB0aGVtIHRvIGJlIG5vbi1OVUxMLg0KQWRkIGEgY2hlY2sgdG8gcHJldmVudCBhIE5V
TEwgcG9pbnRlciBleGNlcHRpb24uDQoNClNpZ25lZC1vZmYtYnk6IFV3ZSBLbGVpbmUtS8O2bmln
IDx1d2VAa2xlaW5lLWtvZW5pZy5vcmc+DQotLS0NCiBkcml2ZXJzL2RheC9idXMuYyB8IDggKysr
KysrKysNCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2RheC9idXMuYyBiL2RyaXZlcnMvZGF4L2J1cy5jDQppbmRleCA3MzdiMjA3YzllMzAu
LjYxOGQ0NjI5NzViYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvZGF4L2J1cy5jDQorKysgYi9kcml2
ZXJzL2RheC9idXMuYw0KQEAgLTEzOTIsNiArMTM5MiwxNCBAQCBpbnQgX19kYXhfZHJpdmVyX3Jl
Z2lzdGVyKHN0cnVjdCBkYXhfZGV2aWNlX2RyaXZlciAqZGF4X2RydiwNCiAJc3RydWN0IGRldmlj
ZV9kcml2ZXIgKmRydiA9ICZkYXhfZHJ2LT5kcnY7DQogCWludCByYyA9IDA7DQogDQorCS8qDQor
CSAqIGRheF9idXNfcHJvYmUoKSBjYWxscyBkYXhfZHJ2LT5wcm9iZSgpIHVuY29uZGl0aW9uYWxs
eSBhbmQNCisJICogZGF4X2J1c19yZW1vdmUoKSBjYWxscyBkYXhfZHJ2LT5yZW1vdmUoKSB1bmNv
bmRpdGlvbmFsbHkuIFNvIGJldHRlcg0KKwkgKiBiZSBzYWZlIHRoYW4gc29ycnkgYW5kIGVuc3Vy
ZSB0aGVzZSBhcmUgcHJvdmlkZWQuDQorCSAqLw0KKwlpZiAoIWRheF9kcnYtPnByb2JlIHx8ICFk
YXhfZHJ2LT5yZW1vdmUpDQorCQlyZXR1cm4gLUVJTlZBTDsNCisNCiAJSU5JVF9MSVNUX0hFQUQo
JmRheF9kcnYtPmlkcyk7DQogCWRydi0+b3duZXIgPSBtb2R1bGU7DQogCWRydi0+bmFtZSA9IG1v
ZF9uYW1lOw0KDQpiYXNlLWNvbW1pdDogNWM4ZmU1ODNjY2U1NDJhYTBiODRhZGM5MzljZTg1Mjkz
ZGUzNmU1ZQ0KLS0gDQoyLjI5LjINCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QgLS0gbGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpUbyB1bnN1YnNjcmliZSBzZW5kIGFuIGVtYWlsIHRvIGxpbnV4LW52ZGltbS1s
ZWF2ZUBsaXN0cy4wMS5vcmcK
