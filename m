Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28389225F321D
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 14:39:14 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: fix ndctl_persistence_domain declaration
Date: Fri, 6 Apr 2018 21:39:12 +0000
Message-ID: <1523050750.19605.11.camel@intel.com>
References: <1523021334-9976-1-git-send-email-lukasz.plewa@intel.com>
 <CAPcyv4h97ig8hRPPVPOA-kKTNpuciWHtMeT3s1xyqv=5wyDbcw@mail.gmail.com>
In-Reply-To: <CAPcyv4h97ig8hRPPVPOA-kKTNpuciWHtMeT3s1xyqv=5wyDbcw@mail.gmail.com>
Content-Language: en-US
Content-ID: <A8C686C703185E4BA345021CEC18F144@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Plewa, Lukasz" <lukasz.plewa@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE4LTA0LTA2IGF0IDA3OjQwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgQXByIDYsIDIwMTggYXQgNjoyOCBBTSwgIDxsdWthc3oucGxld2FAaW50ZWwuY29t
PiB3cm90ZToNCj4gPiBGcm9tOiDFgXVrYXN6IFBsZXdhIDxsdWthc3oucGxld2FAaW50ZWwuY29t
Pg0KPiA+IA0KPiA+IHRoZSBkZWNsYXJhdGlvbiBvZiBuZGN0bF9wZXJzaXN0ZW5jZV9kb21haW4g
c2hvdWxkIGJlIGFib3ZlIGZpcnN0IHVzZQ0KPiA+IG9mIHRoaXMgZW51bQ0KPiA+IA0KPiA+IFJl
cG9ydGVkLWJ5OiBLYW1pbCBEaWVkcmljaCA8a2FtaWwuZGllZHJpY2hAaW50ZWwuY29tPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IMWBdWthc3ogUGxld2EgPGx1a2Fzei5wbGV3YUBpbnRlbC5jb20+DQo+
ID4gLS0tDQo+ID4gIG5kY3RsL2xpYm5kY3RsLmggfCAxNCArKysrKysrLS0tLS0tLQ0KPiA+ICAx
IGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gTG9v
a3MgZ29vZCwNCj4gDQo+IFJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1z
QGludGVsLmNvbT4NCg0KVGhhbmtzLCBhcHBsaWVkLg0KPiBfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0DQo+
IExpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcNCj4gaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1h
bi9saXN0aW5mby9saW51eC1udmRpbW0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
