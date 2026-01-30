Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C665536655C
	for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 23:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769814815; cv=pass; b=pJ1+22kt4v2b946bNRgNKB0f9SZ56LYBfv7T7Hw0KyExxYe9fu1iYwmP40J3WYGQS7dyXR9jxetvgoSCVVMUOzLCsLXXxFRgx54qDN/PWCGsxkPx10h3UCaZLh7RHIX29lU9/E+FPZOTRS6x7sEWPaYgQPeTmJZ8u+LdtgbXzro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769814815; c=relaxed/simple;
	bh=c34Quq+eQsW819C0KqCK2tzNAvjf7UPjPYiue9c5K38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gs9o0JKyaAoNJhuFn8h+hJzhlAJInRmVaB9OsRPyzu1RYaeWfxBhGXmXQRMzSf8z7tx5M2cvnhoxYkIOf3N7yzYe8GPYZlfwss4FAjZP7P6oVEl39hgs+ooHB8aThIl68R0MdvNC9/P+E2Yne5otYC1j0JiOAl/L/lj2e8H6aAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fc3/wik0; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fc3/wik0"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-503347dea84so30647941cf.3
        for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 15:13:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769814812; cv=none;
        d=google.com; s=arc-20240605;
        b=jp82ti8RfgrzMn+SquWIAAh/ZWvsRIPSb4prhsnwmOUBip2vS/zRoDtIaR7FiSv2rf
         E/b0dpEfLabI9VaFfiF4dsR10ajmNUbsBX3ZjVZYKDui8eDYOBTDlYwGxl5dfUwo85Ww
         UPhTIPlBLLSZUaWIHx3ZY1yBW9Z2kVmT1LUTAetDZrqLJwKlLC5b0y6oRxEWC2LHReaQ
         UkLv2YuCKqS/Fgq6rp3c5udp595UC1hIgpx0EyLgA6Hxbiy7M3roLF3IiPmqG8E2JSQl
         l/db+zS0OciNZyt32eE3TLe2vEcY+m3MQYJcPLoM1wnU2U/3fVajJdHin2beE/yREPE7
         MW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mCpt40N6zxEp6+nDSQMAaK5Vngq+apunb1ikLDPBcPI=;
        fh=qBtsQntZkSG3BLeXCADigByAg9Y+266DlIdJhzbBOFA=;
        b=c3oo77+PnCYUps3YQHkEMArcFcz4g3S5UAYm5AyCFVoumxjl3P+lhK2+RKg2rNNbY2
         q+C3hGudWSRSWzZHklrQYGIKWbY23sMcgTXGAdnoTjyaBSbtnnGdDBPluY9n8Yrb9uKZ
         TlXFFPrL1s2tPvaeUgR796ilUV4vVP19+hLyr1insdVd0IJDFgF5U1r3XnK0WCvr4dsW
         ofuaPjRslCCVnbSON7jgYlci4+YDoSH2K94uyBPW2Lx4L9FlLRZ0WYeXj9vZ6w+2zVjk
         WkoNfqVJ64VJr2SLH9hA1EIx7HSNLh5VPrGfY+3CeFVDSSPM+fGXr5Bg6Lc6LVy3AmsQ
         JaLQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769814812; x=1770419612; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCpt40N6zxEp6+nDSQMAaK5Vngq+apunb1ikLDPBcPI=;
        b=fc3/wik0lY9S7+pQ1Z1h+h17rYtPbja8HgmPK5vfKR2FHNUMKGufXT0t0ShWYP2n48
         tIaYWj+9bmGrINqfh3zDc3wp6kPqfsArrizzTXp/Fm6rHMhJH4BH7WBXUDWgO5+Q0mUS
         H2J0b1OWaZHeBTLUNn2aUQt24uujWMV7EWZ0bs5QZuSiLdDgHqchLW4zjP4051AXhnum
         wL3eSMYDC7JN2AM/g2YLSp/kBXqrkekz/tV7edxIC15hiTh8QWs3xgL0VxMdva3IQ/p5
         0RpqVwNT+Wmx0Sg/bcmAPSv+Caiom8qmreGoOrl2TS3dqMviYr0laxtSMRTDTUAalUJi
         5mIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769814812; x=1770419612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mCpt40N6zxEp6+nDSQMAaK5Vngq+apunb1ikLDPBcPI=;
        b=PMwFCoodSpkP7cGiEZYiDMN8ftk0I4tn1t89Sv0Ito109QjtBkXnwUKo0KRYr21ZqL
         g+oVDZ22n9AaF9lOSbdETmQeFrMIeVF1Qfps95OQkYv1cr3K8GB61k8g64E0BHE7hP3X
         eLPR/t7I6lO3LYPTJdURdFruvnAdZgLkMR9YCHvbI2SaO6lxTggIdL7kZ269+w7j3f2J
         oheMHmwUVF/YVSCe6fRUc+cnM0Gxz1B5KDDvj9sjVnSYpvbhyWc1AACB8NVZenwWweSQ
         tq+9l7ZlR8gNnjrOWyT4QZhl4ZVkV2Nyv/9ShO22j0qdU8bz0Nr9XFx1/JLmGHMtw55/
         ziZA==
X-Forwarded-Encrypted: i=1; AJvYcCWjSKy1HiVrciW3Ruyoz9KKtB2P1Mr967jClaTQ0cZ1ersl9RaxUMl4y9P9Blda0ItTMIbZQgo=@lists.linux.dev
X-Gm-Message-State: AOJu0YydvfDsyUizVQ5PEEdopt1RKH4d5rHYgfy8at7NXua+6bpgl2EU
	OoG53VLpqzEw0jkZNy0HvjQ30VKYKwwzfucHYMXY8IJjGfb+lGTIvahmwghkSEKLRpwkIYiZ+YR
	2Y7+xA0s1dLwWj+SpIW9Cy2YlQHNwZHs=
X-Gm-Gg: AZuq6aJZVC/9h0dNChqNDC6G/mL8MiTbllwMZX7TVqOvgCxk285dIbUyl0yKHtV96YZ
	RV2+D99VoNRicwJpjEF7W5knDyXGgZQPpS6Mf4p83Eeej8j6hKFyw8rw5iWAXJWU18PMep9f4sb
	6xnt45nD9phFcOVsj6rHPmnfMzoP4767QxXkxr0hcAERCT8EEp55xyI/inUtOkoh26MtDKL7zdD
	GxKV5HlhzBm0m8cITSU1j9YObg5bGnBKkTZ1EDSfuTl3JcUhc2nVcTN0Oyk9W3HJGPw/w==
X-Received: by 2002:a05:622a:c8:b0:501:502b:8c6b with SMTP id
 d75a77b69052e-505d217b5a5mr58752171cf.9.1769814811697; Fri, 30 Jan 2026
 15:13:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260118223344.92651-1-john@jagalactic.com> <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <0100019bd33e43bf-bb49e98f-284c-475b-a027-13c7271f67bf-000000@email.amazonses.com>
In-Reply-To: <0100019bd33e43bf-bb49e98f-284c-475b-a027-13c7271f67bf-000000@email.amazonses.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 30 Jan 2026 15:13:20 -0800
X-Gm-Features: AZwV_QhZcPdEqRRUkE10n-Q1UjWagCWtvDsztQQ9CRVvisVS-xKBB72jFQNvlFU
Message-ID: <CAJnrk1YNRNRrXVydX6=5NAic3fu6QggbA5xV2fwywP27yZu2ZA@mail.gmail.com>
Subject: Re: [PATCH V7 17/19] famfs_fuse: Add DAX address_space_operations
 with noop_dirty_folio
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	John Groves <jgroves@fastmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>, 
	Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 18, 2026 at 2:33=E2=80=AFPM John Groves <john@jagalactic.com> w=
rote:
>
> From: John Groves <John@Groves.net>
>
> Famfs is memory-backed; there is no place to write back to, and no
> reason to mark pages dirty at all.
>
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/famfs.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
> index b38e92d8f381..90325bd14354 100644
> --- a/fs/fuse/famfs.c
> +++ b/fs/fuse/famfs.c
> @@ -14,6 +14,7 @@
>  #include <linux/mm.h>
>  #include <linux/dax.h>
>  #include <linux/iomap.h>
> +#include <linux/pagemap.h>
>  #include <linux/path.h>
>  #include <linux/namei.h>
>  #include <linux/string.h>
> @@ -39,6 +40,15 @@ static const struct dax_holder_operations famfs_fuse_d=
ax_holder_ops =3D {
>         .notify_failure         =3D famfs_dax_notify_failure,
>  };
>
> +/*
> + * DAX address_space_operations for famfs.
> + * famfs doesn't need dirty tracking - writes go directly to
> + * memory with no writeback required.
> + */
> +static const struct address_space_operations famfs_dax_aops =3D {
> +       .dirty_folio    =3D noop_dirty_folio,
> +};
> +
>  /***********************************************************************=
******/
>
>  /*
> @@ -627,6 +637,7 @@ famfs_file_init_dax(
>         if (famfs_meta_set(fi, meta) =3D=3D NULL) {
>                 i_size_write(inode, meta->file_size);
>                 inode->i_flags |=3D S_DAX;
> +               inode->i_data.a_ops =3D &famfs_dax_aops;
>         } else {
>                 pr_debug("%s: file already had metadata\n", __func__);
>                 __famfs_meta_free(meta);
> --
> 2.52.0
>
>
