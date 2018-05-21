Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD8B4207E36DE
 for <linux-nvdimm@lists.01.org>; Mon, 21 May 2018 11:29:37 -0700 (PDT)
Subject: Re: [Qemu-devel] [qemu PATCH v4 2/4] tests/.gitignore: add entry for
 generated file
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180521163203.26590-3-ross.zwisler@linux.intel.com>
 <6332df7d-3588-9ecc-6220-2f40c1581fe6@redhat.com>
 <be62d517-9b3e-6fe2-7333-b8315e830b4b@amsat.org>
From: Eric Blake <eblake@redhat.com>
Message-ID: <cf2f3544-fe8f-4649-6056-f37246009307@redhat.com>
Date: Mon, 21 May 2018 13:29:31 -0500
MIME-Version: 1.0
In-Reply-To: <be62d517-9b3e-6fe2-7333-b8315e830b4b@amsat.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Igor Mammedov <imammedo@redhat.com>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, qemu block <qemu-block@nongnu.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gMDUvMjEvMjAxOCAxMjozMiBQTSwgUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgd3JvdGU6Cgo+
Pj4KPj4+ICDCoMKgwqDCoHRlc3RzL3Rlc3QtYmxvY2stYmFja2VuZAo+Pj4KCj4+PiArdGVzdC1i
bG9jay1iYWNrZW5kCj4+PiAgwqAgdGVzdC1ibG9ja2pvYgo+Pj4gIMKgIHRlc3QtYmxvY2tqb2It
dHhuCj4+PiAgwqAgdGVzdC1idWZmZXJpc3plcm8KPiAKPiBXaGF0IGFib3V0IHVzaW5nIGdpdGln
bm9yZSBuZWdhdGVkIHBhdHRlcm4gaW4gdGVzdHMvPwoKT3IsIHdoYXQgd2UndmUgdGhyZWF0ZW5l
ZCB0byBkbyBpbiB0aGUgcGFzdDogcmVuYW1lIGFsbCB1bml0IHRlc3RzIHRvIAp0aGUgcGF0dGVy
biAqLXRlc3QgaW5zdGVhZCBvZiB0ZXN0LSosIGFzIGEgc3VmZml4IGlzIGEgbG90IGVhc2llciB0
byAKZXhjbHVkZSB2aWEgZ2xvYiB0aGFuIGEgcHJlZml4LiAgQW5kIHdoaWxlIHdlJ3JlIHJlbmFt
aW5nIHRoaW5ncywgc29ydCAKdGVzdHMgaW50byBzZXBhcmF0ZSBzdWJkaXJlY3RvcmllcyBhY2Nv
cmRpbmcgdG8gd2hldGhlciB0aGV5IGFyZSBydW4gYXMgCnBhcnQgb2YgJ21ha2UgY2hlY2stdW5p
dCcgb3IgJ21ha2UgY2hlY2stcXRlc3QnLiAgQnV0IHVudGlsIHNvbWVvbmUgZG9lcyAKdGhhdCB3
b3JrLCB0d2Vha2luZyB0aGUgLmdpdGlnbm9yZSBmb3IgaW5kaXZpZHVhbCB0ZXN0cyBhcyB0aGV5
IGtlZXAgCmdldHRpbmcgYWRkZWQgaXMgbm8gd29yc2UgdGhhbiB3aGF0IHdlJ3ZlIGJlZW4gZG9p
bmcuCgotLSAKRXJpYyBCbGFrZSwgUHJpbmNpcGFsIFNvZnR3YXJlIEVuZ2luZWVyClJlZCBIYXQs
IEluYy4gICAgICAgICAgICsxLTkxOS0zMDEtMzI2NgpWaXJ0dWFsaXphdGlvbjogIHFlbXUub3Jn
IHwgbGlidmlydC5vcmcKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3Jn
Cmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
