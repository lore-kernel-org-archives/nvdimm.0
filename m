Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96E43219516BC
 for <linux-nvdimm@lists.01.org>; Tue,  9 May 2017 09:56:05 -0700 (PDT)
Received: from G9W8453.americas.hpqcorp.net (g9w8453.houston.hp.com
 [16.216.160.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g9t5009.houston.hpe.com (Postfix) with ESMTPS id A2BF87A
 for <linux-nvdimm@lists.01.org>; Tue,  9 May 2017 16:56:04 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 2/2] ndctl: add list --media-errors support
Date: Tue, 9 May 2017 16:55:56 +0000
Message-ID: <1494348939.30303.73.camel@hpe.com>
References: <149428467512.44955.4085670669863366983.stgit@djiang5-desk3.ch.intel.com>
 <149428468046.44955.6721097374196988691.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149428468046.44955.6721097374196988691.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTA1LTA4IGF0IDE2OjA0IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
ZGRpbmcgb3B0aW9uIGZvciBuZGN0bCBsaXN0IGNvbW1hbmQgdG8gc2hvdyBiYWRibG9ja3MgZm9y
IHJlZ2lvbiBhbmQNCj4gZGV2aWNlLiBUaGUgZGV2aWNlIGJhZGJsb2NrcyBhcmUgY2FsY3VsYXRl
ZCBmcm9tIHRoZSByZWdpb24NCj4gYmFkYmxvY2tzLiBUaGlzIGFsbG93cyB0aGUgdXNlciB0byBw
cm92aWRlIHRoZSBwcm9wZXIgYmFkYmxvY2sgb2Zmc2V0DQo+IGFuZCBsZW5ndGggZm9yIGNsZWFy
aW5nIGxhdGVyIG9uLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFu
Z0BpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoG5kY3RsL2xpc3QuY8KgwqDCoMKgwqDCoHzCoMKgwqAx
NyArKysrKysrKysrKysrKy0tLQ0KPiDCoG5kY3RsL25hbWVzcGFjZS5jIHzCoMKgwqDCoDIgKy0N
Cj4gwqAyIGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQoN
CkhpIERhdmUsDQoNCkl0IHNob3dzIHRoZSBzYW1lIGJhZGJsb2NrIG9mZnNldCB0d2ljZS4gIFRo
ZSB2YWx1ZSBpcyBjb3JyZWN0IGZvcg0KMTU3Mjg2NC4gIHN0cmFjZS5sb2cgaXMgYXR0YWNoZWQg
Zm9yIG1vcmUgaW5mby4NCg0KIyBjYXQgL3N5cy9idXMvbmQvZGV2aWNlcy9yZWdpb24wL3NpemUN
CjE3MTc5ODY5MTg0DQoNCiMgY2F0IC9zeXMvY2xhc3MvZGF4L2RheDAuMC9zaXplDQoxNjkwOTMz
NjU3Ng0KDQojIGNhdCAvc3lzL2J1cy9uZC9kZXZpY2VzL3JlZ2lvbjAvYmFkYmxvY2tzDQoxMDQ4
NTc2IDENCjE1NzI4NjQgMQ0KDQojIG5kY3RsIGxpc3QgLS1tZWRpYS1lcnJvcnMgLS1tb2RlPWRh
eA0Kew0KwqAgImRldiI6Im5hbWVzcGFjZTAuMCIsDQrCoCAibW9kZSI6ImRheCIsDQrCoCAic2l6
ZSI6MTY5MDkzMzY1NzYsDQrCoCAidXVpZCI6IjhjNzE4MTFmLTI2MGQtNDc4OC04NDg3LWRiODhk
ODI5ZDM5MyIsDQrCoCAiYmFkYmxvY2tzIjpbDQrCoMKgwqDCoHsNCsKgwqDCoMKgwqDCoCJvZmZz
ZXQiOjEwNDQ0ODAsDQrCoMKgwqDCoMKgwqAibGVuZ3RoIjoxDQrCoMKgwqDCoH0sDQrCoMKgwqDC
oHsNCsKgwqDCoMKgwqDCoCJvZmZzZXQiOjEwNDQ0ODAsDQrCoMKgwqDCoMKgwqAibGVuZ3RoIjox
DQrCoMKgwqDCoH0NCsKgIF0NCn0NCg0KVGhhbmtzLA0KLVRvc2hpDQpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0
CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9s
aXN0aW5mby9saW51eC1udmRpbW0K
