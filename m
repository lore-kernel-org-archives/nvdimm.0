Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41DC35947
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 00:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751588838; cv=none; b=PUcQwUMwbEsN2Fu0GAJwfxTvfvznxF7WL2M0f4Qo8bsDMLpK8ezyraefX9VsxvKeniCQi0wC2WLbkhYIWIEMPVGGrR44ZUksPRG5HqyKYTB8wZY5xoqaNwv7g05CpGjUS9PQM/9Cf8dXuCKL98XAaWiRVmhOp5qiTFrV7e91tZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751588838; c=relaxed/simple;
	bh=ZiQ9WvbhgrqOMqZuRx3huleB0tjtVkP0ALx19wMz7I0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WqQKk6Br7hqZ6nN/PEkIiWIuQwCrJYJG52lG7NLCjQVnUog40K2qh3dRCVf4DNu91t/NsCQhNnrvvhqg/BAgiAjPhkyx5VHifjOOsfhidql8uubOeRJMdai3kNbMGZHGOweg1D1ZdCun1lwhvHpP1a/BKc7I/6m3QhY2f6Vil6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iVN+RAJ4; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iVN+RAJ4"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-74ce477af25so228987b3a.3
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 17:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751588836; x=1752193636; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiQ9WvbhgrqOMqZuRx3huleB0tjtVkP0ALx19wMz7I0=;
        b=iVN+RAJ4d6O/1vd4ZOT6wyok9/MhghWufRpdQ4lQfN5g0YCODz9GqPmEtjNtiuC28b
         jV+4/s28JaM9hbrCgmWc4awq6pHuTXzWsLxuwd/+ovUdTn0VZmik1uJNveyH6M61cOo4
         aH4g4RfZ412ncKPMs7F364psihFndhfnJXqKseu+Rxab16BYtjcy5jUnsKw4r8jdqJTD
         hV/CT7r9sUCXqWNc9zSQq6uSphKENGR8+cfrHm3a8yclDQlEQL0kgc4obRPRqNHqHXRS
         pk5ZhtF0vvJUoHmvXe/kt3D0i8Dt0Rbppsb8hJ0xESFTTmSJznPRJjv5dJ7xCw5p93jP
         SjIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751588836; x=1752193636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZiQ9WvbhgrqOMqZuRx3huleB0tjtVkP0ALx19wMz7I0=;
        b=IaljcJfnBUzOY+WptbsYSe3vHZ5INlTwxKIivOLlE0XpGlo3diGfVqY6JMbJw2C+uW
         8KOirS6bn/xWF9YhzU3ewi1X+nIyepqw+0LjMnrU9b+xWvGXZ8NNZ+RFfgXnMg+4NShX
         u4qJOSrP4hEVnwP7imZ6M8ZkTPMOOBxbLdDoNUPMx9eArWtmzaiw5LVqx6HPbJvCdQpq
         Q4EdcScwqiJ9FR7pDIPHYxMqxdwEbuPTkt2bGz7LrPNKRplUdRlQ6EU8QpAs6B6cYMq7
         apU2FTDPBRqrhJ0VVacieL/W47k12Y3CpFeEDLG5WWHZElq47qM1x1DpkLWVGBMT8c5z
         8fag==
X-Forwarded-Encrypted: i=1; AJvYcCU7a6dAL2Z65QcxcXZ6udIVoVLqG5bV7ivSJJYAyqMBa8/ji1RkuNn66Xp+Jj/LkQQY4v7lxcc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpdYNY47/XF4xGwv6VKL5qpa5QIzx3jsJoKgoweN/Gc8Ozs1I7
	BzTzo0pLKAQWWPVgwsXxELxtcAbf5tG2kY9za1uYnYF5klEB/2TyQ+Ux
X-Gm-Gg: ASbGncvf8qald48MZEADFDpC383CPpAvt2ghu/9n/qBINddXSHJwzpaZlVo7S6H/Cn1
	GHfSud/awWnAJ6DLErN/uC+DVlfGDhN4R1dM4i7xjtuci/CGybmNNcohW/7WpJ1+rK0AJQGKSfm
	y0MOcE5DhihuSJqcN3DuZ6hNS1ZbhOjgnMQfvyxkwPJ7EGss5JcDsY0gFCSVcFSA2LPRJakMx3n
	YwaH951tIJrnCC7ErW7DhZJMCMBXNVS7T2ZVWA7FOkuz4dyNxYUtaeIsNMedNVinVHl51VSdT7d
	YAnRkJG3UvwzFxt1M8e0xuYbMAMoDE/CG/rgBDrJA+gMGuOV4D0bMnG2DkPNmQ==
X-Google-Smtp-Source: AGHT+IGwQCrkWrjApK0htBGSorBdvNkVh5GSO+iYPYY+Kh0DqyqHto9HinLiE593880id3pXNBbbnw==
X-Received: by 2002:a05:6a20:4325:b0:220:9e54:d5cc with SMTP id adf61e73a8af0-225b9b7a66bmr1282824637.31.1751588836070;
        Thu, 03 Jul 2025 17:27:16 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee62dd6asm647668a12.64.2025.07.03.17.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 17:27:15 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 8A22A4206886; Fri, 04 Jul 2025 07:27:12 +0700 (WIB)
Date: Fri, 4 Jul 2025 07:27:12 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 18/18] famfs_fuse: Add documentation
Message-ID: <aGcf4AhEZTJXbEg3@archie.me>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-19-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FhmplPz1+JPluJTh"
Content-Disposition: inline
In-Reply-To: <20250703185032.46568-19-john@groves.net>


--FhmplPz1+JPluJTh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2025 at 01:50:32PM -0500, John Groves wrote:
> +Requirements 3 and 4 are handled by the user space components, and are
> +largely orthogonal to the functionality of the famfs kernel module.
> +
> +Requirements 3 and 4 cannot be met by conventional fs-dax file systems

"Such requirements, however, cannot be met by ..."

> +(e.g. xfs) because they use write-back metadata; it is not valid to mount
> +such a file system on two hosts from the same in-memory image.
> +

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--FhmplPz1+JPluJTh
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaGcf3AAKCRD2uYlJVVFO
o7MlAQDFFzY/AyfkzJf6X39RAu80LaEnq2G/NAeqbWbqwX+W8gD6ArnxxAZHvTMc
4pRWe3cIkdvJArMN4f2J8/XM623oTgk=
=0PQj
-----END PGP SIGNATURE-----

--FhmplPz1+JPluJTh--
