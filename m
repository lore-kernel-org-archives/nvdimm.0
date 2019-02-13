Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B877E202E53B5
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 00:24:16 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id n8so2559448otl.6
 for <linux-nvdimm@lists.01.org>; Wed, 13 Feb 2019 00:24:16 -0800 (PST)
MIME-Version: 1.0
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
 <26ac36f4-7391-5321-217b-50d67e2119d7@intel.com>
 <453f13cd-a7fe-33eb-9a27-8490825ca29c@inria.fr>
 <CAPcyv4jF7ZyKaFDw7nb04UvWkVWGJdLGkZDQ1g=X7i+kdu7JRg@mail.gmail.com>
 <a3bfe739-228e-26fe-90f7-4a4f8ceb3a9a@inria.fr>
In-Reply-To: <a3bfe739-228e-26fe-90f7-4a4f8ceb3a9a@inria.fr>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Feb 2019 00:24:04 -0800
Message-ID: <CAPcyv4jJ=C7ZEsJqBxzBMsQWz4+C8BZmWuk7OkztOebprd2rMg@mail.gmail.com>
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

T24gV2VkLCBGZWIgMTMsIDIwMTkgYXQgMTI6MTIgQU0gQnJpY2UgR29nbGluIDxCcmljZS5Hb2ds
aW5AaW5yaWEuZnI+IHdyb3RlOgo+Cj4gTGUgMTMvMDIvMjAxOSDDoCAwMTozMCwgRGFuIFdpbGxp
YW1zIGEgw6ljcml0IDoKPiA+IE9uIFR1ZSwgRmViIDEyLCAyMDE5IGF0IDExOjU5IEFNIEJyaWNl
IEdvZ2xpbiA8QnJpY2UuR29nbGluQGlucmlhLmZyPiB3cm90ZToKPiA+PiAjIG5kY3RsIGRpc2Fi
bGUtcmVnaW9uIGFsbAo+ID4+ICMgbmRjdGwgemVyby1sYWJlbHMgYWxsCj4gPj4gIyBuZGN0bCBl
bmFibGUtcmVnaW9uIHJlZ2lvbjAKPiA+PiAjIG5kY3RsIGNyZWF0ZS1uYW1lc3BhY2UgLXIgcmVn
aW9uMCAtdCBwbWVtIC1tIGRldmRheAo+ID4+IHsKPiA+PiAgICJkZXYiOiJuYW1lc3BhY2UwLjAi
LAo+ID4+ICAgIm1vZGUiOiJkZXZkYXgiLAo+ID4+ICAgIm1hcCI6ImRldiIsCj4gPj4gICAic2l6
ZSI6IjE0ODguMzcgR2lCICgxNTk4LjEzIEdCKSIsCj4gPj4gICAidXVpZCI6ImFkMDA5NmQ3LTNm
ZTctNDQwMi1iNTI5LWFkNjRlZDBiZjc4OSIsCj4gPj4gICAiZGF4cmVnaW9uIjp7Cj4gPj4gICAg
ICJpZCI6MCwKPiA+PiAgICAgInNpemUiOiIxNDg4LjM3IEdpQiAoMTU5OC4xMyBHQikiLAo+ID4+
ICAgICAiYWxpZ24iOjIwOTcxNTIsCj4gPj4gICAgICJkZXZpY2VzIjpbCj4gPj4gICAgICAgewo+
ID4+ICAgICAgICAgImNoYXJkZXYiOiJkYXgwLjAiLAo+ID4+ICAgICAgICAgInNpemUiOiIxNDg4
LjM3IEdpQiAoMTU5OC4xMyBHQikiCj4gPj4gICAgICAgfQo+ID4+ICAgICBdCj4gPj4gICB9LAo+
ID4+ICAgImFsaWduIjoyMDk3MTUyCj4gPj4gfQo+ID4+ICMgbmRjdGwgZW5hYmxlLW5hbWVzcGFj
ZSBuYW1lc3BhY2UwLjAKPiA+PiAjIGVjaG8gLW4gZGF4MC4wID4gL3N5cy9idXMvZGF4L2RyaXZl
cnMvZGV2aWNlX2RheC9yZW1vdmVfaWQKPiA+PiA8aGFuZz4KPiA+Pgo+ID4+IEkgdHJpZWQgd2l0
aCBhbmQgd2l0aG91dCBkYXhfcG1lbV9jb21wYXQgbG9hZGVkLCBidXQgaXQgZG9lc24ndCBoZWxw
Lgo+ID4gSSB0aGluayB0aGlzIGlzIGR1ZSB0bzoKPiA+Cj4gPiAgIGE5ZjFmZmRiNmEyMCBkZXZp
Y2UtZGF4OiBBdXRvLWJpbmQgZGV2aWNlIGFmdGVyIHN1Y2Nlc3NmdWwgbmV3X2lkCj4gPgo+ID4g
SSBtaXNzZWQgdGhhdCB0aGlzIHBhdGggaXMgYWxzbyBjYWxsZWQgaW4gdGhlIHJlbW92ZV9pZCBw
YXRoLiBUaGFua3MKPiA+IGZvciB0aGUgYnVnIHJlcG9ydCEgSSdsbCBnZXQgdGhpcyBmaXhlZCB1
cC4KPgo+Cj4gTm93IHRoYXQgcmVtb3ZlX2lkIGlzIGZpeGVkLCB0aGluZ3MgZmFpbHMgbGF0ZXIg
aW4gRGF2ZSdzIHByb2NlZHVyZToKPgo+ICMgZWNobyAtbiBkYXgwLjAgPiAvc3lzL2J1cy9kYXgv
ZHJpdmVycy9kZXZpY2VfZGF4L3JlbW92ZV9pZAo+ICMgZWNobyAtbiBkYXgwLjAgPiAvc3lzL2J1
cy9kYXgvZHJpdmVycy9kZXZpY2VfZGF4L3VuYmluZAo+ICMgZWNobyAtbiBkYXgwLjAgPiAvc3lz
L2J1cy9kYXgvZHJpdmVycy9rbWVtL25ld19pZAoKSW4gdGhlIGN1cnJlbnQgdmVyc2lvbiBvZiB0
aGUgY29kZSB0aGUgYmluZCBpcyBub3QgbmVjZXNzYXJ5LCBzbyB0aGUKbGFjayBvZiBlcnJvciBt
ZXNzYWdlcyBoZXJlIG1lYW5zIHRoZSBiaW5kIHN1Y2NlZWRlZC4KCj4gIyBlY2hvIC1uIGRheDAu
MCA+IC9zeXMvYnVzL2RheC9kcml2ZXJzL2ttZW0vYmluZAo+IC1iYXNoOiBlY2hvOiB3cml0ZSBl
cnJvcjogTm8gc3VjaCBkZXZpY2UKClRoaXMgYWxzbyBoYXBwZW5zIHdoZW4gdGhlIGRldmljZSBp
cyBhbHJlYWR5IGJvdW5kLgoKPgo+IChBbmQgbm90aGluZyBzZWVtcyB0byBoYXZlIGNoYW5nZWQg
aW4gL3N5cy9kZXZpY2VzL3N5c3RlbS9tZW1vcnkvKi9zdGF0ZSkKCldoYXQgZG9lcyAiY2F0IC9w
cm9jL2lvbWVtIiBzYXk/Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9y
ZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
