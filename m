Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14A5221213EE5
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 15:45:11 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 1/4] ndctl, util: add OPTION_FILENAME to parse_opt_type
Date: Tue, 12 Jun 2018 22:45:09 +0000
Message-ID: <1528843507.4998.8.camel@intel.com>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
 <20180507050926.17243-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4hcq4jbsP=tSHJ2NqDVAFepmT0UQj-xJVt3KjauHw3ZVA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222766C70A@g01jpexmbkw01>
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222766C70A@g01jpexmbkw01>
Content-Language: en-US
Content-ID: <8BC8D490BC0BC94681B0EBD4A9AC5166@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE4LTA1LTE2IGF0IDAyOjQyICswMDAwLCBRaSwgRnVsaSB3cm90ZToNCj4gPiAt
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IERhbiBXaWxsaWFtcyBbbWFpbHRv
OmRhbi5qLndpbGxpYW1zQGludGVsLmNvbV0NCj4gPiBTZW50OiBTYXR1cmRheSwgTWF5IDEyLCAy
MDE4IDE6NDIgQU0NCj4gPiBUbzogUWksIEZ1bGkv5paJIOemj+WIqSA8cWkuZnVsaUBqcC5mdWpp
dHN1LmNvbT4NCj4gPiBDYzogbGludXgtbnZkaW1tIDxsaW51eC1udmRpbW1AbGlzdHMuMDEub3Jn
Pg0KPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjYgMS80XSBuZGN0bCwgdXRpbDogYWRkIE9QVElP
Tl9GSUxFTkFNRSB0bw0KPiA+IHBhcnNlX29wdF90eXBlDQo+ID4gDQo+ID4gT24gU3VuLCBNYXkg
NiwgMjAxOCBhdCAxMDowOSBQTSwgUUkgRnVsaSA8cWkuZnVsaUBqcC5mdWppdHN1LmNvbT4NCj4g
PiB3cm90ZToNCj4gPiA+IFRoaXMgcGF0Y2ggYm9ycm93cyB0aGUgT1BUSU9OX0ZJTEVOQU1FIGZy
b20gZ2l0IHRvIG5kY3RsIHRvIG1ha2Ugc3VyZQ0KPiA+ID4gZmlsZW5hbWUgaXMgY29ycmVjdC4g
U29tZSByZWxhdGVkIHJlZmFjdG9yaW5nIGlzIGFsc28gaW5jbHVkZWQ6DQo+ID4gPiAgIC0gYWRk
cyBwYXJzZV9vcHRpb25zX3ByZWZpeCgpIGludGVyZmFjZQ0KPiA+ID4gICAtIG1vdmVzIGlzX2Fi
c29sdXRlIGZyb20gdXRpbC9oZWxwLmMgdG8gdXRpbC91dGlsLmMNCj4gPiA+ICAgLSBhZGRzIGEg
bmV3IGZpbGUgdXRpbC9hYnNwYXRoLmMNCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogUUkg
RnVsaSA8cWkuZnVsaUBqcC5mdWppdHN1LmNvbT4NCj4gPiANCj4gPiBSZXZpZXdlZC1ieTogRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gDQo+IA0KPiBTaW5jZSB0
aGlzIHBhdGNoIGlzIGluZGVwZW5kZW50IGZyb20gdGhlIG90aGVycywgY291bGQgeW91IHBsZWFz
ZSBtZXJnZQ0KPiB0aGlzIG9uZSBmaXJzdD8NCg0KSGkgUWksDQoNClllcyBJIGhhdmUgYXBwbGll
ZCB0aGUgZmlyc3QgcGF0Y2gsIGFuZCBpdCBpcyBub3cgaW4gdGhlIHBlbmRpbmcgYnJhbmNoLg0K
DQpUaGFua3MsDQoJLVZpc2hhbApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
