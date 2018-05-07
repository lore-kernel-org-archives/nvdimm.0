Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EFBD720961094
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 12:28:31 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH v1 0/6] use mm to manage NVDIMM (pmem) zone
References: <1525704627-30114-1-git-send-email-yehs1@lenovo.com>
 <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 <x49a7tbi8r3.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hekYsXFy1PHg7zMyoWtj1pYVfnANfrhpk-+Hr_NBV=BQ@mail.gmail.com>
Date: Mon, 07 May 2018 15:28:29 -0400
In-Reply-To: <CAPcyv4hekYsXFy1PHg7zMyoWtj1pYVfnANfrhpk-+Hr_NBV=BQ@mail.gmail.com>
 (Dan Williams's message of "Mon, 7 May 2018 12:17:05 -0700")
Message-ID: <x491seni7tu.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: Sasha Levin <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, Huaisheng Ye <yehs1@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, chengnt@lenovo.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, pasha.tatashin@oracle.com, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, colyli@suse.de, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

RGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+IHdyaXRlczoKCj4gT24gTW9u
LCBNYXkgNywgMjAxOCBhdCAxMjowOCBQTSwgSmVmZiBNb3llciA8am1veWVyQHJlZGhhdC5jb20+
IHdyb3RlOgo+PiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4gd3JpdGVz
Ogo+Pgo+Pj4gT24gTW9uLCBNYXkgNywgMjAxOCBhdCAxMTo0NiBBTSwgTWF0dGhldyBXaWxjb3gg
PHdpbGx5QGluZnJhZGVhZC5vcmc+IHdyb3RlOgo+Pj4+IE9uIE1vbiwgTWF5IDA3LCAyMDE4IGF0
IDEwOjUwOjIxUE0gKzA4MDAsIEh1YWlzaGVuZyBZZSB3cm90ZToKPj4+Pj4gVHJhZGl0aW9uYWxs
eSwgTlZESU1NcyBhcmUgdHJlYXRlZCBieSBtbShtZW1vcnkgbWFuYWdlbWVudCkgc3Vic3lzdGVt
IGFzCj4+Pj4+IERFVklDRSB6b25lLCB3aGljaCBpcyBhIHZpcnR1YWwgem9uZSBhbmQgYm90aCBp
dHMgc3RhcnQgYW5kIGVuZCBvZiBwZm4KPj4+Pj4gYXJlIGVxdWFsIHRvIDAsIG1tIHdvdWxkbuKA
mXQgbWFuYWdlIE5WRElNTSBkaXJlY3RseSBhcyBEUkFNLCBrZXJuZWwgdXNlcwo+Pj4+PiBjb3Jy
ZXNwb25kaW5nIGRyaXZlcnMsIHdoaWNoIGxvY2F0ZSBhdCBcZHJpdmVyc1xudmRpbW1cIGFuZAo+
Pj4+PiBcZHJpdmVyc1xhY3BpXG5maXQgYW5kIGZzLCB0byByZWFsaXplIE5WRElNTSBtZW1vcnkg
YWxsb2MgYW5kIGZyZWUgd2l0aAo+Pj4+PiBtZW1vcnkgaG90IHBsdWcgaW1wbGVtZW50YXRpb24u
Cj4+Pj4KPj4+PiBZb3UgcHJvYmFibHkgd2FudCB0byBsZXQgbGludXgtbnZkaW1tIGtub3cgYWJv
dXQgdGhpcyBwYXRjaCBzZXQuCj4+Pj4gQWRkaW5nIHRvIHRoZSBjYy4KPj4+Cj4+PiBZZXMsIHRo
YW5rcyBmb3IgdGhhdCEKPj4+Cj4+Pj4gQWxzbywgSSBvbmx5IHJlY2VpdmVkIHBhdGNoIDAgYW5k
IDQuICBXaGF0IGhhcHBlbmVkCj4+Pj4gdG8gMS0zLDUgYW5kIDY/Cj4+Pj4KPj4+Pj4gV2l0aCBj
dXJyZW50IGtlcm5lbCwgbWFueSBtbeKAmXMgY2xhc3NpY2FsIGZlYXR1cmVzIGxpa2UgdGhlIGJ1
ZGR5Cj4+Pj4+IHN5c3RlbSwgc3dhcCBtZWNoYW5pc20gYW5kIHBhZ2UgY2FjaGUgY291bGRu4oCZ
dCBiZSBzdXBwb3J0ZWQgdG8gTlZESU1NLgo+Pj4+PiBXaGF0IHdlIGFyZSBkb2luZyBpcyB0byBl
eHBhbmQga2VybmVsIG1t4oCZcyBjYXBhY2l0eSB0byBtYWtlIGl0IHRvIGhhbmRsZQo+Pj4+PiBO
VkRJTU0gbGlrZSBEUkFNLiBGdXJ0aGVybW9yZSB3ZSBtYWtlIG1tIGNvdWxkIHRyZWF0IERSQU0g
YW5kIE5WRElNTQo+Pj4+PiBzZXBhcmF0ZWx5LCB0aGF0IG1lYW5zIG1tIGNhbiBvbmx5IHB1dCB0
aGUgY3JpdGljYWwgcGFnZXMgdG8gTlZESU1NCj4+Cj4+IFBsZWFzZSBkZWZpbmUgImNyaXRpY2Fs
IHBhZ2VzLiIKPj4KPj4+Pj4gem9uZSwgaGVyZSB3ZSBjcmVhdGVkIGEgbmV3IHpvbmUgdHlwZSBh
cyBOVk0gem9uZS4gVGhhdCBpcyB0byBzYXkgZm9yCj4+Pj4+IHRyYWRpdGlvbmFsKG9yIG5vcm1h
bCkgcGFnZXMgd2hpY2ggd291bGQgYmUgc3RvcmVkIGF0IERSQU0gc2NvcGUgbGlrZQo+Pj4+PiBO
b3JtYWwsIERNQTMyIGFuZCBETUEgem9uZXMuIEJ1dCBmb3IgdGhlIGNyaXRpY2FsIHBhZ2VzLCB3
aGljaCB3ZSBob3BlCj4+Pj4+IHRoZW0gY291bGQgYmUgcmVjb3ZlcmVkIGZyb20gcG93ZXIgZmFp
bCBvciBzeXN0ZW0gY3Jhc2gsIHdlIG1ha2UgdGhlbQo+Pj4+PiB0byBiZSBwZXJzaXN0ZW50IGJ5
IHN0b3JpbmcgdGhlbSB0byBOVk0gem9uZS4KPj4KPj4gWy4uLl0KPj4KPj4+IEkgdGhpbmsgYWRk
aW5nIHlldCBvbmUgbW9yZSBtbS16b25lIGlzIHRoZSB3cm9uZyBkaXJlY3Rpb24uIEluc3RlYWQs
Cj4+PiB3aGF0IHdlIGhhdmUgYmVlbiBjb25zaWRlcmluZyBpcyBhIG1lY2hhbmlzbSB0byBhbGxv
dyBhIGRldmljZS1kYXgKPj4+IGluc3RhbmNlIHRvIGJlIGdpdmVuIGJhY2sgdG8gdGhlIGtlcm5l
bCBhcyBhIGRpc3RpbmN0IG51bWEgbm9kZQo+Pj4gbWFuYWdlZCBieSB0aGUgVk0uIEl0IHNlZW1z
IGl0IHRpbWVzIHRvIGR1c3Qgb2ZmIHRob3NlIHBhdGNoZXMuCj4+Cj4+IFdoYXQncyB0aGUgdXNl
IGNhc2U/Cj4KPiBVc2UgTlZESU1NcyBhcyBTeXN0ZW0tUkFNIGdpdmVuIHRoZWlyIHBvdGVudGlh
bGx5IGhpZ2hlciBjYXBhY2l0eSB0aGFuCj4gRERSLiBUaGUgZXhwZWN0YXRpb24gaW4gdGhhdCBj
YXNlIGlzIHRoYXQgZGF0YSBpcyBmb3JmZWl0IChub3QKPiBwZXJzaXN0ZWQpIGFmdGVyIGEgY3Jh
c2guIEFueSBwZXJzaXN0ZW50IHVzZSBjYXNlIHdvdWxkIG5lZWQgdG8gZ28KPiB0aHJvdWdoIHRo
ZSBwbWVtIGRyaXZlciwgZmlsZXN5c3RlbS1kYXggb3IgZGV2aWNlLWRheC4KCk9LLCBidXQgdGhh
dCBzb3VuZHMgZGlmZmVyZW50IGZyb20gd2hhdCB3YXMgYmVpbmcgcHJvcG9zZWQsIGhlcmUuICBJ
J2xsCnF1b3RlIGZyb20gYWJvdmU6Cgo+Pj4+PiBCdXQgZm9yIHRoZSBjcml0aWNhbCBwYWdlcywg
d2hpY2ggd2UgaG9wZSB0aGVtIGNvdWxkIGJlIHJlY292ZXJlZAogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXgo+Pj4+
PiBmcm9tIHBvd2VyIGZhaWwgb3Igc3lzdGVtIGNyYXNoLCB3ZSBtYWtlIHRoZW0gdG8gYmUgcGVy
c2lzdGVudCBieQogICAgICBeXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eCj4+Pj4+IHN0
b3JpbmcgdGhlbSB0byBOVk0gem9uZS4KCkhlbmNlIG15IGNvbmZ1c2lvbi4KCkNoZWVycywKSmVm
ZgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0
cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
