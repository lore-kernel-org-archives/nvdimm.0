Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3428.houston.hp.com (g4t3428.houston.hp.com [15.201.208.56])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4CCDD1A1E42
 for <linux-nvdimm@lists.01.org>; Tue, 22 Mar 2016 13:15:35 -0700 (PDT)
Message-ID: <1458680853.6393.592.camel@hpe.com>
Subject: Re: [RFC v2] [PATCH 0/10] DAX page fault locking
From: Toshi Kani <toshi.kani@hpe.com>
Date: Tue, 22 Mar 2016 15:07:33 -0600
In-Reply-To: <20160322193212.GA11164@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <20160322193212.GA11164@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, brian.boylston@hpe.com, "Wilcox, Matthew" R" <matthew.r.wilcox@intel.com>, NeilBrown <neilb@suse.com>," linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTAzLTIyIGF0IDEzOjMyIC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6Cj4g
T24gTW9uLCBNYXIgMjEsIDIwMTYgYXQgMDI6MjI6NDVQTSArMDEwMCwgSmFuIEthcmEgd3JvdGU6
Cj4gPiBbU29ycnkgZm9yIHJlcG9zdCBidXQgSSBhY2NpZGVudGFsbHkgc2VudCBpbml0aWFsIGVt
YWlsIHdpdGhvdXQKPiA+IHBhdGNoZXNdCj4gPiAKPiA+IEhlbGxvLAo+ID4gCj4gPiB0aGlzIGlz
IG15IHNlY29uZCBhdHRlbXB0IGF0IERBWCBwYWdlIGZhdWx0IGxvY2tpbmcgcmV3cml0ZS4gVGhp
bmdzIG5vdwo+ID4gd29yayByZWFzb25hYmx5IHdlbGwsIGl0IGhhcyBzdXJ2aXZlZCBmdWxsIHhm
c3Rlc3RzIHJ1biBvbiBleHQ0LiBJCj4gPiBndWVzcyBJIG5lZWQgdG8gZG8gbW9yZSBtbWFwIHRh
cmdldHRlZCB0ZXN0cyB0byB1bnZlaWwgaXNzdWVzLiBHdXlzCj4gPiB3aGF0IGRvIHlvdSB1c2Vk
IGZvciBEQVggdGVzdGluZz8KPiAKPiBJIHR5cGljYWxseSB1c2UgeGZzdGVzdHMgZm9yIHJlZ3Jl
c3Npb24gdGVzdGluZy7CoMKgSWYgd2UgY2FuIGNvbWUgdXAgd2l0aAo+IG5ldyBnZW5lcmFsbHkg
dXNlZnVsIHJlZ3Jlc3Npb24gdGVzdHMsIGVzcGVjaWFsbHkgb25lcyBjb25jZXJuaW5nIG1tYXAK
PiByYWNlcywgdGhhdCB3b3VsZCBiZSBhd2Vzb21lLsKgwqBJIGd1ZXNzIGl0J3MganVzdCBhIGNo
b2ljZSBiZXR3ZWVuIGFkZGluZwo+IHRoZW0gc29tZXdoZXJlIGluIHhmc3Rlc3RzIG9yIHNvbWV3
aGVyZSBlbHNlIGxpa2Ugd2l0aCB0aGUgdW5pdCB0ZXN0cyBpbgo+IG5kY3RsLgoKQnJpYW4gQm95
bHN0b24gd3JvdGUgYSB0ZXN0IGZvciBtbWFwIHJhY2UgY29uZGl0aW9ucyBhbmQgcG9zdGVkIGl0
IGJlZm9yZS4KwqBUaGlzIHRlc3Qgd2FzIHZlcnkgdXNlZnVsIHRvIGZpeCB0aGUgZGF0YSBjb3Jy
dXB0aW9uIGlzc3VlIHdlIGhhZCBiZWZvcmUuCmh0dHA6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMv
bGludXgtZXh0NC9tc2c0OTg3Ni5odG1sCgpJZiB0aGVyZSBpcyBhbnl0aGluZyB3ZSBjYW4gZG8g
dG8gbWFrZSB0aGlzIHRlc3QgdXNlZnVsIGFzIHJlZ3Jlc3Npb24KdGVzdHM/CgpUaGFua3MsCi1U
b3NoaQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGlu
dXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8v
bGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
