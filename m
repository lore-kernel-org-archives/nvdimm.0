Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 468E02118C50E
 for <linux-nvdimm@lists.01.org>; Mon, 12 Nov 2018 07:42:44 -0800 (PST)
Subject: Re: [PATCH 02/11] libnvdimm/security: change clear text nvdimm keys
 to encrypted keys
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163666.70506.8805433934495072699.stgit@djiang5-desk3.ch.intel.com>
 <1541957268.3734.53.camel@linux.ibm.com>
 <CAPcyv4jMPDap8L6jTo9NGnrJGCjUY_BvSBuPge8NL4QS2Ku0CQ@mail.gmail.com>
 <1541966975.3734.78.camel@linux.ibm.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <bf917ee9-1795-9c10-ecec-28c7d5d68345@intel.com>
Date: Mon, 12 Nov 2018 08:42:43 -0700
MIME-Version: 1.0
In-Reply-To: <1541966975.3734.78.camel@linux.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Mimi Zohar <zohar@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>
Cc: keyrings@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Ck9uIDExLzExLzIwMTggMTowOSBQTSwgTWltaSBab2hhciB3cm90ZToKPj4+IFRyYWRpdGlvbmFs
bHkgdGhlcmUgaXMgYSBzaW5nbGUgbWFzdGVyIGtleSBmb3IgdGhlIHN5c3RlbSwgd2hpY2ggd291
bGQKPj4+IGJlIHNlYWxlZCB0byBhIHNldCBvZiBib290IHRpbWUgUENSIHZhbHVlcy4gIEFmdGVy
IGRlY3J5cHRpbmcgYWxsIG9mCj4+PiB0aGUgZW5jcnlwdGVkIGtleXMsIHRoZSBtYXN0ZXIga2V5
IHdvdWxkIGJlIHJlbW92ZWQgZnJvbSB0aGUga2V5cmluZwo+Pj4gYW5kIGEgUENSIGV4dGVuZGVk
LiAgRXh0ZW5kaW5nIGEgUENSIHdvdWxkIHByZXZlbnQgdGhlIG1hc3RlciBrZXkgZnJvbQo+Pj4g
YmVpbmcgdW5zZWFsZWQgYWdhaW4gYW5kIHVzZWQgdG8gZGVjcnlwdCBlbmNyeXB0ZWQga2V5cywg
d2l0aG91dAo+Pj4gcmVib290aW5nIHRoZSBzeXN0ZW0uICBOb3JtYWxseSB0aGlzIHdvdWxkIGJl
IGRvbmUgYmVmb3JlIHBpdm90aW5nCj4+PiByb290Lgo+Pj4KPj4+IElmIHlvdSdyZSBub3QgcmVm
ZXJyaW5nIHRvIHRoZSBzeXN0ZW0gbWFzdGVyIGtleSBhbmQgYXJlIGludGVudGlvbmFsbHkKPj4+
IGxpbWl0aW5nIHVzYWdlIHRvIFRQTSAyLjAsIG1vcmUgZGV0YWlscyBvbiB0aGUgbWFzdGVyIGtl
eSBzZWN1cml0eQo+Pj4gcmVxdWlyZW1lbnRzIHNob3VsZCBiZSBpbmNsdWRlZC4KPj4gT2gsIGlu
dGVyZXN0aW5nIHBvaW50LiBJIHRoaW5rIHdlIGhhZCBiZWVuIGFzc3VtaW5nIGEgbG9jYWwgKwo+
PiB1bnNlYWxlZC1hdC1ydW50aW1lIG52ZGltbSBtYXN0ZXIga2V5IHJhdGhlciB0aGFuIGEgc3lz
dGVtLXdpZGUgbWFzdGVyCj4+IGtleS4gWWVzLCB3ZSBuZWVkIHRvIHJldGhpbmsgdGhpcyBpbiB0
ZXJtcyBvZiBzdXBwb3J0aW5nIGEgc2VhbGVkCj4+IHN5c3RlbS1rZXkuIFRoaXMgd291bGQgc2Vl
bSB0byBsaW1pdCBzZWN1cml0eSBhY3Rpb25zLCBvdXRzaWRlIG9mCj4+IHVubG9jaywgdG8gYWx3
YXlzIHJlcXVpcmluZyBhIHJlYm9vdC4gSS5lLiB0aGUgbm9taW5hbCBjYXNlIGlzIHRoYXQgd2UK
Pj4gYm9vdCB1cCBhbmQgdW5sb2NrIHRoZSBESU1NcywgYnV0IGFueSBzdWJzZXF1ZW50IHNlY3Vy
aXR5IG9wZXJhdGlvbgo+PiBsaWtlIGVyYXNlLCBvciBjaGFuZ2UtcGFzc3BocmFzZSB3b3VsZCBy
ZXF1aXJlIHJlYm9vdGluZyBpbnRvIGFuCj4+IGVudmlyb25tZW50IHdoZXJlIHRoZSBzeXN0ZW0t
bWFzdGVyIGtleSBpcyB1bnNlYWxlZC4gSSBkbyB0aGluawo+PiByZS1wcm92aXNpb25pbmcga2V5
cyBhbmQgZXJhc2luZyBESU1NIGNvbnRlbnRzIGFyZSBzdWZmaWNpZW50bHkKPj4gZXhjZXB0aW9u
YWwgZXZlbnRzIHRoYXQgYSByZWJvb3QgcmVxdWlyZW1lbnQgaXMgdG9sZXJhYmxlLgo+PiBJcyB0
aGVyZSBhbHJlYWR5IGV4aXN0aW5nIHRvb2xpbmcgYXJvdW5kIHRoaXMgdG8gYmUgYWJsZSB0byBz
Y2hlZHVsZQo+PiBtYXN0ZXIta2V5IHJlbGF0ZWQgYWN0aW9ucyB0byBiZSBkZWZlcnJlZCB0byBh
biBpbml0cmQgZW52aXJvbm1lbnQ/Cj4gVGhlcmUncyB0aGUgb3JpZ2luYWwgZHJhY3V0IHN1cHBv
cnQgZm9yIGxvYWRpbmcgYSBtYXN0ZXJrZXksIHdoaWNoIGlzCj4gdXNlZCBieSB0aGUgRVZNIGFu
ZCBlY3J5cHRmcyBkcmFjdXQgbW9kdWxlcy4gwqBBZnRlciB0aGUgbGFzdCB1c2FnZSwKPiB0aGUg
bWFzdGVya2V5IG5lZWRzIHRvIGJlIHJlbW92ZWQgZnJvbSB0aGUga2V5cmluZy4KCkhvdyBkb2Vz
IG9uZSBnZW5lcmF0ZSBuZXcgZW5jcnlwdGVkIGtleXMgd2l0aCB0aGUgc3lzdGVtIG1hc3Rlcmtl
eSAKcmVtb3ZlZCBmcm9tIHRoZSBrZXlyaW5nPwoKCj4KPiBEaWZmZXJlbnQgcGVvcGxlIG92ZXIg
dGhlIHllYXJzIGhhdmUgd2FudGVkIHRvIGFkZCBzdXBwb3J0IGZvcgo+IGNhbGN1bGF0aW5nIHRo
ZSBib290IHRpbWUgZXhwZWN0ZWQgUENScyB2YWx1ZXMgaW4gb3JkZXIgdG8gcmVzZWFsIGtleXMK
PiAodHJ1c3RlZCBrZXkgdXBkYXRlKSwgYnV0IEkgaGF2ZW4ndCBsb29rZWQgdG8gc2VlIGlmIHRo
ZXJlIGFyZSBhbnkKPiBvcGVuIHNvdXJjZSB0b29scyBhdmFpbGFibGUuCj4KPiBNaW1pCj4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1t
IG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEu
b3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
