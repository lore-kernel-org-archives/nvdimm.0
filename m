Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx-out01.mykolab.com (mx01.mykolab.com [95.128.36.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D598A1A1E66
 for <linux-nvdimm@lists.01.org>; Thu, 28 Apr 2016 16:24:46 -0700 (PDT)
Message-ID: <1461885878.11211.1.camel@stellar.sh>
Subject: Re: [PATCH v2] test: Add a unit test for dax error handling
From: Vishal Verma <vishal@stellar.sh>
Date: Thu, 28 Apr 2016 17:24:38 -0600
In-Reply-To: <1461438854-3828-1-git-send-email-vishal.l.verma@intel.com>
References: <1461438854-3828-1-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
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
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCAyMDE2LTA0LTIzIGF0IDEzOjE0IC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6Cj4g
V2hlbiB3ZSBoYXZlIGEgbmFtZXNwYWNlIHdpdGggbWVkaWEgZXJyb3JzLCBEQVggc2hvdWxkIGZh
aWwgd2hlbgo+IHRyeWluZwo+IHRvIG1hcCB0aGUgYmFkIGJsb2NrcyBmb3IgZGlyZWN0IGFjY2Vz
cywgYnV0IGEgcmVndWxhciB3cml0ZSgpIHRvIHRoZQo+IHNhbWUgc2VjdG9yIHNob3VsZCBnbyB0
aHJvdWdoIHRoZSBkcml2ZXIgYW5kIGNsZWFyIHRoZSBlcnJvci4KPiBUaGlzIHRlc3QgY2hlY2tz
IGZvciBhbGwgb2YgdGhlIGFib3ZlIGhhcHBlbmluZyAtIGZhaWx1cmUgZm9yIGEKPiByZWFkKCkK
PiBvbiBhIGZpbGUgd2l0aCBhIGJhZCBibG9jaywgZmFpbHVyZSBvbiBhbiBtbWFwLXJlYWQgZm9y
IHRoZSBzYW1lLCBhbmQKPiBmaW5hbGx5IGEgc3VjY2Vzc2Z1bCB3cml0ZSB0aGF0IGNsZWFycyB0
aGUgYmFkIGJsb2NrLgo+IAo+IEl0IGFsc28gdGVzdHMgdGhhdCBhIGhvbGUgcHVuY2ggdG8gYSBi
YWRibG9jayAoaWYgdGhlIGhvbGUtcHVuY2ggaXMKPiBzZWN0b3IgYWxpZ25lZCBhbmQgc2l6ZWQp
IGNsZWFycyB0aGUgZXJyb3IuCj4gCj4gU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNo
YWwubC52ZXJtYUBpbnRlbC5jb20+Cj4gLS0tCj4gCj4gdjI6IEFsc28gdGVzdCB0aGF0IHB1bmNo
aW5nIGEgaG9sZSBjbGVhcnMgcG9pc29uLgo+IAo+IMKgTWFrZWZpbGUuYW3CoMKgwqDCoMKgwqDC
oMKgfMKgwqDCoDUgKy0KPiDCoHRlc3QvZGF4LWVycm9ycy5jwqDCoHwgMTM5Cj4gKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiDCoHRlc3QvZGF4
LWVycm9ycy5zaCB8IDEyNgo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwo+IMKgMyBmaWxlcyBjaGFuZ2VkLCAyNjggaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKPiDCoGNyZWF0ZSBtb2RlIDEwMDY0NCB0ZXN0L2RheC1lcnJvcnMuYwo+IMKgY3Jl
YXRlIG1vZGUgMTAwNzU1IHRlc3QvZGF4LWVycm9ycy5zaAoKTm90ZSB0aGF0IHRoaXMgdGVzdCBh
cy1pcyBpcyBhbHJlYWR5IGNvcnJlY3QgZm9yIHRoZSB2NCBvZiB0aGUgREFYCmVycm9yIGhhbmRs
aW5nIHNlcmllcyBzaW5jZSB3ZSBhbHJlYWR5IG9wZW4gd2l0aCBPX0RJUkVDVCBpbiBkYXgtCmVy
cm9ycy5jCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
