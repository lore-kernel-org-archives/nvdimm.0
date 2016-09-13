Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7172A1A1DF1
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 19:50:23 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id d191so138448058oih.2
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 19:50:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC1QiQHNz7sgf=GcCmqLE-VQT4BxmD0M-XSaQqKL-ADqRt4pcg@mail.gmail.com>
References: <CAC1QiQHNz7sgf=GcCmqLE-VQT4BxmD0M-XSaQqKL-ADqRt4pcg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Sep 2016 19:50:22 -0700
Message-ID: <CAPcyv4jcJTWBzfTO5tamm1YxXrjvCyytR2cL00cwLpzZcK-gHg@mail.gmail.com>
Subject: Re: Panic when insmod nfit_test.ko
Content-Type: multipart/mixed; boundary=001a11392fbe869861053c5aacdc
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: ryan chen <ryan.chan105@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

--001a11392fbe869861053c5aacdc
Content-Type: text/plain; charset=UTF-8

On Mon, Sep 12, 2016 at 7:30 PM, ryan chen <ryan.chan105@gmail.com> wrote:
> Hi all,
> Recently I'm trying to check the testing suite of nfit_test for nvdimm
> on 4.8-rc5, and system got panic once insmod nfit_test.ko ,
> I've checked the RIP, I guess it panics due to NULL
> nvdimm_map pointer, i.e., accessing nvdimm_map->mem,
> so I have a question that, should we check the return value of
> alloc_nvdimm_map if it failed:
>
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -171,6 +171,9 @@ void *devm_nvdimm_memremap(struct device *dev,
> resource_size_t offset,
>                 kref_get(&nvdimm_map->kref);
>         nvdimm_bus_unlock(dev);
>
> +       if (!nvdimm_map)
> +               return NULL;
> +
>         if (devm_add_action_or_reset(dev, nvdimm_map_put, nvdimm_map))
>                 return NULL;
> But why we got NULL nvdimm_map is still unknown,
> please let me know if you need any information. Thanks.

Thanks for the report.  We do need to check if alloc_nvdimm_map fails.
My guess as to why it is failing the call to request_mem_region().
Can you try the attached patch, and send the kernel log as well as the
contents of /proc/iomem?

--001a11392fbe869861053c5aacdc
Content-Type: text/x-patch; charset=US-ASCII; name="libnvdimm-fix.patch"
Content-Disposition: attachment; filename="libnvdimm-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_it0vs0vw0

bGlibnZkaW1tOiBmaXggZGV2bV9udmRpbW1fbWVtcmVtYXAoKSBlcnJvciBwYXRoCgpGcm9tOiBE
YW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KClRoZSBpbnRlcm5hbCBhbGxv
Y19udmRpbW1fbWFwKCkgaGVscGVyIG1pZ2h0IGZpbGUsIHBhcnRpY3VsYXJseSBpZiB0aGUKbWVt
b3J5IHJlZ2lvbiBpcyBhbHJlYWR5IGJ1c3kuICBSZXBvcnQgcmVxdWVzdF9tZW1fcmVnaW9uKCkg
ZmFpbHVyZXMgYW5kCmNoZWNrIGZvciB0aGUgZmFpbHVyZS4KClJlcG9ydGVkLWJ5OiBSeWFuIENo
ZW4gPHJ5YW4uY2hhbjEwNUBnbWFpbC5jb20+ClNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8
ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMvbnZkaW1tL2NvcmUuYyB8ICAg
IDggKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL252ZGltbS9jb3JlLmMgYi9kcml2ZXJzL252ZGltbS9j
b3JlLmMKaW5kZXggNzE1NTgzZjY5ZDI4Li4xNDA2NmFkZDIwZjAgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbnZkaW1tL2NvcmUuYworKysgYi9kcml2ZXJzL252ZGltbS9jb3JlLmMKQEAgLTk5LDggKzk5
LDExIEBAIHN0YXRpYyBzdHJ1Y3QgbnZkaW1tX21hcCAqYWxsb2NfbnZkaW1tX21hcChzdHJ1Y3Qg
ZGV2aWNlICpkZXYsCiAJbnZkaW1tX21hcC0+c2l6ZSA9IHNpemU7CiAJa3JlZl9pbml0KCZudmRp
bW1fbWFwLT5rcmVmKTsKIAotCWlmICghcmVxdWVzdF9tZW1fcmVnaW9uKG9mZnNldCwgc2l6ZSwg
ZGV2X25hbWUoJm52ZGltbV9idXMtPmRldikpKQorCWlmICghcmVxdWVzdF9tZW1fcmVnaW9uKG9m
ZnNldCwgc2l6ZSwgZGV2X25hbWUoJm52ZGltbV9idXMtPmRldikpKSB7CisJCWRldl9lcnIoJm52
ZGltbV9idXMtPmRldiwgImZhaWxlZCB0byByZXF1ZXN0ICVwYSArICVsZCBmb3IgJXNcbiIsCisJ
CQkJJm9mZnNldCwgc2l6ZSwgZGV2X25hbWUoZGV2KSk7CiAJCWdvdG8gZXJyX3JlcXVlc3RfcmVn
aW9uOworCX0KIAogCWlmIChmbGFncykKIAkJbnZkaW1tX21hcC0+bWVtID0gbWVtcmVtYXAob2Zm
c2V0LCBzaXplLCBmbGFncyk7CkBAIC0xNzEsNiArMTc0LDkgQEAgdm9pZCAqZGV2bV9udmRpbW1f
bWVtcmVtYXAoc3RydWN0IGRldmljZSAqZGV2LCByZXNvdXJjZV9zaXplX3Qgb2Zmc2V0LAogCQlr
cmVmX2dldCgmbnZkaW1tX21hcC0+a3JlZik7CiAJbnZkaW1tX2J1c191bmxvY2soZGV2KTsKIAor
CWlmICghbnZkaW1tX21hcCkKKwkJcmV0dXJuIE5VTEw7CisKIAlpZiAoZGV2bV9hZGRfYWN0aW9u
X29yX3Jlc2V0KGRldiwgbnZkaW1tX21hcF9wdXQsIG52ZGltbV9tYXApKQogCQlyZXR1cm4gTlVM
TDsKIAo=
--001a11392fbe869861053c5aacdc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--001a11392fbe869861053c5aacdc--
