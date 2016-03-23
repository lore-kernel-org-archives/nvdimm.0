Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3428.houston.hp.com (g4t3428.houston.hp.com [15.201.208.56])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2CA561A1E81
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 07:19:29 -0700 (PDT)
Message-ID: <1458745886.6393.638.camel@hpe.com>
Subject: Re: [RFC v2] [PATCH 0/10] DAX page fault locking
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 23 Mar 2016 09:11:26 -0600
In-Reply-To: <20160323094551.GA4512@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <20160322193212.GA11164@linux.intel.com>
 <1458680853.6393.592.camel@hpe.com> <20160323094551.GA4512@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, brian.boylston@hpe.com, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE2LTAzLTIzIGF0IDEwOjQ1ICswMTAwLCBKYW4gS2FyYSB3cm90ZToKPiBPbiBU
dWUgMjItMDMtMTYgMTU6MDc6MzMsIFRvc2hpIEthbmkgd3JvdGU6Cj4gPiBPbiBUdWUsIDIwMTYt
MDMtMjIgYXQgMTM6MzIgLTA2MDAsIFJvc3MgWndpc2xlciB3cm90ZToKPiA+ID4gT24gTW9uLCBN
YXIgMjEsIDIwMTYgYXQgMDI6MjI6NDVQTSArMDEwMCwgSmFuIEthcmEgd3JvdGU6Cj4gPiA+ID4g
W1NvcnJ5IGZvciByZXBvc3QgYnV0IEkgYWNjaWRlbnRhbGx5IHNlbnQgaW5pdGlhbCBlbWFpbCB3
aXRob3V0Cj4gPiA+ID4gcGF0Y2hlc10KPiA+ID4gPiAKPiA+ID4gPiBIZWxsbywKPiA+ID4gPiAK
PiA+ID4gPiB0aGlzIGlzIG15IHNlY29uZCBhdHRlbXB0IGF0IERBWCBwYWdlIGZhdWx0IGxvY2tp
bmcgcmV3cml0ZS4gVGhpbmdzCj4gPiA+ID4gbm93IHdvcmsgcmVhc29uYWJseSB3ZWxsLCBpdCBo
YXMgc3Vydml2ZWQgZnVsbCB4ZnN0ZXN0cyBydW4gb24KPiA+ID4gPiBleHQ0LiBJIGd1ZXNzIEkg
bmVlZCB0byBkbyBtb3JlIG1tYXAgdGFyZ2V0dGVkIHRlc3RzIHRvIHVudmVpbAo+ID4gPiA+IGlz
c3Vlcy4gR3V5cyB3aGF0IGRvIHlvdSB1c2VkIGZvciBEQVggdGVzdGluZz8KPiA+ID4gCj4gPiA+
IEkgdHlwaWNhbGx5IHVzZSB4ZnN0ZXN0cyBmb3IgcmVncmVzc2lvbiB0ZXN0aW5nLsKgwqBJZiB3
ZSBjYW4gY29tZSB1cAo+ID4gPiB3aXRoIG5ldyBnZW5lcmFsbHkgdXNlZnVsIHJlZ3Jlc3Npb24g
dGVzdHMsIGVzcGVjaWFsbHkgb25lcwo+ID4gPiBjb25jZXJuaW5nIG1tYXAgcmFjZXMsIHRoYXQg
d291bGQgYmUgYXdlc29tZS7CoMKgSSBndWVzcyBpdCdzIGp1c3QgYQo+ID4gPiBjaG9pY2UgYmV0
d2VlbiBhZGRpbmcgdGhlbSBzb21ld2hlcmUgaW4geGZzdGVzdHMgb3Igc29tZXdoZXJlIGVsc2UK
PiA+ID4gbGlrZSB3aXRoIHRoZSB1bml0IHRlc3RzIGluIG5kY3RsLgo+ID4gCj4gPiBCcmlhbiBC
b3lsc3RvbiB3cm90ZSBhIHRlc3QgZm9yIG1tYXAgcmFjZSBjb25kaXRpb25zIGFuZCBwb3N0ZWQg
aXQKPiA+IGJlZm9yZS4gwqBUaGlzIHRlc3Qgd2FzIHZlcnkgdXNlZnVsIHRvIGZpeCB0aGUgZGF0
YSBjb3JydXB0aW9uIGlzc3VlIHdlCj4gPiBoYWQgYmVmb3JlLgo+ID4gaHR0cDovL3d3dy5zcGlu
aWNzLm5ldC9saXN0cy9saW51eC1leHQ0L21zZzQ5ODc2Lmh0bWwKPiA+IAo+ID4gSWYgdGhlcmUg
aXMgYW55dGhpbmcgd2UgY2FuIGRvIHRvIG1ha2UgdGhpcyB0ZXN0IHVzZWZ1bCBhcyByZWdyZXNz
aW9uCj4gPiB0ZXN0cz8KPiAKPiBUaGFua3MgZm9yIHRoZSBwb2ludGVyLCBJIGZvcmdvdCBhYm91
dCB0aGlzIHVzZWZ1bCB0ZXN0LiBBcyBEYXZlIHNhaWQgdGhlCj4gYmVzdCB3YXkgZm9yIHRoaXMg
dG8gbm90IGdldCBsb3N0IGlzIHRvIGluY2x1ZGUgaXQgaW4geGZzdGVzdHMuIFNpbmNlIEkKPiB3
YW50IHRvIHJ1biB0aGUgdGVzdCByZWd1bGFybHkgYW55d2F5LCBJIGNhbiBpbnRlZ3JhdGUgaXQg
bXlzZWxmLgoKR3JlYXQhIFRoYW5rcyBKYW4hCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4
LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5m
by9saW51eC1udmRpbW0K
