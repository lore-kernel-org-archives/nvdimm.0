Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C25472
	for <nvdimm@lists.linux.dev>; Fri,  2 Jul 2021 04:41:56 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id s14so7999744pfg.0
        for <nvdimm@lists.linux.dev>; Thu, 01 Jul 2021 21:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZT/WwBbHhsNk7JQf+0weYjJ8hV3V64CBj+Z1OlnfAqc=;
        b=uWHZBvB3nLhnvHwKeNyKBesk1mw0oHX4OWnf8dhq7jC+aiKqJ8IP+TGj4GIVJ+XO7F
         Eh8W1Kuw15osQ1L0kAEXPPfj5NlzIgqiTd3cPSHiPwute33gCgpifku/YO6ehcwx2HJd
         XaYz3UMM9xNGQwEGssNzYQ/74daverGhWTaiG1QMPXFx/N2n8kqcX83vqldO69D3weBK
         s1jqPPcTgE31pwTLpxy1ZGEQDV/EeQEpGPGKzZbkNEhkq0r8oGHlU0O+jGudT+tMvnCF
         yY4RAOC/iDAXXT5lt1zteSNpH6146do2HRrCjSgWyd/BX7a/cBS74nkVuuHhNhE1zmvl
         t9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZT/WwBbHhsNk7JQf+0weYjJ8hV3V64CBj+Z1OlnfAqc=;
        b=OZa4LTY9rC0id4tqLWjrZJ7gDmYf2m9m8E1Pr4iH2zW/cRp4ROrAhACwjiSDUiPh5r
         87YKzF1ZEkYI0mQJSiGF4/i9x7FO6ZG8y6EmByNzj4PeIavdEuxmBJjSHbZTZjbZouzf
         y2u3JYWTQlHt4fqAZ15ZxWcWd0TC8h7vm0NRIUlefi85dIJzz2u+QanObYITAUE+22wY
         KK+rPPXyKY57WLKwSwa0CS8S/P1Eefh8YfNE/An0qZ6eSY2Eg0vStFSXB7oMLcc2DBbB
         mUMi5sgrlb46iqMQ+twClyfIiFlGqWhKNIzTrwjLs50ehhJLyfzI2L2Ypfs+OALsZhlD
         hlEg==
X-Gm-Message-State: AOAM530jEzoIn2WONIX9HboY0lxhvRTilw9tVNLUeLsticepjIPD6LyZ
	ll8OPKXigKNVIJKLDdjWogASreRnd/y0M3RPiWU3Rg==
X-Google-Smtp-Source: ABdhPJxfD2AC+dfPVloGaz4xrxX9dgSt/kzcq2DQ5hvj4ZSbWd9eWgDaeI1j78QfR+miLCqAcWpaV9FbOw611F8GlhI=
X-Received: by 2002:a63:1e1b:: with SMTP id e27mr616375pge.240.1625200915686;
 Thu, 01 Jul 2021 21:41:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210609030642.66204-1-jingqi.liu@intel.com>
In-Reply-To: <20210609030642.66204-1-jingqi.liu@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 1 Jul 2021 21:41:44 -0700
Message-ID: <CAPcyv4jZ4WznktzoEm=vousG2rBaV6nyZDj-i8o5TYG=xdTqjg@mail.gmail.com>
Subject: Re: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
To: Jingqi Liu <jingqi.liu@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Vishal L Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

[ add Vishal ]


On Tue, Jun 8, 2021 at 8:16 PM Jingqi Liu <jingqi.liu@intel.com> wrote:
>
> The following bug is caused by setting the size of Label Index Block
> to a fixed 256 bytes.
>
> Use the following Qemu command to start a Guest with 2MB label-size:
>         -object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
>         -device nvdimm,memdev=mem1,id=nv1,label-size=2M
>
> There is a namespace in the Guest as follows:
>         $ ndctl list
>         [
>           {
>             "dev":"namespace0.0",
>             "mode":"devdax",
>             "map":"dev",
>             "size":14780727296,
>             "uuid":"58ad5282-5a16-404f-b8ee-e28b4c784eb8",
>             "chardev":"dax0.0",
>             "align":2097152,
>             "name":"namespace0.0"
>           }
>         ]
>
> Fail to read labels. The result is as follows:
>         $ ndctl read-labels -u nmem0
>         [
>         ]
>         read 0 nmem
>
> If using the following Qemu command to start the Guest with 128K
> label-size, this label can be read correctly.
>         -object memory-backend-file,id=mem1,share=on,mem-path=/dev/dax1.1,size=14G,align=2M
>         -device nvdimm,memdev=mem1,id=nv1,label-size=128K
>
> The size of a Label Index Block depends on how many label slots fit into
> the label storage area. The minimum size of an index block is 256 bytes
> and the size must be a multiple of 256 bytes. For a storage area of 128KB,
> the corresponding Label Index Block size is 256 bytes. But if the label
> storage area is not 128KB, the Label Index Block size should not be 256 bytes.
>
> Namespace Label Index Block appears twice at the top of the label storage area.
> Following the two index blocks, an array for storing labels takes up the
> remainder of the label storage area.
>
> For obtaining the size of Namespace Index Block, we also cannot rely on
> the field of 'mysize' in this index block since it might be corrupted.
> Similar to the linux kernel, we use sizeof_namespace_index() to get the size
> of Namespace Index Block. Then we can also correctly calculate the starting
> offset of the following namespace labels.
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jingqi Liu <jingqi.liu@intel.com>

Apologies for the delay in responding, this looks good and passes my tests:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
