Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC9E257D
	for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 21:50:50 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id i17so9151705pla.10
        for <nvdimm@lists.linux.dev>; Fri, 13 May 2022 14:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iJuobBmIBVSaPMk+qVzEvo4csdqwj8fKf0FwNOb+7M0=;
        b=hSTJioLxFfDdpKmJuQTSCJBtlSTNQhan5vYhQrx77bAOMLNw1zLzEe2Br0xFAf8gjz
         /CzK+jK3YXtyOzQtBd+X6jlhTuMj/chjrbeHazEKUXqcl4+UhVP44kpOKxOtQoM1LQ4X
         kHJVRrLsRQzDlgFtopPZkdMz/eUvATdd6hky18DZrScoyx9WuX4Dg6JAcJAtJb8yOove
         kU6uQFPrk4rdN532S9aGreECmTpbYeLe7SKoBF577A2UMy4z+ENSH/U8ZgVgBbtMVUax
         CImMP1I2VdTRuJlHaQQnbtN6G67c+ShUIrQvI0VEOozDIQYEdPDVcnJO437d1bOpQK92
         0Chg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iJuobBmIBVSaPMk+qVzEvo4csdqwj8fKf0FwNOb+7M0=;
        b=QoG8aBsncrtAH0tf9+maHSBeCkdTmXiW9izIut+ld8G61S5eVQJp0uJ3pUI+imSY5S
         FxI/pgCEftzeV/YDFSahlSSRI7SCq5g0ALj26Sr8jRPIAyTCX53I2baeP/enBU+P3zh2
         daPXlyIKnFUqQLrC6nevs36ruAUp1urPKMZUJ6fUHWMRDixipFr4GM6tS9wUBTkGuwk8
         DCvAId0NAgV/r8RgVnG8oC+9IOaXEFXsYhnAWIuPm8/p087btPlsX3vgnn9nnhWwCrUK
         EyC63rEXA+Gl/Qjjql86g5v18yD7WoLubTEWDuY3fnTtW83X6Azii/gncT75S7mSvezs
         ZYdg==
X-Gm-Message-State: AOAM5325DuT+dkXCvQsXg0RxwIfRmbXGXuSVGCF5UzMw3wJ18VXMoXu+
	ll7mnhqCZlxXNNAKc1i22EE0gVPNRXGniYhS0aIWjA==
X-Google-Smtp-Source: ABdhPJyU4g+3eCS7Fxllab5e0ETM04Rki3xFhVv7p/mB+jsYuPnBcvUXAfOdh2kWOTGfT3M+MbSh0PFnPgzDvBALmNA=
X-Received: by 2002:a17:902:ea57:b0:15a:6173:87dd with SMTP id
 r23-20020a170902ea5700b0015a617387ddmr6665568plg.147.1652478650479; Fri, 13
 May 2022 14:50:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <202205132308.wrD99x33-lkp@intel.com> <4960152c-4bff-4749-1dfa-61f2b2b1fd3f@oracle.com>
In-Reply-To: <4960152c-4bff-4749-1dfa-61f2b2b1fd3f@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 May 2022 14:50:39 -0700
Message-ID: <CAPcyv4j4=V_Rhg=oDoMKgVcaOQgoWNBNOu4-F1wwtfxkfn-aRA@mail.gmail.com>
Subject: Re: [nvdimm:libnvdimm-for-next 8/11] fs/fuse/virtio_fs.c:784:19:
 error: incompatible function pointer types initializing 'long (*)(struct
 dax_device *, unsigned long, long, enum dax_access_mode, void **, pfn_t *)'
 with an expression of type 'long (stru...
To: Jane Chu <jane.chu@oracle.com>
Cc: "llvm@lists.linux.dev" <llvm@lists.linux.dev>, Christoph Hellwig <hch@lst.de>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, May 13, 2022 at 11:50 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> Sorry again, and I'm scratching my head how could my build not complain
> when I missed this change?
>
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 86b7dbb6a0d4..c9faa5f2587c 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -773,6 +773,8 @@ static int virtio_fs_zero_page_range(struct
> dax_device *dax_dev,
>          void *kaddr;
>
>          rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
> +       rc = dax_direct_access(dax_dev, pgoff, nr_pages, DAX_ACCESS,
> +                       &kaddr, NULL);
>          if (rc < 0)
>                  return rc;
>          memset(kaddr, 0, nr_pages << PAGE_SHIFT);
>
> Please let me know if you prefer a patch sent your way.

Also needed to fixup the virtio_fs_direct_access() function signature:

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 86b7dbb6a0d4..8db53fa67359 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -752,7 +752,8 @@ static void virtio_fs_cleanup_vqs(struct
virtio_device *vdev,
  * offset.
  */
 static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
-                                   long nr_pages, void **kaddr, pfn_t *pfn)
+                                   long nr_pages, enum dax_access_mode mode,
+                                   void **kaddr, pfn_t *pfn)
 {
        struct virtio_fs *fs = dax_get_private(dax_dev);
        phys_addr_t offset = PFN_PHYS(pgoff);
@@ -772,7 +773,8 @@ static int virtio_fs_zero_page_range(struct
dax_device *dax_dev,
        long rc;
        void *kaddr;

-       rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
+       rc = dax_direct_access(dax_dev, pgoff, nr_pages, DAX_ACCESS, &kaddr,
+                              NULL);
        if (rc < 0)
                return rc;
        memset(kaddr, 0, nr_pages << PAGE_SHIFT);
