Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894813FF0
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 15:17:09 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id w19-20020a17090aaf9300b00191e6d10a19so1690791pjq.1
        for <nvdimm@lists.linux.dev>; Thu, 09 Sep 2021 08:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AzpI9xRwH63S4sY7PZzWuRKdR4DgsYKYQ1tUCrYHpxo=;
        b=dJ10V6/NsRo1W9cdQBMQ3kp9HeqUBGBiGonqDUGUrQA+L/9hCpOXCtlJ0JXYs2sB8w
         Yx4b1wAxryGQ6OH96UxXMo6WhIWD2ZQ57Wlzqpzgv8Czoe6Z3nB0xVnBP0/yZUGO5//k
         pAkusPFChxSxD2HMYcwbDANynJHFOkupRKJPfyuOUes4LzWfOXG0QYSWKAjZhHZOhDAe
         XSVaQbZpuStkHpq7VfzNWJSGfYLR1jvvYMXyGO/5Q1H4yLUWnKwlAjqhvQ4kUd7MUPNt
         U0ILtq36aeKM/fxEJyDEqHK0n86gJzQrp4+1rPKTjH3TeJ0ZGCUQQizchR4kneFZgDA4
         9VZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AzpI9xRwH63S4sY7PZzWuRKdR4DgsYKYQ1tUCrYHpxo=;
        b=FaeAWCJduq3OqQmV+xD53BYE7wv5obCkWjrX+oMzVPpMrxlFPy2NrGTsLiPwB14ZJt
         YbaGXsLMkNCU/YeJ/6QfOnXa9J/KTTrFs+41jaRPW0oR82sO4/9Hpl1/IHyp9kgCLXPh
         7i7MmElrwCQAeudyosH5rWPqTgGnte+ujfNCvIdHQV7+tFfFL+it/w1plvzhmy232L43
         DT3bfr6f335iwEM0hyxV5OyGfjVpzCLKNtFnrzSV008mizvutkURjnUv2MY9FXihEEOW
         qnJEHO0hRtnI6RCKecRUbD/lyjycYol1CUnacRKvHlG1J89FmGuTXGmQM1ZJ8nMMJVhE
         cHrw==
X-Gm-Message-State: AOAM533tTP8uxmZtmG0eq4iylY8gejF1G/5sASkcc1s7GMv76Ow18jzG
	kzIQeANSjaxL2DMg6MNpUn02Ac9ojOWbrJvpPmZDWg==
X-Google-Smtp-Source: ABdhPJwb3JKlDwjVI/1z+amoXzg0p9IxzGtjt02Ri3upXE1tVsq1lvKgxOb9/WOQY4kaqGujr7fVvf4WeKYHQOZCudc=
X-Received: by 2002:a17:90a:d686:: with SMTP id x6mr4219398pju.8.1631200628814;
 Thu, 09 Sep 2021 08:17:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116430804.2460985.5482188351381597529.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210909140942.000025e5@Huawei.com>
In-Reply-To: <20210909140942.000025e5@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Sep 2021 08:16:58 -0700
Message-ID: <CAPcyv4hvMzk3uaV6wRCoqpbHXRmx4HvDyvc0OovLUbAJc7bXkw@mail.gmail.com>
Subject: Re: [PATCH v4 03/21] libnvdimm/labels: Introduce the concept of
 multi-range namespace labels
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Vishal L Verma <vishal.l.verma@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Ben Widawsky <ben.widawsky@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 9, 2021 at 6:10 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Wed, 8 Sep 2021 22:11:48 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > The CXL specification defines a mechanism for namespaces to be comprised
> > of multiple dis-contiguous ranges. Introduce that concept to the legacy
> > NVDIMM namespace implementation with a new nsl_set_nrange() helper, that
> > sets the number of ranges to 1. Once the NVDIMM subsystem supports CXL
> > labels and updates its namespace capacity provisioning for
> > dis-contiguous support nsl_set_nrange() can be updated, but in the
> > meantime CXL label validation requires nrange be non-zero.
> >
> > Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
> (gave tag on v3 and this looks to be the same).

Whoops, sorry about that, now recorded.
