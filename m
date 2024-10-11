Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E311F8F0D
	for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 02:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612931; cv=none; b=qGyzlSC4bkxlMXNjIdUxP94Qcfg9Yvns1tWLbETMAzypHjlKCny3Kqxl9aXZNiOZ+lhibfjozIJauPl+FvT+HOMSOdtuaIwxFObWBlYTFGOBPMT7OmL6pR/ZADXSIPZV+sTi/pdbaRTdAnc9HpGmbRTeDurjUU+0w3WVOOR4jbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612931; c=relaxed/simple;
	bh=gKiPKrKK60BJmsa5junoqJcObDYTvmnASwTlUEIPmT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WJE3DE5haxpoW7b4bTSvR5ItTpgIbf36BEZAnzcUSYw3L9ySTJKyFyGIOl/R0aWVfJJbKu6kDvz82nCGhrAfs9giInM1jMCsdXfXXMNOx+9BpBSatldc8Nt13naTEqC7p9snBwzmfcHYRQSEKd3kZP2Lr3XGNH8SlukDoywclcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b/mCLYXI; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b/mCLYXI"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20c693b68f5so15668545ad.1
        for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 19:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728612930; x=1729217730; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G70sgRbW5zVDibTqLQGClZ8RjbVJyvgKa5ojU/Ri918=;
        b=b/mCLYXI/dz11SlMTb+ahj5stLIR6Sts/fbJN7KEsrussEsg3bGy4Oziw8hNUnju+D
         +XUJ7E7IWk1SqsjVQNnk4fIwtkvbFyYp1TlycFFm+5bLPGXWeSRv1u+Nf1izgvuNRDqm
         /S+0tUQUszcuPxA7zPzUphL1nq4EMBVGEKRatrkEQO9D399+82zur5j57IYMAqGX6Ee+
         wQuphbZT6tD5oDV/MaEEgdzkAtwL3J+Yp+QUvP6325pQJYm21fFow20Enj3W+OMKqh18
         BFbrA51W//t11YMPuqIpWnyJvyZjvbB3yh2Ge1T8NS3WEzmZuQkquI5W0kAHkeopzYdU
         Q3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612930; x=1729217730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G70sgRbW5zVDibTqLQGClZ8RjbVJyvgKa5ojU/Ri918=;
        b=OhiyF0OxvaWjeFAXFW5DZktwSOEZA1yivJhYKDo1VHAD559sdclWPHCKbBJMHwyVY2
         F4YWQULE6VAs4K5SRrtpDoLWoo1tp0ZdQ2KbagPtRGsfBzlVtVIgeKMv0gufXIyCCFo5
         BNNSqg50mzbnnn4/WJoLcKFGH9zwvmXS1ME31NZlGyM6+BAN0zDYepeH8STVLzPMcqlu
         9XqlpDaNtyOF1ifEz8FmJ22cm0XvF/zeAFqriLTQo/o9m1RtbQRNu5tj5xu0bwT/B/IS
         SzZtGLPkyvy4MqQpP09jzDrJ70qWSpbQifWkzA1wQVeqqoiOtKAC+RaZoelBhbNAd2ek
         lpzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/WZ5FTO6EetRGR2/gWU5M3FLfTtDPfNSEdf+7lqm37LtnR29Wd5aWFBKFC93nDITEy/1qqo8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDWgQAg6WodxKBz4Zq5DJ+26kktZcMhKMkz5mcQh4YZPb7PdJH
	/8abkyBI5lM1lXM+5dBUAWX/lbaDPu7Nhfg5uMZATbdHUsNBz5bw
X-Google-Smtp-Source: AGHT+IE+MmEO12vUoLLKgbmMkNfIYHaPi9xzVe//y2m2AiK1pGN+UkN2eoeP1RMMb86Uy/RRTG6kzw==
X-Received: by 2002:a17:902:f789:b0:20c:9821:69a9 with SMTP id d9443c01a7336-20ca169e77dmr10577485ad.37.1728612929724;
        Thu, 10 Oct 2024 19:15:29 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c350ee8sm15532475ad.295.2024.10.10.19.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 19:15:29 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 99E6E4374224; Fri, 11 Oct 2024 09:15:23 +0700 (WIB)
Date: Fri, 11 Oct 2024 09:15:23 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: ira.weiny@intel.com, Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 13/28] cxl/mem: Expose DCD partition capabilities in
 sysfs
Message-ID: <ZwiKOyvXFXfAiOOU@archie.me>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-13-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oaAeGPAZ1RHcucEh"
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-13-c261ee6eeded@intel.com>


--oaAeGPAZ1RHcucEh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 07, 2024 at 06:16:19PM -0500, ira.weiny@intel.com wrote:
> +What:		/sys/bus/cxl/devices/memX/dcY/qos_class
> +Date:		December, 2024
> +KernelVersion:	v6.13
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) Dynamic Capacity (DC) region information.  Devices only
> +		export dcY if DCD partition Y is supported.  For CXL host
> +		platforms that support "QoS Telemmetry" this attribute conveys
> +		a comma delimited list of platform specific cookies that
> +		identifies a QoS performance class for the persistent partition
> +		of the CXL mem device. These class-ids can be compared against
> +		a similar "qos_class" published for a root decoder. While it is
> +		not required that the endpoints map their local memory-class to
> +		a matching platform class, mismatches are not recommended and
> +		there are platform specific performance related side-effects
"... mismatches are not recommended as there are ..."
> +		that may result. First class-id is displayed.
> =20

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--oaAeGPAZ1RHcucEh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZwiKOwAKCRD2uYlJVVFO
o8NIAQCZrs5IPtJRWJ3wy4dqN3eWUxQgLyspoOpH7V3EXTsEbwEAuEOVomNyr5Hp
JxCkGB4XGrygV0ZUzfdlEEXL1qkYYgo=
=v9WZ
-----END PGP SIGNATURE-----

--oaAeGPAZ1RHcucEh--
