Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C186211B76AA
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 10:09:59 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id t204so3940513oie.7
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 10:09:59 -0800 (PST)
MIME-Version: 1.0
References: <154095556915.3271337.12581429676272726902.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154095561122.3271337.123035797363130070.stgit@dwillia2-desk3.amr.corp.intel.com>
 <d1c1c05c-ffc3-619f-5367-90d8a19a449a@inria.fr>
In-Reply-To: <d1c1c05c-ffc3-619f-5367-90d8a19a449a@inria.fr>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Jan 2019 10:09:47 -0800
Message-ID: <CAPcyv4gyhR9bGetOcGANCBB78av4_j2aWebyCTzXYrCK8w0HrA@mail.gmail.com>
Subject: Re: [PATCH 8/8] device-dax: Add /sys/class/dax backwards compatibility
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
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCBKYW4gMTYsIDIwMTkgYXQgMzowNSBBTSBCcmljZSBHb2dsaW4gPEJyaWNlLkdvZ2xp
bkBpbnJpYS5mcj4gd3JvdGU6Cj4KPiBMZSAzMS8xMC8yMDE4IMOgIDA0OjEzLCBEYW4gV2lsbGlh
bXMgYSDDqWNyaXQgOgo+ID4gT24gdGhlIGV4cGVjdGF0aW9uIHRoYXQgc29tZSBlbnZpcm9ubWVu
dHMgbWF5IG5vdCB1cGdyYWRlIGxpYmRheGN0bAo+ID4gKHVzZXJzcGFjZSBjb21wb25lbnQgdGhh
dCBkZXBlbmRzIG9uIHRoZSAvc3lzL2NsYXNzL2RheCBoaWVyYXJjaHkpLAo+ID4gcHJvdmlkZSBh
IGRlZmF1bHQgLyBsZWdhY3kgZGF4X3BtZW1fY29tcGF0IGRyaXZlci4gVGhlIGRheF9wbWVtX2Nv
bXBhdAo+ID4gZHJpdmVyIGltcGxlbWVudHMgdGhlIG9yaWdpbmFsIC9zeXMvY2xhc3MvZGF4IHN5
c2ZzIGxheW91dCByYXRoZXIgdGhhbgo+ID4gL3N5cy9idXMvZGF4LiBXaGVuIHVzZXJzcGFjZSBp
cyB1cGdyYWRlZCBpdCBjYW4gYmxhY2tsaXN0IHRoaXMgbW9kdWxlCj4gPiBhbmQgc3dpdGNoIHRv
IHRoZSBkYXhfcG1lbSBkcml2ZXIgZ29pbmcgZm9yd2FyZC4KPgo+Cj4gSGVsbG8gRGFuCj4KPiBJ
dCBsb29rcyBsaWtlIC9zeXMvYnVzL2RheC9kZXZpY2VzIHJlbWFpbnMgZW1wdHkgZm9yZXZlciBp
Zgo+IGRheF9wbWVtX2NvbXBhdCBoYXMgZXZlciBiZWVuIGxvYWRlZCBkdXJpbmcgdGhpcyBib290
LiBVbmxvYWRpbmcKPiBkYXhfcG1lbV9jb21wYXQgYW5kIHJlY3JlYXRpbmcgZGF4IGRldmljZXMg
d2l0aCBuZGN0bCBhZnRlcndhcmRzIGRvZXNuJ3QKPiBtYWtlIHRoZW0gYXBwZWFyIChuZWl0aGVy
IGluIC9zeXMvY2xhc3MvZGF4IG9idmlvdXNseSwgbm9yIGluCj4gL3N5cy9idXMvZGF4L2Rldmlj
ZXMgc3VycHJpc2luZ2x5KS4gSXMgdGhpcyBleHBlY3RlZD8KPgo+IFRoaW5ncyBhcHBlYXIgZmlu
ZSBpbiAvc3lzL2J1cy9kYXgvZGV2aWNlcyBhZnRlciBkaXNhYmxpbmcgdGhlIGNvbXBhdAo+IG1v
ZHVsZSBpbiBLY29uZmlnLgo+Cj4gSSBhbSB1c2luZyB5b3VyIG52ZGltbS1wZW5kaW5nIGJyYW5j
aC4KClRoYW5rcyBmb3IgdHJ5aW5nIGl0IG91dCEKClNvIHRoZSBrZXJuZWwgYnkgaXRzZWxmIHdp
bGwgbm90IG9wdCB5b3UgaW4gdG8gdGhlIG5ldyBkZXZpY2UtbW9kZWwuCklmIGRheF9wbWVtX2Nv
bXBhdCBpcyBhdmFpbGFibGUgdGhlbiBpdCBuZWVkcyB0byBiZSBleHBsaWNpdGx5CmRpc2FibGVk
IHdpdGggYSBtb2Rwcm9iZSBwb2xpY3kuIEZvciBleGFtcGxlIGhlcmUncyBhIGJlZm9yZSBhbiBh
ZnRlcgpvZiBvcHRpbmctaW4gdG8gL3N5cy9idXMvZGF4OgoKIyBscyAvc3lzL2NsYXNzL2RheApk
YXgwLjAKIyBuZGN0bCBkaXNhYmxlLXJlZ2lvbiBhbGwKZGlzYWJsZWQgMyByZWdpb25zCiMgZGF4
Y3RsIG1pZ3JhdGUtZGV2aWNlLW1vZGVsCiBTdWNjZXNzOiBpbnN0YWxsZWQgL2V0Yy9tb2Rwcm9i
ZS5kL2RheGN0bC5jb25mCiMgbW9kcHJvYmUgLXIgZGF4X3BtZW1fY29tcGF0CiMgbHNtb2QgfCBn
cmVwIGRheAojIG5kY3RsIGVuYWJsZS1yZWdpb24gYWxsCmVuYWJsZWQgMyByZWdpb25zCiMgbHMg
L3N5cy9jbGFzcy9kYXgKPC0tLS0gbm8gb3V0cHV0LCBpdCdzIG5vdyBnb25lLgoKVGhlIHBhdGNo
IHRoYXQgaW50cm9kdWNlcyAiZGF4Y3RsIG1pZ3JhdGUtZGV2aWNlLW1vZGVsIiBpcyBoZXJlOgpo
dHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzEwNzYzOTk3LwoKSG93ZXZlciwgYmVo
aW5kIHRoZSBzY2VuZXMgYWxsIHRoYXQgaXMgZG9pbmcgaXMgaW5zdGFsbGluZwovZXRjL21vZHBy
b2JlLmQvZGF4Y3RsLmNvbmYgd2l0aCB0aGUgZm9sbG93aW5nIGNvbnRlbnRzOgoKYmxhY2tsaXN0
IGRheF9wbWVtX2NvbXBhdAphbGlhcyBuZDp0NyogZGF4X3BtZW0KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
