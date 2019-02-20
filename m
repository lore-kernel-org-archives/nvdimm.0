Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37FDA208F6108
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 00:29:21 -0800 (PST)
Subject: Re: [PATCH] acpi/nfit: Fix bus command validation
References: <154958385172.3932544.193235520333886200.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49lg2bql2v.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iiZS_zfroRtmS-zD-cCDj1yQonBsWM23utR9m9kiBizA@mail.gmail.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <b1f73551-5c11-3651-dc6f-5cdcf815e0d0@suse.de>
Date: Wed, 20 Feb 2019 09:29:19 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iiZS_zfroRtmS-zD-cCDj1yQonBsWM23utR9m9kiBizA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Vishal Verma <vishal.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gMjAvMDIvMjAxOSAwMzo1OCwgRGFuIFdpbGxpYW1zIHdyb3RlOgpbLi4uXQoKPj4KPj4gVHJp
Y2t5IGNvZGUgcGF0aCwgZWg/Cj4gCj4gaW9jdGwgcGF0aCwgbnVtYmVyIG9uZSBzb3VyY2Ugb2Yg
YnVncyAvIHRocmFzaCBpbiB0aGlzIHN1YnN5c3RlbS4gMm5kCj4gcGxhY2UsIEFSUy4KClBvc3Np
Ymx5IHVucG9wdWxhciBpZGVhLCBidXQgc2hvdWxkIHdlIG1heWJlIHRlYWNoIHRyaW5pdHkvc3l6
Y2FsbGVyCmFib3V0IHRoZXNlIGlvY3RsKClzPwoKQmV0dGVyIHdlIGZpbmQgdGhlIGJ1Z3MgaW4g
YSBRQSBsaWtlIGVudmlyb25tZW50IHRoYW4gaW4gdGhlIGZpbGVkLCBJIGd1ZXNzPwoKQnl0ZSwK
CUpvaGFubmVzCi0tIApKb2hhbm5lcyBUaHVtc2hpcm4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgU1VTRSBMYWJzIEZpbGVzeXN0ZW1zCmp0aHVtc2hpcm5Ac3VzZS5kZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODkKU1VTRSBMSU5VWCBHbWJILCBNYXhm
ZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBT
bWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKS2V5IGZpbmdl
cnByaW50ID0gRUMzOCA5Q0FCIEMyQzQgRjI1RCA4NjAwIEQwRDAgMDM5MyA5NjlEIDJENzYgMDg1
MApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0
cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
