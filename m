Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on0729.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::729])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 618301A1DF3
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 15:19:43 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 2/3] acpi, nfit: add dimm device notification support
Date: Mon, 29 Aug 2016 22:19:40 +0000
Message-ID: <1472509138.1532.61.camel@hpe.com>
References: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147198926249.3136.6163137762013359047.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1472235940.1532.23.camel@hpe.com>
 <CAPcyv4hdLdGR7LLyHVZsyXK6dNL1+jF927Siqt_D2DfPSifwwA@mail.gmail.com>
In-Reply-To: <CAPcyv4hdLdGR7LLyHVZsyXK6dNL1+jF927Siqt_D2DfPSifwwA@mail.gmail.com>
Content-Language: en-US
Content-ID: <2F5149A71B223640B089BA356D13F25C@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTA4LTI2IGF0IDExOjM5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgQXVnIDI2LCAyMDE2IGF0IDExOjI2IEFNLCBLYW5pLCBUb3NoaW1pdHN1IDx0b3No
aS5rYW5pQGhwZS5jbw0KPiBtPiB3cm90ZToNCj4gPiANCj4gPiBPbiBUdWUsIDIwMTYtMDgtMjMg
YXQgMTQ6NTQgLTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gPiA+IA0KPiA+ID4gUGVyICJB
Q1BJIDYuMSBTZWN0aW9uIDkuMjAuMyIgTlZESU1NIGRldmljZXMsIGNoaWxkcmVuIG9mIHRoZQ0K
PiA+ID4gQUNQSTAwMTIgTlZESU1NIFJvb3QgZGV2aWNlLCBjYW4gcmVjZWl2ZSBoZWFsdGggZXZl
bnQNCj4gPiA+IG5vdGlmaWNhdGlvbnMuDQo+ID4gPiANCj4gPiA+IEdpdmVuIHRoYXQgdGhlc2Ug
ZGV2aWNlcyBhcmUgcHJlY2x1ZGVkIGZyb20gcmVnaXN0ZXJpbmcgYQ0KPiA+ID4gbm90aWZpY2F0
aW9uIGhhbmRsZXIgdmlhIGFjcGlfZHJpdmVyLmFjcGlfZGV2aWNlX29wcyAoZHVlIHRvIG5vDQo+
ID4gPiBfSElEKSwgd2UgdXNlIGFjcGlfaW5zdGFsbF9ub3RpZnlfaGFuZGxlcigpIGRpcmVjdGx5
Lg0KPiA+IA0KPiA+IEkndmUgY29uZmlybWVkIHRoYXQgdGhpcyBBQ1BJIG5vdGlmeSBoYW5kbGVy
IGlzIGNhbGxlZCBwcm9wZXJseS4NCj4gPiANCj4gPiA+IA0KPiA+ID4gVGhlIHJlZ2lzdGVyZWQg
aGFuZGxlciwgYWNwaV9udmRpbW1fbm90aWZ5KCksIHRyaWdnZXJzIGEgcG9sbCgyKQ0KPiA+ID4g
ZXZlbnQgb24gdGhlIG5tZW1YL25maXQvZmxhZ3Mgc3lzZnMgYXR0cmlidXRlIHdoZW4gYSBoZWFs
dGggZXZlbnQNCj4gPiA+IG5vdGlmaWNhdGlvbiBpcyByZWNlaXZlZC4NCj4gPiANCj4gPiBUaGlz
IHNvdW5kcyBnb29kIGlkZWEsIGJ1dCBzaG91bGQgd2UgZG9jdW1lbnQgdGhhdCB0aGUgdmFsdWUg
b2YNCj4gPiBzeXNmcyAnZmxhZ3MnIGl0c2VsZiBkb2VzIG5vdCBnZXQgdXBkYXRlZD/CoMKgVXNl
ciBzcGFjZSBwcm9ncmFtIHdpbGwNCj4gPiB0aGVuIG5lZWQgdG8gY2FsbCBpdHMgX0RTTSB0byBn
ZXQgaGVhbHRoIHN0YXR1cy4NCj4gDQo+IFllcywgdGhpcyBwbHVzIHRoZSBuZXcgc2NydWIgYXR0
cmlidXRlIGJlaGF2aW9yIG5lZWQgZG9jdW1lbnRhdGlvbi4NCj4gSSdsbCBwcmVwYXJlIGEgcmVm
cmVzaCBmb3IgRG9jdW1lbnRhdGlvbi9udmRpbW0vbnZkaW1tLnR4dC4NCj4NCj4gVGhlIG5lZWQg
dG8gY2FsbCBhIF9EU00gYWZ0ZXIgYSBub3RpZmljYXRpb24gZXZlbnQgaXMgZG9jdW1lbnRlZCBp
bg0KPiB0aGUgQUNQSSBzcGVjLCBidXQgeW91J3JlIHJpZ2h0LCB3ZSBkbyBuZWVkIHRvIGNvbm5l
Y3QgdGhhdCBsYW5ndWFnZQ0KPiB0byB0aGUgTGludXggc3BlY2lmaWMgbWVjaGFuaXNtLg0KDQpT
b3VuZHMgZ3JlYXQuIMKgV2l0aCB0aGF0Og0KDQpSZXZpZXdlZC1ieTogVG9zaGkgS2FuaSA8dG9z
aGkua2FuaUBocGUuY29tPg0KDQpUaGFua3MhDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
