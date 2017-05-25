Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF96821A08D83
 for <linux-nvdimm@lists.01.org>; Thu, 25 May 2017 06:30:55 -0700 (PDT)
Message-ID: <1495718961.6967.117.camel@linux.intel.com>
Subject: Re: [PATCH 10/23] afs: switch to use uuid_t and uuid_gen
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 25 May 2017 16:29:21 +0300
In-Reply-To: <20170525130027.GA30194@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-11-hch@lst.de>
 <1495478957.6967.69.camel@linux.intel.com> <20170523084956.GB20121@lst.de>
 <1495545099.6967.81.camel@linux.intel.com> <20170525130027.GA30194@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA1LTI1IGF0IDE1OjAwICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToKPiBPbiBUdWUsIE1heSAyMywgMjAxNyBhdCAwNDoxMTozOVBNICswMzAwLCBBbmR5IFNoZXZj
aGVua28gd3JvdGU6Cj4gPiBTaW5jZSB3ZSBpbnRyb2R1Y2VkIGEgdW5pb24gaXQncyBwb3NzaWJs
ZSB0aGF0IHdlIG1pZ2h0IGFjY2VzcyB0aGUKPiA+IG1lbWJlciB3aGljaCB3YXNuJ3QgbGFzdCBt
b2RpZmllZCBvbmUuIFNvLCBteSBjb21tZW50IGlzIHRvIGdpdmUgYW4KPiA+IGF0dGVudGlvbiBv
biBzdWNoIHBvc3NpYmlsaXR5IGFuZCBhdm9pZCBpZiB0aGVyZSBpcyBhbiBhbGlhc2luZwo+ID4g
aGFwcGVuZWQuCj4gCj4gV2UgZG8gZm9yIEFGUyAoYW5kIFhGUyBmb3IgZnMgZnNpZCkuwqDCoE15
IHByZWZlcmVuY2Ugd291bGQgYmUgdG8KPiBub3QgaGF2ZSB0aGUgdjEgc3RydWN0IGRlZmludGlv
biBidXQgaW5zdGVhZCBwcm92aWRlIGEgZmV3Cj4gaGVscGVycyBpbiB1dWlkLmggdGhhdCB1c2Ug
Z2V0X3VuYWxpZ25lZF9iZSogaWYgbmVlZGVkOgo+IAo+IAl1dWlkX3YxX3RpbWVfbG93KCkKPiAJ
dXVpZF92MV90aW1lX21pZCgpCj4gCXV1aWRfdjFfdGltZV90aW1lX2hpX2FuZF92ZXJzaW9uKCku
Lgo+IAo+IEZyb20gaGlzIHByZXZpb3VzbHkgcmVwbHkgaXQgc2VlbXMgbGlrZSBEYXZlIGRvZXNu
J3QgbGlrZSB0aGF0IGlkZWEKPiB0b28gbXVjaCwgaW4gd2hpY2ggY2FzZSBJIHN1c3BlY3QgbW92
aW5nIHN0cnVjdCB1dWlkX3YxIGJhY2sgaW50bwo+IGFmcyBhbmQgbGl2aW5nIHdpdGggY2FzdCBp
biBpdCBpcyB0aGUgd2F5IHRvIGdvLgoKUGVyc29uYWxseSBJIGRvbid0IGxpa2UgdGhhdCB1bmlv
biBzdHVmZiwgc28sIGRlZmluaXRlbHkgbXkgdm90ZSB0byBnZXQKcmlkIG9mIEFGUyBzdHVmZiBp
biBnZW5lcmljIGhlbHBlcnMuCgpPVE9IIGlmIHRoZXJlIHdpbGwgYmUgbW9yZSB1c2VycyBvZiBz
dWNoIEFQSSB0aGVuIHNvbWV0aGluZyBsaWtlIHlvdQpwcm9wb3NlZCB3b3VsZCBiZSBzdWZmaWNp
ZW50IHdpdGhvdXQgaW50cm9kdWNpbmcgYSB1bmlvbi4KCi0tIApBbmR5IFNoZXZjaGVua28gPGFu
ZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNvbT4KSW50ZWwgRmlubGFuZCBPeQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
