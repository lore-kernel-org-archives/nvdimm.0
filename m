Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D28381E9D
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 15:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733872; cv=pass; b=XkiXNABmjhouqA9PaTfQxCDlfrWCpYdRGPfT8x1xXwwqUQiooG/D4MiBJOTWvO5CuSIGEngJ+yrpqa7Dq6vOEvMZnxARxjniD3M11mPkMlOPfvGoLJB1IaMxfVL+yblDW1mLPy6OnWDcH4b9/GGg2sbM+ByeOxdsgsfKrXAq1w8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733872; c=relaxed/simple;
	bh=FmqQi9tHDOGtMRA8eYccGrCqdDwhdIqG1ghsXPY1Uts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kc8RQpTGg3csqm0uNmHZP+NYlvkkOXA2IEaj/8y2o1uVVTB8sP32imBwtSwLtwebY2WsosrFRHmDD8i5bdy2Z0px1u8PfNGw6yPa7d99HPckojFHuyL9ajGKIA/7snrAFzS7M5akHi7DMduFx0zuoAQMADQ0WRfpRQ7BMMH4Z68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=lZub4YDw; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="lZub4YDw"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e5c92c389so867524885a.3
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 08:24:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784733856; cv=none;
        d=google.com; s=arc-20260327;
        b=DSn0clmc4L8WuwxLPF7gfSMPs67AH1sPywhuw1B4WdowazDsrvr9XtQD1bhd3l9uK5
         BdETeZe2MqzHhVRZyGTAoUc3y1rTTU1rB/T4JldIhCPt79zL7SH55biOG0XPjIJ7MyB0
         6Z8tV+bSys/gehfdML6N1pvHkHYheaIHQjNaGlCOcj2DOJNRxto8HRJbXfwoBg2voXmz
         GV0UuCJRJLrQt4dadN/pXPjVn8nVuz/nv+TVADp32AeZXHIMNsWQneI3wJXAqZI75xC4
         2aBvuD5oWQ3F8fogNKTgBwfNlo4e+edxLLkriLQ8zin3gSFcPFEd8e2JNCDAIeTGKs3P
         NHFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ff8+sJsygEDuStaVFp2hCNrsI9M5jePRaYSdvrv4X0o=;
        fh=9947AnOccgvnTfVQBJX0CFJVidCsqy4gU90L0Rmj4Kk=;
        b=rAo5x+OwT65WC4UK5cGu76TsqpNAkCepjkkh4PTWjhaM5XjxLf52zqrsmpsq9+3JE7
         KhHkyRf7Rtrmj/6Dwnn/edwKy7fAxIVG55ccKxdaz4EqMj11sSst9Qm3Q6FdekW7wMwk
         DRvL3pOBgssOAP2/SBjwSjKNWTqVsjdUqZTzNvHpm24iXfnczb0yOFV1s2J00pxADHRG
         T4IPXOcduep2tUyfti5CWmuZQBKxXjaxlXQv1Jz+nPLR7lImDkJGRlYFcsdztiFBBgkp
         CnHQD9xVvG4pc0V0woWaEhvp57wfblHNoZmjLd3mhXJYOjMfECCMgYXBocZQcUipCuLm
         hE9A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784733856; x=1785338656; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ff8+sJsygEDuStaVFp2hCNrsI9M5jePRaYSdvrv4X0o=;
        b=lZub4YDwgHtq/qw3NACjxGrTTKi/1BxBqrfHlTLq7DlD2Qyp3D9SgeRsw3vNyxlCkn
         /HbCvHuLP8ox/U2nBc7dzX7xEv93MuYDbtK9YR453xk6VKa2W4pzfk7em+y8K/Wr1KDB
         EcymrYeIfk6j3OticzPUhcsLl06mighdpSe/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784733856; x=1785338656;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ff8+sJsygEDuStaVFp2hCNrsI9M5jePRaYSdvrv4X0o=;
        b=sQ6iK8PrXRh5dpGxOsA164R7OwgWiUjk0ExvU5C18VBAQtEHZEdcASH+K48tDSWQhr
         8e2sik0rudaQTs1rlDdUshL1Tkiet/vcvwg9BXjKymNd3OQvhxakl0NTjajhh8C6565G
         jTatW08bJi0bpzLbvq18F2A/9FIYYqDHqC7l+upwTjRNF7+n/CPzaGwN9z878g4cELwy
         HvwbOEUkGBojBVLIRainO3WV7kXnz1DyAkJ12346dwCuDs51J7zsgo8KVyAgFyZThwIp
         3niI/A4rB5Q/4UJe4dqTXL814NKVUHw5UbbtrkYb6YoriIWyAdvrjFIGtWzBGLA1fHN8
         p2dg==
X-Forwarded-Encrypted: i=1; AHgh+RpEE9GhjGtdhZF1Rnz6vvWFuBkIHPpRXeUHxx6cm8oDg4sQGpFDoiKR+PiRD3I6luDBmEZHOao=@lists.linux.dev
X-Gm-Message-State: AOJu0YzaIq1rWL37feW/9m2tYhuSmJ8UzDxX51FhzCEOjptIr18a2Q71
	E3W99Ru2DxitIPXeOVZj6wxJbQIIpzOLnKgPAOq4mYuJMDzfL7/CaDz2pkPOx6Xx+XZnb8OiNfJ
	8jdn2u/tisOhGeChWqSKQuSxMkASCa6E0eEN0z/E9bw==
X-Gm-Gg: AR+sD10y7WVgcqougf/XHmoRSW3mIXAg7JwqxYPXYfOVD7phZq6yRNeeF9Aub4gZzkn
	2uyLKWbQAtOlV0yEcBS+Os0M87t2KE4XY5T8jJP+0B53uV0HvlXa3ew0OMyhrIsr786gt737rKY
	vF6X7FrOdWqvB+4vIuEEWZMsqoCb2EnsvhT7yYeVS/KjKSu0Wg5HWQyeiLPb7II968Qe3G9Hj6S
	0QMWne5dL/vgEReNfaTBxs2zGOwoNARs+/+aD+dCKZ1uGTV29YJWF8b09QRJsjcJNvPZgElieUj
	ZHO+0edERa9vQJP9Rg==
X-Received: by 2002:a05:620a:2844:b0:92e:9cb3:3f71 with SMTP id
 af79cd13be357-930b3ed66f6mr2281752885a.36.1784733856139; Wed, 22 Jul 2026
 08:24:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720034553.68798-1-john@jagalactic.com> <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <0100019f7da174eb-4cd0f3ae-59da-4533-b469-6eee009a22bd-000000@email.amazonses.com>
In-Reply-To: <0100019f7da174eb-4cd0f3ae-59da-4533-b469-6eee009a22bd-000000@email.amazonses.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Jul 2026 17:24:05 +0200
X-Gm-Features: AUfX_mxUSuw0ZWzZWiq2Rpl7efuyYxiFK3IBC4AQjtyaBV6Cq7Rj41foWBlGbSE
Message-ID: <CAJfpegvkbK4xtQsssn3yrdLn7zZRGB8MeRcauP8mbmJRCnFouw@mail.gmail.com>
Subject: Re: [PATCH V11 4/9] famfs_fuse: Create files with famfs fmaps
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

On Mon, 20 Jul 2026 at 05:46, John Groves <john@jagalactic.com> wrote:

> +/* Famfs fmap message components */
> +
> +#define FAMFS_FMAP_VERSION 1

Please don't use separate versioning for extents.  It doesn't help
with feature negotiation, so let's just use the INIT feature flags for
this purpose.

> +
> +#define FAMFS_FMAP_MAX 32768 /* Largest supported fmap message */

Not sure if it makes sense declaring this on the user API.

> +
> +enum fuse_famfs_file_type {
> +       FUSE_FAMFS_FILE_REG,
> +       FUSE_FAMFS_FILE_SUPERBLOCK,
> +       FUSE_FAMFS_FILE_LOG,
> +};

Unused, apparently.

> +
> +enum famfs_ext_type {
> +       FUSE_FAMFS_EXT_SIMPLE = 0,
> +};

An enum with a single value is not useful.

> +
> +struct fuse_famfs_simple_ext {

struct fuse_extent {

> +       uint32_t se_devindex;

uint64_t backing_id.

> +       uint32_t reserved;
> +       uint64_t se_offset;
> +       uint64_t se_len;

Please  drop the "se_" prefix.

Please add more spare space here (e.g. uint64_t space[3]).

> +};

> +
> +struct fuse_famfs_fmap_header {

struct fuse_extents_header {

> +       uint8_t file_type; /* enum fuse_famfs_file_type */

Unused

> +       uint8_t reserved;
> +       uint16_t fmap_version;

Don't use, plese.

> +       uint32_t ext_type; /* enum famfs_ext_type */

Unused.

> +       uint32_t nextents;

Okay.

> +       uint32_t fmap_size; /* Inclusive of this header */

That's the same as outh.len.

> +       uint64_t file_size;

Same as i_size

Thanks,
Miklos
