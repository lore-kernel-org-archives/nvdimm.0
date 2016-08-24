Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0AC41A1E27
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 20:58:13 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id c15so6697046oig.0
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 20:58:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jH+R0vPyMvDhNmrQ-DjvMe_KW9SxPoQCdX8Zbgd3KESA@mail.gmail.com>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4g8y4P02wm6Fx5Cx1zX6_xysdYg7jG6jjz6GTX7KqCkvA@mail.gmail.com>
 <1471996023.1532.6.camel@hpe.com>
 <CAPcyv4gJtTj8chX_eTNhs1PJ=D3X7USuDXwFSWSEZt1cUAXpUw@mail.gmail.com>
 <CS1PR84MB0005F40F71804F3988DD23CB82EA0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4jH+R0vPyMvDhNmrQ-DjvMe_KW9SxPoQCdX8Zbgd3KESA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 20:58:12 -0700
Message-ID: <CAPcyv4g1ULSDXzp5ufpXzp5JB3z1TN_za=_AqUC8E6f2FNsycw@mail.gmail.com>
Subject: Re: [PATCH] memremap: Fix NULL pointer BUG in get_zone_device_page()
Content-Type: multipart/mixed; boundary=001a1141f5344d4e48053ac94a28
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "Mulumudi, Abhilash Kumar  <m.abhilash-kumar@hpe.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brian.starkey@arm.com" <brian.starkey@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

--001a1141f5344d4e48053ac94a28
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 23, 2016 at 7:53 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Aug 23, 2016 at 6:29 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>>> On Tue, Aug 23, 2016 at 4:47 PM, Kani, Toshimitsu <toshi.kani@hpe.com>
>>> wrote:
>>> > On Tue, 2016-08-23 at 15:32 -0700, Dan Williams wrote:
>>> >> On Tue, Aug 23, 2016 at 11:43 AM, Toshi Kani <toshi.kani@hpe.com>
>>> >> wrote:
>>> >  :
>>> >> I'm not sure about this fix.  The point of honoring
>>> >> vmem_altmap_offset() is because a portion of the resource that is
>>> >> passed to devm_memremap_pages() also contains the metadata info
>>> block
>>> >> for the device.  The offset says "use everything past this point for
>>> >> pages".  This may work for avoiding a crash, but it may corrupt info
>>> >> block metadata in the process.  Can you provide more information
>>> >> about the failing scenario to be sure that we are not triggering a
>>> >> fault on an address that is not meant to have a page mapping?  I.e.
>>> >> what is the host physical address of the page that caused this fault,
>>> >> and is it valid?
>>> >
>>> > The fault address in question was the 2nd page of an NVDIMM range.  I
>>> > assumed this fault address was valid and needed to be handled.  Here is
>>> > some info about the base and patched cases.  Let me know if you need
>>> > more info.
>>> >
>>> > Base
>>> > ====
>>> >
>>> > The following NVDIMM range was set to /dev/dax.
>>>
>>> With ndctl create-namespace or manually via sysfs?  Specifically I'm
>>> looking for what the 'align' attribute was set to when the
>>> configuration was established.  Can you provide a dump of the sysfs
>>> attributes for the /dev/dax parent device?
>>
>> I used the ndctl command below.
>> ndctl create-namespace -f -e namespace0.0 -m dax
>>
>> Here is additional info from my note for the base case.
>>
>> p {struct dev_pagemap} 0xffff88046d0453f0
>> $3 = {
>>   altmap = 0xffff88046d045410,
>>   res = 0xffff88046d0453a8,
>>   ref = 0xffff88046d0452f0,
>>   dev = 0xffff880464790410
>> }
>>
>> crash> p {struct vmem_altmap} 0xffff88046d045410
>> $6 = {
>>   base_pfn = 0x480000,
>>   reserve = 0x2,        // PHYS_PFN(SZ_8K)
>>   free = 0x101fe,
>>   align = 0x1fe,
>>   alloc = 0x10000
>> }
>
> Ah, so, on second look the 0x490200000 data offset looks correct.  The
> total size of the address range is 16GB which equates to 256MB needed
> for struct page, plus 2MB more to re-align the data on the next 2MB
> boundary.
>
> The question now is why is the guest faulting on an access to an
> address less than 0x490200000?

Does the attached patch fix this for you?

--001a1141f5344d4e48053ac94a28
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-dax-fix-device-dax-region-base.patch"
Content-Disposition: attachment;
	filename="0001-dax-fix-device-dax-region-base.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_is8de6mu0

RnJvbSA1MDZjZGQyYzRlYzBmOTI4M2FjNGViOTIyNTlmMmU4YTcxYzViNjM3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNv
bT4KRGF0ZTogVHVlLCAyMyBBdWcgMjAxNiAxOTo1OTozMSAtMDcwMApTdWJqZWN0OiBbUEFUQ0hd
IGRheDogZml4IGRldmljZS1kYXggcmVnaW9uIGJhc2UKClRoZSBkYXRhIG9mZnNldCBmb3IgYSBk
YXggcmVnaW9uIG5lZWRzIHRvIGFjY291bnQgZm9yIGFuIGFsdG1hcApyZXNlcnZhdGlvbiBpbiB0
aGUgcmVzb3VyY2UgcmFuZ2UuICBPdGhlcndpc2UsIGRldmljZS1kYXggaXMgYWxsb3dpbmcKbWFw
cGluZ3MgZGlyZWN0bHkgaW50byB0aGUgbWVtbWFwIG9yIGRldmljZSBpbmZvLWJsb2NrIGFyZWEs
IHdpdGggY3Jhc2gKc2lnbmF0dXJlcyBsaWtlIHRoZSBmb2xsb3dpbmc6CgogQlVHOiB1bmFibGUg
dG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMDAwMDAw
MDAwOAogSVA6IFs8ZmZmZmZmZmY4MTFhYzg1MT5dIGdldF96b25lX2RldmljZV9wYWdlKzB4MTEv
MHgzMAogQ2FsbCBUcmFjZToKICAgZm9sbG93X2Rldm1hcF9wbWQrMHgyOTgvMHgyYzAKICAgZm9s
bG93X3BhZ2VfbWFzaysweDI3NS8weDUzMAogICBfX2dldF91c2VyX3BhZ2VzKzB4ZTMvMHg3NTAK
ICAgX19nZm5fdG9fcGZuX21lbXNsb3QrMHgxYjIvMHg0NTAgW2t2bV0KICAgPyBocnRpbWVyX3Ry
eV90b19jYW5jZWwrMHgyYy8weDEyMAogICA/IGt2bV9yZWFkX2wxX3RzYysweDU1LzB4NjAgW2t2
bV0KICAgdHJ5X2FzeW5jX3BmKzB4NjYvMHgyMzAgW2t2bV0KICAgPyBrdm1faG9zdF9wYWdlX3Np
emUrMHg5MC8weGEwIFtrdm1dCiAgIHRkcF9wYWdlX2ZhdWx0KzB4MTMwLzB4MjgwIFtrdm1dCiAg
IGt2bV9tbXVfcGFnZV9mYXVsdCsweDVmLzB4ZjAgW2t2bV0KICAgaGFuZGxlX2VwdF92aW9sYXRp
b24rMHg5NC8weDE4MCBba3ZtX2ludGVsXQogICB2bXhfaGFuZGxlX2V4aXQrMHgxZDMvMHgxNDQw
IFtrdm1faW50ZWxdCiAgID8gYXRvbWljX3N3aXRjaF9wZXJmX21zcnMrMHg2Zi8weGEwIFtrdm1f
aW50ZWxdCiAgID8gdm14X3ZjcHVfcnVuKzB4MmQxLzB4NDkwIFtrdm1faW50ZWxdCiAgIGt2bV9h
cmNoX3ZjcHVfaW9jdGxfcnVuKzB4ODFkLzB4MTZhMCBba3ZtXQogICA/IHdha2VfdXBfcSsweDQ0
LzB4ODAKICAga3ZtX3ZjcHVfaW9jdGwrMHgzM2MvMHg2MjAgW2t2bV0KICAgPyBfX3Zmc193cml0
ZSsweDM3LzB4MTYwCiAgIGRvX3Zmc19pb2N0bCsweGEyLzB4NWQwCiAgIFN5U19pb2N0bCsweDc5
LzB4OTAKICAgZW50cnlfU1lTQ0FMTF82NF9mYXN0cGF0aCsweDFhLzB4YTQKCkNjOiA8c3RhYmxl
QHZnZXIua2VybmVsLm9yZz4KQ2M6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlv
bi5vcmc+CkZpeGVzOiBhYjY4ZjI2MjIxMzYgKCIvZGV2L2RheCwgcG1lbTogZGlyZWN0IGFjY2Vz
cyB0byBwZXJzaXN0ZW50IG1lbW9yeSIpClJlcG9ydGVkLWJ5OiBBYmhpbGFzaCBLdW1hciBNdWx1
bXVkaSA8bS5hYmhpbGFzaC1rdW1hckBocGUuY29tPgpSZXBvcnRlZC1ieTogVG9zaGkgS2FuaSA8
dG9zaGkua2FuaUBocGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndp
bGxpYW1zQGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL2RheC9wbWVtLmMgICAgICAgfCAyICsrCiBp
bmNsdWRlL2xpbnV4L21lbXJlbWFwLmggfCAxICsKIGtlcm5lbC9tZW1yZW1hcC5jICAgICAgICB8
IDkgKysrKysrKysrCiAzIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2RheC9wbWVtLmMgYi9kcml2ZXJzL2RheC9wbWVtLmMKaW5kZXggZGZiMTY4
NTY4YWYxLi4wNjAzNjM3ZGYxNjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZGF4L3BtZW0uYworKysg
Yi9kcml2ZXJzL2RheC9wbWVtLmMKQEAgLTExNiw2ICsxMTYsOCBAQCBzdGF0aWMgaW50IGRheF9w
bWVtX3Byb2JlKHN0cnVjdCBkZXZpY2UgKmRldikKIAlpZiAocmMpCiAJCXJldHVybiByYzsKIAor
CXJlcy5zdGFydCArPSB2bWVtX2FsdG1hcF9yZXNvdXJjZV9vZmZzZXQoYWx0bWFwKTsKKwogCW5k
X3JlZ2lvbiA9IHRvX25kX3JlZ2lvbihkZXYtPnBhcmVudCk7CiAJZGF4X3JlZ2lvbiA9IGFsbG9j
X2RheF9yZWdpb24oZGV2LCBuZF9yZWdpb24tPmlkLCAmcmVzLAogCQkJbGUzMl90b19jcHUocGZu
X3NiLT5hbGlnbiksIGFkZHIsIFBGTl9ERVZ8UEZOX01BUCk7CmRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L21lbXJlbWFwLmggYi9pbmNsdWRlL2xpbnV4L21lbXJlbWFwLmgKaW5kZXggOTM0MTYx
OTZiYTY0Li43MjY1YjgzY2RiZWEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbWVtcmVtYXAu
aAorKysgYi9pbmNsdWRlL2xpbnV4L21lbXJlbWFwLmgKQEAgLTI0LDYgKzI0LDcgQEAgc3RydWN0
IHZtZW1fYWx0bWFwIHsKIH07CiAKIHVuc2lnbmVkIGxvbmcgdm1lbV9hbHRtYXBfb2Zmc2V0KHN0
cnVjdCB2bWVtX2FsdG1hcCAqYWx0bWFwKTsKK3Jlc291cmNlX3NpemVfdCB2bWVtX2FsdG1hcF9y
ZXNvdXJjZV9vZmZzZXQoc3RydWN0IHZtZW1fYWx0bWFwICphbHRtYXApOwogdm9pZCB2bWVtX2Fs
dG1hcF9mcmVlKHN0cnVjdCB2bWVtX2FsdG1hcCAqYWx0bWFwLCB1bnNpZ25lZCBsb25nIG5yX3Bm
bnMpOwogCiAjaWZkZWYgQ09ORklHX1pPTkVfREVWSUNFCmRpZmYgLS1naXQgYS9rZXJuZWwvbWVt
cmVtYXAuYyBiL2tlcm5lbC9tZW1yZW1hcC5jCmluZGV4IDI1MWQxNmI0Y2I0MS4uOTQxZTg5N2M1
MmE4IDEwMDY0NAotLS0gYS9rZXJuZWwvbWVtcmVtYXAuYworKysgYi9rZXJuZWwvbWVtcmVtYXAu
YwpAQCAtMzg0LDYgKzM4NCwxNSBAQCB1bnNpZ25lZCBsb25nIHZtZW1fYWx0bWFwX29mZnNldChz
dHJ1Y3Qgdm1lbV9hbHRtYXAgKmFsdG1hcCkKIAlyZXR1cm4gYWx0bWFwLT5yZXNlcnZlICsgYWx0
bWFwLT5mcmVlOwogfQogCityZXNvdXJjZV9zaXplX3Qgdm1lbV9hbHRtYXBfcmVzb3VyY2Vfb2Zm
c2V0KHN0cnVjdCB2bWVtX2FsdG1hcCAqYWx0bWFwKQoreworCS8qIG51bWJlciBvZiBieXRlcyBm
cm9tIGJhc2Ugd2hlcmUgZGF0YSBzdGFydHMgYWZ0ZXIgdGhlIG1lbW1hcCAqLworCWlmICghYWx0
bWFwKQorCQlyZXR1cm4gMDsKKwlyZXR1cm4gdm1lbV9hbHRtYXBfb2Zmc2V0KGFsdG1hcCkgKiBQ
QUdFX1NJWkU7Cit9CitFWFBPUlRfU1lNQk9MX0dQTCh2bWVtX2FsdG1hcF9yZXNvdXJjZV9vZmZz
ZXQpOworCiB2b2lkIHZtZW1fYWx0bWFwX2ZyZWUoc3RydWN0IHZtZW1fYWx0bWFwICphbHRtYXAs
IHVuc2lnbmVkIGxvbmcgbnJfcGZucykKIHsKIAlhbHRtYXAtPmFsbG9jIC09IG5yX3BmbnM7Ci0t
IAoyLjUuNQoK
--001a1141f5344d4e48053ac94a28
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--001a1141f5344d4e48053ac94a28--
