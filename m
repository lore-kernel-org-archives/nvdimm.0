Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on0702.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe45::702])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D36E81E6C
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 14:04:38 -0800 (PST)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2] libnvdimm: check and clear poison before writing to
 pmem
Date: Thu, 10 Nov 2016 22:04:40 +0000
Message-ID: <1478815355.20881.119.camel@hpe.com>
References: <147879993593.130465.16954973899565924428.stgit@djiang5-desk3.ch.intel.com>
 <20161110191711.GB26806@omniknight.lm.intel.com>
 <CAPcyv4j9-PsJ4T8EdiiLnq1-hOLvasV7FymuLbYpsDfu3G7=EA@mail.gmail.com>
 <20161110215629.GC26806@omniknight.lm.intel.com>
In-Reply-To: <20161110215629.GC26806@omniknight.lm.intel.com>
Content-Language: en-US
Content-ID: <CA484F76F0006C4F9142CFF65E1D2EF8@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTExLTEwIGF0IDE0OjU2IC0wNzAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IE9uIDExLzEwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQrCoDoNCj4gPiBUaGlzIGZlZWxzIGxpa2Ug
b3Zlci1lbmdpbmVlcmluZyBhIHN0aWxsIG5vdCBwZXJmZWN0IHNvbHV0aW9uIHRvIGENCj4gPiBy
YXJlIHByb2JsZW0uwqDCoE91dHNpZGUgb2YgYXRvbWljLXdyaXRlLWFuZC1jbGVhciB3ZSBzaG91
bGQganVzdA0KPiA+IGtlZXAgdGhlIGNvZGUgYmVzdCBlZmZvcnQgYW5kIHNpbXBsZS4NCj4gDQo+
IEZhaXIgZW5vdWdoIDopIEluIHRoYXQgY2FzZSBJIHRoaW5rIHRoZSBvbmx5IGNoYW5nZSBuZWVk
ZWQgaXMgdG8NCj4gc2ltcGx5IHJlbW92ZSB0aGUgY2xlYXJlZCAhPSBzaXplIGNoZWNrLCBkbyBi
YWRibG9ja3NfY2xlYXIgZm9yDQo+ICJjbGVhcmVkID4+IDkiIChhcyBpdCBpcyBub3cpLCBhbmQg
dGhlbiB3cml0ZSAic2l6ZSIsIGFuZCByZXR1cm4NCj4gc3VjY2Vzcy4gU291bmQgZ29vZD8NCg0K
Q2FuIHdlIHRha2UgdGhlIHNhbWUgYXBwcm9hY2ggYXPCoHBtZW1fZG9fYnZlYygpLCBpLmUuIGNv
cHkgdGhlIGRhdGEsDQpidXQgcmV0dXJuIC1FSU8gaW4gY2FzZSB0aGUgY2xlYXIgZmFpbGVkPw0K
DQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEu
b3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
