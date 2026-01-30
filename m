Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B661359FA4
	for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 22:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769813607; cv=pass; b=EZe0o2wwHzz2ntfApQUVljpqbdSWhPh6FeaqD0xVe5NWS0e0nVimy69zsR5qtAemBZKJYMkUTd+TXLvtIPzOyhmKMPdfy5GJrN+3FG5aCHLkPiXIYQb6ALPxU/Is1bsC0m7vLBOAJL5dP1phzPIKlcAakhXFI/JAR//xhEADpqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769813607; c=relaxed/simple;
	bh=I6AA9LJQkjtH8pRVXBRtk0eb0kKxzR2imNiewT90hbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sEMYNdwW7OiRJTGTqkO50zy5AKsII+DyiyWnndxvWj3bfWMevL+CQus/himdx+FZQvFh/4woMYtctewxT/0UZ2eATM/Q5rbjAuM2lwLyZc4hJPwAFe+1sVRD7wJ3fXZryQIHrZL9Wf0NE0/eOdJndInhfbli62YSla1s1gasP/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jF7WQUZA; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jF7WQUZA"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50145d27b4cso28366051cf.2
        for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 14:53:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769813604; cv=none;
        d=google.com; s=arc-20240605;
        b=O5f61OW4JKgE3teWQwRUzcqdThNhnUoX4mqirl9KgAuRS9rJ3b2wLJrJPdNWzc/S7o
         0WSeQBOartY0vfAW/gWtCZn2x98AU30KbuZHORNAbeKedXpl4GicUF7lz9jqmEoW84+B
         eRD5jMHs6NQ/Cnsz4UuqIOA/RrsZ1YIjXfOHhKmO/qOXQOkBzZjdkZRq701L+aG1fXwq
         mMWksvUYvpMENYkHaENkWQSXrkf6uadO/XF8GZZ9k5xdzmHCKYeR6YQHXDfJ+PpmVkK4
         bPqTUjWI5s65gvplKACV0p6Od0UGI65JIW35f3hEY9whMttlsynHfe/oXqaK0NSn4Bcj
         +kGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RvpDJGr4SwO80ntJbbklM7U7D7aCaEah0HNbCRkVHSs=;
        fh=hkuZXjnuUViqi2tFdDvXaECVyHRpUnssnZNP7+xsZuI=;
        b=aOVVokTxiAjRXvNKbgwHDKQF9xx6iq7CdIBAdtwpSxr093qupVi36rDo5JFQJBA8tc
         PRyFpMfkm+c+KLP8XDc08Rz8trFi3yTZ910MFbAAgGKh6XT5AZ22c1IkMx3KNbDHfA+O
         2m+qEanGvwPbuVo+CR3abkuQEnAc/4RiJNiJO1joMnOrcA+Av6+RM2cyzWOPMWK00/xn
         LumeckF362AQsAnu4hmftUXnuX0Nsr2Qbm+N+eEFzc2bl/ftvqo4FEnxqujF8vEQk43P
         MDskv/tUCW4T/kczNWloVffHdYtrj+rz/xohzyVEuPafmxSwb1EkolrLrbj9R8NcqaiG
         Z96Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769813604; x=1770418404; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RvpDJGr4SwO80ntJbbklM7U7D7aCaEah0HNbCRkVHSs=;
        b=jF7WQUZA3677lubZ40UisdjOv7thRoCgzakPipOsg91ojr4p88ww41DfFcqBDlhKLO
         11cp4SfvIIhVO5TCW4mGIPRMV/VcELdXYmIPV7qrg51EWrCF4qf4D84cwroNxNegopUj
         zd5CbH6emEf8GNyhHXZK6ACRUalp87jT/tVv5bOQk/aUNA0Eq8mbZ1eZNMo5OzHGgtdT
         yBqbxd8IOinveuH7MhD7p9VuuMhTAKUuJC+yzNtKSP5YIlwzt+/tH62wiXlNF/R4HmE3
         M9wZz79TsMODRG9rj0yX80IB84yjdSLurh7ROkAximSUjoAPt0l5CaHNEaOIlri0vQDF
         jvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769813604; x=1770418404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RvpDJGr4SwO80ntJbbklM7U7D7aCaEah0HNbCRkVHSs=;
        b=v6r+XHICocFhmoeYyhRfkkv6Y1cLF+gqBvqelDsQ2QQHDqThmKsV7+orBqfgzRCqdo
         dUfRndxfxhTDKG90hA+0eHqVUOgZ5tV4sOBz67R3BNMQ0TUwPuw9ClvVB6WE2CyHG0Xi
         7PSA5m7CW0LiXNjuMghCr11HMexeBYaDZMQvVFbQeOxGBPTGXYrSLW7CDilG4j2ftW+L
         ZbnWl5lGpI2h5CbP8YOuw8kzwovKsrtRwFM7rlqG6Of08TKzFAP8VEwxTHjil6Z/aIwS
         xqWokZ33xjit2v9XO4yKIGltXaW/tn6/AgsfMw6zHtWN0VCFP2zENmRqMoKR8o//QZom
         PoDw==
X-Forwarded-Encrypted: i=1; AJvYcCWIog0V+0UJmoIzyRy17kuYC8kSszv+YKOegL3XSnSEVttatpHXDLxciAaXQ+rf+JhAGQq1XWw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFEWvHkbbjkJTEbh6hz/mXWzOitcxkzY0l9ekwW6k4Td3onGF3
	Lt0xKjidSoM2u+yYvH2dk8YWq9x/tfLUWNdWA4m/7TZek8oi72qF4g9sH6UZ6N0MfLnLBzGK4zJ
	VDmVEM+aRPecMYEq0ycMdCvLb6wllgaQ=
X-Gm-Gg: AZuq6aK+v344wyE7Gs8przd1JUO40ht9pwhD2X4zyaqvEeqFAxQ8xcQLCHD4yonxa9v
	h3xl8CV+KiMKLfQjJftJqJXJqORb1+p0l7LO46yvjs0I2DElGPIoPrzXMPzSwOEST15Fkm+9GCR
	oo7ciXZNimqUB6Y7ZKtsax2jnpUAua8YfXFMCYerKr7qOU7oAWahW4EQ11C+RPJdP6fXVAd69n/
	JckCf67hPusg5f6SKuQivwxTtaSzZJh9iDMwcOC1895H2JbAEPG1/vLHfDb/JliTzgPnQ==
X-Received: by 2002:ac8:5ac1:0:b0:502:9f71:6458 with SMTP id
 d75a77b69052e-505d223e5afmr53898871cf.44.1769813604047; Fri, 30 Jan 2026
 14:53:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260118223516.92753-1-john@jagalactic.com> <0100019bd33f2761-af1fb233-73d0-4b99-a0c0-d239266aec91-000000@email.amazonses.com>
 <0100019bd33fb644-94215a33-24d2-4474-b9eb-ddae39b29bd8-000000@email.amazonses.com>
In-Reply-To: <0100019bd33fb644-94215a33-24d2-4474-b9eb-ddae39b29bd8-000000@email.amazonses.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 30 Jan 2026 14:53:13 -0800
X-Gm-Features: AZwV_QgH1KMH2vlFTNGo85feW4dv-AHS4Ad-yDU5HTglx7x3SJ0Y27UEufrkPHc
Message-ID: <CAJnrk1Z9BuCLZv576Ro9iYUPRDpW=1euG0rQ2wC_19sBcR18pw@mail.gmail.com>
Subject: Re: [PATCH V7 1/3] fuse_kernel.h: bring up to baseline 6.19
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

On Sun, Jan 18, 2026 at 2:35=E2=80=AFPM John Groves <john@jagalactic.com> w=
rote:
>
> From: John Groves <john@groves.net>
>
> This is copied from include/uapi/linux/fuse.h in 6.19 with no changes.
>
> Signed-off-by: John Groves <john@groves.net>

This LGTM. We could probably just merge this in already.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  include/fuse_kernel.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/include/fuse_kernel.h b/include/fuse_kernel.h
> index 94621f6..c13e1f9 100644
> --- a/include/fuse_kernel.h
> +++ b/include/fuse_kernel.h
> @@ -239,6 +239,7 @@
>   *  7.45
>   *  - add FUSE_COPY_FILE_RANGE_64
>   *  - add struct fuse_copy_file_range_out
> + *  - add FUSE_NOTIFY_PRUNE
>   */
>
>  #ifndef _LINUX_FUSE_H
> @@ -680,7 +681,7 @@ enum fuse_notify_code {
>         FUSE_NOTIFY_DELETE =3D 6,
>         FUSE_NOTIFY_RESEND =3D 7,
>         FUSE_NOTIFY_INC_EPOCH =3D 8,
> -       FUSE_NOTIFY_CODE_MAX,
> +       FUSE_NOTIFY_PRUNE =3D 9,
>  };
>
>  /* The read buffer is required to be at least 8k, but may be much larger=
 */
> @@ -1119,6 +1120,12 @@ struct fuse_notify_retrieve_in {
>         uint64_t        dummy4;
>  };
>
> +struct fuse_notify_prune_out {
> +       uint32_t        count;
> +       uint32_t        padding;
> +       uint64_t        spare;
> +};
> +
>  struct fuse_backing_map {
>         int32_t         fd;
>         uint32_t        flags;
> @@ -1131,6 +1138,7 @@ struct fuse_backing_map {
>  #define FUSE_DEV_IOC_BACKING_OPEN      _IOW(FUSE_DEV_IOC_MAGIC, 1, \
>                                              struct fuse_backing_map)
>  #define FUSE_DEV_IOC_BACKING_CLOSE     _IOW(FUSE_DEV_IOC_MAGIC, 2, uint3=
2_t)
> +#define FUSE_DEV_IOC_SYNC_INIT         _IO(FUSE_DEV_IOC_MAGIC, 3)
>
>  struct fuse_lseek_in {
>         uint64_t        fh;
> --
> 2.52.0
>
