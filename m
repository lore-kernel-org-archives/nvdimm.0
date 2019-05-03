Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id BBC162194EB76
 for <linux-nvdimm@lists.01.org>; Fri,  3 May 2019 03:35:08 -0700 (PDT)
Subject: Re: [PATCH v6 02/12] mm/sparsemem: Introduce common definitions for
 the size and mask of a section
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552634586.2015392.2662168839054356692.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+CK2bCkqLc82G2MW+rYrKTi4KafC+tLCASkaT8zRfVJCCe8HQ@mail.gmail.com>
 <CAPcyv4g+KNu=upejy7Xm=jWR0cdhygPAdSRbkfFGpJeHFGc4+w@mail.gmail.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <bd76cb2f-7cdc-f11b-11ec-285862db66f3@arm.com>
Date: Fri, 3 May 2019 11:35:04 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g+KNu=upejy7Xm=jWR0cdhygPAdSRbkfFGpJeHFGc4+w@mail.gmail.com>
Content-Language: en-GB
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
To: Dan Williams <dan.j.williams@intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

T24gMDMvMDUvMjAxOSAwMTo0MSwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+IE9uIFRodSwgTWF5IDIs
IDIwMTkgYXQgNzo1MyBBTSBQYXZlbCBUYXRhc2hpbiA8cGFzaGEudGF0YXNoaW5Ac29sZWVuLmNv
bT4gd3JvdGU6Cj4+Cj4+IE9uIFdlZCwgQXByIDE3LCAyMDE5IGF0IDI6NTIgUE0gRGFuIFdpbGxp
YW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+IHdyb3RlOgo+Pj4KPj4+IFVwLWxldmVsIHRo
ZSBsb2NhbCBzZWN0aW9uIHNpemUgYW5kIG1hc2sgZnJvbSBrZXJuZWwvbWVtcmVtYXAuYyB0bwo+
Pj4gZ2xvYmFsIGRlZmluaXRpb25zLiAgVGhlc2Ugd2lsbCBiZSB1c2VkIGJ5IHRoZSBuZXcgc3Vi
LXNlY3Rpb24gaG90cGx1Zwo+Pj4gc3VwcG9ydC4KPj4+Cj4+PiBDYzogTWljaGFsIEhvY2tvIDxt
aG9ja29Ac3VzZS5jb20+Cj4+PiBDYzogVmxhc3RpbWlsIEJhYmthIDx2YmFia2FAc3VzZS5jej4K
Pj4+IENjOiBKw6lyw7RtZSBHbGlzc2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4KPj4+IENjOiBMb2dh
biBHdW50aG9ycGUgPGxvZ2FuZ0BkZWx0YXRlZS5jb20+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBEYW4g
V2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KPj4KPj4gU2hvdWxkIGJlIGRyb3Bw
ZWQgZnJvbSB0aGlzIHNlcmllcyBhcyBpdCBoYXMgYmVlbiByZXBsYWNlZCBieSBhIHZlcnkKPj4g
c2ltaWxhciBwYXRjaCBpbiB0aGUgbWFpbmxpbmU6Cj4+Cj4+IDdjNjk3ZDdmYjVjYjE0ZWY2MGUy
YjY4NzMzM2JhM2VmYjc0ZjczZGEKPj4gICBtbS9tZW1yZW1hcDogUmVuYW1lIGFuZCBjb25zb2xp
ZGF0ZSBTRUNUSU9OX1NJWkUKPiAKPiBJIHNhdyB0aGF0IHBhdGNoIGZseSBieSBhbmQgYWNrZWQg
aXQsIGJ1dCBJIGhhdmUgbm90IHNlZW4gaXQgcGlja2VkIHVwCj4gYW55d2hlcmUuIEkgZ3JhYmJl
ZCBsYXRlc3QgLWxpbnVzIGFuZCAtbmV4dCwgYnV0IGRvbid0IHNlZSB0aGF0Cj4gY29tbWl0Lgo+
IAo+ICQgZ2l0IHNob3cgN2M2OTdkN2ZiNWNiMTRlZjYwZTJiNjg3MzMzYmEzZWZiNzRmNzNkYQo+
IGZhdGFsOiBiYWQgb2JqZWN0IDdjNjk3ZDdmYjVjYjE0ZWY2MGUyYjY4NzMzM2JhM2VmYjc0Zjcz
ZGEKClllYWgsIEkgZG9uJ3QgcmVjb2duaXNlIHRoYXQgSUQgZWl0aGVyLCBub3IgaGF2ZSBJIGhh
ZCBhbnkgbm90aWZpY2F0aW9ucyAKdGhhdCBBbmRyZXcncyBwaWNrZWQgdXAgYW55dGhpbmcgb2Yg
bWluZSB5ZXQgOi8KClJvYmluLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
