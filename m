Return-Path: <SRS0=3g58=HH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_20,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D017BC433E9
	for <linux-nvdimm@archiver.kernel.org>; Fri,  5 Feb 2021 22:29:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E6B564FEE
	for <linux-nvdimm@archiver.kernel.org>; Fri,  5 Feb 2021 22:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E6B564FEE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kleine-koenig.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C8A43100EA2D3;
	Fri,  5 Feb 2021 14:29:28 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=94.130.110.236; helo=antares.kleine-koenig.org; envelope-from=uwe@kleine-koenig.org; receiver=<UNKNOWN> 
Received: from antares.kleine-koenig.org (antares.kleine-koenig.org [94.130.110.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D7D36100ED4BC
	for <linux-nvdimm@lists.01.org>; Fri,  5 Feb 2021 14:29:01 -0800 (PST)
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
	id D58D6AEDEFB; Fri,  5 Feb 2021 23:28:59 +0100 (CET)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/5] dax-device: Properly handle drivers without remove callback
Date: Fri,  5 Feb 2021 23:28:39 +0100
Message-Id: <20210205222842.34896-3-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205222842.34896-1-uwe@kleine-koenig.org>
References: <20210205222842.34896-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Message-ID-Hash: 7OREFJMUE52KHS563FFMHFJAAQOFKOO5
X-Message-ID-Hash: 7OREFJMUE52KHS563FFMHFJAAQOFKOO5
X-MailFrom: uwe@kleine-koenig.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7OREFJMUE52KHS563FFMHFJAAQOFKOO5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SWYgYWxsIHJlc291cmNlcyBhcmUgYWxsb2NhdGVkIGluIC5wcm9iZSgpIHVzaW5nIGRldm1fIGZ1
bmN0aW9ucyBpdA0KbWlnaHQgbWFrZSBzZW5zZSB0byBub3QgcHJvdmlkZSBhIC5yZW1vdmUoKSBj
YWxsYmFjay4gVGhlbiB0aGUgcmlnaHQNCnRoaW5nIGlzIHRvIGp1c3QgcmV0dXJuIHN1Y2Nlc3Mu
DQoNClNpZ25lZC1vZmYtYnk6IFV3ZSBLbGVpbmUtS8O2bmlnIDx1d2VAa2xlaW5lLWtvZW5pZy5v
cmc+DQotLS0NCiBkcml2ZXJzL2RheC9idXMuYyB8IDYgKysrKystDQogMSBmaWxlIGNoYW5nZWQs
IDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9k
YXgvYnVzLmMgYi9kcml2ZXJzL2RheC9idXMuYw0KaW5kZXggNzJmYzRiOWI5YWU2Li4yYzllM2Y2
ZjYxNWYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2RheC9idXMuYw0KKysrIGIvZHJpdmVycy9kYXgv
YnVzLmMNCkBAIC0xNzgsOCArMTc4LDEyIEBAIHN0YXRpYyBpbnQgZGF4X2J1c19yZW1vdmUoc3Ry
dWN0IGRldmljZSAqZGV2KQ0KIHsNCiAJc3RydWN0IGRheF9kZXZpY2VfZHJpdmVyICpkYXhfZHJ2
ID0gdG9fZGF4X2RydihkZXYtPmRyaXZlcik7DQogCXN0cnVjdCBkZXZfZGF4ICpkZXZfZGF4ID0g
dG9fZGV2X2RheChkZXYpOw0KKwlpbnQgcmV0ID0gMDsNCiANCi0JcmV0dXJuIGRheF9kcnYtPnJl
bW92ZShkZXZfZGF4KTsNCisJaWYgKGRheF9kcnYtPnJlbW92ZSkNCisJCXJldCA9IGRheF9kcnYt
PnJlbW92ZShkZXZfZGF4KTsNCisNCisJcmV0dXJuIHJldDsNCiB9DQogDQogc3RhdGljIHN0cnVj
dCBidXNfdHlwZSBkYXhfYnVzX3R5cGUgPSB7DQotLSANCjIuMjkuMg0KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlz
dCAtLSBsaW51eC1udmRpbW1AbGlzdHMuMDEub3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1h
aWwgdG8gbGludXgtbnZkaW1tLWxlYXZlQGxpc3RzLjAxLm9yZwo=
