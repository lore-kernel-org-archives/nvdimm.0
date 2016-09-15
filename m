Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D786D1A1EC0
 for <linux-nvdimm@lists.01.org>; Wed, 14 Sep 2016 17:44:03 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id q188so48003536oia.3
 for <linux-nvdimm@lists.01.org>; Wed, 14 Sep 2016 17:44:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160913174140.10810-3-brian.boylston@hpe.com>
References: <20160913174140.10810-1-brian.boylston@hpe.com>
 <20160913174140.10810-3-brian.boylston@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Sep 2016 17:44:02 -0700
Message-ID: <CAPcyv4gM4L42Lpm=fW+zCqR7q-SFCAnh+ZsSRjM00cHvG4-s_w@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 2/4] libndctl: record dsm family in add_dimm()
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
To: Brian Boylston <brian.boylston@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 13, 2016 at 10:41 AM, Brian Boylston <brian.boylston@hpe.com> wrote:
> The recorded DSM family can be used to provide family-specific
> functionality.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
> ---
>  ndctl/lib/libndctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 9a9dc74..c824d83 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -136,6 +136,7 @@ struct ndctl_dimm {
>         unsigned short subsystem_revision_id;
>         unsigned short manufacturing_date;
>         unsigned char manufacturing_location;
> +       unsigned long dsm_family;
>         unsigned long dsm_mask;
>         char *unique_id;
>         char *dimm_path;
> @@ -1145,6 +1146,11 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
>         if (sscanf(buf, "%d:%d", &dimm->major, &dimm->minor) != 2)
>                 goto err_read;
>
> +       sprintf(path, "%s/nfit/family", dimm_base);
> +       if (sysfs_read_attr(ctx, path, buf) < 0)
> +               goto err_read;
> +       dimm->dsm_family = strtoul(buf, NULL, 0);


Hmm I don't think it should it be fatal to add_dimm() for a failure to
have a family.  It's reasonable for a DIMM to exist in the NFIT, but
have no DSMs or a DSM implementation that is new to the kernel.  Can
we make this continue on and teach consumers of ->dsm_family that it
might be an error value?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
