Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x243.google.com (mail-qt0-x243.google.com
 [IPv6:2607:f8b0:400d:c0d::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 234CF207E4E1F
 for <linux-nvdimm@lists.01.org>; Mon, 21 May 2018 10:32:24 -0700 (PDT)
Received: by mail-qt0-x243.google.com with SMTP id f13-v6so19894969qtp.10
 for <linux-nvdimm@lists.01.org>; Mon, 21 May 2018 10:32:24 -0700 (PDT)
Subject: Re: [Qemu-devel] [qemu PATCH v4 2/4] tests/.gitignore: add entry for
 generated file
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180521163203.26590-3-ross.zwisler@linux.intel.com>
 <6332df7d-3588-9ecc-6220-2f40c1581fe6@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <be62d517-9b3e-6fe2-7333-b8315e830b4b@amsat.org>
Date: Mon, 21 May 2018 14:32:16 -0300
MIME-Version: 1.0
In-Reply-To: <6332df7d-3588-9ecc-6220-2f40c1581fe6@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Eric Blake <eblake@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Igor Mammedov <imammedo@redhat.com>, qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, qemu block <qemu-block@nongnu.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gMDUvMjEvMjAxOCAwMTo0MSBQTSwgRXJpYyBCbGFrZSB3cm90ZToKPiBPbiAwNS8yMS8yMDE4
IDExOjMyIEFNLCBSb3NzIFp3aXNsZXIgd3JvdGU6Cj4+IEFmdGVyIGEgIm1ha2UgY2hlY2siIHdl
IGVuZCB1cCB3aXRoIHRoZSBmb2xsb3dpbmc6Cj4+Cj4+ICQgZ2l0IHN0YXR1cwo+PiBPbiBicmFu
Y2ggbWFzdGVyCj4+IFlvdXIgYnJhbmNoIGlzIHVwLXRvLWRhdGUgd2l0aCAnb3JpZ2luL21hc3Rl
cicuCj4+Cj4+IFVudHJhY2tlZCBmaWxlczoKPj4gwqDCoCAodXNlICJnaXQgYWRkIDxmaWxlPi4u
LiIgdG8gaW5jbHVkZSBpbiB3aGF0IHdpbGwgYmUgY29tbWl0dGVkKQo+Pgo+PiDCoMKgwqDCoHRl
c3RzL3Rlc3QtYmxvY2stYmFja2VuZAo+Pgo+PiBub3RoaW5nIGFkZGVkIHRvIGNvbW1pdCBidXQg
dW50cmFja2VkIGZpbGVzIHByZXNlbnQgKHVzZSAiZ2l0IGFkZCIgdG8KPj4gdHJhY2spCj4+Cj4+
IFNpZ25lZC1vZmYtYnk6IFJvc3MgWndpc2xlciA8cm9zcy56d2lzbGVyQGxpbnV4LmludGVsLmNv
bT4KPj4gRml4ZXM6IGNvbW1pdCBhZDBkZjNlMGZkYWMgKCJibG9jazogdGVzdCBibGtfYWlvX2Zs
dXNoKCkgd2l0aAo+PiBibGstPnJvb3QgPT0gTlVMTCIpCj4+IENjOiBLZXZpbiBXb2xmIDxrd29s
ZkByZWRoYXQuY29tPgo+PiAtLS0KPj4gwqAgdGVzdHMvLmdpdGlnbm9yZSB8IDEgKwo+PiDCoCAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykKPiAKPiBSZXZpZXdlZC1ieTogRXJpYyBCbGFr
ZSA8ZWJsYWtlQHJlZGhhdC5jb20+Cj4gCj4+Cj4+IGRpZmYgLS1naXQgYS90ZXN0cy8uZ2l0aWdu
b3JlIGIvdGVzdHMvLmdpdGlnbm9yZQo+PiBpbmRleCBmYjYyZDIyOTliLi4yYmM2MWE5YTU4IDEw
MDY0NAo+PiAtLS0gYS90ZXN0cy8uZ2l0aWdub3JlCj4+ICsrKyBiL3Rlc3RzLy5naXRpZ25vcmUK
Pj4gQEAgLTIxLDYgKzIxLDcgQEAgdGVzdC1iYXNlNjQKPj4gwqAgdGVzdC1iZHJ2LWRyYWluCj4+
IMKgIHRlc3QtYml0b3BzCj4+IMKgIHRlc3QtYml0Y250Cj4+ICt0ZXN0LWJsb2NrLWJhY2tlbmQK
Pj4gwqAgdGVzdC1ibG9ja2pvYgo+PiDCoCB0ZXN0LWJsb2Nram9iLXR4bgo+PiDCoCB0ZXN0LWJ1
ZmZlcmlzemVybwoKV2hhdCBhYm91dCB1c2luZyBnaXRpZ25vcmUgbmVnYXRlZCBwYXR0ZXJuIGlu
IHRlc3RzLz8KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
