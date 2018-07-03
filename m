Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A28D210F2029
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 20:46:36 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id 13-v6so1059698ois.1
 for <linux-nvdimm@lists.01.org>; Mon, 02 Jul 2018 20:46:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB1169BD7B3DE8CDA8BA5AE658AB420@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
 <153057476931.38125.15448927598576316449.stgit@djiang5-desk3.ch.intel.com>
 <AT5PR8401MB1169BD7B3DE8CDA8BA5AE658AB420@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 2 Jul 2018 20:46:35 -0700
Message-ID: <CAPcyv4ipAULUgtV6rvx7hQBLtjr7VSE25KvBiHxHRe7TT0HvKA@mail.gmail.com>
Subject: Re: [PATCH 04/11] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 2, 2018 at 6:45 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dave Jiang
>> Sent: Monday, July 2, 2018 6:39 PM
>> To: dan.j.williams@intel.com
>> Cc: dhowells@redhat.com; alison.schofield@intel.com; keyrings@vger.kernel.org; keescook@chromium.org;
>> linux-nvdimm@lists.01.org
>> Subject: [PATCH 04/11] nfit/libnvdimm: add unlock of nvdimm support for Intel DIMMs
>>
>> Adding support to allow query the security status of the Intel nvdimms and
>> also unlock the dimm via the kernel key management APIs. The passphrase is
>> expected to be pulled from userspace through keyutils. Moving the Intel
>> related bits to its own source file as well.
>>
> ...
>> +static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
>> +struct nvdimm *nvdimm, const char *passphrase)
>> +{
> +struct nd_intel_unlock_unit *cmd;
> +struct nd_cmd_pkg *pkg;
> ...
>> +pkg_size = sizeof(*pkg) + sizeof(*cmd);
>> +pkg = kzalloc(pkg_size, GFP_KERNEL);
>> +if (!pkg)
>> +return -ENOMEM;
>> +
>> +pkg->nd_command = NVDIMM_INTEL_UNLOCK_UNIT;
>> +pkg->nd_family = NVDIMM_FAMILY_INTEL;
>> +pkg->nd_size_in = ND_INTEL_PASSPHRASE_SIZE;
>> +pkg->nd_size_out = ND_INTEL_STATUS_SIZE;
>> +pkg->nd_fw_size = ND_INTEL_STATUS_SIZE;
>> +cmd = (struct nd_intel_unlock_unit *)&pkg->nd_payload;
>> +memcpy(cmd->passphrase, passphrase, ND_INTEL_PASSPHRASE_SIZE);
>> +rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, pkg,
>> +sizeof(pkg_size), &cmd_rc);
> ...
>> +kfree(pkg);
>
> Since it contains a high-value password, I recommend zeroing cmd->passphrase
> before calling kfree() so that data isn't seen by a subsequent kmalloc()
> caller (and make sure the compiler cannot optimize away the clearing code).
> clear)
>
> Also, check if the ndctl() call chain makes any copies of cmd->passphrase
> and ensure they are cleared.

If an attacker can run arbitrary code in the kernel they can get the
key from the ring directly, or turn on ACPI debug. A platform could
arrange for the DIMMs to be unlocked pre-OS to minimize passphrase
exposure, but once you need to unlock from the OS at runtime there is
this exposure. Now, there may be ways we could protect the key the TPM
to minimize exposure, but there would always be the in-flight risk,
especially with ACPI debug.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
