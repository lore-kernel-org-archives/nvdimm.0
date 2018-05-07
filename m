Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0090E20961094
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 12:08:36 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH v1 0/6] use mm to manage NVDIMM (pmem) zone
References: <1525704627-30114-1-git-send-email-yehs1@lenovo.com>
 <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
Date: Mon, 07 May 2018 15:08:32 -0400
In-Reply-To: <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 (Dan Williams's message of "Mon, 7 May 2018 11:57:10 -0700")
Message-ID: <x49a7tbi8r3.fsf@segfault.boston.devel.redhat.com>
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
LCBNYXkgNywgMjAxOCBhdCAxMTo0NiBBTSwgTWF0dGhldyBXaWxjb3ggPHdpbGx5QGluZnJhZGVh
ZC5vcmc+IHdyb3RlOgo+PiBPbiBNb24sIE1heSAwNywgMjAxOCBhdCAxMDo1MDoyMVBNICswODAw
LCBIdWFpc2hlbmcgWWUgd3JvdGU6Cj4+PiBUcmFkaXRpb25hbGx5LCBOVkRJTU1zIGFyZSB0cmVh
dGVkIGJ5IG1tKG1lbW9yeSBtYW5hZ2VtZW50KSBzdWJzeXN0ZW0gYXMKPj4+IERFVklDRSB6b25l
LCB3aGljaCBpcyBhIHZpcnR1YWwgem9uZSBhbmQgYm90aCBpdHMgc3RhcnQgYW5kIGVuZCBvZiBw
Zm4KPj4+IGFyZSBlcXVhbCB0byAwLCBtbSB3b3VsZG7igJl0IG1hbmFnZSBOVkRJTU0gZGlyZWN0
bHkgYXMgRFJBTSwga2VybmVsIHVzZXMKPj4+IGNvcnJlc3BvbmRpbmcgZHJpdmVycywgd2hpY2gg
bG9jYXRlIGF0IFxkcml2ZXJzXG52ZGltbVwgYW5kCj4+PiBcZHJpdmVyc1xhY3BpXG5maXQgYW5k
IGZzLCB0byByZWFsaXplIE5WRElNTSBtZW1vcnkgYWxsb2MgYW5kIGZyZWUgd2l0aAo+Pj4gbWVt
b3J5IGhvdCBwbHVnIGltcGxlbWVudGF0aW9uLgo+Pgo+PiBZb3UgcHJvYmFibHkgd2FudCB0byBs
ZXQgbGludXgtbnZkaW1tIGtub3cgYWJvdXQgdGhpcyBwYXRjaCBzZXQuCj4+IEFkZGluZyB0byB0
aGUgY2MuCj4KPiBZZXMsIHRoYW5rcyBmb3IgdGhhdCEKPgo+PiBBbHNvLCBJIG9ubHkgcmVjZWl2
ZWQgcGF0Y2ggMCBhbmQgNC4gIFdoYXQgaGFwcGVuZWQKPj4gdG8gMS0zLDUgYW5kIDY/Cj4+Cj4+
PiBXaXRoIGN1cnJlbnQga2VybmVsLCBtYW55IG1t4oCZcyBjbGFzc2ljYWwgZmVhdHVyZXMgbGlr
ZSB0aGUgYnVkZHkKPj4+IHN5c3RlbSwgc3dhcCBtZWNoYW5pc20gYW5kIHBhZ2UgY2FjaGUgY291
bGRu4oCZdCBiZSBzdXBwb3J0ZWQgdG8gTlZESU1NLgo+Pj4gV2hhdCB3ZSBhcmUgZG9pbmcgaXMg
dG8gZXhwYW5kIGtlcm5lbCBtbeKAmXMgY2FwYWNpdHkgdG8gbWFrZSBpdCB0byBoYW5kbGUKPj4+
IE5WRElNTSBsaWtlIERSQU0uIEZ1cnRoZXJtb3JlIHdlIG1ha2UgbW0gY291bGQgdHJlYXQgRFJB
TSBhbmQgTlZESU1NCj4+PiBzZXBhcmF0ZWx5LCB0aGF0IG1lYW5zIG1tIGNhbiBvbmx5IHB1dCB0
aGUgY3JpdGljYWwgcGFnZXMgdG8gTlZESU1NCgpQbGVhc2UgZGVmaW5lICJjcml0aWNhbCBwYWdl
cy4iCgo+Pj4gem9uZSwgaGVyZSB3ZSBjcmVhdGVkIGEgbmV3IHpvbmUgdHlwZSBhcyBOVk0gem9u
ZS4gVGhhdCBpcyB0byBzYXkgZm9yCj4+PiB0cmFkaXRpb25hbChvciBub3JtYWwpIHBhZ2VzIHdo
aWNoIHdvdWxkIGJlIHN0b3JlZCBhdCBEUkFNIHNjb3BlIGxpa2UKPj4+IE5vcm1hbCwgRE1BMzIg
YW5kIERNQSB6b25lcy4gQnV0IGZvciB0aGUgY3JpdGljYWwgcGFnZXMsIHdoaWNoIHdlIGhvcGUK
Pj4+IHRoZW0gY291bGQgYmUgcmVjb3ZlcmVkIGZyb20gcG93ZXIgZmFpbCBvciBzeXN0ZW0gY3Jh
c2gsIHdlIG1ha2UgdGhlbQo+Pj4gdG8gYmUgcGVyc2lzdGVudCBieSBzdG9yaW5nIHRoZW0gdG8g
TlZNIHpvbmUuCgpbLi4uXQoKPiBJIHRoaW5rIGFkZGluZyB5ZXQgb25lIG1vcmUgbW0tem9uZSBp
cyB0aGUgd3JvbmcgZGlyZWN0aW9uLiBJbnN0ZWFkLAo+IHdoYXQgd2UgaGF2ZSBiZWVuIGNvbnNp
ZGVyaW5nIGlzIGEgbWVjaGFuaXNtIHRvIGFsbG93IGEgZGV2aWNlLWRheAo+IGluc3RhbmNlIHRv
IGJlIGdpdmVuIGJhY2sgdG8gdGhlIGtlcm5lbCBhcyBhIGRpc3RpbmN0IG51bWEgbm9kZQo+IG1h
bmFnZWQgYnkgdGhlIFZNLiBJdCBzZWVtcyBpdCB0aW1lcyB0byBkdXN0IG9mZiB0aG9zZSBwYXRj
aGVzLgoKV2hhdCdzIHRoZSB1c2UgY2FzZT8gIFRoZSBhYm92ZSBwYXRjaCBkZXNjcmlwdGlvbiBz
ZWVtcyB0byBpbmRpY2F0ZSBhbgppbnRlbnQgdG8gcmVjb3ZlciBjb250ZW50cyBhZnRlciBhIHBv
d2VyIGxvc3MuICBXaXRob3V0IHNlZWluZyB0aGUgd2hvbGUKc2VyaWVzLCBJJ20gbm90IHN1cmUg
aG93IHRoYXQncyBhY2NvbXBsaXNoZWQgaW4gYSBzYWZlIG9yIG1lYW5pbmdmdWwKd2F5LgoKSHVh
aXNoZW5nLCBjb3VsZCB5b3UgcHJvdmlkZSBhIGJpdCBtb3JlIGJhY2tncm91bmQ/CgpUaGFua3Mh
CkplZmYKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGlu
dXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8v
bGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
