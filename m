From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Badblocks checking/representation in filesystems
Date: Sat, 21 Jan 2017 00:23:24 +0000
Message-ID: <1484961537.2029.22.camel@hpe.com>
References: <CAL4pJv6MvJhTuPJbPAV-HXGrMST-dJs461O=wwfcpdvQA-amdA@mail.gmail.com>
 <20170120004633.GA14128@omniknight.lm.intel.com>
 <20170120182435.0E12.E1E9C6FF@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170120182435.0E12.E1E9C6FF-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Content-Language: en-US
Content-ID: <365FEB0F58C3034799803438026C42F3-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "y-goto-+CUm20s59erQFUHtdCDX3A@public.gmane.org" <y-goto-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org" <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "Vyacheslav.Dubeyko-Sjgp3cTcYWE@public.gmane.org" <Vyacheslav.Dubeyko-Sjgp3cTcYWE@public.gmane.org>, "darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "andiry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <andiry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org" <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

T24gRnJpLCAyMDE3LTAxLTIwIGF0IDE4OjI0ICswOTAwLCBZYXN1bm9yaSBHb3RvIHdyb3RlOg0K
IDoNCj4gPiANCj4gPiBMaWtlIG1lbnRpb25lZCBiZWZvcmUsIHRoaXMgZGlzY3Vzc2lvbiBpcyBt
b3JlIGFib3V0IHByZXNlbnRhdGlvbg0KPiA+IG9mIGVycm9ycyBpbiBhIGtub3duIGNvbnN1bWFi
bGUgZm9ybWF0LCByYXRoZXIgdGhhbiByZWNvdmVyaW5nIGZyb20NCj4gPiBlcnJvcnMuIFdoaWxl
IHJlY292ZXJpbmcgZnJvbSBlcnJvcnMgaXMgaW50ZXJlc3RpbmcsIHdlIGFscmVhZHkNCj4gPiBo
YXZlIGxheWVycyBsaWtlIFJBSUQgZm9yIHRoYXQsIGFuZCB0aGV5IGFyZSBhcyBhcHBsaWNhYmxl
IHRvDQo+ID4gTlZESU1NIGJhY2tlZCBzdG9yYWdlIGFzIHRoZXkgaGF2ZSBiZWVuIGZvciBkaXNr
L1NTRCBiYXNlZCBzdG9yYWdlLg0KPiANCj4gSSBoYXZlIG9uZSBxdWVzdGlvbiBoZXJlLg0KPiAN
Cj4gQ2VydGFpbmx5LCB1c2VyIGNhbiB1c2UgTFZNIG1pcnJvcmluZyBmb3Igc3RvcmFnZSBtb2Rl
IG9mIE5WRElNTS4NCj4gSG93ZXZlciwgTlZESU1NIGhhcyBEQVggbW9kZS7CoA0KPiBDYW4gdXNl
ciB1c2UgTFZNIG1pcnJvcmluZyBmb3IgTlZESU1NIERBWCBtb2RlPw0KPiBJIGNvdWxkIG5vdCBm
aW5kIGFueSBpbmZvcm1hdGlvbiB0aGF0IExWTSBzdXBwb3J0IERBWC4uLi4NCg0KZG0tbGluZWFy
IGFuZCBkbS1zdHJpcGUgc3VwcG9ydCBEQVguICBUaGlzIGlzIGRvbmUgYnkgbWFwcGluZyBibG9j
aw0KYWxsb2NhdGlvbnMgdG8gTFZNIHBoeXNpY2FsIGRldmljZXMuICBPbmNlIGJsb2NrcyBhcmUg
YWxsb2NhdGVkLCBhbGwNCkRBWCBJL09zIGFyZSBkaXJlY3QgYW5kIGRvIG5vdCBnbyB0aHJvdWdo
IHRoZSBkZXZpY2UtbWFwcGVyIGxheWVyLiAgV2UNCm1heSBiZSBhYmxlIHRvIGNoYW5nZSBpdCBm
b3IgcmVhZC93cml0ZSBwYXRocywgYnV0IGl0IHJlbWFpbnMgdHJ1ZSBmb3INCm1tYXAuICBTbywg
SSBkbyBub3QgdGhpbmsgREFYIGNhbiBiZSBzdXBwb3J0ZWQgd2l0aCBMVk0gbWlycm9yaW5nLiAN
ClRoaXMgZG9lcyBub3QgcHJlY2x1ZGUgaGFyZHdhcmUgbWlycm9yaW5nLCB0aG91Z2guDQoNCi1U
b3NoaQ0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGlu
dXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8v
bGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
