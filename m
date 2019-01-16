Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail2-relais-roc.national.inria.fr
 (mail2-relais-roc.national.inria.fr [192.134.164.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C4CB211B7F66
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 03:05:14 -0800 (PST)
Subject: Re: [PATCH 8/8] device-dax: Add /sys/class/dax backwards compatibility
References: <154095556915.3271337.12581429676272726902.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154095561122.3271337.123035797363130070.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Brice Goglin <Brice.Goglin@inria.fr>
Message-ID: <d1c1c05c-ffc3-619f-5367-90d8a19a449a@inria.fr>
Date: Wed, 16 Jan 2019 12:05:11 +0100
MIME-Version: 1.0
In-Reply-To: <154095561122.3271337.123035797363130070.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

TGUgMzEvMTAvMjAxOCDDoCAwNDoxMywgRGFuIFdpbGxpYW1zIGEgw6ljcml0wqA6Cj4gT24gdGhl
IGV4cGVjdGF0aW9uIHRoYXQgc29tZSBlbnZpcm9ubWVudHMgbWF5IG5vdCB1cGdyYWRlIGxpYmRh
eGN0bAo+ICh1c2Vyc3BhY2UgY29tcG9uZW50IHRoYXQgZGVwZW5kcyBvbiB0aGUgL3N5cy9jbGFz
cy9kYXggaGllcmFyY2h5KSwKPiBwcm92aWRlIGEgZGVmYXVsdCAvIGxlZ2FjeSBkYXhfcG1lbV9j
b21wYXQgZHJpdmVyLiBUaGUgZGF4X3BtZW1fY29tcGF0Cj4gZHJpdmVyIGltcGxlbWVudHMgdGhl
IG9yaWdpbmFsIC9zeXMvY2xhc3MvZGF4IHN5c2ZzIGxheW91dCByYXRoZXIgdGhhbgo+IC9zeXMv
YnVzL2RheC4gV2hlbiB1c2Vyc3BhY2UgaXMgdXBncmFkZWQgaXQgY2FuIGJsYWNrbGlzdCB0aGlz
IG1vZHVsZQo+IGFuZCBzd2l0Y2ggdG8gdGhlIGRheF9wbWVtIGRyaXZlciBnb2luZyBmb3J3YXJk
LgoKCkhlbGxvIERhbgoKSXQgbG9va3MgbGlrZSAvc3lzL2J1cy9kYXgvZGV2aWNlcyByZW1haW5z
IGVtcHR5IGZvcmV2ZXIgaWYKZGF4X3BtZW1fY29tcGF0IGhhcyBldmVyIGJlZW4gbG9hZGVkIGR1
cmluZyB0aGlzIGJvb3QuIFVubG9hZGluZwpkYXhfcG1lbV9jb21wYXQgYW5kIHJlY3JlYXRpbmcg
ZGF4IGRldmljZXMgd2l0aCBuZGN0bCBhZnRlcndhcmRzIGRvZXNuJ3QKbWFrZSB0aGVtIGFwcGVh
ciAobmVpdGhlciBpbiAvc3lzL2NsYXNzL2RheCBvYnZpb3VzbHksIG5vciBpbgovc3lzL2J1cy9k
YXgvZGV2aWNlcyBzdXJwcmlzaW5nbHkpLiBJcyB0aGlzIGV4cGVjdGVkPwoKVGhpbmdzIGFwcGVh
ciBmaW5lIGluIC9zeXMvYnVzL2RheC9kZXZpY2VzIGFmdGVyIGRpc2FibGluZyB0aGUgY29tcGF0
Cm1vZHVsZSBpbiBLY29uZmlnLgoKSSBhbSB1c2luZyB5b3VyIG52ZGltbS1wZW5kaW5nIGJyYW5j
aC4KClRoYW5rcwoKQnJpY2UKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
