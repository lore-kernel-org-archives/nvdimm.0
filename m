Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 7A7A71A1E04
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 13:22:31 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] acpi, nfit: fix acpi event notifications for nfit
Date: Thu, 18 Aug 2016 20:22:29 +0000
Message-ID: <1471551711.6177.25.camel@intel.com>
References: <1471546104-28520-1-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4ixygjD8St5YP2SjfEJnVeWMsAHjqDTF8xxWPvvDWw_bw@mail.gmail.com>
 <07af328e-d703-fd80-20be-725f00e54812@hpe.com>
 <CAPcyv4gM8SNLGn+ATELbBoOZWqk80_XYu41z-PDTs-3ONCGLeA@mail.gmail.com>
In-Reply-To: <CAPcyv4gM8SNLGn+ATELbBoOZWqk80_XYu41z-PDTs-3ONCGLeA@mail.gmail.com>
Content-Language: en-US
Content-ID: <1B49B1C567C3B54C9574FE8F8A2C0B5F@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linda.knippers@hpe.com" <linda.knippers@hpe.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "guangrong.xiao@linux.intel.com" <guangrong.xiao@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTA4LTE4IGF0IDEyOjU0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgQXVnIDE4LCAyMDE2IGF0IDEyOjUyIFBNLCBMaW5kYSBLbmlwcGVycyA8bGluZGEu
a25pcHBlcnNAaHBlLmMNCj4gb20+IHdyb3RlOg0KPiA+IA0KPiA+IA0KPiA+IA0KPiA+IE9uIDgv
MTgvMjAxNiAzOjQ4IFBNLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+ID4gPiANCj4gPiA+IE9uIFRo
dSwgQXVnIDE4LCAyMDE2IGF0IDExOjQ4IEFNLCBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1h
QGludA0KPiA+ID4gZWwuY29tPiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+IFRoZSBuZml0IGRy
aXZlciBoYWQgYW4gYWNwaSBldmVudCBub3RpZmljYXRpb24gaGFuZGxlciwgYnV0IGl0DQo+ID4g
PiA+IG5ldmVyDQo+ID4gPiA+IHdvdWxkJ3ZlIHdvcmtlZCBiZWNhdXNlIHdlIHdlcmVuJ3Qgc2V0
dGluZyB0aGUNCj4gPiA+ID4gQUNQSV9EUklWRVJfQUxMX05PVElGWV9FVkVOVFMgZmxhZyBpbiBh
Y3BpX2RyaXZlci4NCj4gPiA+IA0KPiA+ID4gTGV0J3MgdXBkYXRlIHRoZSBjaGFuZ2Vsb2cgdG8g
YmUgaGVscGZ1bCBmb3Igc29tZW9uZSBpbXBsZW1lbnRpbmcNCj4gPiA+IGENCj4gPiA+IGJhY2tw
b3J0IG9yIHRha2luZyB0aGlzIGJhY2sgdG8gYSAtc3RhYmxlIGJyYW5jaC7CoMKgU29tZXRoaW5n
IGxpa2U6DQo+ID4gPiANCj4gPiA+IFN1YmplY3Q6IGFjcGksIG5maXQ6IGZpeCBldmVudCBub3Rp
ZmljYXRpb25zDQo+ID4gPiANCj4gPiA+IENvbW1pdCAyMDk4NTE2NDlkYzQgImFjcGk6IG5maXQ6
IEFkZCBzdXBwb3J0IGZvciBob3QtYWRkIiBhZGRlZA0KPiA+ID4gc3VwcG9ydCBmb3IgX0ZJVCBu
b3RpZmljYXRpb25zLCBidXQgaXQgbmVnbGVjdGVkIHRvIHNldCB0aGUNCj4gPiA+IEFDUElfRFJJ
VkVSX0FMTF9OT1RJRllfRVZFTlRTIGZsYWcgdGhhdCBhY3BpX2J1c19ub3RpZnkoKSB1c2VzIHRv
DQo+ID4gPiBnYXRlDQo+ID4gPiBub3RpZmljYXRpb24gZGVsaXZlcnkuDQo+ID4gDQo+ID4gV2hp
bGUgd2UncmUgYXQgaXQsIHNob3VsZCB3ZSB1cGRhdGUgdGhlIG5vdGlmaWVyIGZ1bmN0aW9uIHRv
DQo+ID4gZXhwbGljaXRseSBjaGVjaw0KPiA+IGZvciBldmVudCAweDgwIGJlZm9yZSByZS1ldmFs
dWF0aW5nIHRoZSBfRklUP8KgwqBJJ20gdGhpbmtpbmcgYWJvdXQNCj4gPiBzb21lIHRpbWUNCj4g
PiBpbiB0aGUgZnV0dXJlIHdoZW4gdGhlcmUgbWlnaHQgYmUgbW9yZSB0aGFuIG9uZSBldmVudC4N
Cj4gDQo+IFllcywgZ29vZCBpZGVhLg0KDQpTb3VuZHMgZ29vZCwgcGFydCBvZiB0aGUgc2FtZSBw
YXRjaCBvciBzZXBhcmF0ZWx5PwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
