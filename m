Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F83B21954088
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 13:16:03 -0700 (PDT)
From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH] acpi, nfit: fix the memory error check in nfit_handle_mce
Date: Fri, 21 Apr 2017 20:16:00 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F6127653B@ORSMSX114.amr.corp.intel.com>
References: <20170420221818.23522-1-vishal.l.verma@intel.com>
 <CAPcyv4ijU2V-4WOPysL12ByOovAXDO=Mci1D4wNDFqxRjdvT2w@mail.gmail.com>
 <1492804517.2738.25.camel@intel.com>
In-Reply-To: <1492804517.2738.25.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Pj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoIShtY2UtPnN0YXR1cyAmIDB4ZWY4MCkgPT0gQklUKDcp
KQ0KPj4gDQo+PiBDYW4gd2UgZ2V0IGEgZGVmaW5lIGZvciB0aGlzLCBvciBhIGNvbW1lbnQgZXhw
bGFpbmluZyBhbGwgdGhlIG1hZ2ljDQo+PiB0aGF0J3MgaGFwcGVuaW5nIG9uIHRoYXQgb25lIGxp
bmU/DQo+DQo+IFllcyAtIGFsc28gbGlrZSBsa3AgcG9pbnRlZCBvdXQsIHRoZSBjaGVjayBpc24n
dCBjb3JyZWN0IGF0IGFsbC4gTGV0IG1lDQo+IGZpZ3VyZSBvdXQgd2hhdCByZWFsbHkgbmVlZHMg
dG8gYmUgZG9uZSwgYW5kIEkgd2lsbCByZXNlbmQgd2l0aCBhIGJldHRlcg0KPiBjb21tZW50LiAN
Cg0KTmVlZHMgZXh0cmEgcGFyZW50aGVzZXMgdG8gbWFrZSBpdCByaWdodC4gVmlzaGFsLCBzb3Jy
eSBJIGxlZCB5b3UgYXN0cmF5Lg0KDQoJaWYgKCEoKG1jZS0+c3RhdHVzICYgMHhlZjgwKSA9PSBC
SVQoNykpKQ0KDQpUaGUgbWFnaWMgaXMgc2hvd24gaW4gdGFibGUgMTUtOSBvZiB0aGUgSW50ZWwg
U29mdHdhcmUgRGV2ZWxvcGVycyBNYW51YWwNCihidXQgcGVyaGFwcyBub3Qgd2VsbCBleHBsYWlu
ZWQgdGhlcmUpLg0KDQptY2UtPnN0YXR1cyBpbiB0aGUgYWJvdmUgY29kZSBpcyBhIHZhbHVlIHBs
dWNrZWQgZnJvbSBhIG1hY2hpbmUgY2hlY2sNCmJhbmsgc3RhdHVzIHJlZ2lzdGVyLiBTZWUgZmln
dXJlIDE1LTYgaW4gdGhlIFNETS4gIFRoZSBpbXBvcnRhbnQgYml0cyBmb3IgdGhpcw0KYXJlIHsx
NTowfSB3aGljaCBhcmUgdGhlICJNQ0EgRXJyb3IgY29kZSIuICBUYWJsZSAxNS05IHNob3dzIGhv
dyB0aGVzZQ0KYXJlIGdyb3VwZWQgaW50byB0eXBlcywgd2hlcmUgdGhlIHR5cGUgaXMgZGVmaW5l
ZCBieSB0aGUgbW9zdCBzaWduaWZpY2FudCAnMScNCmJpdCBpbiB0aGUgZmllbGQgKGV4Y2x1ZGlu
ZyBiaXQgMTIgd2hpY2ggaXMgdGhlIENvcnJlY3Rpb24gUmVwb3J0IEZpbHRlcmluZyBiaXQsDQpz
ZWUgc2VjdGlvbiAxNS45LjIuMSkuDQoNClNvIGlmIEJJVCgzKSBpcyB0aGUgbW9zdCBzaWduaWZp
Y2FudCBiaXQsIHRoZSB0aGlzIGlzIGEgIkdlbmVyaWMgQ2FjaGUgSGllcmFyY2h5Ig0KZXJyb3Is
IEJJVCg0KSBkZW5vdGVzIGEgVExCIGVycm9yLCBCSVQoNykgYSBNZW1vcnkgZXJyb3IsIGFuZCBz
byBvbi4NCg0KTWF5YmUgd2Ugc2hvdWxkIGhhdmUgZGVmaW5lcyBpbiBtY2UuaCBmb3IgdGhlbT8g
IEl0IGdldHMgYSBiaXQgbW9yZSBjb21wbGljYXRlZA0KYXMgYWxsIHRoZSBhYm92ZSBvbmx5IGFw
cGxpZXMgdG8gSW50ZWwgYnJhbmRlZCBYODYgQ1BVcyAuLi4gb24gQU1EIGRpZmZlcmVudA0KZGVj
b2RpbmcgcnVsZXMgYXBwbHkuDQoNCi1Ub255DQoNCg0KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1u
dmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8v
bGludXgtbnZkaW1tCg==
