Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com
 [IPv6:2607:f8b0:4864:20::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35AFB211D56BE
 for <linux-nvdimm@lists.01.org>; Sat, 16 Mar 2019 12:48:31 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id b4so10036599oif.6
 for <linux-nvdimm@lists.01.org>; Sat, 16 Mar 2019 12:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <54fb48ed-f681-1420-b2d0-082ed14802a7@inria.fr>
 <CAPcyv4g0KCON5KfTyeoK3UWApD=Gg=-eg=9Cc0OR-QcArXKMFA@mail.gmail.com>
 <f1374ac6-5007-8ac9-782d-d0615feb3b09@inria.fr>
 <CAPcyv4ivcUmiPSgS-27iB2dv455n64nmeSMh690QjYUTLmG1ow@mail.gmail.com>
 <c7e6e156-8060-35f4-8265-885cdc7b5a77@inria.fr>
 <CAPcyv4jzpbhPYQOCUpNLV5o_9tPP2FJNxFffg-uddBFMGQhbcQ@mail.gmail.com>
 <a4a352ce-d814-2f97-3773-e22ddd6bbdec@inria.fr>
In-Reply-To: <a4a352ce-d814-2f97-3773-e22ddd6bbdec@inria.fr>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 16 Mar 2019 12:48:18 -0700
Message-ID: <CAPcyv4j_-irtAr3SD7gw2FNeKxM+OMAo04w5ms6SOVKupkMP0A@mail.gmail.com>
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

T24gU2F0LCBNYXIgMTYsIDIwMTkgYXQgMTE6MTYgQU0gQnJpY2UgR29nbGluIDxCcmljZS5Hb2ds
aW5AaW5yaWEuZnI+IHdyb3RlOgo+Cj4gTGUgMTYvMDMvMjAxOSDDoCAxNzoxNiwgRGFuIFdpbGxp
YW1zIGEgw6ljcml0IDoKPiA+Cj4gPiBXaGF0IHZlcnNpb24gb2YgbmRjdGw/IFNvdW5kcyBsaWtl
IHlvdSBtYXkgYmUgcnVubmluZyBzb21ldGhpbmcgcHJpb3IKPiA+IHRvIHY2NCB0aGF0IGRvZXMg
bm90IHVuZGVyc3RhbmQgdGhlIG5ldyBkZXZpY2UgdG9wb2xvZ3kuCj4KPgo+IEl0J3MgbmRjdGwg
ZnJvbSBnaXQgbWFzdGVyLCBoZW5jZSA2NC4xLgo+Cj4gSSBhbSB1c2luZyBhIHNpbWlsYXIgc29m
dHdhcmUga2VybmVsK25kY3RsIG9uIGEgbWFjaGluZSB3aXRoIHJlYWwKPiBudmRpbW1zLCBubyBw
cm9ibGVtIHRoZXJlLiBJdCdzIG9ubHkgdGhlIG1hY2hpbmUgd2l0aCBmYWtlIG52ZGltbSB1c2lu
Zwo+IG1lbW1hcCB0aGF0IHNob3cgdGhpcyBpc3N1ZS4KPgoKSG1tLCBhbGwgbXkgZ3Vlc3NlcyBh
cmUgY29taW5nIHVwIGVtcHR5Li4uIHdoaWNoIHVzdWFsbHkgbWVhbnMgdGhlcmUKaXMgaW5kZWVk
IGEgYnVnLiBMZXQgbWUgdHJ5IHNvbWUgZXhwZXJpbWVudHMgaGVyZSwgYnV0IEkgbWF5IG5lZWQg
dG8Kc2VuZCB5b3UgYSBkZWJ1ZyBwYXRjaCBmb3IgbW9yZSBpbmZvLiBUaGFua3MgZm9yIHRoZSBt
ZW1tYXA9Cmluc2lnaHQuLi4gSSBkbyB0ZXN0IHdpdGggdGhhdCwgYnV0IGxldCBtZSBzZWUgaWYg
dGhlcmUgaXMgc29tZXRoaW5nCnNwZWNpZmljIGFib3V0IHlvdXIgY29uZmlnLgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGlu
ZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFp
bG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
