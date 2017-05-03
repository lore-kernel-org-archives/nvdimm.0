Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C50421A13492
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 09:09:18 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [RFC PATCH] dax: add badblocks check to Device DAX
Date: Wed, 3 May 2017 16:09:14 +0000
Message-ID: <1493827750.30303.44.camel@hpe.com>
References: <20170503153103.30756-1-toshi.kani@hpe.com>
 <CAPcyv4hu9iW-EEaggOj4ax_P6=Y28adi5Hb7Rp1Q1xBTWenJuQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hu9iW-EEaggOj4ax_P6=Y28adi5Hb7Rp1Q1xBTWenJuQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <A85D757FD7939343B94DBF6039077797@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA1LTAzIGF0IDA4OjUyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFdlZCwgTWF5IDMsIDIwMTcgYXQgODozMSBBTSwgVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBo
cGUuY29tPg0KPiB3cm90ZToNCj4gPiBUaGlzIGlzIGEgUkZDIHBhdGNoIGZvciBzZWVraW5nIHN1
Z2dlc3Rpb25zLsKgwqBJdCBhZGRzIHN1cHBvcnQgb2YNCj4gPiBiYWRibG9ja3MgY2hlY2sgaW4g
RGV2aWNlIERBWCBieSB1c2luZyByZWdpb24tbGV2ZWwgYmFkYmxvY2tzIGxpc3QuDQo+ID4gVGhp
cyBwYXRjaCBpcyBvbmx5IGJyaWVmbHkgdGVzdGVkLg0KPiA+IA0KPiA+IGRldmljZV9kYXggaXMg
YSB3ZWxsLWlzb2xhdGVkIHNlbGYtY29udGFpbmVkIG1vZHVsZSBhcyBpdCBjYWxscw0KPiA+IGFs
bG9jX2RheCgpIHdpdGggZGV2X2RheCwgd2hpY2ggaXMgcHJpdmF0ZSB0byBkZXZpY2VfZGF4LsKg
wqBGb3INCj4gPiBjaGVja2luZyBiYWRibG9ja3MsIGl0IG5lZWRzIHRvIGNhbGwgZGF4X3BtZW0g
dG8gY2hlY2sgd2l0aA0KPiA+IHJlZ2lvbi1sZXZlbCBiYWRibG9ja3MuDQo+ID4gDQo+ID4gVGhp
cyBwYXRjaCBhdHRlbXB0cyB0byBrZWVwIGRldmljZV9kYXggc2VsZi1jb250YWluZWQuwqDCoEl0
IGFkZHMNCj4gPiBjaGVja19lcnJvcigpIHRvIGRheF9vcGVyYXRpb25zLCBhbmQgZGF4X2NoZWNr
X2Vycm9yKCkgYXMgYSBzdHViDQo+ID4gd2l0aCAqZGV2X2RheCBhbmQgKmRldiBwb2ludGVycyB0
byBjb252ZXkgaXQgdG8gZGF4X3BtZW0uwqDCoEkgYW0NCj4gPiB3b25kZXJpbmcgaWYgdGhpcyBp
cyB0aGUgcmlnaHQgZGlyZWN0aW9uLCBvciB3ZSBzaG91bGQgY2hhbmdlIHRoZQ0KPiA+IG1vZHVs
YXJpdHkgdG8gbGV0IGRheF9wbWVtIGNhbGwgYWxsb2NfZGF4KCkgd2l0aCBpdHMgZGF4X3BtZW0g
KG9yDQo+ID4gSSBjb21wbGV0ZWx5IG1pc3NlZCBzb21ldGhpbmcpLg0KPiANCj4gVGhlIHByb2Js
ZW0gaXMgdGhhdCBkZXZpY2UtZGF4IGd1YXJhbnRlZXMgYSBnaXZlbiBmYXVsdCBncmFudWxhcml0
eS4NCj4gVG8gbWFrZSB0aGF0IGd1YXJhbnRlZSB3ZSBjYW4ndCBmYWxsYmFjayBmcm9tIDFHIG9y
IDJNIG1hcHBpbmdzIGR1ZQ0KPiB0byBhbiBlcnJvci4gV2UgYWxzbyBjYW4ndCByZWFzb25hYmx5
IGdvIHRoZSBvdGhlciB3YXkgYW5kIGZhaWwNCj4gbWFwcGluZ3MgdGhhdCBjb250YWluIGEgYmFk
YmxvY2sgYmVjYXVzZSB0aGF0IHdvdWxkIGNoYW5nZSB0aGUgYmxhc3QNCj4gcmFkaXVzIG9mIGEg
bWVkaWEgZXJyb3IgdG8gdGhlIGZhdWx0IHNpemUuDQoNCkRvZXMgaXQgbWVhbiB3ZSBleHBlY3Qg
dXNlcnMgdG8gaGF2ZSBDUFVzIHdpdGggTUNFIHJlY292ZXJ5IGZvciBEZXZpY2UNCkRBWD8gIENh
biB3ZSBhZGQgYW4gYXR0cmlidXRlcyBsaWtlIGFsbG93IGVycm9yLWNoZWNrICYgZmFsbC1iYWNr
Pw0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
