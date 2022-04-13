Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D732F23
	for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 22:06:09 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id c12so3101493plr.6
        for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 15:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+TkOV5v3hXeRRZE7H5Vq1vLrZTdrHF1lFjpXd5xGlls=;
        b=q6sK4N3fFAyBdutlj3pA0WimzP1uGFTAe5+cE/dtB9yEAOFJIyKZsB84DqxChLidKx
         NU/g4XTKeQyD1+NLhsWf4RjmS2Fc1e0IJxDFaMN1dwYTZm+wByCBelYAyI1hISqJE/pY
         LYZ60ezMfuPQDGcV5PwaYU0RF9MTdkNiLzp0vMq33AAqgaT83wWiyVpFU0uTtOFjlNm0
         KLUinkvgkYLebCQXnIHpVm8jqXLkscZKeTq2fWyu5Bwd88Si7Lkim091Tik+Cq9bIZ0E
         x+2qoKZbDouq5Tkz+/6THbFbhmvGk1OUcm2EqH8Aw92H7EQPHtZ4kRYCBeNXvKpmxZyP
         lYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+TkOV5v3hXeRRZE7H5Vq1vLrZTdrHF1lFjpXd5xGlls=;
        b=yYVD//yN7bO1czh5gA3vj76teoe3ANOkxCZhJwLAp/Rwutj42o48vgCR+GHxFJlx3/
         b53dXNFkdpDgSKzVLzdahXgiUt6vZM+GObVZ61tCV9a3lHDfsttYXkipEh+eHO9c6QSD
         0L/bfdBjDO0cWj2HOZqMmZaEZl/O4EkYq3VI5CPoxb0t9MvP2BXq/9ZWZNJNiNRqgvFS
         +pTNKbIZnx9YJx40zL76UX4BMhQaBW4staP+bl5OFWBx8sE5TkKC1BKqZ5D8LIRX4k/L
         TfhxVyln28vRXyzDLgBddA1sjDxzPEfyUsl4c1lkT7DkQLQkmolLNiKqsXIyQK34OhLM
         sMtA==
X-Gm-Message-State: AOAM532nzyCeZ+PfXAmxW1lr5Bq/c1F8nsIhaHgFFNCMFyMi6w7mJj5/
	cG2DAt/vNRUk0sOcNR4s/0xkhvzwgBR0OO5eGjO5Wt6Tsvc=
X-Google-Smtp-Source: ABdhPJzQWdsUZCwUxrbytfbWfiMVW0aRlZe6t/+QfsydcXfayxcE9qafFVe9BtUEBFbnbNU/t1NH5fSWq09IxrTa06I=
X-Received: by 2002:a17:90a:430d:b0:1bc:f340:8096 with SMTP id
 q13-20020a17090a430d00b001bcf3408096mr266248pjg.93.1649887569436; Wed, 13 Apr
 2022 15:06:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164982970436.684294.12004091884213856239.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220413093949.GW2731@worktop.programming.kicks-ass.net>
In-Reply-To: <20220413093949.GW2731@worktop.programming.kicks-ass.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 15:05:58 -0700
Message-ID: <CAPcyv4g-88D=ysgY5aXS9-jDM+KzPqpUoKi8VxBQeK4WKtcRHw@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] cxl/core: Refactor a cxl_lock_class() out of cxl_nested_lock()
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-cxl@vger.kernel.org, Alison Schofield <alison.schofield@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Ben Widawsky <ben.widawsky@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Dave Jiang <dave.jiang@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	Greg KH <gregkh@linuxfoundation.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 13, 2022 at 2:40 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
>
> *Completely* untested (I wouldn't know where to begin and probably odn't
> have the hardware anyway), and known incomplete.
>
> What's wrong with something like this then?
>

I'll give it a shot, I think it solves all the cringeworthy aspects of
what I proposed.
