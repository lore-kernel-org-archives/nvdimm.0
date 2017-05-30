Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBB5E21A16EC7
 for <linux-nvdimm@lists.01.org>; Tue, 30 May 2017 04:43:33 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id l18so107579579oig.2
 for <linux-nvdimm@lists.01.org>; Tue, 30 May 2017 04:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c769be43-0c73-8934-06a0-0c5b6f6a975d@gmail.com>
References: <20170529155643.5848.E1E9C6FF@jp.fujitsu.com>
 <c5a2a27e-50ee-b08f-4e2d-d8fbb496adfd@gmail.com>
 <CAPcyv4hGL8ZXfsnN4jossEr2VEFSA7iBaAnx94czryBy7cDahQ@mail.gmail.com>
 <c769be43-0c73-8934-06a0-0c5b6f6a975d@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 May 2017 04:44:31 -0700
Message-ID: <CAPcyv4jp7TVZ9-7-ZGHT=K2fbRABfCiyMfjGosD2Du5hm_QitQ@mail.gmail.com>
Subject: Re: Fw: Panic when make check for ndctl
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
To: Yasunori Goto <ygotopersonal@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCBNYXkgMzAsIDIwMTcgYXQgMTI6MzQgQU0sIFlhc3Vub3JpIEdvdG8gPHlnb3RvcGVy
c29uYWxAZ21haWwuY29tPiB3cm90ZToKPgo+Cj4gT24gMjAxN+W5tDA15pyIMzDml6UgMDg6MDQs
IERhbiBXaWxsaWFtcyB3cm90ZToKPj4KPj4gT24gTW9uLCBNYXkgMjksIDIwMTcgYXQgNzoyMSBB
TSwgWWFzdW5vcmkgR290byA8eWdvdG9wZXJzb25hbEBnbWFpbC5jb20+Cj4+IHdyb3RlOgo+Pj4K
Pj4+IEhlbGxvLAo+Pj4gSSB0cmllZCAibWFrZSBjaGVjayIgb2YgbmRjdGwgY29tbWFuZCBvbiB0
aGUga2VybmVsIG9mIGxpYm52ZGltbS1mb3ItbmV4dAo+Pj4gYnJhbmNoKCopLAo+Pj4gYnV0IEkg
ZmVlbCBpdHMga2VybmVsIGlzIHVuc3RhYmxlIHdoZW4gbmZpdF90ZXN0LmtvIG1vZHVsZSBpcyBs
b2FkZWQuCj4+Pgo+Pj4gKCopICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvbnZkaW1tL252ZGltbQo+Pj4gbGlibnZkaW1tLWZvci1uZXh0Cj4+PiAgICAgICAg
ICBUaGUgbmV3ZXN0IGNvbW1pdCBpcyBmNTcwNWFhOGNmZWQKPj4+Cj4+PiBIZXJlIGlzIGNvbnNv
bGUgbG9ncyB3aGVuIHRoZSBrZXJuZWwgd2FzIHBhbmljZWQsIGFuZCBJJ2xsIGF0dGFjaCB0aGUK
Pj4+IGtlcm5lbAo+Pj4gY29uZmlnIGZpbGUuCj4+Pgo+Pj4gRG9lcyBhbnlvbmUga25vdyBob3cg
dG8gc29sdmUgdGhpcz8gQW0gSSBzb21ldGhpbmcgd3Jvbmc/Cj4+Cj4+IE5vLCB5b3UncmUgbm90
IGRvaW5nIGFueXRoaW5nIHdyb25nLiBUaGlzIGlzIGEga25vd24gaXNzdWUgdGhhdCBJIGFtCj4+
IGludmVzdGlnYXRpbmcuIFRoZSByZXBvcnRzIG9mIHRoaXMgdXN1YWxseSBjb21lIGZyb20gZGlz
dHJpYnV0aW9ucwo+PiB3aXRoIG9sZGVyIG1vZHVsZSBsb2FkaW5nIGluZnJhc3RydWN0dXJlLiBJ
ZiB5b3UgY2FuIHRyeSB3aXRoIGEgcmVjZW50Cj4+IEZlZG9yYSB0aGF0IHdvdWxkIG1pbWljIHRo
ZSBlbnZpcm9ubWVudCBJIG5vcm1hbGx5IHVzZSB0byB0ZXN0LAo+Cj4KPiBPaCwgSSBzZWUuIENl
cnRhaW5seSwgSSB1c2VkIENlbnRPUzcuCj4gT2ssIEknbGwgdXNlIEZlZG9yYSBlbnZpcm9ubWVu
dC4KPgo+PiAgIGJ1dCBob3BlZnVsbHkgaW4gdGhlIG5leHQgd2VlayBvciBzbyBJJ2xsIHJvb3Qg
Y2F1c2Ugd2hhdCBpcyB0cmlnZ2VyaW5nCj4+IHRoaXMgb24gQ2VudE9TIGFuZCBEZWJpYW4uCj4K
PiBUaGFua3MsCj4KPiBCVFcsIEkgY291bGQgdGFrZSB0aGUgY3Jhc2ggZHVtcCB3aGVuIHRoaXMg
cGFuaWMgb2NjdXJyZWQuCj4gSXMgdGhlIGNyYXNoIGR1bXAgaGVscGZ1bCBmb3IgeW91ciBpbnZl
c3RpZ2F0aW9uIG9mIHJvb3QgY2F1c2U/Cj4gSWYgeWVzLCBJJ2xsIHVwbG9hZCB0aGUgZHVtcCB0
byBnb29nbGUgc3RvcmFnZS4KClRoYW5rcyBmb3IgdGhlIG9mZmVyLiBJIGRvIGhhdmUgYWNjZXNz
IHRvIGEgc3lzdGVtIHRoYXQgY2FuIHJlcHJvZHVjZQp0aGlzIHNvIG5vIG5lZWQgdG8gY29sbGVj
dCB0aGUgY3Jhc2ggZHVtcC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
