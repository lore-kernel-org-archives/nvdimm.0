Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C916E2CA6
	for <nvdimm@lists.linux.dev>; Wed,  8 Dec 2021 21:53:04 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso4254312otf.0
        for <nvdimm@lists.linux.dev>; Wed, 08 Dec 2021 13:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tXovSrOyOnREehEDgz6gKu5N5pHzqfU6ltVBE9oLRs8=;
        b=wMSDu7iZr3IIkmcc4PykK3RIXv0iSJmkyt5zKMiexrTVa6ViQIySBGBbZ57unfRHcm
         2L92rNIkcfmQNkJMx7bjRw1gePbY2JxiBdu2/t47/EbVcnr5T9LObzlEZd30aLDH2jfF
         YndJpIr0e0Iybsv/MyVGQwMAeTWU10ppdOXcWg5SHkLUR/Xvn9HzIzcwzzAGb/Mg3ECO
         nkoGvZlGAWpJzAbMQ0lrUtmzCQ0Cqkb4oH4aP2qha10EOLam2eZmUemvcEHlkxwlqFhl
         ijr3elG59BrpksI+nSaoeXNI3TY0Ol8pr0MS05aQ45KYf+3X3xRUeR6ChRJ7lArahBdU
         aNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tXovSrOyOnREehEDgz6gKu5N5pHzqfU6ltVBE9oLRs8=;
        b=u8YSZR3V9vYDsqG81b/YLJUuSGHWO6im4No2SwvrqUxwdvowUJfV0FYLdrHEPH04Zj
         RDqGaq0gzwCH7DjKlBBNqlPCJW4LIkesOs9sNxG1SE/9u+Ci8DKipf8mnXj29umpzfrZ
         +eoqsPzcAxRvKL33C15WFKqcftvBB5u0CXsrYZVEBmMEUurfUt3y2brNrCf7RydrHHCV
         sh4yNzAwjWJIOgsv5EHKIKoTDnSovy8W+gZhCcdn1badFbvVC/61T7r367wNzIzo0A6s
         HudHUu71H037lpYj/tXDP+xxdtd2ptbHjwQFXdnWJwJ2DX4fTxew9MClcXrn+SMKCMI8
         +MVQ==
X-Gm-Message-State: AOAM530IhMxc1zynMVnZ8s+gUp8WHKjQm8ErcgFH587Nilujnd4CK+Y3
	nSlst135OOv9ai5QxFu60P7OgFyjRFvAoY7DmogG0Q==
X-Google-Smtp-Source: ABdhPJzxt5yKBhQBenbhJuG4nlZsej9Vvw4KdF61LFJOH10EFInui8Pa4LPBInmLk4fZtuc5S+2/HHviVO01cppgO5Y=
X-Received: by 2002:a05:6830:2b20:: with SMTP id l32mr1853871otv.333.1639000384089;
 Wed, 08 Dec 2021 13:53:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211206222830.2266018-1-vishal.l.verma@intel.com> <20211206222830.2266018-9-vishal.l.verma@intel.com>
In-Reply-To: <20211206222830.2266018-9-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Dec 2021 13:52:53 -0800
Message-ID: <CAPcyv4gfekvz73JTQcWj+xpkWOUFJH_SBquKkDXkMfK6J8eUTw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 08/12] util/parse-config: refactor
 filter_conf_files into util/
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, QI Fuli <qi.fuli@jp.fujitsu.com>, 
	"Hu, Fenghua" <fenghua.hu@intel.com>, QI Fuli <qi.fuli@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 6, 2021 at 2:28 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Move filter_conf() into util/parse-configs.c as filter_conf_files() so
> that it can be reused by the config parser in daxctl.
>
> Cc: QI Fuli <qi.fuli@fujitsu.com>
> Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
