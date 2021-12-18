Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69F92C9C
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 02:28:13 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id x15so2962782plg.1
        for <nvdimm@lists.linux.dev>; Fri, 17 Dec 2021 18:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MfHXjsRQo0Ui4puyVFxSD3WvugUAt4jhbTNKOmv07Ro=;
        b=YYmsm2lUtXi/ZwO9tOneh75xbima+MqE1v/rzkMVR5SQI0xaijiSBIdHTLzgpnJ+ks
         9R9n1orniY3dAyJUwLBrwDbsBwxFQyjupSwjXF0nOE/V71NSyzje5Bnk4aQ+jnIzwOnJ
         dQ/uxhTjyPlYnmAPOr+sqLZ+VXtSh3FtrUBGkWzH50SPDHEa+aTVTzDCah8i+nt/Dcr0
         1QB7rHukgdRgXZnLw8hg9L89xMIo8eTY5CIkQafsJbZBeapizy5MGHjmG6ow+hpS+GPH
         nHUxuvMZsNL3vVA9fiZ2pTqFru+K7vny2dqbiiDekjPqE0gzqAE7qOUZuwXZ8pdtyOyW
         3wFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MfHXjsRQo0Ui4puyVFxSD3WvugUAt4jhbTNKOmv07Ro=;
        b=tazczayEJsoOR3RQo45z+R+nY52cteZcBN4tnLBT066PmbhRTElstacuEdmKiDLD1K
         IddmIVH3X2eKezyEXwxwmex9OJi4W0K6yzAGxmC9I32ESdOGkdClJ2B1RvSQpfAAyXEe
         GSoeMIXXKWosaGfjduLAOOC8wEtsnrLlu1kVTId5OM3K/k4Hu/la8cX3AsNaeXLVcg84
         +DIiV034uFikvl5lIJzOZAG32HeKWzcomqYW/8l72ZVtOM1MrAQhw/oDLaSnrIIMpOvj
         DULZFEzz9bcXAUhDUf1dFnDqQ9VAiXLn4qjeT4GNfMaJ/xa2BVxOkYXlpy3dGeGEDVC+
         rFJg==
X-Gm-Message-State: AOAM532H6Y3erWXSbHhF3R9XfoImlmGxFfBtqUU18X4ug4r+iBaN6fNg
	3QJBlUkKrjJ8trsR+/md0t0cJ6VbHKkMp0sw5ROgxw==
X-Google-Smtp-Source: ABdhPJzas+sA2cpPHpahOZJDKYMEclQ8LYKUWh+wBsOnPCUfwsVgws+Lcnv4drjWBNeXgvJIwPlA1UwziWzWSx+iIw0=
X-Received: by 2002:a17:902:bb87:b0:148:a2e7:fb52 with SMTP id
 m7-20020a170902bb8700b00148a2e7fb52mr5870998pls.147.1639794493185; Fri, 17
 Dec 2021 18:28:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211218022511.314928-1-vishal.l.verma@intel.com>
In-Reply-To: <20211218022511.314928-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Dec 2021 18:28:02 -0800
Message-ID: <CAPcyv4hGOw0wp7iR24vVXG_jCRTFwaxMNmq+qJH_8tpG8K8zfg@mail.gmail.com>
Subject: Re: [ndctl PATCH] libcxl: fix potential NULL dereference in cxl_memdev_nvdimm_bridge_active()
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 17, 2021 at 6:25 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Static analysis points out that the function above has a check for
> 'if (!bridge)', implying that bridge maybe NULL, but it is dereferenced
> before the check, which could result in a NULL dereference.
>
> Fix this by moving any accesses to the bridge structure after the NULL
> check.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> ---
>  cxl/lib/libcxl.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index f0664be..3390eb9 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -420,12 +420,15 @@ CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
>  {
>         struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
>         struct cxl_nvdimm_bridge *bridge = memdev->bridge;
> -       char *path = bridge->dev_buf;
> -       int len = bridge->buf_len;
> +       char *path;
> +       int len;
>
>         if (!bridge)
>                 return 0;
>
> +       path = bridge->dev_buf;
> +       len = bridge->buf_len;
> +
>         if (snprintf(path, len, "%s/driver", bridge->dev_path) >= len) {
>                 err(ctx, "%s: nvdimm bridge buffer too small!\n",
>                                 cxl_memdev_get_devname(memdev));
>
> base-commit: 8f4e42c0c526e85b045fd0329df7cb904f511c98
> prerequisite-patch-id: acc28fefb6680c477864561902d1560c300fa4a9
> prerequisite-patch-id: c749c331eb4a521c8f0b0820e3dda7ac521926d0
> prerequisite-patch-id: 9fc7ac4fe29689b9c4de00924a9e455cd9b58d53
> prerequisite-patch-id: e019f2c873ac1b93d80b9c260336e5d3f46b0925
> prerequisite-patch-id: b69ecc9d68ce5e7c79b62cea257663519f630da2
> prerequisite-patch-id: 928a32f4c1ff844df809ccf1aba8315cac723d93
> prerequisite-patch-id: ae29f23cedf529da1fe8e39f8cde1df827d75fa1
> prerequisite-patch-id: f3d8fc575f5afed65be8a7b486962e8384eabc1a
> prerequisite-patch-id: 74859f43302dcc442dfb1e29f6babad75d229bf1
> prerequisite-patch-id: 696c2d5caf0bd4eac645035f72a7077efbf3e6cd
> prerequisite-patch-id: e3ef7893a1df9ecc6b76dee78f2b27cc933ad891

git-send-email adds this by default now?
