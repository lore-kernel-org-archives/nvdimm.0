Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C58F121A18AAB
 for <linux-nvdimm@lists.01.org>; Tue, 18 Apr 2017 09:09:17 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, check: Add a sigbus handler to detect
 metadata corruption
Date: Tue, 18 Apr 2017 16:09:11 +0000
Message-ID: <1492531749.3344.1.camel@intel.com>
References: <20170414000251.23904-1-vishal.l.verma@intel.com>
 <x49lgqzqc32.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49lgqzqc32.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Content-ID: <656E400A0DA32744BCAD13BE3F190084@intel.com>
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
To: "jmoyer@redhat.com" <jmoyer@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTA0LTE3IGF0IDExOjM3IC0wNDAwLCBKZWZmIE1veWVyIHdyb3RlOg0KPiBW
aXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4gd3JpdGVzOg0KPiANCj4gPiBJ
ZiB3ZSBoYXZlIHBvaXNvbi9iYWRibG9ja3MgaW4gdGhlIEJUVCBtZXRhZGF0YSBzZWN0aW9ucywg
dGhlIG1tYXAtDQo+ID4gcmVhZHMNCj4gPiBoYXBwZW5pbmcgaW4gdGhlIGNoZWNrZXIgd2lsbCB0
cmlnZ2VyIGEgU0lHQlVTLCBhbmQgdGhlIHByb2dyYW0NCj4gPiB3aWxsDQo+ID4gaGFsdCBhYnJ1
cHRseS4gQWRkIGEgc2lnYnVzIGhhbmRsZXIgd2hpY2ggbm90aWZpZXMgdGhlIHVzZXIgb2YNCj4g
PiB0aGlzLCBhbmQNCj4gPiBwcmludHMgb3V0IGEgcmVsZXZhbnQgZXJyb3IgbWVzc2FnZToNCj4g
DQo+IFRoaXMgaXNuJ3QgbXVjaCBiZXR0ZXIgdGhhbiBqdXN0IHNlZ2ZhdWx0aW5nLsKgwqBEaWQg
eW91IGNvbnNpZGVyDQo+IHdoZXRoZXINCj4gaXQgd2FzIHBvc3NpYmxlIHRvIHJlY29uc3RydWN0
IGNvcnJ1cHQgbWV0YWRhdGEgaW4gYW55IGNpcmN1bXN0YW5jZXM/DQo+IA0KDQpUaGUgb25seSBz
cG90IHdlIGNhbiBhY3R1YWxseSBjb3JyZWN0IG1ldGFkYXRhIHdvdWxkIGJlIGZvciBhbiBpbmZv
DQpibG9jaywgaWYgdGhlIGNvcHkgaXMgaW50YWN0LiBGb3IgYW55IG90aGVyIHBvaXNvbiBpbiB0
aGUgbWFwIG9yIGZsb2csDQpJIGRvbid0IHRoaW5rIHdlIGhhdmUgYW55IHdheSB0byByZWNvdmVy
LiBXYXMgdGhhdCAoaW5mbyBibG9ja3MpIHdoYXQNCnlvdSBtZWFudCwgb3Igc29tZXRoaW5nIGVs
c2U/Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
