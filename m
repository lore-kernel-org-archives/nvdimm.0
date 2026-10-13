Received: from mail-yx2-f2.google.com (mail-yx2-f2.google.com [74.125.224.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD3D427FA0
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 01:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791856517; cv=pass; b=FYcMhT3FYP28fez1u9yHRwoRBcu5+qDmmNI4KlS2zdoGyHjEEYZxwJuSJFdMviN96ASA8HvlKeObnbkKGXRqKAgKbTxaXaqLoGj12p7Bn2D/pDIbXRabeXGFOEstyBraaFiV/rfEjJrmPY64GPr8BrypBGLfpdqZkzA4XgvS58Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791856517; c=relaxed/simple;
	bh=mG265DhJNejB3aQoWJ6qVy75eCz04BYxxJNwPeHfTj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kWghe6w/G8YqLRIHKq1K0GqQEUXN5yUHo45rQMKdlNh5Vl/kXcEn6329qDnfhOgU/frs7C6gYmmcYMSihCSVCL/anGo76dVjLbAQGA+ehdAizv4RxhO+J4cmbghC3JH3gePpKL+H6f9lMsrJhZ7JnIFjbx02lUweGgGF53j4a6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RbHiszqo; arc=pass smtp.client-ip=74.125.224.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbHiszqo"
Received: by mail-yx2-f2.google.com with SMTP id 956f58d0204a3-67569b8cbf8so728469d50.1
        for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 18:55:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791856515; cv=none;
        d=google.com; s=arc-20260327;
        b=WTIgYMVIvuy3JYN4Y39DrtwRwxErtDV3G5HSQpWIm3kEowEDS/e+Vi5o+ZHrAGQpps
         fXAf0fqLJpq+h8sE5WWbZlXN+j6kSqdMSVIgMMWNFOEXS6IYBf1yLcEeq9tZLg+aUnB1
         DOvqSYEf0mSHZIuRrLkUizROqG/y+GdwxgJtgjpP1EtJcOxqyrnMbL3iSwuMBdJzvHwm
         QLp19j+aUsqxIaa/DSfdtzBYsoVPrgJR/HP4gHD2CGQRV1+qFK9dHuzZv+rsCjsATsFw
         0CzGSGA/JtQ0lMRMbmDmS0KNZnU3/Dd6XPRdkar8m2f7Lwqex013OrTuxefOFgE8JJKv
         WVCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PZWY1+3DvZQ0StiNShQCtdQAyPVbWkBMdlv0s3OdV3Y=;
        fh=9zKbJ1B2vSjLEmMVEJDTDa7umgMn0Ur3EdsrgGbLwxo=;
        b=qJX+nQEX4juIaOhwlIIQEY8vM6be7ddbNwQmAeZhMAU9Hxr1YNsq1mrMTqEqETwe5q
         umeC97Y820R8SMRLq8YlLSwk5690dUP02q73fCfp0Ib1RfK9BOnRcpuYKhwBqLGq+gTd
         4HMM3yimavTo3toBBmDALoI5oTD0/jI+vPThRCmzVfnHZ0WoxNa4EGgOW3ydzdgI3zg6
         04g/nh0BYfKHymre8jTkSPRMK4pdp7LNPH1QX/hTdufF7HOVRx1aeHHxC84bbr5dbUvT
         2Yoo5kTKNLtGIJk86A95LRS4ldL7RL6DD86p1SKbMb2XTw3QM7lcrfSKa21p3btiA4kf
         Y0LQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791856515; x=1792461315; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PZWY1+3DvZQ0StiNShQCtdQAyPVbWkBMdlv0s3OdV3Y=;
        b=RbHiszqoPCPS9Pn/FMjn+/tk9nL+1pajq7KfS8p+2YI0GUYYQUtCCKq1e7Uo7m2+tF
         bE/D+PpCX6ZTCOJaFDGOlqjSAy2Kib5L5iZQewdELsOHaYTj+2yZuSeqmNiOsyWJDgx1
         dJpOHuYweYInnapW1V6WApOQwqS3Ei7qKbs8P4bCvCwpRJ8OAhwlgEY/fnejECid02Xj
         20VarVaqZmxSSMLLNtg+gj640qAUXSkCruisjMinJRuPTFZUXw6ksqrPwMxFFVjXvnVw
         8LGZii70He7z+7ujkOWQU+/GWt9UYHZiXurW8pCoUM5f214zZwFRMydIM4Y0rzeAeDDF
         Genw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791856515; x=1792461315;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PZWY1+3DvZQ0StiNShQCtdQAyPVbWkBMdlv0s3OdV3Y=;
        b=ZLLNLB6mwBjxqkuxBVKUgN26gb3tw+mh3fIK4mE+eivpeDO+EXmB1eg3G9h9Vts5i/
         dnmWDW5Zk/sbZCe+JNB7CIV6s+FAcMJzidfFcbpI6egxr2xxzgb9kxO7XcHTH2AXEq+n
         +VTTz+38iGQu96sqB1w7+jvfNjYwDIgV5ogKXCsOxQtapJ77R5fg7TyiLE4M1j+cedbS
         jKILd8h7J4CZIKSmcpxRGt9lf15R3QtuZ2KoW39XMg4zcXP33dkAGbfefwr/4izQyDNY
         p7u0JGPC/IF6jnhumAaSck5TIJ/h/9PM7xEo/LsDOtErXrW2ud0QtwXzvhcRRMrLpKvX
         Nm0g==
X-Forwarded-Encrypted: i=1; AKwUvBzEayLLg6bdiUpNa+kY5d09j3sUFOubERjJlTL/nNsSnq2uSUudXzVMgOi84lUsA5SN9WrOFX0=@lists.linux.dev
X-Gm-Message-State: AFq9FYJNN3yytWPBEcHzdoWCMaDNPbC25ECtzFQeDqq70QyADXq051Bm
	XoiadROXef2CdeWsZq8jPAbhK0gqO93+aCDQJd6sVeuff8Qn5FctsZSg4lAUFqdqaPaSstr3awa
	VTIQcQJRX/Uogp2kqotJ0lylvYQ2tQRc=
X-Gm-Gg: AYBFou2uX4NAP+wiaee0luK5wpjrQ0gB8VD0NF80n6Ta5MnLzjWcMCovD5Q1H59TahU
	IVt25YNety6PszpsT8T1rky7jpaXN+s70nmITLmqF/BSxp/oDm+kEfeH9hlxKjhuZaiMsMXM9XB
	li77evxT/MFwdEZwDxB2N7edQLVls6VEzHq1348FrDShE8/zfBtJmtUKuCxcRTTvD1bxS2CZ/tl
	3yTkZjDq9NVLqzGGvo2a92NyJxHG0GX5gZSPsfXOdu2i+VUkcl1H8Cj2uiZd0Jxl2yL/sgibVwZ
	gPZ2CgYstxf/rh+qyh20ur4Z0j9aUa6mjjME15MJH/74/hIoaHiRj+iDrmvFwDUuVjUjss8LJc0
	t/5pzHOrSPhqHeiGaWCDL8k2t/VQANgTjPyat
X-Received: by 2002:a05:690e:d0f:b0:677:c1c9:8cad with SMTP id
 956f58d0204a3-6793630857bmr4065688d50.101.1791856515453; Mon, 12 Oct 2026
 18:55:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261011131857.30481-1-jianyungao89@gmail.com> <as1riZMcDaX5niW9@aschofie-mobl2.lan>
In-Reply-To: <as1riZMcDaX5niW9@aschofie-mobl2.lan>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Tue, 13 Oct 2026 09:55:05 +0800
X-Gm-Features: AclHuK-qPrcKDhDkwZ2-LoYX7aqLa6VHDfxw6GQjUohnMboPcDsPQB2ik2549xw
Message-ID: <CAHP3+4DCsJ4vJWFWfswGj70p+it+KJ2fLA1G8p5iKYJ7fi4TGw@mail.gmail.com>
Subject: Re: [PATCH] dax: fix mapping_store() returning 0 instead of error code
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"open list:DEVICE DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>, 
	"open list:DEVICE DIRECT ACCESS (DAX)" <linux-cxl@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alison,

Thank you for pointing this out! I'll drop my patch since Muchun's
version covers both cases. I'll review Muchun's patch and add my
Reviewed-by if it looks good.

Best regards,
Jianyun

On Tue, Oct 13, 2026 at 7:21=E2=80=AFAM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> On Sun, Oct 11, 2026 at 09:18:57PM +0800, jianyungao89@gmail.com wrote:
> > From: Jianyun Gao <jianyungao89@gmail.com>
> >
> > When the region driver is not loaded, mapping_store() returns rc
> > which is 0 at that point, instead of an error code. Set it to
> > -ENXIO to match the equivalent check in size_store().
>
>
> Hi Jianyun,
>
> The change looks correct, but there is another path in mapping_store() wi=
th
> the same problem. When alloc_is_aligned() fails, rc is still zero, so the
> sysfs write reports success without allocating the requested range.
>
> Muchun Song already posted a patch addressing both cases.
> https://lore.kernel.org/nvdimm/20260924025035.1265035-1-songmuchun@byteda=
nce.com/
>
> Please take a look and add your reviewed-by tag to Muchun's patchset
> or comment if it doesn't meet your needs.
>
> -- Alison
>
> >
> > Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> > Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> > ---
> >  drivers/dax/bus.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index b809e1a264af..262f97b5e7aa 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, =
struct device_attribute *attr,
> >               return rc;
> >       if (!dax_region->dev->driver) {
> >               up_write(&dax_region_rwsem);
> > -             return rc;
> > +             return -ENXIO;
> >       }
> >       rc =3D down_write_killable(&dax_dev_rwsem);
> >       if (rc) {
> > --
> > 2.34.1
> >
