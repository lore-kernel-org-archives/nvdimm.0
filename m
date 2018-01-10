Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x22d.google.com (mail-wm0-x22d.google.com
 [IPv6:2a00:1450:400c:c09::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09D17222CF1B4
 for <linux-nvdimm@lists.01.org>; Wed, 10 Jan 2018 09:36:13 -0800 (PST)
Received: by mail-wm0-x22d.google.com with SMTP id f206so509237wmf.5
 for <linux-nvdimm@lists.01.org>; Wed, 10 Jan 2018 09:41:25 -0800 (PST)
Mime-Version: 1.0 (1.0)
Subject: Re: Detecting NUMA per pmem
From: Oren Berman <oren@lightbitslabs.com>
In-Reply-To: <CAPcyv4hOqiq8LjHv7Qtt5J1SxJouiwvJVvAS9WgzWbcnoWEeQw@mail.gmail.com>
Date: Wed, 10 Jan 2018 19:41:19 +0200
Message-Id: <25EE894A-E894-4C80-9B5B-A8A2B2763662@lightbitslabs.com>
References: <CAN=ZobSmQ97gRKFaho7DPvXVD18W4145JfTQ5Ncf80Tw17fkGA@mail.gmail.com>
 <20171020162227.GA8576@linux.intel.com>
 <CAN=ZobRsTqFtLiibVDU=yoNPSSgd7S=DaM=p2JTWcBm9x2PjsA@mail.gmail.com>
 <CAPcyv4ifUJUJFKksk0atmfeMiOJoQRPzYU9Z633i0Cj8pjpD6A@mail.gmail.com>
 <CAN=ZobTYOgWxPbLcH275EK4PkoniMk+1g1HehxoXLp1bqUN9Bg@mail.gmail.com>
 <CAA9_cmff4YFQnP+1csz2Z_=dKcQeW5jYFC2QLcN9V4j1FV+zyA@mail.gmail.com>
 <CAN=ZobSKm8isvTEALkd_-X7Hyjbv6tH-Yy0UGtOTkn2_fKoqhA@mail.gmail.com>
 <CAA9_cmes_Strpx6jNYDOnxZ0DUENFpWOpL-65jvpv3ztQwB74Q@mail.gmail.com>
 <CACTTzNa06a4ZM6tkYesqf-19WfcSuJovD-AWKC8-obVp_cTOPQ@mail.gmail.com>
 <CAN=ZobTrcu9LALChbB2HT1Fw_aAnDLGotU0Uo8uhewf5c3E+UA@mail.gmail.com>
 <CAPcyv4iyoWkG1MLtJ8cKN=yoav7Wstck5sJdeJhjxGeLPCRn6w@mail.gmail.com>
 <CAN=ZobRRj2ccifvwvkTPs_MwcbEK8ncYA_ydX8+Ar8gQpYu_oA@mail.gmail.com>
 <CAN=ZobT3V_cfLGKaLyfrhUthtW6xqE5EJ1=1u3o4RvdM4fOd5w@mail.gmail.com>
 <CAA9_cmcr+7DhH3mSPRvCtyVK6F31GGmvkq8nEi1sNzchmK70qw@mail.gmail.com>
 <CAN=ZobQyy3taNhB_sXjeeUdWx0xP1aL3icr5_+ANFmBH+4Ge5A@mail.gmail.com>
 <CAPcyv4hOqiq8LjHv7Qtt5J1SxJouiwvJVvAS9WgzWbcnoWEeQw@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

SGkKVGhhbmtzIGZvciB5b3VyIGFuc3dlcgpJZiB3ZSBkbyBtZW1yZW1hcCBvbiB0aGUgcGh5c2lj
YWwgYWRkcmVzcwpPZiB0aGUgbnZyYW0gZnJvbSB3aXRoaW4gdGhlIGtlcm5lbCB0byBnZXQgYSBu
ZXcgdmlydHVhbCBhZGRyZXNzIG1hcHBpbmcgd2lsbCBpdCBsb2NrIHRoZSBtYXBwaW5nPwpDYW4g
dGhpcyBiZSBhbHNvIGEgd29ya2Fyb3VuZD8KT3JlbgoK16DXqdec15cg157XlC1pUGhvbmUg16nX
nNeZCgrigKvXkS0xMCDXkdeZ16DXldezIDIwMTgsINeR16nXoteUIDE4OjM4LCDigI/igI9EYW4g
V2lsbGlhbXMg4oCPPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4g15vXqteRL9eUOuKArAoKPj4g
T24gV2VkLCBKYW4gMTAsIDIwMTggYXQgNzoyMyBBTSwgT3JlbiBCZXJtYW4gPG9yZW5AbGlnaHRi
aXRzbGFicy5jb20+IHdyb3RlOgo+PiBOb3cgdG8gYWxsIG9mIHRoZSBmb3J1bQo+PiAKPj4gSGkg
RGFuCj4+IAo+PiBUaGFua3Mgd2UgYXJlIGdvaW5nIHRvIHRyeSB0aGlzLgo+PiAKPj4gQ2FuIHlv
dSBleHBsYWluIHdoeSB0aGlzIGNhbiBjYXVzZSB0aGlzIGlzc3VlIC0gaXMgdGhlIE5WRElNTSBt
ZW1vcnkgc3BhY2UKPj4gYWxzbyBiZWluZyByYW5kb21pemVkPwo+PiBJcyBpdCBkb25lIGR1cmlu
ZyBydW50aW1lPwo+PiAKPiAKPiBZZXMsIGthc2xyIHJhbmRvbWl6ZXMgdGhlIGRpcmVjdCBtYXAu
IFdlIGhhdmUgc2VlbiBwcm9ibGVtcyB3aXRoIGl0IGluCj4gdGhlIHBhc3QgcmVsYXRpdmUgdG8g
c2V0dGluZyB1cCBwbWVtIG1hcHBpbmdzLiBXZSBmaXhlZCBvbmUgc3VjaCBidWcKPiB3aXRoIHRo
aXMgY29tbWl0Ogo+IAo+IGZjNWY5ZDVmMTUxYyB4ODYvbW06IEZpeCBib290IGNyYXNoIGNhdXNl
ZCBieSBpbmNvcnJlY3QgbG9vcCBjb3VudAo+IGNhbGN1bGF0aW9uIGluIHN5bmNfZ2xvYmFsX3Bn
ZHMoKQo+IAo+IC4uLmJ1dCBpdCBhcHBlYXJzIHdlIG1heSBoYXZlIGFub3RoZXIgYnVnIGluIHRo
aXMgYXJlYS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
