Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA712C82
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 22:29:42 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id l13so5117031plg.9
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 14:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BRkB2wipl7+jhUqvhRWOl4c9knyQgjfnb91drCfn3VM=;
        b=J/67zQAd5y8SNt2WlbqkgxafOmsYqxM/lvBo58anjlSDI+giv+9a2US1AL1DkHQQPS
         7FfgAtp9h5kxEP2jhOD4EBU/iB7aYHCjzAgkNMQCYfwSW7Bw7Rq36duG0x5Drf7zaprA
         br/s4ZcjSbDhT5A/zdtPrxYM4kxDqST3hsHJwaSEBjE+AgfAjmDKsrh2H6J5Pb1xceOM
         AVGpY0diQSoj1JZUyPsA7iw8geStuynoDqgmBwUVIOLtEHmk4tEoToXg/FS5sr3BhV5L
         bfeanuhcGnUJURDYGVkRRwK5HN4TF8QFznilZYzapFL6nb3lmNkg4zUydjm24/o3EnJB
         5Y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BRkB2wipl7+jhUqvhRWOl4c9knyQgjfnb91drCfn3VM=;
        b=yKWGK/B3IsDTsiNVCGNStu+PkKOnEeNQtcVmXMKoJ57lezqa0U9JVcmuY32RIRSvvr
         JBz0S0cbTnvVhmiPQ/dimN3DFOeR2bHG8B3CySd81fL3OwhO6klM23l5HpnHfnYBxhpl
         iIgeoCBEQZ68w0oxpUiIh+HMI0OVpyJt3F84EAyEEyM0wXEFRY6zuzKdcKRTof5D0ISn
         8Wb8U8RIdCEPhC/eQT46G6JVy40cM5fL67nYzJdFdKJkP90m/jz2oFWTV3tDAkgclgWj
         swafyyMZxJf7e+XW4TbIDisoNEivV870fK/N/X34DjHb4JtVC7frnvDpqN1oYxgaavsF
         7FdQ==
X-Gm-Message-State: AOAM531tC5HnpU+6KT7DbC2Y4TE9syWZ5UZ0aVa0lZeGQmkDS+SzcNO0
	mYfuLK0/MSd36U1RaWPQn1BCwZn/fYisdiRhTiwm63wKIv4=
X-Google-Smtp-Source: ABdhPJz07t1Yd9XkjGJzVP7cdliEvXQKPZm2/2/PGEcdxIjnCdxc2cNfzZfYJjHUVM32OPwLgMM+HE7p9CSgIHG6cgk=
X-Received: by 2002:a17:90a:640e:: with SMTP id g14mr36623090pjj.8.1643668182515;
 Mon, 31 Jan 2022 14:29:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298418268.3018233.17790073375430834911.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131145358.0000322a@Huawei.com>
In-Reply-To: <20220131145358.0000322a@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 14:29:34 -0800
Message-ID: <CAPcyv4iUGhR7EQ5WkxpqZg+9eFzK9LwrhSWZSZzZKmjiRO5sDQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/40] cxl/core: Fix cxl_probe_component_regs() error message
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 6:54 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Sun, 23 Jan 2022 16:29:42 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Fix a '\n' vs '/n' typo.
> >
> > Fixes: 08422378c4ad ("cxl/pci: Add HDM decoder capabilities")
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> FWIW
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Possibly worth pulling this out and sending separately.

Yeah, if some other for-5.17 material shows up I might send this along
too in advance of v5.18.
