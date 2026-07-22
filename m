Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2013546E0
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 13:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784728762; cv=pass; b=sYH5hpWoHBllxdbgunVcwCiKvycIliGxB0spfLPN4atq1Pbb/3HASxwnB2MkldN+qSkvXjGqAMOhGiswtKkkPVfTHnBl2CUJ/6nFvPrciSPpqsmB7KQrWSNnB7Q45qIZFFJ2qPDusUSkVxfl6oWGf9oTvo6otYblJEpdVRQqXBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784728762; c=relaxed/simple;
	bh=l8OyTHPsSiXlV3Gjth/iDTYvVrHiTPTknws/b6slKyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qnRl9kcNORpZn+chhP48/vwP29Onqs9j6dvXard9Lvn83XYe6IKbzm0c9UvadW6F4mmNJlVaKZwjSwGz1X6NqdC5Vi12KdqToJAgkhy7LKh0lOZBSXt2QXW2wQr9omzL0k4S3beM1NXil2PKGlbJdg6JXI317ceuBvJBCLA0o5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=QNPYoH/f; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="QNPYoH/f"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c0c45c580so108443711cf.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 06:59:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784728758; cv=none;
        d=google.com; s=arc-20260327;
        b=jh2i07ttcOnPaiZAZb1mbqZDxH65O8M9LoToJ0E0fDYeguLvgVSGfwdxYOx+izjawA
         vodRv3oKAW2ujv5ZH/OBUmbLt/TlTNhJUUguQ142gSdVq1fQGjJ13Vl+B+43XwOGp/Wy
         FgoOKRyTFFxklCPBmVwZ6aoPoxwc/3l30yRZUWXIPZeDOh/utCpo2iYm1Io6nPRUv9Uc
         ZDEgs3+oii5lfvUlYywraqM/Cxf6uAoS+iikXf4iKaWKW6RXKeaT1dUYqe4fSN2dWA/q
         QCC5VdycQTh1twDcXfIcJV3JrMPoBiefDiSF3ul1V5waC3iDFw7gtHngyJK+iZBGMIY5
         XX7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vQ2/EjZAmPdGp5icD1VFPQXMQudnf/IhCWBft3t6T2U=;
        fh=jOFMhJCRwhOO1dXMu/8FnRyjK6egkMqjCubcKtXBZlo=;
        b=PskkeVxPfwnKcV/u8lCMxPl6s3RkZmCEOipKrpImEkGfWt0u4J1djzMw+AKcbGmnF9
         ochbNL19joP9uJObjIBINSO17RN9vUvBON0AztqSJ7uar9RQ3TNif70lF0tfTH7gRGXl
         xab0VBeC4aGtGhWDlVjeTE7awqy227gxCk1FkmiyiYk+XWWYbjknYZkyOap1KrSH0Gpj
         PaIqqV5ZgfahMqMiwpYEKMmV8eJiapSwkzuzLrr3lDfaWqXc4eZsvtP/FO7Bo9RIzqVA
         rVykzzIf5sUfGAeCKeMXyQpuyAsNvjQNi6X5c5NMukZ50zCbgzlpDouAvpD5jaGY3EtF
         kHXw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784728758; x=1785333558; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vQ2/EjZAmPdGp5icD1VFPQXMQudnf/IhCWBft3t6T2U=;
        b=QNPYoH/fA8AVDnLfViOAibASjhUxG237JAaJ9Bia122HDFl8bQO9qb9dbvVrDzV87B
         BpE/PbDb+7NhyPx+yliG+IEBVKkATy5jcKI9/qu0/ga4tgQvkqRZ4e8X2QrQnR+8+GRh
         B5R/jLONk3Rzha6mvpxgEvgIviT0ufCs9jdVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784728758; x=1785333558;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vQ2/EjZAmPdGp5icD1VFPQXMQudnf/IhCWBft3t6T2U=;
        b=pZJiMLR5plUzzFlYmpOEuRKaD/+9EObGT6+X5jKeNlmspBGo+fI69lDrP33e6C979i
         W8+H/Rj+zBoJ4teFTdOidpNCI+2ZGeME1caYvdVuW2EdyfbGar2qIuIS/lcF5lCJFO/S
         0dJrFN6FtYtpsnMqROEHngfXhaQIFEcRJipNe0EQRF3YSab5FzO5Khz4NDF5MmXAm/yp
         0PPv5P8AkS7fE144Jdw0FjKGJEtuHuZomOyfikcwpkHWHZbZnoGijOqFh1w9Dyo5Bt8q
         rekqv0eBQpa1bDrc0z9PoXxaIM1+t9QGilJm1wvkw2KzvD/suywYYa752qOI5tPxpoVx
         Oz7A==
X-Forwarded-Encrypted: i=1; AHgh+Rq1ilhg5ZJ7D7xshu26pjeVw/bHq1E5h6IoTlDOyaSba1ehRt/6NRFpeN/cU43z+l0/Pr2KTO0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJZ2YxqpK0qkSE6PbGwR7mjaitlS25B8Dg8IvMl3Mj8Hs8hYst
	Tc9N2s8r2QoTaSkmM+GpuyxsGxpYFOjCespnCe9NIQk2VYLXcP2RYkZ7X+xYC4vGIXXANB+FsDV
	nari6ltQz+Je4x9oEuHtL0hIT01JR0/5nuPc6mSHaVA==
X-Gm-Gg: AR+sD11HlGM4EvNlb9s+muUFq3MnqJxGvZE7nWj8ZMqV3ccH6TwT+stdXroLFq5Sq3m
	76Af8gAewL9j3MFIsxkvoYuIK39+hYTBSo9LJU7MYze2rJ+yzIIuPxB/8cxDqnh2AAqyJaEvucY
	rrTqska7vMfaHB6izpJ+04m2CEaa3sAL0uG/dGd4COyYa88b5RtpLVqckvjV9tBiQc064tkoDUj
	EeV5NlYWoq5cGQKLWCUFeGPoPm4Eo0IAQKLFCFnncEklDUkKL+MLyaBGJDFGoJiZmNW5cOQPRWk
	xEgh47DzauyKvXA1tA==
X-Received: by 2002:ac8:5893:0:b0:51c:7b13:62f8 with SMTP id
 d75a77b69052e-5213eb800b4mr216533471cf.78.1784728758165; Wed, 22 Jul 2026
 06:59:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720034541.68781-1-john@jagalactic.com> <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <0100019f7da14ceb-fbd4edd7-ce17-4770-8c58-1296ad3e3fbe-000000@email.amazonses.com>
In-Reply-To: <0100019f7da14ceb-fbd4edd7-ce17-4770-8c58-1296ad3e3fbe-000000@email.amazonses.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Jul 2026 15:59:07 +0200
X-Gm-Features: AUfX_mySW2J0tjX47cdgUqD8gQ_vf8pqX8_96NOWv8ZzqlVpdTk8edwifSp98Qg
Message-ID: <CAJfpeguf3EBgBrf=mrG2Jp=oNp65DDg1fZsdEaqgBn6UNNrZRg@mail.gmail.com>
Subject: Re: [PATCH V11 3/9] famfs_fuse: Plumb the GET_FMAP message/response
To: John Groves <john@jagalactic.com>
Cc: John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, 
	Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Jul 2026 at 05:45, John Groves <john@jagalactic.com> wrote:

> +       /*
> +        * The fmap size is not known in advance. Start with a modest buffer and,
> +        * if the server reports (via the returned header's fmap_size) that the
> +        * whole fmap did not fit, reallocate exactly that size and retry once.
> +        * The server learns our buffer size from the request's
> +        * fuse_getxattr_in.size (GETXATTR-style size probe).

No need to retry.  I'll post a patch to dynamically allocate the reply
buffer (already posted as part of fusex).

> +        */
> +       for (attempt = 0; ; attempt++) {
> +               struct fuse_getxattr_in in = { .size = bufsize };
> +               struct fuse_famfs_fmap_header *fmh;

This struct isn't defined until the next patch.

Thanks,
Miklos
