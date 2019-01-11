Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com
 [IPv6:2607:f8b0:4864:20::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FF32211B1110
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 14:07:12 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id c206so13496851oib.0
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 14:07:12 -0800 (PST)
MIME-Version: 1.0
References: <47b0eaaa-ad49-5062-5f1f-fb6f79b2448d@oracle.com>
 <3908561D78D1C84285E8C5FCA982C28F7D4C4F61@ORSMSX110.amr.corp.intel.com>
 <ca4e6f85-9bf1-9421-5207-ac855882c245@oracle.com>
In-Reply-To: <ca4e6f85-9bf1-9421-5207-ac855882c245@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jan 2019 14:07:00 -0800
Message-ID: <CAPcyv4jo8-Mgoa0=2bD9uTUy17VJGVZvj-Pf_RszPmv=Q_GQpQ@mail.gmail.com>
Subject: Re: 23222f8f8dce6: acpi, nfit: Add function to look up nvdimm device
 and provide SMBIOS handle
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
To: Jane Chu <jane.chu@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBKYW4gMTEsIDIwMTkgYXQgMjowMyBQTSBKYW5lIENodSA8amFuZS5jaHVAb3JhY2xl
LmNvbT4gd3JvdGU6Cj4KPiBPbiAxLzExLzIwMTkgMTo1NCBQTSwgTHVjaywgVG9ueSB3cm90ZToK
Pgo+ID4gSmFuZSwKPiA+Cj4gPiBJdCBkb2VzIGxvb2sgYSBiaXQgZmlzaHkuICBCdXQgaWYgdGhl
cmUgaXMgYW4gaXNzdWUgd2l0aCDigJxtZW1kZXbigJ0KPiA+IGNoYW5naW5nIG9uY2Ugd2UgcmVs
ZWFzZSB0aGUgbG9ja3MsCj4gPgo+ID4gdGhlbiBpdCB3aWxsIG9ubHkgaGVscCBhIGxpdHRsZSB0
byBtb3ZlIHRoZSDigJwqZmxhZ3MgPSBtZW1kZXYtPmZsYWdz4oCdCj4gPiBiYWNrIGJlZm9yZSB3
ZSByZWxlYXNlIHRoZSBsb2Nrcy4KPiA+Cj4gPiBOb3RlIHRoYXQgd2UgYWNjZXNzIG1lbWRldiBv
bmUgbW9yZSB0aW1lIHdpdGggdGhlIOKAnHJldHVybgo+ID4gbWVtZGV2LT5waHlzaWNhbF9pZOKA
nQo+ID4KPiBJbmRlZWQsIHRoYXQgbGluZSB0b28uCj4KPiA+IEJ1dCBJ4oCZbSBub3QgYXQgYWxs
IHN1cmUgd2hhdCB0aGUgcG9zc2libGUgcmFjZXMgYXJlIGhlcmUuIEkgaG9wZQo+ID4gc29tZW9u
ZSBmcm9tIHRoZSBsaW54LW52ZGltbSBsaXN0Cj4gPgo+ID4gY2FuIGNvbW1lbnQuIEkgdGhpbmsg
SSBqdXN0IGN1dCAmIHBhc3RlZCB0aGUgYnVsayBvZiB0aG9zZSBuZXN0ZWQKPiA+IGxvb3BzIGZy
b20gZWxzZXdoZXJlLiBBcyBmYXIgYXMgSQo+ID4KPiA+IGtub3cgd2UgZG9u4oCZdCBjdXJyZW50
bHkgaGF2ZSBhbnkgc3VwcG9ydCBmb3IgaG90cGx1ZyBORklUIGRldmljZXMsIHNvCj4gPiBJIHN1
c3BlY3QgdGhlcmUgaXMgY3VycmVudGx5Cj4gPgo+ID4gbm8gcmFjZSBoZXJlLgo+ID4KPiBJIGRv
bid0IHVuZGVyc3RhbmQgdGhlIGJ1bGsgb2YgdGhlIGNvZGUsIGp1c3QgdHJ5aW5nIHRvIGZvbGxv
dyB3aGF0IHlvdSBzYWlkCj4gaGVyZS4gIFNvIGlmIHdlICpldmVyKiBkZWNpZGUgdG8gc3VwcG9y
dCBob3RwbHVnIE5GSVQgZGV2aWNlLCB3aGF0IHdvdWxkIHJlbWluZAo+IHVzIHRvIGNsb3NlIHRo
ZSByYWNlIGhlcmU/ICAgSXMgdGhlcmUgYW55IGhhcm0gdG8gcmVmZXJlbmNlIG1lbWRldiB3aGls
ZSB3ZQo+IHN0aWxsIGhhdmUgdGhlIGxvY2tzPwoKTm8gaGFybSBpbiBmaXhpbmcgaXQgdXAsIEkn
ZCB0YWtlIHRoYXQgcGF0Y2ggaWYgeW91IHdyb3RlIGl0IHVwLgoKVGhlcmUgaXMgcG90ZW50aWFs
bHkgYSByYWNlIHRvZGF5IGlmIHRoZSBrZXJuZWwgd2FzIGNhbGxpbmcgdGhpcwpyb3V0aW5lLCBi
dXQgc29tZSBvdGhlciB0aHJlYWQgd2FzIGRvaW5nOgoKICAgZWNobyAiQUNQSTAwMTI6MDAiID4g
L3N5cy9idXMvYWNwaS9kcml2ZXJzL25maXQvdW5iaW5kCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgt
bnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZv
L2xpbnV4LW52ZGltbQo=
