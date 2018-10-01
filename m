Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DCBB21161235
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 14:55:44 -0700 (PDT)
References: <20180927165420.5290-1-logang@deltatee.com>
 <20180927165420.5290-14-logang@deltatee.com>
 <5ddeed51-0580-9581-cf12-c75e18b4f7cc@grimberg.me>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <69cd8aab-b94e-98f5-5397-48bb875e8280@deltatee.com>
Date: Mon, 1 Oct 2018 15:55:16 -0600
MIME-Version: 1.0
In-Reply-To: <5ddeed51-0580-9581-cf12-c75e18b4f7cc@grimberg.me>
Content-Language: en-CA
Subject: Re: [PATCH v8 13/13] nvmet: Optionally use PCI P2P memory
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
To: Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Steve Wise <swise@opengridcomputing.com>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAyMDE4LTEwLTAxIDM6MzQgcC5tLiwgU2FnaSBHcmltYmVyZyB3cm90ZToKPj4gKwo+PiAr
CWxpc3RfZm9yX2VhY2hfZW50cnkoY3RybCwgJnN1YnN5cy0+Y3RybHMsIHN1YnN5c19lbnRyeSkg
ewo+PiArCQlwY2lfcDJwZG1hX3JlbW92ZV9jbGllbnQoJmN0cmwtPnAycF9jbGllbnRzLCBudm1l
dF9uc19kZXYobnMpKTsKPj4gKwkJbnZtZXRfYWRkX2FzeW5jX2V2ZW50KGN0cmwsIE5WTUVfQUVS
X1RZUEVfTk9USUNFLCAwLCAwKTsKPiAKPiBIaSBMb2dhbiwgd2hhdCBpcyB0aGlzIGV2ZW50IGhl
cmU/CgpPb3BzLCB0aGF0IG11c3QgaGF2ZSBiZWVuIGZyb20gYSBiYWQgcmViYXNlLi4uLiBXaWxs
IEZpeC4KCj4+ICsJCWlmIChzcS0+cWlkICYmIHAycF9kZXYpIHsKPj4gKwkJCXJlcS0+c2cgPSBw
Y2lfcDJwbWVtX2FsbG9jX3NnbChwMnBfZGV2LCAmcmVxLT5zZ19jbnQsCj4+ICsJCQkJCQkgICAg
ICAgcmVxLT50cmFuc2Zlcl9sZW4pOwo+PiArCQkJaWYgKHJlcS0+c2cpIHsKPj4gKwkJCQlyZXEt
PnAycF9kZXYgPSBwMnBfZGV2Owo+PiArCQkJCXJldHVybiAwOwo+PiArCQkJfQo+IAo+IFdvdWxk
IGJlIHVzZWZ1bCB0byBjb21tZW50IHRoYXQgd2UgZmFsbCB0byBub3JtYWwgc2dsIGFsbG9jYXRp
b24uCgpPay4KCj4+ICsvKgo+PiArICogSWYgYWxsb3dfcDJwbWVtIGlzIHNldCwgd2Ugd2lsbCB0
cnkgdG8gdXNlIFAyUCBtZW1vcnkgZm9yIHRoZSBTR0wgbGlzdHMgZm9yCj4+ICsgKiDOmS9PIGNv
bW1hbmRzLiBUaGlzIHJlcXVpcmVzIHRoZSBQQ0kgcDJwIGRldmljZSB0byBiZSBjb21wYXRpYmxl
IHdpdGggdGhlCj4+ICsgKiBiYWNraW5nIGRldmljZSBmb3IgZXZlcnkgbmFtZXNwYWNlIG9uIHRo
aXMgY29udHJvbGxlci4KPj4gKyAqLwo+PiArc3RhdGljIHZvaWQgbnZtZXRfc2V0dXBfcDJwbWVt
KHN0cnVjdCBudm1ldF9jdHJsICpjdHJsLCBzdHJ1Y3QgbnZtZXRfcmVxICpyZXEpCj4+ICt7Cj4+
ICsJc3RydWN0IG52bWV0X25zICpuczsKPj4gKwlpbnQgcmV0Owo+PiArCj4+ICsJaWYgKCFyZXEt
PnBvcnQtPnVzZV9wMnBtZW0gfHwgIXJlcS0+cDJwX2NsaWVudCkKPj4gKwkJcmV0dXJuOwo+IAo+
IE5pdCwgSU1PIHdvdWxkIGJlIGJldHRlciB0byBjaGVjayBhdCB0aGUgY2FsbC1zaXRlLCBidXQg
bm90IGEgaGFyZAo+IG11c3QuLi4KCkknZCByYXRoZXIga2VlcCB0aGUgbG9naWMgZm9yIHdoZXRo
ZXIgdG8gZW5hYmxlIHAycG1lbSBpbiBpdCdzIG93bgpmdW5jdGlvbi4gbnZtZV9hbGxvY19jdHJs
KCkgaXMgYWxyZWFkeSB2ZXJ5IGxvbmcgYW5kIGNvbXBsaWNhdGVkLgoKPiBJIHN0aWxsIGRvIG5v
dCBmdWxseSB1bmRlcnN0YW5kIHdoeSBwMnBfZGV2IGhhcyB0byBiZSBjdHJsLXdpZGUgYW5kIG5v
dAo+IHBlciBuYW1lc3BhY2UuIFNvcnJ5IHRvIGtlZXAgYnJpbmdpbmcgdGhpcyB1cCAoYWdhaW4p
LiBCdXQgaWYgcGVvcGxlIGFyZQo+IE9LIHdpdGggaXQgdGhlbiBJIGd1ZXNzIEkgY2FuIHN0b3Ag
YXNraW5nIGFib3V0IHRoaXMuLi4KCkJlY2F1c2UgeW91IG5ldmVyIGFuc3dlcmVkIG15IHF1ZXN0
aW9uIGJhY2sgaW4gTWFyY2hbMV0gKHdoaWNoIEkgdGhpbmsKeW91J3ZlIGFuc3dlcmVkIGJlbG93
KS4uLi4KCj4gSSB0aGluayB0aGF0IGF0IHNvbWUgcG9pbnQgd2Ugc2FpZCB0aGF0IHRoaXMgbG9v
a3MgbGlrZSBpdCBzaG91bGQgZmFsbAo+IGJhY2sgdG8gaG9zdCBtZW1vcnkgZm9yIHRob3NlIG5h
bWVzcGFjZXMuLiB3aGVuIHdlIGFsbG9jYXRlIHRoZSBzZ2wgd2UKPiBhbHJlYWR5IGFzc2lnbmVk
IGEgbmFtZXNwYWNlIHRvIHRoZSByZXF1ZXN0IChudm1ldF9yZXFfaW5pdCkuCgpJIGRpZCBub3Qg
cmVhbGl6ZSB0aGUgbmFtZXNwYWNlIHdvdWxkIGJlIGF2YWlsYWJsZSBhdCB0aGlzIHRpbWUuIEkg
Z3Vlc3MKSSBjYW4gZ2l2ZSB0aGlzIGEgdHJ5LCBidXQgaXQncyBnb2luZyB0byBiZSBhIGZhaXJs
eSBiaWcgY2hhbmdlIGZyb20Kd2hhdCdzIHByZXNlbnRlZCBoZXJlLi4uIFRob3VnaCwgSSBhZ3Jl
ZSBpdCdsbCBwcm9iYWJseSBiZSBhbiBpbXByb3ZlbWVudC4KCkxvZ2FuCgpbMV0KaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGttbC83MTYzYWY5My0yZjM3LWE4YjYtOTg2YS0zY2IyZTYyYmVlMjlA
ZGVsdGF0ZWUuY29tL1QvI3UKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
