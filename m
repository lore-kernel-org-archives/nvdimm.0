Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ou.quest-ce.net (unknown [IPv6:2001:bc8:3541:100::1])
 (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 062AD2111B786
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 10:34:00 -0700 (PDT)
Message-ID: <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
Date: Wed, 05 Sep 2018 19:33:38 +0200
In-Reply-To: <20180905165552.GB25206@kroah.com>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <20180905165552.GB25206@kroah.com>
Mime-Version: 1.0
Subject: Re: [RFC] UAPI: Check headers by compiling all together as C++
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
To: Greg KH <greg@kroah.com>, David Howells <dhowells@redhat.com>
Cc: moderated for non-subscribers <alsa-devel@alsa-project.org>, "Michael S. Tsirkin" <mst@redhat.com>, David Airlie <airlied@linux.ie>, Jason Wang <jasowang@redhat.com>, Mat Martineau <mathew.j.martineau@linux.intel.com>, dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org, Masahiro Yamada <yamada.masahiro@socionext.com>, keyrings@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-nvdimm@lists.01.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, coreteam@netfilter.org, Kent Overstreet <kent.overstreet@gmail.com>, linux-kbuild@vger.kernel.org, linux-arm-msm@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>, Jan Harkes <jaharkes@cs.cmu.edu>, Michal Marek <michal.lkml@markovi.net>, linux-api@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>, netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, freedreno@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

SGksCgpMZSBtZXJjcmVkaSAwNSBzZXB0ZW1icmUgMjAxOCDDoCAxODo1NSArMDIwMCwgR3JlZyBL
SCBhIMOpY3JpdCA6Cj4gT24gV2VkLCBTZXAgMDUsIDIwMTggYXQgMDQ6NTQ6MjdQTSArMDEwMCwg
RGF2aWQgSG93ZWxscyB3cm90ZToKPiA+IAo+ID4gSGVyZSdzIGEgc2V0IG9mIHBhdGNoZXMgdGhh
dCBpbnNlcnRzIGEgc3RlcCBpbnRvIHRoZSBidWlsZCBwcm9jZXNzIHRvIG1ha2UKPiA+IHN1cmUg
dGhhdCB0aGUgVUFQSSBoZWFkZXJzIGNhbiBhbGwgYmUgYnVpbHQgdG9nZXRoZXIgd2l0aCBDKysg
KGlmIHRoZQo+ID4gY29tcGlsZXIgYmVpbmcgdXNlZCBzdXBwb3J0cyBDKyspLiAgQWxsIGJ1dCB0
aGUgZmluYWwgcGF0Y2ggcGVyZm9ybSBmaXh1cHMsCj4gPiBpbmNsdWRpbmc6Cj4gCj4gV2FpdCwg
d2h5IGRvIHdlIGNhcmU/ICBXaGF0IGhhcyByZWNlbnRseSBjaGFuZ2VkIHRvIHN0YXJ0IHRvIGRp
cmVjdGx5Cj4gaW1wb3J0IGtlcm5lbCB1YXBpIGZpbGVzIGludG8gQysrIGNvZGU/Cj4gCj4gQW5k
IGlmIHVzZXJzcGFjZSB3YW50cyB0byBkbyB0aGlzLCBjYW4ndCB0aGV5IGRvIHRoZSBDIG5hbWVz
cGFjZSB0cmljawo+IHRoZW1zZWx2ZXMgd2hlbiB0aGV5IGRvIHRoZSBpbXBvcnQ/ICBUaGF0IG11
c3QgYmUgaG93IHRoZXkgYXJlIGRvaW5nIGl0Cj4gdG9kYXksIHJpZ2h0Pwo+IAoKVGhleSBjYW4n
dC4KCgpBZGRpbmcgZXh0ZXJuICJDIiB7IH0gZG9lc24ndCBtYWdpY2FsbHkgbWFrZSAiY2xhc3Mi
IGEgbm9uIGtleXdvcmQuCkV2ZW4gaWYgaXQgd2FzIHRoZSBjYXNlLCB3cml0aW5nIEMrKyBjb2Rl
IHVzaW5nIHdoYXRldmVyLT5jbGFzcyB3b3VsZApwcm9iYWJseSBicm9rZSBiZWNhdXNlIGNsYXNz
IGlzIGEga2V5d29yZCBpbiBDKysuCgotLSAKWWFubiBEcm9uZWF1ZApPUFRFWUEKCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
