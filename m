Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFE42222F4E37
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 15:52:52 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id p31so19749451ota.4
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 15:57:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171222232231.GA26715@linux.intel.com>
References: <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org>
 <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
 <20171220224105.GA27258@linux.intel.com>
 <39cbe02a-d309-443d-54c9-678a0799342d@gmail.com>
 <CAPcyv4j9shdJFrvADa=qW4L-jPJJ4S_TJc_c=aRoW3EmSCCChQ@mail.gmail.com>
 <20171222232231.GA26715@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Dec 2017 15:57:41 -0800
Message-ID: <CAPcyv4j95rWmFM5NDvoRJakwVE5YUgcipQW2Ju+40+FD6vYs+Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, Matthew Wilcox <willy@infradead.org>, Linux ACPI" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, Linux API <linux-api@vger.kernel.org>, Brice Goglin" <brice.goglin@gmail.com>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBEZWMgMjIsIDIwMTcgYXQgMzoyMiBQTSwgUm9zcyBad2lzbGVyCjxyb3NzLnp3aXNs
ZXJAbGludXguaW50ZWwuY29tPiB3cm90ZToKPiBPbiBGcmksIERlYyAyMiwgMjAxNyBhdCAwMjo1
Mzo0MlBNIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4+IE9uIFRodSwgRGVjIDIxLCAyMDE3
IGF0IDEyOjMxIFBNLCBCcmljZSBHb2dsaW4gPGJyaWNlLmdvZ2xpbkBnbWFpbC5jb20+IHdyb3Rl
Ogo+PiA+IExlIDIwLzEyLzIwMTcgw6AgMjM6NDEsIFJvc3MgWndpc2xlciBhIMOpY3JpdCA6Cj4+
IFsuLl0KPj4gPiBIZWxsbwo+PiA+Cj4+ID4gSSBjYW4gY29uZmlybSB0aGF0IEhQQyBydW50aW1l
cyBhcmUgZ29pbmcgdG8gdXNlIHRoZXNlIHBhdGNoZXMgKGF0IGxlYXN0Cj4+ID4gYWxsIHJ1bnRp
bWVzIHRoYXQgdXNlIGh3bG9jIGZvciB0b3BvbG9neSBkaXNjb3ZlcnksIGJ1dCB0aGF0J3MgdGhl
IHZhc3QKPj4gPiBtYWpvcml0eSBvZiBIUEMgYW55d2F5KS4KPj4gPgo+PiA+IFdlIHJlYWxseSBk
aWRuJ3QgbGlrZSBLTkwgZXhwb3NpbmcgYSBoYWNreSBTTElUIHRhYmxlIFsxXS4gV2UgaGFkIHRv
Cj4+ID4gZXhwbGljaXRseSBkZXRlY3QgdGhhdCBzcGVjaWZpYyBjcmF6eSB0YWJsZSB0byBmaW5k
IG91dCB3aGljaCBOVU1BIG5vZGVzCj4+ID4gd2VyZSBsb2NhbCB0byB3aGljaCBjb3JlcywgYW5k
IHRvIGZpbmQgb3V0IHdoaWNoIE5VTUEgbm9kZXMgd2VyZQo+PiA+IEhCTS9NQ0RSQU0gb3IgRERS
LiBBbmQgdGhlbiB3ZSBoYWQgdG8gaGlkZSB0aGUgU0xJVCB2YWx1ZXMgdG8gdGhlCj4+ID4gYXBw
bGljYXRpb24gYmVjYXVzZSB0aGUgcmVwb3J0ZWQgbGF0ZW5jaWVzIGRpZG4ndCBtYXRjaCByZWFs
aXR5LiBRdWl0ZQo+PiA+IGFubm95aW5nLgo+PiA+Cj4+ID4gV2l0aCBSb3NzJyBwYXRjaGVzLCB3
ZSBjYW4gZWFzaWx5IGdldCB3aGF0IHdlIG5lZWQ6Cj4+ID4gKiB3aGljaCBOVU1BIG5vZGVzIGFy
ZSBsb2NhbCB0byB3aGljaCBDUFVzPyAvc3lzL2RldmljZXMvc3lzdGVtL25vZGUvCj4+ID4gY2Fu
IG9ubHkgcmVwb3J0IGEgc2luZ2xlIGxvY2FsIG5vZGUgcGVyIENQVSAoZG9lc24ndCB3b3JrIGZv
ciBLTkwgYW5kCj4+ID4gdXBjb21pbmcgYXJjaGl0ZWN0dXJlcyB3aXRoIEhCTStERFIrLi4uKQo+
PiA+ICogd2hpY2ggTlVNQSBub2RlcyBhcmUgc2xvdy9mYXN0IChmb3IgYm90aCBiYW5kd2lkdGgg
YW5kIGxhdGVuY3kpCj4+ID4gQW5kIHdlIGNhbiBzdGlsbCBsb29rIGF0IFNMSVQgdW5kZXIgL3N5
cy9kZXZpY2VzL3N5c3RlbS9ub2RlIGlmIHJlYWxseQo+PiA+IG5lZWRlZC4KPj4gPgo+PiA+IEFu
ZCBvZiBjb3Vyc2UgaGF2aW5nIHRoaXMgaW4gc3lzZnMgaXMgbXVjaCBiZXR0ZXIgdGhhbiBwYXJz
aW5nIEFDUEkKPj4gPiB0YWJsZXMgdGhhdCBhcmUgb25seSBhY2Nlc3NpYmxlIHRvIHJvb3QgOikK
Pj4KPj4gT24gdGhpcyBwb2ludCwgaXQncyBub3QgY2xlYXIgdG8gbWUgdGhhdCB3ZSBzaG91bGQg
YWxsb3cgdGhlc2Ugc3lzZnMKPj4gZW50cmllcyB0byBiZSB3b3JsZCByZWFkYWJsZS4gR2l2ZW4g
L3Byb2MvaW9tZW0gbm93IGhpZGVzIHBoeXNpY2FsCj4+IGFkZHJlc3MgaW5mb3JtYXRpb24gZnJv
bSBub24tcm9vdCB3ZSBhdCBsZWFzdCBuZWVkIHRvIGJlIGNhcmVmdWwgbm90Cj4+IHRvIHVuZG8g
dGhhdCB3aXRoIG5ldyBzeXNmcyBITUFUIGF0dHJpYnV0ZXMuCj4KPiBUaGlzIGVuYWJsaW5nIGRv
ZXMgbm90IGV4cG9zZSBhbnkgcGh5c2ljYWwgYWRkcmVzc2VzIHRvIHVzZXJzcGFjZS4gIEl0IG9u
bHkKPiBwcm92aWRlcyBwZXJmb3JtYW5jZSBudW1iZXJzIGZyb20gdGhlIEhNQVQgYW5kIGFzc29j
aWF0ZXMgdGhlbSB3aXRoIGV4aXN0aW5nCj4gTlVNQSBub2Rlcy4gIEFyZSB5b3Ugd29ycmllZCB0
aGF0IGV4cG9zaW5nIHBlcmZvcm1hbmNlIG51bWJlcnMgdG8gbm9uLXJvb3QKPiB1c2VycyB2aWEg
c3lzZnMgcG9zZXMgYSBzZWN1cml0eSByaXNrPwoKSXQncyBhbiBpbmZvcm1hdGlvbiBkaXNjbG9z
dXJlIHRoYXQncyBub3QgY2xlYXIgd2UgbmVlZCB0byBtYWtlIHRvCm5vbi1yb290IHByb2Nlc3Nl
cy4KCkknbSBtb3JlIHdvcnJpZWQgYWJvdXQgdXNlcnNwYWNlIGdyb3dpbmcgZGVwZW5kZW5jaWVz
IG9uIHRoZSBhYnNvbHV0ZQpudW1iZXJzIHdoZW4gdGhvc2UgbnVtYmVycyBjYW4gY2hhbmdlIGZy
b20gcGxhdGZvcm0gdG8gcGxhdGZvcm0uCkRpZmZlcmVudGlhdGVkIG1lbW9yeSBvbiBvbmUgcGxh
dGZvcm0gbWF5IGJlIHRoZSBjb21tb24gbWVtb3J5IHBvb2wgb24KYW5vdGhlci4KClRvIG1lIHRo
aXMgaGFzIHBhcmFsbGVscyB3aXRoIHN0b3JhZ2UgZGV2aWNlIGhpbnRpbmcgd2hlcmUKc3BlY2lm
aWNhdGlvbnMgbGlrZSBUMTAgaGF2ZSBhIGNvbXBsZXggZW51bWVyYXRpb24gb2YgYWxsIHRoZQpw
ZXJmb3JtYW5jZSBoaW50cyB0aGF0IGNhbiBiZSBwYXNzZWQgdG8gdGhlIGRldmljZSwgYnV0IHRo
ZSBMaW51eAplbmFibGluZyBlZmZvcnQgYWltcyBmb3IgYSBzYW5pdHplZCBzZXQgb2YgcmVsYXRp
dmUgaGludHMgdGhhdCBtYWtlCnNlbnNlLiBJdCdzIG1vcmUgZmxleGlibGUgaWYgdXNlcnNwYWNl
IHNwZWNpZmllcyBhIHJlbGF0aXZlIGludGVudApyYXRoZXIgdGhhbiBhbiBhYnNvbHV0ZSBwZXJm
b3JtYW5jZSB0YXJnZXQuIFB1dHRpbmcgYWxsIHRoZSBITUFUCmluZm9ybWF0aW9uIGludG8gc3lz
ZnMgZ2l2ZXMgdXNlcnNwYWNlIG1vcmUgaW5mb3JtYXRpb24gdGhhbiBpdCBjb3VsZApwb3NzaWJs
eSBkbyBhbnl0aGluZyByZWFzb25hYmxlLCBhdCBsZWFzdCBvdXRzaWRlIG9mIHNwZWNpYWxpemVk
IGFwcHMKdGhhdCBhcmUgaGFuZCB0dW5lZCBmb3IgYSBnaXZlbiBoYXJkd2FyZSBwbGF0Zm9ybS4K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
