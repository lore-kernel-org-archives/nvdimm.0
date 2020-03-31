Return-Path: <SRS0=0pIv=5Q=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22711C43331
	for <linux-nvdimm@archiver.kernel.org>; Tue, 31 Mar 2020 11:51:34 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C88FE20714
	for <linux-nvdimm@archiver.kernel.org>; Tue, 31 Mar 2020 11:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C88FE20714
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5EEAA10FC389F;
	Tue, 31 Mar 2020 04:52:23 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.35; helo=huawei.com; envelope-from=yuehaibing@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9A88C10FC389C
	for <linux-nvdimm@lists.01.org>; Tue, 31 Mar 2020 04:52:20 -0700 (PDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
	by Forcepoint Email with ESMTP id 3180AD57F30DCA01549B;
	Tue, 31 Mar 2020 19:51:27 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Tue, 31 Mar 2020
 19:51:20 +0800
From: YueHaibing <yuehaibing@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <aneesh.kumar@linux.ibm.com>,
	<jmoyer@redhat.com>
Subject: [PATCH v2 -next] libnvdimm/region: Fix build error
Date: Tue, 31 Mar 2020 19:50:24 +0800
Message-ID: <20200331115024.31628-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20200330141943.31696-1-yuehaibing@huawei.com>
References: <20200330141943.31696-1-yuehaibing@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Message-ID-Hash: 7P5CS7QSGGCJQ5LNIHFOKADR56AGUN6H
X-Message-ID-Hash: 7P5CS7QSGGCJQ5LNIHFOKADR56AGUN6H
X-MailFrom: yuehaibing@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7P5CS7QSGGCJQ5LNIHFOKADR56AGUN6H/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gQ09ORklHX1BQQzMyPXkgYnVpbGQgZmFpbHM6DQoNCmRyaXZlcnMvbnZkaW1tL3JlZ2lvbl9k
ZXZzLmM6MTAzNDoxNDogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmGRvX2RpduKAmQ0K
ICByZW1haW5kZXIgPSBkb19kaXYocGVyX21hcHBpbmcsIG1hcHBpbmdzKTsNCiAgICAgICAgICAg
ICAgXn5+fn5+DQpJbiBmaWxlIGluY2x1ZGVkIGZyb20gLi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9n
ZW5lcmF0ZWQvYXNtL2RpdjY0Lmg6MTowLA0KICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVk
ZS9saW51eC9rZXJuZWwuaDoxOCwNCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvYXNt
LWdlbmVyaWMvYnVnLmg6MTksDQogICAgICAgICAgICAgICAgIGZyb20gLi9hcmNoL3Bvd2VycGMv
aW5jbHVkZS9hc20vYnVnLmg6MTA5LA0KICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9s
aW51eC9idWcuaDo1LA0KICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9zY2F0
dGVybGlzdC5oOjcsDQogICAgICAgICAgICAgICAgIGZyb20gZHJpdmVycy9udmRpbW0vcmVnaW9u
X2RldnMuYzo1Og0KLi9pbmNsdWRlL2FzbS1nZW5lcmljL2RpdjY0Lmg6MjQzOjIyOiBlcnJvcjog
cGFzc2luZyBhcmd1bWVudCAxIG9mIOKAmF9fZGl2NjRfMzLigJkgZnJvbSBpbmNvbXBhdGlibGUg
cG9pbnRlciB0eXBlIFstV2Vycm9yPWluY29tcGF0aWJsZS1wb2ludGVyLXR5cGVzXQ0KICAgX19y
ZW0gPSBfX2RpdjY0XzMyKCYobiksIF9fYmFzZSk7IFwNCg0KVXNlIGRpdl91NjQgaW5zdGVhZCBv
ZiBkb19kaXYgdG8gZml4IHRoaXMuDQoNCkZpeGVzOiAyNTIyYWZiODZhOGMgKCJsaWJudmRpbW0v
cmVnaW9uOiBJbnRyb2R1Y2UgYW4gJ2FsaWduJyBhdHRyaWJ1dGUiKQ0KU2lnbmVkLW9mZi1ieTog
WXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KLS0tDQp2MjogdXNlIGRpdl91NjRf
cmVtIGFuZCBjb2RlIGNsZWFudXANCi0tLQ0KIGRyaXZlcnMvbnZkaW1tL3JlZ2lvbl9kZXZzLmMg
fCA4ICsrKy0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlv
bnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL3JlZ2lvbl9kZXZzLmMgYi9kcml2
ZXJzL252ZGltbS9yZWdpb25fZGV2cy5jDQppbmRleCBiZjIzOWU3ODM5NDAuLmNjYmI1YjQzYjhi
MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbnZkaW1tL3JlZ2lvbl9kZXZzLmMNCisrKyBiL2RyaXZl
cnMvbnZkaW1tL3JlZ2lvbl9kZXZzLmMNCkBAIC01NjMsOCArNTYzLDcgQEAgc3RhdGljIHNzaXpl
X3QgYWxpZ25fc3RvcmUoc3RydWN0IGRldmljZSAqZGV2LA0KIAkgKiBjb250cmlidXRlIHRvIHRo
ZSB0YWlsIGNhcGFjaXR5IGluIHN5c3RlbS1waHlzaWNhbC1hZGRyZXNzDQogCSAqIHNwYWNlIGZv
ciB0aGUgbmFtZXNwYWNlLg0KIAkgKi8NCi0JZHBhID0gdmFsOw0KLQlyZW1haW5kZXIgPSBkb19k
aXYoZHBhLCBuZF9yZWdpb24tPm5kcl9tYXBwaW5ncyk7DQorCWRwYSA9IGRpdl91NjRfcmVtKHZh
bCwgbmRfcmVnaW9uLT5uZHJfbWFwcGluZ3MsICZyZW1haW5kZXIpOw0KIAlpZiAoIWlzX3Bvd2Vy
X29mXzIoZHBhKSB8fCBkcGEgPCBQQUdFX1NJWkUNCiAJCQl8fCB2YWwgPiByZWdpb25fc2l6ZShu
ZF9yZWdpb24pIHx8IHJlbWFpbmRlcikNCiAJCXJldHVybiAtRUlOVkFMOw0KQEAgLTEwMTAsNyAr
MTAwOSw3IEBAIEVYUE9SVF9TWU1CT0wobmRfcmVnaW9uX3JlbGVhc2VfbGFuZSk7DQogDQogc3Rh
dGljIHVuc2lnbmVkIGxvbmcgZGVmYXVsdF9hbGlnbihzdHJ1Y3QgbmRfcmVnaW9uICpuZF9yZWdp
b24pDQogew0KLQl1bnNpZ25lZCBsb25nIGFsaWduLCBwZXJfbWFwcGluZzsNCisJdW5zaWduZWQg
bG9uZyBhbGlnbjsNCiAJaW50IGksIG1hcHBpbmdzOw0KIAl1MzIgcmVtYWluZGVyOw0KIA0KQEAg
LTEwMzAsOCArMTAyOSw3IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIGRlZmF1bHRfYWxpZ24oc3Ry
dWN0IG5kX3JlZ2lvbiAqbmRfcmVnaW9uKQ0KIAl9DQogDQogCW1hcHBpbmdzID0gbWF4X3QodTE2
LCAxLCBuZF9yZWdpb24tPm5kcl9tYXBwaW5ncyk7DQotCXBlcl9tYXBwaW5nID0gYWxpZ247DQot
CXJlbWFpbmRlciA9IGRvX2RpdihwZXJfbWFwcGluZywgbWFwcGluZ3MpOw0KKwlkaXZfdTY0X3Jl
bShhbGlnbiwgbWFwcGluZ3MsICZyZW1haW5kZXIpOw0KIAlpZiAocmVtYWluZGVyKQ0KIAkJYWxp
Z24gKj0gbWFwcGluZ3M7DQogDQotLSANCjIuMTcuMQ0KDQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0IC0tIGxp
bnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKVG8gdW5zdWJzY3JpYmUgc2VuZCBhbiBlbWFpbCB0byBs
aW51eC1udmRpbW0tbGVhdmVAbGlzdHMuMDEub3JnCg==
