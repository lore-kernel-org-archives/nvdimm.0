Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44EE7208AE2C8
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 05:28:35 -0800 (PST)
Subject: Re: [PATCH] acpi/nfit: Fix bus command validation
From: Johannes Thumshirn <jthumshirn@suse.de>
References: <154958385172.3932544.193235520333886200.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49lg2bql2v.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iiZS_zfroRtmS-zD-cCDj1yQonBsWM23utR9m9kiBizA@mail.gmail.com>
 <b1f73551-5c11-3651-dc6f-5cdcf815e0d0@suse.de>
 <CAPcyv4hZXJbrLc9f3xsOTPs_RYVH9vhuxSxHj-4L56ZNi+ZRZg@mail.gmail.com>
 <fcbf4a2c-a4c4-556e-f2dc-c22663997de5@suse.de>
Message-ID: <cb6d55e7-8544-ce28-55e5-f4c0361a256f@suse.de>
Date: Thu, 21 Feb 2019 14:28:32 +0100
MIME-Version: 1.0
In-Reply-To: <fcbf4a2c-a4c4-556e-f2dc-c22663997de5@suse.de>
Content-Type: multipart/mixed; boundary="------------892760BAE4EE405FB98D14F6"
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Vishal Verma <vishal.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

This is a multi-part message in MIME format.
--------------892760BAE4EE405FB98D14F6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

[+CC dvyukov ]

On 20/02/2019 18:21, Johannes Thumshirn wrote:
> On 20/02/2019 17:15, Dan Williams wrote:> I wouldn't be opposed to
> syzkaller fuzzing the nvdimm-ioctl path.
> As a heads up, I've started adding the ioctl() definitions to syzcaller.
> Just so we don't duplicate any efforts.

So AFAICS this (see attachment) should do the trick.

@dvyukov is there something I'm missing, or can syzkaller pick up the
/dev/ndctl devices and start fuzzing the ioctl path with this?

Thanks,
	Johannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--------------892760BAE4EE405FB98D14F6
Content-Type: text/plain; charset=UTF-8;
 name="dev_ndctl.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dev_ndctl.txt"

IyBDb3B5cmlnaHQgMjAxOSBzeXprYWxsZXIgcHJvamVjdCBhdXRob3JzLiBBbGwgcmlnaHRz
IHJlc2VydmVkLgojIFVzZSBvZiB0aGlzIHNvdXJjZSBjb2RlIGlzIGdvdmVybmVkIGJ5IEFw
YWNoZSAyIExJQ0VOU0UgdGhhdCBjYW4gYmUgZm91bmQgaW4gdGhlIExJQ0VOU0UgZmlsZS4K
CiNpbmNsdWRlIDxhc20vaW9jdGwuaD4KI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CiNpbmNs
dWRlIDx1YXBpL2xpbnV4L25kY3RsLmg+CgpyZXNvdXJjZSBmZF9uZGN0bFtmZF0KCnN5el9v
cGVuX2RldiRuZGN0bChkZXYgcHRyW2luLCBzdHJpbmdbIi9kZXYvbmRjdGwjIl1dLCBpZCBp
bnRwdHIsIGZsYWdzIGZsYWdzW29wZW5fZmxhZ3NdKSBmZF9uZGN0bAoKaW9jdGwkTkRfSU9D
VExfRElNTV9GTEFHUyhmZCBmZF9uZGN0bCwgY21kIGNvbnN0W05EX0lPQ1RMX0RJTU1fRkxB
R1NdLCBhcmcgcHRyW2luLCBuZF9jbWRfZGltbV9mbGFnc10pCmlvY3RsJE5EX0lPQ1RMX0dF
VF9DT05GSUdfU0laRShmZCBmZF9uZGN0bCwgY21kIGNvbnN0W05EX0lPQ1RMX0dFVF9DT05G
SUdfU0laRV0sIGFyZyBwdHJbaW4sIG5kX2NtZF9nZXRfY29uZmlnX3NpemVdKQppb2N0bCRO
RF9JT0NUTF9HRVRfQ09ORklHX0RBVEEoZmQgZmRfbmRjdGwsIGNtZCBjb25zdFtORF9JT0NU
TF9HRVRfQ09ORklHX0RBVF0sIGFyZyBwdHJbaW4sIG5kX2NtZF9nZXRfY29uZmlnX2RhdGFf
aGRyXSkKaW9jdGwkTkRfSU9DVExfU0VUX0NPTkZJR19EQVRBKGZkIGZkX25kY3RsLCBjbWQg
Y29uc3RbTkRfSU9DVExfU0VUX0NPTkZJR19EQVRBXSwgYXJnIHB0cltpbiwgbmRfY21kX3Nl
dF9jb25maWdfaGRyXSkKaW9jdGwkTkRfSU9DVExfVkVORE9SKGZkIGZkX25kY3RsLCBjbWQg
Y29uc3RbTkRfSU9DVExfVkVORE9SXSwgYXJnIHB0cltpbiwgbmRfY21kX3ZlbmRvcl9oZHJd
KQoKaW9jdGwkTkRfSU9DVExfQVJTX0NBUChmZCBmZF9uZGN0bCwgY21kIGNvbnN0W05EX0lP
Q1RMX0FSU19DQVBdLCBhcmcgcHRyW2luLCBuZF9jbWRfYXJzX2NhcF0pCmlvY3RsJE5EX0lP
Q1RMX0FSU19TVEFSVChmZCBmZF9uZGN0bCwgY21kIGNvbnN0W05EX0lPQ1RMX0FSU19TVEFS
VF0sIGFyZyBwdHJbaW4sIG5kX2NtZF9hcnNfc3RhcnRdKQppb2N0bCRORF9JT0NUTF9BUlNf
U1RBVFVTKGZkIGZkX25kY3RsLCBjbWQgY29uc3RbTkRfSU9DVExfQVJTX1NUQVRVU10sIGFy
ZyBwdHJbaW4sIG5kX2NtZF9hcnNfc3RhdHVzXSkKaW9jdGwkTkRfSU9DVExfQ0xFQVJfRVJS
T1IoZmQgZmRfbmRjdGwsIGNtZCBjb25zdFtORF9JT0NUTF9DTEVBUl9FUlJPUl0sIGFyZyBw
dHJbaW4sIG5kX2NtZF9jbGVhcl9lcnJvcl0pCmlvY3RsJE5EX0lPQ1RMX0NBTEwoZmQgZmRf
bmRjdGwsIGNtZCBjb25zdFtORF9JT0NUTF9DQUxMXSwgYXJnIHB0cltpbiwgbmRfY21kX3Br
Z10pCgpuZF9jbWRfZGltbV9mbGFncyB7CglzdGF0dXMJaW50MzIKCWZsYWdzCWludDMyCn0g
W3BhY2tlZF0KCm5kX2NtZF9nZXRfY29uZmlnX3NpemUgewoJc3RhdHVzCQlpbnQzMgoJY29u
ZmlnX3NpemUJaW50MzIKCW1heF94ZmVyCWludDMyCn0gW3BhY2tlZF0KCm5kX2NtZF9nZXRf
Y29uZmlnX2RhdGFfaGRyIHsKCWluX29mZnNldAlpbnQzMgoJaW5fbGVuZ3RoCWxlbltvdXRf
YnVmLCBpbnQzMl0KCXN0YXR1cwkJaW50MzIKCW91dF9idWYJCXB0cltvdXQsIGFycmF5W2lu
dDhdCn0gW3BhY2tlZF0KCnN0cnVjdCBuZF9jbWRfc2V0X2NvbmZpZ19oZHIgewoJaW5fb2Zm
c2V0CWludDMyCglpbl9sZW5ndGgJbGVuW2luX2J1ZiwgaW50MzJdCglpbl9idWYJCXB0cltp
biwgYXJyYXlbaW50OF0KfSBbcGFja2VkXQoKc3RydWN0IG5kX2NtZF92ZW5kb3JfaGRyIHsK
CW9wY29kZQkJaW50MzIKCWluX2xlbmd0aAlsZW5baW5fYnVmLCBpbnQzMl0KCWluX2J1ZgkJ
cHRyW2luLCBhcnJheVtpbnQ4XQp9IFtwYWNrZWRdCgpuZF9jbWRfYXJzX2NhcCB7CglhZGRy
ZXNzCQlpbnQ2NAogICAgICAgIGxlbmd0aAkJaW50NjQKICAgICAgICBzdGF0dXMJCWludDMy
CiAgICAgICAgbWF4X2Fyc19vdXQJaW50MzIKICAgICAgICBjbGVhcl9lcnJfdW5pdAlpbnQz
MgogICAgICAgIGZsYWdzCQlpbnQxNgogICAgICAgIHJlc2VydmVkCWludDE2Cn0gW3BhY2tl
ZF0KCm5kX2NtZF9hcnNfc3RhcnQgewogICAgICAgIGFkZHJlc3MJCWludDY0CiAgICAgICAg
bGVuZ3RoCQlpbnQ2NAogICAgICAgIHR5cGUJCWludDE2CiAgICAgICAgZmxhZ3MJCWludDgK
ICAgICAgICByZXNlcnZlZAlhcnJheVtjb25zdFswLCBpbnQ4XSwgNV0KICAgICAgICBzdGF0
dXMJCWludDMyCiAgICAgICAgc2NydWJfdGltZQlpbnQzMgp9IFtwYWNrZWRdCgp0eXBlIG5k
X2Fyc19yZWNvcmQgewoJaGFuZGxlCQlpbnQzMgoJcmVzZXJ2ZWQJaW50MzIKCWVycl9hZGRy
ZXNzCWludDY0CglsZW5ndGgJCWludDY0Cn0gW3BhY2tlZF0KCm5kX2NtZF9hcnNfc3RhdHVz
IHsKICAgICAgICBzdGF0dXMJCWludDMyCiAgICAgICAgb3V0X2xlbmd0aAlpbnQzMgogICAg
ICAgIGFkZHJlc3MJCWludDY0CiAgICAgICAgbGVuZ3RoCQlpbnQ2NAogICAgICAgIHJlc3Rh
cnRfYWRkcmVzcyBpbnQ2NAogICAgICAgIHJlc3RhcnRfbGVuZ3RoCWludDY0CiAgICAgICAg
dHlwZQkJaW50MTYKICAgICAgICBmbGFncwkJaW50MTYKICAgICAgICBudW1fcmVjb3Jkcwls
ZW5bcmVjb3JkcywgaW50MzJdCglyZWNvcmRzCQlwdHJbb3V0LCBhcnJheVtuZF9hcnNfcmVj
b3Jkc10KfSBbcGFja2VkXQoKbmRfY21kX2NsZWFyX2Vycm9yIHsKICAgICAgICBhZGRyZXNz
CQlpbnQ2NAogICAgICAgIGxlbmd0aAkJaW50NjQKICAgICAgICBzdGF0dXMJCWludDMyCiAg
ICAgICAgcmVzZXJ2ZWQJYXJyYXlbY29uc3RbMCwgaW50OF0sIDRdCiAgICAgICAgY2xlYXJl
ZAkJaW50NjQKfSBbcGFja2VkXQoKbmRfY21kX3BrZyB7CgluZF9mYW1pbHkJaW50NjQKCW5k
X2NvbW1hbmQJaW50NjQKCW5kX3NpemVfaW4gCWxlbltuZF9wYXlsb2FkLCBpbnQzMl0KCW5k
X3NpemVfb3V0CWludDMyCgluZF9yZXNlcnZlZDIJYXJyYXlbY29uc3RbMCwgaW50MzJdLCA5
XQoJbmRfZndfc2l6ZQlpbnQzMgoJbmRfcGF5bG9hZAlwdHIgW2luLCBhcnJheVtpbnQ4XV0K
Cn0gW3BhY2tlZF0K
--------------892760BAE4EE405FB98D14F6
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--------------892760BAE4EE405FB98D14F6--
