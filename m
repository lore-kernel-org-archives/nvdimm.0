Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C801B220E8CA6
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 16:15:51 -0700 (PDT)
From: "Schmauss, Erik" <erik.schmauss@intel.com>
Subject: RE: [PATCH v2 5/7] ACPICA: Integrate package handling with
 module-level code
Date: Mon, 16 Apr 2018 23:15:49 +0000
Message-ID: <CF6A88132359CE47947DB4C6E1709ED539727606@ORSMSX110.amr.corp.intel.com>
References: <20180215210932.15490-1-erik.schmauss@intel.com>
 <CAPcyv4hp_pm2n3H_froFkedd_GMQvsrEc8yZxYzfYkPDYvjDww@mail.gmail.com>
 <CF6A88132359CE47947DB4C6E1709ED5397230D6@ORSMSX110.amr.corp.intel.com>
 <3701399.BBZtpt46yJ@aspire.rjw.lan>
 <CAPcyv4j-iC+b07=JPP_TV1MLHA2iO5iKLvc+jaPHoEuRfzoAFQ@mail.gmail.com>
In-Reply-To: <CAPcyv4j-iC+b07=JPP_TV1MLHA2iO5iKLvc+jaPHoEuRfzoAFQ@mail.gmail.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Moore,
List-ID: <linux-nvdimm@lists.01.org>

WyB0cmltbWluZyBdDQo+ID4+IFJhZmFlbCwgd2UgbWF5IHdhbnQgdG8gaG9sZCBiYWNrIG9uIHRo
ZSBtb2R1bGUtbGV2ZWwgY29kZSBjaGFuZ2VzDQo+ID4+ICh0aGUgcGF0Y2hlcyBiZWxvdykgZm9y
IHJjMS4gQmV0d2VlbiB0aGlzIGFuZCB0aGUgc3RyYW5nZSBfVFNTIGlzc3VlLA0KPiA+PiBpdCBz
ZWVtcyBsaWtlIHRoZXJlIGFyZSBhIGZldyBtb3JlIHRoaW5ncyB0byByZXNvbHZlIGJlZm9yZSB0
aGlzIGlzDQo+ID4+IHJlYWR5IGZvciBrZXJuZWwgdXBzdHJlYW0uDQo+ID4NCkhpIFJhZmFlbCwN
Cg0KPiA+IEl0IGxvb2tzIGxpa2UgeW91IGFyZSBhc2tpbmcgbWUgdG8gcXVldWUgdXAgcmV2ZXJ0
cyBhcyBwZXIgdGhlIERhbidzDQo+ID4gcmVwb3J0LCBpcyB0aGF0IGNvcnJlY3Q/DQoNClRoaXMg
aXMgaW5kZWVkIHdoYXQgSSBtZWFudCBsYXN0IHdlZWsuIEhvd2V2ZXIsIEkndmUgbG9va2VkIGlu
dG8gdGhlIGlzc3VlIGFuZCBEYW4ncyBxZW11DQppbnN0YW5jZSBoYWQgQU1MIHRoYXQgd2Ugbm8g
bG9uZ2VyIHN1cHBvcnQuIFRoaXMgaXMgYmVjYXVzZSB0aGUgQUNQSUNBIGNvbW1pdCBtYWtlcyBj
aGFuZ2VzIHRvIHRoZSBleGVjdXRpb24gb2YgQU1MDQpkdXJpbmcgdGFibGUgbG9hZCB0byBtYXRj
aCB3aW5kb3dzIEFNTCBpbnRlcnByZXRlciBiZWhhdmlvciBzbyB0aGlzIGNvbW1pdCBhbHNvIGdv
dCByaWQgb2Ygc3VwcG9ydCBmb3IgZXhlY3V0aW5nIGNvZGUNCmNvbnRhaW5pbmcgZm9yd2FyZCBy
ZWZlcmVuY2VzIChleGNlcHQgZm9yIHBhY2thZ2UgZWxlbWVudHMpLg0KDQpJJ3ZlIHN1Z2dlc3Rl
ZCBhIGZpeCBmb3IgdGhlIGZpcm13YXJlIGluIGEgc2VwYXJhdGUgZW1haWwuIFNvIEkgd291bGQg
c2F5IHRoYXQgdGhpcyBpc3N1ZSBpcyByZXNvbHZlZCBhZnRlciBpZiBEYW4gY2FuIHJ1bg0KaGlz
IHRlc3Qgc3VjY2Vzc2Z1bGx5IHdpdGggdGhlIGFkanVzdGVkIGZpcm13YXJlLg0KDQpJZiBEYW4n
cyB0ZXN0IGlzIHN1Y2Nlc3NmdWwsIHdlIGRvbuKAmXQgbmVlZCB0byByZXZlcnQgdGhlc2UgY2hh
bmdlcw0KDQpFcmlrDQoNCj4gDQo+IE5vdGUsIHRoYXQgSSdtIHdpbGxpbmcgdG8gdHJ5IGFueSBw
cm9wb3NlZCBmaXggcGF0Y2hlcyBvbiB0b3AuIEkganVzdCB3YW50ZWQgdG8NCj4gY2xhcmlmeSB0
aGF0IHdlIGhhdmUgYSBzaW1wbGUgZmFsbGJhY2sgcG9zaXRpb24gaWYgdGhlIGRlYnVnIHN0YXJ0
cyBkcmFnZ2luZyBvdXQuDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
