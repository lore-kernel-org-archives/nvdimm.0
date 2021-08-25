Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A25872
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 00:35:59 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id 7so19816671pfl.10
        for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 17:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=95m2H3aNFcqs+pjrKLKP9B9PIJTzb95CufuE2mhXjt0=;
        b=au/u6K9d0HpoY+qxu7XDr2psxeuw8EIOsy+sP1lld2FerZcJ1LZFFU9ko2FhZSpDb/
         6rlavbff0mmr/XuVg2yRDIEsXUJ+jM8gSWU0OvpmscDyHWQ5Vzy877ppRbtNTmUz4vdF
         TbrbDP9ilOSaUuOBfatcjVQxICjsKZczsWkeU6+VcbFRTFLnszd4lhoKlop2zVzHeG35
         pCHRyQlDqMfse7SjcELHVcQIhpOJG1TyRZif7SzVDcnEYCN24hwTzG9eXX+AZlVK+kkm
         Mb3EDSN583y/c9BmMc2rt5DGPnj8RuiRqkSAskRaA9TCqIPtFhg/3TFId3hDL+Rt8xYI
         fowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=95m2H3aNFcqs+pjrKLKP9B9PIJTzb95CufuE2mhXjt0=;
        b=sF/ER4uniluQze2/YIm7JQ72YpRpW8W8f46XgiwyKd8luGfsJm6j/VvkRzCrfXczxP
         jc9AT5fqjtsffRCdoqRlU3gM/0ZHRJ7cUjIbJ1+rYfo4JxVPheJlvjULupDztbVU4a4t
         URwowfjK984E6LV0goEAwJJ4qNq4oKhoh7KarOGtgLUayXrs03vNGaUsKOOBYf3wT+QX
         9ky9wSIRTWKHkd80Lj8gAwE95CdFcQqqZ8uOat5TYA+Lezgas36MlM4FJIxXiV43ID1C
         QHoDB2Ggj/p2SCr5Ov/9+BMkK1JU827LvK+9JXLkKcf/WAWN9jg2Hgtbg4RRmx5dP41h
         Eg3g==
X-Gm-Message-State: AOAM533Q81jNLN+sZohCTJDYgXjsRT4PdAYGOpcly72eSR/U/4mItpwf
	5aup7UnW/FUUhBJUVwyqVPFiWOgw/nE6VzfSUquvig==
X-Google-Smtp-Source: ABdhPJw7YDF8tfa4S8oyVosEZTdcqIyf6S0D0vLD3w6h49znXNssiOVKzTy9/WL+P2JWlK0PJEdBbGNQImC7UBuzYCo=
X-Received: by 2002:a62:3342:0:b029:3b7:6395:a93 with SMTP id
 z63-20020a6233420000b02903b763950a93mr41426733pfz.71.1629851759548; Tue, 24
 Aug 2021 17:35:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210715223324.GA29063@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20210715223324.GA29063@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Aug 2021 17:35:48 -0700
Message-ID: <CAPcyv4gKqK6Mi6-PT0Mo=P=gBvMkA2zK1Huo3f2aAKYAP3SCVg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] virtio-pmem: Support PCI BAR-relative addresses
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, apais@microsoft.com, 
	tyhicks@microsoft.com, jamorris@microsoft.com, benhill@microsoft.com, 
	sunilmut@microsoft.com, grahamwo@microsoft.com, tstark@microsoft.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 15, 2021 at 3:34 PM Taylor Stark <tstark@linux.microsoft.com> wrote:
>
> Changes from v1 [1]:
>  - Fixed a bug where the guest might touch pmem region prior to the
>    backing file being mapped into the guest's address space.
>
> [1]: https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg23736.html
>
> ---
>
> These patches add support to virtio-pmem to allow the pmem region to be
> specified in either guest absolute terms or as a PCI BAR-relative address.
> This is required to support virtio-pmem in Hyper-V, since Hyper-V only
> allows PCI devices to operate on PCI memory ranges defined via BARs.
>
> Taylor Stark (2):
>   virtio-pmem: Support PCI BAR-relative addresses
>   virtio-pmem: Set DRIVER_OK status prior to creating pmem region

Are these patches still valid? I am only seeing one of them on the list.
