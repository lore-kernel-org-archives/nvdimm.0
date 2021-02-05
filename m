Return-Path: <SRS0=3g58=HH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5C3C43333
	for <linux-nvdimm@archiver.kernel.org>; Fri,  5 Feb 2021 22:30:03 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AA30164DD9
	for <linux-nvdimm@archiver.kernel.org>; Fri,  5 Feb 2021 22:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA30164DD9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kleine-koenig.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 35F98100EA2DE;
	Fri,  5 Feb 2021 14:30:02 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a01:4f8:c0c:3a97::2; helo=antares.kleine-koenig.org; envelope-from=uwe@kleine-koenig.org; receiver=<UNKNOWN> 
Received: from antares.kleine-koenig.org (antares.kleine-koenig.org [IPv6:2a01:4f8:c0c:3a97::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3521A100ED4BC
	for <linux-nvdimm@lists.01.org>; Fri,  5 Feb 2021 14:29:05 -0800 (PST)
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
	id 00403AEDF01; Fri,  5 Feb 2021 23:29:03 +0100 (CET)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 5/5] dax-device: Make remove callback return void
Date: Fri,  5 Feb 2021 23:28:42 +0100
Message-Id: <20210205222842.34896-6-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205222842.34896-1-uwe@kleine-koenig.org>
References: <20210205222842.34896-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Message-ID-Hash: 7NGBKTV3BE5EHOLMCGUEOLUTAV4BCU6E
X-Message-ID-Hash: 7NGBKTV3BE5EHOLMCGUEOLUTAV4BCU6E
X-MailFrom: uwe@kleine-koenig.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7NGBKTV3BE5EHOLMCGUEOLUTAV4BCU6E/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhlIGRyaXZlciBjb3JlIGlnbm9yZXMgdGhlIHJldHVybiB2YWx1ZSBvZiBzdHJ1Y3QgYnVzX3R5
cGU6OnJlbW92ZSgpDQpiZWNhdXNlIHRoZXJlIGlzIG9ubHkgbGl0dGxlIHRoYXQgY2FuIGJlIGRv
bmUuIFRvIHNpbXBsaWZ5IHRoZSBxdWVzdCB0bw0KbWFrZSB0aGlzIGZ1bmN0aW9uIHJldHVybiB2
b2lkLCBsZXQgc3RydWN0IGRheF9kZXZpY2VfZHJpdmVyOjpyZW1vdmUoKQ0KcmV0dXJuIHZvaWQs
IHRvby4gQWxsIHVzZXJzIGFscmVhZHkgdW5jb25kaXRpb25hbGx5IHJldHVybiAwLCB0aGlzIGNv
bW1pdA0KbWFrZXMgaXQgb2J2aW91cyB0aGF0IHJldHVybmluZyBhbiBlcnJvciBjb2RlIGlzbid0
IGludGVuZGVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBVd2UgS2xlaW5lLUvDtm5pZyA8dXdlQGtsZWlu
ZS1rb2VuaWcub3JnPg0KLS0tDQogZHJpdmVycy9kYXgvYnVzLmMgIHwgNSArKy0tLQ0KIGRyaXZl
cnMvZGF4L2J1cy5oICB8IDIgKy0NCiBkcml2ZXJzL2RheC9rbWVtLmMgfCA3ICsrLS0tLS0NCiAz
IGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZGF4L2J1cy5jIGIvZHJpdmVycy9kYXgvYnVzLmMNCmluZGV4IGJjNDI1
ZjFjNTJiZC4uMGE5MzllMjhkMDQ4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9kYXgvYnVzLmMNCisr
KyBiL2RyaXZlcnMvZGF4L2J1cy5jDQpAQCAtMTc4LDEyICsxNzgsMTEgQEAgc3RhdGljIGludCBk
YXhfYnVzX3JlbW92ZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQogew0KIAlzdHJ1Y3QgZGF4X2Rldmlj
ZV9kcml2ZXIgKmRheF9kcnYgPSB0b19kYXhfZHJ2KGRldi0+ZHJpdmVyKTsNCiAJc3RydWN0IGRl
dl9kYXggKmRldl9kYXggPSB0b19kZXZfZGF4KGRldik7DQotCWludCByZXQgPSAwOw0KIA0KIAlp
ZiAoZGF4X2Rydi0+cmVtb3ZlKQ0KLQkJcmV0ID0gZGF4X2Rydi0+cmVtb3ZlKGRldl9kYXgpOw0K
KwkJZGF4X2Rydi0+cmVtb3ZlKGRldl9kYXgpOw0KIA0KLQlyZXR1cm4gcmV0Ow0KKwlyZXR1cm4g
MDsNCiB9DQogDQogc3RhdGljIHN0cnVjdCBidXNfdHlwZSBkYXhfYnVzX3R5cGUgPSB7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9kYXgvYnVzLmggYi9kcml2ZXJzL2RheC9idXMuaA0KaW5kZXggNzJi
OTJmOTU1MDlmLi4xZTk0NmFkNzc4MGEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2RheC9idXMuaA0K
KysrIGIvZHJpdmVycy9kYXgvYnVzLmgNCkBAIC0zOSw3ICszOSw3IEBAIHN0cnVjdCBkYXhfZGV2
aWNlX2RyaXZlciB7DQogCXN0cnVjdCBsaXN0X2hlYWQgaWRzOw0KIAlpbnQgbWF0Y2hfYWx3YXlz
Ow0KIAlpbnQgKCpwcm9iZSkoc3RydWN0IGRldl9kYXggKmRldik7DQotCWludCAoKnJlbW92ZSko
c3RydWN0IGRldl9kYXggKmRldik7DQorCXZvaWQgKCpyZW1vdmUpKHN0cnVjdCBkZXZfZGF4ICpk
ZXYpOw0KIH07DQogDQogaW50IF9fZGF4X2RyaXZlcl9yZWdpc3RlcihzdHJ1Y3QgZGF4X2Rldmlj
ZV9kcml2ZXIgKmRheF9kcnYsDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9kYXgva21lbS5jIGIvZHJp
dmVycy9kYXgva21lbS5jDQppbmRleCA0MDNlYzQyNDcyZDEuLmFjMjMxY2MzNjM1OSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvZGF4L2ttZW0uYw0KKysrIGIvZHJpdmVycy9kYXgva21lbS5jDQpAQCAt
MTM2LDcgKzEzNiw3IEBAIHN0YXRpYyBpbnQgZGV2X2RheF9rbWVtX3Byb2JlKHN0cnVjdCBkZXZf
ZGF4ICpkZXZfZGF4KQ0KIH0NCiANCiAjaWZkZWYgQ09ORklHX01FTU9SWV9IT1RSRU1PVkUNCi1z
dGF0aWMgaW50IGRldl9kYXhfa21lbV9yZW1vdmUoc3RydWN0IGRldl9kYXggKmRldl9kYXgpDQor
c3RhdGljIHZvaWQgZGV2X2RheF9rbWVtX3JlbW92ZShzdHJ1Y3QgZGV2X2RheCAqZGV2X2RheCkN
CiB7DQogCWludCBpLCBzdWNjZXNzID0gMDsNCiAJc3RydWN0IGRldmljZSAqZGV2ID0gJmRldl9k
YXgtPmRldjsNCkBAIC0xNzYsMTEgKzE3Niw5IEBAIHN0YXRpYyBpbnQgZGV2X2RheF9rbWVtX3Jl
bW92ZShzdHJ1Y3QgZGV2X2RheCAqZGV2X2RheCkNCiAJCWtmcmVlKGRhdGEpOw0KIAkJZGV2X3Nl
dF9kcnZkYXRhKGRldiwgTlVMTCk7DQogCX0NCi0NCi0JcmV0dXJuIDA7DQogfQ0KICNlbHNlDQot
c3RhdGljIGludCBkZXZfZGF4X2ttZW1fcmVtb3ZlKHN0cnVjdCBkZXZfZGF4ICpkZXZfZGF4KQ0K
K3N0YXRpYyB2b2lkIGRldl9kYXhfa21lbV9yZW1vdmUoc3RydWN0IGRldl9kYXggKmRldl9kYXgp
DQogew0KIAkvKg0KIAkgKiBXaXRob3V0IGhvdHJlbW92ZSBwdXJwb3NlbHkgbGVhayB0aGUgcmVx
dWVzdF9tZW1fcmVnaW9uKCkgZm9yIHRoZQ0KQEAgLTE5MCw3ICsxODgsNiBAQCBzdGF0aWMgaW50
IGRldl9kYXhfa21lbV9yZW1vdmUoc3RydWN0IGRldl9kYXggKmRldl9kYXgpDQogCSAqIHJlcXVl
c3RfbWVtX3JlZ2lvbigpLg0KIAkgKi8NCiAJYW55X2hvdHJlbW92ZV9mYWlsZWQgPSB0cnVlOw0K
LQlyZXR1cm4gMDsNCiB9DQogI2VuZGlmIC8qIENPTkZJR19NRU1PUllfSE9UUkVNT1ZFICovDQog
DQotLSANCjIuMjkuMg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdCAtLSBsaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnClRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwgdG8gbGludXgtbnZkaW1tLWxlYXZlQGxp
c3RzLjAxLm9yZwo=
