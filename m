Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72B1844
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 01:37:46 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id u5so816265ple.3
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 17:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7vZVv1ogxeGB/tMAdmK5at+J4W8ez8n3jP7SjDQ5qgg=;
        b=cMc473ICFpscrz6Kg2TEINUfuiiCr7n79NNtBniP8KGkOAF9b9J6ETkih1Hf2OjAaY
         zra7/J1LRD1WVCT266kbSOhNePQTQlSfBQLJZxrHOBeKJGQTbkktK4afhTx62f9qaxUt
         M3bS42hVoqOTo+uWBcluZdMV2jxZLwDujKeQj034WXVqpgt0IyZn1+CxFAH7VvntEie7
         NERFRXNHElKR54xfwdMvbtorHfsJcITMYqzhJ/9/IL3SNbXXflV/aIJBKhjKQFEFApQ7
         RGyj8lNGy2O9KfPT9ksA0Nr0Xxft2xo3mbl4FQaPh8pNq66yD3XEDCxjjKAu4dHCbhFh
         ZxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7vZVv1ogxeGB/tMAdmK5at+J4W8ez8n3jP7SjDQ5qgg=;
        b=Ir2Ul8HTUoTdYbDS22WNFsjpZMyDG+QYb0nbwY/gt1ukxAHCs557oxkGYsWWwBd5H8
         7/3r2M85/iaQQtTPD5Y1bMC7dIl1m+142z6C+jEQXoDT9q2AI29mq2mZLh/cJkL3xdku
         5rNaa7CkVlVnPXji9k89L52Jn+nlZb0FxHXOTfgqcGI2j5ImbqA9hACZAjWyDeMor/70
         Ic+k7MpRycuDyD71MG/gBrOnAKp3XSTUy+jWGU4h/MpG1fCvt2+SRl0su2HxwKO+/sJQ
         s2ixAj2Y93Yc4lahtbGBYPd/JyXmxh+iZmSkacwusK1eweUqHoBnjycrb0bZCAiXLZkb
         s0JQ==
X-Gm-Message-State: AOAM530R5uZlINS7KILAq2Nnxuiz0xSTCNJskABkbTr63d3xjAbWrqwJ
	B1QgqoQp2WV031evXBoUIAkVrj2S9jFhNftxrRNkEA==
X-Google-Smtp-Source: ABdhPJyfbGOj2LEZYcd2Uhpx0um1C9tckAPR54JZv8aduFLaOPEJOttLOkO5/aF3ENQOMFJJx594Yf87mhQv1RvvLQI=
X-Received: by 2002:a17:90a:f28d:b0:1b9:975f:1a9f with SMTP id
 fs13-20020a17090af28d00b001b9975f1a9fmr265331pjb.220.1644975466504; Tue, 15
 Feb 2022 17:37:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-7-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-7-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 17:37:40 -0800
Message-ID: <CAPcyv4iJnOYfdc41nNtteidMtvt0fLS5RxZkRfk4Y=9vx_pf4A@mail.gmail.com>
Subject: Re: [PATCH v10 6/9] mm: move pgoff_address() to vma_pgoff_address()
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Since it is not a DAX-specific function, move it into mm and rename it
> to be a generic helper.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
