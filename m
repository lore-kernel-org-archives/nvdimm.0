Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 61E93211DF235
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 17:34:31 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id k11so14621345oic.7
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 17:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <54fb48ed-f681-1420-b2d0-082ed14802a7@inria.fr>
 <CAPcyv4g0KCON5KfTyeoK3UWApD=Gg=-eg=9Cc0OR-QcArXKMFA@mail.gmail.com>
 <f1374ac6-5007-8ac9-782d-d0615feb3b09@inria.fr>
 <CAPcyv4ivcUmiPSgS-27iB2dv455n64nmeSMh690QjYUTLmG1ow@mail.gmail.com>
 <c7e6e156-8060-35f4-8265-885cdc7b5a77@inria.fr>
 <CAPcyv4jzpbhPYQOCUpNLV5o_9tPP2FJNxFffg-uddBFMGQhbcQ@mail.gmail.com>
 <a4a352ce-d814-2f97-3773-e22ddd6bbdec@inria.fr>
 <CAPcyv4j_-irtAr3SD7gw2FNeKxM+OMAo04w5ms6SOVKupkMP0A@mail.gmail.com>
In-Reply-To: <CAPcyv4j_-irtAr3SD7gw2FNeKxM+OMAo04w5ms6SOVKupkMP0A@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 17:34:19 -0700
Message-ID: <CAPcyv4i1jT+_+Ya4N=2D4wg1iEo1dVqmc3Z5abyptaCUd6rhjw@mail.gmail.com>
Subject: Re: failure to setup devdax over fake nvdimm
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
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCBNYXIgMTYsIDIwMTkgYXQgMTI6NDggUE0gRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+IHdyb3RlOgo+Cj4gT24gU2F0LCBNYXIgMTYsIDIwMTkgYXQgMTE6MTYg
QU0gQnJpY2UgR29nbGluIDxCcmljZS5Hb2dsaW5AaW5yaWEuZnI+IHdyb3RlOgo+ID4KPiA+IExl
IDE2LzAzLzIwMTkgw6AgMTc6MTYsIERhbiBXaWxsaWFtcyBhIMOpY3JpdCA6Cj4gPiA+Cj4gPiA+
IFdoYXQgdmVyc2lvbiBvZiBuZGN0bD8gU291bmRzIGxpa2UgeW91IG1heSBiZSBydW5uaW5nIHNv
bWV0aGluZyBwcmlvcgo+ID4gPiB0byB2NjQgdGhhdCBkb2VzIG5vdCB1bmRlcnN0YW5kIHRoZSBu
ZXcgZGV2aWNlIHRvcG9sb2d5Lgo+ID4KPiA+Cj4gPiBJdCdzIG5kY3RsIGZyb20gZ2l0IG1hc3Rl
ciwgaGVuY2UgNjQuMS4KPiA+Cj4gPiBJIGFtIHVzaW5nIGEgc2ltaWxhciBzb2Z0d2FyZSBrZXJu
ZWwrbmRjdGwgb24gYSBtYWNoaW5lIHdpdGggcmVhbAo+ID4gbnZkaW1tcywgbm8gcHJvYmxlbSB0
aGVyZS4gSXQncyBvbmx5IHRoZSBtYWNoaW5lIHdpdGggZmFrZSBudmRpbW0gdXNpbmcKPiA+IG1l
bW1hcCB0aGF0IHNob3cgdGhpcyBpc3N1ZS4KPiA+Cj4KPiBIbW0sIGFsbCBteSBndWVzc2VzIGFy
ZSBjb21pbmcgdXAgZW1wdHkuLi4gd2hpY2ggdXN1YWxseSBtZWFucyB0aGVyZQo+IGlzIGluZGVl
ZCBhIGJ1Zy4gTGV0IG1lIHRyeSBzb21lIGV4cGVyaW1lbnRzIGhlcmUsIGJ1dCBJIG1heSBuZWVk
IHRvCj4gc2VuZCB5b3UgYSBkZWJ1ZyBwYXRjaCBmb3IgbW9yZSBpbmZvLiBUaGFua3MgZm9yIHRo
ZSBtZW1tYXA9Cj4gaW5zaWdodC4uLiBJIGRvIHRlc3Qgd2l0aCB0aGF0LCBidXQgbGV0IG1lIHNl
ZSBpZiB0aGVyZSBpcyBzb21ldGhpbmcKPiBzcGVjaWZpYyBhYm91dCB5b3VyIGNvbmZpZy4KCkJy
aWNlLCBtYXkgSSBhc2sgeW91IHRvIHJ1bjoKCiAgICB1ZGV2YWRtIG1vbml0b3IgLXAKCi4uLndo
aWxlIHJ1bm5pbmcgdGhlICJuZGN0bCBjcmVhdGUtbmFtZXNwYWNlIiBjb21tYW5kIGFuZCBzZW5k
IHRoZSBvdXRwdXQ/Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpo
dHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
