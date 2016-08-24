Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47B0D1A1E27
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 22:48:48 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id c15so9150973oig.0
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 22:48:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g1ULSDXzp5ufpXzp5JB3z1TN_za=_AqUC8E6f2FNsycw@mail.gmail.com>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4g8y4P02wm6Fx5Cx1zX6_xysdYg7jG6jjz6GTX7KqCkvA@mail.gmail.com>
 <1471996023.1532.6.camel@hpe.com>
 <CAPcyv4gJtTj8chX_eTNhs1PJ=D3X7USuDXwFSWSEZt1cUAXpUw@mail.gmail.com>
 <CS1PR84MB0005F40F71804F3988DD23CB82EA0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4jH+R0vPyMvDhNmrQ-DjvMe_KW9SxPoQCdX8Zbgd3KESA@mail.gmail.com>
 <CAPcyv4g1ULSDXzp5ufpXzp5JB3z1TN_za=_AqUC8E6f2FNsycw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 22:48:46 -0700
Message-ID: <CAPcyv4iuSvx0kYLOaBXP57M-AgStubGg08Td7s_08G=cZTYWdw@mail.gmail.com>
Subject: Re: [PATCH] memremap: Fix NULL pointer BUG in get_zone_device_page()
Content-Type: multipart/mixed; boundary=001a1140ab38bf2034053acad52a
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

--001a1140ab38bf2034053acad52a
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 23, 2016 at 8:58 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Aug 23, 2016 at 7:53 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Tue, Aug 23, 2016 at 6:29 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>>>> On Tue, Aug 23, 2016 at 4:47 PM, Kani, Toshimitsu <toshi.kani@hpe.com>
>>>> wrote:
>>>> > On Tue, 2016-08-23 at 15:32 -0700, Dan Williams wrote:
>>>> >> On Tue, Aug 23, 2016 at 11:43 AM, Toshi Kani <toshi.kani@hpe.com>
>>>> >> wrote:
>>>> >  :
>>>> >> I'm not sure about this fix.  The point of honoring
>>>> >> vmem_altmap_offset() is because a portion of the resource that is
>>>> >> passed to devm_memremap_pages() also contains the metadata info
>>>> block
>>>> >> for the device.  The offset says "use everything past this point for
>>>> >> pages".  This may work for avoiding a crash, but it may corrupt info
>>>> >> block metadata in the process.  Can you provide more information
>>>> >> about the failing scenario to be sure that we are not triggering a
>>>> >> fault on an address that is not meant to have a page mapping?  I.e.
>>>> >> what is the host physical address of the page that caused this fault,
>>>> >> and is it valid?
>>>> >
>>>> > The fault address in question was the 2nd page of an NVDIMM range.  I
>>>> > assumed this fault address was valid and needed to be handled.  Here is
>>>> > some info about the base and patched cases.  Let me know if you need
>>>> > more info.
>>>> >
>>>> > Base
>>>> > ====
>>>> >
>>>> > The following NVDIMM range was set to /dev/dax.
>>>>
>>>> With ndctl create-namespace or manually via sysfs?  Specifically I'm
>>>> looking for what the 'align' attribute was set to when the
>>>> configuration was established.  Can you provide a dump of the sysfs
>>>> attributes for the /dev/dax parent device?
>>>
>>> I used the ndctl command below.
>>> ndctl create-namespace -f -e namespace0.0 -m dax
>>>
>>> Here is additional info from my note for the base case.
>>>
>>> p {struct dev_pagemap} 0xffff88046d0453f0
>>> $3 = {
>>>   altmap = 0xffff88046d045410,
>>>   res = 0xffff88046d0453a8,
>>>   ref = 0xffff88046d0452f0,
>>>   dev = 0xffff880464790410
>>> }
>>>
>>> crash> p {struct vmem_altmap} 0xffff88046d045410
>>> $6 = {
>>>   base_pfn = 0x480000,
>>>   reserve = 0x2,        // PHYS_PFN(SZ_8K)
>>>   free = 0x101fe,
>>>   align = 0x1fe,
>>>   alloc = 0x10000
>>> }
>>
>> Ah, so, on second look the 0x490200000 data offset looks correct.  The
>> total size of the address range is 16GB which equates to 256MB needed
>> for struct page, plus 2MB more to re-align the data on the next 2MB
>> boundary.
>>
>> The question now is why is the guest faulting on an access to an
>> address less than 0x490200000?
>
> Does the attached patch fix this for you?

Sorry, should be this much simpler patch that also mirrors what
driver/nvdimm/pmem.c is doing...

--001a1140ab38bf2034053acad52a
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-dax-fix-device-dax-region-base.patch"
Content-Disposition: attachment;
	filename="0001-dax-fix-device-dax-region-base.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_is8hc5hz1

RnJvbSAzMzY5ZjBlODI1YzEyYmIyZjE3YzBmN2QzY2NlY2I3YzYwZjY0NWUwIE1vbiBTZXAgMTcg
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
bGxpYW1zQGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL2RheC9wbWVtLmMgfCAzICsrKwogMSBmaWxl
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZGF4L3BtZW0u
YyBiL2RyaXZlcnMvZGF4L3BtZW0uYwppbmRleCBkZmIxNjg1NjhhZjEuLjFmMDFlOThjODNjNyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9kYXgvcG1lbS5jCisrKyBiL2RyaXZlcnMvZGF4L3BtZW0uYwpA
QCAtMTE2LDYgKzExNiw5IEBAIHN0YXRpYyBpbnQgZGF4X3BtZW1fcHJvYmUoc3RydWN0IGRldmlj
ZSAqZGV2KQogCWlmIChyYykKIAkJcmV0dXJuIHJjOwogCisJLyogYWRqdXN0IHRoZSBkYXhfcmVn
aW9uIHJlc291cmNlIHRvIHRoZSBzdGFydCBvZiBkYXRhICovCisJcmVzLnN0YXJ0ICs9IGxlNjRf
dG9fY3B1KHBmbl9zYi0+ZGF0YW9mZik7CisKIAluZF9yZWdpb24gPSB0b19uZF9yZWdpb24oZGV2
LT5wYXJlbnQpOwogCWRheF9yZWdpb24gPSBhbGxvY19kYXhfcmVnaW9uKGRldiwgbmRfcmVnaW9u
LT5pZCwgJnJlcywKIAkJCWxlMzJfdG9fY3B1KHBmbl9zYi0+YWxpZ24pLCBhZGRyLCBQRk5fREVW
fFBGTl9NQVApOwotLSAKMi41LjUKCg==
--001a1140ab38bf2034053acad52a
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--001a1140ab38bf2034053acad52a--
