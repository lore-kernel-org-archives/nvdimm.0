Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E046F21A16ECB
 for <linux-nvdimm@lists.01.org>; Wed, 14 Jun 2017 18:19:55 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 02/14] dm: add ->copy_from_iter() dax operation support
Date: Thu, 15 Jun 2017 01:21:08 +0000
Message-ID: <1497489635.9288.18.camel@hpe.com>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703983692.20620.3787021839815275819.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1497487541.9288.16.camel@hpe.com>
In-Reply-To: <1497487541.9288.16.camel@hpe.com>
Content-Language: en-US
Content-ID: <E1E5D9D30646AA43A340A60F7CD7EFE9@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA2LTE0IGF0IDE4OjQ1IC0wNjAwLCBUb3NoaSBLYW5pIHdyb3RlOg0KPiBP
biBGcmksIDIwMTctMDYtMDkgYXQgMTM6MjMgLTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4g
PiBBbGxvdyBkZXZpY2UtbWFwcGVyIHRvIHJvdXRlIGNvcHlfZnJvbV9pdGVyIG9wZXJhdGlvbnMg
dG8gdGhlDQo+ID4gcGVyLXRhcmdldCBpbXBsZW1lbnRhdGlvbi4gSW4gb3JkZXIgZm9yIHRoZSBk
ZXZpY2Ugc3RhY2tpbmcgdG8gd29yaw0KPiA+IHdlIG5lZWQgYSBkYXhfZGV2IGFuZCBhIHBnb2Zm
IHJlbGF0aXZlIHRvIHRoYXQgZGV2aWNlLiBUaGlzIGdpdmVzDQo+ID4gZWFjaCBsYXllciBvZiB0
aGUgc3RhY2sgdGhlIGluZm9ybWF0aW9uIGl0IG5lZWRzIHRvIGxvb2sgdXAgdGhlDQo+ID4gb3Bl
cmF0aW9uIHBvaW50ZXIgZm9yIHRoZSBuZXh0IGxldmVsLg0KPiA+IA0KPiA+IFRoaXMgY29uY2Vw
dHVhbGx5IGFsbG93cyBmb3IgYW4gYXJyYXkgb2YgbWl4ZWQgZGV2aWNlIGRyaXZlcnMgd2l0aA0K
PiA+IHZhcnlpbmcgY29weV9mcm9tX2l0ZXIgaW1wbGVtZW50YXRpb25zLg0KPiA+IA0KPiA+IENj
OiBUb3NoaSBLYW5pIDx0b3NoaS5rYW5pQGhwZS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IE1pa2Ug
U25pdHplciA8c25pdHplckByZWRoYXQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IERhbiBXaWxs
aWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiANCj4gSSB3YXMgd29ycmllZCBhYm91
dCBwb3NzaWJsZSBvdmVyaGVhZCB3aXRoIGFkZGl0aW9uYWwgc3R1YiBjYWxscywgYnV0DQo+IGl0
IGxvb2tzIGZpbmUgd2l0aCBhIHNpbmdsZSB0aHJlYWQgZmlvIHdyaXRlIHRlc3Qgd2l0aCBkaXJl
Y3Q9MS4NCj4gDQo+IMKgOTIuNjIlwqDCoFtrZXJuZWwua2FsbHN5bXNdwqDCoMKgW2tdIF9fY29w
eV91c2VyX25vY2FjaGUNCj4gwqAgMC4wNCXCoMKgW2tlcm5lbC5rYWxsc3ltc13CoMKgwqBba10g
ZW50cnlfU1lTQ0FMTF82NF9mYXN0cGF0aA0KPiDCoCAwLjA4JcKgwqBsaWJwdGhyZWFkLTIuMjIu
c2/CoMKgWy5dIF9fR0lfX19saWJjX3dyaXRlDQo+IMKgIDAuMDElwqDCoFtrZXJuZWwua2FsbHN5
bXNdwqDCoMKgW2tdIHN5c193cml0ZQ0KPiDCoCAwLjAyJcKgwqBba2VybmVsLmthbGxzeW1zXcKg
wqDCoFtrXSB2ZnNfd3JpdGUNCj4gwqAgMC4wMiXCoMKgW2tlcm5lbC5rYWxsc3ltc13CoMKgwqBb
a10gX192ZnNfd3JpdGUNCj4gwqAgMC4wMiXCoMKgW2tlcm5lbC5rYWxsc3ltc13CoMKgwqBba10g
ZXh0NF9maWxlX3dyaXRlX2l0ZXINCj4gwqAgMC4wMiXCoMKgW2tlcm5lbC5rYWxsc3ltc13CoMKg
wqBba10gZGF4X2lvbWFwX3J3DQo+IMKgIDAuMDMlwqDCoFtrZXJuZWwua2FsbHN5bXNdwqDCoMKg
W2tdIGlvbWFwX2FwcGx5DQo+IMKgIDAuMDQlwqDCoFtrZXJuZWwua2FsbHN5bXNdwqDCoMKgW2td
IGRheF9pb21hcF9hY3Rvcg0KPiDCoCAwLjAxJcKgwqBba2VybmVsLmthbGxzeW1zXcKgwqDCoFtr
XSBkYXhfY29weV9mcm9tX2l0ZXINCj4gwqAgMC4wMSXCoMKgW2tlcm5lbC5rYWxsc3ltc13CoMKg
wqBba10gZG1fZGF4X2NvcHlfZnJvbV9pdGVyDQo+IMKgIDAuMDElwqDCoFtrZXJuZWwua2FsbHN5
bXNdwqDCoMKgW2tdIGxpbmVhcl9kYXhfY29weV9mcm9tX2l0ZXINCj4gwqAgMC4wMyXCoMKgW2tl
cm5lbC5rYWxsc3ltc13CoMKgwqBba10gY29weV9mcm9tX2l0ZXJfZmx1c2hjYWNoZQ0KPiDCoCAw
LjAwJcKgwqBba2VybmVsLmthbGxzeW1zXcKgwqDCoFtrXSBwbWVtX2NvcHlfZnJvbV9pdGVyDQoN
CkkgaGFkIGJzPTI1NmssIHdoaWNoIHdhcyB0b28gYmlnIGZvciB0aGlzIHRlc3QuICBicz00ayBy
ZXN1bHQgaXMgbm90DQp0aGlzIHByZXR0eSBhdCBhbGwsIG9ubHkgMjMlIGluIF9fY29weV91c2Vy
X25vY2FjaGUuICBUaGlzIGNoYW5nZQ0KYWNjb3VudHMgZm9yIGFwcHJveC4gMSUgd2l0aCA0ay4g
IEdpdmVuIHdlIGhhdmUgbGFyZ2VyIG92ZXJoZWFkcyBpbg0KbWFueSBvdGhlciBmdW5jdGlvbnMg
aW4gdGhlIHBhdGgsIHRoZSBjaGFuZ2UgbG9va3MgYWNjZXB0YWJsZSAoSSBrZWVwDQpteSByZXZp
ZXctYnkpLiAgSSdkIHByZWZlciB0byByZWR1Y2UgY29kZSBpbiB0aGUgcGF0aCwgdGhvdWdoLg0K
DQpUaGFua3MsDQotVG9zaGkNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAx
Lm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
