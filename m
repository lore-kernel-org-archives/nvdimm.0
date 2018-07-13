Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 753D3211F8897
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:42:49 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id 13-v6so65211324ois.1
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:42:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153142855264.27297.4115939988098343498.stgit@djiang5-desk3.ch.intel.com>
References: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
 <153142855264.27297.4115939988098343498.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 16:42:48 -0700
Message-ID: <CAPcyv4iZi8+rQQPv-ZqX5WyQAAZ36tyH2A-TjbM7ZYP91+qnEw@mail.gmail.com>
Subject: Re: [PATCH v4 08/11] nfit/libnvdimm: add support for issue secure
 erase DSM to Intel nvdimm
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
Cc: David Howells <dhowells@redhat.com>, "Schofield, Alison  <alison.schofield@intel.com>, keyrings@vger.kernel.org, Kees Cook" <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 12, 2018 at 1:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Add support to issue a secure erase DSM to the Intel nvdimm. The
> required passphrase is acquired from userspace through the kernel key
> management. To trigger the action, "erase" is written to the "security"
> sysfs attribute.  libnvdimm will support the erase generic API call.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/intel.c  |   55 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/dimm_devs.c |   47 ++++++++++++++++++++++++++++++++++++++
>  include/linux/libnvdimm.h  |    2 ++
>  3 files changed, 104 insertions(+)
>
[..]
> @@ -690,6 +735,8 @@ static ssize_t security_store(struct device *dev,

I just realized that we should be blocking all security state changes
while the DIMM is active. I think this needs a

        wait_nvdimm_bus_probe_idle(&nvdimm_bus->dev);
        if (atomic_read(&nvdimm->busy))
                return -EBUSY;

...like we have in nd_cmd_clear_to_send(). I don't think there are any
security operations we want to allow while regions and namespaces are
active.

With that fix:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
