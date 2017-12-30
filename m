Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail3-relais-sop.national.inria.fr
 (mail3-relais-sop.national.inria.fr [192.134.164.104])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 044C02205BE88
 for <linux-nvdimm@lists.01.org>; Sat, 30 Dec 2017 01:14:35 -0800 (PST)
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
References: <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org>
 <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
 <20171220224105.GA27258@linux.intel.com>
 <39cbe02a-d309-443d-54c9-678a0799342d@gmail.com>
 <CAPcyv4j9shdJFrvADa=qW4L-jPJJ4S_TJc_c=aRoW3EmSCCChQ@mail.gmail.com>
 <71317994-af66-a1b2-4c7a-86a03253cf62@gmail.com>
 <20171230065845.GD27959@bombadil.infradead.org>
From: Brice Goglin <brice.goglin@gmail.com>
Message-ID: <74a585de-c825-b568-ee14-c8799b9d6238@gmail.com>
Date: Sat, 30 Dec 2017 10:19:29 +0100
MIME-Version: 1.0
In-Reply-To: <20171230065845.GD27959@bombadil.infradead.org>
Content-Language: en-US
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Odzioba, Lukasz" <lukasz.odzioba@intel.com>, "Schmauss, Erik  <erik.schmauss@intel.com>, Len Brown <lenb@kernel.org>, John Hubbard" <jhubbard@nvidia.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, Linux API <linux-api@vger.kernel.org>, Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

CgpMZSAzMC8xMi8yMDE3IMOgIDA3OjU4LCBNYXR0aGV3IFdpbGNveCBhIMOpY3JpdMKgOgo+IE9u
IFdlZCwgRGVjIDI3LCAyMDE3IGF0IDEwOjEwOjM0QU0gKzAxMDAsIEJyaWNlIEdvZ2xpbiB3cm90
ZToKPj4+IFBlcmhhcHMgd2UgY2FuIGVubGlzdCAvcHJvYy9pb21lbSBvciBhIHNpbWlsYXIgZW51
bWVyYXRpb24gaW50ZXJmYWNlCj4+PiB0byB0ZWxsIHVzZXJzcGFjZSB0aGUgTlVNQSBub2RlIGFu
ZCB3aGV0aGVyIHRoZSBrZXJuZWwgdGhpbmtzIGl0IGhhcwo+Pj4gYmV0dGVyIG9yIHdvcnNlIHBl
cmZvcm1hbmNlIGNoYXJhY3RlcmlzdGljcyByZWxhdGl2ZSB0byBiYXNlCj4+PiBzeXN0ZW0tUkFN
LCBpLmUuIG5ldyBJT1JFU19ERVNDXyogdmFsdWVzLiBJJ20gd29ycmllZCB0aGF0IGlmIHdlIHN0
YXJ0Cj4+PiBwdWJsaXNoaW5nIGFic29sdXRlIG51bWJlcnMgaW4gc3lzZnMgdXNlcnNwYWNlIHdp
bGwgZGVmYXVsdCB0byBsb29raW5nCj4+PiBmb3Igc3BlY2lmaWMgbWFnaWMgbnVtYmVycyBpbiBz
eXNmcyB2cyBhc2tpbmcgdGhlIGtlcm5lbCBmb3IgbWVtb3J5Cj4+PiB0aGF0IGhhcyBwZXJmb3Jt
YW5jZSBjaGFyYWN0ZXJpc3RpY3MgcmVsYXRpdmUgdG8gYmFzZSAiU3lzdGVtIFJBTSIuIEluCj4+
PiBvdGhlciB3b3JkcyB0aGUgYWJzb2x1dGUgcGVyZm9ybWFuY2UgaW5mb3JtYXRpb24gdGhhdCB0
aGUgSE1BVAo+Pj4gcHVibGlzaGVzIGlzIHVzZWZ1bCB0byB0aGUga2VybmVsLCBidXQgaXQncyBu
b3QgY2xlYXIgdGhhdCB1c2Vyc3BhY2UKPj4+IG5lZWRzIHRoYXQgdnMgYSByZWxhdGl2ZSBpbmRp
Y2F0b3IgZm9yIG1ha2luZyBOVU1BIG5vZGUgcHJlZmVyZW5jZQo+Pj4gZGVjaXNpb25zLgo+PiBT
b21lIEhQQyB1c2VycyB3aWxsIGJlbmNobWFyayB0aGUgbWFjaGluZSB0byBkaXNjb3ZlcnkgYWN0
dWFsCj4+IHBlcmZvcm1hbmNlIG51bWJlcnMgYW55d2F5Lgo+PiBIb3dldmVyLCBtb3N0IHVzZXJz
IHdvbid0IGRvIHRoaXMuIFRoZXkgd2lsbCB3YW50IHRvIGtub3cgcmVsYXRpdmUKPj4gcGVyZm9y
bWFuY2Ugb2YgZGlmZmVyZW50IG5vZGVzLiBJZiB5b3Ugbm9ybWFsaXplIEhNQVQgdmFsdWVzIGJ5
IGRpdmlkaW5nCj4+IHRoZW0gd2l0aCBzeXN0ZW0tUkFNIHZhbHVlcywgdGhhdCdzIGxpa2VseSBP
Sy4gSWYgeW91IGp1c3Qgc2F5ICJ0aGF0Cj4+IG5vZGUgaXMgZmFzdGVyIHRoYW4gc3lzdGVtIFJB
TSIsIGl0J3Mgbm90IHByZWNpc2UgZW5vdWdoLgo+IFNvICJ0aGlzIG1lbW9yeSBoYXMgODAwJSBi
YW5kd2lkdGggb2Ygbm9ybWFsIiBhbmQgInRoaXMgbWVtb3J5IGhhcyA3MCUKPiBiYW5kd2lkdGgg
b2Ygbm9ybWFsIj8KCkkgZ3Vlc3MgdGhhdCB3b3VsZCB3b3JrLgpCcmljZQoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcg
bGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxt
YW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
