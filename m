Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1B38211C64B5
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 17:58:13 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id y1so7391144oie.12
 for <linux-nvdimm@lists.01.org>; Fri, 01 Feb 2019 17:58:13 -0800 (PST)
MIME-Version: 1.0
References: <20190202015253.20051-1-vishal.l.verma@intel.com>
In-Reply-To: <20190202015253.20051-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Feb 2019 17:58:01 -0800
Message-ID: <CAPcyv4gWvez-4X=oNZkEwQy0X8Uf-YN-ndbpYY=7SHvJV-Oxzg@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/4] ndctl,
 keys: fix a memory leak in dimm_create_key()
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 1, 2019 at 5:53 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Static analysis reports that we are leaking 'fp' in the above function.
> Add an fclose() to close the leak.
>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/util/keys.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
> index 85818c0..acc2ff3 100644
> --- a/ndctl/util/keys.c
> +++ b/ndctl/util/keys.c
> @@ -260,14 +260,15 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
>
>          wrote = fwrite(buffer, 1, size, fp);
>          if (wrote != size) {
> -                if (wrote == -1)
> -                        rc = -errno;
> -                else
> -                        rc = -EIO;
> -                fprintf(stderr, "Failed to write to %s: %s\n",
> -                                path, strerror(-rc));
> -                free(buffer);
> -                return rc;
> +               if (wrote == -1)
> +                       rc = -errno;
> +               else
> +                       rc = -EIO;
> +               fprintf(stderr, "Failed to write to %s: %s\n",
> +                               path, strerror(-rc));
> +               fclose(fp);
> +               free(buffer);
> +               return rc;
>          }
>
>          fclose(fp);

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
