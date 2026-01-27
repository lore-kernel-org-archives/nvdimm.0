Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F14E30E852
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 21:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769550960; cv=pass; b=bFE/BSRcVHzcp9dIyftK4BQCQqHmSQcr/ohoZr+IhZ48ggPb2I961UZ5vCaEvOBDFtrWKCFclwTEyP/c+QpG1LWuchvJa7DkjK1Nc6fmbUC2vV+v7Q7lxRpFxAiDajBD5wTZsBfs6ZWo22/Bix3xY92ol2xBz+jhtycZINFCYlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769550960; c=relaxed/simple;
	bh=8m6SHPVdIWrcyh2aRGiyHcnuhF1GhzjV4UbqBqvwtjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DUVZD1ooIbjSHqqbLJDEnfaCecnGEG9BrDsY4Lza6Ipcj/4bqdAAU6qqct/wZIgBHMDQ+CMAMSBS3Ev9UZe2906k8qW5daGSbD4geUVcAIKSdzOU7osOV3LieWSpYW6sGpTqnHAyO1QAw2jgDLoaudoTgT7GkZGvtl75BY0sGAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJElpePB; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJElpePB"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-894770e34afso102240266d6.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 13:55:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769550957; cv=none;
        d=google.com; s=arc-20240605;
        b=SAyq3iCNt5DD3xLeg9XlWtJn+8HF6fA0adcKtlXk9tgsYF7/wJY5LPpY4b29qAZeTE
         RRBikhC4Aif+kf68EOhi9fzk0acVSp5uexPI0jaSuJSl8UBp2p9+GwviHkxTwwDCoSv7
         tN5aot5MqQdXZYUGy6FP1vZUY+5w3R5e5yCDx3noclPSuPMmr27czcFoMU0eac4LWZnJ
         lyuf7gQJ5PEZ0pQDz8SewRPvRvX1+H+xMq9uvrYRdoohRGADbbBZyvU4ra3RHLsbZe8W
         Gw2fyalFXQ/BUBHLw7/xfypM0/a3sRJ2cEQ9jUOnVyZ1FWb1fPy0c79Vagov9GziUN3I
         7g9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NKlFs0mQTNIoeYHTCe8czttQkA2EuwhIv5BND87JXOY=;
        fh=rs4ckGe+0begkh2tnZMknKe1IWci/1z0svSAlGzOMSc=;
        b=T1h4peX9rsERb1mefXZPy/cjx4LtOUoV5Pzo/5tcP7GA+p1Qh1P3gCqGM7KEp9t2nS
         3rNgKmktXCLOMnE1h96BS2O9NwYzzCvNWBIHFwWXmFvaee5hTYziBg4cPVwvsFGbLH26
         56KOACXBe9PKQyDyLobH/Tfn+A2VaDDR8tICm88TeVZ0sMlrVPCh0ia6mgsDXY9eBE+J
         juN1D2Aqxk/orvLFDONL7TKUnPQnPhkKM7LO/ysbGxyda58pXPzymepxAWACGUfD//B4
         zT996zFJkHfes+evUJOf6GLUAMEDsrrhWYXwsouW8OI00Iaoj9cb31+swNm7nlP4bn3v
         RXcw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769550957; x=1770155757; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NKlFs0mQTNIoeYHTCe8czttQkA2EuwhIv5BND87JXOY=;
        b=KJElpePBPIJ9cQDe5r2b19ySA3G1zMMPJjRMpibI8BhJo+MTiVeQifpFVzwceWE7a8
         TqCorpIPZKfqAanKW14QZGsZb5VZ9q/zhb6shgsh+4BTEY+oqyn5FZYsGpmgjNywh3M6
         thdxSaOK7cvlgmdDq+Hbrfj+CftutjvbJCE1PlDKhXOT9FUuxOugSQIgXdMqpPhav3HS
         IqiIzXs2JzpDnBC128yQWL7Lz4Hx6syGGTti5OYLiTYZ0xhoYEfevR+nAIw08k+LgsJC
         nxKXNY31KUyuz9PniSQQUgN+QAZvFxDbPR9Uo8rsPc4EQ/OcwC4qagAW1CElxcgihHWa
         B0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769550957; x=1770155757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NKlFs0mQTNIoeYHTCe8czttQkA2EuwhIv5BND87JXOY=;
        b=pL2XUuijBKnvgoSabTjBj/6IDCvh5RQXyqhw3ll+NvBi8pWPsKx62oqa9x2/8/cFQo
         3VhVq0jO1SRXdkogPCLrYb+6JDQIM+KKhP8dgMLiHf0hFqAn3BEEfJzi0ex7PrSFOeGz
         7ZSX1HUyDIshjQ/dWzWjT+jPQTW4As9TxiHHeinMyDVWiK+FTUh+FnivKobycNf7ZJq3
         nN0w+ft6hXhv5ztv1wr0vqLC4q5k6zdcMxSk3eQduWKzJCVsklU/VBETy1sHYZ0PQy01
         va3q0v2Y4XZwZqlSmu+kPf/4vgYfk//hnhOBMFGbZFgp4eYQ6lqMkxed9lF/80dyPQRN
         5b2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmgEJqqZXeZqPBMQNrdM8oe0PYaTNOqKm7yp0Rb/2Pxd9KSCCCjCPYZfYnuvLLvQ1VwRxOt8Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0+NSJ1oK6PttUouoK8z3qDG73iWJ/e0cNRnBSFevheVXt+wfi
	zR7FJkfxHL5I81i27u/Kpisron2aBw2EdyxVE2owL44CZb6tZ1eqB1H5Px9e/N01MsNEEEsl95t
	tpKd7wzteOVluXDN/SUwqsVHFXcJxu1s=
X-Gm-Gg: AZuq6aL3WIp4PqFSzC2vyolZQCovlT0Hhyn84n62yjz11UC+dEcxbampZqyL+8hVrii
	ZPms8ibGtv5JuIM6hQJ//7ZvZGjBq0dF7pdMKD3V6nstpd10C0nw/eCN6x/gPTlwpY6rW/R0PZ7
	evNicBAt3HU/mgV274n/U9wQh9pdYQEmQ77VWLIyu9eoLaLucu1okmle4j5QgzNBITXgeQnn8qa
	n03Lw/4O+EEnnWe1O0BRMCHLDopkNVLf8EyZV0MlyF6qPhiKrNMKr0RNzEULOb6SzZ7gA==
X-Received: by 2002:a05:622a:311:b0:4ed:a6b0:5c39 with SMTP id
 d75a77b69052e-5032fc1341emr35550071cf.63.1769550956926; Tue, 27 Jan 2026
 13:55:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260116125831.953.compound@groves.net> <20260116185911.1005-10-john@jagalactic.com>
 <20260116185911.1005-1-john@jagalactic.com> <0100019bc831c807-bc90f4c0-d112-4c14-be08-d16839a7bcb6-000000@email.amazonses.com>
In-Reply-To: <0100019bc831c807-bc90f4c0-d112-4c14-be08-d16839a7bcb6-000000@email.amazonses.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 27 Jan 2026 13:55:44 -0800
X-Gm-Features: AZwV_QhPL9Sj6DMGNjDww4OFl9nGLOsm6aFs6t6n1KrqwkFwyhPAYsBkmAeTikQ
Message-ID: <CAJnrk1bvomN7_MZOO8hwf85qLztZys4LfCjfcs_ZUq8+YBk5Wg@mail.gmail.com>
Subject: Re: [PATCH V5 09/19] famfs_fuse: magic.h: Add famfs magic numbers
To: john@jagalactic.com
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

On Fri, Jan 16, 2026 at 11:52=E2=80=AFAM John Groves <john@jagalactic.com> =
wrote:
>
> From: John Groves <john@groves.net>
>
> Famfs distinguishes between its on-media and in-memory superblocks. This
> reserves the numbers, but they are only used by the user space
> components of famfs.
>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  include/uapi/linux/magic.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 638ca21b7a90..712b097bf2a5 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -38,6 +38,8 @@
>  #define OVERLAYFS_SUPER_MAGIC  0x794c7630
>  #define FUSE_SUPER_MAGIC       0x65735546
>  #define BCACHEFS_SUPER_MAGIC   0xca451a4e
> +#define FAMFS_SUPER_MAGIC      0x87b282ff
> +#define FAMFS_STATFS_MAGIC      0x87b282fd

Could you explain why this needs to be added to uapi? If they are used
only by userspace, does it make more sense for these constants to live
in the userspace code instead?

Thanks,
Joanne

>
>  #define MINIX_SUPER_MAGIC      0x137F          /* minix v1 fs, 14 char n=
ames */
>  #define MINIX_SUPER_MAGIC2     0x138F          /* minix v1 fs, 30 char n=
ames */
> --
> 2.52.0
>
>
