Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D2C30B501
	for <nvdimm@lists.linux.dev>; Fri, 15 May 2026 02:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778812065; cv=none; b=PQ0/CB+p3P13J/SMde47vXSM+UlfPiGE9WxZKJrQwB41SyLAIpWaCdsfj3OkE7oxcQT9QAYctjskZa20CSTvBCVgop4WZzPROX8KGuhzqh3BM6MwhjsaoKocNy4sm81rqg/VSKlMVLAt3zB7/BfR3yzYasPwlJP6VnGVZYlrWF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778812065; c=relaxed/simple;
	bh=u3xJJvFryReNBVBZkrBO3vKgaE4NDauZ9QrwQb+WzMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V6wec0EzC+atS7Tdn9JCM3k0FONTTvuJOZa+2hdPLMcGtzA412GiRewsrUHx9yxf0MnhzErNcrFlV0+AXXmiujdOBvv/bWtFkia2vMzHnVsGfXIA8YA285KU5lS+oP6GvD6s1gDxvkXxxgixWCf7D/fGJKFJgdyZ4jD/aiVrSKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfcmYe7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfcmYe7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA34C2BCF5
	for <nvdimm@lists.linux.dev>; Fri, 15 May 2026 02:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778812065;
	bh=u3xJJvFryReNBVBZkrBO3vKgaE4NDauZ9QrwQb+WzMs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lfcmYe7T2PzprGVLG3AlAF7lM4GtLbEwmhpbIs216kWjkYgEtzt6w2AE1kF23cYg2
	 p8ygTc2uoJRNvzVBoJjlljqB5cTeztOquy1kFo+/o5N3C/lMUXZmIDgVQsouSAhglZ
	 kfbhwbQM9MZaOzOwV68Onb6B3wVNrl+lwZ8qHNUJiBB16R0v8z3twyPcypg7Ql3Ujg
	 bvLRz5lmG0NTbpy7AHauyn8zq9NMzgDG8t7CyBocXBNubiJvKmBGZ204iAHUzRvp96
	 +dIqdXbutsgshSr6FxxqgDCNp+ya6qM+Jfc/zXxbqh+KPhcx+pN2mI5ZaTe5vwKQeH
	 VZiDX7WlOhsBw==
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so75362825e9.2
        for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 19:27:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8Co6VB0KcUsi9TZaBHgJnRc/BrG+9dQAJBLLt9uy8FMqzT+yMrZWu7tATq5hng4ku4nJ9raU0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHTYQtEcAqFBL7nr0D9eLu+RvAdVTIFMzr67DZWjWGEkv1/2jC
	dMxaca9JxTyMNNRfA5W4iXXfr4sS8a89ecrbvDF9W3CcDYD0B9A1iIYLu7Lwc1EnLY/SSuJe+qb
	QZfa7cdaN5qjLq/OZ8J0s6SCz0zqldUc=
X-Received: by 2002:a05:600c:4a1a:b0:48f:e6b9:c728 with SMTP id
 5b1f17b1804b1-48fe6b9c7e4mr11617295e9.26.1778812063942; Thu, 14 May 2026
 19:27:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260514063234.86439-1-cp0613@linux.alibaba.com> <20260514063234.86439-2-cp0613@linux.alibaba.com>
In-Reply-To: <20260514063234.86439-2-cp0613@linux.alibaba.com>
From: Guo Ren <guoren@kernel.org>
Date: Fri, 15 May 2026 10:27:31 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQUpwSCLVN+2oX=WWHVb6NYgE8jVBhTZVqCOn7dZ4a5CQ@mail.gmail.com>
X-Gm-Features: AVHnY4INQ8MwjbFKkLC5mxRb-vYD5ZjUJSVy7BkrBe6tUyzXHW7YA-_rZcO-kyk
Message-ID: <CAJF2gTQUpwSCLVN+2oX=WWHVb6NYgE8jVBhTZVqCOn7dZ4a5CQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] daxctl: fix kmod reference leak on probe-insert failure
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 2:32=E2=80=AFPM Chen Pei <cp0613@linux.alibaba.com>=
 wrote:
>
> daxctl_insert_kmod_for_mode() obtains a kmod reference via
> kmod_module_new_from_name() and only stores it in dev->module after a
> successful kmod_module_probe_insert_module() call. On the failure path
> the local reference was returned without being released, leaking one
> reference per failed enable attempt.
>
> Drop the reference before returning the error code.
>
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
> ---
>  daxctl/lib/libdaxctl.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 02ae7e5..ffc81eb 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -927,6 +927,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_=
dev *dev,
>                         NULL, NULL, NULL, NULL);
>         if (rc < 0) {
>                 err(ctx, "%s: insert failure: %d\n", devname, rc);
> +               kmod_module_unref(kmod);
>                 return rc;
>         }
>         dev->module =3D kmod;
> --
> 2.43.0
>
Reviewed-by: Guo Ren <guoren@kernel.org>

--=20
Best Regards
 Guo Ren
