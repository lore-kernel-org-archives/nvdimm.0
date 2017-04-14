Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BFC3321A18AAA
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 12:52:59 -0700 (PDT)
From: "Rudoff, Andy" <andy.rudoff@intel.com>
Subject: Re: [ndctl PATCH] ndctl, check: Add a sigbus handler to detect
 metadata corruption
Date: Fri, 14 Apr 2017 19:52:58 +0000
Message-ID: <01C2D860-110D-407F-A8FA-2892AF38EB88@intel.com>
References: <20170414000251.23904-1-vishal.l.verma@intel.com>
 <F7CF62AA-B1F5-486D-AA87-F61674B86AC5@intel.com>
 <1492196446.1657.1.camel@intel.com>
 <CAPcyv4hc8d15yUs133ZG5V4+7R+CfdPaDA0661JX95ZcnLK0sw@mail.gmail.com>
 <D56299A3-A5A4-4B49-AFC6-5F03118F1F85@intel.com>
 <1492198820.1657.3.camel@intel.com>
In-Reply-To: <1492198820.1657.3.camel@intel.com>
Content-Language: en-US
Content-ID: <024F31CC5F63F34182BDE2A63CBBE0E3@intel.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

DQogICAgPklmIHdlIGhpdCBhIGtub3duIGJhZGJsb2NrLCB0aGF0IGlzIDUxMkIgd29ydGggb2Yg
bWFwIGVudHJpZXMgKDEyOCkuDQogICAgPlNob3VsZCB3ZSByZWFsbHkgKGFsbW9zdCBjZXJ0YWlu
bHkpIHNjcmFtYmxlIDY0IGJsb2Nrcz8gOikNCiAgICA+SWYgaXQgaXMgYSBsYXRlbnQgZXJyb3Is
IGl0IHdpbGwgc3RpbGwgYmUgYXQgbGVhc3QgYSBjYWNoZSBsaW5lIHdvcnRoDQogICAgPm9mIG1h
cCBlbnRyaWVzLCBpLmUuIDE2Lg0KICAgID4NCiAgICA+SWYgYW4gZXJyb3IgaXMgaW4gdGhlIGxv
ZywgdGhlbiBpbiB0aGUgYmFkYmxvY2sgY2FzZSwgd2UgbG9zZSBib3RoIGxvZw0KICAgID5hbmQg
bG9nJyBmb3IgZm91ciBsYW5lcy4gV2hpY2ggbWVhbnMgd2UgY2FuJ3QgdGVsbCBpcyBvbmUgb2Yg
dGhvc2UgNA0KICAgID5lbnRyaWVzIG5lZWRlZCBhIG1hcCB1cGRhdGUsIGxlYXZpbmcgYSBwb3Rl
bnRpYWwgY29ycnVwdGlvbiB3aW5kb3cNCiAgICA+b3Blbi4NCiAgICANCkJlZm9yZSByZXNwb25k
aW5nIHRvIHRoaXMsIGNhbiB5b3Ugd2FsayBtZSB0aHJvdWdoIHRoZSBzdGVwcw0KYSB1c2VyIGlz
IGV4cGVjdGVkIHRvIHRha2UgaWYgcG9pc29uIGFwcGVhcnMgdGhlIGZsb2csIGZvciBleGFtcGxl
Pw0KU2F5IEkganVzdCB3YW50IHRvIGNvcHkgb3V0IGFzIG11Y2ggZGF0YSBhcyBJIGNhbiBnZXQs
IHRoZW4gcmVjcmVhdGUNCmEgZnJlc2ggQlRULiAgSSB0aGluayB5b3XigJlyZSB0ZWxsaW5nIG1l
IHRoYXQgYSBwb2lzb25lZCBmbG9nIHByZXZlbnRzDQptZSBmcm9tIHVzaW5nIHRoZSBlbnRpcmUg
ZGV2aWNlLCBidXQgbWF5YmUgSeKAmW0gd3JvbmcgYW5kIHlvdeKAmXJlDQpzYXlpbmcgSSBjYW4g
c3RpbGwgZ2V0IHRvIHRoZSBvdGhlciBhcmVuYXM/DQoNCkFueXdheSwgYWZ0ZXIgY29weWluZyBv
dXQgd2hhdCBJIGNhbiwgaG93IGRvIEkgcmVjcmVhdGUgdGhlIEJUVD8NCldoZW4gdGhlIEJUVCBj
cmVhdGlvbiBjb2RlIHN0YXJ0cyB3cml0aW5nIHRoZSBuZXcgZmxvZywgd2lsbCB0aGF0DQpjbGVh
ciB0aGUgcG9pc29uPyAgRG9lcyB0aGUgQlRUIGNyZWF0aW9uIGNvZGUgZG8gYmlnIGVub3VnaCB3
cml0ZXMNCnNvIHRoZSBkcml2ZXIgd2lsbCBpc3N1ZSBDbGVhciBVbmNvcnJlY3RhYmxlIGNvbW1h
bmRzPw0KDQpXaXRoIHlvdXIgYW5zd2VycywgSSB0aGluayB3ZSBjYW4gY3JlYXRlIGEgdHlwaWNh
bCB1c2VyIGZsb3csDQp3aGVyZSB0aGUgdXNlciBnZXRzIGVycm9yIG1lc3NhZ2VzIGFuZCB0cmll
cyB0byB1c2Ugb3VyIHRvb2xzDQp0byBmaXggdGhpbmdzLiAgVGhhdCBzaG91bGQgdGVsbCB1cyBp
ZiB3ZeKAmXJlIG9uIHRoZSByaWdodCB0cmFjaw0Kb3IgaWYgd2XigJlyZSBzdHJhbmRpbmcgdGhl
IHBvb3IgdXNlciB3aXRoIG5vIHdheSB0byByZWNvdmVy4oCmDQoNClRoYW5rcywNCg0KLWFuZHkN
Cg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51
eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9s
aXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
