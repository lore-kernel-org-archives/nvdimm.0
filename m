Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ou.quest-ce.net (unknown [IPv6:2001:bc8:3541:100::1])
 (using TLSv1.2 with cipher AES128-SHA (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70A7B2111B79A
 for <linux-nvdimm@lists.01.org>; Thu,  6 Sep 2018 00:13:21 -0700 (PDT)
Message-ID: <48b8af08170fb896c12cc4e3eae7501b4fa4181d.camel@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 06 Sep 2018 09:12:58 +0200
In-Reply-To: <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <20180905165552.GB25206@kroah.com>
 <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
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

TGUgbWVyY3JlZGkgMDUgc2VwdGVtYnJlIDIwMTggw6AgMTk6MzMgKzAyMDAsIFlhbm4gRHJvbmVh
dWQgYSDDqWNyaXQgOgo+IExlIG1lcmNyZWRpIDA1IHNlcHRlbWJyZSAyMDE4IMOgIDE4OjU1ICsw
MjAwLCBHcmVnIEtIIGEgw6ljcml0IDoKPiA+IE9uIFdlZCwgU2VwIDA1LCAyMDE4IGF0IDA0OjU0
OjI3UE0gKzAxMDAsIERhdmlkIEhvd2VsbHMgd3JvdGU6Cj4gPiA+IAo+ID4gPiBIZXJlJ3MgYSBz
ZXQgb2YgcGF0Y2hlcyB0aGF0IGluc2VydHMgYSBzdGVwIGludG8gdGhlIGJ1aWxkCj4gPiA+IHBy
b2Nlc3MgdG8gbWFrZQo+ID4gPiBzdXJlIHRoYXQgdGhlIFVBUEkgaGVhZGVycyBjYW4gYWxsIGJl
IGJ1aWx0IHRvZ2V0aGVyIHdpdGggQysrIChpZgo+ID4gPiB0aGUKPiA+ID4gY29tcGlsZXIgYmVp
bmcgdXNlZCBzdXBwb3J0cyBDKyspLiAgQWxsIGJ1dCB0aGUgZmluYWwgcGF0Y2gKPiA+ID4gcGVy
Zm9ybSBmaXh1cHMsCj4gPiA+IGluY2x1ZGluZzoKPiA+IAo+ID4gV2FpdCwgd2h5IGRvIHdlIGNh
cmU/ICBXaGF0IGhhcyByZWNlbnRseSBjaGFuZ2VkIHRvIHN0YXJ0IHRvCj4gPiBkaXJlY3RseQo+
ID4gaW1wb3J0IGtlcm5lbCB1YXBpIGZpbGVzIGludG8gQysrIGNvZGU/Cj4gPiAKPiA+IEFuZCBp
ZiB1c2Vyc3BhY2Ugd2FudHMgdG8gZG8gdGhpcywgY2FuJ3QgdGhleSBkbyB0aGUgQyBuYW1lc3Bh
Y2UKPiA+IHRyaWNrCj4gPiB0aGVtc2VsdmVzIHdoZW4gdGhleSBkbyB0aGUgaW1wb3J0PyAgVGhh
dCBtdXN0IGJlIGhvdyB0aGV5IGFyZQo+ID4gZG9pbmcgaXQKPiA+IHRvZGF5LCByaWdodD8KPiA+
IAo+IAo+IFRoZXkgY2FuJ3QuCj4gCj4gCj4gQWRkaW5nIGV4dGVybiAiQyIgeyB9IGRvZXNuJ3Qg
bWFnaWNhbGx5IG1ha2UgImNsYXNzIiBhIG5vbiBrZXl3b3JkLgo+IEV2ZW4gaWYgaXQgd2FzIHRo
ZSBjYXNlLCB3cml0aW5nIEMrKyBjb2RlIHVzaW5nIHdoYXRldmVyLT5jbGFzcyB3b3VsZAo+IHBy
b2JhYmx5IGJyb2tlIGJlY2F1c2UgY2xhc3MgaXMgYSBrZXl3b3JkIGluIEMrKy4KPiAKCkZvciB0
aGUgcmVjb3JkLCBsaWJYMTEgaGFzIHRvIGhhbmRsZSB0aGUga2luayBwZiBpc3N1ZSB3aXRoIEMr
KwprZXl3b3JkOgoKCmh0dHBzOi8vZ2l0bGFiLmZyZWVkZXNrdG9wLm9yZy94b3JnL2xpYi9saWJ4
MTEvYmxvYi83MzNmNjRiZmViMzExYzFkMDQwYjJmNzUxYmZkZWY5YzlkMGY4OWVmL2luY2x1ZGUv
WDExL1hsaWIuaCNMMjI3Cgp0eXBlZGVmIHN0cnVjdCB7CglYRXh0RGF0YSAqZXh0X2RhdGE7CS8q
IGhvb2sgZm9yIGV4dGVuc2lvbiB0byBoYW5nIGRhdGEgKi8KCVZpc3VhbElEIHZpc3VhbGlkOwkv
KiB2aXN1YWwgaWQgb2YgdGhpcyB2aXN1YWwgKi8KI2lmIGRlZmluZWQoX19jcGx1c3BsdXMpIHx8
IGRlZmluZWQoY19wbHVzcGx1cykKCWludCBjX2NsYXNzOwkJLyogQysrIGNsYXNzIG9mIHNjcmVl
biAobW9ub2Nocm9tZSwgZXRjLikgKi8KI2Vsc2UKCWludCBjbGFzczsJCS8qIGNsYXNzIG9mIHNj
cmVlbiAobW9ub2Nocm9tZSwgZXRjLikgKi8KI2VuZGlmCgl1bnNpZ25lZCBsb25nIHJlZF9tYXNr
LCBncmVlbl9tYXNrLCBibHVlX21hc2s7CS8qIG1hc2sgdmFsdWVzICovCglpbnQgYml0c19wZXJf
cmdiOwkvKiBsb2cgYmFzZSAyIG9mIGRpc3RpbmN0IGNvbG9yIHZhbHVlcyAqLwoJaW50IG1hcF9l
bnRyaWVzOwkvKiBjb2xvciBtYXAgZW50cmllcyAqLwp9IFZpc3VhbDsKCgpSZWdhcmRzLgoKLS0g
Cllhbm4gRHJvbmVhdWQKT1BURVlBCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
