Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F9542244E410
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 16:22:00 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id d9-v6so19379087oth.10
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 16:22:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CF6A88132359CE47947DB4C6E1709ED539727606@ORSMSX110.amr.corp.intel.com>
References: <20180215210932.15490-1-erik.schmauss@intel.com>
 <CAPcyv4hp_pm2n3H_froFkedd_GMQvsrEc8yZxYzfYkPDYvjDww@mail.gmail.com>
 <CF6A88132359CE47947DB4C6E1709ED5397230D6@ORSMSX110.amr.corp.intel.com>
 <3701399.BBZtpt46yJ@aspire.rjw.lan>
 <CAPcyv4j-iC+b07=JPP_TV1MLHA2iO5iKLvc+jaPHoEuRfzoAFQ@mail.gmail.com>
 <CF6A88132359CE47947DB4C6E1709ED539727606@ORSMSX110.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Apr 2018 16:21:58 -0700
Message-ID: <CAPcyv4jEkQTEWxE=+mf0C5oA0j50ZvjU=QpvL1n6mmtemrnBLg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] ACPICA: Integrate package handling with
 module-level code
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
To: "Schmauss, Erik" <erik.schmauss@intel.com>
Cc: Qemu Developers <qemu-devel@nongnu.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Moore,
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCBBcHIgMTYsIDIwMTggYXQgNDoxNSBQTSwgU2NobWF1c3MsIEVyaWsgPGVyaWsuc2No
bWF1c3NAaW50ZWwuY29tPiB3cm90ZToKPiBbIHRyaW1taW5nIF0KPj4gPj4gUmFmYWVsLCB3ZSBt
YXkgd2FudCB0byBob2xkIGJhY2sgb24gdGhlIG1vZHVsZS1sZXZlbCBjb2RlIGNoYW5nZXMKPj4g
Pj4gKHRoZSBwYXRjaGVzIGJlbG93KSBmb3IgcmMxLiBCZXR3ZWVuIHRoaXMgYW5kIHRoZSBzdHJh
bmdlIF9UU1MgaXNzdWUsCj4+ID4+IGl0IHNlZW1zIGxpa2UgdGhlcmUgYXJlIGEgZmV3IG1vcmUg
dGhpbmdzIHRvIHJlc29sdmUgYmVmb3JlIHRoaXMgaXMKPj4gPj4gcmVhZHkgZm9yIGtlcm5lbCB1
cHN0cmVhbS4KPj4gPgo+IEhpIFJhZmFlbCwKPgo+PiA+IEl0IGxvb2tzIGxpa2UgeW91IGFyZSBh
c2tpbmcgbWUgdG8gcXVldWUgdXAgcmV2ZXJ0cyBhcyBwZXIgdGhlIERhbidzCj4+ID4gcmVwb3J0
LCBpcyB0aGF0IGNvcnJlY3Q/Cj4KPiBUaGlzIGlzIGluZGVlZCB3aGF0IEkgbWVhbnQgbGFzdCB3
ZWVrLiBIb3dldmVyLCBJJ3ZlIGxvb2tlZCBpbnRvIHRoZSBpc3N1ZSBhbmQgRGFuJ3MgcWVtdQo+
IGluc3RhbmNlIGhhZCBBTUwgdGhhdCB3ZSBubyBsb25nZXIgc3VwcG9ydC4gVGhpcyBpcyBiZWNh
dXNlIHRoZSBBQ1BJQ0EgY29tbWl0IG1ha2VzIGNoYW5nZXMgdG8gdGhlIGV4ZWN1dGlvbiBvZiBB
TUwKPiBkdXJpbmcgdGFibGUgbG9hZCB0byBtYXRjaCB3aW5kb3dzIEFNTCBpbnRlcnByZXRlciBi
ZWhhdmlvciBzbyB0aGlzIGNvbW1pdCBhbHNvIGdvdCByaWQgb2Ygc3VwcG9ydCBmb3IgZXhlY3V0
aW5nIGNvZGUKPiBjb250YWluaW5nIGZvcndhcmQgcmVmZXJlbmNlcyAoZXhjZXB0IGZvciBwYWNr
YWdlIGVsZW1lbnRzKS4KPgo+IEkndmUgc3VnZ2VzdGVkIGEgZml4IGZvciB0aGUgZmlybXdhcmUg
aW4gYSBzZXBhcmF0ZSBlbWFpbC4gU28gSSB3b3VsZCBzYXkgdGhhdCB0aGlzIGlzc3VlIGlzIHJl
c29sdmVkIGFmdGVyIGlmIERhbiBjYW4gcnVuCj4gaGlzIHRlc3Qgc3VjY2Vzc2Z1bGx5IHdpdGgg
dGhlIGFkanVzdGVkIGZpcm13YXJlLgo+Cj4gSWYgRGFuJ3MgdGVzdCBpcyBzdWNjZXNzZnVsLCB3
ZSBkb27igJl0IG5lZWQgdG8gcmV2ZXJ0IHRoZXNlIGNoYW5nZXMKCkknbSBjb25jZXJuZWQgYWJv
dXQgb3RoZXIgcWVtdS1rdm0gdXNlcnMgdGhhdCBkbyBub3QgdXBncmFkZSB0aGVpcgpoeXBlcnZp
c29yIGF0IHRoZSBzYW1lIHBhY2UgYXMgdGhlaXIgZ3Vlc3Qga2VybmVsLiBFc3BlY2lhbGx5IGZv
cgpjbG91ZCBwcm92aWRlcnMgdGhhdCBtYXkgYmUgcnVubmluZyBsYXRlc3QgbWFpbmxpbmUga2Vy
bmVsIG9uIG9sZGVyCnFlbXUta3ZtIHRoaXMgd2lsbCBsb29rIGxpa2UgYSBwdXJlIGtlcm5lbCBy
ZWdyZXNzaW9uLiBJcyB0aGVyZSBhCnF1aWNrIGZpeCB3ZSBjYW4gY2FycnkgaW4gdGhlIGtlcm5l
bCB0byBzdXBwb3J0IHRoZXNlIGZvcndhcmQKcmVmZXJlbmNlcywgYXQgbGVhc3QgdW50aWwgd2Ug
a25vdyB0aGF0IHFlbXUta3ZtIGlzIG5vIGxvbmdlciBzaGlwcGluZwp0aGUgYnJva2VuIEFNTD8K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
