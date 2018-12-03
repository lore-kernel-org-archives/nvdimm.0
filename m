Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84CAE2118EF7E
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 09:16:13 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id a11so12288492otr.10
 for <linux-nvdimm@lists.01.org>; Mon, 03 Dec 2018 09:16:13 -0800 (PST)
MIME-Version: 1.0
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
 <ffeb6225-6d5c-099e-3158-4711c879ec23@gmail.com>
 <48d78370-438d-65fa-370c-4cf61a27ed3d@intel.com>
In-Reply-To: <48d78370-438d-65fa-370c-4cf61a27ed3d@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 3 Dec 2018 09:16:01 -0800
Message-ID: <CAPcyv4jU1A93J4pqme3bGHE_KJE2TZ_F9pncgesuksT8YaR-FQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] Allow persistent memory to be used like normal RAM
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Brice Goglin <brice.goglin@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, zwisler@kernel.org, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCBEZWMgMywgMjAxOCBhdCA4OjU2IEFNIERhdmUgSGFuc2VuIDxkYXZlLmhhbnNlbkBp
bnRlbC5jb20+IHdyb3RlOgo+Cj4gT24gMTIvMy8xOCAxOjIyIEFNLCBCcmljZSBHb2dsaW4gd3Jv
dGU6Cj4gPiBMZSAyMi8xMC8yMDE4IMOgIDIyOjEzLCBEYXZlIEhhbnNlbiBhIMOpY3JpdCA6Cj4g
PiBXaGF0IGhhcHBlbnMgb24gc3lzdGVtcyB3aXRob3V0IGFuIEhNQVQ/IERvZXMgdGhpcyBuZXcg
bWVtb3J5IGdldCBtZXJnZWQKPiA+IGludG8gZXhpc3RpbmcgTlVNQSBub2Rlcz8KPgo+IEl0IGdl
dHMgbWVyZ2VkIGludG8gdGhlIHBlcnNpc3RlbnQgbWVtb3J5IGRldmljZSdzIG5vZGUsIGFzIHRv
bGQgYnkgdGhlCj4gZmlybXdhcmUuICBJbnRlbCdzIHBlcnNpc3RlbnQgbWVtb3J5IHNob3VsZCBh
bHdheXMgYmUgaW4gaXRzIG93biBub2RlLAo+IHNlcGFyYXRlIGZyb20gRFJBTS4KPgo+ID4gQWxz
bywgZG8geW91IHBsYW4gdG8gaGF2ZSBhIHdheSBmb3IgYXBwbGljYXRpb25zIHRvIGZpbmQgb3V0
IHdoaWNoIE5VTUEKPiA+IG5vZGVzIGFyZSAicmVhbCBEUkFNIiB3aGlsZSBvdGhlcnMgYXJlICJw
bWVtLWJhY2tlZCI/IChzb21ldGhpbmcgbGlrZSBhCj4gPiBuZXcgYXR0cmlidXRlIGluIC9zeXMv
ZGV2aWNlcy9zeXN0ZW0vbm9kZS9ub2RlWC8pIE9yIHNob3VsZCB3ZSB1c2UgSE1BVAo+ID4gcGVy
Zm9ybWFuY2UgYXR0cmlidXRlcyBmb3IgdGhpcz8KPgo+IFRoZSBiZXN0IHdheSBpcyB0byB1c2Ug
dGhlIHN5c2ZzLWdlbmVyaWMgaW50ZXJmYWNlcyB0byB0aGUgSE1BVCB0aGF0Cj4gS2VpdGggQnVz
Y2ggaXMgcHVzaGluZy4gIEluIHRoZSBlbmQsIHdlIHJlYWxseSB0aGluayBmb2xrcyB3aWxsIG9u
bHkKPiBjYXJlIGFib3V0IHRoZSBtZW1vcnkncyBwZXJmb3JtYW5jZSBwcm9wZXJ0aWVzIHJhdGhl
ciB0aGFuIHdoZXRoZXIgaXQncwo+ICphY3R1YWxseSogcGVyc2lzdGVudCBtZW1vcnkgb3Igbm90
LgoKSXQncyBhbHNvIGltcG9ydGFudCB0byBwb2ludCBvdXQgdGhhdCAicGVyc2lzdGVudCBtZW1v
cnkiIGJ5IGl0c2VsZiBpcwphbiBhbWJpZ3VvdXMgbWVtb3J5IHR5cGUuIEl0J3MgYW55dGhpbmcg
ZnJvbSBuZXcgbWVkaWEgd2l0aCBkaXN0aW5jdApwZXJmb3JtYW5jZSBjaGFyYWN0ZXJpc3RpY3Mg
dG8gYmF0dGVyeSBiYWNrZWQgRFJBTS4gSS5lLiB0aGUKcGVyZm9ybWFuY2Ugb2YgInBlcnNpc3Rl
bnQgbWVtb3J5IiBtYXkgYmUgaW5kaXN0aW5ndWlzaGFibGUgZnJvbSAicmVhbApEUkFNIi4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1t
IG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEu
b3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
