Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01on0137.outbound.protection.outlook.com [104.47.33.137])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E0771A1E9F
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jul 2016 21:08:05 -0700 (PDT)
From: "Sajjan, Vikas C" <vikas.cha.sajjan@hpe.com>
Subject: RE: [PATCH] dax: use devm_add_action_or_reset()
Date: Thu, 7 Jul 2016 04:02:26 +0000
Message-ID: <DF4PR84MB00411E7F9BC7755BE410881AD93B0@DF4PR84MB0041.NAMPRD84.PROD.OUTLOOK.COM>
References: <1467697807-27067-1-git-send-email-vikas.cha.sajjan@hpe.com>
 <20160705065904.ek4ltpveavadqdqt@c203.arch.suse.de>
 <CAPcyv4ivACkVySPL_-EQGWCVE=QHjQ+yBk-7tC12Ui29iuFWUQ@mail.gmail.com>
In-Reply-To: <CAPcyv4ivACkVySPL_-EQGWCVE=QHjQ+yBk-7tC12Ui29iuFWUQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogRGFuIFdpbGxpYW1zIFttYWlsdG86
ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tXSANClNlbnQ6IFRodXJzZGF5LCBKdWx5IDA3LCAyMDE2
IDM6NDkgQU0NClRvOiBKb2hhbm5lcyBUaHVtc2hpcm4gPGp0aHVtc2hpcm5Ac3VzZS5kZT4NCkNj
OiBTYWpqYW4sIFZpa2FzIEMgPHZpa2FzLmNoYS5zYWpqYW5AaHBlLmNvbT47IFJvc3MgWndpc2xl
ciA8cm9zcy56d2lzbGVyQGxpbnV4LmludGVsLmNvbT47IGxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmc7IExpbnV4IEFDUEkgPGxpbnV4LWFjcGlAdmdlci5rZXJuZWwub3JnPjsgS25pcHBlcnMsIExp
bmRhIDxsaW5kYS5rbmlwcGVyc0BocGUuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSF0gZGF4OiB1
c2UgZGV2bV9hZGRfYWN0aW9uX29yX3Jlc2V0KCkNCg0KVGhhbmtzLCBhcHBsaWVkLg0KDQpUaGFu
ayB5b3UsIERhbi4NCiANCk9uIE1vbiwgSnVsIDQsIDIwMTYgYXQgMTE6NTkgUE0sIEpvaGFubmVz
IFRodW1zaGlybiA8anRodW1zaGlybkBzdXNlLmRlPiB3cm90ZToNCj4gT24gVHVlLCBKdWwgMDUs
IDIwMTYgYXQgMTE6MjA6MDdBTSArMDUzMCwgVmlrYXMgQyBTYWpqYW4gd3JvdGU6DQo+PiBJZiBk
ZXZtX2FkZF9hY3Rpb24oKSBmYWlscywgd2UgYXJlIGV4cGxpY2l0bHkgY2FsbGluZyB0aGUgY2xl
YW51cCB0byANCj4+IGZyZWUgdGhlIHJlc291cmNlcyBhbGxvY2F0ZWQuIFVzZSB0aGUgaGVscGVy
IA0KPj4gZGV2bV9hZGRfYWN0aW9uX29yX3Jlc2V0KCkgYW5kIHJldHVybiBkaXJlY3RseSBpbiBj
YXNlIG9mIGVycm9yLCANCj4+IHNpbmNlIHRoZSBjbGVhbnVwIGZ1bmN0aW9uIGhhcyBiZWVuIGFs
cmVhZHkgY2FsbGVkIGJ5IHRoZSBoZWxwZXIgaWYgdGhlcmUgd2FzIGFueSBlcnJvci4NCj4+DQo+
PiBSZXBvcnRlZC1ieTogU3VkaXAgTXVraGVyamVlIDxzdWRpcG0ubXVraGVyamVlQGdtYWlsLmNv
bT4NCj4+IFNpZ25lZC1vZmYtYnk6IFZpa2FzIEMgU2FqamFuIDx2aWthcy5jaGEuc2FqamFuQGhw
ZS5jb20+DQo+DQo+IFJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGp0aHVtc2hpcm5A
c3VzZS5kZT4NCj4NCj4gLS0NCj4gSm9oYW5uZXMgVGh1bXNoaXJuICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgU3RvcmFnZQ0KPiBqdGh1bXNoaXJuQHN1c2UuZGUgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg5DQo+IFNVU0UgTElO
VVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnDQo+IEdGOiBGZWxpeCBJbWVu
ZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24gSFJCIDIxMjg0IChBRyANCj4g
TsO8cm5iZXJnKSBLZXkgZmluZ2VycHJpbnQgPSBFQzM4IDlDQUIgQzJDNCBGMjVEIDg2MDAgRDBE
MCAwMzkzIDk2OUQgDQo+IDJENzYgMDg1MA0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1A
bGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgt
bnZkaW1tCg==
