Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4262D3FF0
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 18:38:21 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 17so2709151pgp.4
        for <nvdimm@lists.linux.dev>; Thu, 09 Sep 2021 11:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=943STyQuyGAFkNgg01KO1B1DOWI2nJ+DvbHRe4VQe08=;
        b=SE1IaZXRM0if+XOxEyUHiAgzlj7edQcax03xjz/nobuVIAC6iBVsnndPz6VW1zc1bx
         8U/YDlhIEyZ+jLI7dh+7hT5DHIiJCUAtJwFDnQ/MbMRG06AB6u5wYkKWcbXwcZHRf1N0
         jIYoSrLQS/oCN7zSZ1VMeUIXpmQ5F1XXNFYUXYHZmA3uU41aHtufb6eimdhTtLTHJiCb
         ggd+SyvwldXbBojXmBgOUBrhjA5z5FtgReveeEqIiM//zGAiMxaxd2Kvbm6T+kiqxjgq
         6nJkUsCxmzdt7sxbLTmacaE4v7XfPEN0ncqc2h+72LMY1Egst8gpPYpzAmJPRiQOAvOy
         lJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=943STyQuyGAFkNgg01KO1B1DOWI2nJ+DvbHRe4VQe08=;
        b=FNhlpxNW50jVbu9pw/fJAz0CXOxq8NnunIj1ZzeIAEZC8+PXzpnTR+79N+UnC8MG4p
         SVj/jCfAlcsChC8Tl9XwfTLmOJKl+Bu7haaUfUPhcssMRskvbI704CUBjgpWl7T8pxY5
         mBQCy6t9F+KIol6qG+Cz/j8IN1sGGmsF7hoBesAy6kynxBwOdlymfnz4B122ubdbTX4d
         FPHtRVcYWNBfKyZdyTyty2Y7Y8tZ8Ip0CW95DQnGcdU43NFTkbg3404rHmy6WbCJREIW
         TG06vmFlMyUV2fQlYhhDatosPdBsgEB72XdCuiqvEkBcS1tlmfqgUqSrWsbIJH0NFxcX
         LQKw==
X-Gm-Message-State: AOAM531CWIL9ppDrcnXUI6b4YaKQD/JyPXdki/Q1lIqaiECfYGLamI0i
	shFVL3WUC5bi02f5QNs2DlvgW8Vs1DAjOACkzMVg8g==
X-Google-Smtp-Source: ABdhPJzaO1bUJk+gLrDMJZ/3Nc2cF+/Ng3dxm4BqVAu72P0SuULafmwFIpT1iuFPjfh0DyxQNu4j0+Ux4oCJR+sqRdg=
X-Received: by 2002:a62:6d07:0:b0:40a:33cd:d3ea with SMTP id
 i7-20020a626d07000000b0040a33cdd3eamr4089769pfc.61.1631212700703; Thu, 09 Sep
 2021 11:38:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116431893.2460985.4003511000574373922.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210909155829.vjqznxbql2fgna3q@intel.com>
In-Reply-To: <20210909155829.vjqznxbql2fgna3q@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Sep 2021 11:38:09 -0700
Message-ID: <CAPcyv4hNMBH4v2Kp2q4w0WdCcZSV54mUuJg9wCVk7kkEey_CEA@mail.gmail.com>
Subject: Re: [PATCH v4 05/21] libnvdimm/label: Define CXL region labels
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 9, 2021 at 8:58 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-09-08 22:11:58, Dan Williams wrote:
> > Add a definition of the CXL 2.0 region label format. Note this is done
> > as a separate patch to make the next patch that adds namespace label
> > support easier to read.
> >
> > Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/nvdimm/label.h |   32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
>
> Wondering how awkward it's going to be to use this in the cxl region driver. Is
> the intent to push all device based reads/writes to labels happen in
> drivers/nvdimm?

I am looking at it from the perspective that namespace provisioning
and assembly will need to consult region details. So drivers/nvdimm/
needs to have region-label awareness regardless.

Now, when the CXL side wants to provision a region, it will also need
to coordinate label area access with any namespace provisioning
operations that might be happening on other regions that the CXL
device is contributing.

Both of those lead me to believe that CXL should just request the
nvdimm sub-system to update labels to keep all the competing label
operations and cached label data in-sync.
