Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw1-f67.google.com (mail-yw1-f67.google.com
 [209.85.161.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94BCD21161235
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 15:23:30 -0700 (PDT)
Received: by mail-yw1-f67.google.com with SMTP id v1-v6so6214089ywv.6
 for <linux-nvdimm@lists.01.org>; Mon, 01 Oct 2018 15:23:30 -0700 (PDT)
Subject: Re: [PATCH v8 13/13] nvmet: Optionally use PCI P2P memory
References: <20180927165420.5290-1-logang@deltatee.com>
 <20180927165420.5290-14-logang@deltatee.com>
 <5ddeed51-0580-9581-cf12-c75e18b4f7cc@grimberg.me>
 <69cd8aab-b94e-98f5-5397-48bb875e8280@deltatee.com>
From: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <b790b11f-41df-f495-fdd1-d8bd6d6b7dd6@grimberg.me>
Date: Mon, 1 Oct 2018 15:23:25 -0700
MIME-Version: 1.0
In-Reply-To: <69cd8aab-b94e-98f5-5397-48bb875e8280@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Steve Wise <swise@opengridcomputing.com>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Cj4+PiArLyoKPj4+ICsgKiBJZiBhbGxvd19wMnBtZW0gaXMgc2V0LCB3ZSB3aWxsIHRyeSB0byB1
c2UgUDJQIG1lbW9yeSBmb3IgdGhlIFNHTCBsaXN0cyBmb3IKPj4+ICsgKiDOmS9PIGNvbW1hbmRz
LiBUaGlzIHJlcXVpcmVzIHRoZSBQQ0kgcDJwIGRldmljZSB0byBiZSBjb21wYXRpYmxlIHdpdGgg
dGhlCj4+PiArICogYmFja2luZyBkZXZpY2UgZm9yIGV2ZXJ5IG5hbWVzcGFjZSBvbiB0aGlzIGNv
bnRyb2xsZXIuCj4+PiArICovCj4+PiArc3RhdGljIHZvaWQgbnZtZXRfc2V0dXBfcDJwbWVtKHN0
cnVjdCBudm1ldF9jdHJsICpjdHJsLCBzdHJ1Y3QgbnZtZXRfcmVxICpyZXEpCj4+PiArewo+Pj4g
KwlzdHJ1Y3QgbnZtZXRfbnMgKm5zOwo+Pj4gKwlpbnQgcmV0Owo+Pj4gKwo+Pj4gKwlpZiAoIXJl
cS0+cG9ydC0+dXNlX3AycG1lbSB8fCAhcmVxLT5wMnBfY2xpZW50KQo+Pj4gKwkJcmV0dXJuOwo+
Pgo+PiBOaXQsIElNTyB3b3VsZCBiZSBiZXR0ZXIgdG8gY2hlY2sgYXQgdGhlIGNhbGwtc2l0ZSwg
YnV0IG5vdCBhIGhhcmQKPj4gbXVzdC4uLgo+IAo+IEknZCByYXRoZXIga2VlcCB0aGUgbG9naWMg
Zm9yIHdoZXRoZXIgdG8gZW5hYmxlIHAycG1lbSBpbiBpdCdzIG93bgo+IGZ1bmN0aW9uLiBudm1l
X2FsbG9jX2N0cmwoKSBpcyBhbHJlYWR5IHZlcnkgbG9uZyBhbmQgY29tcGxpY2F0ZWQuCgpGYWly
IGVub3VnaC4uCgo+PiBJIHN0aWxsIGRvIG5vdCBmdWxseSB1bmRlcnN0YW5kIHdoeSBwMnBfZGV2
IGhhcyB0byBiZSBjdHJsLXdpZGUgYW5kIG5vdAo+PiBwZXIgbmFtZXNwYWNlLiBTb3JyeSB0byBr
ZWVwIGJyaW5naW5nIHRoaXMgdXAgKGFnYWluKS4gQnV0IGlmIHBlb3BsZSBhcmUKPj4gT0sgd2l0
aCBpdCB0aGVuIEkgZ3Vlc3MgSSBjYW4gc3RvcCBhc2tpbmcgYWJvdXQgdGhpcy4uLgo+IAo+IEJl
Y2F1c2UgeW91IG5ldmVyIGFuc3dlcmVkIG15IHF1ZXN0aW9uIGJhY2sgaW4gTWFyY2hbMV0gKHdo
aWNoIEkgdGhpbmsKPiB5b3UndmUgYW5zd2VyZWQgYmVsb3cpLi4uLgoKSSdtIHNvcnJ5Li4uIEkg
bG9zdCB0cmFja2luZyBvbiB0aGlzLi4uCgo+PiBJIHRoaW5rIHRoYXQgYXQgc29tZSBwb2ludCB3
ZSBzYWlkIHRoYXQgdGhpcyBsb29rcyBsaWtlIGl0IHNob3VsZCBmYWxsCj4+IGJhY2sgdG8gaG9z
dCBtZW1vcnkgZm9yIHRob3NlIG5hbWVzcGFjZXMuLiB3aGVuIHdlIGFsbG9jYXRlIHRoZSBzZ2wg
d2UKPj4gYWxyZWFkeSBhc3NpZ25lZCBhIG5hbWVzcGFjZSB0byB0aGUgcmVxdWVzdCAobnZtZXRf
cmVxX2luaXQpLgo+IAo+IEkgZGlkIG5vdCByZWFsaXplIHRoZSBuYW1lc3BhY2Ugd291bGQgYmUg
YXZhaWxhYmxlIGF0IHRoaXMgdGltZS4gSSBndWVzcwo+IEkgY2FuIGdpdmUgdGhpcyBhIHRyeSwg
YnV0IGl0J3MgZ29pbmcgdG8gYmUgYSBmYWlybHkgYmlnIGNoYW5nZSBmcm9tCj4gd2hhdCdzIHBy
ZXNlbnRlZCBoZXJlLi4uIFRob3VnaCwgSSBhZ3JlZSBpdCdsbCBwcm9iYWJseSBiZSBhbiBpbXBy
b3ZlbWVudC4KClRoYW5rcywgaWYgaXQgdHVybnMgb3V0IHRvIGNyZWF0ZSB0byBtdWNoIG9mIGEg
Y2h1cm4sIHdlIGNvdWxkIGRlZmVyCnRoYXQgdG8gYSBsYXRlciBzdGFnZSwgYnV0IHdlIGNhbiBh
dCBsZWFzdCBkb2N1bWVudCBpdC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
