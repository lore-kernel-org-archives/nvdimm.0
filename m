Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FC4B21D49C82
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 13:17:37 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: QEMU NVDIMM as type 7 in e820 table
Date: Fri, 28 Jul 2017 20:19:15 +0000
Message-ID: <1501272590.2042.91.camel@hpe.com>
References: <20170728180446.GA31104@linux.intel.com>
 <CAPcyv4i5YWK6RHYEkH6C1oPWwhPLOD-atmkMVXDXc-qdv_0hgw@mail.gmail.com>
 <20170728194543.GA20726@linux.intel.com>
In-Reply-To: <20170728194543.GA20726@linux.intel.com>
Content-Language: en-US
Content-ID: <75AF5876A80935459CC26B6A26E3417D@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "stefanha@gmail.com" <stefanha@gmail.com>, "mst@redhat.com" <mst@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "guangrong.xiao@gmail.com" <guangrong.xiao@gmail.com>, "imammedo@redhat.com" <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA3LTI4IGF0IDEzOjQ1IC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6DQo+
IE9uIEZyaSwgSnVsIDI4LCAyMDE3IGF0IDExOjExOjEwQU0gLTA3MDAsIERhbiBXaWxsaWFtcyB3
cm90ZToNCj4gPiBPbiBGcmksIEp1bCAyOCwgMjAxNyBhdCAxMTowNCBBTSwgUm9zcyBad2lzbGVy
DQo+ID4gPHJvc3Muendpc2xlckBsaW51eC5pbnRlbC5jb20+IHdyb3RlOg0KIDoNCj4gPiBEbyB5
b3UgbmVlZCB0aGF0IGluZm9ybWF0aW9uaW4gZTgyMD8gTGludXggZWZmZWN0aXZlbHkgaWdub3Jl
cw0KPiA+IHR5cGUtNy4gQXMgbG9uZyBhcyB0aGUgcmFuZ2UgaXMgdHJlYXRlZCBhcyByZXNlcnZl
ZCBpdCdzIG5vdCBjbGVhcg0KPiA+IHRoYXQgeW91IG5lZWQgdGhlIGU4MjAgZW50cnkuIFdlIGFs
c28gaW5mZWN0IHRoZSBwZXJzaXN0ZW50IHR5cGUNCj4gPiBiYWNrIGludG8gdGhlIG1lbW9yeSBt
YXAgd2hlbiB0aGUgTkZJVCBkcml2ZXIgbG9hZHMuIC9wcm9jL2lvbWVtDQo+ID4gc2hvdWxkIHNo
b3cgdGhlIHJpZ2h0IGRhdGEuDQo+IA0KPiBbIEFkZGluZyBMaW5kYSAmIFRvc2hpIHRvIHNlZSBp
ZiB0aGV5IGhhdmUgYW4gb3Bpbmlvbi4gXQ0KPiANCj4gSSBndWVzcyBtYXliZSB3ZSBkb24ndCBu
ZWVkIGl0LsKgwqBZZXAsIC9wcm9jL2lvbWVtIGxvb2tzIGdvb2Q6DQo+IA0KPiDCoCAjIGNhdCAv
cHJvYy9pb21lbQ0KPiDCoCAwMDAwMDAwMC0wMDAwMGZmZiA6IFJlc2VydmVkDQo+IMKgIDAwMDAx
MDAwLTAwMDlmYmZmIDogU3lzdGVtIFJBTQ0KPiDCoCAuLi4NCj4gwqAgMTAwMDAwMDAwLTIzZmZm
ZmZmZiA6IFN5c3RlbSBSQU0NCj4gwqAgMjQwMDAwMDAwLWEzZmZmZmZmZiA6IFBlcnNpc3RlbnQg
TWVtb3J5DQo+IMKgwqDCoMKgMjQwMDAwMDAwLWEzZmZmZmZmZiA6IG5hbWVzcGFjZTAuMA0KPiAN
Cj4gSSB3YXMganVzdCB3b3JyaWVkIHRoYXQgdGhpcyB3YXMgYW4gaW5jb25zaXN0ZW5jeSBiZXR3
ZWVuIHRoZSB3YXkNCj4gdGhhdCB2aXJ0dWFsIE5WRElNTXMgYXJlIHByZXNlbnRlZCB2cyB0aGUg
d2F5IHRoYXQgdGhleSB3aWxsIGJlDQo+IHByZXNlbnRlZCBvbiBiYXJlIG1ldGFsLsKgwqBJIGF0
IGxlYXN0IGxvb2sgYXQgdGhlIGU4MjAgdGFibGUgdG8gZ2V0IG15DQo+IGJlYXJpbmdzIG9mIGhv
dyBtZW1vcnkgaXMgbGFpZCBvdXQgLSBtYXliZSBJIGp1c3QgbmVlZCB0byBsb29rIGF0DQo+IC9w
cm9jL2lvbWVtIGluc3RlYWQ/DQoNCkZXIHNob3VsZCBwcmVzZW50IGEgcGVyc2lzdGVudCBtZW1v
cnkgcmFuZ2UgaW4gZTgyMCBvciBVRUZJIG1lbW9yeQ0KZGVzY3JpcHRvciB0YWJsZS4gIFNvLCBp
dCdzIGEgZ29vZCBwcmFjdGljZSBmb3IgUUVNVSB0byBkbyBpdCBhcyB3ZWxsLg0KDQpUaGF0IHNh
aWQsIHRoZSBORklUIGRyaXZlciBpbnNlcnRzIGEgcGVyc2lzdGVudCBtZW1vcnkgcmFuZ2UgdG8g
dGhlDQprZXJuZWwgSU8gcmVzb3VyY2UgdGFibGUgZnJvbSBORklULCBzbyB3ZSBhcmUgT0sgd2l0
aG91dCB0aGlzIGluZm8uIA0KWWVzLCAvcHJvYy9pb21lbSBzaG93cyBob3cgdGhlIHJlc291cmNl
cyBhcmUgbWFuYWdlZCBieSB0aGUga2VybmVsLg0KDQpUaGFua3MsDQotVG9zaGkNCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWls
aW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
