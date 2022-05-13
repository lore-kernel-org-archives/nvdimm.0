Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE00B7A
	for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 22:09:43 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so11975579pju.2
        for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 15:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Mip6GB+UOxs40OE0wM8HSHN4JOWEcgh6ZJadFhE8R6M=;
        b=hG3F2MTWmspdKtHcKZJp220fMBZM5LR050BELG+dE11wxITHxXRC2n6V/hGuI8s7cw
         QQUImjQd8ydkGgqgaukb8rYw7e3mZMpVFGPbeXyQGY1/8AacuRbrw7a4IIJbkhjy9ABs
         RcyurlmuizIBp/nznhwbdGMyz1Bqfy2HL52+ZIR3nRRevvBxLNUS35/FRrYyN0s81m9u
         kpx1NbfR49gssH4i1uI9kJGSfPuCJZ9Tem2zirzgiuyF6NSu/PKBurU0pvg9yz0fgn+U
         r7r1IXiOoDuVmW26Q9XgEDFebIoZbKA+aFEsq5Fy/o0aEzpdXM3iMmJHCSL3LZ0S/l47
         HxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Mip6GB+UOxs40OE0wM8HSHN4JOWEcgh6ZJadFhE8R6M=;
        b=3vDkqRn1tWbFfDW36NWRixb+bYpHxz6q7Uzr9WmojJcW79ewekxI6blyP9TMojGGvT
         g7ier8YiDWz5Eo6ZrMLasipuSGdmd8ilYfuVAJhZ/K8nYSxqk2p+ckYXhzKQtphe6kTT
         DIFrBZsfLXzUZiiSoN8z3PHCEQdov3zSsheH7Oo2XqxzFsPdd6fHeH4cm+ZcHRsRRcK/
         Rveh7dRJQCzCwuA0CH0r3xKfDsT1yv+B15IuePe9vachgbTahlAzP9kLHnDyY06GYZwk
         dR1AtE8Kk7WAoE01iT40bx3rLG/sOo4VN9tNgfq0AUOQXdLs1WMGiJvO9nzcdGASDZCG
         3+DA==
X-Gm-Message-State: AOAM530TOtl6XcXTaw1njH68Xr8GeFy+mrrGTEuDvBBKdc/d28Z1Rd0w
	UpIGgAFKloMALSOvDbORdmOP7KwWzbMBC6gKf+XOuQ==
X-Google-Smtp-Source: ABdhPJzpfY8MlgI5f++tvopz4LYKd5ilu/z06Js/hnaOsL1+374Mzjwb83UO8JaxESRupngEQCtjfZyPDj2zPFQAv3s=
X-Received: by 2002:a17:90b:3845:b0:1dc:a733:2ece with SMTP id
 nl5-20020a17090b384500b001dca7332ecemr6990831pjb.220.1652479783256; Fri, 13
 May 2022 15:09:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220422224508.440670-5-jane.chu@oracle.com> <165247892149.4131000.9240706498758561525.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165247892149.4131000.9240706498758561525.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 May 2022 15:09:32 -0700
Message-ID: <CAPcyv4g8Tkx_b_Rs1WeAeV1knxV-z2r7Gmf56b8XN=CTyj6RVQ@mail.gmail.com>
Subject: Re: [PATCH v10 4/7] dax: introduce DAX_RECOVERY_WRITE dax access mode
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>, 
	Mike Snitzer <snitzer@redhat.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 13, 2022 at 2:56 PM Dan Williams <dan.j.williams@intel.com> wro=
te:
>
> From: Jane Chu <jane.chu@oracle.com>
>
> Up till now, dax_direct_access() is used implicitly for normal
> access, but for the purpose of recovery write, dax range with
> poison is requested.  To make the interface clear, introduce
>         enum dax_access_mode {
>                 DAX_ACCESS,
>                 DAX_RECOVERY_WRITE,
>         }
> where DAX_ACCESS is used for normal dax access, and
> DAX_RECOVERY_WRITE is used for dax recovery write.
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[..]
> diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-=
dax.c
> index af19c85558e7..dcc328eba811 100644
> --- a/tools/testing/nvdimm/pmem-dax.c
> +++ b/tools/testing/nvdimm/pmem-dax.c
> @@ -8,7 +8,8 @@
>  #include <nd.h>
>
>  long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
> -               long nr_pages, void **kaddr, pfn_t *pfn)
> +               long nr_pages, enum dax_access_mode mode, void **kaddr,
> +               pfn_t *pfn)

Local build test reports:

tools/testing/nvdimm/pmem-dax.c:11:53: error: parameter 4 (=E2=80=98mode=E2=
=80=99) has
incomplete type
   11 |                 long nr_pages, enum dax_access_mode mode, void **ka=
ddr,
      |                                ~~~~~~~~~~~~~~~~~~~~~^~~~


...so need to include linux/dax.h in this file now for that definition.
