Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D2F821F38856
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 15:21:06 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id v9so16394613oif.13
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 15:24:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013001004.14963-4-vishal.l.verma@intel.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
 <20171013001004.14963-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Oct 2017 15:24:37 -0700
Message-ID: <CAPcyv4gfRAGqhf3NpWJ+1uHU1r0SD0kg7t5F8M0ZZU8rzY+O+Q@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 3/6] ndctl: add an inject-error command
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 5:10 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add an inject-error command to ndctl. This uses the error injection DSMs
> in ACPI6.2 to provide a generic error injection and management
> interface. Once can inject errors, and view as well as clear injected
> errors using these commands.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
> new file mode 100644
> index 0000000..4c45902
> --- /dev/null
> +++ b/ndctl/inject-error.c
[..]
> +static int uninject_error(struct ndctl_namespace *ndns, u64 offset, u64 length)
> +{
> +       int rc;
> +
> +       rc = ndctl_namespace_uninject_error(ndns, offset, length);
> +       if (rc) {
> +               fprintf(stderr, "Unable to uninject error: %d\n", rc);
> +               return rc;
> +       }
> +
> +       printf("Warning: Un-injecting previously injected errors here will\n");
> +       printf("not cause the kernel to 'forget' its badblock entries. Those\n");
> +       printf("have to be cleared through the normal process of writing\n");
> +       printf("the affected blocks\n\n");

Rest of the patch looks good, but when I apply it I'll move this to go
to stderr since we only expect json on stdout.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
