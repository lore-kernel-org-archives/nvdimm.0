Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A5F2F24
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 20:39:09 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id z35so549076pfw.2
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 12:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8z1UZ+NMGTJbrhhy8yl4Lu6kb8svRF/BgAyYUwsEQck=;
        b=JCplgkUiO0PqXEIAJctgsTHYuyQcLQD9TAxvLBFbCOx/ffKySRHbjX3hMHycW9DbzW
         c3tnEXiCa93KHVdCd4LaxXUberXsBLk0De/HQxNR94sxJR+LYpG1H+4h5wEQFjF9dV2m
         Ve94cbvDFFFLJaV65Y5EWshPOG4Cxb/yAGlZ+TZDbkux52MS4LFtR0RPRZMj6N+tp+qP
         7ZIB4vYAsoGSKj4Z/8CFeuEwI28Uo1X1yG5mr2rw2Cm4+OBsVarMUtrEJkDmJ7vcbbYy
         C4BlUIhEu6jYWmwvGa0rtkI9VFM74pLkwjmff5pD8vU7QIwdOtfilLEDL5YQk8QE223G
         rUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8z1UZ+NMGTJbrhhy8yl4Lu6kb8svRF/BgAyYUwsEQck=;
        b=AP/OQN7QW9tol+O01YGVx4jsYMuSfhzVvNxKXZanW3K0qwJavi3v+U3uYVxOH08PV/
         zcJM/NHgd/cc7ezHBqHVzfhxZxEWPUm2lwiuK2osTjWaDZLi4wz2OfVNeS1snKBlnWZY
         dpQhk2HGjPpSuK5HgGb1OiO0JgckdyivIqsUZc007insPEzJ3Oa8ghHRf+bB1Gt9SGGY
         A8xFaFcH5nde8a5IUewCtuUIoptKa8RHYUn3J2RP5foTT0JDAnoggvs3KmNqK8p2GZce
         U1N9uOY5LduHPTGxr1EE7Es31hvXTyFPzjyZVidvVNuVZsoniZ9nx5Lqcm+JoJU5Z4XW
         eo6w==
X-Gm-Message-State: AOAM530eyet39Lmrx3kc0AYv645Ahgpe+b7inpW8c6hx0sbyxHGsuLPU
	PmwStHV2LiZy2R6wnsgQK0VgVgVjHNQ6N/lpkGiQ+RDgrws=
X-Google-Smtp-Source: ABdhPJy9d+7BY3Bsjz2Hj3HgFNIB1RuqdywF3tAVcSEa8HJnwuAdoazt07ZbmQJoFKi544/yr+Z+PUXG0INlvVDBKZ8=
X-Received: by 2002:a63:4717:: with SMTP id u23mr5001209pga.74.1644352749567;
 Tue, 08 Feb 2022 12:39:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1644271559.git.alison.schofield@intel.com> <fad634a7912265e87a8e7f3c3c9db21c1494d9ad.1644271559.git.alison.schofield@intel.com>
In-Reply-To: <fad634a7912265e87a8e7f3c3c9db21c1494d9ad.1644271559.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Feb 2022 12:38:58 -0800
Message-ID: <CAPcyv4iA-491r-c+j_-vuxRvkOB0vhW=Sm74Fa+M4WsVLUobGw@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 3/6] libcxl: return the partition alignment field
 in bytes
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 7, 2022 at 3:06 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Per the CXL specification, the partition alignment field reports
> the alignment value in multiples of 256MB. In the libcxl API, values
> for all capacity fields are defined to return bytes.
>
> Update the partition alignment accessor to return bytes so that it
> is in sync with other capacity related fields.

Perhaps a note that the expectation is that this early in the
development cycle the expectation is that no third party consumers of
this library have come to depend on the encoded capacity field.


>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/lib/libcxl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index e9d7762..307e5c4 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -2306,7 +2306,7 @@ CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
>         if (cmd->status < 0)
>                 return cmd->status;

Hmm, I like that this function does "if ()" instead of "? :", however,
it seems it also needs to be fixed to return ULLONG_MAX in the error
case. The status will otherwise be misinterpreted as the alignment.

>
> -       return le64_to_cpu(id->partition_align);
> +       return capacity_to_bytes(id->partition_align);
>  }
>
>  CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
> --
> 2.31.1
>
