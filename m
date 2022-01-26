Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470C7168
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 16:40:45 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id h23so21528099pgk.11
        for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 08:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TwB0/lwgzjPiaznOkUe1BfmTxTsRyXZA+iPBHyPh2c=;
        b=5pPbMY64O7YApU1mKSzhG32AZ+VK5moxzw5p9OSRJGFWzwPyvp94EYgidJzc1oyEbL
         n159dA0WVt5RMch0cAt2PGN+9OOt0YMAo6dGOrYxBwipcFNYi0adh5BuDdHIGTUPdr67
         l6Y8/kVpY5G1HS9l1hE+JZBg0WS/B9oE/xIY3xYJU6LuIq/tPaOGLgsoAh8fuS3VO3sq
         ica+dgNt4m6PzGeRoDx/RgwzVVTv/gLzXb6nSAuf1IIAuaxYPG9eb9VVuFzBJkh94ebj
         h35k5IAWD0QGLfYTluhwF1lahU17acf7fCO6ID8KU1rCNnvy8ibqT9+dXtRlpP8yuHT6
         B4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TwB0/lwgzjPiaznOkUe1BfmTxTsRyXZA+iPBHyPh2c=;
        b=TpNlHXXa+/tQXQ3k48N+RBXC6Uwf0Idj6Au4jUkD+swSs9YSHFPIGKINp4nYQ0OTJk
         tO0aj5EXcZNK+95Uh+T1i6VWEKY9pjbD3YkadkKREWtIGIBUGAYMg9I6BP+x8Z8RZSgl
         HH08hYgUXLWoNiCHZcW1Wgz+VW4M8iOQT6VFx+8yUgqCnRQlwObpqOYHd2S3EZZZpO+8
         6OCsOmdYFOBOPisD7uW2LsvnoT5XAIRYfWEyLC/QJ4qc9mYPF5i36GFcxp3+COom8FRj
         M6sJNucLzMRW9pT4/i8PqmVmZ2Q14xTvmGXwPtBUIVTA9xlkkwRIMpMS7z9coNV744ik
         s/Vg==
X-Gm-Message-State: AOAM5314qcmM3p+mEEZV0ZPQmRAvsrCBpMPcPAsEahzUUHhCNyP/a199
	VSTdMFEnqTomZi65CczWAeXPg6KsTSCgnRRMGkUSmw==
X-Google-Smtp-Source: ABdhPJwq3FEoB/EhVZFCemFiKBwua2FDLaGTYok5A7738cFnNMM2m/2m/bOKepOFmxVpVz38mXxJ+FG9sfMPNJqFjfs=
X-Received: by 2002:a63:79c2:: with SMTP id u185mr19869012pgc.74.1643215244730;
 Wed, 26 Jan 2022 08:40:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1642535478.git.alison.schofield@intel.com> <6e295b9c3ab676906e6f58588b54071ea968e0cd.1642535478.git.alison.schofield@intel.com>
In-Reply-To: <6e295b9c3ab676906e6f58588b54071ea968e0cd.1642535478.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jan 2022 08:40:34 -0800
Message-ID: <CAPcyv4jpUubqaFSsvLjcrN2je3Fy4STDLbgfW=9VOdm_9eh-Cg@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 3/6] libcxl: return the partition alignment field
 in bytes
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Per the CXL specification, the partition alignment field reports
> the alignment value in multiples of 256MB. In the libcxl API, values
> for all capacity fields are defined to return bytes.
>
> Update the partition alignment accessor to return bytes so that it
> is in sync with other capacity related fields.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  cxl/lib/libcxl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 1fd584a..5b1fc32 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1089,7 +1089,7 @@ CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
>         if (cmd->status < 0)
>                 return cmd->status;
>
> -       return le64_to_cpu(id->partition_align);
> +       return le64_to_cpu(id->partition_align) * CXL_CAPACITY_MULTIPLIER;
>  }
>

Looks ok, and likely no one has noticed the old behavior. If someone
does notice though we'll likely need to introduce a new
cxl_cmd_identify_get_partition_align_bytes() and support both styles
forever.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
