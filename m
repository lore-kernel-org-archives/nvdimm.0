Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 749F221A13492
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 11:46:57 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [RFC PATCH] dax: add badblocks check to Device DAX
Date: Wed, 3 May 2017 18:46:54 +0000
Message-ID: <1493837209.30303.47.camel@hpe.com>
References: <20170503153103.30756-1-toshi.kani@hpe.com>
 <CAPcyv4hu9iW-EEaggOj4ax_P6=Y28adi5Hb7Rp1Q1xBTWenJuQ@mail.gmail.com>
 <1493827750.30303.44.camel@hpe.com>
 <CAPcyv4gthc8Gc7SUyxqecDrd+dtOfOzY19bs5sY1qMepQKh=kQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gthc8Gc7SUyxqecDrd+dtOfOzY19bs5sY1qMepQKh=kQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <1525569F81A4294E9F7B5AEADFF66DA0@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gV2VkLCAyMDE3LTA1LTAzIGF0IDA5OjMwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFdlZCwgTWF5IDMsIDIwMTcgYXQgOTowOSBBTSwgS2FuaSwgVG9zaGltaXRzdSA8dG9zaGku
a2FuaUBocGUuY29tPg0KPiB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMTctMDUtMDMgYXQgMDg6NTIg
LTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gPiA+IE9uIFdlZCwgTWF5IDMsIDIwMTcgYXQg
ODozMSBBTSwgVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBocGUuY29tPg0KPiA+ID4gd3JvdGU6DQo+
ID4gPiA+IFRoaXMgaXMgYSBSRkMgcGF0Y2ggZm9yIHNlZWtpbmcgc3VnZ2VzdGlvbnMuwqDCoEl0
IGFkZHMgc3VwcG9ydA0KPiA+ID4gPiBvZiBiYWRibG9ja3MgY2hlY2sgaW4gRGV2aWNlIERBWCBi
eSB1c2luZyByZWdpb24tbGV2ZWwNCj4gPiA+ID4gYmFkYmxvY2tzIGxpc3QuICBUaGlzIHBhdGNo
IGlzIG9ubHkgYnJpZWZseSB0ZXN0ZWQuDQo+ID4gPiA+IA0KPiA+ID4gPiBkZXZpY2VfZGF4IGlz
IGEgd2VsbC1pc29sYXRlZCBzZWxmLWNvbnRhaW5lZCBtb2R1bGUgYXMgaXQgY2FsbHMNCj4gPiA+
ID4gYWxsb2NfZGF4KCkgd2l0aCBkZXZfZGF4LCB3aGljaCBpcyBwcml2YXRlIHRvIGRldmljZV9k
YXguwqDCoEZvcg0KPiA+ID4gPiBjaGVja2luZyBiYWRibG9ja3MsIGl0IG5lZWRzIHRvIGNhbGwg
ZGF4X3BtZW0gdG8gY2hlY2sgd2l0aA0KPiA+ID4gPiByZWdpb24tbGV2ZWwgYmFkYmxvY2tzLg0K
PiA+ID4gPiANCj4gPiA+ID4gVGhpcyBwYXRjaCBhdHRlbXB0cyB0byBrZWVwIGRldmljZV9kYXgg
c2VsZi1jb250YWluZWQuwqDCoEl0IGFkZHMNCj4gPiA+ID4gY2hlY2tfZXJyb3IoKSB0byBkYXhf
b3BlcmF0aW9ucywgYW5kIGRheF9jaGVja19lcnJvcigpIGFzIGENCj4gPiA+ID4gc3R1YiB3aXRo
ICpkZXZfZGF4IGFuZCAqZGV2IHBvaW50ZXJzIHRvIGNvbnZleSBpdCB0bw0KPiA+ID4gPiBkYXhf
cG1lbS7CoMKgSSBhbSB3b25kZXJpbmcgaWYgdGhpcyBpcyB0aGUgcmlnaHQgZGlyZWN0aW9uLCBv
ciB3ZQ0KPiA+ID4gPiBzaG91bGQgY2hhbmdlIHRoZSBtb2R1bGFyaXR5IHRvIGxldCBkYXhfcG1l
bSBjYWxsIGFsbG9jX2RheCgpDQo+ID4gPiA+IHdpdGggaXRzIGRheF9wbWVtIChvciBJIGNvbXBs
ZXRlbHkgbWlzc2VkIHNvbWV0aGluZykuDQo+ID4gPiANCj4gPiA+IFRoZSBwcm9ibGVtIGlzIHRo
YXQgZGV2aWNlLWRheCBndWFyYW50ZWVzIGEgZ2l2ZW4gZmF1bHQNCj4gPiA+IGdyYW51bGFyaXR5
LiBUbyBtYWtlIHRoYXQgZ3VhcmFudGVlIHdlIGNhbid0IGZhbGxiYWNrIGZyb20gMUcgb3INCj4g
PiA+IDJNIG1hcHBpbmdzIGR1ZSB0byBhbiBlcnJvci4gV2UgYWxzbyBjYW4ndCByZWFzb25hYmx5
IGdvIHRoZQ0KPiA+ID4gb3RoZXIgd2F5IGFuZCBmYWlsIG1hcHBpbmdzIHRoYXQgY29udGFpbiBh
IGJhZGJsb2NrIGJlY2F1c2UgdGhhdA0KPiA+ID4gd291bGQgY2hhbmdlIHRoZSBibGFzdCByYWRp
dXMgb2YgYSBtZWRpYSBlcnJvciB0byB0aGUgZmF1bHQgc2l6ZS4NCj4gPiANCj4gPiBEb2VzIGl0
IG1lYW4gd2UgZXhwZWN0IHVzZXJzIHRvIGhhdmUgQ1BVcyB3aXRoIE1DRSByZWNvdmVyeSBmb3IN
Cj4gPiBEZXZpY2UgREFYP8KgwqBDYW4gd2UgYWRkIGFuIGF0dHJpYnV0ZXMgbGlrZSBhbGxvdyBl
cnJvci1jaGVjayAmDQo+ID4gZmFsbC1iYWNrPw0KPiANCj4gWWVzLCB3aXRob3V0IE1DRSByZWNv
dmVyeSBkZXZpY2UtZGF4IG1hcHBpbmdzIHRoYXQgY29uc3VtZSBlcnJvcnMNCj4gd2lsbCByZWJv
b3QuIElmIGFuIGFwcGxpY2F0aW9uIG5lZWRzIHRoZSBrZXJuZWwgcHJvdGVjdGlvbiBpdCBzaG91
bGQNCj4gYmUgdXNpbmcgZmlsZXN5c3RlbS1kYXguDQoNClVuZGVyc3Rvb2QuICBBcmUgd2UgZ29p
bmcgdG8gcHJvdmlkZSBzeXNmcyAiYmFkYmxvY2tzIiBmb3IgRGV2aWNlIERBWA0KYXMgaXQgaXMg
YWxzbyBuZWVkZWQgZm9yIG5kY3RsIGNsZWFyLWVycm9yPw0KDQpUaGFua3MsDQotVG9zaGkNCiAK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
