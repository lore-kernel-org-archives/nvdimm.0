Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54EC168
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 17:23:35 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id y17so177462plg.7
        for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 09:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m4PBcFHpg3X/cUeTjK/pA3owHS0LZpp7nuPsOtsy/uM=;
        b=MRK8LrTkL61/2/BaPTX5UhD5roOEEheTbidBIpfv4xMENDJNSEs0hesn/UJ3IHzbY4
         US8nGBB1iFNZ8REhJxhSATNI7rF8YetikV95cRqRYG+MHUlfnQydcFpf3I9tYWwvlVGz
         kl2IWJSDG4MOFtq8ZzrvI8gRhRAhPMvd/I9Wyb+hFbccm4nfe6Grxy4vIHoDMPuJXAnR
         rK1XqEqP53f4ADfzii+M/cj09FUqrSj5w78JnFFbViY7b8EpiY08ssfOLSqrelY1tY31
         szIWRGcZuJNCzzR4dqmQZdw4t3wWhDyOVx28h+1D0ZhKL4O9FOdLYRd7vatO/O7bFL/o
         EJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m4PBcFHpg3X/cUeTjK/pA3owHS0LZpp7nuPsOtsy/uM=;
        b=g7QaLQFc9qEa351sDjtLgnu9mJ+JGL6+jwDstmL8wLubrze9aGJbUkg2KSL0WFRwRr
         9/NudWPym6QhLovl7exOERgBoKkhAHEOdjXEa9OlJCN8JBfzbg9CNFHGl/Mm4D2HBwUe
         hBSrlhAtrWUFGzWMj0sy0cVOwFCxKruejMRvyEHNuXe/u4Q9jYfCnGYhBREk6Td49/eJ
         tkw8XTIwf18I0JJExdiyVuNJ6tDRW8RsDin6aRzyc9Gk3Pwgesc+QChz/Z2MKk/Qzev8
         lVuWOfBkVEFps6A7hV2CAPV5HEQxBhlnuxA78NXqzMLvMhJvWJfuFqavfi31nizRHvmH
         JVNA==
X-Gm-Message-State: AOAM532SaR06E1NVswUKTKFNhzIndLFYx7srAPZ0KLRQ0ZbajErO7nZy
	94imnhVTkiGawlzJ9Gy2+PXPdQ3sAzDNy1o+SkVGkg==
X-Google-Smtp-Source: ABdhPJzi84NoQVPOQ39gCTYeTDT3xvXg4UkMWphQ4maUGvEoxCjmQctUJ0RzLjIpw8cEEpBYUvjZj74lZmHXRgxoKp8=
X-Received: by 2002:a17:902:ce8d:b0:14b:4bc6:e81 with SMTP id
 f13-20020a170902ce8d00b0014b4bc60e81mr14896398plg.132.1643217815141; Wed, 26
 Jan 2022 09:23:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1642535478.git.alison.schofield@intel.com> <5c20a16be96fb402b792b0b23cc1373651cef111.1642535478.git.alison.schofield@intel.com>
In-Reply-To: <5c20a16be96fb402b792b0b23cc1373651cef111.1642535478.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jan 2022 09:23:23 -0800
Message-ID: <CAPcyv4g3s=4AV+B3EHgANHXedrvOeY8vasE7uR5vznUX5BX24w@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 4/6] cxl: add memdev partition information to cxl-list
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Users may want to check the partition information of a memory device
> using the CXL command line tool. This is useful for understanding the
> active, as well as creating the next, partition layout.
>
> Add an option the 'cxl list' command to display partition information.
> Include all of the fields from GET_PARTITION_INFO and the partitioning
> related fields from the IDENTIFY mailbox command.
>
> Example:
>     "partition_info":{
>       "active_volatile_bytes":273535729664,
>       "active_persistent_bytes":0,
>       "next_volatile_bytes":0,
>       "next_persistent_bytes":0,
>       "total_bytes":273535729664,
>       "volatile_only_bytes":0,
>       "persistent_only_bytes":0,
>       "partition_alignment_bytes":268435456
>     }
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt |  23 +++++++
>  cxl/json.c                     | 114 +++++++++++++++++++++++++++++++++
>  cxl/list.c                     |   5 ++
>  util/json.h                    |   1 +
>  4 files changed, 143 insertions(+)
>
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index c8d10fb..912ac11 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -85,6 +85,29 @@ OPTIONS
>    }
>  ]
>  ----
> +-I::
> +--partition::
> +       Include partition information in the memdev listing. Example listing:
> +----
> +# cxl list -m mem0 -I
> +[
> +  {
> +    "memdev":"mem0",
> +    "pmem_size":0,
> +    "ram_size":273535729664,
> +    "partition_info":{
> +      "active_volatile_bytes":273535729664,
> +      "active_persistent_bytes":0,
> +      "next_volatile_bytes":0,
> +      "next_persistent_bytes":0,
> +      "total_bytes":273535729664,
> +      "volatile_only_bytes":0,
> +      "persistent_only_bytes":0,
> +      "partition_alignment_bytes":268435456

I think it's confusing to include "_bytes" in the json listing as it's
not used in any of the other byte oriented output fields across 'cxl
list' and 'ndctl list'. "_size" would match similar fields in other
json objects.

Other than that,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
