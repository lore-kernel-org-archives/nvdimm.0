Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 888E42194EB76
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 08:19:18 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id 98so5185684oty.1
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 08:19:18 -0800 (PST)
MIME-Version: 1.0
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
 <26ac36f4-7391-5321-217b-50d67e2119d7@intel.com>
 <453f13cd-a7fe-33eb-9a27-8490825ca29c@inria.fr>
 <CAPcyv4jF7ZyKaFDw7nb04UvWkVWGJdLGkZDQ1g=X7i+kdu7JRg@mail.gmail.com>
 <a3bfe739-228e-26fe-90f7-4a4f8ceb3a9a@inria.fr>
 <CAPcyv4jJ=C7ZEsJqBxzBMsQWz4+C8BZmWuk7OkztOebprd2rMg@mail.gmail.com>
 <057ad938-e745-02f7-edce-e19bd326da6a@inria.fr>
 <eb58cb96-1f61-2dd2-b1ab-5a7d4df78297@inria.fr>
In-Reply-To: <eb58cb96-1f61-2dd2-b1ab-5a7d4df78297@inria.fr>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Feb 2019 08:19:05 -0800
Message-ID: <CAPcyv4iAex_rgPXfhsjWjbvKX79s0ZoieE2NeX14_F56WoQ_7A@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
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
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, "Huang, Ying  <ying.huang@intel.com>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCBGZWIgMTMsIDIwMTkgYXQgNTowNyBBTSBCcmljZSBHb2dsaW4gPEJyaWNlLkdvZ2xp
bkBpbnJpYS5mcj4gd3JvdGU6Cj4KPgo+IExlIDEzLzAyLzIwMTkgw6AgMDk6NDMsIEJyaWNlIEdv
Z2xpbiBhIMOpY3JpdCA6Cj4gPiBMZSAxMy8wMi8yMDE5IMOgIDA5OjI0LCBEYW4gV2lsbGlhbXMg
YSDDqWNyaXQgOgo+ID4+IE9uIFdlZCwgRmViIDEzLCAyMDE5IGF0IDEyOjEyIEFNIEJyaWNlIEdv
Z2xpbiA8QnJpY2UuR29nbGluQGlucmlhLmZyPiB3cm90ZToKPiA+Pj4gTGUgMTMvMDIvMjAxOSDD
oCAwMTozMCwgRGFuIFdpbGxpYW1zIGEgw6ljcml0IDoKPiA+Pj4+IE9uIFR1ZSwgRmViIDEyLCAy
MDE5IGF0IDExOjU5IEFNIEJyaWNlIEdvZ2xpbiA8QnJpY2UuR29nbGluQGlucmlhLmZyPiB3cm90
ZToKPiA+Pj4+PiAjIG5kY3RsIGRpc2FibGUtcmVnaW9uIGFsbAo+ID4+Pj4+ICMgbmRjdGwgemVy
by1sYWJlbHMgYWxsCj4gPj4+Pj4gIyBuZGN0bCBlbmFibGUtcmVnaW9uIHJlZ2lvbjAKPiA+Pj4+
PiAjIG5kY3RsIGNyZWF0ZS1uYW1lc3BhY2UgLXIgcmVnaW9uMCAtdCBwbWVtIC1tIGRldmRheAo+
ID4+Pj4+IHsKPiA+Pj4+PiAgICJkZXYiOiJuYW1lc3BhY2UwLjAiLAo+ID4+Pj4+ICAgIm1vZGUi
OiJkZXZkYXgiLAo+ID4+Pj4+ICAgIm1hcCI6ImRldiIsCj4gPj4+Pj4gICAic2l6ZSI6IjE0ODgu
MzcgR2lCICgxNTk4LjEzIEdCKSIsCj4gPj4+Pj4gICAidXVpZCI6ImFkMDA5NmQ3LTNmZTctNDQw
Mi1iNTI5LWFkNjRlZDBiZjc4OSIsCj4gPj4+Pj4gICAiZGF4cmVnaW9uIjp7Cj4gPj4+Pj4gICAg
ICJpZCI6MCwKPiA+Pj4+PiAgICAgInNpemUiOiIxNDg4LjM3IEdpQiAoMTU5OC4xMyBHQikiLAo+
ID4+Pj4+ICAgICAiYWxpZ24iOjIwOTcxNTIsCj4gPj4+Pj4gICAgICJkZXZpY2VzIjpbCj4gPj4+
Pj4gICAgICAgewo+ID4+Pj4+ICAgICAgICAgImNoYXJkZXYiOiJkYXgwLjAiLAo+ID4+Pj4+ICAg
ICAgICAgInNpemUiOiIxNDg4LjM3IEdpQiAoMTU5OC4xMyBHQikiCj4gPj4+Pj4gICAgICAgfQo+
ID4+Pj4+ICAgICBdCj4gPj4+Pj4gICB9LAo+ID4+Pj4+ICAgImFsaWduIjoyMDk3MTUyCj4gPj4+
Pj4gfQo+ID4+Pj4+ICMgbmRjdGwgZW5hYmxlLW5hbWVzcGFjZSBuYW1lc3BhY2UwLjAKPiA+Pj4+
PiAjIGVjaG8gLW4gZGF4MC4wID4gL3N5cy9idXMvZGF4L2RyaXZlcnMvZGV2aWNlX2RheC9yZW1v
dmVfaWQKPiA+Pj4+PiA8aGFuZz4KPiA+Pj4+Pgo+ID4+Pj4+IEkgdHJpZWQgd2l0aCBhbmQgd2l0
aG91dCBkYXhfcG1lbV9jb21wYXQgbG9hZGVkLCBidXQgaXQgZG9lc24ndCBoZWxwLgo+ID4+Pj4g
SSB0aGluayB0aGlzIGlzIGR1ZSB0bzoKPiA+Pj4+Cj4gPj4+PiAgIGE5ZjFmZmRiNmEyMCBkZXZp
Y2UtZGF4OiBBdXRvLWJpbmQgZGV2aWNlIGFmdGVyIHN1Y2Nlc3NmdWwgbmV3X2lkCj4gPj4+Pgo+
ID4+Pj4gSSBtaXNzZWQgdGhhdCB0aGlzIHBhdGggaXMgYWxzbyBjYWxsZWQgaW4gdGhlIHJlbW92
ZV9pZCBwYXRoLiBUaGFua3MKPiA+Pj4+IGZvciB0aGUgYnVnIHJlcG9ydCEgSSdsbCBnZXQgdGhp
cyBmaXhlZCB1cC4KPiA+Pj4gTm93IHRoYXQgcmVtb3ZlX2lkIGlzIGZpeGVkLCB0aGluZ3MgZmFp
bHMgbGF0ZXIgaW4gRGF2ZSdzIHByb2NlZHVyZToKPiA+Pj4KPiA+Pj4gIyBlY2hvIC1uIGRheDAu
MCA+IC9zeXMvYnVzL2RheC9kcml2ZXJzL2RldmljZV9kYXgvcmVtb3ZlX2lkCj4gPj4+ICMgZWNo
byAtbiBkYXgwLjAgPiAvc3lzL2J1cy9kYXgvZHJpdmVycy9kZXZpY2VfZGF4L3VuYmluZAo+ID4+
PiAjIGVjaG8gLW4gZGF4MC4wID4gL3N5cy9idXMvZGF4L2RyaXZlcnMva21lbS9uZXdfaWQKPiA+
PiBJbiB0aGUgY3VycmVudCB2ZXJzaW9uIG9mIHRoZSBjb2RlIHRoZSBiaW5kIGlzIG5vdCBuZWNl
c3NhcnksIHNvIHRoZQo+ID4+IGxhY2sgb2YgZXJyb3IgbWVzc2FnZXMgaGVyZSBtZWFucyB0aGUg
YmluZCBzdWNjZWVkZWQuCj4KPgo+IEl0IGxvb2tzIGxpa2UgInVuYmluZCIgaXMgcmVxdWlyZWQg
dG8gbWFrZSB0aGUgUE1FTSBhcHBlYXIgYXMgYSBuZXcKPiBub2RlLiBJZiBJIHJlbW92ZV9pZCBm
cm9tIGRldmRheCBhbmQgbmV3X2lkIHRvIGttZW0gd2l0aG91dCAidW5iaW5kIiBpbgo+IHRoZSBt
aWRkbGUsIG5vdGhpbmcgYXBwZWFycy4KPgo+IFdyaXRpbmcgdG8gImttZW0vYmluZCIgZGlkbid0
IHNlZW0gbmVjZXNzYXJ5LgoKWWVzLCBpbiBzaG9ydDoKCmRldmljZV9kYXgvcmVtb3ZlX2lkOiBu
b3QgcmVxdWlyZWQsIHRoaXMgZHJpdmVyIGF0dGFjaGVzIHRvIGFueSBhbmQKYWxsIGRldmljZS1k
YXggZGV2aWNlcyBieSBkZWZhdWx0CmRldmljZV9kYXgvdW5iaW5kOiByZXF1aXJlZCwgbm90aGlu
ZyBlbHNlIHdpbGwgZnJlZSB0aGUgZGV2aWNlIGZvcgprbWVtIHRvIGF0dGFjaAprbWVtL25ld19p
ZDogcmVxdWlyZWQsIGl0IHdpbGwgYXR0YWNoIGlmIHRoZSBkZXZpY2UgaXMgY3VycmVudGx5CnVu
Ym91bmQgb3RoZXJ3aXNlIHRoZSBkZXZpY2UgbXVzdCBiZSB1bmJvdW5kIGJlZm9yZSBwcm9jZWVk
aW5nCmttZW0vYmluZDogb25seSByZXF1aXJlZCBpZiB0aGUgZGV2aWNlIHdhcyBidXN5IC8gYXR0
YWNoZWQgdG8KZGV2aWNlX2RheCB3aGVuIG5ld19pZCB3YXMgd3JpdHRlbi4KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcg
bGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxt
YW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
