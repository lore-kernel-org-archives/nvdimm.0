Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A3829CA
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 20:03:27 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso787741pji.0
        for <nvdimm@lists.linux.dev>; Mon, 07 Jun 2021 13:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8eiTN2SecL+L9tmp2tiWhKD5FFj8ndrnsfT62HKaYR8=;
        b=ERV6uOsqzoUh3OU7qtH2WJUGZXDoAOulyCHDm7lWOO41S29GKJxw1tIJPrKvQvhpQ1
         3vVB9py4oKc9c6Nm2Z0Owa2u3y2wlSYBhtp2RUvIZKmDxqyBanFM0fMiaNkwPKalBIWq
         rQXwrParZm2evbwGzEPLG6Zmu/PSaikwxK1dxjkj5E5VfN2/F23qVZo6nmfaY6V+7mSw
         Olo0u3EKQ/fOqlgT/PoBgdavN3ai70+e3zzN6zWLqviZYOZn7aq1z0gb7/lRUYyLWozv
         Ksnc00c3iVpb6BrQBpanazWtpnFZ2uXVYt2UbcXcFAoOgC5howWWmo7+pwgRklOjExsB
         vCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8eiTN2SecL+L9tmp2tiWhKD5FFj8ndrnsfT62HKaYR8=;
        b=LsHZYksaK8ZV8SyMd/PdQkf7M6gu79j3nqegu/mP0CQguqgjrrUt8y3ZriaHNHlXDn
         ow7cXD1E/1gVRUsWo8kbp79EbtK8uV2+MwrcQveRYr2WKV7PVv2G69fJbUAhnv//RPzK
         l8qHozFtFohMX96HM2tYekcvCUGP3jOureHchfbhK4rN7wK+tmG38jiSz/KrbdKuqERy
         UsVdpKm2eQZt4Zsv8Q7AR49NuyGvuETiRSna2VwHs1xYcyzI9K4g1VJrNufnRkWw80mr
         nd25W9HQOG8jX2imklz8isn/4S7dQXE/Is/VNBpt4NgHaDKbpT8Sy/oZQr6VF3Ptm9DO
         bPyQ==
X-Gm-Message-State: AOAM531gB3zZXbX8woS2AoYE4wz0JjOdH9DoAKTpCGkRFBo2CE853mLO
	I7HXi6NQcgJBZ4cGTWfbwbJer4nRY6y0lD74r18yJRXIAmBQQA==
X-Google-Smtp-Source: ABdhPJzsbK0fcIwttRwYMa9cGTjf1DZsvVmcawERgRvLrdGsMrmhZ+5bx+QanBedU7ftnVFx3tQyhFU/5C98pbjk3Mc=
X-Received: by 2002:a17:90a:fc88:: with SMTP id ci8mr852302pjb.13.1623096206522;
 Mon, 07 Jun 2021 13:03:26 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210603012556.77451-1-jingqi.liu@intel.com>
In-Reply-To: <20210603012556.77451-1-jingqi.liu@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Jun 2021 13:03:15 -0700
Message-ID: <CAPcyv4hzS93k5PYXE_bVp6SQ8WwPw09B+SyJC0xPKE20simwuQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
To: Jingqi Liu <jingqi.liu@intel.com>
Cc: nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 2, 2021 at 6:36 PM Jingqi Liu <jingqi.liu@intel.com> wrote:
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
> When reading namespace index and labels, we should read the field of 'mysize'
> in the Label Index Block. Then we can correctly calculate the starting offset
> of another Label Index Block and the following namespace labels.

Good find! I agree this is broken, but I'm not sure this is the way to
fix it. The ndctl enabling is meant to support dumping index blocks
that might be corrupt, so I don't want to rely on index block data for
this value. It should copy the kernel which has this definition for
determining sizeof_namespace_index():

size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd)
{
        u32 nslot, space, size;

        /*
         * Per UEFI 2.7, the minimum size of the Label Storage Area is large
         * enough to hold 2 index blocks and 2 labels.  The minimum index
         * block size is 256 bytes. The label size is 128 for namespaces
         * prior to version 1.2 and at minimum 256 for version 1.2 and later.
         */
        nslot = nvdimm_num_label_slots(ndd);
        space = ndd->nsarea.config_size - nslot * sizeof_namespace_label(ndd);
        size = __sizeof_namespace_index(nslot) * 2;
        if (size <= space && nslot >= 2)
                return size / 2;

        dev_err(ndd->dev, "label area (%d) too small to host (%d byte)
labels\n",
                        ndd->nsarea.config_size, sizeof_namespace_label(ndd));
        return 0;
}
