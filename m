Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F16C6211B6C17
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 23:47:11 -0800 (PST)
Subject: Re: [PATCH 4/4] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181905.12E102B4@viggo.jf.intel.com>
 <5ef5d5e9-9d35-fb84-b69e-7456dcf4c241@linux.intel.com>
 <1e9377c6-11a0-3bbd-763d-d9347bd556cf@intel.com>
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Message-ID: <74c01a55-1a47-d649-a32a-ea597c24ab4a@linux.intel.com>
Date: Fri, 18 Jan 2019 15:47:32 +0800
MIME-Version: 1.0
In-Reply-To: <1e9377c6-11a0-3bbd-763d-d9347bd556cf@intel.com>
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
To: Dave Hansen <dave.hansen@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, dave@sr71.net
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

T24gMjAxOS8xLzE3IOS4i+WNiDExOjE3LCBEYXZlIEhhbnNlbiB3cm90ZToKPiBPbiAxLzE3LzE5
IDEyOjE5IEFNLCBZYW5taW4gWmhhbmcgd3JvdGU6Cj4+Pgo+PiBJIGRpZG4ndCB0cnkgcG1lbSBh
bmQgSSBhbSB3b25kZXJpbmcgaXQncyBzbG93ZXIgdGhhbiBEUkFNLgo+PiBTaG91bGQgYSBmbGFn
LCBzdWNoIGxpa2UgX0dGUF9QTUVNLCBiZSBhZGRlZCB0byBkaXN0aW5ndWlzaCBpdCBmcm9tCj4+
IERSQU0/Cj4gCj4gQWJzb2x1dGVseSBub3QuIDopCkFncmVlLgoKPiAKPiBXZSBhbHJlYWR5IGhh
dmUgcGVyZm9ybWFuY2UtZGlmZmVyZW50aWF0ZWQgbWVtb3J5LCBhbmQgbG90cyBvZiB3YXlzIHRv
Cj4gZW51bWVyYXRlIGFuZCBzZWxlY3QgaXQgaW4gdGhlIGtlcm5lbCAoYWxsIG9mIG91ciBOVU1B
IGluZnJhc3RydWN0dXJlKS4KS2VybmVsIGRvZXMgbWFuYWdlIG1lbW9yeSBsaWtlIHdoYXQgeW91
IHNheS4KTXkgcXVlc3Rpb24gaXM6IHdpdGggeW91ciBwYXRjaCwgUE1FTSBiZWNvbWVzIG5vcm1h
bCBSQU0sIHRoZW4gdGhlcmUgaXMKYSBjaGFuY2UgZm9yIGtlcm5lbCB0byBhbGxvY2F0ZSBQTUVN
IGFzIERNQSBidWZmZXIuClNvbWUgc3VwZXIgc3BlZWQgZGV2aWNlcyBsaWtlIDEwR2lnYSBOSUMs
IFVTQiAoU1NJQyBjb25uZWN0aW5nIG1vZGVtKSwgCm1pZ2h0IG5vdCB3b3JrIHdlbGwgaWYgRE1B
IGJ1ZmZlciBpcyBpbiBQTUVNIGFzIGl0J3Mgc2xvd2VyIHRoYW4gRFJBTS4KClNob3VsZCB5b3Vy
IHBhdGNoc2V0IGNvbnNpZGVyIGl0PwoKCgo+IAo+IFBNRU0gaXMgYWxzbyBqdXN0IHRoZSBmaXJz
dCBvZiBtYW55ICJraW5kcyIgb2YgbWVtb3J5IHRoYXQgZm9sa3Mgd2FudCB0bwo+IGJ1aWxkIGlu
IHN5c3RlbXMgYW5kIHVzZSBhICJSQU0iLiAgV2UgbGl0ZXJhbGx5IGRvbid0IGhhdmUgc3BhY2Ug
dG8gcHV0Cj4gYSBmbGFnIGluIGZvciBlYWNoIHR5cGUuCj4gCj4gCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QK
TGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2xpbnV4LW52ZGltbQo=
