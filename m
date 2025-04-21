Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70511DFD8F
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 21:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745269226; cv=none; b=evBtEcp6GMiQ7L/Mk9GQS6SSQN8yWGks2dPfS4PfZY3gN6Vpw88Hy8Dg1aiB4ny5JntvtvwKkGUalvMHC0KDVuXUilUSHDheViI+J98xqm9NZHfZJd1ApgKTRkLx/lxDkx/sBpb9UUe8J2AA2nUI/dUer9IghzmA2QurN2KKEnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745269226; c=relaxed/simple;
	bh=lGsrYSNcKG8qfiaikDbbRwogHHQDp6DKS6+nvftTpcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fhh7c6x+FvuK7PJJ0f4FO7LAAZteTjCSxEwnJkBjXre7H/mnBDN20fwFxlYoLHkQ5kzZxOgowCrvtkc1fOl6dksR5z+N4FJVuQwtbSoJK6plpskP8Y9Dw6EQjn2hmD7DRwF2bdFhLp1XXkVUPcX4bOhfMU8twDEMzqq7FoYN28g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+DVZyh8; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+DVZyh8"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2b8e2606a58so2490385fac.0
        for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 14:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745269224; x=1745874024; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=POBPLlOljVBDgxUS6PxzvxfjfLb9G+KKgkGlb9c3n64=;
        b=C+DVZyh8uo7zRlcUfdRxHFIiQoWKQ0q+dud2+azYYHBJkmY7ndFFBYsPNXLc/IjQuz
         o83QLhQWCmnOstLKgG5S0mltdZEPe5+6qcKKobdMDH0D14Dyew6GxQOumsYIa7MEj0V7
         ZBb23CPXKvACdhaVA78I5T+0w9JetUDnEjRoUbMXgUBegE2IfnVlyqlfx/AMnASAQ+Yb
         z1Y9cJF+nm3xqDHOSF+nZezFGOjiKbeUYxLz5pSWz2x2ISzJZJMoLwUt/fox6kmKUo3r
         MkGsE4IJ98ER+XLaQdsZeH/QLdf2FzKWCKLuGn6iEVo0MBc8VFgGLgt36t3BVN5sfINf
         sD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745269224; x=1745874024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=POBPLlOljVBDgxUS6PxzvxfjfLb9G+KKgkGlb9c3n64=;
        b=whBTH9kIY+H+MSKgC/fDimU+radDwPx4amzam+FONvWbxwqfqbFNIOX8xdVVJ+Astp
         RtBSfQOApb5dw+l9isM3RKT57EPZadMxRspKaYUdeF9LFowMQvwmaYTdn+3EQOCeDtA9
         Kqdk2hWzUlQb9rivd6HPWuEOdr3mPssVdZTTD+Y12qN4YjP75CGLaShpmLvHoEbVjqz6
         qEPVADeZ+qLdaGEftgC3NAcWoukb/WDUYOAQE1PkTmyN1G4yXILEVRdET+gzHL6MRXgO
         YE67k8+hu3NB9Ro4kABanx0eXYsvjgxNuiqVorgOr8l9BS/nTcCCbzKe+YGrYACjIt11
         0ckg==
X-Forwarded-Encrypted: i=1; AJvYcCWE72FJGNCd5a1JnDe97Q+bwx2a8ZGXQaYKNQyPFpMwZqPfu/TAoCElIEFoicq14Gz9Nbh+0TQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtTBb+VnLkxsq+lVfLkFW7Xoi95drlen8l98y6H0vZtwbz++V7
	h5utwLvj5A3g6fIvRIAFufddqwpE/4wXW34gp5PGRN9pM0XN+yr7
X-Gm-Gg: ASbGncu3cJvBcCldPlIOtQlRqBYzY+rYEdltOetlN7oSYoRqBwuje2JE5VmL3U0qD73
	qCj15xlY/ZPRTXhKbmK1oeHD49irayNRW0RsJw1uq3F+1B9Ei9e63PL862n6z4b1BoFCWgLwPfo
	fF4YorCXijkZUI3YP/BN0+quKRpRbYwdbxTvACnqQ8n6RBIFCiErflAJEkbpL/L96QAUEu9Q3X+
	rRh2VNAxTNLBbp/Pbbw+VceSFj/3HF7jgUIS7BfVgqTdF1ZEazGvTDKe2PnRKzbKX5ZGAWe5TiZ
	Hn0nhmq7jxND1NglBSsp6uKzPREHRB2SUUwlE5grHYAStb3n3QxwGEi0fKyg
X-Google-Smtp-Source: AGHT+IFhWik0dvo5nbC73OtnpAgOzCCxlIuY5TcJavE3QjUL4HXTbUVWDwb/kdN4looh8mC60vBqqQ==
X-Received: by 2002:a05:6871:c70a:b0:2cc:3586:294f with SMTP id 586e51a60fabf-2d526a28b26mr7572447fac.9.1745269223691;
        Mon, 21 Apr 2025 14:00:23 -0700 (PDT)
Received: from Borg-550.local ([2603:8080:1500:3d89:c191:629b:fde5:2f06])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2d52135b8b4sm2121868fac.17.2025.04.21.14.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Apr 2025 14:00:23 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 21 Apr 2025 16:00:21 -0500
From: John Groves <John@groves.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredb.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 17/19] famfs_fuse: Add famfs metadata documentation
Message-ID: <f27nf7ac2lopba4tnakkxx2zvnlmntfvk2olrxyz7yv4ywrufb@cwobadow6gxs>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-18-john@groves.net>
 <f0b218f4-7379-4fa5-93e4-a1c9dd4c411c@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0b218f4-7379-4fa5-93e4-a1c9dd4c411c@infradead.org>

On 25/04/20 08:51PM, Randy Dunlap wrote:
> 
> 

good edits... 

Caching them into a branch for the next versions

Thank you!

John

