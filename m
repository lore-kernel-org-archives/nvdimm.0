Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC90921283A5A
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 10:52:03 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id j19so10183460otq.2
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 10:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190617122733.22432-1-hch@lst.de>
 <20190617122733.22432-9-hch@lst.de>
In-Reply-To: <20190617122733.22432-9-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Jun 2019 10:51:35 -0700
Message-ID: <CAPcyv4i_0wUJHDqY91R=x5M2o_De+_QKZxPyob5=E9CCv8rM7A@mail.gmail.com>
Subject: Re: [PATCH 08/25] memremap: move dev_pagemap callbacks into a
 separate structure
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, nouveau@lists.freedesktop.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCBKdW4gMTcsIDIwMTkgYXQgNToyNyBBTSBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxz
dC5kZT4gd3JvdGU6Cj4KPiBUaGUgZGV2X3BhZ2VtYXAgaXMgYSBncm93aW5nIHRvbyBtYW55IGNh
bGxiYWNrcy4gIE1vdmUgdGhlbSBpbnRvIGEKPiBzZXBhcmF0ZSBvcHMgc3RydWN0dXJlIHNvIHRo
YXQgdGhleSBhcmUgbm90IGR1cGxpY2F0ZWQgZm9yIG11bHRpcGxlCj4gaW5zdGFuY2VzLCBhbmQg
YW4gYXR0YWNrZXIgY2FuJ3QgZWFzaWx5IG92ZXJ3cml0ZSB0aGVtLgo+Cj4gU2lnbmVkLW9mZi1i
eTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gUmV2aWV3ZWQtYnk6IExvZ2FuIEd1
bnRob3JwZSA8bG9nYW5nQGRlbHRhdGVlLmNvbT4KPiBSZXZpZXdlZC1ieTogSmFzb24gR3VudGhv
cnBlIDxqZ2dAbWVsbGFub3guY29tPgo+IC0tLQo+ICBkcml2ZXJzL2RheC9kZXZpY2UuYyAgICAg
ICAgICAgICAgfCAxMSArKysrKystLS0tCj4gIGRyaXZlcnMvZGF4L3BtZW0vY29yZS5jICAgICAg
ICAgICB8ICAyICstCj4gIGRyaXZlcnMvbnZkaW1tL3BtZW0uYyAgICAgICAgICAgICB8IDE5ICsr
KysrKysrKy0tLS0tLS0KPiAgZHJpdmVycy9wY2kvcDJwZG1hLmMgICAgICAgICAgICAgIHwgIDkg
KysrKystLS0KPiAgaW5jbHVkZS9saW51eC9tZW1yZW1hcC5oICAgICAgICAgIHwgMzYgKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLQo+ICBrZXJuZWwvbWVtcmVtYXAuYyAgICAgICAgICAg
ICAgICAgfCAxOCArKysrKysrKy0tLS0tLS0tCj4gIG1tL2htbS5jICAgICAgICAgICAgICAgICAg
ICAgICAgICB8IDEwICsrKysrKy0tLQo+ICB0b29scy90ZXN0aW5nL252ZGltbS90ZXN0L2lvbWFw
LmMgfCAgOSArKysrLS0tLQo+ICA4IGZpbGVzIGNoYW5nZWQsIDY1IGluc2VydGlvbnMoKyksIDQ5
IGRlbGV0aW9ucygtKQo+ClsuLl0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9udmRpbW0v
dGVzdC9pb21hcC5jIGIvdG9vbHMvdGVzdGluZy9udmRpbW0vdGVzdC9pb21hcC5jCj4gaW5kZXgg
MjE5ZGQwYTFjYjA4Li5hNjY3ZDk3NDE1NWUgMTAwNjQ0Cj4gLS0tIGEvdG9vbHMvdGVzdGluZy9u
dmRpbW0vdGVzdC9pb21hcC5jCj4gKysrIGIvdG9vbHMvdGVzdGluZy9udmRpbW0vdGVzdC9pb21h
cC5jCj4gQEAgLTEwNiwxMSArMTA2LDEwIEBAIEVYUE9SVF9TWU1CT0woX193cmFwX2Rldm1fbWVt
cmVtYXApOwo+Cj4gIHN0YXRpYyB2b2lkIG5maXRfdGVzdF9raWxsKHZvaWQgKl9wZ21hcCkKPiAg
ewo+IC0gICAgICAgc3RydWN0IGRldl9wYWdlbWFwICpwZ21hcCA9IF9wZ21hcDsKCldob29wcywg
bmVlZGVkIHRvIGtlZXAgdGhpcyBsaW5lIHRvIGF2b2lkOgoKdG9vbHMvdGVzdGluZy9udmRpbW0v
dGVzdC9pb21hcC5jOjEwOToxMTogZXJyb3I6IOKAmHBnbWFw4oCZIHVuZGVjbGFyZWQKKGZpcnN0
IHVzZSBpbiB0aGlzIGZ1bmN0aW9uKTsgZGlkIHlvdSBtZWFuIOKAmF9wZ21hcOKAmT8KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
