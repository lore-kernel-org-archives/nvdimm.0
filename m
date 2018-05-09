Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta12.messagelabs.com (mail1.bemta12.messagelabs.com
 [216.82.251.7])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 429F4207E36D9
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 21:48:12 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External] Re: [RFC PATCH v1 0/6] use mm to manage NVDIMM (pmem)
 zone
Date: Wed, 9 May 2018 04:47:54 +0000
Message-ID: <HK2PR03MB16841CBB549F40F86BB8D35C92990@HK2PR03MB1684.apcprd03.prod.outlook.com>
References: <1525704627-30114-1-git-send-email-yehs1@lenovo.com>
 <20180507184622.GB12361@bombadil.infradead.org>
 <CAPcyv4hBJN3npXwg3Ur32JSWtKvBUZh7F8W+Exx3BB-uKWwPag@mail.gmail.com>
 <x49a7tbi8r3.fsf@segfault.boston.devel.redhat.com>
 <HK2PR03MB1684659175EB0A11E75E9B61929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
 <20180508030959.GB16338@bombadil.infradead.org>
In-Reply-To: <20180508030959.GB16338@bombadil.infradead.org>
Content-Language: zh-CN
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Sasha Levin <alexander.levin@verizon.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, NingTing Cheng <chengnt@lenovo.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "pasha.tatashin@oracle.com" <pasha.tatashin@oracle.com>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, "colyli@suse.de" <colyli@suse.de>, Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

DQo+IA0KPiBPbiBUdWUsIE1heSAwOCwgMjAxOCBhdCAwMjo1OTo0MEFNICswMDAwLCBIdWFpc2hl
bmcgSFMxIFllIHdyb3RlOg0KPiA+IEN1cnJlbnRseSBpbiBvdXIgbWluZCwgYW4gaWRlYWwgdXNl
IHNjZW5hcmlvIGlzIHRoYXQsIHdlIHB1dCBhbGwgcGFnZSBjYWNoZXMgdG8NCj4gPiB6b25lX252
bSwgd2l0aG91dCBhbnkgZG91YnQsIHBhZ2UgY2FjaGUgaXMgYW4gZWZmaWNpZW50IGFuZCBjb21t
b24gY2FjaGUNCj4gPiBpbXBsZW1lbnQsIGJ1dCBpdCBoYXMgYSBkaXNhZHZhbnRhZ2UgdGhhdCBh
bGwgZGlydHkgZGF0YSB3aXRoaW4gaXQgd291bGQgaGFzIHJpc2sNCj4gPiB0byBiZSBtaXNzZWQg
YnkgcG93ZXIgZmFpbHVyZSBvciBzeXN0ZW0gY3Jhc2guIElmIHdlIHB1dCBhbGwgcGFnZSBjYWNo
ZXMgdG8gTlZESU1NcywNCj4gPiBhbGwgZGlydHkgZGF0YSB3aWxsIGJlIHNhZmUuDQo+IA0KPiBU
aGF0J3MgYSBjb21tb24gbWlzY29uY2VwdGlvbi4gIFNvbWUgZGlydHkgZGF0YSB3aWxsIHN0aWxs
IGJlIGluIHRoZQ0KPiBDUFUgY2FjaGVzLiAgQXJlIHlvdSBwbGFubmluZyBvbiBidWlsZGluZyBz
ZXJ2ZXJzIHdoaWNoIGhhdmUgZW5vdWdoDQo+IGNhcGFjaXRhbmNlIHRvIGFsbG93IHRoZSBDUFUg
dG8gZmx1c2ggYWxsIGRpcnR5IGRhdGEgZnJvbSBMTEMgdG8gTlYtRElNTT8NCj4gDQpTb3JyeSBm
b3Igbm90IGJlaW5nIGNsZWFyLg0KRm9yIENQVSBjYWNoZXMgaWYgdGhlcmUgaXMgYSBwb3dlciBm
YWlsdXJlLCBOVkRJTU0gaGFzIEFEUiB0byBndWFyYW50ZWUgYW4gaW50ZXJydXB0IHdpbGwgYmUg
cmVwb3J0ZWQgdG8gQ1BVLCBhbiBpbnRlcnJ1cHQgcmVzcG9uc2UgZnVuY3Rpb24gc2hvdWxkIGJl
IHJlc3BvbnNpYmxlIHRvIGZsdXNoIGFsbCBkaXJ0eSBkYXRhIHRvIE5WRElNTS4NCklmIHRoZXJl
IGlzIGEgc3lzdGVtIGNydXNoLCBwZXJoYXBzIENQVSBjb3VsZG4ndCBoYXZlIGNoYW5jZSB0byBl
eGVjdXRlIHRoaXMgcmVzcG9uc2UuDQoNCkl0IGlzIGhhcmQgdG8gbWFrZSBzdXJlIGV2ZXJ5dGhp
bmcgaXMgc2FmZSwgd2hhdCB3ZSBjYW4gZG8gaXMganVzdCB0byBzYXZlIHRoZSBkaXJ0eSBkYXRh
IHdoaWNoIGlzIGFscmVhZHkgc3RvcmVkIHRvIFBhZ2VjYWNoZSwgYnV0IG5vdCBpbiBDUFUgY2Fj
aGUuDQpJcyB0aGlzIGFuIGltcHJvdmVtZW50IHRoYW4gY3VycmVudD8NCg0KPiBUaGVuIHRoZXJl
J3MgdGhlIHByb2JsZW0gb2YgcmVjb25uZWN0aW5nIHRoZSBwYWdlIGNhY2hlICh3aGljaCBpcw0K
PiBwb2ludGVkIHRvIGJ5IGVwaGVtZXJhbCBkYXRhIHN0cnVjdHVyZXMgbGlrZSBpbm9kZXMgYW5k
IGRlbnRyaWVzKSB0bw0KPiB0aGUgbmV3IGlub2Rlcy4NClllcywgaXQgaXMgbm90IGVhc3kuDQoN
Cj4gDQo+IEFuZCB0aGVuIHlvdSBoYXZlIHRvIGNvbnZpbmNlIGN1c3RvbWVycyB0aGF0IHdoYXQg
eW91J3JlIGRvaW5nIGlzIHNhZmUNCj4gZW5vdWdoIGZvciB0aGVtIHRvIHRydXN0IGl0IDstKQ0K
U3VyZS4g8J+Yig0KDQpTaW5jZXJlbHksDQpIdWFpc2hlbmcgWWUNCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QK
TGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LW52ZGltbQo=
