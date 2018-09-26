Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9885021962301
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 17:42:43 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id 36-v6so26400191oth.11
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 17:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <153791805740.70158.12896535066689316343.stgit@djiang5-desk3.ch.intel.com>
 <153791869908.70158.3791301656095148670.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153791869908.70158.3791301656095148670.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Sep 2018 17:42:31 -0700
Message-ID: <CAPcyv4gVAvM3CPd7Z=AzuFK79RLC139F9xAvZ4G-SKLL8uEmpA@mail.gmail.com>
Subject: Re: [PATCH v9 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 25, 2018 at 4:39 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add support for setting and/or updating passphrase on the Intel nvdimms.
> The passphrase is pulled from userspace through the kernel key management.
> We trigger the update via writing "update <old_keyid> <new_keyid>" to the
> sysfs attribute "security". If no <old_keyid> exists (for enabling security)
> then a 0 should be used. The state of the security can also be read via the
> "security" attribute. libnvdimm will generically support the key_change
> API call.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[..]
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index b7e22e6b80db..e915e6de6c12 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
[..]
> +#define SEC_CMD_SIZE 128
> +static ssize_t security_store(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t len)
> +
> +{
> +       struct nvdimm *nvdimm = to_nvdimm(dev);
> +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> +       ssize_t rc = -EINVAL;
> +       unsigned int new_key = 0, old_key = 0;
> +       char cmd[SEC_CMD_SIZE];
> +
> +       if (len > SEC_CMD_SIZE)
> +               return -EINVAL;
> +
> +        wait_nvdimm_bus_probe_idle(&nvdimm_bus->dev);
> +        if (atomic_read(&nvdimm->busy))
> +                return -EBUSY;
> +
> +       sscanf(buf, "%s %u %u", cmd, &old_key, &new_key);
> +       if (strcmp(cmd, "update") == 0) {

Please use sysfs_streq() here to catch garbage at the end of the string.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
