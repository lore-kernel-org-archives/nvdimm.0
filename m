Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4AFCB212449FA
 for <linux-nvdimm@lists.01.org>; Thu,  2 May 2019 17:41:17 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id v23so3216973oif.8
 for <linux-nvdimm@lists.01.org>; Thu, 02 May 2019 17:41:17 -0700 (PDT)
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552634586.2015392.2662168839054356692.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+CK2bCkqLc82G2MW+rYrKTi4KafC+tLCASkaT8zRfVJCCe8HQ@mail.gmail.com>
In-Reply-To: <CA+CK2bCkqLc82G2MW+rYrKTi4KafC+tLCASkaT8zRfVJCCe8HQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 2 May 2019 17:41:05 -0700
Message-ID: <CAPcyv4g+KNu=upejy7Xm=jWR0cdhygPAdSRbkfFGpJeHFGc4+w@mail.gmail.com>
Subject: Re: [PATCH v6 02/12] mm/sparsemem: Introduce common definitions for
 the size and mask of a section
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Robin Murphy <robin.murphy@arm.com>, David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBNYXkgMiwgMjAxOSBhdCA3OjUzIEFNIFBhdmVsIFRhdGFzaGluIDxwYXNoYS50YXRh
c2hpbkBzb2xlZW4uY29tPiB3cm90ZToKPgo+IE9uIFdlZCwgQXByIDE3LCAyMDE5IGF0IDI6NTIg
UE0gRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+IHdyb3RlOgo+ID4KPiA+
IFVwLWxldmVsIHRoZSBsb2NhbCBzZWN0aW9uIHNpemUgYW5kIG1hc2sgZnJvbSBrZXJuZWwvbWVt
cmVtYXAuYyB0bwo+ID4gZ2xvYmFsIGRlZmluaXRpb25zLiAgVGhlc2Ugd2lsbCBiZSB1c2VkIGJ5
IHRoZSBuZXcgc3ViLXNlY3Rpb24gaG90cGx1Zwo+ID4gc3VwcG9ydC4KPiA+Cj4gPiBDYzogTWlj
aGFsIEhvY2tvIDxtaG9ja29Ac3VzZS5jb20+Cj4gPiBDYzogVmxhc3RpbWlsIEJhYmthIDx2YmFi
a2FAc3VzZS5jej4KPiA+IENjOiBKw6lyw7RtZSBHbGlzc2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4K
PiA+IENjOiBMb2dhbiBHdW50aG9ycGUgPGxvZ2FuZ0BkZWx0YXRlZS5jb20+Cj4gPiBTaWduZWQt
b2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KPgo+IFNob3Vs
ZCBiZSBkcm9wcGVkIGZyb20gdGhpcyBzZXJpZXMgYXMgaXQgaGFzIGJlZW4gcmVwbGFjZWQgYnkg
YSB2ZXJ5Cj4gc2ltaWxhciBwYXRjaCBpbiB0aGUgbWFpbmxpbmU6Cj4KPiA3YzY5N2Q3ZmI1Y2Ix
NGVmNjBlMmI2ODczMzNiYTNlZmI3NGY3M2RhCj4gIG1tL21lbXJlbWFwOiBSZW5hbWUgYW5kIGNv
bnNvbGlkYXRlIFNFQ1RJT05fU0laRQoKSSBzYXcgdGhhdCBwYXRjaCBmbHkgYnkgYW5kIGFja2Vk
IGl0LCBidXQgSSBoYXZlIG5vdCBzZWVuIGl0IHBpY2tlZCB1cAphbnl3aGVyZS4gSSBncmFiYmVk
IGxhdGVzdCAtbGludXMgYW5kIC1uZXh0LCBidXQgZG9uJ3Qgc2VlIHRoYXQKY29tbWl0LgoKJCBn
aXQgc2hvdyA3YzY5N2Q3ZmI1Y2IxNGVmNjBlMmI2ODczMzNiYTNlZmI3NGY3M2RhCmZhdGFsOiBi
YWQgb2JqZWN0IDdjNjk3ZDdmYjVjYjE0ZWY2MGUyYjY4NzMzM2JhM2VmYjc0ZjczZGEKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
