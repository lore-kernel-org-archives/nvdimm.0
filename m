Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 570FE1A1ED1
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:11:42 -0800 (PST)
Message-ID: <1457481844.15454.510.camel@hpe.com>
Subject: Re: [PATCH v2-UPDATE2 3/4] resource: Add device-managed
 insert/remove_resource()
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 08 Mar 2016 17:04:04 -0700
In-Reply-To: <CAPcyv4i2GwujqK=MDJpSKhvufJprmCV4vmQRpS_UP-n1kau+mg@mail.gmail.com>
References: <1457460530-17959-1-git-send-email-toshi.kani@hpe.com>
 <CA+55aFy=V-esUXZa2AogS685k+r9PyyNStkZrrUUkWSKvLFUGQ@mail.gmail.com>
 <CAPcyv4gT1RvnEquYXVo7sZscdUrkiWpG-Yvr_EX4=L25397X0g@mail.gmail.com>
 <CA+55aFxPn3J68MsqQd7OVv7jetZjPduP53MFmw2f_-z7=ebpXQ@mail.gmail.com>
 <CAPcyv4i2GwujqK=MDJpSKhvufJprmCV4vmQRpS_UP-n1kau+mg@mail.gmail.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki  <rjw@rjwysocki.net>, Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTAzLTA4IGF0IDE0OjQ0IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
T24gVHVlLCBNYXIgOCwgMjAxNiBhdCAyOjIzIFBNLCBMaW51cyBUb3J2YWxkcwo+IDx0b3J2YWxk
c0BsaW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cj4gPiBPbiBUdWUsIE1hciA4LCAyMDE2IGF0
IDEyOjU5IFBNLCBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbQo+ID4gPiB3
cm90ZToKPiA+ID4gCj4gPiA+IEhlcmUncyB0aGUgdXNhZ2UgcGF0Y2ggZnJvbSBUb3NoaSBbMV0g
KGNvcGllZCBiZWxvdykuwqDCoEl0IGlzIGluZGVlZCBhCj4gPiA+IHJlc291cmNlIGluamVjdGVk
IGJ5IG5maXQgLyBudmRpbW0gYnVzIGltcGxlbWVudGF0aW9uLsKgwqBXZSBqdXN0Cj4gPiA+IGhh
cHBlbgo+ID4gPiB0byBzdXBwb3J0IG5maXQgYW5kIGxpYm52ZGltbSBhcyBtb2R1bGVzLgo+ID4g
PiAKPiA+ID4gVGhlIGdvYWwgb2YgdGhlc2UgcGF0Y2hlcyBpcyB0byB1c2UgdGhlIEFDUEkgTkZJ
VCBkYXRhIHRvIGNyZWF0ZSBhCj4gPiA+ICJQZXJzaXN0ZW50IE1lbW9yeSIgcmF0aGVyIHRoYW4g
InJlc2VydmVkIiByZXNvdXJjZS7CoMKgVGhpcyBpcyBmb3IKPiA+ID4gcGxhdGZvcm0tZmlybXdh
cmUgaW1wbGVtZW50YXRpb25zIHRoYXQgdXNlIEU4MjAtVHlwZTIgcmF0aGVyIHRoYW4KPiA+ID4g
RTgyMC1UeXBlNyB0byBkZXNjcmliZSBwbWVtLgo+ID4gCj4gPiBTbyBteSB3b3JyeSBpcyB0aGF0
IHRoZXJlIGlzIGxpa2VseSBleGFjdGx5IG9uZSBvciB0d28gb2YgdGhlc2Uga2luZHMKPiA+IG9m
IHNpdGVzLgo+ID4gCj4gPiBXaHkgY291bGRuJ3QgdGhleSBqdXN0IHVzZSBpbnNlcnRfcmVzb3Vy
Y2UoKSBhbmQgdGhlbiByZW1vdmUgaXQKPiA+IG1hbnVhbGx5Pwo+IAo+IFlvdSBtZWFuIGluc3Rl
YWQgb2YgaW50cm9kdWNpbmcgYSBkZXZtX2luc2VydF9yZXNvdXJjZSgpIGFzIGEgaGVscGZ1bAo+
IGZpcnN0LWNsYXNzLWNpdGl6ZW4gYXBpLCBqdXN0IGFycmFuZ2UgZm9yIHRoZSByZXNvdXJjZSB0
byBiZSBpbnNlcnRlZAo+IGxvY2FsbHk/wqDCoFN1cmUuCj4gCj4gSSBhc3N1bWUgVG9zaGkgd2Fz
IGxvb2tpbmcgdG8ga2VlcCB0aGUgZGV2bSBzZW1hbnRpY3MgbGlrZSB0aGUgcmVzdCBvZgo+IHRo
ZSBuZml0IGRyaXZlciwgYnV0IHdlIGNhbiBkbyB0aGF0IGxvY2FsbHkgd2l0aCBkZXZtX2FkZF9h
Y3Rpb24oKSBhbmQKPiBza2lwIHRoZSBuZXcgZ2VuZXJhbCBwdXJwb3NlIGFwaS4KClllcywgSSBw
cmVmZXIgdGhlIGRldm0gc2VtYW50aWNzLiDCoGluc2VydF9yZXNvdXJjZSgpIGFuZCByZW1vdmVf
cmVzb3VyY2UoKQphcmUgbm90IGV4cG9ydGVkIGludGVyZmFjZXMuIMKgU28sIHdpdGggZGV2bV9h
ZGRfYWN0aW9uKCksIHdlIHN0aWxsIG5lZWQgdG8KaW50cm9kdWNlIGJ1aWx0LWluIGV4cG9ydGVk
IHdyYXBwZXJzIGZvciBpbnNlcnQvcmVtb3ZlX3Jlc291cmNlKCksIHVubGVzcwp3ZSBjaGFuZ2Ug
dG8gZXhwb3J0IHRoZW0gZGlyZWN0bHkuIMKgU2luY2Ugd2UgbmVlZCB0byBleHBvcnQgInNvbWV0
aGluZyIsIEkKdGhpbmsgaXQgaXMgYmV0dGVyIHRvIGV4cG9ydCB0aGVpciBkZXZtIGludGVyZmFj
ZXMuCgpUaGFua3MsCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
