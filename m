Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5457922085869
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 17:09:52 -0800 (PST)
Received: by mail-ot0-x244.google.com with SMTP id v21so26464325oth.6
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 17:14:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j95rWmFM5NDvoRJakwVE5YUgcipQW2Ju+40+FD6vYs+Q@mail.gmail.com>
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
 <CAPcyv4j95rWmFM5NDvoRJakwVE5YUgcipQW2Ju+40+FD6vYs+Q@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 23 Dec 2017 02:14:41 +0100
Message-ID: <CAJZ5v0j22oRwsO7uULdeamUK-BwQAYq_v6h1LUZw3vpwqCLunQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, Matthew Wilcox <willy@infradead.org>, Linux ACPI" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, Linux API <linux-api@vger.kernel.org>, Brice Goglin" <brice.goglin@gmail.com>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCBEZWMgMjMsIDIwMTcgYXQgMTI6NTcgQU0sIERhbiBXaWxsaWFtcyA8ZGFuLmoud2ls
bGlhbXNAaW50ZWwuY29tPiB3cm90ZToKPiBPbiBGcmksIERlYyAyMiwgMjAxNyBhdCAzOjIyIFBN
LCBSb3NzIFp3aXNsZXIKPiA8cm9zcy56d2lzbGVyQGxpbnV4LmludGVsLmNvbT4gd3JvdGU6Cj4+
IE9uIEZyaSwgRGVjIDIyLCAyMDE3IGF0IDAyOjUzOjQyUE0gLTA4MDAsIERhbiBXaWxsaWFtcyB3
cm90ZToKPj4+IE9uIFRodSwgRGVjIDIxLCAyMDE3IGF0IDEyOjMxIFBNLCBCcmljZSBHb2dsaW4g
PGJyaWNlLmdvZ2xpbkBnbWFpbC5jb20+IHdyb3RlOgo+Pj4gPiBMZSAyMC8xMi8yMDE3IMOgIDIz
OjQxLCBSb3NzIFp3aXNsZXIgYSDDqWNyaXQgOgo+Pj4gWy4uXQo+Pj4gPiBIZWxsbwo+Pj4gPgo+
Pj4gPiBJIGNhbiBjb25maXJtIHRoYXQgSFBDIHJ1bnRpbWVzIGFyZSBnb2luZyB0byB1c2UgdGhl
c2UgcGF0Y2hlcyAoYXQgbGVhc3QKPj4+ID4gYWxsIHJ1bnRpbWVzIHRoYXQgdXNlIGh3bG9jIGZv
ciB0b3BvbG9neSBkaXNjb3ZlcnksIGJ1dCB0aGF0J3MgdGhlIHZhc3QKPj4+ID4gbWFqb3JpdHkg
b2YgSFBDIGFueXdheSkuCj4+PiA+Cj4+PiA+IFdlIHJlYWxseSBkaWRuJ3QgbGlrZSBLTkwgZXhw
b3NpbmcgYSBoYWNreSBTTElUIHRhYmxlIFsxXS4gV2UgaGFkIHRvCj4+PiA+IGV4cGxpY2l0bHkg
ZGV0ZWN0IHRoYXQgc3BlY2lmaWMgY3JhenkgdGFibGUgdG8gZmluZCBvdXQgd2hpY2ggTlVNQSBu
b2Rlcwo+Pj4gPiB3ZXJlIGxvY2FsIHRvIHdoaWNoIGNvcmVzLCBhbmQgdG8gZmluZCBvdXQgd2hp
Y2ggTlVNQSBub2RlcyB3ZXJlCj4+PiA+IEhCTS9NQ0RSQU0gb3IgRERSLiBBbmQgdGhlbiB3ZSBo
YWQgdG8gaGlkZSB0aGUgU0xJVCB2YWx1ZXMgdG8gdGhlCj4+PiA+IGFwcGxpY2F0aW9uIGJlY2F1
c2UgdGhlIHJlcG9ydGVkIGxhdGVuY2llcyBkaWRuJ3QgbWF0Y2ggcmVhbGl0eS4gUXVpdGUKPj4+
ID4gYW5ub3lpbmcuCj4+PiA+Cj4+PiA+IFdpdGggUm9zcycgcGF0Y2hlcywgd2UgY2FuIGVhc2ls
eSBnZXQgd2hhdCB3ZSBuZWVkOgo+Pj4gPiAqIHdoaWNoIE5VTUEgbm9kZXMgYXJlIGxvY2FsIHRv
IHdoaWNoIENQVXM/IC9zeXMvZGV2aWNlcy9zeXN0ZW0vbm9kZS8KPj4+ID4gY2FuIG9ubHkgcmVw
b3J0IGEgc2luZ2xlIGxvY2FsIG5vZGUgcGVyIENQVSAoZG9lc24ndCB3b3JrIGZvciBLTkwgYW5k
Cj4+PiA+IHVwY29taW5nIGFyY2hpdGVjdHVyZXMgd2l0aCBIQk0rRERSKy4uLikKPj4+ID4gKiB3
aGljaCBOVU1BIG5vZGVzIGFyZSBzbG93L2Zhc3QgKGZvciBib3RoIGJhbmR3aWR0aCBhbmQgbGF0
ZW5jeSkKPj4+ID4gQW5kIHdlIGNhbiBzdGlsbCBsb29rIGF0IFNMSVQgdW5kZXIgL3N5cy9kZXZp
Y2VzL3N5c3RlbS9ub2RlIGlmIHJlYWxseQo+Pj4gPiBuZWVkZWQuCj4+PiA+Cj4+PiA+IEFuZCBv
ZiBjb3Vyc2UgaGF2aW5nIHRoaXMgaW4gc3lzZnMgaXMgbXVjaCBiZXR0ZXIgdGhhbiBwYXJzaW5n
IEFDUEkKPj4+ID4gdGFibGVzIHRoYXQgYXJlIG9ubHkgYWNjZXNzaWJsZSB0byByb290IDopCj4+
Pgo+Pj4gT24gdGhpcyBwb2ludCwgaXQncyBub3QgY2xlYXIgdG8gbWUgdGhhdCB3ZSBzaG91bGQg
YWxsb3cgdGhlc2Ugc3lzZnMKPj4+IGVudHJpZXMgdG8gYmUgd29ybGQgcmVhZGFibGUuIEdpdmVu
IC9wcm9jL2lvbWVtIG5vdyBoaWRlcyBwaHlzaWNhbAo+Pj4gYWRkcmVzcyBpbmZvcm1hdGlvbiBm
cm9tIG5vbi1yb290IHdlIGF0IGxlYXN0IG5lZWQgdG8gYmUgY2FyZWZ1bCBub3QKPj4+IHRvIHVu
ZG8gdGhhdCB3aXRoIG5ldyBzeXNmcyBITUFUIGF0dHJpYnV0ZXMuCj4+Cj4+IFRoaXMgZW5hYmxp
bmcgZG9lcyBub3QgZXhwb3NlIGFueSBwaHlzaWNhbCBhZGRyZXNzZXMgdG8gdXNlcnNwYWNlLiAg
SXQgb25seQo+PiBwcm92aWRlcyBwZXJmb3JtYW5jZSBudW1iZXJzIGZyb20gdGhlIEhNQVQgYW5k
IGFzc29jaWF0ZXMgdGhlbSB3aXRoIGV4aXN0aW5nCj4+IE5VTUEgbm9kZXMuICBBcmUgeW91IHdv
cnJpZWQgdGhhdCBleHBvc2luZyBwZXJmb3JtYW5jZSBudW1iZXJzIHRvIG5vbi1yb290Cj4+IHVz
ZXJzIHZpYSBzeXNmcyBwb3NlcyBhIHNlY3VyaXR5IHJpc2s/Cj4KPiBJdCdzIGFuIGluZm9ybWF0
aW9uIGRpc2Nsb3N1cmUgdGhhdCdzIG5vdCBjbGVhciB3ZSBuZWVkIHRvIG1ha2UgdG8KPiBub24t
cm9vdCBwcm9jZXNzZXMuCj4KPiBJJ20gbW9yZSB3b3JyaWVkIGFib3V0IHVzZXJzcGFjZSBncm93
aW5nIGRlcGVuZGVuY2llcyBvbiB0aGUgYWJzb2x1dGUKPiBudW1iZXJzIHdoZW4gdGhvc2UgbnVt
YmVycyBjYW4gY2hhbmdlIGZyb20gcGxhdGZvcm0gdG8gcGxhdGZvcm0uCj4gRGlmZmVyZW50aWF0
ZWQgbWVtb3J5IG9uIG9uZSBwbGF0Zm9ybSBtYXkgYmUgdGhlIGNvbW1vbiBtZW1vcnkgcG9vbCBv
bgo+IGFub3RoZXIuCj4KPiBUbyBtZSB0aGlzIGhhcyBwYXJhbGxlbHMgd2l0aCBzdG9yYWdlIGRl
dmljZSBoaW50aW5nIHdoZXJlCj4gc3BlY2lmaWNhdGlvbnMgbGlrZSBUMTAgaGF2ZSBhIGNvbXBs
ZXggZW51bWVyYXRpb24gb2YgYWxsIHRoZQo+IHBlcmZvcm1hbmNlIGhpbnRzIHRoYXQgY2FuIGJl
IHBhc3NlZCB0byB0aGUgZGV2aWNlLCBidXQgdGhlIExpbnV4Cj4gZW5hYmxpbmcgZWZmb3J0IGFp
bXMgZm9yIGEgc2FuaXR6ZWQgc2V0IG9mIHJlbGF0aXZlIGhpbnRzIHRoYXQgbWFrZQo+IHNlbnNl
LiBJdCdzIG1vcmUgZmxleGlibGUgaWYgdXNlcnNwYWNlIHNwZWNpZmllcyBhIHJlbGF0aXZlIGlu
dGVudAo+IHJhdGhlciB0aGFuIGFuIGFic29sdXRlIHBlcmZvcm1hbmNlIHRhcmdldC4gUHV0dGlu
ZyBhbGwgdGhlIEhNQVQKPiBpbmZvcm1hdGlvbiBpbnRvIHN5c2ZzIGdpdmVzIHVzZXJzcGFjZSBt
b3JlIGluZm9ybWF0aW9uIHRoYW4gaXQgY291bGQKPiBwb3NzaWJseSBkbyBhbnl0aGluZyByZWFz
b25hYmxlLCBhdCBsZWFzdCBvdXRzaWRlIG9mIHNwZWNpYWxpemVkIGFwcHMKPiB0aGF0IGFyZSBo
YW5kIHR1bmVkIGZvciBhIGdpdmVuIGhhcmR3YXJlIHBsYXRmb3JtLgoKVGhhdCdzIGEgdmFsaWQg
cG9pbnQgSU1PLgoKSXQgaXMgc29ydCBvZiB0ZW1wdGluZyB0byBleHBvc2UgZXZlcnl0aGluZyB0
byB1c2VyIHNwYWNlIHZlcmJhdGltLAplc3BlY2lhbGx5IGVhcmx5IGluIHRoZSBlbmFibGluZyBw
cm9jZXNzIHdoZW4gdGhlIGtlcm5lbCBoYXMgbm90IHlldApmb3VuZCBzdWl0YWJsZSB3YXlzIHRv
IHV0aWxpemUgdGhlIGdpdmVuIGluZm9ybWF0aW9uLCBidXQgdGhlIHZlcnkgYWN0Cm9mIGV4cG9z
aW5nIGl0IG1heSBhZmZlY3Qgd2hhdCBjYW4gYmUgZG9uZSB3aXRoIGl0IGluIHRoZSBmdXR1cmUu
CgpVc2VyIHNwYWNlIGludGVyZmFjZXMgbmVlZCB0byBzdGF5IGFyb3VuZCBhbmQgYmUgc3VwcG9y
dGVkIGZvcmV2ZXIsIGF0CmxlYXN0IHBvdGVudGlhbGx5LCBzbyBhZGRpbmcgZXZlcnkgb25lIG9m
IHRoZW0gaXMgYSBzZXJpb3VzCmNvbW1pdG1lbnQuCgpUaGFua3MsClJhZmFlbApfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGlu
ZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFp
bG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
