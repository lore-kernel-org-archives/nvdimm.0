Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B8CD021A16EC7
 for <linux-nvdimm@lists.01.org>; Tue, 30 May 2017 00:33:56 -0700 (PDT)
Received: by mail-pf0-x242.google.com with SMTP id n23so16057285pfb.3
 for <linux-nvdimm@lists.01.org>; Tue, 30 May 2017 00:34:55 -0700 (PDT)
Subject: Re: Fw: Panic when make check for ndctl
References: <20170529155643.5848.E1E9C6FF@jp.fujitsu.com>
 <c5a2a27e-50ee-b08f-4e2d-d8fbb496adfd@gmail.com>
 <CAPcyv4hGL8ZXfsnN4jossEr2VEFSA7iBaAnx94czryBy7cDahQ@mail.gmail.com>
From: Yasunori Goto <ygotopersonal@gmail.com>
Message-ID: <c769be43-0c73-8934-06a0-0c5b6f6a975d@gmail.com>
Date: Tue, 30 May 2017 16:34:51 +0900
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hGL8ZXfsnN4jossEr2VEFSA7iBaAnx94czryBy7cDahQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAyMDE35bm0MDXmnIgzMOaXpSAwODowNCwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+IE9uIE1v
biwgTWF5IDI5LCAyMDE3IGF0IDc6MjEgQU0sIFlhc3Vub3JpIEdvdG8gPHlnb3RvcGVyc29uYWxA
Z21haWwuY29tPiB3cm90ZToKPj4gSGVsbG8sCj4+IEkgdHJpZWQgIm1ha2UgY2hlY2siIG9mIG5k
Y3RsIGNvbW1hbmQgb24gdGhlIGtlcm5lbCBvZiBsaWJudmRpbW0tZm9yLW5leHQKPj4gYnJhbmNo
KCopLAo+PiBidXQgSSBmZWVsIGl0cyBrZXJuZWwgaXMgdW5zdGFibGUgd2hlbiBuZml0X3Rlc3Qu
a28gbW9kdWxlIGlzIGxvYWRlZC4KPj4KPj4gKCopICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvbnZkaW1tL252ZGltbQo+PiBsaWJudmRpbW0tZm9yLW5leHQK
Pj4gICAgICAgICAgVGhlIG5ld2VzdCBjb21taXQgaXMgZjU3MDVhYThjZmVkCj4+Cj4+IEhlcmUg
aXMgY29uc29sZSBsb2dzIHdoZW4gdGhlIGtlcm5lbCB3YXMgcGFuaWNlZCwgYW5kIEknbGwgYXR0
YWNoIHRoZSBrZXJuZWwKPj4gY29uZmlnIGZpbGUuCj4+Cj4+IERvZXMgYW55b25lIGtub3cgaG93
IHRvIHNvbHZlIHRoaXM/IEFtIEkgc29tZXRoaW5nIHdyb25nPwo+IE5vLCB5b3UncmUgbm90IGRv
aW5nIGFueXRoaW5nIHdyb25nLiBUaGlzIGlzIGEga25vd24gaXNzdWUgdGhhdCBJIGFtCj4gaW52
ZXN0aWdhdGluZy4gVGhlIHJlcG9ydHMgb2YgdGhpcyB1c3VhbGx5IGNvbWUgZnJvbSBkaXN0cmli
dXRpb25zCj4gd2l0aCBvbGRlciBtb2R1bGUgbG9hZGluZyBpbmZyYXN0cnVjdHVyZS4gSWYgeW91
IGNhbiB0cnkgd2l0aCBhIHJlY2VudAo+IEZlZG9yYSB0aGF0IHdvdWxkIG1pbWljIHRoZSBlbnZp
cm9ubWVudCBJIG5vcm1hbGx5IHVzZSB0byB0ZXN0LAoKT2gsIEkgc2VlLiBDZXJ0YWlubHksIEkg
dXNlZCBDZW50T1M3LgpPaywgSSdsbCB1c2UgRmVkb3JhIGVudmlyb25tZW50LgoKPiAgIGJ1dCBo
b3BlZnVsbHkgaW4gdGhlIG5leHQgd2VlayBvciBzbyBJJ2xsIHJvb3QgY2F1c2Ugd2hhdCBpcyB0
cmlnZ2VyaW5nCj4gdGhpcyBvbiBDZW50T1MgYW5kIERlYmlhbi4KVGhhbmtzLAoKQlRXLCBJIGNv
dWxkIHRha2UgdGhlIGNyYXNoIGR1bXAgd2hlbiB0aGlzIHBhbmljIG9jY3VycmVkLgpJcyB0aGUg
Y3Jhc2ggZHVtcCBoZWxwZnVsIGZvciB5b3VyIGludmVzdGlnYXRpb24gb2Ygcm9vdCBjYXVzZT8K
SWYgeWVzLCBJJ2xsIHVwbG9hZCB0aGUgZHVtcCB0byBnb29nbGUgc3RvcmFnZS4KClJlZ2FyZHMs
CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgt
bnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlz
dHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
