Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF987817A7
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 14:05:41 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 0/7] introduce 'daxctl list', and 'ndctl list'
 updates
Date: Mon, 9 Jan 2017 22:05:40 +0000
Message-ID: <1483999472.4414.0.camel@intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170109215636.GA5330@omniknight.lm.intel.com>
 <CAPcyv4gUcb-Swm2t8yySq67BYBkoufBLE+vunionOLx2Rt_Oaw@mail.gmail.com>
In-Reply-To: <CAPcyv4gUcb-Swm2t8yySq67BYBkoufBLE+vunionOLx2Rt_Oaw@mail.gmail.com>
Content-Language: en-US
Content-ID: <969BCBA1FF7E2F4CBECDD422CA1CC497@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTAxLTA5IGF0IDE0OjAwIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgSmFuIDksIDIwMTcgYXQgMTo1NiBQTSwgVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20NCj4gPiB3cm90ZToNCj4gPiBPbiAwMS8wNiwgRGFuIFdpbGxpYW1zIHdy
b3RlOg0KPiA+ID4gKiBUaGUgJ25kY3RsIGxpc3QnIGNvbW1hbmQgYXdrd2FyZGx5IHByaW50cyBv
dXQgYWxsIHRoZQ0KPiA+ID4gY29ycmVzcG9uZGluZw0KPiA+ID4gwqAgZGV2aWNlLWRheCBpbmZv
cm1hdGlvbiB3aGVuIGEgbmFtZXNwYWNlIGlzIGluICdkYXgnIG1vZGUuDQo+ID4gPiBDb252ZXJz
ZWx5IGlmDQo+ID4gPiDCoCBzb21lb25lIGlzIG9ubHkgaW50ZXJlc3RlZCBpbiBsaXN0aW5nIGRl
dmljZS1kYXggaW5mb3JtYXRpb24NCj4gPiA+IHRoZXkgbmVlZCB0bw0KPiA+ID4gwqAgY29udGVu
ZCB3aXRoIGxpYm52ZGltbSBkYXRhLg0KPiA+ID4gDQo+ID4gPiDCoCBJbnRyb2R1Y2UgYSBzZXBh
cmF0ZSBkYXhjdGwgdXRpbGl0eSB3aXRoIGl0cyBvd24gJ2xpc3QnIGNvbW1hbmQNCj4gPiA+IGZv
ciB0aGlzDQo+ID4gPiDCoCBwdXJwb3NlLCBhbmQgbWFrZSB0aGUgbGlzdGluZyBvZiBkZXZpY2Ut
ZGF4IGRhdGEgdGhyb3VnaCAnbmRjdGwNCj4gPiA+IGxpc3QnDQo+ID4gPiDCoCBvcHRpb25hbCAo
bmV3IC0tZGV2aWNlLWRheCBvcHRpb24pLg0KPiA+IA0KPiA+IHRoZSAncnBtYnVpbGQnIHNjcmlw
dCB3YXMgZmFpbGluZyBhcyB0aGUgbmV3IGRheGN0bCB1dGlsaXR5IHdhc24ndA0KPiA+IGluY2x1
ZGVkIGluICVmaWxlcyBpbiB0aGUgc3BlYy4gVGhlIGZvbGxvd2luZyBwYXRjaCBmaXhlcyB0aGF0
Lg0KPiA+IA0KPiA+IDg8LS0tLS0NCj4gPiANCj4gPiBGcm9tIGQyNmE1ODJiNGFlOWU2OWEyMmU1
MjkwOGE1ZDRiYmFlMGE3OTcxN2YgTW9uIFNlcCAxNyAwMDowMDowMA0KPiA+IDIwMDENCj4gPiBG
cm9tOiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gPiBEYXRlOiBN
b24sIDkgSmFuIDIwMTcgMTQ6NTI6MzQgLTA3MDANCj4gPiBTdWJqZWN0OiBbUEFUQ0hdIHNwZWM6
IGFkZCB0aGUgbmV3IGRheGN0bCBiaW5hcnkgdG8gdGhlIHNwZWMgZmlsZQ0KPiA+IA0KPiA+IFRo
ZSBtaXNzaW5nIGJpbmFyeSB3YXMgdHJpZ2dlcmluZyB0aGUgImluc3RhbGxlZCBidXQgdW5wYWNr
YWdlZCBmaWxlDQo+ID4gZm91bmQiIGNoZWNrIGZvciBycG1idWlsZC4gQWRkIGRheGN0bCB0byB0
aGUgJWZpbGVzIHNlY3Rpb24gYXMgd2UgZG8NCj4gPiB3YW50IGl0IHRvIGJlIHBhY2thZ2VkLg0K
PiANCj4gWWVzLCB3ZSBkbyB3YW50IGl0IHBhY2thZ2VkLCBidXQgaW4gaXQncyBvd24gcnBtLiBJ
IGhhdmUgcGF0Y2ggdG8gYWRkDQo+IHRoYXQgYXMgd2VsbCBhcyBhIGRheGN0bCBtYW4gcGFnZS4N
Cg0KQWggb2sgLSBJIHRob3VnaHQgaXQgd291bGQganVzdCBnZXQgaW5zdGFsbGVkIGFzIGEgcGFy
dCBvZiB0aGUgbmRjdGwNCnJwbS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
